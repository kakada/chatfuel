## Story

Get top 2 latest sessions who access to `main_dbs` in verboice and messenger

```sql
select * from (
  SELECT sessions.id, sessions.session_id,
    platform_name, sessions.created_at ,
    gender,
    rank() over ( partition by platform_name order by sessions.created_at desc)
    FROM "sessions"
    INNER JOIN "step_values"
    ON "step_values"."session_id" = "sessions"."id"
    WHERE "sessions"."gender" = 'female' AND
          -- variable_id=33 => owso_info
          "step_values"."variable_id" = 33 AND
          "step_values"."variable_value_id" IN (
              SELECT "variable_values"."id" FROM "variable_values"
                WHERE "variable_values"."variable_id" = 33
                -- raw_value = 2 (verboice)
                -- raw_value = 'main_dbs' (chatbot)
                AND "variable_values"."raw_value" IN ('2', 'main_dbs')
                ORDER BY "variable_values"."mapping_value_en" ASC
            )
      ORDER BY "sessions"."created_at" DESC
-- top 2
) tmp where rank <=2;
```
