# Local PostgreSQL Docker Provisioner (`db-up`)

`db-up` is a lightweight zsh automation utility designed to bootstrap persistent, isolated PostgreSQL containers directly from project-level environment variables. 

## Features

- **Multi-Schema Multi-Tenant Isolation**: Dynamically generates unique container and Docker volume names based on your target database name (`postgres-${POSTGRES_DB}`). This allows you to run multiple distinct databases concurrently without naming or port collisions.
- **Strict Environment Validation**: Verifies the presence of required infrastructure variables before executing Docker commands to prevent half-baked or broken container spin-ups.
- **Native Parsing**: Safely processes key-value pairs formatted with colons (`KEY: "VALUE"`), strips enclosing quotes, eliminates line spaces, and neutralizes cross-platform Windows line endings (`\r`) without relying on brittle third-party CLI text-parsers like `xargs`.

## Prerequisites

- **Shell**: zsh
- **Containerization**: Docker Engine installed and running locally.

## Configuration File

The function automatically targets a file named `.env` in your current working terminal directory. The file must use the following configuration structure:

```env
POSTGRES_HOST: "127.0.0.1"
POSTGRES_PORT: 5432
POSTGRES_USER: "pg_user"
POSTGRES_PASS: "pg_pass"
POSTGRES_DB: "pg_db_name"
POSTGRES_MAX_CONNECTIONS: 10
POSTGRES_MIN_CONNECTIONS: 2
```

*Note: `POSTGRES_USER`, `POSTGRES_PASS`, `POSTGRES_DB`, and `POSTGRES_PORT` are strictly required.*

## Usage

Navigate to your target project folder containing your `.env` configuration file and run the following command:

```bash
db-up
```

### Script Execution Workflow

1. The function scans for a local `.env` file in the current directory.
2. It strips whitespace, strips quotes, extracts configuration variables, and exports them directly into your current shell memory environment.
3. The function validates that all 4 required database parameters contain actionable non-empty strings.
4. If valid, it provisions a persistent storage backing volume named `pgdata-[YOUR_DATABASE_NAME]`.
5. It runs a background Docker container utilizing the official **PostgreSQL 17** base image, setting internal configurations like `max_connections`.
