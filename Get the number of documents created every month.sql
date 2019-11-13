--------------------
-- requires the YearMonth scalar function defined in sql file of similar name  
--------------------- 
 
select docsadm.YearMonth(CREATION_DATE), user_id, COUNT(*)
from DOCSADM.FOLDER_ITEM fi 
	join DOCSADM.PROFILE p on fi.DOCNUMBER = p.DOCNUMBER
	join DOCSADM.PEOPLE u on p.AUTHOR = u.system_id
where fi.PARENT = 161715
group by  docsadm.YearMonth(CREATION_DATE), USER_ID
--datename(yy, CREATION_DATE) + '/' + convert(varchar(2), datepart(mm, CREATION_DATE))
order by 1, 3 desc





