-- Table: drm_permission_policy_member

-- DROP TABLE drm_permission_policy_member;

CREATE TABLE drm_permission_policy_member
(
  seqno serial NOT NULL,
  companyid character varying(64) NOT NULL,
  policyid character varying(64) NOT NULL,
  deptcode character varying(32) NOT NULL,
  userid character varying(32) NOT NULL,
  CONSTRAINT "PK_DRM_PERMISSION_POLICY_MEMBER" PRIMARY KEY (companyid, policyid, deptcode, userid),
  CONSTRAINT "FK_DRM_PERMISSION_POLICY_MEMBER_GROUP" FOREIGN KEY (companyid, policyid)
      REFERENCES drm_permission_policy (companyid, policyid) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "FK_DRM_PERMISSION_POLICY_MEMBER_MEMBER" FOREIGN KEY (companyid, deptcode, userid)
      REFERENCES member (companyid, deptcode, userid) MATCH FULL
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);