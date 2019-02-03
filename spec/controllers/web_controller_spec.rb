require 'rails_helper'

RSpec.describe WebController, type: :controller do

  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'resets session' do
      get :index, session: { dumb_value: true }
      expect(session[:dumb_value]).to be_nil
    end
  end

  describe 'GET #show' do
    let(:repository) { 'https://github.com/jyp/boon' }
    let(:contributors) { %w[name русске_имя äåãøáæ] }
    let(:valid_params) { { repository: repository } }
    let(:invalid_params_array) do
      [
        {},
        { repository: '' },
        { repository: 'https://github.com/jyp/boon/repo' },
        { repository: 'https://meme.me/jyp/boon' }
      ]
    end
    let(:cached_session) { { contributors: contributors,
                             search_url: repository } }

    before(:example) do
      allow_any_instance_of(Api::Github::Rest).to(
        receive(:contributors) { contributors }
      )
    end

    it 'returns http success' do
      get :show
      expect(response).to have_http_status(:success)
    end

    it 'assigns values for view' do
      get :show, params: valid_params
      expect(assigns(:contributors)).to eq(contributors)
      expect(assigns(:url)).to eq(repository)
    end

    it 'caches results in the session' do
      get :show, params: valid_params
      expect(session.to_h.symbolize_keys).to eq(cached_session)
    end

    context 'with same search query repeated' do
      it 'retrieves results from the session' do
        get :show, params: valid_params
        expect(subject).not_to receive(:search_contributors)
        get :show, params: valid_params
      end
    end

    context 'with invalid parameters' do
      it 'does not assign values for view' do
        invalid_params_array do |invalid_params|
          get :show, params: invalid_params
          expect(assigns(:contributors)).to eq([])
          expect(assigns(:url)).to be_nil
        end
      end
    end
  end

  describe 'GET #download' do
    let(:repository) { 'https://github.com/jyp/boon' }
    let(:contributors) { %w[name русске_имя äåãøáæ] }
    let(:one_name) { contributors[0] }
    let(:cached_session) { { contributors: contributors,
                             search_url: repository } }
    let(:valid_params) { { name: one_name } }
    let(:invalid_params) { { name: 'hello me am invalid' } }
    let(:invalid_session) { {} }

    context 'with valid parameters' do
      let(:content_type) { 'application/pdf' }
      let(:content_disposition) { "attachment; filename=\"#{one_name}.pdf\""}

      it 'serves the requested file' do
        get :download, params: valid_params, session: cached_session
        expect(response.content_type).to eq(content_type)
        expect(response.header['Content-Disposition']). to eq(content_disposition)
      end
    end

    context 'with invalid parameters' do
      it 'redirects to root with wrong params' do
        get :download, params: invalid_params, session: cached_session
        expect(response).to redirect_to(root_path)
      end

      it 'redirects to root with wrong session' do
        get :download, params: valid_params, session: invalid_session
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'GET #download_all' do
    let(:repository) { 'https://github.com/jyp/boon' }
    let(:contributors) { %w[name русске_имя äåãøáæ] }
    let(:cached_session) { { contributors: contributors,
                             search_url: repository } }
    let(:invalid_session) { {} }

    context 'with valid parameters' do
      let(:content_type) { 'application/zip' }
      let(:content_disposition) { 'attachment; filename="download.zip"' }

      it 'serves the requested file' do
        get :download_all, session: cached_session
        expect(response.content_type).to eq(content_type)
        expect(response.header['Content-Disposition']). to eq(content_disposition)
      end
    end

    context 'with invalid parameters' do
      it 'redirects to root with wrong session' do
        get :download_all, session: invalid_session
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
