USE data;

-- Create initial tables

CREATE TABLE geography (
    geography_id serial primary key,
    abbreviation char(2),
    full_name varchar not null
);

CREATE TABLE batch (
    batch_id serial primary key,
    push_time timestamptz not null,
    publish_time timestamptz,
    shift_lead VARCHAR(100),
    commit_note VARCHAR,
    is_daily_commit BOOLEAN not null,
    is_preview BOOLEAN not null,
    is_revision BOOLEAN not null
    PRIMARY KEY (batch_id)
);

CREATE TABLE core_data (
    geography_id int references geography(geography_id) not null,
    last_update_time timestamptz not null,
    last_check_time timestamptz not null,
    data_date DATE not null,  -- the day we mean to report this data for; meant for "states daily" extraction
    tests INT,
    -- additional cols for positives, negatives, hospitalization data, etc...
    checker VARCHAR(100),
    double_checker VARCHAR(100),
    public_notes VARCHAR,
    private_notes VARCHAR,  -- from worksheet, "Notes" column (made by checker or doublechecker)
    source_notes VARCHAR, -- from state matrix: which columns?
    batch_id INT references batch(batch_id),
    -- should have a primary key on what? (geography_id, batch_id) ?
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
