select user_id, full_name, g2.group_name as [primary group]/*, g.group_id*/, 'In ' + g.group_name
--	,*
from people p
	inner join peoplegroups pg on p.system_id = pg.people_system_id
	inner join groups g on pg.groups_system_id = g.system_id
	inner join groups g2 on primary_group = g2.system_id
order by 2, 3