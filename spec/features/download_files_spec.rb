require 'rails_helper'

RSpec.feature 'DownloadFiles', type: :feature do
  background do
    visit root_path
    fill_in :repository, with: 'https://github.com/jyp/boon'
    click_button 'Search'
  end

  feature 'download PDF certificates' do
    scenario 'User downloads a certificate' do
      all('#downloads a', text: /.*\.pdf/).each do |link|
        name = link.text.chomp('.pdf')
        link.click
        expect(page).to have_current_path(download_path(name))
      end
    end

    scenario 'User downloads all certificates in a zip file' do
      click_link('download.zip')
      expect(page).to have_current_path(download_all_path)
    end
  end
end
