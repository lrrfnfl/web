-- Table: licence

-- DROP TABLE licence;

CREATE TABLE licence
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  licencetype character(1) NOT NULL,
  licencestartdate date,
  licenceenddate date,
  licencecount integer NOT NULL DEFAULT 0,
  dbprotectionlicencecount integer NOT NULL DEFAULT 0,
  lastmodifieddatetime timestamp without time zone,
  createdatetime timestamp without time zone NOT NULL,
  CONSTRAINT "PK_LICENCE" PRIMARY KEY (companyid),
  CONSTRAINT "FK_LICENCE_COMPANY" FOREIGN KEY (companyid)
      REFERENCES company (companyid) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
