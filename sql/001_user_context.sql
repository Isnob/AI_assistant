CREATE TABLE IF NOT EXISTS user_context (
  id SERIAL PRIMARY KEY,
  session_id TEXT DEFAULT 'global',
  category TEXT,
  content TEXT NOT NULL,
  priority INT DEFAULT 5,
  source TEXT DEFAULT 'manual',
  is_core BOOLEAN DEFAULT false,
  confidence REAL DEFAULT 1.0,
  expires_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_user_context_session_core
  ON user_context (session_id, is_core, priority DESC, updated_at DESC);

CREATE INDEX IF NOT EXISTS idx_user_context_active_lookup
  ON user_context (session_id, category, priority DESC, updated_at DESC)
  WHERE expires_at IS NULL;

COMMENT ON TABLE user_context IS
  'Curated long-term memory for the Telegram scheduling agent.';

COMMENT ON COLUMN user_context.session_id IS
  'Conversation owner, usually telegram:<chat_id>.';

COMMENT ON COLUMN user_context.is_core IS
  'Whether the memory should be included in every prompt.';

COMMENT ON COLUMN user_context.expires_at IS
  'Soft-delete or TTL marker. Active rows have NULL or future expires_at.';

