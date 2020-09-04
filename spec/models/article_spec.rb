require 'rails_helper'

RSpec.describe Article, type: :model do
  context "title, body が指定されているとき" do
    let(:article) { build(:article) }
    it "記事が作成される" do
      expect(article).to be_valid
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
