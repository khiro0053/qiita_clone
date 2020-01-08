require 'rails_helper'

RSpec.describe "Api::V1::Auth::Registrations", type: :request do
  describe "GET /api/v1/auth/registrations" do
    it "works! (now write some real specs)" do
      get api_v1_auth_registrations_path
      expect(response).to have_http_status(200)
    end
  end
end
