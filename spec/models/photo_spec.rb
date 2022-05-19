require 'rails_helper'

RSpec.describe Photo, type: :model do
  before do
    @photo = FactoryBot.build(:photo)
  end

  describe '新規投稿' do
    context '新規投稿ができる場合' do
      it 'contentとimageが存在していれば保存できる' do
        expect(@photo).to be_valid
      end
    end
    context '新規投稿ができない場合' do
      it 'contentが空では保存できない' do
        @photo.content = ''
        @photo.valid?
        expect(@photo.errors.full_messages).to include("Content can't be blank")
      end
      it 'imageが空では保存できない' do
        @photo.image = nil
        @photo.valid?
        expect(@photo.errors.full_messages).to include("Image can't be blank")
      end
      it 'contentとimageが空では保存できない' do
        @photo.content = ''
        @photo.image = nil
        @photo.valid?
        expect(@photo.errors.full_messages).to include("Content can't be blank", "Image can't be blank")
      end
      it 'userが紐づいていないと保存できない' do
        @photo.user = nil
        @photo.valid?
        expect(@photo.errors.full_messages).to include("User must exist")
      end
    end
  end
end
