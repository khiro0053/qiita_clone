
# 概要
Qiitaのクローンアプリです。  
APIはRails, フロントはVueで作成しました。（フロントは自分で実装してはおりません。）  
テストフレームワークにはRspecを使用し、CircleCIでのテスト自動化を行っております。  
データベースはDockerのMySQLコンテナを使用しています。   
ログイン、ログアウト機能の実装にはdevise-token-authを使用しました。  
デプロイにはherokuを使用しております。  
https://protected-springs-12591.herokuapp.com/


# 機能一覧
- ユーザー登録、ログイン、ログアウト機能
- 下書き投稿、本番公開投稿(Markdown記法・シンタックスハイライト)
- 記事一覧表示
- 記事編集、削除
- マイページ一覧表示（本番公開記事のみ）
- 下書き一覧表示（自身の記事のみ）


herokuへのデプロイも行いました。
# 使用技術一覧
- Ruby version 2.6.2
- vue version 2.6.1
- MySQL
- Docker
- Rspec
- CircleCI
