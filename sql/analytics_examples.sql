-- Active memory by priority.
SELECT
  session_id,
  category,
  is_core,
  priority,
  confidence,
  updated_at,
  content
FROM user_context
WHERE expires_at IS NULL OR expires_at > CURRENT_TIMESTAMP
ORDER BY session_id, is_core DESC, priority DESC, updated_at DESC;

-- Core vs searchable memory distribution.
SELECT
  session_id,
  is_core,
  count(*) AS memory_count
FROM user_context
WHERE expires_at IS NULL OR expires_at > CURRENT_TIMESTAMP
GROUP BY session_id, is_core
ORDER BY session_id, is_core DESC;

-- Expired memory audit trail.
SELECT
  id,
  session_id,
  category,
  source,
  expires_at,
  content
FROM user_context
WHERE expires_at IS NOT NULL
ORDER BY expires_at DESC;

-- Recent n8n executions for the scheduling workflow.
SELECT
  id,
  status,
  mode,
  "workflowId",
  "startedAt",
  "stoppedAt",
  EXTRACT(EPOCH FROM ("stoppedAt" - "startedAt")) AS duration_seconds
FROM execution_entity
ORDER BY id DESC
LIMIT 20;

-- Chat history volume by session.
SELECT
  session_id,
  count(*) AS messages
FROM n8n_chat_histories
GROUP BY session_id
ORDER BY messages DESC;

