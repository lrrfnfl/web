-- Table: licence_renewal_history

-- DROP TABLE licence_renewal_history;

CREATE TABLE licence_renewal_history
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  licencetype character(1) NOT NULL,
  licencestartdate date,
  licenceenddate date,
  licencecount integer NOT NULL DEFAULT 0,
  dbprotectionlicencecount integer NOT NULL DEFAULT 0,
  paymenttype character(1),
  approvalno character varying(32),
  paymentamount bigint,
  paymentdate date,
  comments text,
  createdatetime timestamp without time zone NOT NULL,
  CONSTRAINT "PK_LICENCE_RENEWAL_HISTORY" PRIMARY KEY (seqno),
  CONSTRAINT "FK_LICENCE_RENEWAL_HISTORY_COMPANY" FOREIGN KEY (companyid)
      REFERENCES company (companyid) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
