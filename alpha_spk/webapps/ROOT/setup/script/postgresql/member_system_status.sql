-- Table: member_system_status

-- DROP TABLE member_system_status;

CREATE TABLE member_system_status
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  deptcode character varying(32) NOT NULL,
  userid character varying(32) NOT NULL,
  cpuinfo text,
  memoryinfo text,
  osinfo text,
  lastosupdatedatetime timestamp without time zone,
  antivirussoftwareinfo text,
  antivirussoftwarelatestupdateflag character(1),
  systempasswordsetupflag character(1),
  lastchangedsystempassworddatetime timestamp without time zone,
  systempasswordexpirationdatetime timestamp without time zone,
  screensaveractivationflag character(1),
  CONSTRAINT "PK_MEMBER_SYSTEM_STATUS" PRIMARY KEY (companyid, deptcode, userid),
  CONSTRAINT "FK_MEMBER_SYSTEM_STATUS_MEMBER" FOREIGN KEY (companyid, deptcode, userid)
      REFERENCES member (companyid, deptcode, userid) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
