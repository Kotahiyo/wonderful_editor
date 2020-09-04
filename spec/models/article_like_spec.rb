require 'rails_helper'

RSpec.describe ArticleLike, type: :model do
  context "必要なカラムが指定されている時" do
    let(:article_like) { build(:article_like) }
    fit "値が入力される" do
      expect(article_like).to be_valid
    end
  end
end
