-- Table: member_system_control_config

-- DROP TABLE member_system_control_config;

CREATE TABLE member_system_control_config
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  deptcode character varying(32) NOT NULL,
  userid character varying(32) NOT NULL,
  systempasswordsetupflag character(1),
  systempasswordminlength integer,
  systempasswordmaxlength integer,
  systempasswordexpirationflag character(1),
  systempasswordexpirationperiod integer,
  screensaveractivationflag character(1),
  screensaverwaitingminutes integer,
  lastmodifieddatetime timestamp without time zone,
  createdatetime timestamp without time zone NOT NULL,
  CONSTRAINT "PK_MEMBER_SYSTEM_CONTROL_CONFIG" PRIMARY KEY (companyid, deptcode, userid),
  CONSTRAINT "FK_MEMBER_SYSTEM_CONTROL_CONFIG_MEMBER" FOREIGN KEY (companyid, deptcode, userid)
      REFERENCES member (companyid, deptcode, userid) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
