declare @client_id varchar(10)
declare @matter_id varchar(10)
declare @matterSysId int

declare my_cur cursor for 
select c.client_id, m.matter_id, m.system_id 
from docsadm.client c inner join docsadm.MATTER m on c.system_id = m.client_id
where m.system_id <> 0
order by 1, 2
open my_cur
fetch next from my_cur into @client_id, @matter_id, @matterSysId

declare @nextSysId int
set @nextSysId = 3000

declare @loopcnt int
declare @matterCnt int
set @matterCnt = 0

declare @lastClient_id varchar(10)

while @@fetch_status = 0
begin
	if @lastClient_Id = @client_id
	begin
		set @mattercnt = @mattercnt + 1
	end
	else
	begin
		set @mattercnt = 0
		set @lastClient_Id = @client_id
	end

	set @loopCnt = 0
	while @loopcnt < 3
	begin	
		insert into docsadm.link_matter_type (system_id, matter_link, type_link)
			values (@nextSysId, @matterSysId, 2799 + @matterCnt * 3 + @loopCnt)
		set @nextSysId = @nextSysId + 1
		set @loopCnt = @loopCnt + 1	
	end
	fetch next from my_cur into @client_id, @matter_id, @matterSysId
end
close my_cur
deallocate my_cur




--select System_id, type_id, description from docsadm.documenttypes 
--where system_id not in (929, 1454)
--order by system_id



