-- Table: company_default_pattern

-- DROP TABLE company_default_pattern;

CREATE TABLE company_default_pattern
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  patternid integer NOT NULL,
  patternsubid integer NOT NULL,
  CONSTRAINT "PK_COMPANY_DEFAULT_PATTERN" PRIMARY KEY (companyid, patternid, patternsubid),
  CONSTRAINT "FK_COMPANY_DEFAULT_PATTERN_COMPANY" FOREIGN KEY (companyid)
      REFERENCES company (companyid) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "FK_COMPANY_DEFAULT_PATTERN_PATTERN" FOREIGN KEY (patternid, patternsubid)
      REFERENCES pattern (patternid, patternsubid) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
