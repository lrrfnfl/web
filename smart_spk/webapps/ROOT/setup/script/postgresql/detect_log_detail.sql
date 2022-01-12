-- Table: detect_log_detail

-- DROP TABLE detect_log_detail;

CREATE TABLE detect_log_detail
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  deptcode character varying(32) NOT NULL,
  userid character varying(32) NOT NULL,
  searchid character varying(15) NOT NULL,
  searchtype character(1) NOT NULL,
  searchseqno integer NOT NULL,
  searchdate date NOT NULL,
  filetype character(1) NOT NULL,
  searchword character varying(128),
  patternid integer NOT NULL,
  patternsubid integer NOT NULL,
  detectkeywordcount bigint,
  createdatetime timestamp without time zone NOT NULL,
  CONSTRAINT "PK_DETECT_LOG_DETAIL" PRIMARY KEY (companyid, deptcode, userid, searchid, searchseqno, patternid, patternsubid),
  CONSTRAINT "FK_DETECT_LOG_DETAIL_PATTERN" FOREIGN KEY (patternid, patternsubid)
      REFERENCES pattern (patternid, patternsubid) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);

-- Index: "IDX_DETECT_LOG_DETAIL_SEQNO"

-- DROP INDEX "IDX_DETECT_LOG_DETAIL_SEQNO";

CREATE INDEX "IDX_DETECT_LOG_DETAIL_SEQNO"
  ON detect_log_detail
  USING btree
  (seqno);
