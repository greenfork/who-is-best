class WebController < ApplicationController
  def index
  end

  def show
    @url = 'https://github.com'
    contribs_stub
  end

  private

  def contribs_stub
    @contributors = [{ name: 'me', filename: 'me.pdf' },
                     { name: 'mi', filename: 'mi.pdf' },
                     { name: 'mo', filename: 'mo.pdf' }]
  end
end
