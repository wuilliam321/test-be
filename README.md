# README

Steps to setup the project

## Requirements

* Ruby version: `2.4.1`
* Bundler: `2.0.2`
* Sqlite3

**Note**: All packed installed automatically on bundle install. The only needed package is ruby, please use `rvm` to install it


    rvm install 2.4.1
    
Then run

    rvm use 2.4.1

## Setup

* System dependencies
    
      bundle install

* Environment variables

Create two files: `config/local_env.yml` and  `config/local_env.test.yml` and put this content in there:


    API_REST_DOMAIN: example.com
    API_REST_URL: http://example.com/public/v1/
    CLIENT_ID: test
    CLIENT_SECRET: my_V3ry_S3cre7_P@@sw0rd
    TEST_USER: test_automation_000@example.com # no needed for local_env.yaml
    TEST_PASSWORD: my_0th3r_S3cre7_P@@sw0rd # no needed for local_env.yaml
 

* Database creation
    
      bundle exec rails db:migrate

* Database initialization

      bundle exec rails db:seed

# Running test

    bundle exec rspec
    
# Coverage

Open in browser: `<PROJECT_FOLDER>/coverage/index.html` after test running