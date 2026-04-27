CREATE TABLE IF NOT EXISTS media_assets (
  id BIGSERIAL PRIMARY KEY,
  session_id TEXT NOT NULL,
  telegram_file_id TEXT NOT NULL,
  telegram_file_unique_id TEXT,
  file_name TEXT,
  mime_type TEXT,
  local_path TEXT,
  caption TEXT,
  extracted_text TEXT,
  summary TEXT,
  source_message_date TIMESTAMP,
  expires_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_media_assets_session_created
  ON media_assets (session_id, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_media_assets_active
  ON media_assets (session_id, expires_at)
  WHERE expires_at IS NULL;

COMMENT ON TABLE media_assets IS
  'Planned metadata table for Telegram photos, documents, PDFs, and voice attachments.';

