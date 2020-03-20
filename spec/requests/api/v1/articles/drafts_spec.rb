require 'rails_helper'

RSpec.describe "Api::V1::Articles::Drafts", type: :request do
  describe "GET /api/v1/articles/drafts" do
    it "works! (now write some real specs)" do
      get api_v1_articles_drafts_index_path
      expect(response).to have_http_status(200)
    end
  end
end
