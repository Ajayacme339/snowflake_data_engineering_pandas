-- Create the avalanche database and schema: using Snowsight UI
-- CREATE OR REPLACE DATABASE avalanche_db;
-- CREATE OR REPLACE SCHEMA avalanche_schema;
USE ROLE ACCOUNTADMIN
USE DATABASE avalanche_db;
USE SCHEMA avalanche_schema;

-- Create the stage for storing our files
CREATE OR REPLACE STAGE avalanche_stage
  URL = 's3://sfquickstarts/misc/avalanche/csv/'
  DIRECTORY = (ENABLE = TRUE AUTO_REFRESH = TRUE);

ls @avalanche_stage;

----------------------------------------------------------------------------

CREATE OR REPLACE TABLE customer_reviews (
    product VARCHAR,
    date DATE,
    summary TEXT,
    sentiment_score FLOAT
);

-- Load customer reviews
COPY INTO customer_reviews
FROM @avalanche_stage/customer_reviews.csv
FILE_FORMAT = (
    TYPE = CSV
    FIELD_DELIMITER = ','
    SKIP_HEADER = 1
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
    TRIM_SPACE = TRUE
    NULL_IF = ('NULL', 'null')
    EMPTY_FIELD_AS_NULL = TRUE
);