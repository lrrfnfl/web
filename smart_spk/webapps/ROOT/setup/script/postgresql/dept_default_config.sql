-- Table: dept_default_config

-- DROP TABLE dept_default_config;

CREATE TABLE dept_default_config
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  deptcode character varying(32) NOT NULL,
  jobprocessingtype character varying(2),
  forcedterminationflag character(1),
  forcedterminationpwd character varying(128),
  decordingpermissionflag character(1),
  safeexportflag character(1),
  contentcopypreventionflag character(1),
  realtimeobservationflag character(1),
  passwordexpirationflag character(1),
  passwordexpirationperiod integer,
  expirationflag character(1),
  expirationperiod character varying(8),
  expirationjobprocessingtype character varying(2),
  useserverocrflag character(1),
  ocrserveripaddress character varying(64),
  ocrserverport character varying(8),
  lastmodifieddatetime timestamp without time zone,
  createdatetime timestamp without time zone NOT NULL,
  CONSTRAINT "PK_DEPT_DEFAULT_CONFIG" PRIMARY KEY (companyid, deptcode),
  CONSTRAINT "FK_DEPT_DEFAULT_CONFIG_DEPT" FOREIGN KEY (companyid, deptcode)
      REFERENCES dept (companyid, deptcode) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
