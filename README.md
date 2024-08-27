# Custom Attributes Storage in Rails Application

This Rails application provides a mechanism to store custom attributes for various models, allowing flexibility for different partners' needs. The implementation uses a Concern to encapsulate the logic necessary for managing custom attributes, with a focus on ensuring that these attributes can be queried using SQL.

## Table of Contents

- [Features](#features)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Setting Up the Environment](#setting-up-the-environment)
  - [Running the Application](#running-the-application)
    - [Without Docker](#without-docker)
    - [With Docker](#with-docker)
  - [Testing](#run-tests)
  - [Example Usage](#example-usage)

## Features

- Store and manage custom attributes for different models (e.g., `Customer` and `Battery`).
- Support for querying custom attributes using pure SQL.
- SQLite as the relational database for simplicity.
- Ability to customize which attributes are available for each model.

## Getting Started

### Prerequisites
To run this application, you'll need:
- Ruby (version 3.2.0)
- Rails (version 7.0.8)
- PostgreSQL (version 14)
- Docker

## Setting Up the Environment
### 1. Clone the Repository
```sh
git clone https://github.com/Haseeb717/EAV-pattern-app
cd EAV-pattern-app
```

## Running the Application
### Without Docker

### 1. Install Dependencies
```sh
bundle install
```

### 2. Database configuration
```sh
rails db:create
rails db:migrate
```

### 3. Rails Server

Run the rails server on console with port 3000:

```sh
rails s -p 3000
```

### With Docker

### 1. Build the Docker image:
```sh
  docker-compose build
```

### 2. Start the containers:
```sh
docker-compose up
```

### 3. Run database migrations:
```sh
docker-compose run web rails db:create
docker-compose run web rails db:migrate
```

### Run Tests

Execute the test suite:

```sh
bundle exec rspec
```

### Example Usage
You can add custom attributes to the Customer and Battery models as follows:

## Add custom attributes to Customer
```sh
customer = Customer.new(name: 'John Doe', phone_number: '123-456-7890')
customer.set_custom_attributes({ email: 'john.doe@example.com', hometown: 'New York' })
customer.save!
```

## Add custom attributes to Battery
```
battery = Battery.new(capacity: 300)
battery.set_custom_attributes({ make: 'BrandX', model: 'X200' })
battery.save!
```

### Querying Custom Attributes
You can query the custom attributes using SQL. For example:

```sh
SELECT * FROM custom_attributes WHERE customizable_type = 'Customer' AND key = 'email';
```
This allows for flexible querying of the custom attributes based on the requirements of different partners.


### Seeds
To run the seeds after setting up the application, execute:

```sh
rails db:seed
```

