-- Table: realtimeobservation_log

-- DROP TABLE realtimeobservation_log;

CREATE TABLE realtimeobservation_log
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  deptcode character varying(32) NOT NULL,
  userid character varying(32) NOT NULL,
  ipaddress character varying(64),
  clientid character varying(64),
  fileid character varying(64) NOT NULL,
  filepath character varying(512) NOT NULL,
  observationtype character(1) NOT NULL,
  observationcontents text,
  observationdatetime timestamp without time zone NOT NULL,
  detectpatterncount integer NOT NULL DEFAULT 0,
  detectkeywordcount bigint NOT NULL DEFAULT 0,
  CONSTRAINT "PK_REALTIMEOBSERVATION_LOG" PRIMARY KEY (seqno)
)
WITH (
  OIDS=FALSE
);

-- Index: "IDX_REALTIMEOBSERVATION_LOG_FILEID"

-- DROP INDEX "IDX_REALTIMEOBSERVATION_LOG_FILEID";

CREATE INDEX "IDX_REALTIMEOBSERVATION_LOG_FILEID"
  ON realtimeobservation_log
  USING btree
  (fileid);

-- Index: "IDX_REALTIMEOBSERVATION_LOG_MEMBER"

-- DROP INDEX "IDX_REALTIMEOBSERVATION_LOG_MEMBER";

CREATE INDEX "IDX_REALTIMEOBSERVATION_LOG_MEMBER"
  ON realtimeobservation_log
  USING btree
  (companyid, deptcode, userid);

-- Index: "IDX_REALTIMEOBSERVATION_LOG_OBSERVATIONDATETIME"

-- DROP INDEX "IDX_REALTIMEOBSERVATION_LOG_OBSERVATIONDATETIME";

CREATE INDEX "IDX_REALTIMEOBSERVATION_LOG_OBSERVATIONDATETIME"
  ON realtimeobservation_log
  USING btree
  (observationdatetime);
ALTER TABLE realtimeobservation_log CLUSTER ON "IDX_REALTIMEOBSERVATION_LOG_OBSERVATIONDATETIME";
