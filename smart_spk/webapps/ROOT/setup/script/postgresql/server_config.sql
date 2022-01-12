-- Table: server_config

-- DROP TABLE server_config;

CREATE TABLE server_config
(
  servertype character(1) NOT NULL,
  version character varying(32) NOT NULL,
  oem character varying(32),
  forcedloginflag character(1) NOT NULL,
  logintriallimitcount integer NOT NULL,
  relogindelaysecondafterlock integer NOT NULL,
  adminaccessableaddressmaxcount integer NOT NULL,
  representativecompanyid character varying(64) NOT NULL
)
WITH (
  OIDS=FALSE
);
