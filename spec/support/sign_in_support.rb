module SignInSupport
  def basic_pass(path)
    username = ENV["BASIC_AUTH_USER"]
    password = ENV["BASIC_AUTH_PASSWORD"]
    visit "http://#{username}:#{password}@#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}#{path}"
  end

  def sign_in(user)
    # トップページに移動する
    basic_pass root_path
    visit root_path
    # トップページにログインページに遷移するボタンがあることを確認する
    expect(page).to have_content('ログイン')
    # ログインページへ移動する
    visit new_user_session_path
    # ユーザー情報を入力する
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード（6文字以上）', with: user.password
    # ログインボタンを押す
    find('input[name="commit"]').click
    # トップページへ移動したことを確認する
    expect(current_path).to eq(root_path)
  end
end