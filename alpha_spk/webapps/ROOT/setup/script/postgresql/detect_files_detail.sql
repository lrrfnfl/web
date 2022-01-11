-- Table: detect_files_detail

-- DROP TABLE detect_files_detail;

CREATE TABLE detect_files_detail
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  deptcode character varying(32) NOT NULL,
  userid character varying(32) NOT NULL,
  searchpathhash character varying(64) NOT NULL,
  patternid integer NOT NULL,
  detectkeywordcount bigint NOT NULL DEFAULT 0,
  CONSTRAINT "PK_DETECT_FILES_DETAIL" PRIMARY KEY (companyid, deptcode, userid, searchpathhash, patternid)
)
WITH (
  OIDS=FALSE
);

-- Index: "IDX_DETECT_FILES_DETAIL_SEQNO"

-- DROP INDEX "IDX_DETECT_FILES_DETAIL_SEQNO";

CREATE UNIQUE INDEX "IDX_DETECT_FILES_DETAIL_SEQNO"
  ON detect_files_detail
  USING btree
  (seqno);
