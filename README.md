# Megumi API 

This README provides information on setting up, configuring and running the application.

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

## Using the API 

Certainly! I've added the "localhost" part to all the `curl` requests. Please note that I assumed the default port is 3000, so adjust it if your local server is running on a different port.

## Using the API

### Create Event
- **Endpoint**: `/api/v1/device_events`
- **Method**: POST
- **Description**: Create an event with a status code of 200.

```bash
curl -X POST http://localhost:3000/api/v1/device_events
```

### Get Event by UUID
- **Endpoint**: `/api/v1/device_events/1b63b287-b44c-46c1-b4f2-a20f00208358`
- **Method**: GET
- **Description**: Retrieve an event by ID with a status code of 200.

```bash
curl http://localhost:3000/api/v1/device_events/1b63b287-b44c-46c1-b4f2-a20f00208358
```

### Get All Events
- **Endpoint**: `/api/v1/device_events`
- **Method**: GET
- **Description**: Retrieve all events with a status code of 200.

```bash
curl http://localhost:3000/api/v1/device_events
```

### Filter & Pagination
- **Endpoint**: `/api/v1/device_events?notification_sent=false&page=1`
- **Method**: GET
- **Description**: Retrieve events with filter and pagination parameters, with a status code of 200.

```bash
curl http://localhost:3000/api/v1/device_events?notification_sent=false&page=1
```

### Update Event
- **Endpoint**: `/api/v1/device_events/1b63b287-b44c-46c1-b4f2-a20f00208358`
- **Method**: PATCH
- **Description**: Update an event with a status code of 200.

```bash
curl -X PATCH http://localhost:3000/api/v1/device_events/1b63b287-b44c-46c1-b4f2-a20f00208358
```

### Delete Event
- **Endpoint**: `/api/v1/device_events/555b0f04-37a5-4f58-a263-6db3c245e0ef`
- **Method**: DELETE
- **Description**: Delete an event with a status code of 204.

```bash
curl -X DELETE http://localhost:3000/api/v1/device_events/555b0f04-37a5-4f58-a263-6db3c245e0ef
```

### Export Events to S3 bucket
- **Endpoint**: `/api/v1/device_events/export_events`
- **Method**: POST
- **Description**: Export events with a status code of 200.

```bash
curl -X POST http://localhost:3000/api/v1/device_events/export_events
```

### Get Contents from S3 bucket
- **Endpoint**: `/api/v1/device_events`
- **Method**: GET
- **Description**: Test S3 endpoint with a status code of 200.

```bash
curl http://localhost:3000/api/v1/device_events
```

### All endpoints

- [Insomnia Collection YAML](https://sky-protect-2.s3.eu-west-1.amazonaws.com/Megumi+API+-+Insomnia+Collection.yaml)

- [Postman Collection HAR](https://sky-protect-2.s3.eu-west-1.amazonaws.com/Megumi+API+-+PostmanCollection.har)

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