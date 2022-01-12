-- Table: search_result_summary_detail

-- DROP TABLE search_result_summary_detail;

CREATE TABLE search_result_summary_detail
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  deptcode character varying(32) NOT NULL,
  userid character varying(32) NOT NULL,
  searchid character varying(15) NOT NULL,
  searchtype character(1) NOT NULL,
  searchdate date NOT NULL,
  patternid integer NOT NULL,
  patternsubid integer NOT NULL,
  detectkeywordcount bigint NOT NULL DEFAULT 0,
  CONSTRAINT "PK_SEARCH_RESULT_SUMMARY_DETAIL" PRIMARY KEY (companyid, deptcode, userid, searchid, patternid, patternsubid),
  CONSTRAINT "FK_SEARCH_RESULT_SUMMARY_DETAIL_PATTERN" FOREIGN KEY (patternid, patternsubid)
      REFERENCES pattern (patternid, patternsubid) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);

-- Index: "IDX_SEARCH_RESULT_SUMMARY_DETAIL_SEARCHDATE"

-- DROP INDEX "IDX_SEARCH_RESULT_SUMMARY_DETAIL_SEARCHDATE";

CREATE INDEX "IDX_SEARCH_RESULT_SUMMARY_DETAIL_SEARCHDATE"
  ON search_result_summary_detail
  USING btree
  (searchdate);
