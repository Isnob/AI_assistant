#!/usr/bin/env bash
set -euo pipefail

docker exec -it ai-agent-db-1 psql -U "${POSTGRES_USER:-n8n}" -d "${POSTGRES_DB:-n8n_data}"

