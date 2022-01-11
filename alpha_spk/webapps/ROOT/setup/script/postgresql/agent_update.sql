-- Table: agent_update

-- DROP TABLE agent_update;

CREATE TABLE agent_update
(
  seqno serial NOT NULL,
  version character varying(32) NOT NULL,
  title character varying(256) NOT NULL,
  content text,
  companyid character varying(64),
  downloadpath character varying(256) NOT NULL,
  infofilename character varying(64) NOT NULL,
  distributestate character(1) NOT NULL,
  distributedcount integer NOT NULL DEFAULT 0,
  lastmodifieddatetime timestamp without time zone,
  createdatetime timestamp without time zone NOT NULL,
  CONSTRAINT "PK_AGENT_UPDATE" PRIMARY KEY (version)
)
WITH (
  OIDS=FALSE
);
