-- Table: dept_exclusion_search_folders

-- DROP TABLE dept_exclusion_search_folders;

CREATE TABLE dept_exclusion_search_folders
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  deptcode character varying(32) NOT NULL,
  path text NOT NULL,
  CONSTRAINT "PK_DEPT_EXCLUSION_SEARCH_FOLDERS" PRIMARY KEY (companyid, deptcode, path),
  CONSTRAINT "FK_DEPT_EXCLUSION_SEARCH_FOLDERS_DEPT" FOREIGN KEY (companyid, deptcode)
      REFERENCES dept (companyid, deptcode) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
