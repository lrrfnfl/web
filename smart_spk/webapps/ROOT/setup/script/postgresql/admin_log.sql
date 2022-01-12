-- Table: admin_log

-- DROP TABLE admin_log;

CREATE TABLE admin_log
(
  seqno serial NOT NULL,
  adminid character varying(32) NOT NULL,
  companyid character varying(64),
  jobtype character(1) NOT NULL,
  jobcategory character varying(2) NOT NULL,
  jobsubject character varying(256) NOT NULL,
  jobcontent text,
  jobdatetime timestamp without time zone NOT NULL,
  CONSTRAINT "PK_ADMIN_LOG" PRIMARY KEY (seqno),
  CONSTRAINT "FK_ADMIN_LOG_ADMIN" FOREIGN KEY (adminid)
      REFERENCES admin (adminid) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);

-- Index: "IDX_ADMIN_LOG_JOBDATETIME"

-- DROP INDEX "IDX_ADMIN_LOG_JOBDATETIME";

CREATE INDEX "IDX_ADMIN_LOG_JOBDATETIME"
  ON admin_log
  USING btree
  (jobdatetime);
ALTER TABLE admin_log CLUSTER ON "IDX_ADMIN_LOG_JOBDATETIME";

