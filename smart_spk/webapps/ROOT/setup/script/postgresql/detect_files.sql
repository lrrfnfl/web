-- Table: detect_files

-- DROP TABLE detect_files;

CREATE TABLE detect_files
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  deptcode character varying(32) NOT NULL,
  userid character varying(32) NOT NULL,
  searchpathhash character varying(64) NOT NULL,
  lastsearchid character varying(15) NOT NULL,
  lastsearchseqno integer NOT NULL,
  lastsearchtype character(1) NOT NULL,
  lastsearchdate date NOT NULL,
  lastresult character varying(2) NOT NULL,
  searchpath character varying(512) NOT NULL,
  filetype character(1) NOT NULL,
  filecategory character(1),
  comment text,
  filecreationdate date,
  fileexpirationdate date,
  lastmodifierid character varying(32),
  lastmodifieddatetime timestamp without time zone,
  CONSTRAINT "PK_DETECT_FILES" PRIMARY KEY (companyid, deptcode, userid, searchpathhash)
)
WITH (
  OIDS=FALSE
);

-- Index: "IDX_DETECT_FILES_LASTSEARCHDATE"

-- DROP INDEX "IDX_DETECT_FILES_LASTSEARCHDATE";

CREATE INDEX "IDX_DETECT_FILES_LASTSEARCHDATE"
  ON detect_files
  USING btree
  (lastsearchdate);
ALTER TABLE detect_files CLUSTER ON "IDX_DETECT_FILES_LASTSEARCHDATE";

-- Index: "IDX_DETECT_FILES_SEQNO"

-- DROP INDEX "IDX_DETECT_FILES_SEQNO";

CREATE INDEX "IDX_DETECT_FILES_SEQNO"
  ON detect_files
  USING btree
  (seqno);

