-- Table: payment

-- DROP TABLE payment;

CREATE TABLE payment
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  paymenttype character(1),
  approvalno character,
  paymentamount bigint,
  paymentdate date,
  createdatetime timestamp without time zone NOT NULL,
  CONSTRAINT "PK_PAYMENT" PRIMARY KEY (seqno),
  CONSTRAINT "FK_PAYMENT_COMPANY" FOREIGN KEY (companyid)
      REFERENCES company (companyid) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
