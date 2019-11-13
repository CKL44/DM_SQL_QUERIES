declare @oldestLogin datetime
declare @sysId int
declare @userId varchar(25)

select top 1 @oldestLogin = last_login_date, @sysId = p.system_id, @userid = p.user_id
from docsadm.people p
	inner join docsadm.network_aliases na on p.system_id = na.personorgroup
where user_id <> 'INTERNAL' and primary_group = 1 and last_login_date is not null
order by 1 asc
print @UserId
print @OldestLogin
print @sysId

update docsadm.people 
set USER_ID = 'GNILSSON', full_name = 'Grant Nilsson', allow_login = 'Y', USER_PASSWORD = 'a' 
where system_id = @sysId

update docsadm.network_aliases
set network_id = 'Opentext\GNILSSON'
where personorgroup = @SysId

delete docsadm.network_aliases
where personorgroup = @SysId
