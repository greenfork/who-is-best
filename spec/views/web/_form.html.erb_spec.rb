require 'rails_helper'

RSpec.describe 'web/_form.html.erb', type: :view do
  it 'has an input field' do
    render
    expect(rendered).to match(/name="repository"/)
  end

  it 'has a submit button' do
    render
    expect(rendered).to match(/name="commit"/)
  end

  context 'with the url in params' do
    it 'displays this url' do
      url = 'http://getskeleton.com/'
      assign(:url, url)
      render
      expect(rendered).to match(url)
    end
  end
end
