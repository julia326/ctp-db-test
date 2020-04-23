USE data;

-- Create initial tables

CREATE TABLE geography (
    geography_id INT NOT NULL AUTO_INCREMENT,
    -- XXX: not sure if we should use a geography_id in contemplation of potential future additions or just state abbreviations for now
);

CREATE TABLE batch (
    batch_id INT NOT NULL AUTO_INCREMENT,
    push_time DATETIME,
    shift_lead VARCHAR(100),
    commit_note VARCHAR,
    is_daily_commit BOOLEAN,
    is_preview BOOLEAN,
    PRIMARY KEY (batch_id)
);

CREATE TABLE state_data (
    state VARCHAR(50),
    last_update_time DATETIME,
    last_check_time DATETIME,
    data_date DATE,  -- the day we mean to report this data for; meant for "states daily" extraction
    tests INT,
    -- additional cols for positives, negatives, hospitalization data, etc...
    checker VARCHAR(100),
    double_checker VARCHAR(100),
    public_notes VARCHAR,
    private_notes VARCHAR,  -- from worksheet, "Notes" column (made by checker or doublechecker)
    source_notes VARCHAR, -- from state matrix: which columns?
    batch_id INT,
    CONSTRAINT `fk_batch`
      FOREIGN KEY (batch_id) REFERENCES batch(batch_id)
      ON DELETE NO ACTION
);

/* non-daily batch */
INSERT INTO batch (push_time, shift_lead, commit_note, daily_commit) VALUES ("2020-03-20 10:00:00", "jkodysh", "Julia is testing", FALSE);
INSERT INTO states 
	(state, last_update_time, last_check_time, data_date, tests, checker, public_notes, batch_id) VALUES
	("PA", "2020-03-20", "2020-03-20 09:55:00", "2020-03-20", 130, "jkodysh", "nothing to see here", 1);
INSERT INTO states 
	(state, last_update_time, last_check_time, data_date, tests, checker, public_notes, batch_id) VALUES
    ("NY", "2020-03-20", "2020-03-20 09:55:00", "2020-03-20", 168, "jkodysh", "still nothing to see here", 1);

/* daily batch */
INSERT INTO batch (push_time, shift_lead, commit_note, daily_commit) VALUES ("2020-03-20 15:00:00", "jkodysh", "Julia is testing daily batch", TRUE);
INSERT INTO states 
	(state, last_update_time, last_check_time, data_date, tests, checker, public_notes, batch_id) VALUES
	("PA", "2020-03-20", "2020-03-20 14:55:00", "2020-03-20", 131, "jkodysh", "nothing to see here", 2);
INSERT INTO states 
	(state, last_update_time, last_check_time, data_date, tests, checker, public_notes, batch_id) VALUES
    ("NY", "2020-03-20", "2020-03-20 14:55:00", "2020-03-20", 170, "jkodysh", "still nothing to see here", 2);

/* non-daily batch */
INSERT INTO batch (push_time, shift_lead, commit_note, daily_commit) VALUES ("2020-03-20 20:00:00", "jkodysh", "Julia is still testing", FALSE);
INSERT INTO states 
	(state, last_update_time, last_check_time, data_date, tests, checker, public_notes, batch_id) VALUES
	("PA", "2020-03-20", "2020-03-20 17:55:00", "2020-03-20", 140, "jkodysh", "nothing to see here", 3);
INSERT INTO states 
	(state, last_update_time, last_check_time, data_date, tests, checker, public_notes, batch_id) VALUES
    ("NY", "2020-03-20", "2020-03-20 17:55:00", "2020-03-20", 180, "jkodysh", "still nothing to see here", 3);

/* next day, non-daily batch */
INSERT INTO batch (push_time, shift_lead, commit_note, daily_commit) VALUES ("2020-03-21 10:00:00", "jkodysh", "Julia is still testing", FALSE);
INSERT INTO states 
	(state, last_update_time, last_check_time, data_date, tests, checker, public_notes, batch_id) VALUES
	("PA", "2020-03-21", "2020-03-21 09:55:00", "2020-03-21", 150, "jkodysh", "nothing to see here", 4);
INSERT INTO states 
	(state, last_update_time, last_check_time, data_date, tests, checker, public_notes, batch_id) VALUES
    ("NY", "2020-03-21", "2020-03-21 09:55:00", "2020-03-21", 190, "jkodysh", "still nothing to see here", 4);

/* revise data from previous day */
INSERT INTO batch (push_time, shift_lead, commit_note, daily_commit) VALUES ("2020-03-21 11:00:00", "jkodysh", "Revising old data", TRUE);
INSERT INTO states
	(state, last_update_time, data_date, tests, checker, public_notes, batch_id) VALUES
    ("NY", "2020-03-20", "2020-03-20", 175, "jkodysh", "Missed 5 tests", 5);
    
SELECT * FROM states INNER JOIN batch ON states.batch_id = batch.batch_id;
