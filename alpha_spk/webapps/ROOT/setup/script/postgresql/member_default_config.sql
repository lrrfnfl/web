-- Table: member_default_config

-- DROP TABLE member_default_config;

CREATE TABLE member_default_config
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  deptcode character varying(32) NOT NULL,
  userid character varying(32) NOT NULL,
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
  ocrserveripaddress character varying(32),
  ocrserverport character varying(8),
  lastmodifieddatetime timestamp without time zone,
  createdatetime timestamp without time zone NOT NULL,
  CONSTRAINT "PK_MEMBER_DEFAULT_CONFIG" PRIMARY KEY (companyid, deptcode, userid),
  CONSTRAINT "FK_MEMBER_DEFAULT_CONFIG_MEMBER" FOREIGN KEY (companyid, deptcode, userid)
      REFERENCES member (companyid, deptcode, userid) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
