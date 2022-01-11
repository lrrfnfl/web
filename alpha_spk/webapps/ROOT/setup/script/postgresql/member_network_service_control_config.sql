-- Table: member_network_service_control_config

-- DROP TABLE member_network_service_control_config;

CREATE TABLE member_network_service_control_config
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  deptcode character varying(32) NOT NULL,
  userid character varying(32) NOT NULL,
  networkservicecontrolflag character(1) NOT NULL,
  blockspecificurlsflag character(1),
  lastmodifieddatetime timestamp without time zone,
  createdatetime timestamp without time zone NOT NULL,
  CONSTRAINT "PK_MEMBER_NETWORK_SERVICE_CONTROL_CONFIG" PRIMARY KEY (companyid, deptcode, userid),
  CONSTRAINT "FK_MEMBER_NETWORK_SERVICE_CONTROL_CONFIG_MEMBER" FOREIGN KEY (companyid, deptcode, userid)
      REFERENCES member (companyid, deptcode, userid) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
