class WebController < ApplicationController
  class InvalidFilename < RuntimeError; end
  TMP_DIR = '/tmp'.freeze

  def index
    reset_session
  end

  def show
    # Store @contributors for every session in order to cache
    # the query sent to the specified github repository.
    if session[:search_url] == url_params[:repository]
      @contributors = session[:contributors].map(&:symbolize_keys)
    else
      @contributors = search_contributors
      session[:contributors] = @contributors
      session[:search_url] = url_params[:repository]
    end

    @url = url_params[:repository]
  end

  def download
    filename = download_params
  rescue InvalidFilename
    redirect_to web_show_path
  else
    send_file filename, type: 'application/pdf'
  end

  private

  def url_params
    params.permit(:repository)
  end

  def download_params
    if params[:filename].blank? || params[:format] != 'pdf'
      raise InvalidFilename
    end

    filename = params[:filename] + '.' + params[:format]
    path = File.join(TMP_DIR, filename)
    raise InvalidFilename unless File.exist?(path)

    path
  end

  def search_contributors
    [{ name: 'me' },
     { name: 'mi' },
     { name: 'mo' }]
  end
end
