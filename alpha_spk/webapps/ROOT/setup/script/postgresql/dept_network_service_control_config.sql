-- Table: dept_network_service_control_config

-- DROP TABLE dept_network_service_control_config;

CREATE TABLE dept_network_service_control_config
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  deptcode character varying(32) NOT NULL,
  networkservicecontrolflag character(1) NOT NULL,
  blockspecificurlsflag character(1),
  lastmodifieddatetime timestamp without time zone,
  createdatetime timestamp without time zone NOT NULL,
  CONSTRAINT "PK_DEPT_NETWORK_SERVICE_CONTROL_CONFIG" PRIMARY KEY (companyid, deptcode),
  CONSTRAINT "FK_DEPT_NETWORK_SERVICE_CONTROL_CONFIG_DEPT" FOREIGN KEY (companyid, deptcode)
      REFERENCES dept (companyid, deptcode) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
