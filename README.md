![logo_sola](https://user-images.githubusercontent.com/92853864/167255890-873fabdc-7623-4631-8820-9bca6fd974db.png)

# アプリケーション名
sola

# アプリケーション概要
無理なく続けられる、画像投稿日記帳。

# URL
https://sola-36709.herokuapp.com/

# テスト用アカウント
- Basic認証
  - ID: admin
  - PASSWORD: 2222

- アカウント1
  - メールアドレス: test01@test.com
  - パスワード: test01

- アカウント2
  - メールアドレス: test02@test.com
  - パスワード: test02

# 利用方法
1日1回以上、空を撮影し、その時の感情と共に投稿する。

# 目指した課題解決
ペルソナは、日々の仕事や受験勉強で忙しい社会人や受験生。

ユーザーストーリーは、何も考えずに空を見上げ一呼吸置くことで、ストレス緩和を促す。

# 洗い出した要件
https://docs.google.com/spreadsheets/d/11hLCWlFRvoMEKDqSbjivDohZ3z9LIch45zRuR8ck2z8/edit?usp=sharing

# 実装した機能についての画像やGIFおよびその説明
ログインした各ユーザー本人のみ閲覧出来る、Web版の簡易な日記帳。
[![Image from Gyazo](https://i.gyazo.com/d7fb805e563c5cb84ca44fd05b88b036.jpg)](https://gyazo.com/d7fb805e563c5cb84ca44fd05b88b036)

# 実装予定の機能
- BOT機能
- 画像識別機能

# データベース設計
![test](https://user-images.githubusercontent.com/92853864/167257957-74215d65-fe90-42e6-bd19-188a3c92f73a.png)

# ローカルでの動作方法
- WebブラウザGoogle Chromeの最新版を利用してアクセス.
  -ただしデプロイ等で接続できない場合もある。その際は少し時間をおいてから接続。
- 接続先およびログイン情報については、上記の通り。
- 同時に複数の方がログインしている場合に、ログインできない可能性がある。
- テストアカウントでログイン→トップページから新規投稿→フォームに入力→情報投稿
- 確認後、ログアウト処理をする。