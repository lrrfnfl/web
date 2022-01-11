-- Table: url_block_log

-- DROP TABLE url_block_log;

CREATE TABLE url_block_log
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  deptcode character varying(32) NOT NULL,
  userid character varying(32) NOT NULL,
  ipaddress character varying(32),
  clientid character varying(64),
  blockurl character varying(128) NOT NULL,
  logcontents character varying(256),
  logdatetime timestamp without time zone NOT NULL,
  createdatetime timestamp without time zone NOT NULL,
  CONSTRAINT "PK_URL_BLOCK_LOG" PRIMARY KEY (seqno)
)
WITH (
  OIDS=FALSE
);

-- Index: "IDX_URL_BLOCK_LOG_CREATEDATETIME"

-- DROP INDEX "IDX_URL_BLOCK_LOG_CREATEDATETIME";

CREATE INDEX "IDX_URL_BLOCK_LOG_CREATEDATETIME"
  ON url_block_log
  USING btree
  (createdatetime);
ALTER TABLE url_block_log CLUSTER ON "IDX_URL_BLOCK_LOG_CREATEDATETIME";

-- Index: "IDX_URL_BLOCK_LOG_LOGDATETIME"

-- DROP INDEX "IDX_URL_BLOCK_LOG_LOGDATETIME";

CREATE INDEX "IDX_URL_BLOCK_LOG_LOGDATETIME"
  ON url_block_log
  USING btree
  (logdatetime);

-- Index: "IDX_URL_BLOCK_LOG_MEMBER"

-- DROP INDEX "IDX_URL_BLOCK_LOG_MEMBER";

CREATE INDEX "IDX_URL_BLOCK_LOG_MEMBER"
  ON url_block_log
  USING btree
  (companyid, deptcode, userid);

