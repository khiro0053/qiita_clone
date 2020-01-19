require "rails_helper"

RSpec.describe "Api::V1::Auth::Sessions", type: :request do
  describe "POST /api/v1/auth/sign_in" do
    subject { post(api_v1_user_session_path, params: params) }

    context "登録済みの正しいユーザー情報を送った場合" do
      let(:user) { create(:user) }
      let(:params) { attributes_for(:user, email: user.email, password: user.password) }

      it "ログインできる" do
        subject
        header = response.header
        expect(response).to have_http_status(:ok)
        expect(header["access-token"]).to be_present
        expect(header["client"]).to be_present
      end
    end

    context "emailが一致しない場合" do
      let(:user) { create(:user) }
      let(:params) { attributes_for(:user, password: user.password) }

      it "ログインできない" do
        subject
        res = JSON.parse(response.body)
        header = response.header
        expect(response).to have_http_status(:unauthorized)
        expect(res["errors"]).to include "Invalid login credentials. Please try again."
        expect(header["access-token"]).to be_blank
        expect(header["client"]).to be_blank
      end
    end

    context "passwordが一致しない場合" do
      let(:user) { create(:user) }
      let(:params) { attributes_for(:user, email: user.email) }

      it "ログインできない" do
        subject
        res = JSON.parse(response.body)
        header = response.header
        expect(response).to have_http_status(:unauthorized)
        expect(res["errors"]).to include "Invalid login credentials. Please try again."
        expect(header["access-token"]).to be_blank
        expect(header["client"]).to be_blank
      end
    end
  end

  describe "DELETE /api/v1/auth/sign_out" do
    subject { delete(destroy_api_v1_user_session_path, headers: headers) }

    context "ログアウトするための正しいユーザー情報を送った場合" do
      let(:user) { create(:user) }
      let!(:headers) { user.create_new_auth_token }

      it "ログアウトできる" do
        expect { subject }.to change { user.reload.tokens.count }.from(1).to(0)
        expect(response).to have_http_status(:ok)
      end
    end

    context "誤った情報を送った場合" do
      let(:user) { create(:user) }
      let!(:token) { user.create_new_auth_token }
      let!(:headers) { { "access-token" => "", "token-type" => "", "client" => "", "expiry" => "", "uid" => "" } }

      it "ログアウトできない" do
        subject
        expect(response).to have_http_status(:not_found)
        res = JSON.parse(response.body)
        expect(res["errors"]).to include "User was not found or was not logged in."
      end
    end
  end
end
