-- Table: safe_export

-- DROP TABLE safe_export;

CREATE TABLE safe_export
(
  seqno serial NOT NULL,
  exportid character varying(64) NOT NULL,
  companyid character varying(64) NOT NULL,
  deptcode character varying(32) NOT NULL,
  userid character varying(32) NOT NULL,
  receiver character varying(128) NOT NULL,
  receiveremail character varying(128) NOT NULL,
  description text,
  decoder character varying(128),
  decodedipaddress character varying(32),
  decodedclientid character varying(64),
  decodeddatetime timestamp without time zone,
  exportfilescount integer NOT NULL DEFAULT 0,
  decodestatus character(1),
  createdatetime timestamp without time zone NOT NULL,
  CONSTRAINT "PK_SAFE_EXPORT" PRIMARY KEY (exportid),
  CONSTRAINT "FK_SAFE_EXPORT_MEMBER" FOREIGN KEY (companyid, deptcode, userid)
      REFERENCES member (companyid, deptcode, userid) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);

-- Index: "IDX_SAFE_EXPORT_EXPORTID"

-- DROP INDEX "IDX_SAFE_EXPORT_EXPORTID";

CREATE INDEX "IDX_SAFE_EXPORT_EXPORTID"
  ON safe_export
  USING btree
  (exportid COLLATE pg_catalog."default");

