# Megumi API 

This README provides information on setting up, configuring, and maintaining the [Your Project Name] application.

## Table of Contents

- [Dependencies](#dependencies)
- [How to Run](#how-to-run)
- [How to Run the Test Suite](#how-to-run-the-test-suite)
- [Services](#services)
- [Security](#security)
  - [Brakeman](#brakeman)
    - [How to Run Brakeman](#how-to-run-brakeman)
    - [Generating an HTML Report](#generating-an-html-report)
  - [Rubocop](#rubocop)
- [Continuous Integration (CI)](#continuous-integration-ci)
- [Contributing](#contributing)

## Dependencies

- Ruby 3.2.2
- Rails 7.1.2

To install necessary gems (includes PostgreSQL 1.1):

```bash
bundle install
```

Then run:

```bash
rails db:create
rails db:migrate
```

Run the server:

```bash
rails server
```

## How to Run the Test Suite 🏃‍

Tests are created with minitest. Run the tests:

```bash
rails test
```

## Additional Gems  💎

### Security Brakeman 🔑

[Brakeman](https://brakemanscanner.org/) is a vulnerability scanner for Ruby on Rails applications.

#### How to Run Brakeman

```bash
brakeman
```

#### Generating an HTML Report

```bash
brakeman -f html > ~/report.html
open ~/report.html
```

### Rubocop

[Rubocop](https://rubocop.org/) is a Ruby static code analyzer and formatter.

## Continuous Integration (CI) 🧑‍🔧

A GitHub Action has been created to run unit tests on every pull request against the `main` branch and `main` itself.

Added database timeouts for the production PostgreSQL database to resolve long-running queries. Look for `config/database.yml`.

## Potential Improvments 🤯

- [PgHero](https://github.com/ankane/pghero): PgHero can help identify issues in PostgreSQL.
- [Rollbar](https://github.com/rollbar/rollbar-gem): Rollbar is a tool for error reporting.
- [Sidekiq](https://github.com/mperham/sidekiq): Sidekiq is a tool for handling background jobs in Ruby.