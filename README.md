# README

This README would normally document whatever steps are necessary to get the
application up and running.

아주 기본적인 Ruby on Rails8의 CRUD 게시글

* Ruby version = 3.4.8
* Database = MySQL
* Database creation = bin/rails db:create
* Database initialization
  - rails g model Posts title context:text
  - bin/rails db:migrate

ENV Setting
 - export DB_HOST="127.0.0.1"
 - export DB_USERNAME=
 - export DB_PASSWORD=
 - 다 작성 후 "source ~/.bashrc (or ~/.zshrc)"
