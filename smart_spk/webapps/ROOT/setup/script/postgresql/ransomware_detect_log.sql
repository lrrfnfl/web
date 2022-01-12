-- Table: ransomware_detect_log

-- DROP TABLE ransomware_detect_log;

CREATE TABLE ransomware_detect_log
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  deptcode character varying(32) NOT NULL,
  userid character varying(32) NOT NULL,
  ipaddress character varying(64),
  clientid character varying(64),
  filepath character varying(512) NOT NULL,
  detectcomments text,
  detectdatetime timestamp without time zone NOT NULL,
  createdatetime timestamp without time zone NOT NULL,
  CONSTRAINT "PK_RANSOMWARE_DETECT_LOG" PRIMARY KEY (seqno)
)
WITH (
  OIDS=FALSE
);

-- Index: "IDX_RANSOMWARE_DETECT_LOG_CREATEDATETIME"

-- DROP INDEX "IDX_RANSOMWARE_DETECT_LOG_CREATEDATETIME";

CREATE INDEX "IDX_RANSOMWARE_DETECT_LOG_CREATEDATETIME"
  ON ransomware_detect_log
  USING btree
  (createdatetime);

-- Index: "IDX_RANSOMWARE_DETECT_LOG_DETECTDATETIME"

-- DROP INDEX "IDX_RANSOMWARE_DETECT_LOG_DETECTDATETIME";

CREATE INDEX "IDX_RANSOMWARE_DETECT_LOG_DETECTDATETIME"
  ON ransomware_detect_log
  USING btree
  (detectdatetime);
ALTER TABLE ransomware_detect_log CLUSTER ON "IDX_RANSOMWARE_DETECT_LOG_DETECTDATETIME";

-- Index: "IDX_RANSOMWARE_DETECT_LOG_MEMBER"

-- DROP INDEX "IDX_RANSOMWARE_DETECT_LOG_MEMBER";

CREATE INDEX "IDX_RANSOMWARE_DETECT_LOG_MEMBER"
  ON ransomware_detect_log
  USING btree
  (companyid, deptcode, userid);
