# Personal Site

A personal website built with Ruby on Rails and self-hosted as a public web application.

It includes:
- a public-facing portfolio website,
- a custom admin panel for managing content,
- authentication for admin access,
- seeded example data for local testing.

The project was created as a small end-to-end app to showcase backend and full-stack development skills, code organization, testing, and deployment.

## Live Site

Live URL: `https://yp8we.hatchboxapp.com/`

## Repository

Repository URL: `https://github.com/nika-piotrowska/personal_site`

## Features

### Public website
- Home page
- About page
- Experience page
- Projects listing and project details
- Contact page

### Admin panel
- Admin authentication
- Profile management
- Projects CRUD
- Experience CRUD

## Tech Stack

- Ruby 3.4.8
- Rails 8.1
- PostgreSQL 16
- Hotwire (default Rails setup)
- Importmap (default Rails setup)
- Dart Sass
- Devise
- RSpec
- RuboCop
- Brakeman
- Bundler Audit

## Running locally

### 1. Clone the repository

```bash
git clone https://github.com/nika-piotrowska/personal_site.git
cd personal_site
```

### 2. Install dependencies

```bash
bundle install
```

### 3. Configure environment variables

Create a `.env` file based on `.env.sample.`

Example:

```env
DB_DEV_USERNAME=username
DB_DEV_PASSWORD=password
```

### 4. Set up the database

```bash
bin/rails db:create
bin/rails db:migrate
```

If you want to start with example content, you can also run:

```bash
bin/rails db:seed
```

Using seeds is optional.
You can run the application without seeded data, create your own account, and add content manually.

### 5. Start the application

```bash
bin/rails server
```

The app should be available at:

```
http://localhost:3000
```

### Seeded admin account

For local development, seeds create a default admin user:

- Email: `admin@example.com`
- Password: `Password123!`

You can use these credentials to log in to the admin panel locally or create own account.

### Test suite

Run tests with:

```bash
bundle exec rspec
```

### Code quality / security checks

```bash
bundle exec rubocop
bundle exec brakeman
bundle exec bundler-audit
```

### Deployment

The application is self-hosted and deployed publicly.
The repository also includes deployment-related configuration and CI setup.

### Notes

This project is intentionally kept small and focused. The goal was to build a clean, maintainable personal website with a custom CMS-like admin area, rather than relying on an external admin framework.

### Future Improvements

- Add a `Skill` model to better represent technologies and tools used in projects and experience
- Add filtering projects by technology
- Improve UI/UX and visual consistency across pages
- Add pagination for projects and experience
- Add caching for frequently accessed content
