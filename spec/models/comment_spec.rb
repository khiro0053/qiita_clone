require "rails_helper"

RSpec.describe Comment, type: :model do
  describe "正常系"do
    context "コメント文がある場合" do
      let(:comment) {build(:comment)}
      it "コメント投稿できる" do
      expect(comment).to be_valid
      end
    end
  end
  describe "エラーチェック" do
    context "コメント文がない場合" do
      let(:comment) {build(:comment, body: nil)}
      it "コメント投稿できない" do
        expect(comment).not_to be_valid
      end
    end
  end
end
