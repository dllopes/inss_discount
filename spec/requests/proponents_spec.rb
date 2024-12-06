require 'rails_helper'

RSpec.describe 'Proponents', type: :request do
  let(:valid_attributes) { attributes_for(:proponent) }

  let(:invalid_attributes) do
    {
      name: '',
      cpf: '',
      birth_date: '',
      personal_phone: '',
      reference_phone: '',
      salary: nil,
      address_attributes: {
        street: '',
        number: '',
        neighborhood: '',
        city: '',
        state: '',
        zip_code: ''
      }
    }
  end

  describe 'GET /index' do
    it 'returns a successful response' do
      get proponents_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /new' do
    it 'returns a successful response' do
      get new_proponent_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /create' do
    let(:request_params) { {} }

    def post_request
      post proponents_path, params: request_params
    end

    context 'with valid parameters' do
      let(:request_params) { { proponent: valid_attributes } }

      it 'creates a new Proponent' do
        expect {
          post_request
        }.to change(Proponent, :count).by(1)
      end

      it 'redirects to the created proponent' do
        post_request
        expect(response).to redirect_to(proponent_path(Proponent.last))
      end
    end

    context 'with invalid parameters' do
      let(:request_params) { { proponent: invalid_attributes } }

      it 'does not create a new Proponent' do
        expect {
          post_request
        }.not_to change(Proponent, :count)
      end

      it 'returns an unprocessable entity response' do
        post_request
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'renders the new template' do
        post_request
        expect(response.body).to include('New Proponent')
      end
    end
  end

  describe 'GET /show' do
    let(:proponent) { create(:proponent) }

    it 'returns a successful response' do
      get proponent_path(proponent)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /edit' do
    let(:proponent) { create(:proponent) }

    it 'returns a successful response' do
      get edit_proponent_path(proponent)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'PATCH /update' do
    let(:proponent) { create(:proponent) }
    let(:request_params) { {} }

    def patch_request
      patch proponent_path(proponent), params: request_params
    end

    context 'with valid parameters' do
      let(:new_attributes) { attributes_for(:proponent) }
      let(:request_params) { { proponent: new_attributes } }

      it 'updates the requested proponent' do
        patch_request
        proponent.reload
        expect(proponent.name).to eq(new_attributes[:name])
        expect(proponent.salary).to eq(new_attributes[:salary])
      end

      it 'redirects to the proponent' do
        patch_request
        expect(response).to redirect_to(proponent_path(proponent))
      end
    end

    context 'with invalid parameters' do
      let(:request_params) { { proponent: invalid_attributes } }

      it 'does not update the proponent' do
        old_name = proponent.name
        patch_request
        proponent.reload
        expect(proponent.name).to eq(old_name)
      end

      it 'returns an unprocessable entity response' do
        patch_request
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'renders the edit template' do
        patch_request
        expect(response.body).to include('Editing Proponent')
      end
    end
  end

  describe 'DELETE /destroy' do
    let!(:proponent) { create(:proponent) }

    def delete_request
      delete proponent_path(proponent)
    end

    it 'destroys the requested proponent' do
      expect {
        delete_request
      }.to change(Proponent, :count).by(-1)
    end

    it 'redirects to the proponents list' do
      delete_request
      expect(response).to redirect_to(proponents_url)
    end
  end

  describe 'POST /calculate_discount' do
    let(:request_params) { { salary: 5000.0 } }

    def post_request
      post calculate_discount_proponents_path, params: request_params
    end

    it 'returns the correct INSS discount' do
      allow(Proponent).to receive(:calculate_inss_discount).and_return(600.0)
      post_request
      expect(response.content_type).to eq('application/json; charset=utf-8')
      json_response = JSON.parse(response.body)
      expect(json_response['inss_discount']).to eq(600.0)
    end
  end
end