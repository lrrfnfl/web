-- Table: company_setup_config

-- DROP TABLE company_setup_config;

CREATE TABLE company_setup_config
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  dbprotectionoption character(1),
  printcontroloption character(1),
  watermarkoption character(1),
  mediacontroloption character(1),
  networkservicecontroloption character(1),
  softwaremanageoption character(1),
  ransomwaredetectionoption character(1),
  defaultkeepfileperiod integer,
  CONSTRAINT "PK_COMPANY_SETUP_CONFIG" PRIMARY KEY (companyid),
  CONSTRAINT "FK_COMPANY_SETUP_CONFIG_COMPANY" FOREIGN KEY (companyid)
      REFERENCES company (companyid) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
