-- Table: company_system_control_config

-- DROP TABLE company_system_control_config;

CREATE TABLE company_system_control_config
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  systempasswordsetupflag character(1),
  systempasswordminlength integer,
  systempasswordmaxlength integer,
  systempasswordexpirationflag character(1),
  systempasswordexpirationperiod integer,
  screensaveractivationflag character(1),
  screensaverwaitingminutes integer,
  lastmodifieddatetime timestamp without time zone,
  createdatetime timestamp without time zone NOT NULL,
  CONSTRAINT "PK_COMPANY_SYSTEM_CONTROL_CONFIG" PRIMARY KEY (companyid),
  CONSTRAINT "FK_COMPANY_SYSTEM_CONTROL_CONFIG_COMPANY" FOREIGN KEY (companyid)
      REFERENCES company (companyid) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
