select 
	case so.xtype 
		when 'FN'	then 'Scalar Functions'
		when 'IT'	then 'Message Queue'
		when 'P'	then 'Stored Procedure'
		when 'S'	then 'System Table'
		when 'PK'	then 'Primary Key'
		when 'SQ'	then 'Service Queue'
		when 'TR'	then 'Trigger'
		when 'U'	then 'User Table'
	end as [Object Type],
	USER_NAME(so.uid) as Owner,
	so.name as [Object Name], 
	sc.name as [Column Name], 
	st.name as [Data Type],
	sc.prec as [Length], sc.length as [Data Length], sc.isnullable as [Is Nullable]
from dbo.sysobjects AS so
	INNER JOIN dbo.syscolumns sc ON so.id = sc.id 
	inner join dbo.systypes st on sc.xusertype = st.xusertype
where so.xtype in ('U', 'P', 'TR', 'FN', 'PK')
order by 1, 2, 3, 4






