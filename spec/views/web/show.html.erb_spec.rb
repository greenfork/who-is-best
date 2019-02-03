require 'rails_helper'

RSpec.describe 'web/show.html.erb', type: :view do
  it 'has a form' do
    render
    expect(rendered).to match(/<form/)
  end

  context 'with the contributors present' do
    let(:names) { %w[me mi mo] }

    before(:example) do
      assign(:contributors, names)
    end

    it 'has a name and a link for every contributor' do
      render
      names.each do |name|
        expect(rendered).to match(name)
      end
    end

    it 'has a link for a full download' do
      render
      expect(rendered).to match(/download.zip/)
    end
  end

  context 'with the contributors absent' do
    it 'has no links' do
      render
      expect(rendered).not_to match(/<a/)
    end

    it 'has an error message' do
      render
      expect(rendered).to match(/sorry/i)
    end
  end
end
