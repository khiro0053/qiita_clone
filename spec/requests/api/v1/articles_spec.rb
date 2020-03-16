require "rails_helper"

RSpec.describe "Api::V1::Articles", type: :request do
  describe "GET /api/v1/articles" do
    subject { get(api_v1_articles_path) }

    before do
      create_list(:article, 2, :draft)
      create_list(:article, 3, :published)
    end

    it "公開記事のみ一覧が取得できる" do
      subject
      res = JSON.parse(response.body)
      expect(res.length).to eq Article.published.count
      expect(res[0].keys).to eq ["id", "title", "body", "updated_at", "status", "user"]
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /api/v1/articles/:id" do
    subject { get(api_v1_article_path(article_id)) }

    context "指定したidの公開記事が存在する場合" do
      let(:article) { create(:article, :published) }
      let(:article_id) { article.id }
      it "指定した記事が取得できる" do
        subject
        res = JSON.parse(response.body)
        expect(res["id"]).to eq article.id
        expect(res["title"]).to eq article.title
        expect(res["body"]).to eq article.body
        expect(res["updated_at"]).to be_present
        expect(res["status"]).to eq "published"
        expect(response).to have_http_status(:ok)
      end
    end

    context "指定したidの記事が存在しない場合" do
      let(:article_id) { 99999 }
      it "記事が取得できない" do
        expect { subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end

    context "指定したidの記事が下書き状態だった場合" do
      let(:article) { create(:article, :draft) }
      let(:article_id) { article.id }
      it "記事が取得できない" do
        expect { subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe "POST /api/v1/articles" do
    subject { post(api_v1_articles_path, params: params, headers: headers) }

    context "公開状態の記事を作成した場合" do
      let(:params) { { article: attributes_for(:article, :published) } }
      let(:current_user) { create(:user) }
      let(:headers) { current_user.create_new_auth_token }

      it "current_userに紐付いた公開記事が作成できる" do
        expect { subject }.to change { current_user.articles.published.count }.by(1)
        expect(response).to have_http_status(:ok)
      end
    end

    context "下書きの記事を作成した場合" do
      let(:params) { { article: attributes_for(:article, :draft) } }
      let(:current_user) { create(:user) }
      let(:headers) { current_user.create_new_auth_token }

      it "current_userに紐付いた下書き記事が作成できる" do
        expect { subject }.to change { current_user.articles.draft.count }.by(1)
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "PATCH /api/v1/articles/:id" do
    subject { patch(api_v1_article_path(article_id), params: params, headers: headers) }

    let(:params) { { article: attributes_for(:article, :published) } }
    let(:current_user) { create(:user) }
    let(:article) { create(:article, user: current_user, status: "draft") }
    let(:headers) { current_user.create_new_auth_token }

    context "自身が作成した記事を更新する場合" do
      let(:article_id) { article.id }
      it "記事の内容を更新できる" do
        expect { subject }.to change { Article.find(article_id).title }.from(article.title).to(params[:article][:title]) &
                              change { Article.find(article_id).body }.from(article.body).to(params[:article][:body]) &
                              change { Article.find(article_id).status }.from(article.status).to(params[:article][:status]) &
                              not_change { Article.find(article_id).created_at }
        expect(response).to have_http_status(:ok)
      end
    end

    context "更新しようとしたidの記事が既に存在しなかった場合" do
      # let(:article) { create(:article, user: current_user)  }が呼ばれないためcurrent_user.articlesが空になる
      let(:article_id) { 99999 }
      it "更新できない" do
        expect { subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe "DELETE /api/v1/articles/:id" do
    subject { delete(api_v1_article_path(article_id), params: params, headers: headers) }

    let(:params) { { article: attributes_for(:article) } }
    let(:current_user) { create(:user) }
    let(:headers) { current_user.create_new_auth_token }
    let!(:article) { create(:article, user: current_user) }

    context "自身が作成した記事を削除する場合" do
      let(:article_id) { article.id }
      it "記事を削除できる" do
        expect { subject }.to change { current_user.articles.count }.by(-1)
        expect(response).to have_http_status(:ok)
      end
    end

    context "削除する記事のidが存在しない場合" do
      let(:article_id) { 99999 }
      it "削除できない" do
        expect { subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
