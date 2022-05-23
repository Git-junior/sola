require 'rails_helper'

def basic_pass(path)
  username = ENV["BASIC_AUTH_USER"]
  password = ENV["BASIC_AUTH_PASSWORD"]
  visit "http://#{username}:#{password}@#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}#{path}"
end

RSpec.describe 'プロトタイプ情報投稿', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @photo_content = Faker::Lorem.sentence
  end

  context 'ログインしていないとき' do
    it 'ログインしていない状態で新規投稿ページにアクセスした場合、ログインページに移動する' do
      # トップページに移動する
      basic_pass root_path
      visit new_photo_path
      # ログインしていない場合、ログインページに遷移されることを確認する
      expect(current_path).to eq(new_user_session_path)
    end
  end
  context 'プロトタイプ情報投稿できるとき' do
    it 'ログイン状態で、必要な情報が存在していれば新規投稿できる' do
      # ログインする
      sign_in(@user)
      # 新規投稿ページへのボタンがあることを確認する
      expect(page).to have_content('新規投稿')
      # 新規投稿ページに移動する
      visit new_photo_path
      # フォームに情報を入力する
      fill_in 'photo[content]', with: @photo_content
      # 添付する画像を定義する
      image_path = Rails.root.join('public/images/test_image.JPG')
      # 画像選択フォームに画像を添付する
      attach_file('photo[image]', image_path)
      # 保存するボタンを押すとPhotoモデルのカウントが1上がることを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { Photo.count }.by(1)
      # トップページには先ほど投稿した内容の画像情報が存在することを確認する
      expect(page).to have_selector('img')
      # トップページには先ほど投稿した内容の文字情報が存在することを確認する
      expect(page).to have_content(@photo_content)
    end
  end
  context 'プロトタイプ情報投稿できないとき' do
    it 'ログイン状態だが、テキストが空では新規投稿ができずに同じページに戻ってくる' do
      # ログインする
      sign_in(@user)
      # 新規投稿ページへのボタンがあることを確認する
      expect(page).to have_content('新規投稿')
      # 新規投稿ページに移動する
      visit new_photo_path
      # フォームに情報を入力しない
      fill_in 'photo[content]', with: ''
      # 添付する画像を定義する
      image_path = Rails.root.join('public/images/test_image.JPG')
      # 画像選択フォームに画像を添付する
      attach_file('photo[image]', image_path)
      # 保存するボタンを押してもPhotoモデルのカウントは上がらないことを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { Photo.count }.by(0)
      # 新規投稿ページへ戻されることを確認する
      expect(current_path).to eq(photos_path)
    end
    it 'ログイン状態だが、画像が空では新規投稿ができずに同じページに戻ってくる' do
      # ログインする
      sign_in(@user)
      # 新規投稿ページへのボタンがあることを確認する
      expect(page).to have_content('新規投稿')
      # 新規投稿ページに移動する
      visit new_photo_path
      # フォームに情報を入力する
      fill_in 'photo[content]', with: @photo_content
      # 画像を添付しない
      # 保存するボタンを押してもPhotoモデルのカウントは上がらないことを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { Photo.count }.by(0)
      # 新規投稿ページへ戻されることを確認する
      expect(current_path).to eq(photos_path)
    end
    it 'ログイン状態だが、テキストと画像が空では新規投稿ができずに同じページに戻ってくる' do
      # ログインする
      sign_in(@user)
      # 新規投稿ページへのボタンがあることを確認する
      expect(page).to have_content('新規投稿')
      # 新規投稿ページに移動する
      visit new_photo_path
      # フォームに情報を入力しない
      fill_in 'photo[content]', with: ''
      # 画像を添付しない
      # 保存するボタンを押してもPhotoモデルのカウントは上がらないことを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { Photo.count }.by(0)
      # 新規投稿ページへ戻されることを確認する
      expect(current_path).to eq(photos_path)
    end
  end
end

RSpec.describe 'プロトタイプ情報詳細表示', type: :system do
  before do
    @photo1 = FactoryBot.create(:photo)
    @photo2 = FactoryBot.create(:photo)
  end

  context 'ログインしていないとき' do
    it 'ログインしていない状態で詳細表示ページにアクセスした場合、ログインページに移動する' do
      # トップページに移動する
      # ログインしていない場合、ログインページに遷移されることを確認する
    end
  end
  context 'プロトタイプ情報詳細表示できるとき' do
    it 'ログイン状態で、自分が投稿したプロトタイプ情報は詳細表示できる' do
      # ログインする
      # 自分が投稿したプロトタイプ情報の詳細ページに遷移する
      # 詳細ページにプロトタイプ情報の内容が含まれていることを確認する
    end
  end
  context 'プロトタイプ情報詳細表示できないとき' do
    it 'ログイン状態だが、自分以外が投稿したプロトタイプ情報は詳細表示できずトップページに移動する' do
      # ログインする
      # 自分以外が投稿したプロトタイプ情報の詳細ページに遷移する
      # 自分のトップページに遷移されることを確認する
    end
  end
end