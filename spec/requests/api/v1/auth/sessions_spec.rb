require 'rails_helper'

RSpec.describe "Api::V1::Auth::Sessions", type: :request do
  describe "GET /api/v1/auth/sessions" do
    it "works! (now write some real specs)" do
      get api_v1_auth_sessions_index_path
      expect(response).to have_http_status(200)
    end
  end
end
