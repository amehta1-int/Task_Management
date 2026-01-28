# Task Manager

## Overview

Task Manager is a Rails application for managing personal tasks with secure user
authentication. Users can create, update, and organize tasks by status and
priority, making it easy to keep work tracked and visible.

## Technicality

### Stack

- Ruby 3.2.6
- Rails 8.1.2
- MySQL 5.7+
- RSpec for testing

### Core Domains

- Users: signup/login via secure password authentication
- Tasks: CRUD operations with status and priority attributes
- Querying: filtering by status and sorting by due date or priority

### Service Objects

Business logic is encapsulated in service classes under `app/services`:

- `SessionsAuthenticateService` for login authentication
- `SignUpUsersService` for user creation
- `CreateTasksService` for task creation
- `UpdateTasksService` for task updates
- `QueryTasksService` for task filtering/sorting

### API Notes

Controllers respond to both HTML and JSON for main flows:

- Sessions: login/logout
- Users: signup
- Tasks: list, show, create, update, delete

## Setup

```bash
# Install dependencies
bundle install

# Setup database
rails db:create db:migrate

# Start server
rails server
```

## Tests

RSpec covers model, request, service, and system specs. Run the full suite with:

```bash
bundle exec rspec
```

## Docker

Docker Compose is available for local MySQL. Start the database with:

```bash
docker compose up -d db
```

If you want to run the app container too:

```bash
docker compose up --build
```
