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
end
