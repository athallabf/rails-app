# Rails App

A Rails application for development purposes.

## Requirements

* Ruby version: (check `.ruby-version` file)
* Rails version: (check `Gemfile`)
* PostgreSQL database
* Node.js and Yarn (for asset compilation)

## Setup

1. Install dependencies:
```bash
bundle install
yarn install
```

2. Setup database:
```bash
rails db:create
rails db:migrate
rails db:seed  # Optional: load seed data
```

3. Set up credentials:
   - Ensure `config/master.key` file exists with the correct encryption key
   - Or set `RAILS_MASTER_KEY` environment variable

## Running the Application

### Development
```bash
rails server
# or
bin/dev  # if using bin/dev script
```

Visit http://localhost:3000

### Docker
```bash
docker-compose up
```

## Testing
```bash
# Run all tests
rails test

# Run specific test file
rails test test/models/user_test.rb

# Run system tests
rails test:system
```

## Database

The application uses PostgreSQL. Database configuration can be found in `config/database.yml`.

### Common database commands:
```bash
rails db:migrate        # Run pending migrations
rails db:rollback      # Rollback last migration
rails db:reset         # Drop, create, migrate, and seed database
rails console          # Open Rails console
```

## Deployment

The application uses CI/CD pipelines for deployment with the following features:
- Docker containerization for consistent deployments
- Automated builds and deployments via GitHub Actions
- Environment-specific configurations

### Recent deployment updates:
- Docker environment configured with Rails master key
- CSRF protection properly configured for production
- CI/CD service account with appropriate IAM roles (Viewer role)
- Improved artifact handling for Docker image URLs

## Environment Variables

### Required for production:
- `RAILS_MASTER_KEY`: Rails encryption key for credentials
- `DATABASE_URL`: PostgreSQL connection string
- `RAILS_ENV`: Set to `production`
- `RAILS_LOG_TO_STDOUT`: Set to `true` for Docker/cloud deployments

### Optional:
- `PORT`: Server port (default: 3000)
- `RAILS_SERVE_STATIC_FILES`: Set to `true` if not using a CDN/nginx

## Docker

The application includes Docker support for both development and production environments.

### Build Docker image:
```bash
docker build -t jarvis-dev-rails .
```

### Run with Docker Compose:
```bash
docker-compose up
```

## Troubleshooting

### CSRF Token Issues
If encountering CSRF token verification errors:
- Ensure `config.force_ssl = true` in production (if using HTTPS)
- Check that sessions are properly configured
- Verify cookies are being set correctly

### Master Key Issues
If Rails cannot decrypt credentials:
- Ensure `config/master.key` exists and contains the correct key
- Or set `RAILS_MASTER_KEY` environment variable
- Never commit `master.key` to version control

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request
