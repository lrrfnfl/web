-- Table: detect_log

-- DROP TABLE detect_log;

CREATE TABLE detect_log
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  deptcode character varying(32) NOT NULL,
  userid character varying(32) NOT NULL,
  searchid character varying(15) NOT NULL,
  searchtype character(1) NOT NULL,
  searchseqno integer NOT NULL,
  searchdate date NOT NULL,
  searchpath character varying(512) NOT NULL,
  workdatetime timestamp without time zone,
  workpath character varying(512),
  filetype character(1) NOT NULL,
  fileid character varying(64),
  detectstatus character(1) NOT NULL,
  result character varying(2) NOT NULL,
  ipaddress character varying(32),
  clientid character varying(64),
  createdatetime timestamp without time zone NOT NULL,
  CONSTRAINT "PK_DETECT_LOG" PRIMARY KEY (companyid, deptcode, userid, searchid, searchseqno)
)
WITH (
  OIDS=FALSE
);

-- Index: "IDX_DETECT_LOG_CREATEDATETIME"

-- DROP INDEX "IDX_DETECT_LOG_CREATEDATETIME";

CREATE INDEX "IDX_DETECT_LOG_CREATEDATETIME"
  ON detect_log
  USING btree
  (createdatetime);
ALTER TABLE detect_log CLUSTER ON "IDX_DETECT_LOG_CREATEDATETIME";

-- Index: "IDX_DETECT_LOG_FILEID"

-- DROP INDEX "IDX_DETECT_LOG_FILEID";

CREATE INDEX "IDX_DETECT_LOG_FILEID"
  ON detect_log
  USING btree
  (fileid);

-- Index: "IDX_DETECT_LOG_SEARCHDATE"

-- DROP INDEX "IDX_DETECT_LOG_SEARCHDATE";

CREATE INDEX "IDX_DETECT_LOG_SEARCHDATE"
  ON detect_log
  USING btree
  (searchdate);

-- Index: "IDX_DETECT_LOG_SEARCHID"

-- DROP INDEX "IDX_DETECT_LOG_SEARCHID";

CREATE INDEX "IDX_DETECT_LOG_SEARCHID"
  ON detect_log
  USING btree
  (searchid);

-- Index: "IDX_DETECT_LOG_SEQNO"

-- DROP INDEX "IDX_DETECT_LOG_SEQNO";

CREATE INDEX "IDX_DETECT_LOG_SEQNO"
  ON detect_log
  USING btree
  (seqno);
