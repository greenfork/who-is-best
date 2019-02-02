class WebController < ApplicationController
  class InvalidFilename < RuntimeError; end
  TMP_DIR = '/tmp'.freeze

  def index
  end

  def show
    contribs_stub
    @url = url_params[:repository]
    @contributors.each_with_index do |hash, index|
      Pdf::Certificate.generate(hash[:name], index + 1,
                                filename: File.join(TMP_DIR, hash[:filename]))
    end
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

  def contribs_stub
    @contributors = [{ name: 'me', filename: 'me.pdf' },
                     { name: 'mi', filename: 'mi.pdf' },
                     { name: 'mo', filename: 'mo.pdf' }]
  end
end
