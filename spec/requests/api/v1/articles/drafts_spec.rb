require "rails_helper"

RSpec.describe "Api::V1::Articles::Drafts", type: :request do
  describe "GET /api/v1/articles/drafts" do
    subject { get(api_v1_articles_drafts_path, headers: headers) }

    let(:current_user) { create(:user) }
    let!(:article1) { create(:article, :draft, user: current_user) }
    let!(:article2) { create(:article, :published, user: current_user) }
    let!(:article3) { create(:article, :draft) }
    let!(:article4) { create(:article, :draft) }

    context "ログイン時の場合" do
      let(:headers) { current_user.create_new_auth_token }
      it "自分が書いた下書き記事一覧が取得できる" do
        subject
        res = JSON.parse(response.body)
        expect(res.length).to eq current_user.articles.draft.count
        expect(res[0].keys).to eq ["id", "title", "updated_at", "user"]
        expect(res[0]["user"].keys).to eq ["id", "name", "email"]
        expect(response).to have_http_status(:ok)
      end
    end

    context "ログインしていない場合" do
      it "自分が書いた下書き記事一覧が取得できない" do
        subject
        res = JSON.parse(response.body)
        expect(res["errors"]).to include "You need to sign in or sign up before continuing."
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "GET /api/v1/articles/drafts/:id" do
    subject { get(api_v1_articles_draft_path(article_id), headers: headers) }

    let(:current_user) { create(:user) }

    context "ログイン状態で指定した下書き記事が存在する場合" do
      let(:headers) { current_user.create_new_auth_token }
      let(:article) { create(:article, :draft, user: current_user) }
      let(:article_id) { article.id }
      it "自分が書いた下書き記事を取得できる" do
        subject
        res = JSON.parse(response.body)
        expect(res["id"]).to eq article.id
        expect(res["title"]).to eq article.title
        expect(res["body"]).to eq article.body
        expect(res["updated_at"]).to be_present
        expect(res["status"]).to eq "draft"
        expect(response).to have_http_status(:ok)
      end
    end

    context "ログイン状態で指定した下書き記事が存在しない場合" do
      let(:headers) { current_user.create_new_auth_token }
      let(:article) { create(:article, :draft, user: current_user) }
      let(:article_id) { 99999 }
      it "自分が書いた下書き記事を取得できない" do
        expect { subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end

    context "ログインせず指定した下書き記事が存在する場合" do
      let(:article) { create(:article, :draft, user: current_user) }
      let(:article_id) { article.id }
      it "自分が書いた下書き記事を取得できない" do
        subject
        res = JSON.parse(response.body)
        expect(res["errors"]).to include "You need to sign in or sign up before continuing."
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
