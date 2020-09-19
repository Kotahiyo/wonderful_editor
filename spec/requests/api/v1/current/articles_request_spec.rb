require 'rails_helper'

RSpec.describe "Api::V1::Current::Articles", type: :request do
  let(:headers) { current_user.create_new_auth_token }
  let(:current_user) { create(:user) }
  describe "GET /current/articles" do
    subject { get(api_v1_current_articles_path, headers: headers) }
    context "複数の記事が存在するとき" do
      let!(:article1) { create(:article, :published, updated_at: 1.days.ago, user: current_user) }
      let!(:article2) { create(:article, :published, updated_at: 2.days.ago, user: current_user) }
      let!(:article3) { create(:article, :published, user: current_user) }
      it "記事の一覧を更新順で取得できる" do
      subject
      res = JSON.parse(response.body)
      expect(res.length).to eq 3
      expect(res[0]["user"]["id"]).to eq current_user.id
      expect(res[0]["user"]["name"]).to eq current_user.name
      expect(res[0]["user"]["email"]).to eq current_user.email
      expect(res.map {|d| d["id"]} ).to eq [article3.id, article1.id, article2.id]
      expect(response).to have_http_status(:ok)
      end
    end
  end
end
