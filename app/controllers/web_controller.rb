class WebController < ApplicationController
  def index
  end

  def show
    contribs_stub
    @url = url_params[:repository]
  end

  private

  def url_params
    params.permit(:repository)
  end

  def contribs_stub
    @contributors = [{ name: 'me', filename: 'me.pdf' },
                     { name: 'mi', filename: 'mi.pdf' },
                     { name: 'mo', filename: 'mo.pdf' }]
  end
end
