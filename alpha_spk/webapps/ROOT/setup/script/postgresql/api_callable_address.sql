-- Table: api_callable_address

-- DROP TABLE api_callable_address;

CREATE TABLE api_callable_address
(
  seqno serial NOT NULL,
  ipaddress character varying(32) NOT NULL,
  callername character varying(128) NOT NULL,
  CONSTRAINT "PK_API_CALLABLE_ADDRESS" PRIMARY KEY (ipaddress)
)
WITH (
  OIDS=FALSE
);
