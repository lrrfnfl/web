-- Table: detect_filetype_summary

-- DROP TABLE detect_filetype_summary;

CREATE TABLE detect_filetype_summary
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  deptcode character varying(32) NOT NULL,
  userid character varying(32) NOT NULL,
  searchtype character(1) NOT NULL,
  searchdate date NOT NULL,
  filetype character(1) NOT NULL,
  detectkeywordcount bigint NOT NULL,
  CONSTRAINT "PK_DETECT_FILETYPE_SUMMARY" PRIMARY KEY (companyid, deptcode, userid, searchtype, searchdate, filetype)
)
WITH (
  OIDS=FALSE
);

-- Index: "IDX_DETECT_FILETYPE_SUMMARY_SEARCHDATE"

-- DROP INDEX "IDX_DETECT_FILETYPE_SUMMARY_SEARCHDATE";

CREATE INDEX "IDX_DETECT_FILETYPE_SUMMARY_SEARCHDATE"
  ON detect_filetype_summary
  USING btree
  (searchdate);
