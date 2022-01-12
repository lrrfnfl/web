-- Table: admin

-- DROP TABLE admin;

CREATE TABLE admin
(
  seqno serial NOT NULL,
  adminid character varying(32) NOT NULL,
  pwd character varying(128) NOT NULL,
  adminname character varying(128) NOT NULL,
  email character varying(128),
  phone character varying(32),
  mobilephone character varying(32),
  admintype character(1) NOT NULL,
  companyid character varying(64),
  accessableaddresstype character(1) NOT NULL,
  changefirstpasswordflag character(1) NOT NULL,
  passwordexpirationflag character(1) NOT NULL DEFAULT '0'::bpchar,
  passwordexpirationperiod integer,
  lastchangedpassworddatetime timestamp without time zone,
  loginflag character(1) NOT NULL,
  loginsessionid character varying(128),
  lastlogindatetime timestamp without time zone,
  lockflag character(1) NOT NULL,
  lockdatetime timestamp without time zone,
  failedpasswordattemptcount integer NOT NULL,
  lastmodifieddatetime timestamp without time zone,
  createdatetime timestamp without time zone NOT NULL,
  CONSTRAINT "PK_ADMIN" PRIMARY KEY (adminid)
)
WITH (
  OIDS=FALSE
);
