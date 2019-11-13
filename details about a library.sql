-- count the security recs per profile
select docnumber, COUNT(thing) 
from docsadm.PROFILE p 
join docsadm.SECURITY s on p.SYSTEM_ID = s.THING 
group by docnumber
having COUNT(thing) > 2
order by 2 desc

-- NUMBER OF FOLK IN THE DATABASE
select count(*)  from docsadm.people
select count(*)  from docsadm.groups

-- get the acl and profile defaults 
select acl_defaults, profile_defaults from docsadm.form_user
where ACL_DEFAULTS is not null and ACL_DEFAULTS <> '' and PROFILE_DEFAULTS is not null
select acl_defaults, profile_defaults from docsadm.GROUPS
where ACL_DEFAULTS is not null and ACL_DEFAULTS <> '' and PROFILE_DEFAULTS is not null 
select acl_defaults, profile_defaults from docsadm.PEOPLE
where ACL_DEFAULTS is not null and ACL_DEFAULTS <> '' and PROFILE_DEFAULTS is not null
select acl_defaults, profile_defaults from docsadm.PROFILE_DEFAULTS
where ACL_DEFAULTS is not null and ACL_DEFAULTS <> '' and PROFILE_DEFAULTS is not null 