## Story

Why do some sessions missing?

Some sessions are completely lose from step values (currently cannot find the root cause yet), therefore, we need to download raw data from chatfuel and manually clone into step values.

In order to download chatfuel raw session data go to

. Goto chatfuel dashboard
. Select the bot
. Goto people tab
. Export users

## Howto

1. After download raw chatfuel data
2. Import raw chatfuel data into a [google spreadsheet](https://docs.google.com/spreadsheets/d/1hXPUAIhfPHOf7c2HiiUpLhm17wn0YKdVLwK1lEnxozU/edit#gid=0)
3. Next, dump sessions data(see in scripts section) from database and import into the same spreadsheet in different tab
4. Correct data using vlookup
5. Export the corrected sessions into the root project directory
6. Run rake task (see in scripts section) to check and clone appropriate step value,
   by default, it is expected to a file named `corrected-data.csv` if not, you have to explicitly provide the corrected csv file, otherwise it raises an error.

## Thing to keep in mind when correcting the data

1. correct flow hierachy
   eg. `feedback unit` -> `feedback province` -> `feedback district`
   this mean that `feedback district` **CANNOT** be exists without `feedback unit` and `feedback province`
   but `feedback unit` **CAN** be exists without `feedback province` and `feedback district`

2. consistent location
   eg. feedback province = 02, feedback district = 02xx

3. OWSU location
   eg. feedback district must ends with xx99

## Scripts

1. Dump chatbots sessions who provide incompleted feedback in November
   Note: completed feedback has to answer feedback unit, feedback province, feedback district

```
docker exec -i chatfuel_db_1 psql -U postgres -d chatfuel_development -c "Copy (
  WITH feedback_sessions AS (
  SELECT s.id
    FROM sessions s
        INNER JOIN step_values st on s.id = st.session_id
        INNER JOIN variables v on st.variable_id=v.id
        WHERE v.name IN ('feedback_unit', 'feedback_province', 'feedback_district')
        AND DATE(s.engaged_at) BETWEEN '2021-11-01' AND '2021-11-30' AND
        s.platform_name='Messenger'
        GROUP BY s.id
        HAVING COUNT(*) < 3
)

SELECT s.id, s.session_id,
  MAX(CASE WHEN v.name = 'feedback_unit' THEN vv.raw_value END) feedback_unit,
  MAX(CASE WHEN v.name = 'feedback_province' THEN vv.raw_value END) feedback_province,
  MAX(CASE WHEN v.name = 'feedback_district' THEN vv.raw_value END) feedback_district
  FROM sessions s

  INNER JOIN step_values st ON s.id=st.session_id
  INNER JOIN variables v ON st.variable_id=v.id
  INNER JOIN variable_values vv ON st.variable_value_id=vv.id
  WHERE s.id IN ( SELECT id FROM feedback_sessions )
  GROUP BY s.id
  ORDER BY s.session_id) To STDOUT With CSV HEADER DELIMITER ',';" > feedback_sessions.csv
```

2. After corrected sessions, run the following to migrate the missing step values that are missing

```
rails chatfuel:migrate_missing_from_raw_data # expected to have corrected-data.csv in root directory
or
rails chatfuel:migrate_missing_from_raw_data['path/to/corrected-data.csv']
```
