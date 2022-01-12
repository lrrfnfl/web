-- Table: company

-- DROP TABLE company;

CREATE TABLE company
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  companyname character varying(128) NOT NULL,
  companypostalcode character varying(7),
  companyaddress character varying(256),
  companydetailaddress character varying(512),
  managername character varying(128) NOT NULL,
  manageremail character varying(128),
  managerphone character varying(32),
  managermobilephone character varying(32),
  autocreatedeptcodeflag character(1) NOT NULL,
  servicestateflag character(1) NOT NULL,
  servicestoppeddatetime timestamp without time zone,
  lastmodifieddatetime timestamp without time zone,
  createdatetime timestamp without time zone NOT NULL,
  CONSTRAINT "PK_COMPANY" PRIMARY KEY (companyid)
)
WITH (
  OIDS=FALSE
);
