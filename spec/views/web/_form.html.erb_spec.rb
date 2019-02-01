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
end
