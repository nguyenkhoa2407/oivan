# Requirements:
You would need the following on the machine to run the project:
- Ruby 2.7.0 or later
- SQLite3

Most UNIX-like operating systems have SQLite3 pre-installed, if yours doesn't, You can find the installation instructions at https://www.sqlite.org/. You can verify your installation by running: 
```bash
sqlite3 --version
```

# Start the application
First, install the dependencies
```bash
bundle install
```
Then, you need to set up the database. Run all pending migrations with:
```bash
rails db:migate
```
Currently, only controllers (the 2 required endpoints) are tested. To run the tests:
```bash
rails test:controllers
```
Finally, to start the server:
```bash
bin/rails server 
```

# Using the endpoints
You can then start testing the `encode` and `decode` endpoints via Postman or using the `use_endpoints.rb` file provided in the root directory. 

Adjust the content of the file to your needs and in a separate terminal, simply run:
```bash
ruby use_endpoints.rb
```
Both endpoints use `POST` method, and requires a `url` parameter. 