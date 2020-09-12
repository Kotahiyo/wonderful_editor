require 'rails_helper'

RSpec.describe "Api::V1::Auth::Registrations", type: :request do
  describe "POST /v1/auth" do
    subject { post(api_v1_user_registration_path, params: params) }
    context "必要なカラムが送信されているとき" do
      let(:params) { attributes_for(:user) }
      it "ユーザーが新規登録される。" do
        expect { subject }.to change { User.count }.by(1)
        expect(response).to have_http_status(:ok)
        res = JSON.parse(response.body)
        expect( res["data"]["email"]).to eq( User.last.email )
      end

      it "header 情報を取得できる" do
        subject
        resheader = response.header
        expect(resheader["access-token"]).to be_present
        expect(resheader["client"]).to be_present
        expect(resheader["token-type"]).to be_present
        expect(resheader["uid"]).to be_present
      end
    end

    context "name カラムが送信されていないとき" do
      let(:params) { attributes_for(:user, name: nil)}
      it "エラーする" do
        expect { subject }.to change { User.count }.by(0)
        res = JSON.parse(response.body)
        expect(res["errors"]["full_messages"]).to include "Name can't be blank"
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "email が存在しないとき" do
      let(:params) { attributes_for(:user, email: nil) }

      it "エラーする" do
        expect { subject }.to change { User.count }.by(0)
        res = JSON.parse(response.body)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(res["errors"]["email"]).to include "can't be blank"
      end
    end

    context "password が存在しないとき" do
      let(:params) { attributes_for(:user, password: nil) }

      it "エラーする" do
        expect { subject }.to change { User.count }.by(0)
        res = JSON.parse(response.body)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(res["errors"]["password"]).to include "can't be blank"
      end
    end
  end
end
