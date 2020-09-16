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

  describe "GET /articles/:id" do
    subject { get(api_v1_article_path(article_id)) }

    context "指定した id のユーザが存在するとき" do
      let(:article_id) { article.id }
      let(:article) { create(:article) }
      it "記事の値が取得できる" do
        subject
        res = JSON.parse(response.body)
        expect(res["id"]).to eq article.id
        expect(res["title"]).to eq article.title
        expect(res["body"]).to eq article.body
        expect(res["updated_at"]).to be_present
        expect(res["user"]["id"]).to eq article.user.id
        expect(res["user"].keys).to eq ["id", "name", "email"]
        expect(response).to have_http_status(:success)
      end
    end

    context "指定した id のユーザが存在しないとき" do
      let(:article_id) { 100000 }
      it "記事の値が取得できない" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "Post /articles" do
    subject { post(api_v1_articles_path, params: params, headers: headers) }
    context "適切なパラメータが送信されたとき" do
      let(:params) do
        { article: attributes_for(:article) }
      end
      let(:headers) { current_user.create_new_auth_token }
      let(:current_user) { create(:user) }

      it "記事が作成される" do
        expect { subject }.to change { Article.where(user_id: current_user.id).count }.by(1)
        res = JSON.parse(response.body)
        expect(res["title"]).to eq params[:article][:title]
        expect(res["body"]).to eq params[:article][:body]
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "PUT /articles/:id" do
    subject { put(api_v1_article_path(article.id), params: params, headers: headers) }
    let(:params) do
      { article: attributes_for(:article) }
    end
    let(:headers) { current_user.create_new_auth_token }
    let(:current_user) { create(:user) }

    context "所持している記事のレコードを更新しようとしたとき" do
      let(:article) { create(:article, user: current_user) }
      it "任意のユーザのレコードが更新できる" do
        expect { subject }.to change { article.reload.title }.from(article.title).to(params[:article][:title]) &
                              change { article.reload.body }.from(article.body).to(params[:article][:body])
        expect(response).to have_http_status(:ok)
      end
    end

    context "所持していない記事のレコードを更新しようとしたとき" do
      let(:new_user) { create(:user) }
      let!(:article) { create(:article, user: new_user) }
      it "エラーになる" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound) &
                              change { Article.count }.by(0)
      end
    end
  end

  describe "DELETE /article/:id" do
    subject { delete(api_v1_article_path(article_id), headers: headers) }

    let(:headers) { current_user.create_new_auth_token }
    let(:current_user) { create(:user) }
    let(:article_id) { article.id}

    context "自分の所持する記事を削除しようとするとき" do
      let!(:article) { create(:article, user: current_user) }
      it "任意のユーザーの記事が削除できる" do
        expect { subject }.to change { Article.count }.by(-1)
        expect(response).to have_http_status(:no_content)
      end
    end

    context "他人の所持する記事を削除しようとするとき" do
      let!(:article) { create(:article, user: other_user) }
      let(:other_user) { create(:user) }
      it "任意のユーザーの記事が削除できない" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound) &
                              change { Article.count }.by(0)
      end
    end
  end
end
