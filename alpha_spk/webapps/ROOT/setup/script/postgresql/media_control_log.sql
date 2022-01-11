-- Table: media_control_log

-- DROP TABLE media_control_log;

CREATE TABLE media_control_log
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  deptcode character varying(32) NOT NULL,
  userid character varying(32) NOT NULL,
  ipaddress character varying(32),
  clientid character varying(64),
  filepath character varying(512) NOT NULL,
  mediatype character(1) NOT NULL,
  controltype character(1) NOT NULL,
  logcontents character varying(256),
  logdatetime timestamp without time zone NOT NULL,
  createdatetime timestamp without time zone NOT NULL,
  CONSTRAINT "PK_MEDIA_CONTROL_LOG" PRIMARY KEY (seqno)
)
WITH (
  OIDS=FALSE
);

-- Index: "IDX_MEDIA_CONTROL_LOG_CREATEDATETIME"

-- DROP INDEX "IDX_MEDIA_CONTROL_LOG_CREATEDATETIME";

CREATE INDEX "IDX_MEDIA_CONTROL_LOG_CREATEDATETIME"
  ON media_control_log
  USING btree
  (createdatetime);
ALTER TABLE media_control_log CLUSTER ON "IDX_MEDIA_CONTROL_LOG_CREATEDATETIME";

-- Index: "IDX_MEDIA_CONTROL_LOG_LOGDATETIME"

-- DROP INDEX "IDX_MEDIA_CONTROL_LOG_LOGDATETIME";

CREATE INDEX "IDX_MEDIA_CONTROL_LOG_LOGDATETIME"
  ON media_control_log
  USING btree
  (logdatetime);

-- Index: "IDX_MEDIA_CONTROL_LOG_MEMBER"

-- DROP INDEX "IDX_MEDIA_CONTROL_LOG_MEMBER";

CREATE INDEX "IDX_MEDIA_CONTROL_LOG_MEMBER"
  ON media_control_log
  USING btree
  (companyid, deptcode, userid);
