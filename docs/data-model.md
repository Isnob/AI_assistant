# Data Model

## Core Tables

### `n8n_chat_histories`

Managed by n8n LangChain Postgres Chat Memory.

| Column | Purpose |
| --- | --- |
| `id` | Row id. |
| `session_id` | Conversation key, usually `telegram:<chat_id>`. |
| `message` | JSONB message object stored by LangChain. |

This table is raw conversational history. It can contain model-specific metadata and should not be treated as curated memory.

### `user_context`

Custom table for durable, curated memory.

| Column | Purpose |
| --- | --- |
| `id` | Stable memory id used by tools. |
| `session_id` | Owner scope, usually `telegram:<chat_id>`. |
| `category` | Memory class: preference, goal, constraint, schedule_rule, recurring_commitment, personal_fact, project_fact. |
| `content` | Concise natural-language fact. |
| `priority` | Importance from 1 to 10. |
| `source` | `manual` or `agent`. |
| `is_core` | Include in every prompt when active. |
| `confidence` | Confidence from 0 to 1. |
| `expires_at` | TTL or soft-delete timestamp. |
| `created_at` | Insert timestamp. |
| `updated_at` | Last update timestamp. |

Active rows satisfy:

```sql
expires_at IS NULL OR expires_at > CURRENT_TIMESTAMP
```

### `media_assets`

Planned table for Telegram attachments.

It stores metadata and extracted text/summaries, while the binary file itself should live on disk or object storage.

## Session Strategy

The production workflow uses:

```text
telegram:<chat_id>
```

as the primary session key. This supports multiple Telegram users at the memory layer even before adding per-user Google OAuth and per-user LLM credentials.

