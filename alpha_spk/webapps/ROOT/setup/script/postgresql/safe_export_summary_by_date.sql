-- Table: safe_export_summary_by_date

-- DROP TABLE safe_export_summary_by_date;

CREATE TABLE safe_export_summary_by_date
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  deptcode character varying(32) NOT NULL,
  userid character varying(32) NOT NULL,
  exportdate date NOT NULL,
  exportcount integer NOT NULL DEFAULT 0,
  exportfilescount integer NOT NULL DEFAULT 0,
  decodedcount integer NOT NULL DEFAULT 0,
  decodedfilescount integer NOT NULL DEFAULT 0,
  CONSTRAINT "PK_SAFE_EXPORT_SUMMARY_BY_DATE" PRIMARY KEY (companyid, deptcode, userid, exportdate),
  CONSTRAINT "FK_SAFE_EXPORT_SUMMARY_BY_DATE_MEMBER" FOREIGN KEY (companyid, deptcode, userid)
      REFERENCES member (companyid, deptcode, userid) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
