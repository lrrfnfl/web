-- Table: daily_ransomware_detect_summary

-- DROP TABLE daily_ransomware_detect_summary;

CREATE TABLE daily_ransomware_detect_summary
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  deptcode character varying(32) NOT NULL,
  userid character varying(32) NOT NULL,
  detectdate date NOT NULL,
  detectfilename character varying(128) NOT NULL,
  detectcount integer NOT NULL,
  CONSTRAINT "PK_DAILY_RANSOMWARE_DETECT_SUMMARY" PRIMARY KEY (companyid, deptcode, userid, detectdate, detectfilename)
)
WITH (
  OIDS=FALSE
);

-- Index: "IDX_PRINT_SUMMARY_DETECTDATE"

-- DROP INDEX "IDX_PRINT_SUMMARY_DETECTDATE";

CREATE INDEX "IDX_PRINT_SUMMARY_DETECTDATE"
  ON daily_ransomware_detect_summary
  USING btree
  (detectdate);
