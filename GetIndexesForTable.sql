IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[docsadm].[GetIndexesForTable]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[GetIndexesForTable]
go
create procedure docsadm.GetIndexesForTable 
( 
	@TableName	nvarchar(128),
	@LeaveTable	bit = 0
)
as

declare @pos	int
-- break apart the owner and the tablename
set @pos = CHARINDEX ('.' ,@TableName) 
if @pos = 0
begin 
	print 'Table owner must be specified eg. DOCSADM.PROFILE'
	return 
end
declare @TableOwner	nvarchar(128)
set @TableOwner = left(@TableName, @pos - 1)
set @TableName = right(@TableName, len(@TableName) - @pos)

-- Get the indexes on a table
declare Index_cur cursor for
	SELECT
		i.name AS [Name],
		/*'Server[@Name=' + quotename(CAST(serverproperty(N'Servername') AS sysname),'''') + ']' + '/Database[@Name=' + quotename(db_name(),'''') + ']' + '/Table[@Name=' + 
		quotename(tbl.name,'''') + ' and @Schema=' + quotename(stbl.name,'''') + ']' + '/Index[@Name=' + quotename(i.name,'''') + ']' AS [Urn],*/
		CAST(CASE i.indid WHEN 1 THEN 1 ELSE 0 END AS bit) AS [IsClustered],
		CAST(i.status&2 AS bit) AS [IsUnique]
	FROM
		dbo.sysobjects AS tbl
		INNER JOIN sysusers AS stbl ON stbl.uid = tbl.uid
		INNER JOIN dbo.sysindexes AS i ON (i.indid > 0 and i.indid < 255 and 1 != INDEXPROPERTY(i.id,i.name,N'IsStatistics') and 1 != INDEXPROPERTY(i.id,i.name,N'IsHypothetical')) AND (i.id=tbl.id)
	WHERE
		((tbl.type='U' or tbl.type='S'))and(tbl.name=@TableName and stbl.name=@TableOwner)
	ORDER BY
		[Name] ASC

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IndexData]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
begin
	Delete IndexData
end
else
begin
	create table IndexData
	(
		IndexId				tinyint,
		IndexName			nvarchar(128),
		IsClustered			bit,
		IsUnique			bit,
		ColumnId			tinyint,
		ColumnName			nvarchar(128),
		ColumnIsComputed	bit,
		ColumnDescending	bit
	)
end
declare @IndexName		nvarchar(128)
declare @IsClustered	bit
declare @IsUnique		bit
open Index_cur
fetch next from Index_cur into @IndexName, @IsClustered, @IsUnique
declare @IndexId	tinyint
set @IndexId = 1
while @@fetch_status = 0
begin
	-- get the index columns for each index on each table
	insert into IndexData (IndexId, IndexName, IsClustered, IsUnique, ColumnId, ColumnName, ColumnIsComputed, ColumnDescending)
		SELECT
			@IndexId, @IndexName, @IsClustered, @IsUnique, 
			CAST(ic.keyno AS tinyint) AS [ID],
			clmns.name AS [Name],
			CAST(COLUMNPROPERTY(ic.id, clmns.name, N'IsComputed') AS bit) AS [IsComputed],
			CAST(INDEXKEY_PROPERTY(ic.id, ic.indid, ic.keyno, N'IsDescending') AS bit) AS [Descending]
		FROM
			dbo.sysobjects AS tbl
			INNER JOIN sysusers AS stbl ON stbl.uid = tbl.uid
			INNER JOIN dbo.sysindexes AS i ON (i.indid > 0 and i.indid < 255 and 1 != INDEXPROPERTY(i.id,i.name,N'IsStatistics') and 1 != INDEXPROPERTY(i.id,i.name,N'IsHypothetical')) AND (i.id=tbl.id)
			INNER JOIN dbo.sysindexkeys AS ic ON CAST(ic.indid AS int)=CAST(i.indid AS int) AND ic.id=i.id
			INNER JOIN dbo.syscolumns AS clmns ON clmns.id = ic.id and clmns.colid = ic.colid and clmns.number = 0
		WHERE
			(i.name=@IndexName)and(((tbl.type='U' or tbl.type='S'))and(tbl.name=@TableName and stbl.name=@TableOwner))
		ORDER BY	[ID] ASC
	set @IndexId = @IndexId + 1
	-- get next index record
	fetch next from Index_cur into @IndexName, @IsClustered, @IsUnique
end

close Index_cur
deallocate Index_cur

select * from IndexData
if @LeaveTable = 0
	drop table IndexData