# Megumi API 

This README provides information on setting up, configuring and running Megumi API.

## How to run

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

## How to run test suite 🏃‍

Tests are created with minitest. Run the tests:

```bash
rails test
```

## Using the API

### Create Event
- **Endpoint**: `/api/v1/device_events`
- **Method**: POST
- **Description**: Create an event with a status code of 200.

```bash
curl --request POST \
  --url http://localhost:3000/api/v1/device_events \
  --header 'Content-Type: application/json' \
  --data '{
    "device_uuid": "755d3a5e-9b31-11ee-b9d1-0242ac120002", 
    "recorded_at": "2023-12-11 22:15:43", 
    "category": "device-online"
  }'
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

#### Generate a report

```bash
brakeman -f html > ~/report.html
open ~/report.html
```

### Rubocop

[Rubocop](https://rubocop.org/) is a Ruby static code analyzer and formatter.

## Continuous integration 🧑‍🔧

A GitHub Action has been created to run unit tests on every pull request against the `main` branch and `main` itself.

Added database timeouts for the production PostgreSQL database to resolve long-running queries. Look for `config/database.yml`.

## Deployment 🧑‍🔧

How to deploy the application

```bash
docker build -t megumi .
docker volume create app-storage
docker run --rm -it -v app-storage:/rails/storage -p 3000:3000 --env RAILS_MASTER_KEY=<see config/master.key> megumi
```

Note: Ensure cors in configured properly on the application to allow traffic and the VM needs to have the required ports opened. 

## Potential improvements 🤯

- [PgHero](https://github.com/ankane/pghero): PgHero can help identify issues in PostgreSQL.
- [Rollbar](https://github.com/rollbar/rollbar-gem): Rollbar is a tool for error reporting.
- [Sidekiq](https://github.com/mperham/sidekiq): Sidekiq is a tool for handling background jobs in Ruby.

- export_event feature needs to be tested properly which can be achieved with [AWS Client Stub](https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/ClientStubs.html)
- The AWS credentials needs to be made into an ENV variable 
- Move the export feature to a more reusable component
- filter_by_params can be made into a reusable component
- Pagination endpoint needs to return appropriate headers such as next-page, prev-page etc.
- There can be different validation logic for metadata for different events 
- Filtering can be expanded to support more filter attributes
- Validation for Device UUID can be further expanded to look up in a potential device table
- Categories can be expanded into a more configuration list as opposed to how it is hard coded now
- There needs to be some authentication/authorisation can be accomplished via a authentication provide such as Auth0 or Devise. 
- Sending appropriate HTTP headers depending on the use case
- Fixtures or factorybot can be utilised in testing to reduce repetition
- The database can be seeded with many different types of events which can be used to run tests against
- 