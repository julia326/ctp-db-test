DROP TABLE IF EXISTS core_data;
DROP TABLE IF EXISTS states;
DROP TABLE IF EXISTS batch;

CREATE TABLE states (
    state_name VARCHAR(10) PRIMARY KEY NOT NULL,
    full_name VARCHAR NOT NULL
    -- can hold population, density, coordinates, other data as needed in the future
);

CREATE TABLE batch (
    batch_id SERIAL PRIMARY KEY,
    created_at TIMESTAMPTZ NOT NULL,
    published_at TIMESTAMPTZ,
    shift_lead VARCHAR(100),
    batch_note VARCHAR,
    data_entry_type VARCHAR(100) NOT NULL,
    is_published BOOLEAN NOT NULL,  -- false if preview state, true if live
    is_revision BOOLEAN NOT NULL
);

CREATE TABLE core_data (
     state_name VARCHAR(10) REFERENCES states(state_name) NOT NULL,
     last_update_time TIMESTAMPTZ NOT NULL,
     last_check_time TIMESTAMPTZ NOT NULL,
     data_date DATE NOT NULL,  -- the day we mean to report this data for; meant for "states daily" extraction
     tests INT,
     -- additional cols for positives, negatives, hospitalization data, etc...
     checker VARCHAR(100),
     double_checker VARCHAR(100),
     public_notes VARCHAR,
     private_notes VARCHAR,  -- from worksheet, "Notes" column (made by checker or doublechecker)
     source_notes VARCHAR, -- from state matrix: which columns?
     batch_id INT REFERENCES batch(batch_id)
     -- should have a primary key on what? (geography_id, batch_id) ?
);
