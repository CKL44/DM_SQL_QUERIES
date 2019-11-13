select f.form_name as [primary Profile form], f2.form_name as [Hitlist form],* from groups g 
	left outer join forms f on g.profile_form = f.system_id
	left outer join forms f2 on g.hitlist_form = f2.system_id

select g.group_name, f.form_name
	--, * 
from search_form sf
	inner join forms f on sf.form_id = f.system_id
	inner join groups g on sf.group_id = g.system_id
order by 1, 2