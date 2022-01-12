-- Table: db_protection_program

-- DROP TABLE db_protection_program;

CREATE TABLE db_protection_program
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  programname character varying(128) NOT NULL,
  filename character varying(128) NOT NULL,
  CONSTRAINT "PK_DB_PROTECTION_PROGRAM" PRIMARY KEY (companyid, filename),
  CONSTRAINT "FK_DB_PROTECTION_PROGRAM_COMPANY" FOREIGN KEY (companyid)
      REFERENCES company (companyid) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
