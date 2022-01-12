-- Table: install_state

-- DROP TABLE install_state;

CREATE TABLE install_state
(
  seqno serial NOT NULL,
  companyid character varying(64),
  userid character varying(32),
  jobflag character(1) NOT NULL,
  jobdatetime timestamp without time zone NOT NULL,
  description text,
  ipaddress character varying(64) NOT NULL,
  clientid character varying(64) NOT NULL,
  CONSTRAINT "PK_INSTALL_STATE" PRIMARY KEY (seqno)
)
WITH (
  OIDS=FALSE
);
