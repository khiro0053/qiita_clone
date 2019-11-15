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
  end

  describe "パスワードのエラーチェック" do
    context "パスワードが入力されていない場合" do
      let(:user) { build(:user, password: nil) }
      it "ユーザー登録できない" do
        expect(user).not_to be_valid
      end
    end

    context "パスワードの文字数が7文字以下の場合" do
      let(:user) { build(:user, password: Random.new.rand(0..9).to_s + Faker::Internet.password(min_length: 2, max_length: 6, mix_case: true, special_characters: true)) }
      it "ユーザー登録できない" do
        expect(user).not_to be_valid
      end
    end

    context "パスワードの文字数が33文字以上の場合" do
      let(:user) { build(:user, password: Faker::Internet.password(min_length: 33, mix_case: true, special_characters: true)) }
      it "ユーザー登録できない" do
        expect(user).not_to be_valid
      end
    end

    context "パスワードに数字が含まれていない場合" do
      let(:user) { build(:user, password: (("a".."z").to_a .sample(4) + ("A".."Z").to_a .sample(4)).shuffle.join) }
      it "ユーザー登録ができない" do
        expect(user).not_to be_valid
      end
    end

    context "パスワードに小文字の半角英字が含まれていない場合" do
      let(:user) { build(:user, password: ((0..9).to_a .sample(4) + ("A".."Z").to_a .sample(4)).shuffle.join) }
      it "ユーザー登録ができない" do
        expect(user).not_to be_valid
      end
    end

    context "パスワードに大文字の半角英字が含まれていない場合" do
      let(:user) { build(:user, password: ((0..9).to_a .sample(4) + ("a".."z").to_a .sample(4)).shuffle.join) }
      it "ユーザー登録ができない" do
        expect(user).not_to be_valid
      end
    end
  end
end
