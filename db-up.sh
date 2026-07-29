#!/usr/bin/env zsh
# ==============================================================================
# Function: db-up
# Description: Parses a local YAML-styled .env file, validates critical 
#              PostgreSQL configurations, and initializes an isolated, 
#              persistent Docker Postgres container.
# Multi-Schema: Isolates container and volume naming by the POSTGRES_DB value, 
#               allowing multiple unique database schemas to run simultaneously.
# Dependencies: Zsh shell, Docker CLI
# Required Env: POSTGRES_USER, POSTGRES_PASS, POSTGRES_DB, POSTGRES_PORT
# ==============================================================================

db-up() {
  local env_file=".env"

  if [ ! -f "$env_file" ]; then
    echo "Error: $env_file file not found in the current directory."
    return 1
  fi

  # Read and export values cleanly
  while IFS= read -r line || [ -n "$line" ]; do
    # Strip carriage returns (fixes Windows line endings), skip comments and blanks
    line="${line//$'\r'/}"
    [[ "$line" =~ ^# ]] && continue
    [[ -z "${line//[[:space:]]/}" ]] && continue
    
    # Extract keys and values split by the first colon
    local key="${line%%:*}"
    local val="${line#*:}"
    
    # Trim whitespace and quotes entirely using native Zsh modifiers
    key="${key##[[:space:]]}"
    key="${key%%[[:space:]]}"
    val="${val##[[:space:]]}"
    val="${val%%[[:space:]]}"
    val="${val##\"}"
    val="${val%%\"}"
    
    if [ -n "$key" ] && [ -n "$val" ]; then
      export "$key"="$val"
    fi
  done < "$env_file"

  # Validation checklist for required fields
  local required_vars=(POSTGRES_USER POSTGRES_PASS POSTGRES_DB POSTGRES_PORT)
  local missing=0

  for var in "${required_vars[@]}"; do
    if [ -z "${(P)var}" ]; then
      echo "Error: Required variable $var is missing or empty."
      missing=1
    fi
  done

  if [ $missing -eq 1 ]; then
    return 1
  fi

  # Default optional connection pool variables if empty
  [ -z "$POSTGRES_MAX_CONNECTIONS" ] && POSTGRES_MAX_CONNECTIONS=100

  # Dynamic naming using the DB name allows multiple unique schemas to run at once
  local container_name="postgres-${POSTGRES_DB}"
  local volume_name="pgdata-${POSTGRES_DB}"

  echo "Starting database container: ${container_name} on port ${POSTGRES_PORT}..."

  docker run -d \
    --name "$container_name" \
    -e POSTGRES_USER="$POSTGRES_USER" \
    -e POSTGRES_PASSWORD="$POSTGRES_PASS" \
    -e POSTGRES_DB="$POSTGRES_DB" \
    -v "${volume_name}:/var/lib/postgresql/data" \
    -p "${POSTGRES_PORT}:5432" \
    postgres:17 \
    -c max_connections="$POSTGRES_MAX_CONNECTIONS"
}
