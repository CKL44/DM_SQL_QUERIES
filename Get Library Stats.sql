select version from docsadm.docsparms
go
-- run the query to get all the tables
declare  sel_cur cursor for 
	SELECT sch.name + '.' + so.name
		FROM sys.objects so
		join sys.schemas sch on so.schema_id = sch.schema_id
		WHERE type in (N'U')
	order by 1

declare @tablename	nvarchar (150)
DECLARE	@cmd VARCHAR(500), @cnt INT

CREATE TABLE #CntFile (Tablename varchar(80), cnt INT)
	
--Print 'Record Counts for tables in database: ' + DB_NAME()
open sel_cur
fetch next from sel_cur into @tablename
while @@FETCH_STATUS = 0
begin
	--set @tablename = 'DOCSADM.' + @tablename
	SET @cmd = 'declare @cnt int select @cnt = count(*) from ' + @tablename + ' INSERT #CntFile VALUES(''' + @tablename + ''', @cnt)'
--	print @cmd
	EXEC(@cmd)

	fetch next from sel_cur into @tablename
end

close sel_cur
deallocate sel_cur

select tablename as [Table Name], cnt as [Count for Table] from #cntfile
order by 2 desc

drop TABLE #CntFile 

go
--print 'Folder content count where content items number > 500'
-- select the folder count where content is > 500 items
select p.DOCNAME as [Doc Name], PARENT as [Container Doc#], COUNT(*) as [Number of Children] 
from 
	DOCSADM.FOLDER_ITEM fi
	join DOCSADM.profile p on fi.PARENT = p.DOCNUMBER   
group by p.docname, PARENT
having COUNT(*) > 500
order by 3 desc
go
