# Stock Exchange Project

## Coolify deployment

This repo includes a Docker Compose stack for Coolify with:

- `database`: PostgreSQL
- `api`: Laravel API
- `admin`: Flutter web admin panel
- `staff`: Flutter web staff panel
- `customer`: Flutter web customer panel

## Local staff site

If you want the staff site to open locally in a browser with a fixed hostname,
use `docker-compose.staff.local.yml`.

What it does:

- starts PostgreSQL, the Laravel API, and the staff web app together
- publishes the API on `http://localhost:8000`
- publishes the staff site on port `80`
- uses `restart: unless-stopped` so Docker can bring it back automatically

One-time Windows hosts entry:

```text
127.0.0.1 ltmsstaffku
```

After that, if the stack is running, open:

```text
http://ltmsstaffku
```

Optional helper on Windows:

```text
scripts/start-ltmsstaffku.ps1
```

It requests administrator rights, adds the hosts entry, starts Docker if needed,
brings up `docker-compose.staff.local.yml`, and opens the site.

### Required environment variables in Coolify

- `APP_KEY`
- `DB_DATABASE`
- `DB_USERNAME`
- `DB_PASSWORD`
- `API_BASE_URL`

Suggested public URLs for server `45.32.155.226`:

These are public application domains after deployment. Do not use them as the
Compose file path in Docker tooling or Coolify; point those tools at a
repository file such as `docker-compose.yml` or `docker-compose.staff.local.yml`.

- `https://ltsmapi.45.32.155.226.sslip.io`
- `https://ltsmadmin.45.32.155.226.sslip.io`
- `https://ltsmstaff.45.32.155.226.sslip.io`
- `https://ltsmcustomer.45.32.155.226.sslip.io`

Use:

```text
API_BASE_URL=https://ltsmapi.45.32.155.226.sslip.io
```

### Deploy in Coolify

1. Create a new `Docker Compose` resource in Coolify and connect this Git repository.
2. Use `docker-compose.yml` if you want the full stack (`database`, `api`, `admin`, `staff`, `customer`).
3. Use `docker-compose.backend.yml` if you want to deploy only the backend API and PostgreSQL database first.
4. Use `docker-compose.customer.yml` only if you want to deploy the customer frontend as a separate resource.
5. Add the required environment variables in Coolify before the first deployment.
6. After deployment, attach domains to the services:
   - `api` -> `ltsmapi.45.32.155.226.sslip.io`
   - `admin` -> `ltsmadmin.45.32.155.226.sslip.io`
   - `staff` -> `ltsmstaff.45.32.155.226.sslip.io`
   - `customer` -> `ltsmcustomer.45.32.155.226.sslip.io`

### Default seeded accounts

- Super admin: `admin@ltms.app`
- Staff: `staff@ltms.app`
- Driver: `driver@ltms.app`

If you do not override the seed passwords in Coolify, the default password is `password`.
