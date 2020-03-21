require "rails_helper"

RSpec.describe "Api::V1::Current::Articles", type: :request do
  describe "GET /api/v1/current/articles" do
    subject { get(api_v1_current_articles_path, headers: headers) }

    let(:current_user) { create(:user) }
    let!(:article1) { create(:article, :draft, user: current_user) }
    let!(:article2) { create(:article, :published, user: current_user) }
    let!(:article3) { create(:article, :published) }
    let!(:article4) { create(:article, :draft) }

    context "ログイン時の場合" do
      let(:headers) { current_user.create_new_auth_token }
      it "自分の書いた公開記事一覧が取得できる" do
        subject
        res = JSON.parse(response.body)
        expect(res.length).to eq current_user.articles.published.count
        expect(res[0].keys).to eq ["id", "title", "body", "updated_at", "status", "user"]
        expect(response).to have_http_status(:ok)
      end
    end

    context "ログインしていない場合" do
      it "自分の書いた公開記事一覧が取得できない" do
        subject
        res = JSON.parse(response.body)
        expect(res["errors"]).to include "You need to sign in or sign up before continuing."
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
