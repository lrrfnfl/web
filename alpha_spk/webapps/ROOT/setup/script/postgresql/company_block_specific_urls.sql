-- Table: company_block_specific_urls

-- DROP TABLE company_block_specific_urls;

CREATE TABLE company_block_specific_urls
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  blockurl character varying(128) NOT NULL,
  CONSTRAINT "PK_COMPANY_BLOCK_SPECIFIC_URLS" PRIMARY KEY (companyid, blockurl),
  CONSTRAINT "FK_COMPANY_BLOCK_SPECIFIC_URLS_COMPANY" FOREIGN KEY (companyid)
      REFERENCES company (companyid) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
