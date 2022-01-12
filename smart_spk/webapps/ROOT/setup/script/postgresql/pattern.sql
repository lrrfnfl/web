-- Table: pattern

-- DROP TABLE pattern;

CREATE TABLE pattern
(
  seqno serial NOT NULL,
  patternid integer NOT NULL,
  patterncategoryname character varying(128) NOT NULL,
  patternsubid integer NOT NULL,
  patternname character varying(128) NOT NULL,
  patterntext text NOT NULL,
  updatelockflag character(1) NOT NULL,
  defaultsearchflag character(1) NOT NULL,
  CONSTRAINT "PK_PATTERN" PRIMARY KEY (patternid, patternsubid)
)
WITH (
  OIDS=FALSE
);
