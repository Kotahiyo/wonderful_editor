require 'rails_helper'

RSpec.describe User, type: :model do
  # context "email, password, name が指定されているとき" do
  #   it "ユーザーが作成される" do
  #   user = build(:user)
  #   expect(user).to be_valid
  #   end
  # end

  # context "email が指定されていないとき" do
  #   it "ユーザーが作成されない" do
  #     user = build(:user, email: nil)
  #     expect(user).to be_invalid
  #     expect(user.errors.details[:email][0][:error]).to eq :blank
  #   end
  # end

  # 模範解答

  context "必要な情報が揃っている場合" do
    let(:user) { build(:user) }

    it "ユーザー登録できる" do
      expect(user).to be_valid
    end
  end

  context "名前のみ入力している場合" do
    let(:user) { build(:user, email: nil, password: nil) }

    it "エラーが発生する" do
      expect(user).not_to be_valid
    end
  end

  context "email がない場合" do
    let(:user) { build(:user, email: nil) }

    it "エラーが発生する" do
      expect(user).not_to be_valid
    end
  end

  context "password がない場合" do
    let(:user) { build(:user, password: nil) }

    it "エラーが発生する" do
      expect(user).not_to be_valid
    end
  end
end
