# README

Ruby version 2.6.2
vue version 2.6.10
Docker
Rspec
Description

機能一覧
ユーザー登録、ログイン、ログアウト機能
下書き投稿、本番公開投稿(Markdown記法・シンタックスハイライト)
記事一覧表示
記事編集、削除
マイページ一覧表示（本番公開記事のみ）
下書き一覧表示（自身の記事のみ）
APIはRails, フロントはVueで作成しました。

＊　フロントは教材のサンプルコードをコピーしているため、自分で実装はしておりません。

Rspecによる、model,APIのテストを実装しております。 Dockerをとりいれました 

ログイン、ログアウト機能の実装にはdevise-token-authを導入し、公式ドキュメント等を参考にして、実装しました。

herokuへのデプロイも行いました。 https://qiita-qlone-stg.herokuapp.com/
