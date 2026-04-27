# Calendar Integration

The agent uses two calendar surfaces.

## Personal Calendar

The personal calendar is writable. The agent can:

- list events;
- get a single event;
- create events;
- update events;
- delete events.

The workflow instructs the agent to search for a matching event before updating or deleting when the event id is unknown.

## University Schedule Calendar

The university schedule calendar is read-only.

The agent uses it to:

- answer questions about classes;
- detect free windows;
- avoid planning personal tasks over university classes.

It must not create, update, or delete events in this calendar.

## Future Improvement: Schedule Cache

For data-engineering depth, the university calendar can be periodically ingested into a normalized table:

```sql
calendar_events_cache (
  id,
  source_calendar,
  external_event_id,
  title,
  starts_at,
  ends_at,
  location,
  description_hash,
  loaded_at
)
```

This would enable:

- SQL analytics over study load;
- conflict detection without live API calls;
- historical changes in university schedules;
- dashboards for weekly time allocation.

