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
3. Next, dump sessions data from database and import into the same spreadsheet in different tab
4. Correct data using vlookup
5. Export the corrected sessions
6. Run rake task to check and clone appropriate step value

## Thing to keep in mind when correcting the data

1. correct flow hierachy
   eg. `feedback unit` -> `feedback province` -> `feedback district`
   this mean that `feedback district` **CANNOT** be exists without `feedback unit` and `feedback province`
   but `feedback unit` **CAN** be exists without `feedback province` and `feedback district`

2. consistent location
   eg. feedback province = 02, feedback district = 02xx

3. OWSU location
   eg. feedback district must ends with xx99
