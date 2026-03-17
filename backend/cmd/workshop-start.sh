#!/bin/bash
# Workshop quick-start: one command to a working backend
set -e

cd "$(dirname "$0")/.."

# Create .env from example if missing
if [ ! -f .env ]; then
  cp .env.example .env
  echo "Created .env from .env.example"
else
  echo ".env already exists, skipping copy"
fi

# Load environment
set -a
source .env
set +a

DB_FILE=${DB_FILE:-db/development.sqlite3}

# Initialize DB + create admin user if DB doesn't exist
if [ ! -f "$DB_FILE" ]; then
  mkdir -p "$(dirname "$DB_FILE")"

  echo "Initializing database..."
  node scripts/db-init.js

  echo "Creating admin user..."
  node scripts/user-create.js \
    "${TUDUDI_USER_EMAIL:-admin@example.com}" \
    "${TUDUDI_USER_PASSWORD:-password123}" \
    true
else
  echo "Database already exists at $DB_FILE"
fi

echo ""
echo "============================================="
echo "  Backend ready! Login with:"
echo "  Email:    ${TUDUDI_USER_EMAIL:-admin@example.com}"
echo "  Password: ${TUDUDI_USER_PASSWORD:-password123}"
echo "============================================="
echo ""

exec npx nodemon app.js
