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
      basic_pass root_path
      visit photo_path(@photo1)
      # ログインしていない場合、ログインページに遷移されることを確認する
      expect(current_path).to eq(new_user_session_path)
    end
  end
  context 'プロトタイプ情報詳細表示できるとき' do
    it 'ログイン状態で、自分が投稿したプロトタイプ情報は詳細表示できる' do
      # ログインする
      sign_in(@photo1.user)
      # 自分が投稿したプロトタイプ情報の詳細ページに遷移する
      visit photo_path(@photo1)
      # 詳細ページにプロトタイプ情報の内容が含まれていることを確認する
      expect(page).to have_selector('img')
      expect(page).to have_content(@photo1.content)
    end
  end
  context 'プロトタイプ情報詳細表示できないとき' do
    it 'ログイン状態だが、自分以外が投稿したプロトタイプ情報は詳細表示できずトップページに移動する' do
      # ログインする
      sign_in(@photo1.user)
      # 自分以外が投稿したプロトタイプ情報の詳細ページに遷移する
      visit photo_path(@photo2)
      # 自分のトップページに遷移されることを確認する
      expect(current_path).to eq(photos_index_path)
    end
  end
end

RSpec.describe 'プロトタイプ情報編集', type: :system do
  before do
    @photo1 = FactoryBot.create(:photo)
    @photo2 = FactoryBot.create(:photo)
  end

  context 'ログインしていないとき' do
    it 'ログインしていない状態で編集ページにアクセスした場合、ログインページに移動する' do
      # トップページに移動する
      basic_pass root_path
      visit edit_photo_path(@photo1)
      # ログインしていない場合、ログインページに遷移されることを確認する
      expect(current_path).to eq(new_user_session_path)
    end
  end
  context 'プロトタイプ情報編集できるとき' do
    it 'ログイン状態で、自分が投稿したプロトタイプ情報は編集できる' do
      # ログインする
      sign_in(@photo1.user)
      # 自分が投稿したプロトタイプ情報の詳細表示ページに遷移する
      visit photo_path(@photo1)
      # 詳細表示ページに編集ページに遷移するボタンがあることを確認する
      expect(page).to have_content('編集')
      # 編集ページに遷移する
      visit edit_photo_path(@photo1)
      # すでに投稿済みの内容がフォームに入っていることを確認する
      expect(
        find('input[name="photo[content]"]').value
      ).to eq(@photo1.content)
      # 投稿内容を編集する
      fill_in 'photo[content]', with: "#{@photo1.content}+編集した情報"
      # 添付する画像を定義する
      image_path = Rails.root.join('public/images/test02_image.jpeg')
      # 画像選択フォームに画像を添付する
      attach_file('photo[image]', image_path)
      # 保存するボタンを押してもPhotoモデルのカウントはカウントは変わらないことを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { Photo.count }.by(0)
      # トップページに遷移する
      visit root_path
      # トップページには先ほど編集した内容の画像情報が存在することを確認する
      expect(page).to have_selector('img')
      # トップページには先ほど編集した内容の文字情報が存在することを確認する
      expect(page).to have_content("#{@photo1.content}+編集した情報")
    end
  end
  context 'プロトタイプ情報編集できないとき' do
    it 'ログイン状態だが、自分以外が投稿したプロトタイプ情報は編集できずトップページに移動する' do
      # ログインする
      sign_in(@photo1.user)
      # 自分以外が投稿したプロトタイプ情報の編集ページに遷移する
      visit edit_photo_path(@photo2)
      # 自分のトップページに遷移されることを確認する
      expect(current_path).to eq(photos_index_path)
    end
  end
end

RSpec.describe 'プロトタイプ情報削除', type: :system do
  before do
    @photo1 = FactoryBot.create(:photo)
    @photo2 = FactoryBot.create(:photo)
  end

  context 'ログインしていないとき' do
    it 'ログインしていない状態で削除ボタンのある詳細表示ページにアクセスした場合、ログインページに移動する' do
      # トップページに移動する
      basic_pass root_path
      visit photo_path(@photo1)
      # ログインしていない場合、ログインページに遷移されることを確認する
      expect(current_path).to eq(new_user_session_path)
    end
  end
  context 'プロトタイプ情報削除できるとき' do
    it 'ログイン状態で、自分が投稿したプロトタイプ情報は削除できる' do
      # ログインする
      sign_in(@photo1.user)
      # 自分が投稿したプロトタイプ情報の詳細表示ページに遷移する
      visit photo_path(@photo1)
      # 詳細表示ページに削除するボタンがあることを確認する
      expect(page).to have_content('削除')
      # 削除するボタンを押すとPhotoモデルのカウントが1下がることを確認する
      expect{
        find_link('削除する', href: photo_path(@photo1)).click
      }.to change { Photo.count }.by(-1)
      # トップページに遷移する
      visit root_path
      # トップページには先ほど削除され、デモ投稿の画像情報が存在することを確認する
      expect(page).to have_selector('img')
      # トップページには先ほど削除され、デモ投稿の文字情報が存在することを確認する
      expect(page).to have_content('(sample)')
    end
  end
  context 'プロトタイプ情報削除できないとき' do
    it 'ログイン状態だが、自分以外が投稿したプロトタイプ情報は削除できずトップページに移動する' do
      # ログインする
      sign_in(@photo1.user)
      # 自分以外が投稿したプロトタイプ情報の編集ページに遷移する
      visit photo_path(@photo2)
      # 自分のトップページに遷移されることを確認する
      expect(current_path).to eq(photos_index_path)
    end
  end
end