require 'rails_helper'

RSpec.describe Api::Github::Rest do
  let(:contrib_url) { "https://api.github.com/repos/#{repo}/contributors" }

  context 'with valid repository address' do
    let(:repo) { 'ruby/ruby' }
    let(:get_response) { file_fixture('rest_response.json').read }
    # 3 contributors with the highest number of commits
    let(:contribs) { %w[rafaelfranca tenderlove dhh] }
    let(:client) { class_double('RestClient', get: get_response) }

    context 'and with OAuth token' do
      let(:oauth_token) { 'qwertyuioasdfgh' }
      let(:headers) do
        { accept: 'application/vnd.github.v3+json',
          authorization: "token #{oauth_token}" }
      end

      it 'returns at most 3 names of most active contributors' do
        rs = described_class.new(repo, oauth_token, client).contributors
        expect(rs).to eq(contribs)
      end

      it 'sends correct params to RestClient gem' do
        expect(client).to receive(:get).with(contrib_url, headers)
        described_class.new(repo, oauth_token, client).contributors
      end
    end

    context 'and with no OAuth token' do
      let(:oauth_token) { nil }
      let(:headers) { { accept: 'application/vnd.github.v3+json' } }

      it 'returns at most 3 names of most active contributors' do
        rs = described_class.new(repo, oauth_token, client).contributors
        expect(rs).to eq(contribs)
      end

      it 'sends correct params to RestClient gem' do
        expect(client).to receive(:get).with(contrib_url, headers)
        described_class.new(repo, oauth_token, client).contributors
      end
    end
  end

  context 'with invalid repository address' do
    let(:repo) { 'me' }

    it 'returns nil' do
      client = class_double('RestClient', get: nil)
      rest = described_class.new(repo, nil, client)
      expect { rest.contributors }.not_to raise_error
      expect(rest.contributors).to be_nil
    end
  end
end
