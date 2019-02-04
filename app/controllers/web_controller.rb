require 'zip'

class WebController < ApplicationController
  class InvalidName < RuntimeError; end
  class SessionMissing < RuntimeError; end
  class InvalidRepository < RuntimeError; end
  class InvalidOAuthToken < RuntimeError; end

  def index
    reset_session
  end

  def show
    repo = url_params[:repository]

    # Store @contributors for every session in order to cache
    # the query sent to the specified github repository.
    if session[:search_url] == repo && !repo.blank?
      @contributors = session[:contributors]
    else
      begin
        # Send a request to the external API.
        @contributors = search_contributors(repo, ENV['GITHUB_OAUTH_TOKEN'])
      rescue InvalidRepository
        @contributors = []
      rescue InvalidOAuthToken
        logger.warn "\nGITHUB_OAUTH_TOKEN environment variable can not be" \
                    " used for authentication to Github API.\nPlease, fix it" \
                    " or request a new one.\n"
        @contributors = search_contributors(repo)
      else
        session[:contributors] = @contributors
        session[:search_url] = repo
      end
    end

    @url = url_params[:repository]
  end

  # Receives a name and a number, and serves an appropriate certificate.
  def download
    name, number = download_params
    filename = name + '.pdf'
    pdf_string = Pdf::Certificate.generate(name, number, as_file: false)
  rescue InvalidName
    redirect_to root_path
  rescue SessionMissing
    redirect_to root_path
  else
    send_data pdf_string, filename: filename, type: :pdf
  end

  def download_all
    redirect_to(root_path) && return if session[:contributors].blank?

    zip_archive = generate_zipped_certificates(session[:contributors])
    send_data zip_archive, filename: 'download.zip', type: :zip
  end

  private

  def url_params
    params.permit(:repository)
  end

  def download_params
    raise SessionMissing if session[:contributors].blank?

    found = false
    name_and_number = session[:contributors].each_with_index do |name, index|
      if name == params[:name]
        found = true
        return [name, index + 1]
      end
    end

    raise InvalidName unless found

    name_and_number
  end

  def search_contributors(url, oauth_token = nil)
    ## stub for development
    # contributors = %w[me_name русске_имя äåãøáæ]
    # session[:contributors] = %w[me_name русске_имя äåãøáæ]
    # return contributors

    uri = URI(url)
  rescue ArgumentError, URI::InvalidURIError
    raise InvalidRepository
  else
    if uri.host != 'github.com' || uri.path !~ %r{^/\w+/\w+/?$}
      raise InvalidRepository
    end

    begin
      Api::Github::Rest.new(uri.path, oauth_token).contributors(3)
    rescue Api::Github::Rest::InvalidRepository
      raise InvalidRepository
    rescue Api::Github::Rest::InvalidOAuthToken
      raise InvalidOAuthToken
    end
  end

  def generate_zipped_certificates(names)
    zip_buffer = Zip::OutputStream.write_buffer do |buff|
      names.each_with_index do |name, index|
        buff.put_next_entry name + '.pdf'
        buff << Pdf::Certificate.generate(name, index + 1, as_file: false)
      end
    end
    zip_buffer.rewind
    zip_buffer.read
  end
end
