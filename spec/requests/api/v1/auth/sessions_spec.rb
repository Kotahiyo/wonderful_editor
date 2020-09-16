require 'rails_helper'

RSpec.describe "Api::V1::Auth::Sessions", type: :request do
  describe "POST /v1/auth/sign_in" do
    subject { post(api_v1_user_session_path, params: params)}
    context "登録済みのユーザー情報が確認できたとき" do
      let(:params) { attributes_for(:user, email: user.email, password: user.password) }
      let(:user) { create(:user) }
      it "ログインができる" do
        subject
        expect(response).to have_http_status(:ok)
        header = response.header
        expect(header["access-token"]).to be_present
        expect(header["client"]).to be_present
        expect(header["token-type"]).to be_present
        expect(header["uid"]).to be_present
      end
    end

    context "email 情報が確認できないとき" do
      let(:params) { attributes_for(:user, email: "test@example.com", password: user.password) }
      let(:user) { create(:user) }
      it "ログインできない" do
        subject
        res = JSON.parse(response.body)
        header = response.header
        expect(res["errors"]).to include("Invalid login credentials. Please try again.")
        expect(res["success"]).to be_falsey
        expect(response).to have_http_status(:unauthorized)
        expect(header["access-token"]).to be_blank
        expect(header["client"]).to be_blank
        expect(header["uid"]).to be_blank
      end
    end

    context "passwordが一致しない場合" do
      let(:user) { create(:user) }
      let(:params) { attributes_for(:user, email: user.email, password: "hoge") }

      it "ログインできない" do
        subject
        res = JSON.parse(response.body)
        header = response.header
        expect(res["errors"]).to include "Invalid login credentials. Please try again."
        expect(header["access-token"]).to be_blank
        expect(header["client"]).to be_blank
        expect(header["uid"]).to be_blank
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "DELETE /v1/auth/sign_out" do
    subject { delete(destroy_api_v1_user_session_path, headers: headers) }
    context "ログアウトに必要な処理を送信した場合" do
      let!(:headers) { user.create_new_auth_token }
      let(:user) { create(:user) }
      it "ログアウトする" do
        expect { subject }.to change { user.reload.tokens }.from(be_present).to(be_blank)
        expect(response).to have_http_status(:ok)
      end
    end

    context "誤った情報を渡したとき" do
      let(:user) { create(:user) }
      let!(:token) { user.create_new_auth_token }
      let!(:header) { { "access-token" => "", "token-type" => "", "client" => "", "expiry" => "", "uid" => "" }}
      it "ログアウトできない" do
        subject
        expect(response).to have_http_status(:not_found)
        res = JSON.parse(response.body)
        expect(res["errors"]).to include "User was not found or was not logged in."
      end
    end
  end
end
