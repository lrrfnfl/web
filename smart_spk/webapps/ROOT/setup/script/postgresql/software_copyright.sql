-- Table: software_copyright

-- DROP TABLE software_copyright;

CREATE TABLE software_copyright
(
  seqno serial NOT NULL,
  softwarename character varying(256) NOT NULL,
  filename character varying(128) DEFAULT NULL::character varying,
  filesize bigint,
  softwaretype character(1) NOT NULL,
  description text,
  price bigint NOT NULL,
  manufacturer character varying(128) NOT NULL,
  vendor character varying(128) NOT NULL,
  vendoremail character varying(128) DEFAULT NULL::character varying,
  vendorphone character varying(32) DEFAULT NULL::character varying,
  vendorfax character varying(32) DEFAULT NULL::character varying,
  CONSTRAINT "PK_SOFTWARE_COPYRIGHT" PRIMARY KEY (softwarename)
)
WITH (
  OIDS=FALSE
);
