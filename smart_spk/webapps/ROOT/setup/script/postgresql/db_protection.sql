-- Table: db_protection

-- DROP TABLE db_protection;

CREATE TABLE db_protection
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  useflag character(1),
  lastmodifieddatetime timestamp without time zone,
  createdatetime timestamp without time zone NOT NULL,
  CONSTRAINT "PK_DB_PROTECTION" PRIMARY KEY (companyid),
  CONSTRAINT "FK_DB_PROTECTION_COMPANY" FOREIGN KEY (companyid)
      REFERENCES company (companyid) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
