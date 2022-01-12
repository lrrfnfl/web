-- Table: member_synchronization_config

-- DROP TABLE member_synchronization_config;

CREATE TABLE member_synchronization_config
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  dbtype character(1) NOT NULL,
  dbip character varying(64) NOT NULL,
  dbport character varying(8) NOT NULL,
  dbsid character varying(64) NOT NULL,
  dbaccountid character varying(64) NOT NULL,
  dbaccountpassword character varying(32) NOT NULL,
  sqlquery text NOT NULL,
  exceptionuserlist text
)
WITH (
  OIDS=FALSE
);
