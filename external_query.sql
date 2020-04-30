/* Get the most-recently-correct DAILY batch for each state, for 3/20. (Respects historical edits, takes latest batch_id) */
SELECT state_name, MAX(core_data.batch_id) as max_bid
	FROM core_data INNER JOIN batch ON core_data.batch_id = batch.batch_id
    WHERE data_date = '2020-03-20' AND batch.data_entry_type = 'daily_push' AND batch.is_published = TRUE
    GROUP BY state_name;
	
/* Get the most-recently-correct DAILY batch for each state, for all dates. (Respects historical edits, takes latest batch_id) */
SELECT state_name, data_date, MAX(core_data.batch_id) as max_bid
	FROM core_data INNER JOIN batch ON core_data.batch_id = batch.batch_id
    WHERE batch.data_entry_type = 'daily_push' AND batch.is_published = TRUE
	GROUP BY state_name, data_date;

/* Latest preview batch? */
SELECT MAX(batch_id) as max_bid FROM batch WHERE batch.is_published = FALSE;
	
/* What is our info for all states on 3/20? */
/* Get the latest DAILY data for 2020-03-20 by state. This incorporates historical edits, showing the latest one. (Expected: NY 175, PA 131.) */
SELECT * FROM (
	SELECT state_name, MAX(core_data.batch_id) as max_bid
		FROM core_data INNER JOIN batch ON core_data.batch_id = batch.batch_id
		WHERE data_date = '2020-03-20' AND batch.data_entry_type = 'daily_push' AND batch.is_published = TRUE
		GROUP BY state_name) AS latest_daily_state_batches
	INNER JOIN core_data ON (
		core_data.batch_id = latest_daily_state_batches.max_bid AND
		core_data.state_name = latest_daily_state_batches.state_name)
	INNER JOIN batch ON (core_data.batch_id = batch.batch_id)
	WHERE data_date = '2020-03-20';

/* What's the latest non-preview batch for each state? */
SELECT state_name, MAX(core_data.batch_id) as max_bid
	FROM core_data INNER JOIN batch ON core_data.batch_id = batch.batch_id
    WHERE batch.is_published = TRUE
    GROUP BY state_name;
	
SELECT MAX(data_date) FROM core_data;
	
/* States current: What's the latest published (non-preview) data for all states?
As written, this assumes that the latest date published for any state is the most recent for all states.
*/
WITH temp (latest_date) AS (SELECT MAX(data_date) FROM core_data)
SELECT * FROM (
	SELECT state_name, MAX(core_data.batch_id) as max_bid
		FROM temp,core_data INNER JOIN batch ON core_data.batch_id = batch.batch_id
		WHERE batch.is_published = TRUE AND core_data.data_date = temp.latest_date
		GROUP BY state_name) AS latest_state_batches
	INNER JOIN core_data ON (
		core_data.batch_id = latest_state_batches.max_bid AND
		core_data.state_name = latest_state_batches.state_name)
	INNER JOIN batch ON (core_data.batch_id = batch.batch_id);
	
/* States daily: What's the published daily data for all states, incorporating all edits? */
SELECT * FROM (
	SELECT state_name, data_date, MAX(core_data.batch_id) as max_bid
		FROM core_data INNER JOIN batch ON core_data.batch_id = batch.batch_id
		WHERE batch.data_entry_type = 'daily_push' AND batch.is_published = TRUE
		GROUP BY state_name, data_date) AS latest_state_daily_batches
	INNER JOIN core_data ON (
		core_data.batch_id = latest_state_daily_batches.max_bid AND
		core_data.state_name = latest_state_daily_batches.state_name AND
		core_data.data_date = latest_state_daily_batches.data_date);

/* What is the daily commit history for NY? Also shows history of changes to daily commits */
SELECT * FROM core_data JOIN batch ON core_data.batch_id = batch.batch_id
	WHERE batch.data_entry_type = 'daily_push' AND batch.is_published = TRUE AND core_data.state_name = 'NY';
	
/* Latest preview data? This works even if preview has been written more than once. */
SELECT * FROM (
	SELECT MAX(batch_id) as max_bid FROM batch WHERE batch.is_published = FALSE) AS latest_preview_batch
	INNER JOIN core_data ON (
		core_data.batch_id = latest_preview_batch.max_bid);
