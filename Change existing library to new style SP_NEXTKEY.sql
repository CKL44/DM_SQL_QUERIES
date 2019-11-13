set nocount on 
------------------------------------------------------------------------------------------------------------------
-- check and see if the new style sp_nextkey is already there
-- if the SEQ_* tables are there and there is NO FIELD columns then we are using the new procedure already so exit
------------------------------------------------------------------------------------------------------------------
declare @cnt integer
-- check and see if we are using the new SEQ_ tables
SELECT @cnt = count(*) FROM dbo.sysobjects so 
WHERE so.name like 'SEQ_%' 

declare @sql		varchar(500)

declare @tbname		varchar(37)
declare @nextId		int

if @cnt > 0 
begin
	-- now check and see if we are using the autoincrement fields or the new SEQ_ style 
	SELECT @cnt = count(*) FROM dbo.sysobjects so 
		inner join dbo.syscolumns sc on so.id = sc.id
	WHERE so.name like 'SEQ_%' and sc.name = 'FIELD'
	if @cnt = 0			  -- we must have upgraded the procedure previously - so exit
	begin
		print 'Already using the new SP_NEXTKEY procedure, Exiting'
		goto UpdateStoredProc
	end

	print 'Found version 6.x style sequences'
	-- if it gets here we need to upgrade our old SEQ_ tables to the new style
	declare NewKeys_cursor CURSOR STATIC FOR
		SELECT name FROM dbo.sysobjects WHERE name like 'SEQ_%' 
	open NewKeys_cursor 
	fetch next from NewKeys_cursor 
		into @tbname
	WHILE @@FETCH_STATUS = 0
	BEGIN
		set @tbname = 'DOCSADM.' + @tbname
		-- get the current value of the identity seed, by running the old sp_nextkey stored procedure
		select @nextId = ident_current(@tbname)

		-- now we need to delete the old table and create the new one
		set @sql = 'drop table ' + @tbname
		EXEC(@sql)		
		print 'Creating table ' + @tbname
		set @sql = 'CREATE TABLE ' + @tbname + ' (LASTKEY int NOT NULL)'
		EXEC(@sql)
		-- we need to grant access to docsadm and the docs_users group
		set @sql = 'GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE ON ' + @tbname + ' to DOCS_USERS'
		EXEC(@sql)
		-- now add the LASTKEY record in the table with the valid lastkey value
		print 'Setting up the ' + @tbname + ' table with value: ' + convert(varchar(12), @nextId)
		set @sql = 'INSERT INTO ' + @tbname + ' (LASTKEY) VALUES (' + convert(varchar(12), @nextId) + ')'
		EXEC(@sql)

		-- get next and deal with it 	
		fetch next from NewKeys_cursor 
			into @tbname
	end
	close NewKeys_cursor
	DEALLOCATE NewKeys_cursor
end
else
begin
	print 'Found version 5.x style sequences from DOCS_UNIQUE_KEYS'
	------------------------------------------------------------------------------------------------------------
	-- we must have the old DM 5.x style SP_NEXTKEY procedure so pull the values from the DOCS_UNIQUE_KEYS table
	-- transfer the existing sequence values to the new identity based tables
	------------------------------------------------------------------------------------------------------------
	declare CurrentKeys_cursor CURSOR STATIC FOR
		select tbname, lastkey from docsadm.docs_unique_keys
	open CurrentKeys_cursor 
	fetch next from CurrentKeys_cursor 
		into @tbname, @nextId
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- if the key value has a docsadm on the fron of it then remove it 
		set @tbname = 'DOCSADM.SEQ_' + REPLACE(@tbname,'DOCSADM.','')
		--print @tbname
		-- lets ensure that the new table is create if it doesn't already exist
		set @sql = 'SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N''' + @tbname + ''') AND OBJECTPROPERTY(id, N''IsUserTable'') = 1'
		--print @sql
		EXEC(@sql)
		-- if the table already exists - don't try and create it again
		if @@rowcount = 0
		begin
			print 'Creating table ' + @tbname
			set @sql = 'CREATE TABLE ' + @tbname + ' (LASTKEY int NOT NULL)'
			EXEC(@sql)
			-- we need to grant access to docsadm and the docs_users group
			set @sql = 'GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE ON ' + @tbname + ' to DOCS_USERS'
			EXEC(@sql)
		end
		-- set the current value for LastKey into the new table LASTKEY column
		print 'Setting up the ' + @tbname + ' table with value: ' + convert(varchar(12), @nextId)
		set @sql = 'INSERT INTO ' + @tbname + ' (LASTKEY) VALUES (' + convert(varchar(12), @nextId) + ')'
		EXEC(@sql)

		-- get next and deal with it 	
		fetch next from CurrentKeys_cursor 
			into @tbname, @nextId
	end
	close CurrentKeys_cursor
	DEALLOCATE CurrentKeys_cursor
end


UpdateStoredProc:
GO
-------------------------------------------------------------------
-- now create the new storehed Proc
-------------------------------------------------------------------
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'DOCSADM.sp_nextkey') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
	drop procedure docsadm.sp_nextkey
GO
CREATE procedure [DOCSADM].[sp_nextkey] @table VARCHAR(30), @NoRequired varchar(5) = '1' as 
set nocount on 
set @table = 'DOCSADM.SEQ_' + REPLACE(@table,'DOCSADM.','') 

exec ('DECLARE @ID INT UPDATE ' + @table + ' SET @ID = LASTKEY = LASTKEY + ' + @NoRequired + ' SELECT @ID')
GO
GRANT EXECUTE ON DOCSADM.SP_NEXTKEY TO DOCS_USERS
GO

