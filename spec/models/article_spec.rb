require "rails_helper"

RSpec.describe Article, type: :model do
  describe "正常系" do
    context "titleとbodyが入力されている場合" do
      let(:article) { build(:article) }
      it "記事を作成できる" do
        expect(article).to be_valid
      end
    end
  end

  describe "エラーチェック" do
    context "タイトルが存在しない場合" do
      let(:article) { build(:article, title: nil) }
      it "記事が作成できない" do
        expect(article).not_to be_valid
      end
    end

    context "タイトルが51文字以上の場合" do
      let(:article) { build(:article, title: Faker::Lorem.characters(number: 51)) }
      it "記事が作成できない" do
        expect(article).not_to be_valid
      end
    end

    context "記事の本文が存在しない場合" do
      let(:article) { build(:article, body: nil) }
      it "記事が作成できない" do
        expect(article).not_to be_valid
      end
    end
  end
end
