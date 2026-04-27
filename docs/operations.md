# Operations Runbook

## Check Containers

```bash
docker compose ps
```

Expected core services:

- `db`
- `proxy`
- `n8n`
- `nginx-proxy`
- `duckdns`

## Check n8n Health

```bash
curl -I http://127.0.0.1:5678/
curl -k -I https://example.duckdns.org/
docker logs --tail 100 ai-agent-n8n-1
```

`HTTP 200` from n8n means the editor is reachable.

## Debug a Failed Execution

Find recent executions:

```sql
SELECT id, status, mode, "workflowId", "startedAt", "stoppedAt"
FROM execution_entity
ORDER BY id DESC
LIMIT 10;
```

Inspect saved execution data:

```sql
SELECT data
FROM execution_data
WHERE "executionId" = <execution_id>;
```

Common failure classes:

- model provider quota exceeded;
- outbound proxy is expired or unavailable;
- Telegram trigger cannot register webhook;
- Google Calendar credential expired;
- SQL tool generated invalid parameters.

## Check Outbound Proxy

```bash
docker logs --tail 100 proxy-agent
```

Minimal proxy smoke test from the n8n container:

```bash
docker exec ai-agent-n8n-1 node -e '
const { setGlobalDispatcher, EnvHttpProxyAgent } = require("undici");
setGlobalDispatcher(new EnvHttpProxyAgent());
fetch("https://api.ipify.org?format=json").then(r => r.text()).then(console.log);
'
```

## Connect to PostgreSQL

```bash
docker exec -it ai-agent-db-1 psql -U "$POSTGRES_USER" -d "$POSTGRES_DB"
```

Useful memory query:

```sql
SELECT id, session_id, category, priority, is_core, expires_at, content
FROM user_context
WHERE expires_at IS NULL OR expires_at > CURRENT_TIMESTAMP
ORDER BY is_core DESC, priority DESC, updated_at DESC;
```

