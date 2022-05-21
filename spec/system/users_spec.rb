require 'rails_helper'

def basic_pass(path)
  username = ENV["BASIC_AUTH_USER"]
  password = ENV["BASIC_AUTH_PASSWORD"]
  visit "http://#{username}:#{password}@#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}#{path}"
end

RSpec.describe 'ユーザー新規登録', type: :system do
  before do
    @user = FactoryBot.build(:user)
  end

  context 'ユーザー新規登録ができるとき' do
    it '正しい情報を入力すればユーザー新規登録ができてトップページに移動する' do
      # トップページに移動する
      # トップページに新規登録ページへ遷移するボタンがあることを確認する
      # 新規登録ページへ移動する
      # ユーザー情報を入力する
      # 新規登録ボタンを押すとユーザーモデルのカウントが1上がることを確認する
      # トップページへ遷移したことを確認する
      # ログアウトボタンが表示されることを確認する
      # 新規登録ページへ遷移するボタンや、ログインページへ遷移するボタンが表示されていないことを確認する
    end
  end
  context 'ユーザー新規登録ができないとき' do
    it '誤った情報ではユーザー新規登録ができずに新規登録ページへ戻ってくる' do
      # トップページに移動する
      # トップページに新規登録ページへ遷移するボタンがあることを確認する
      # 新規登録ページへ移動する
      # ユーザー情報を入力する
      # 新規登録ボタンを押してもユーザーモデルのカウントは上がらないことを確認する
      # 新規登録ページへ戻されることを確認する
    end
  end
end
