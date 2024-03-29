declare @cnt int
declare @sysid int
set @cnt = 1
while @cnt < 5000
begin
	set @sysid = @cnt + 1000000	-- start at 1 million for sysid's
	insert into docsadm.people 
		(system_id, user_id, full_name			  
			  ,[DISABLED]
			  ,[USER_PASSWORD]
			  ,[USER_LOCATION]
			  ,[PHONE]
			  ,[EXTENSION]
			  ,[LAST_LOGIN_DATE]
			  ,[LAST_LOGIN_TIME]
			  ,[ALLOW_LOGIN]
			  ,[FAX]
			  ,[DID]
			  ,[TARGET_DOCSRVR]
			  ,[PRIMARY_GROUP]
			  ,[PRIMARY_LIB]
			  ,[PROFILE_DEFAULTS]
			  ,[CONNECT_BRIDGED]
			  ,[BUTTON_BAR]
			  ,[NETWORK_ID]
			  ,[ACL_DEFAULTS]
			  ,[SHOW_RESTORED]
			  ,[PASS_EXP_DATE]
			  ,[LOGINS_REMAINING]
			  ,[PSWORD_VALID_FOR]
			  ,[NO_EXP_DATE]
			  ,[DR_USER]
			  ,[SEARCH_FORM_ID]
			  ,[EMAIL_ADDRESS]
)
		SELECT @sysid
			  ,'User-' + convert(varchar(20), @cnt) 
			  ,'Full name - ' + convert(varchar(20), @cnt)
			  ,[DISABLED]
			  ,[USER_PASSWORD]
			  ,[USER_LOCATION]
			  ,[PHONE]
			  ,[EXTENSION]
			  ,[LAST_LOGIN_DATE]
			  ,[LAST_LOGIN_TIME]
			  ,[ALLOW_LOGIN]
			  ,[FAX]
			  ,[DID]
			  ,[TARGET_DOCSRVR]
			  ,[PRIMARY_GROUP]
			  ,[PRIMARY_LIB]
			  ,[PROFILE_DEFAULTS]
			  ,[CONNECT_BRIDGED]
			  ,[BUTTON_BAR]
			  ,[NETWORK_ID]
			  ,[ACL_DEFAULTS]
			  ,[SHOW_RESTORED]
			  ,[PASS_EXP_DATE]
			  ,[LOGINS_REMAINING]
			  ,[PSWORD_VALID_FOR]
			  ,[NO_EXP_DATE]
			  ,[DR_USER]
			  ,[SEARCH_FORM_ID]
			  ,[EMAIL_ADDRESS]
		  FROM lib5105sr7.[DOCSADM].[PEOPLE]
		where user_id = 'Grant'

	insert into docsadm.peoplegroups
		(groups_system_id, people_system_id) values 
		(1010000 + @cnt / 5, @sysid)

	set @cnt = @cnt + 1

end
go


-- select * from docsadm.groups 
--select * from docsadm.peoplegroups 
--where people_system_id = 3092
--
--select * from docsadm.people

--delete docsadm.peoplegroups where last_update >'2009-08-05' 