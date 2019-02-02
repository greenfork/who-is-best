require 'rails_helper'

RSpec.describe Api::Github::Rest do
  let(:contrib_url) { "https://api.github.com/repos/#{repo}/contributors" }

  context 'with valid repository address' do
    let(:repo) { 'ruby/ruby' }
    let(:get_response) { file_fixture('rest_response.json').read }
    let(:contribs) { %w[rafaelfranca tenderlove dhh] }

    context 'and with OAuth token' do
      let(:oauth_token) { 'qwertyuioasdfgh' }
      let(:headers) do
        { accept: 'application/vnd.github.v3+json',
          authorization: "token #{oauth_token}" }
      end

      it 'returns at most 3 names of most active contributors' do
        client = class_double('RestClient', get: get_response)
        rs = described_class.new(repo, oauth_token, client).contributors(3)
        expect(rs).to eq(contribs)
      end

      it 'sends correct params to RestClient gem' do
        client = class_double('RestClient', get: '[{"login": "me"}]')
        expect(client).to receive(:get).with(contrib_url, headers)
        described_class.new(repo, oauth_token, client).contributors(3)
      end
    end

    context 'and with no OAuth token' do
      let(:oauth_token) { nil }
      let(:headers) { { accept: 'application/vnd.github.v3+json' } }

      it 'returns at most 3 names of most active contributors' do
        client = class_double('RestClient', get: get_response)
        rs = described_class.new(repo, oauth_token, client).contributors(3)
        expect(rs).to eq(contribs)
      end

      it 'sends correct params to RestClient gem' do
        client = class_double('RestClient', get: '[{"login": "me"}]')
        expect(client).to receive(:get).with(contrib_url, headers)
        described_class.new(repo, oauth_token, client).contributors(3)
      end
    end
  end

  context 'with invalid repository address' do
    let(:repo) { 'me' }

    it 'returns nil' do
      client = class_double('RestClient', get: nil)
      rest = described_class.new(repo, nil, client)
      expect { rest.contributors(3) }.not_to raise_error
      expect(rest.contributors(3)).to be_nil
    end
  end
end
