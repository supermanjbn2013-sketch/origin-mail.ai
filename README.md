# ORIGIN MAIL AI

Private email inbox for testing applications and services that you own or are authorized to test.

## What this first version does

- Captures real messages sent by your test application over SMTP.
- Stores messages persistently in a local database.
- Provides a browser dashboard to inspect message content, headers, HTML and attachments.
- Supports live dashboard updates when new test messages arrive.
- Keeps the dashboard and SMTP listener bound to localhost by default.

This is a private QA mail catcher. It is not a public disposable-email provider and does not create accounts at third-party platforms or generate artificial engagement.

## Requirements

- A Linux server or computer with Docker Engine and the Docker Compose plugin.
- A browser.
- An HTTPS reverse proxy if you need to access the dashboard remotely.

## Start

1. Copy `.env.example` to `.env`.
2. Replace `CHANGE_THIS_TO_A_LONG_RANDOM_PASSWORD` with a unique, long password.
3. Start the service:

   ```sh
   docker compose up -d
   ```

4. Open `http://127.0.0.1:8025` on the server, or access it through a properly secured HTTPS reverse proxy.
5. Sign in using the username and password from `MP_UI_AUTH`.

## Configure your test application

For an application running on the same host, configure its SMTP settings as:

- Host: `127.0.0.1`
- Port: `1025`
- Encryption: disabled for loopback-only development
- Authentication: disabled unless you configure SMTP authentication separately

For an application running in another Docker container, attach both services to the same private Docker network and use the Mailpit service hostname `mailpit` and port `1025`.

Send only test messages from systems you control or are authorized to test. Do not expose the unauthenticated SMTP port to the public internet.

## Remote dashboard access

The dashboard is bound to `127.0.0.1:8025` intentionally. To access it from your phone or another device, configure a reverse proxy with HTTPS and keep authentication enabled. Do not change the binding to `0.0.0.0` on an internet-facing server without a deliberate network and access-control setup.

## Real-time updates and API

Mailpit includes a REST API under `/api/v1/` and a WebSocket event endpoint at `/api/events`. The dashboard uses live updates for newly captured messages. The WebSocket event format is documented by Mailpit but is not part of its stable official API, so integrations should tolerate changes.

## Important limitation

Mailpit captures messages delivered to its SMTP server. It does not receive mail addressed to arbitrary public domains through the internet. Receiving internet mail for a domain requires a separately configured inbound mail server, DNS MX records, spam/abuse controls, TLS, and domain-level authorization. That is not enabled in this private QA starter.

## Stop and update

```sh
docker compose down
docker compose pull
docker compose up -d
```

Persistent messages remain in the local `data/` directory when the container is stopped or updated. Protect that directory and your `.env` file.
