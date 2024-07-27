# Requirements:
You would need the following on the machine to run the project:
- Ruby 2.7.0 or later
- SQLite3

Most UNIX-like operating systems have SQLite3 pre-installed, if yours doesn't, You can find the installation instructions at https://www.sqlite.org/. You can verify your installation by running: 
```bash
sqlite3 --version
```

# Starting the application
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
# Important files
Below are the relevant files:
- app/controllers/short_links_controller.rb
- app/models/short_link.rb 
- test/controllers/short_links_controller_test.rb
- db/schema.rb
- db/migrate/20240727065254_create_short_links.rb
- db/migrate/20240727081059_add_url_index_to_short_links.rb


# Using the endpoints
You can then start testing the `encode` and `decode` endpoints via Postman or using the `use_endpoints.rb` file provided in the root directory. 

Adjust the content of the file to your needs and in a separate terminal, simply run:
```bash
ruby use_endpoints.rb
```
Both endpoints use `POST` method, and requires a `url` parameter. 

# Security concerns
### 1. Spam attacks, DDOS attacks
Malicious users can spam request the application, overwhelming the server and making the service unavailable to legitimate users. If these requests contain valid URLs, additional DB storage would also be required, leading to increased storage cost. To prevent this, we can: 
- Implement an authentication flow to deter attackers
- Implement rate limiting to restrict the volume of network traffic over a specific time period
- Implement caching to reduce strain on the application, making it even more difficult for attackers to overload our system

### 2. Cross-site scripting (XSS)
Our service can be used to distribute XSS attacks to other people. For example, attackers can shorten a URL with search parameters that include a malicious JS script. When other users click on this shortened link, they will be redirected to the original URL, and the contained script may be rendered and run by the browser if the website is susceptible to such exploit. 

Unfortunately there's not much we can do against this except looking for dangerous HTML tags (e.g. `<script>`) and other red-flags when receiving an encoding request in order to reject it. 

### 3. Cross Site Request Forgery (CSRF)
Our service can be used to distribute CSRF attacks. Malicious users can encode URLs that make forged requests to popular websites (banking, social media etc). When users click on these links and are currently authenticated in these websites, the credential cookies will be sent along the forged requests. This would lead to unwanted behaviors if said websites do not have preventative measures against CSRF. Similar to XSS, there's not much we can do. The burden belongs the other websites. 

### 4. SQL injection
Attackers can input arbitrary SQL code as part of the data sent to our endpoints. If we use the input directly to build a SQL command, we will compromise our entire database. To prevent this, we can: 
- Check the input to ensure that it's a valid URL
- Use Rails' ORM to handle DB operations instead of writing SQL statements manually.

# Performance concerns
### 1. Collision:
Our encoding algorithm has the following properties:
- It is dependent on the ShortLinks' IDs, which are unique. 
- It is a 1-to-1 mapping between the original url and the encoded url. This is NOT similar to hashing, where multiple values can result in the same hash. Encoding algorithms must have a uniqueness constraint on the result side so that the decoding of the result is deterministic and returns only a single original value. 

This means that we will not get a collision as long as we do not limit the number of characters that the shortened URLs must have. However, out encoded links will get longer over time.

### 2. Scaling:
As the number of users and data grows, we may need to scale our system horizontally to improve the performance and availability of our service. This includes:
- Setting up multiple servers and implement a load balancer to distribute incoming requests evenly among them. This would reduce the strain on any single instance and also allow the service to remain available if some servers die. 
