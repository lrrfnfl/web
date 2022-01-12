-- Table: member_exclusion_search_folders

-- DROP TABLE member_exclusion_search_folders;

CREATE TABLE member_exclusion_search_folders
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  deptcode character varying(32) NOT NULL,
  userid character varying(32) NOT NULL,
  path text NOT NULL,
  CONSTRAINT "PK_MEMBER_EXCLUSION_SEARCH_FOLDERS" PRIMARY KEY (companyid, deptcode, userid, path),
  CONSTRAINT "FK_MEMBER_EXCLUSION_SEARCH_FOLDERS_MEMBER" FOREIGN KEY (companyid, deptcode, userid)
      REFERENCES member (companyid, deptcode, userid) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
