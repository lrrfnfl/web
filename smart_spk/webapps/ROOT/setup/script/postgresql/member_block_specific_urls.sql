-- Table: member_block_specific_urls

-- DROP TABLE member_block_specific_urls;

CREATE TABLE member_block_specific_urls
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  deptcode character varying(32) NOT NULL,
  userid character varying(32) NOT NULL,
  blockurl character varying(128) NOT NULL,
  CONSTRAINT "PK_MEMBER_BLOCK_SPECIFIC_URLS" PRIMARY KEY (companyid, deptcode, userid, blockurl),
  CONSTRAINT "FK_MEMBER_BLOCK_SPECIFIC_URLS_MEMBER" FOREIGN KEY (companyid, deptcode, userid)
      REFERENCES member (companyid, deptcode, userid) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
