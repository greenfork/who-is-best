require 'rails_helper'

RSpec.feature 'HomePageVisits', type: :feature do
  scenario 'User successfully visit home page' do
    visit root_path
    expect(page).to have_content('Who is bestest?')
  end
end
