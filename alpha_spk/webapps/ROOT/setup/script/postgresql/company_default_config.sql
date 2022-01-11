-- Table: company_default_config

-- DROP TABLE company_default_config;

CREATE TABLE company_default_config
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
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
  CONSTRAINT "PK_COMPANY_DEFAULT_CONFIG" PRIMARY KEY (companyid),
  CONSTRAINT "FK_COMPANY_DEFAULT_CONFIG_COMPANY" FOREIGN KEY (companyid)
      REFERENCES company (companyid) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
