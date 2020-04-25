TRUNCATE core_data;
TRUNCATE batch CASCADE;
TRUNCATE states CASCADE;

/* make two states, NY and PA */
INSERT INTO states VALUES ('NY', 'New York');
INSERT INTO states VALUES ('PA', 'Pennsylvania');

/* non-daily batch, 3/20 - final state */
DO $$
DECLARE last_batch_id BIGINT;
BEGIN
	/* This returns the batch ID, can be used in other inserts. */
	INSERT INTO batch
		(created_at, shift_lead, batch_note, is_preview, is_revision, is_daily_commit) VALUES
		('2020-03-20 10:00:00', 'JK', 'Julia is testing', FALSE, FALSE, FALSE)
		RETURNING batch_id INTO last_batch_id;
	/* Insert some data for this batch */
	INSERT INTO core_data 
		(state_name, last_update_time, last_check_time, data_date, tests, checker, public_notes, batch_id) VALUES
		('PA', '2020-03-20', '2020-03-20 09:55:00', '2020-03-20', 130, 'JK', 'PA morning', last_batch_id);
	INSERT INTO core_data 
		(state_name, last_update_time, last_check_time, data_date, tests, checker, public_notes, batch_id) VALUES
		('NY', '2020-03-20', '2020-03-20 09:56:00', '2020-03-20', 168, 'JK', 'NY morning', last_batch_id);
END $$;

/* daily batch, 3/20 - final state */
DO $$
DECLARE last_batch_id BIGINT;
BEGIN
	INSERT INTO batch
		(created_at, shift_lead, batch_note, is_preview, is_revision, is_daily_commit) VALUES
		('2020-03-20 15:00:00', 'JK', 'Julia is testing', FALSE, FALSE, TRUE)
		RETURNING batch_id INTO last_batch_id;
	INSERT INTO core_data 
		(state_name, last_update_time, last_check_time, data_date, tests, checker, public_notes, batch_id) VALUES
		('PA', '2020-03-20 14:00:00', '2020-03-20 14:55:00', '2020-03-20', 131, 'JK', 'PA afternoon', last_batch_id);
	INSERT INTO core_data 
		(state_name, last_update_time, last_check_time, data_date, tests, checker, public_notes, batch_id) VALUES
		('NY', '2020-03-20 14:00:00', '2020-03-20 14:56:00', '2020-03-20', 170, 'JK', 'NY afternoon', last_batch_id);
END $$;

/* non-daily batch, 3/20, final state */
DO $$
DECLARE last_batch_id BIGINT;
BEGIN
	INSERT INTO batch
		(created_at, shift_lead, batch_note, is_preview, is_revision, is_daily_commit) VALUES
		('2020-03-20 20:00:00', 'JK', 'Julia is testing', FALSE, FALSE, FALSE)
		RETURNING batch_id INTO last_batch_id;
	INSERT INTO core_data 
		(state_name, last_update_time, last_check_time, data_date, tests, checker, public_notes, batch_id) VALUES
		('PA', '2020-03-20 17:00:00', '2020-03-20 17:55:00', '2020-03-20', 135, 'JK', 'PA night', last_batch_id);
	INSERT INTO core_data 
		(state_name, last_update_time, last_check_time, data_date, tests, checker, public_notes, batch_id) VALUES
		('NY', '2020-03-20 17:00:00', '2020-03-20 17:56:00', '2020-03-20', 175, 'JK', 'NY night', last_batch_id);
END $$;

/* next day, revise some data from previous day */
DO $$
DECLARE last_batch_id BIGINT;
BEGIN
	INSERT INTO batch
		(created_at, shift_lead, batch_note, is_preview, is_revision, is_daily_commit) VALUES
		('2020-03-21 08:00:00', 'JK', 'Missed 5 tests in NY', FALSE, TRUE, FALSE)
		RETURNING batch_id INTO last_batch_id;
	INSERT INTO core_data
		(state_name, last_update_time, last_check_time, data_date, tests, checker, public_notes, batch_id) VALUES
		('NY', '2020-03-21 00:00:00', '2020-03-21 07:55:00', '2020-03-21', 175, 'JK', 'Missed 5 tests in NY for 3/20 daily', last_batch_id);
END $$;

/* non-daily batch, next day 3/21, final state */
DO $$
DECLARE last_batch_id BIGINT;
BEGIN
	INSERT INTO batch
		(created_at, shift_lead, batch_note, is_preview, is_revision, is_daily_commit) VALUES
		('2020-03-21 10:00:00', 'JK', 'Julia is still testing', FALSE, FALSE, FALSE)
		RETURNING batch_id INTO last_batch_id;
	INSERT INTO core_data 
		(state_name, last_update_time, last_check_time, data_date, tests, checker, public_notes, batch_id) VALUES
		('PA', '2020-03-21 00:00:00', '2020-03-21 09:55:00', '2020-03-21', 140, 'JK', 'PA morning', last_batch_id);
	INSERT INTO core_data 
		(state_name, last_update_time, last_check_time, data_date, tests, checker, public_notes, batch_id) VALUES
		('NY', '2020-03-21 00:00:00', '2020-03-21 09:56:00', '2020-03-21', 190, 'JK', 'NY morning', last_batch_id);
END $$;

/* daily batch, 3/21, preview state */
DO $$
DECLARE last_batch_id BIGINT;
BEGIN
	INSERT INTO batch
		(created_at, shift_lead, batch_note, is_preview, is_revision, is_daily_commit) VALUES
		('2020-03-21 15:00:00', 'JK', 'Julia is still testing', TRUE, FALSE, TRUE)
		RETURNING batch_id INTO last_batch_id;
	INSERT INTO core_data 
		(state_name, last_update_time, last_check_time, data_date, tests, checker, public_notes, batch_id) VALUES
		('PA', '2020-03-21 14:00:00', '2020-03-21 14:55:00', '2020-03-21', 150, 'JK', 'PA afternoon', last_batch_id);
	INSERT INTO core_data 
		(state_name, last_update_time, last_check_time, data_date, tests, checker, public_notes, batch_id) VALUES
		('NY', '2020-03-21 14:00:00', '2020-03-21 14:56:00', '2020-03-21', 200, 'JK', 'NY afternoon', last_batch_id);
END $$;

SELECT * FROM core_data INNER JOIN batch ON core_data.batch_id = batch.batch_id;
