-- Table: company_exclusion_search_folders

-- DROP TABLE company_exclusion_search_folders;

CREATE TABLE company_exclusion_search_folders
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  path text NOT NULL,
  CONSTRAINT "PK_COMPANY_EXCLUSION_SEARCH_FOLDERS" PRIMARY KEY (companyid, path),
  CONSTRAINT "FK_COMPANY_EXCLUSION_SEARCH_FOLDERS_COMPANY" FOREIGN KEY (companyid)
      REFERENCES company (companyid) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
