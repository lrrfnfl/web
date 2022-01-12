-- Table: dept_block_specific_urls

-- DROP TABLE dept_block_specific_urls;

CREATE TABLE dept_block_specific_urls
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  deptcode character varying(32) NOT NULL,
  blockurl character varying(128) NOT NULL,
  CONSTRAINT "PK_DEPT_BLOCK_SPECIFIC_URLS" PRIMARY KEY (companyid, deptcode, blockurl),
  CONSTRAINT "FK_DEPT_BLOCK_SPECIFIC_URLS_DEPT" FOREIGN KEY (companyid, deptcode)
      REFERENCES dept (companyid, deptcode) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
