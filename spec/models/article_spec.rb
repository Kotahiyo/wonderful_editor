require 'rails_helper'

RSpec.describe Article, type: :model do
  context "title, body が指定されているとき" do
    let(:article) { build(:article) }
    it "下書き状態の記事が作成される" do
      expect(article).to be_valid
      expect(article.status).to eq "draft"
    end
  end

  context "status が下書き状態のとき" do
    let(:article) { build(:article, :draft) }
    it "下書き状態の記事で作成できる" do
      expect(article).to be_valid
      expect(article.status).to eq "draft"
    end
  end

  context "status が公開状態のとき" do
    let(:article) { build(:article, :published) }
    fit "公開状態の記事で作成できる" do
      expect(article).to be_valid
      expect(article.status).to eq "published"
    end
  end


  context "title が45文字以上の時" do
    it "記事が作成されない" do
      article = build(:article, title: Faker::Lorem.characters(number: 50))
      expect(article).to be_invalid
      expect(article.errors.details[:title][0][:error]).to eq :too_long
    end
  end
end
