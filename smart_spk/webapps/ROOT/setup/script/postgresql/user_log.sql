-- Table: user_log

-- DROP TABLE user_log;

CREATE TABLE user_log
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  deptcode character varying(32) NOT NULL,
  userid character varying(32) NOT NULL,
  logtype character(1) NOT NULL,
  logdata text,
  createdatetime timestamp without time zone NOT NULL,
  CONSTRAINT "PK_USER_LOG" PRIMARY KEY (seqno)
)
WITH (
  OIDS=FALSE
);

-- Index: "IDX_USER_LOG_CREATEDATETIME"

-- DROP INDEX "IDX_USER_LOG_CREATEDATETIME";

CREATE INDEX "IDX_USER_LOG_CREATEDATETIME"
  ON user_log
  USING btree
  (createdatetime);
ALTER TABLE user_log CLUSTER ON "IDX_USER_LOG_CREATEDATETIME";

-- Index: "IDX_USER_LOG_MEMBER"

-- DROP INDEX "IDX_USER_LOG_MEMBER";

CREATE INDEX "IDX_USER_LOG_MEMBER"
  ON user_log
  USING btree
  (companyid, deptcode, userid);
