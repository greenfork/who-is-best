require 'rails_helper'

RSpec.feature 'EnterSearchQueries', type: :feature do
  feature 'enter values into field and click on the button to search' do
    scenario 'User enters correct github repository' do
      visit root_path
      fill_in :repository, with: 'https://github.com/jyp/boon'
      click_button 'Search'
      search_succeeded
    end

    scenario 'User enters repositories several times' do
      visit root_path
      fill_in :repository, with: 'https://github.com/jyp/boon'
      click_button 'Search'
      search_succeeded
      fill_in :repository, with: 'https://github.com/rails/rails'
      click_button 'Search'
      search_succeeded
      fill_in :repository, with: 'https://github.com/ruby/ruby'
      click_button 'Search'
      search_succeeded
    end

    scenario 'User enters incorrect github repository' do
      visit root_path
      fill_in :repository, with: 'https://rubyonrails.org'
      click_button 'Search'
      expect(page).to have_content('Sorry')
      expect(page).not_to have_current_path(root_path)
      expect(page).not_to have_link('download.zip')
    end
  end
end

def search_succeeded
  expect(page).to have_content('Done!')
  expect(page).not_to have_current_path(root_path)
  expect(page).to have_link('download.zip')
  page.assert_selector('#downloads a', count: 4)
end
