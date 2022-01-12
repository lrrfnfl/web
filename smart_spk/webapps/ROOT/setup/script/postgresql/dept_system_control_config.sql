-- Table: dept_system_control_config

-- DROP TABLE dept_system_control_config;

CREATE TABLE dept_system_control_config
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  deptcode character varying(32) NOT NULL,
  systempasswordsetupflag character(1),
  systempasswordminlength integer,
  systempasswordmaxlength integer,
  systempasswordexpirationflag character(1),
  systempasswordexpirationperiod integer,
  screensaveractivationflag character(1),
  screensaverwaitingminutes integer,
  lastmodifieddatetime timestamp without time zone,
  createdatetime timestamp without time zone NOT NULL,
  CONSTRAINT "PK_DEPT_SYSTEM_CONTROL_CONFIG" PRIMARY KEY (companyid, deptcode),
  CONSTRAINT "FK_DEPT_SYSTEM_CONTROL_CONFIG_DEPT" FOREIGN KEY (companyid, deptcode)
      REFERENCES dept (companyid, deptcode) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
