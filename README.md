# README
This README would normally document whatever steps are necessary to get the  
application up and running.

Things you may want to cover:

* Clone repository
> `git@git.epam.com:mykyta_tretiak/epam-music.git`

* Ruby version
> `ruby-3.1.0`

* Install gems
> `bundle install`

* Database creation
> `rails db:create`

* Database initialization

* How to run the test suite
> `bundle exec rspec`

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* Lintering:
  - rubocop - ruby static code analyzer and code formatter.
  - rubocop-performance - extension for rubocop with additional rules for lintering.
  - rubocop-rails - extension for rubocop with additional rules for rails lintering.
  - traceroute - Rake task that helps find dead routes and unused actions.
  - strong_migrations - сatch unsafe migrations in development.
  - breakman - is a static analysis tool which checks Ruby on Rails applications for security vulnerabilities.
  - bundler-audit - checks gemfile.lock for vulnerable versions of gems and does not allow untrusted gems to be installed.
  - bunder-leak - tool to find leaky gems in your dependencies. Make sure memory leaks are not in your gem dependencies.
  - lefthook - hook for git push and git commit.

* How setting leftook:
  1. Install lefthook:
    ```ruby
    $ lefthook install
    ```
  2. Test it:
    ```ruby
    $ lefthook run pre-commit
    #or
    $ lefthook run pre-push
    ```
  - Expected result after calling commands:

    ```ruby
    $ lefthook run pre-commit
    ...
     SUMMARY: (done in 2.35 seconds)
      ✔️  brakeman
      ✔️  rubocop

    #or

    $ lefthook run pre-push
    ...
    SUMMARY: (done in 1.76 seconds)
    ✔️  bundler-leak
    ✔️  bundler-audit
    ```
* How it works:
    - We have two actions `pre-commit` and `pre-push`:
    -   when you execute `git commit`, call rubocop and brakeman before doing so.
    if rubocop and brakeman run with exceptions, your commit will not be executed.

    - when you execute `git push`, call bundler-leak and bundler-audit before doing so.
    if bundler-leak and bundler-audit run with exceptions, your push will not be executed.

## Configure rails credentials

### How to get keys from encrypted environments

There are 4 environments with their own keys: development, test, staging and production.
1. Open rails console for necessary environment(for instance, **rails c -e production**);
2. **Rails.application.credentials.config** command - demonstation of all data from config/credentials/*.yml.enc file;
3. **Rails.application.credentials.config[:secret_key_base]** command - demonstration of environment key;

Database params from console:
* Rails.application.credentials.config[:database_name]
* Rails.application.credentials.config[:database_host]
* Rails.application.credentials.config[:database_username]
* Rails.application.credentials.config[:database_password]

### How to add or update credentials

You can use a text editor(VIM/Nano/VS Code/etc.) for next command:

`
EDITOR="your text editor" rails credentials:edit --environment <name_of_environment>`

## Deployment on Heroku
### Staging
https://epam-music-staging.herokuapp.com/
### Production
https://epam-music.herokuapp.com/
### Postman Collect
Added to the attachment in the link:
https://beattrey.atlassian.net/jira/software/projects/EM/boards/1?selectedIssue=EM-8

## To use sidekiq

* Install sidekiq gem through `bundle install`
* Run `bundle exec sidekiq -C congfig/sidekiq.yml` from bash
* Run `rails server` from bash

Now you can access sidekiq UI, to do this you have to be logged as admin and go to /sidekiq url
