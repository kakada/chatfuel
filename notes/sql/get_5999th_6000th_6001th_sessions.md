## Story

Get the sessions of 5999th, 6000th, 6001th.

```sql
SELECT session_id, created_at FROM (
  SELECT DISTINCT ON (session_id) session_id, created_at
  FROM sessions
  ORDER BY session_id, created_at ASC
) t
ORDER BY created_at ASC
offset 5998
LIMIT 3;
```
