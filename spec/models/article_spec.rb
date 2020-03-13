require "rails_helper"

RSpec.describe Article, type: :model do
  describe "正常系" do
    context "titleとbodyが入力されていてstatusは指定していない場合" do
      let(:article) { build(:article) }
      it "下書き状態の記事を作成できる" do
        expect(article).to be_valid
        expect(article.status).to eq "draft"
      end
    end

    context "titleとbodyが入力されていてstatusは下書きの場合" do
      let(:article) { build(:article, :draft) }
      it "下書き状態の記事を作成できる" do
        expect(article).to be_valid
        expect(article.status).to eq "draft"
      end
    end

    context "titleとbodyが入力されていてstatusは公開状態の場合" do
      let(:article) { build(:article, :published) }
      it "公開状態の記事を作成できる" do
        expect(article).to be_valid
        expect(article.status).to eq "published"
      end
    end
  end

  describe "エラーチェック" do
    context "タイトルが存在しない場合" do
      let(:article) { build(:article, title: nil) }
      it "記事が作成できない" do
        expect(article).not_to be_valid
        expect(article.errors.messages[:title]).to include "can't be blank"
      end
    end

    context "タイトルが51文字以上の場合" do
      let(:article) { build(:article, title: Faker::Lorem.characters(number: 51)) }
      it "記事が作成できない" do
        expect(article).not_to be_valid
        expect(article.errors.messages[:title]).to include "is too long (maximum is 50 characters)"
      end
    end

    context "記事の本文が存在しない場合" do
      let(:article) { build(:article, body: nil) }
      it "記事が作成できない" do
        expect(article).not_to be_valid
        expect(article.errors.messages[:body]).to include "can't be blank"
      end
    end
  end

  describe "記事のstatusに関するチェック" do
    before do
      create_list(:article, 2, :draft)
      create_list(:article, 3, :published)
    end

    context "下書きの記事だけを取得する場合" do
      it "下書きの記事のみを取得できる" do
        expect(Article.draft.count).to eq 2
        expect(Article.draft[0].status).to eq "draft"
      end
    end

    context "公開の記事だけを取得する場合" do
      it "公開の記事のみを取得できる" do
        expect(Article.published.count).to eq 3
        expect(Article.published[0].status).to eq "published"
      end
    end
  end
end
