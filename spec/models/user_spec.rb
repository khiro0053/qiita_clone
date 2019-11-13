require "rails_helper"

RSpec.describe User, type: :model do
  describe "正常系" do
    context "名前、メールアドレス、パスワードが入力されている場合" do
      let(:user) { build(:user) }
      it "ユーザー登録できる" do
        expect(user).to be_valid
      end
    end
  end

  describe "名前についてのエラーチェック" do
    context "名前が未入力の場合" do
      let(:user) { build(:user, name: nil) }
      it "ユーザー登録できない" do
        expect(user).not_to be_valid
      end
    end

    context "名前が1文字の場合" do
      let(:user) { build(:user, name: "x") }
      it "ユーザー登録できない" do
        expect(user).not_to be_valid
      end
    end

    context "名前が51文字以上の場合" do
      let(:user) { build(:user, name: "x" * 51) }
      it "ユーザー登録できない" do
        expect(user).not_to be_valid
      end
    end
  end

  describe "メールアドレスのエラーチェック" do
    context "メールアドレスが入力されていない場合" do
      let(:user) { build(:user, email: nil) }
      it "ユーザー登録できない" do
        expect(user).not_to be_valid
      end
    end

    context "既に同じメールアドレスが登録されている場合" do
      before do
        user1 = create(:user, email: "aaa@bbb.ccc")
      end

      let(:user2) { build(:user, email: "aaa@bbb.ccc") }
      it "ユーザー登録できない" do
        expect(user2).not_to be_valid
      end
    end

    context "メールアドレスのフォーマットが守られていない場合" do
      let(:user) { build(:user, email: "$#&%@invalid.com") }
      it "ユーザー登録できない" do
        expect(user).not_to be_valid
      end
    end
  end
end
