-- Table: force_search_pattern

-- DROP TABLE force_search_pattern;

CREATE TABLE force_search_pattern
(
  seqno serial NOT NULL,
  searchid character varying(15) NOT NULL,
  companyid character varying(64) NOT NULL,
  patternid integer NOT NULL,
  patternsubid integer NOT NULL,
  CONSTRAINT "PK_FORCE_SEARCH_PATTERN" PRIMARY KEY (searchid, companyid, patternid, patternsubid),
  CONSTRAINT "FK_FORCE_SEARCH_PATTERN_PATTERN" FOREIGN KEY (patternid, patternsubid)
      REFERENCES pattern (patternid, patternsubid) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "FK_FORCE_SEARCH_PATTERN_SEARCHID" FOREIGN KEY (searchid, companyid)
      REFERENCES force_search (searchid, companyid) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
