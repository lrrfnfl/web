-- Table: print_summary

-- DROP TABLE print_summary;

CREATE TABLE print_summary
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  deptcode character varying(32) NOT NULL,
  userid character varying(32) NOT NULL,
  printdate date NOT NULL,
  printpagecount bigint NOT NULL,
  CONSTRAINT "PK_PRINT_SUMMARY" PRIMARY KEY (companyid, deptcode, userid, printdate)
)
WITH (
  OIDS=FALSE
);

-- Index: "IDX_PRINT_SUMMARY_PRINTDATE"

-- DROP INDEX "IDX_PRINT_SUMMARY_PRINTDATE";

CREATE INDEX "IDX_PRINT_SUMMARY_PRINTDATE"
  ON print_summary
  USING btree
  (printdate);
