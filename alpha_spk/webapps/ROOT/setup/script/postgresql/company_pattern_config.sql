-- Table: company_pattern_config

-- DROP TABLE company_pattern_config;

CREATE TABLE company_pattern_config
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  patternid integer NOT NULL,
  patternsubid integer NOT NULL,
  defaultsearchflag character(1) NOT NULL,
  jobprocessingactivecount integer NOT NULL DEFAULT 1,
  CONSTRAINT "PK_COMPANY_PATTERN_CONFIG" PRIMARY KEY (companyid, patternid, patternsubid),
  CONSTRAINT "FK_COMPANY_PATTERN_CONFIG_COMPANY" FOREIGN KEY (companyid)
      REFERENCES company (companyid) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "FK_COMPANY_PATTERN_CONFIG_PATTERN" FOREIGN KEY (patternid, patternsubid)
      REFERENCES pattern (patternid, patternsubid) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
