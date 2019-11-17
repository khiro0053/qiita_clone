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
        expect(user.errors.messages[:name]).to include "can't be blank"
      end
    end

    context "名前が1文字の場合" do
      let(:user) { build(:user, name: "x") }
      it "ユーザー登録できない" do
        expect(user).not_to be_valid
        expect(user.errors.messages[:name]).to include "is too short (minimum is 2 characters)"
      end
    end

    context "名前が51文字以上の場合" do
      let(:user) { build(:user, name: "x" * 51) }
      it "ユーザー登録できない" do
        expect(user).not_to be_valid
        expect(user.errors.messages[:name]).to include "is too long (maximum is 50 characters)"
      end
    end
  end

  describe "メールアドレスのエラーチェック" do
    context "メールアドレスが入力されていない場合" do
      let(:user) { build(:user, email: nil) }
      it "ユーザー登録できない" do
        expect(user).not_to be_valid
        expect(user.errors.messages[:email]).to include "can't be blank"
      end
    end

    context "既に同じメールアドレスが登録されている場合" do
      before { create(:user, email: "aaa@bbb.ccc") }

      let(:user) { build(:user, email: "aaa@bbb.ccc") }
      it "ユーザー登録できない" do
        expect(user).not_to be_valid
        expect(user.errors.messages[:email]).to include "has already been taken"
      end
    end
  end

  describe "パスワードのエラーチェック" do
    context "パスワードが入力されていない場合" do
      let(:user) { build(:user, password: nil) }
      it "ユーザー登録できない" do
        expect(user).not_to be_valid
        expect(user.errors.messages[:password]).to include "can't be blank"
      end
    end

    context "パスワードの文字数が7文字以下の場合" do
      let(:user) { build(:user, password: "Abcdef1") }
      it "ユーザー登録できない" do
        expect(user).not_to be_valid
        expect(user.errors.messages[:password]).to include "is too short (minimum is 8 characters)"
      end
    end

    context "パスワードの文字数が33文字以上の場合" do
      let(:user) { build(:user, password: Faker::Internet.password(min_length: 33, mix_case: true, special_characters: true)) }
      it "ユーザー登録できない" do
        expect(user).not_to be_valid
        expect(user.errors.messages[:password]).to include "is too long (maximum is 32 characters)"
      end
    end

    context "パスワードに数字が含まれていない場合" do
      let(:user) { build(:user, password: "abcdEFGH") }
      it "ユーザー登録ができない" do
        expect(user).not_to be_valid
        expect(user.errors.messages[:password]).to include "is invalid"
      end
    end

    context "パスワードに小文字の半角英字が含まれていない場合" do
      let(:user) { build(:user, password: "ABCD1234") }
      it "ユーザー登録ができない" do
        expect(user).not_to be_valid
        expect(user.errors.messages[:password]).to include "is invalid"
      end
    end

    context "パスワードに大文字の半角英字が含まれていない場合" do
      let(:user) { build(:user, password: "abcd1234") }
      it "ユーザー登録ができない" do
        expect(user).not_to be_valid
        expect(user.errors.messages[:password]).to include "is invalid"
      end
    end

    context "パスワードが全角の文字が含まれている場合" do
      let(:user) { build(:user, password: "ｚEｎｋAｋ1") }
      it "ユーザー登録ができない" do
        expect(user).not_to be_valid
        expect(user.errors.messages[:password]).to include "is invalid"
      end
    end
  end
end
