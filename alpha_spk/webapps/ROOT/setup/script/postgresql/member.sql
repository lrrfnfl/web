-- Table: member

-- DROP TABLE member;

CREATE TABLE member
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  deptcode character varying(32) NOT NULL,
  userid character varying(32) NOT NULL,
  username character varying(128) NOT NULL,
  pwd character varying(128) NOT NULL,
  email character varying(128),
  phone character varying(32),
  mobilephone character varying(32),
  usertype character(1) NOT NULL,
  installflag character(1) NOT NULL,
  installdatetime timestamp without time zone,
  uninstalldatetime timestamp without time zone,
  changefirstpasswordflag character(1) NOT NULL,
  lastchangedpassworddatetime timestamp without time zone,
  loginflag character(1) NOT NULL,
  lastlogindatetime timestamp without time zone,
  lastsearchdatetime timestamp without time zone,
  lastagentcheckdatetime timestamp without time zone,
  lastaccessipaddress character varying(32),
  lastaccessclientid character varying(64),
  servicestateflag character(1) NOT NULL,
  servicestoppeddatetime timestamp without time zone,
  lastmodifieddatetime timestamp without time zone,
  createdatetime timestamp without time zone NOT NULL,
  CONSTRAINT "PK_MEMBER" PRIMARY KEY (companyid, deptcode, userid),
  CONSTRAINT "FK_MEMBER_DEPT" FOREIGN KEY (companyid, deptcode)
      REFERENCES dept (companyid, deptcode) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
