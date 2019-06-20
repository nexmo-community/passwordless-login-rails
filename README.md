# README

A passwordless login authentication system implemented in Rails 6. Uses phone number as identifiers and the Nexmo SMS APIs to send a temporary pin to allow users to log in.

## Requirements

* Rails 6
* PostgreSQL


[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)


## Setup

* if you don't already have one, sign up for a Nexmo account
* the application will require 2 Environment Varibles to be setup: `NEXMO_API_KEY` and `NEXMO_API_SECRET`:
  * in dev mode, `dotenv` is include (https://github.com/bkeepers/dotenv) - please add the above variables to a .env file (this file was also added to `.gitignore`)
  * in production mode, set the variables accordingly - the `Deploy to Heroku` process will prompt you for them

