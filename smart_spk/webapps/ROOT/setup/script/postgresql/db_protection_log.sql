-- Table: db_protection_log

-- DROP TABLE db_protection_log;

CREATE TABLE db_protection_log
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  ipaddress character varying(64) NOT NULL,
  clientid character varying(64),
  logtype character(1) NOT NULL,
  logcontents text,
  logdatetime timestamp without time zone NOT NULL,
  createdatetime timestamp without time zone NOT NULL,
  CONSTRAINT "PK_DB_PROTECTION_LOG" PRIMARY KEY (seqno),
  CONSTRAINT "FK_DB_PROTECTION_LOG_COMPANY" FOREIGN KEY (companyid)
      REFERENCES company (companyid) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);

-- Index: "IDX_DB_PROTECTION_LOG_COMPANY"

-- DROP INDEX "IDX_DB_PROTECTION_LOG_COMPANY";

CREATE INDEX "IDX_DB_PROTECTION_LOG_COMPANY"
  ON db_protection_log
  USING btree
  (companyid);

-- Index: "IDX_DB_PROTECTION_LOG_CREATEDATETIME"

-- DROP INDEX "IDX_DB_PROTECTION_LOG_CREATEDATETIME";

CREATE INDEX "IDX_DB_PROTECTION_LOG_CREATEDATETIME"
  ON db_protection_log
  USING btree
  (createdatetime);
ALTER TABLE db_protection_log CLUSTER ON "IDX_DB_PROTECTION_LOG_CREATEDATETIME";

