class WebController < ApplicationController
  class InvalidName < RuntimeError; end

  def index
    reset_session
  end

  def show
    # Store @contributors for every session in order to cache
    # the query sent to the specified github repository.
    if session[:search_url] == url_params[:repository]
      @contributors = session[:contributors]
    else
      @contributors = search_contributors
      session[:contributors] = @contributors
      session[:search_url] = url_params[:repository]
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
  else
    send_data pdf_string, filename: filename, type: :pdf
  end

  def download_all
    zip_archive = 'some zip archive'
    send_data zip_archive, filename: 'download.zip', type: :zip
  end

  private

  def url_params
    params.permit(:repository)
  end

  def download_params
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

  def search_contributors
    %w[me_name русске_имя äåãøáæ]
  end
end
