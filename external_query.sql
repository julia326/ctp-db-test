USE data;

/* Gets the latest DAILY batch for each state, for the given data date. */
SELECT state, MAX(states.batch_id) as max_bid
	FROM states JOIN batch ON states.batch_id = batch.batch_id
    WHERE data_date = '2020-03-20' AND batch.daily_commit = True
    GROUP BY state;
    
-- What were all states on date Z? For this example, say Z is 2020-03-20.
/* Get the latest DAILY data for 2020-03-20 by state. This incorporates historical edits, showing the latest one. (Expected: NY 175, PA 131.) */
SELECT * FROM (
	SELECT state, MAX(states.batch_id) as max_bid
		FROM states JOIN batch ON states.batch_id = batch.batch_id
		WHERE data_date = '2020-03-20' AND batch.daily_commit = True
		GROUP BY state) AS latest_daily_state_batches
	JOIN states JOIN batch ON states.batch_id = batch.batch_id
    WHERE data_date = '2020-03-20' AND states.batch_id = latest_daily_state_batches.max_bid AND states.state = latest_daily_state_batches.state;

-- What are all states right now? For this example, let's say today's date is 2020-03-21.
/* Get the latest data for today's date, by state. Should be: NY 190, PA 150. Resolves edit conflicts. Works for any date, including today. */
SELECT * FROM (
	SELECT state, MAX(batch_id) as max_bid FROM states WHERE data_date='2020-03-21' GROUP BY state
	) AS x 
    JOIN states
    WHERE data_date='2020-03-21' AND states.batch_id=x.max_bid AND states.state=x.state;

-- What is the daily commit history for state Y? For this example, say for NY. This also shows the history of edits to daily commits.
SELECT * FROM states JOIN batch ON states.batch_id = batch.batch_id
	WHERE batch.daily_commit = True AND states.state = 'NY';
