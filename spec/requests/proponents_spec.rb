# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Proponents', type: :request do
  let(:user) { create(:user) }
  let(:valid_attributes) { attributes_for(:proponent) }

  let(:proponent_one) { create(:proponent, salary: 2000.0) }
  let(:proponent_two) { create(:proponent, salary: 3500.0) }
  let(:report) do
    create(:proponent_salary_report,
           salary_range: 'De R$ 2.089,61 até R$ 3.134,40',
           proponent_ids: [proponent_one.id],
           proponent_count: 1)
  end

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

  before do
    proponent_one
    proponent_two
    report
    sign_in user
  end

  describe 'GET /index' do
    context 'without filters' do
      it 'returns all proponents' do
        get proponents_path

        expect(response).to have_http_status(:ok)
      end
    end

    it 'returns only the proponents within the report' do
      get proponents_path(report_id: report.id)

      expect(response).to have_http_status(:ok)

      response_body = Nokogiri::HTML(response.body)
      displayed_proponents = response_body.css('table tbody tr').map do |row|
        row.css('td').first.text.strip
      end

      expected_proponents = Proponent.where(id: report.proponent_ids).pluck(:name)
      expect(displayed_proponents).to match_array(expected_proponents)
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
        expect do
          post_request
        end.to change(Proponent, :count).by(1)
      end

      it 'redirects to the created proponent' do
        post_request
        expect(response).to redirect_to(proponent_path(Proponent.last))
      end
    end

    context 'with invalid parameters' do
      let(:request_params) { { proponent: invalid_attributes } }

      it 'does not create a new Proponent' do
        expect do
          post_request
        end.not_to change(Proponent, :count)
      end

      it 'returns an unprocessable entity response' do
        post_request
        expect(response).to have_http_status(:unprocessable_entity)
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

  describe 'DELETE /destroy' do
    let!(:proponent) { create(:proponent) }

    def delete_request
      delete proponent_path(proponent)
    end

    it 'destroys the requested proponent' do
      expect do
        delete_request
      end.to change(Proponent, :count).by(-1)
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
      allow(SalaryCalculator).to receive(:new).with(5000.0).and_return(instance_double(SalaryCalculator,
                                                                                       calculate_inss_discount: 600.0))
      post_request
      expect(response.content_type).to eq('application/json; charset=utf-8')
      json_response = response.parsed_body
      expect(json_response['inss_discount']).to eq(600.0)
    end
  end
end
