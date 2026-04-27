# Screenshot Checklist

This repository is ready for screenshots, but the actual images should be added manually to avoid leaking private Telegram messages, calendar data, tokens, or n8n credentials.

## Recommended Screenshots

| File | What to show | Privacy notes |
| --- | --- | --- |
| `assets/screenshots/n8n-workflow.png` | Full n8n canvas with the Telegram trigger, AI Agent, memory tools, and calendar tools visible. | Blur credential names if needed. |
| `assets/screenshots/telegram-demo.png` | A Telegram conversation where the bot plans a schedule or creates an event. | Hide phone number, chat id, and personal messages. |
| `assets/screenshots/calendar-event-created.png` | Google Calendar after the bot created or edited an event. | Use a test event, not a real private event. |
| `assets/screenshots/postgres-memory-query.png` | Query result from `user_context` showing core/searchable memory. | Use synthetic sample rows. |

## README Embeds

After adding files, embed them in `README.md`:

```md
![n8n workflow](assets/screenshots/n8n-workflow.png)
![Telegram demo](assets/screenshots/telegram-demo.png)
![Calendar event](assets/screenshots/calendar-event-created.png)
![Postgres memory](assets/screenshots/postgres-memory-query.png)
```

