-- Table: drm_permission_policy

-- DROP TABLE drm_permission_policy;

CREATE TABLE drm_permission_policy
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  policyid character varying(64) NOT NULL,
  policyname character varying(64) NOT NULL,
  readpermission character(1) NOT NULL,
  writepermission character(1) NOT NULL,
  printpermission character(1) NOT NULL,
  expirationdate date NOT NULL,
  readlimitcount integer NOT NULL,
  CONSTRAINT "PK_DRM_PERMISSION_POLICY" PRIMARY KEY (companyid, policyid),
  CONSTRAINT "FK_DRM_PERMISSION_POLICY_COMPANY" FOREIGN KEY (companyid)
      REFERENCES company (companyid) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);