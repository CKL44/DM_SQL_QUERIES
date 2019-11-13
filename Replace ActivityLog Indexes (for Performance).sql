-- we need to go get all the existing indexes and drop them 
declare cur_ActLogIndexes INSENSITIVE cursor for 
	SELECT name
	FROM sys.indexes 
	WHERE object_id = OBJECT_ID(N'DOCSADM.ACTIVITYLOG') 
	order by type_desc desc		-- want the nonclustered indexes first - so i can delete the clustered index lastDROP INDEX [act_log_trial1] ON [DOCSADM].[ACTIVITYLOG] WITH ( ONLINE = OFF )
	for read only
open cur_ActLogIndexes

declare @idxName		varchar(80)
fetch next from cur_ActLogIndexes into @idxName
WHILE @@FETCH_STATUS = 0
begin
	print ('dropping:' + @idxName)
	exec ('DROP INDEX ' + @idxName + ' ON DOCSADM.ACTIVITYLOG')
	-- get next index name 	
	fetch next from cur_ActLogIndexes into @idxName
end
close cur_ActLogIndexes
deallocate cur_ActLogIndexes
go

-- create the primary clustered index on the ActivityLog System_id column
CREATE UNIQUE CLUSTERED INDEX ACTIVITYLOG_P ON DOCSADM.ACTIVITYLOG 
(
	SYSTEM_ID ASC
)
go

-- create the secondary index on the ActivityLog docnumber column for access for queries linking from tables using the docnumber 
CREATE NONCLUSTERED INDEX ACTIVITYLOG_DOCNO ON DOCSADM.ACTIVITYLOG 
(
	DOCNUMBER ASC,
	SYSTEM_ID ASC
)
go

-- create a generic index with all the field required to do the RED list search
CREATE NONCLUSTERED INDEX ACTIVITYLOG_RED ON DOCSADM.ACTIVITYLOG 
(
	TYPIST ASC,
	START_DATE ASC,
	DOCNUMBER ASC,
	ACTIVITY_TYPE ASC,
	SYSTEM_ID ASC
)
go

