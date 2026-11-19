# ORIGIN MAIL AI

Private email inbox for testing applications and services that you own or are authorized to test.

## What this first version does

- Captures real messages sent by your test application over SMTP.
- Stores messages persistently in a local database.
- Provides a browser dashboard to inspect message content, headers, HTML and attachments.
- Provides live dashboard updates when new test messages arrive.
- Supports secure HTTPS access from a phone or computer through Caddy.
- Protects the dashboard and API with a username and password.

This is a private QA mail catcher. It is not a public disposable-email provider and does not create accounts at third-party platforms or generate artificial engagement.

## Why this uses Mailpit rather than Mail.tm

Mail.tm is a temporary-email API. Its published terms prohibit reselling a wrapper around its API and proxying or mirroring the API under another domain; it also requires attribution. ORIGIN MAIL AI is being built as a private QA inbox for systems you control, so this starter uses Mailpit to capture test messages sent by your own applications instead. See [Mail.tm's API documentation](https://docs.mail.tm/) and its published usage policy.

## Requirements

- A Linux server or computer with Docker Engine and the Docker Compose plugin.
- A domain name whose DNS points to that server.
- Ports 80 and 443 reachable from the internet for automatic HTTPS.
- A browser.

## Configure and start

1. Edit `.env.example` and set `DOMAIN` to your real domain or subdomain, such as `mail.yourdomain.com`.
2. Make sure the domain's DNS A/AAAA record points to the server.
3. Allow inbound TCP ports 80 and 443 through the server firewall.
4. Run the setup helper:

   ```sh
   bash setup.sh
   ```

The helper creates `.env`, generates a strong dashboard password, validates the Compose configuration, and starts the services. Keep `.env` private. If you prefer manual setup, copy `.env.example` to `.env`, set a strong unique value for `MP_UI_AUTH`, then run `docker compose up -d`.

Open `https://your-domain.example` on your phone or computer and sign in using the username and password from `MP_UI_AUTH`.

Caddy obtains and renews HTTPS certificates automatically when DNS and network access are configured correctly.

## Configure your test application

For an application running on the same host, configure its SMTP settings as:

- Host: `127.0.0.1`
- Port: `1025`
- Encryption: disabled for loopback-only development
- Authentication: disabled unless you configure SMTP authentication separately

For an application running in another Docker container, attach both services to the same private Docker network and use the Mailpit service hostname `mailpit` and port `1025`.

Send only test messages from systems you control or are authorized to test. Do not expose the unauthenticated SMTP port to the public internet.

## Real-time updates and API

Mailpit includes a REST API under `/api/v1/` and a WebSocket event endpoint at `/api/events`. Its dashboard updates live when new test messages arrive. The WebSocket event format is not part of its stable official API, so custom integrations should tolerate changes.

## Important limitation

Mailpit captures messages delivered to its SMTP server. It does not receive mail addressed to arbitrary public domains through the internet. Receiving internet mail for a domain requires a separately configured inbound mail server, DNS MX records, spam/abuse controls, TLS, and domain-level authorization. That is not enabled in this private QA starter.

## Stop and update

```sh
docker compose down
docker compose pull
docker compose up -d
```

Persistent messages remain in the local `data/` directory when the container is stopped or updated. Protect that directory and your `.env` file.
