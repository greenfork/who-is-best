require 'rails_helper'

RSpec.describe 'web/index.html.erb', type: :view do
  it 'has a form' do
    render
    expect(rendered).to match(/<form/)
  end
end
