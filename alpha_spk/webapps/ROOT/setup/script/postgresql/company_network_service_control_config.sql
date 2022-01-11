-- Table: company_network_service_control_config

-- DROP TABLE company_network_service_control_config;

CREATE TABLE company_network_service_control_config
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  networkservicecontrolflag character(1) NOT NULL,
  blockspecificurlsflag character(1),
  lastmodifieddatetime timestamp without time zone,
  createdatetime timestamp without time zone NOT NULL,
  CONSTRAINT "PK_COMPANY_NETWORK_SERVICE_CONTROL_CONFIG" PRIMARY KEY (companyid),
  CONSTRAINT "FK_COMPANY_NETWORK_SERVICE_CONTROL_CONFIG_COMPANY" FOREIGN KEY (companyid)
      REFERENCES company (companyid) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
