-- Table: print_log

-- DROP TABLE print_log;

CREATE TABLE print_log
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  deptcode character varying(32) NOT NULL,
  userid character varying(32) NOT NULL,
  ipaddress character varying(64),
  clientid character varying(64),
  filepath character varying(512) NOT NULL,
  printpagecount integer NOT NULL,
  printername character varying(128) NOT NULL,
  printdatetime timestamp without time zone NOT NULL,
  createdatetime timestamp without time zone NOT NULL,
  CONSTRAINT "PK_PRINT_LOG" PRIMARY KEY (seqno)
)
WITH (
  OIDS=FALSE
);

-- Index: "IDX_PRINT_LOG_CREATEDATETIME"

-- DROP INDEX "IDX_PRINT_LOG_CREATEDATETIME";

CREATE INDEX "IDX_PRINT_LOG_CREATEDATETIME"
  ON print_log
  USING btree
  (createdatetime);

-- Index: "IDX_PRINT_LOG_MEMBER"

-- DROP INDEX "IDX_PRINT_LOG_MEMBER";

CREATE INDEX "IDX_PRINT_LOG_MEMBER"
  ON print_log
  USING btree
  (companyid, deptcode, userid);

-- Index: "IDX_PRINT_LOG_PRINTDATETIME"

-- DROP INDEX "IDX_PRINT_LOG_PRINTDATETIME";

CREATE INDEX "IDX_PRINT_LOG_PRINTDATETIME"
  ON print_log
  USING btree
  (printdatetime);
ALTER TABLE print_log CLUSTER ON "IDX_PRINT_LOG_PRINTDATETIME";

