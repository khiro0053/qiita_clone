require "rails_helper"

RSpec.describe "Requests::Api::V1::Registrations", type: :request do
  describe "POST /api/v1/auth" do
    subject { post(api_v1_user_registration_path, params: params) }

    context "規約に沿った名前、メールアドレス、パスワードを送った場合" do
      let(:params) { attributes_for(:user) }
      it "ユーザー登録できる" do
        expect { subject }.to change { User.count }.by(1)
        expect(response).to have_http_status(:ok)
        res = JSON.parse(response.body)["data"]
        header = response.header
        expect(res["name"]).to eq params[:name]
        expect(res["email"]).to eq params[:email]
        expect(res["password"]).to eq params[:password]
        expect(header["access-token"]).to be_present
        expect(header["client"]).to be_present
        expect(header["expiry"]).to be_present
        expect(header["uid"]).to be_present
        expect(header["token-type"]).to be_present
      end
    end

    context "名前が空白だった場合" do
      let(:params) { attributes_for(:user, name: nil) }
      it "ユーザー登録できない" do
        expect { subject }.to change { User.count }.by(0)
        expect(response).to have_http_status(:unprocessable_entity)
        res = JSON.parse(response.body)["errors"]
        expect(res["name"]).to include "can't be blank"
      end
    end

    context "emailが空白だった場合" do
      let(:params) { attributes_for(:user, email: nil) }
      it "ユーザー登録できない" do
        expect { subject }.to change { User.count }.by(0)
        expect(response).to have_http_status(:unprocessable_entity)
        res = JSON.parse(response.body)["errors"]
        expect(res["email"]).to include "can't be blank"
      end
    end

    context "同じemailが既に登録されていた場合" do
      before { create(:user, email: email) }

      let(:email) { Faker::Internet.email }
      let(:params) { attributes_for(:user, email: email) }
      it "ユーザー登録できない" do
        expect { subject }.to change { User.count }.by(0)
        expect(response).to have_http_status(:unprocessable_entity)
        res = JSON.parse(response.body)["errors"]
        expect(res["email"]).to include "has already been taken"
      end
    end

    context "passwordが空白だった場合" do
      let(:params) { attributes_for(:user, password: nil) }
      it "ユーザー登録できない" do
        expect { subject }.to change { User.count }.by(0)
        expect(response).to have_http_status(:unprocessable_entity)
        res = JSON.parse(response.body)["errors"]
        expect(res["password"]).to include "can't be blank"
      end
    end
  end
end
