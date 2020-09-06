require 'rails_helper'

RSpec.describe "Api::V1::Articles", type: :request do
  describe "GET /articles" do
    subject { get(api_v1_articles_path) }
    let!(:article_1) { create(:article, updated_at: 1.days.ago) }
    let!(:article_2) { create(:article, updated_at: 2.days.ago) }
    let!(:article_3) { create(:article) }

    it "記事一覧が取得できる" do
      subject
      res = JSON.parse(response.body)

      expect(res.length).to eq 3
      expect(res[0].keys).to eq ["id", "title", "updated_at", "user"]
      expect(res[0]["user"].keys).to eq ["id", "name", "email"]
      expect(res.map {|d| d["id"]} ).to eq [article_3.id, article_1.id, article_2.id]
      expect(response).to have_http_status(:success)
    end
  end
end
