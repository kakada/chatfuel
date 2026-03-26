chatfuel-rails is a small rails app communicate with [chatfuel](https://chatfuel.com/)
to build interactive chatbot.

## Installation

### Prerequisites

- [Docker](https://docs.docker.com/get-docker/) (version 19.03 or later)
- [Docker Compose](https://docs.docker.com/compose/install/) (version 1.26 or later)

---

### Development

1. **Clone the repository**

   ```bash
   git clone https://github.com/kakada/chatfuel.git
   cd chatfuel
   ```

2. **Configure environment variables**

   ```bash
   cp app.env.example app.env
   ```

   Open `app.env` and fill in the required values (database credentials, API tokens, etc.).

3. **Build and start the containers**

   ```bash
   docker-compose up --build
   ```

   This starts the following services:
   - `db` — PostgreSQL 12
   - `redis` — Redis 5
   - `web` — Rails application on port `3000`
   - `sidekiq` — Background job processor
   - `ngrok` — Tunnel for exposing `localhost:3000` publicly (dashboard at `http://localhost:4040`)

4. **Set up the database** (first run only)

   ```bash
   docker-compose exec web bundle exec rails db:create db:migrate db:seed
   ```

5. **Access the application**

   Open your browser at [http://localhost:3000](http://localhost:3000).

---

### Production

1. **Configure environment variables**

   ```bash
   cp docker-env.example docker-env
   ```

   Edit `docker-env` and set all required values, paying particular attention to:
   - `DATABASE_URL` — PostgreSQL connection string
   - `REDIS_URL` — Redis connection URL
   - `RAILS_MASTER_KEY` — Rails credentials master key
   - `VIRTUAL_HOST` / `LETSENCRYPT_HOST` — Your domain name
   - `LETSENCRYPT_EMAIL` — Email used for Let's Encrypt certificates

2. **Pull the application image and start the stack**

   ```bash
   docker-compose -f docker-compose.prod.yml up -d
   ```

   This starts the following services:
   - `db` — PostgreSQL 12
   - `redis` — Redis 5
   - `app` — Rails application (puma, port 80)
   - `sidekiq` — Background job processor
   - `nginx-proxy` — Nginx reverse proxy (ports 80 and 443)
   - `letsencrypt` — Automatic TLS certificate management

3. **Set up the database** (first run only)

   ```bash
   docker-compose -f docker-compose.prod.yml exec app bundle exec rails db:create db:migrate db:seed
   ```

4. **Access the application**

   The application is served by the Nginx proxy at the domain configured in `VIRTUAL_HOST`.

---

## How it works?

1. First, user communicate with chatbot in facebook page
2. Chatfuel will collect info (user's attributes) that user input and send to our rails app , in this case __chatfuel-rails__
3. __chatfuel-rails__ grabs those attributes through rails params, then, process result and response to chatfuel via JSON response
4. It is possible to redirect to blocks dynamically, base on app logic.


## Plugins

- _set user attribute_ : use to capture value that user answer in messager.
- _json api_ : use to send request, unidirect flow from chatfuel to rails app
- _redirect to blocks_ : redirect user to specific block in design flow

## Challenge

- __re-engagement__
  - _story_: send remind static message to user if he/she does not complete questionair form.
  - subscribe user to a sequence, then unsubscribe once finish.

- __advance re-engagement__
  - _story_: as a chat admin, The bot should follow up the user only question that he/she does not answer yet or not yet complete the current form.
  - _solution_: keep track for each question, redirect user to last block, which is where his/her question that not yet complete.

## For more defail,

- [Chatfuel doc](https://docs.chatfuel.com/en/)
