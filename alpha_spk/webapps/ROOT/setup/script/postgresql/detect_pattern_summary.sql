-- Table: detect_pattern_summary

-- DROP TABLE detect_pattern_summary;

CREATE TABLE detect_pattern_summary
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  deptcode character varying(32) NOT NULL,
  userid character varying(32) NOT NULL,
  searchtype character(1) NOT NULL,
  searchdate date NOT NULL,
  patternid integer NOT NULL,
  patternsubid integer NOT NULL,
  detectkeywordcount bigint NOT NULL,
  CONSTRAINT "PK_DETECT_PATTERN_SUMMARY" PRIMARY KEY (companyid, deptcode, userid, searchtype, searchdate, patternid, patternsubid),
  CONSTRAINT "FK_DETECT_PATTERN_SUMMARY_PATTERN" FOREIGN KEY (patternid, patternsubid)
      REFERENCES pattern (patternid, patternsubid) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);

-- Index: "IDX_DETECT_PATTERN_SUMMARY_SEARCHDATE"

-- DROP INDEX "IDX_DETECT_PATTERN_SUMMARY_SEARCHDATE";

CREATE INDEX "IDX_DETECT_PATTERN_SUMMARY_SEARCHDATE"
  ON detect_pattern_summary
  USING btree
  (searchdate);
