-- Table: db_protection_user

-- DROP TABLE db_protection_user;

CREATE TABLE db_protection_user
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  ipaddress character varying(32) NOT NULL,
  clientid character varying(64),
  CONSTRAINT "PK_DB_PROTECTION_USER" PRIMARY KEY (companyid, ipaddress),
  CONSTRAINT "FK_DB_PROTECTION_USER_COMPANY" FOREIGN KEY (companyid)
      REFERENCES company (companyid) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
