-- Table: search_log

-- DROP TABLE search_log;

CREATE TABLE search_log
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  deptcode character varying(32) NOT NULL,
  userid character varying(32) NOT NULL,
  searchid character varying(15) NOT NULL,
  searchtype character(1) NOT NULL,
  startdatetime timestamp without time zone NOT NULL,
  enddatetime timestamp without time zone NOT NULL,
  ipaddress character varying(32),
  clientid character varying(64),
  createdatetime timestamp without time zone NOT NULL,
  CONSTRAINT "PK_SEARCH_LOG" PRIMARY KEY (companyid, deptcode, userid, searchid)
)
WITH (
  OIDS=FALSE
);

-- Index: "IDX_SEARCH_LOG_CREATEDATETIME"

-- DROP INDEX "IDX_SEARCH_LOG_CREATEDATETIME";

CREATE INDEX "IDX_SEARCH_LOG_CREATEDATETIME"
  ON search_log
  USING btree
  (createdatetime);
ALTER TABLE search_log CLUSTER ON "IDX_SEARCH_LOG_CREATEDATETIME";

-- Index: "IDX_SEARCH_LOG_SEARCHID"

-- DROP INDEX "IDX_SEARCH_LOG_SEARCHID";

CREATE INDEX "IDX_SEARCH_LOG_SEARCHID"
  ON search_log
  USING btree
  (searchid);

-- Index: "IDX_SEARCH_LOG_SEQNO"

-- DROP INDEX "IDX_SEARCH_LOG_SEQNO";

CREATE INDEX "IDX_SEARCH_LOG_SEQNO"
  ON search_log
  USING btree
  (seqno);

-- Index: "IDX_SEARCH_LOG_STARTDATETIME"

-- DROP INDEX "IDX_SEARCH_LOG_STARTDATETIME";

CREATE INDEX "IDX_SEARCH_LOG_STARTDATETIME"
  ON search_log
  USING btree
  (startdatetime);
