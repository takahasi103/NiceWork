require 'rails_helper'

RSpec.describe 'Postモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { post.valid? }

    let(:user) { create(:user) }
    let!(:post) { build(:post, user_id: user.id) }

    context 'bodyカラム' do
      it '空欄でないこと' do
        post.body = ''
        is_expected.to eq false
      end
      it '50文字以下であること: 100文字は〇' do
        post.body = Faker::Lorem.characters(number: 100)
        is_expected.to eq true
      end
      it '50文字以下であること: 101文字は×' do
        post.body = Faker::Lorem.characters(number: 101)
        is_expected.to eq false
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it 'N:1となっている' do
        expect(Post.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end
  end
end