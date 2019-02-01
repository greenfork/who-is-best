class WebController < ApplicationController
  def index
  end

  def show
    @contributors = [{ name: 'me', url: 'url' },
                     { name: 'mi', url: 'urt' },
                     { name: 'mo', url: 'uri' }]
  end
end
