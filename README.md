# newji

# After clone project:

$ cd dougahisho
$ cp .env.sample .env

# After edit .env file:

$ bundle install
$ rails db:create

# Init DB :

$ bundle exec rails db < db/structure.sql

# Import Seed data DB:

$ rake db:seed