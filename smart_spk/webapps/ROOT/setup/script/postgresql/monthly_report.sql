-- Table: monthly_report

-- DROP TABLE monthly_report;

CREATE TABLE monthly_report
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  reportmonth character varying(7) NOT NULL,
  reportname character varying(128),
  downloadpath text,
  createdatetime timestamp without time zone,
  CONSTRAINT "PK_MONTHLY_REPORT" PRIMARY KEY (companyid, reportmonth),
  CONSTRAINT "FK_MONTHLY_REPORT_COMPANY" FOREIGN KEY (companyid)
      REFERENCES company (companyid) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
