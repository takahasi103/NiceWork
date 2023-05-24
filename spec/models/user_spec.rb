require 'rails_helper'

RSpec.describe 'Userモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { user.valid? }

    let!(:other_user) { create(:user) }
    let(:user) { build(:user) }

    context 'account_nameカラム' do
      it '空欄でないこと' do
        user.account_name = ''
        is_expected.to eq false
      end

      it '一意性があること' do
        user.account_name = other_user.account_name
        is_expected.to eq false
      end

      it '20文字以下であること: 20文字は〇' do
        user.account_name = Faker::Alphanumeric.alpha(number: 20)
        is_expected.to eq true
      end

      it '20文字以下であること: 21文字は×' do
        user.account_name = Faker::Alphanumeric.alpha(number: 21)
        is_expected.to eq false
      end

      it '半角英数字であること' do
        user.account_name = 'account_name!'
        is_expected.to eq false
      end
    end

    context 'nameカラム' do
      it '空欄でないこと' do
        user.name = ''
        is_expected.to eq false
      end

      it '15文字以下であること: 15文字は〇' do
        user.name = Faker::Lorem.characters(number: 15)
        is_expected.to eq true
      end

      it '15文字以下であること: 16文字は×' do
        user.name = Faker::Lorem.characters(number: 16)
        is_expected.to eq false
      end
    end

    context 'first_nameカラム' do
      it '空欄でないこと' do
        user.first_name = ''
        is_expected.to eq false
      end
    end

    context 'last_nameカラム' do
      it '空欄でないこと' do
        user.last_name = ''
        is_expected.to eq false
      end
    end

    context 'introductionカラム' do
      it '50文字以下であること: 50文字は〇' do
        user.introduction = Faker::Lorem.characters(number: 50)
        is_expected.to eq true
      end

      it '50文字以下であること: 51文字は×' do
        user.introduction = Faker::Lorem.characters(number: 51)
        is_expected.to eq false
      end
    end

    context 'emailカラム' do
      it '空欄でないこと' do
        user.email = ''
        is_expected.to eq false
      end
    end
  end
end
