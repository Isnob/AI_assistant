# Memory Design

The bot uses three memory layers.

## 1. Short-Term Chat Memory

Stored in `n8n_chat_histories` by the n8n LangChain Postgres Chat Memory node.

Purpose:

- keep recent conversation context;
- allow follow-up messages;
- avoid manual prompt construction for every past message.

The agent does not curate this table. n8n writes it automatically.

## 2. Core Long-Term Memory

Stored in `user_context` with:

```sql
is_core = true
```

Only active rows are loaded:

```sql
expires_at IS NULL OR expires_at > CURRENT_TIMESTAMP
```

Core memory is included in every agent request. It should stay small and contain only high-signal facts:

- stable time constraints;
- standing schedule rules;
- critical preferences;
- important current goals.

## 3. Searchable Long-Term Memory

Stored in `user_context` with `is_core = false`.

This data is not included in every prompt. The agent calls `Search Long-Term Memory` when it needs more context about:

- a project;
- a course;
- a goal;
- a deadline;
- a recurring commitment;
- previous planning preferences.

## Memory Tools

### Save Long-Term Memory

Inserts a new active row into `user_context`.

The tool asks the model for:

- category;
- content;
- priority;
- is_core;
- confidence;
- optional expiration.

It avoids inserting exact active duplicates.

### Search Long-Term Memory

Returns active rows for the current session or global scope. Results include ids so the agent can manage exact rows later.

### Manage Long-Term Memory

Supports two patterns.

Delete/forget:

```sql
UPDATE user_context
SET expires_at = CURRENT_TIMESTAMP,
    updated_at = CURRENT_TIMESTAMP,
    source = 'agent'
WHERE id = :memory_id;
```

Edit/replace:

1. expire the old row;
2. insert a new corrected row.

This intentionally creates an audit trail instead of overwriting history.

