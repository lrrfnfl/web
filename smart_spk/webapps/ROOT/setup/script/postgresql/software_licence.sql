-- Table: software_licence

-- DROP TABLE software_licence;

CREATE TABLE software_licence
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  softwarename character varying(256) NOT NULL,
  licencekey character varying(64) DEFAULT NULL::character varying,
  licencecount integer,
  manufacturer character varying(128) DEFAULT NULL::character varying,
  vendor character varying(128) DEFAULT NULL::character varying,
  vendoremail character varying(128) DEFAULT NULL::character varying,
  vendorphone character varying(32) DEFAULT NULL::character varying,
  vendorfax character varying(32) DEFAULT NULL::character varying,
  lastmodifieddatetime timestamp without time zone,
  createdatetime timestamp without time zone NOT NULL,
  CONSTRAINT "PK_SOFTWARE_LICENCE" PRIMARY KEY (companyid, softwarename),
  CONSTRAINT "FK_SOFTWARE_LICENCE" FOREIGN KEY (companyid)
      REFERENCES company (companyid) MATCH FULL
      ON UPDATE CASCADE ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);

