-- Table: safe_export_files

-- DROP TABLE safe_export_files;

CREATE TABLE safe_export_files
(
  seqno serial NOT NULL,
  exportid character varying(64) NOT NULL,
  filename character varying(128) NOT NULL,
  CONSTRAINT "PK_SAFE_EXPORT_FILES" PRIMARY KEY (exportid, filename),
  CONSTRAINT "FK_SAFE_EXPORT_FILES" FOREIGN KEY (exportid)
      REFERENCES safe_export (exportid) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);

-- Index: "IDX_SAFE_EXPORT_FILES_SEQNO"

-- DROP INDEX "IDX_SAFE_EXPORT_FILES_SEQNO";

CREATE INDEX "IDX_SAFE_EXPORT_FILES_SEQNO"
  ON safe_export_files
  USING btree
  (seqno);

