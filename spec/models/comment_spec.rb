require 'rails_helper'

RSpec.describe Comment, type: :model do
  context "body を指定しているとき" do
    let(:comment) { build(:comment) }
    it "値が入力される" do
      expect(comment).to be_valid
    end
  end

  context "body を指定していない時" do
    it "エラーになる" do
      comment = build(:comment, body: nil)
      expect(comment).to be_invalid
      expect(comment.errors.details[:body][0][:error]).to eq :blank
    end
  end
end
