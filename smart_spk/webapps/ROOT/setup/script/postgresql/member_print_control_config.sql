-- Table: member_print_control_config

-- DROP TABLE member_print_control_config;

CREATE TABLE member_print_control_config
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  deptcode character varying(32) NOT NULL,
  userid character varying(32) NOT NULL,
  printcontrolflag character(1) NOT NULL,
  printlimitflag character(1) NOT NULL,
  printlimittype character(1) NOT NULL,
  printlimitcount integer DEFAULT 0,
  maskingflag character(1) NOT NULL,
  maskingtype character(1) NOT NULL,
  juminsexnotmaskingflag character(1) NOT NULL,
  logcollectoripaddress character varying(64),
  logcollectorportno character varying(8),
  logcollectoraccountid character varying(32),
  logcollectoraccountpwd character varying(32),
  lastmodifieddatetime timestamp without time zone,
  createdatetime timestamp without time zone NOT NULL,
  CONSTRAINT "PK_MEMBER_PRINT_CONTROL_CONFIG" PRIMARY KEY (companyid, deptcode, userid),
  CONSTRAINT "FK_MEMBER_PRINT_CONTROL_CONFIG_MEMBER" FOREIGN KEY (companyid, deptcode, userid)
      REFERENCES member (companyid, deptcode, userid) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
