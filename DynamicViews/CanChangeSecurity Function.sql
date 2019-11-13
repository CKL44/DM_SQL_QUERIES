-- paramaters in are 
-- 1) a conglomeration of the System_id's of all the %_PERSON columns in the current Levels tables
-- 2) a amalgamation of the current user system_id and all of the other users system_id's that have delegated security privelege for this view

create function docsadm.CAN_CHANGE_SECURITY 
	(@SecuritySysIds	varchar(200), 
	 @CheckSysIds		varchar(200)) returns int
begin
/*	declare @SecuritySysIds		varchar(200) 
	set @SecuritySysIds = '5234,62533,9833,'
	declare @CheckSysIds		varchar(200)
	set @CheckSysIds = '9872359,98333,123123,'
*/
	declare @UpTo		int
	set @upto = 1
	declare @CommaAt	int
	declare @SecurityId	varchar(15)

	declare @upto2		int
	declare @CommaAt2	int
	declare @UserSysId	varchar(15)

	while 1 = 1
	begin
		set @CommaAt = charindex(',', @SecuritySysIds, @upTo)
		if @CommaAt = 0
			break
		set @SecurityId = Substring(@SecuritySysIds, @UpTo, @CommaAt - @UpTo)
		if @SecurityId = '-1'
			continue;
		--print 'SecurityId = ' + @SecurityId 
		-- now check and see if this value is in the second string of numbers
		set @UpTo2 = 1
		while 1 = 1 
		begin
			set @CommaAt2 = charindex(',', @CheckSysIds, @upTo2)
			if @CommaAt2 = 0 
				break;
			set @UserSysId = Substring(@CheckSysIds, @UpTo2, @CommaAt2 - @UpTo2)
			--print 'User id = ' + @userSysId
			if @SecurityId = @UserSysId
				return 1
/*			begin
				print 'True' 
				goto done
			end */
			set @UpTo2 = @CommaAt2 + 1
		end	
		set @UpTo = @CommaAt + 1
	end
	-- if it gets here then they don't have access
	return 0
--	print 'False'
--done:
end
go

grant all on docsadm.CAN_CHANGE_SECURITY to docs_users
go