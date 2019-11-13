-- get all the dynamic Views defined
select dv.*, dvl.*, 
	dc.tbname, dc.colname, f.form_name
from docsadm.dynamic_view dv 
	inner join docsadm.docscolumn dc on dv.PROFILE_JOIN_LINK = dc.system_id
	inner join docsadm.dynamic_view_lang dvl on dv.system_id = dvl.dynamic_view_link
	inner join docsadm.forms f on dvl.form_link = f.system_id
order by order_no




-- get the views information
select vl.*, vll.*,
	DC1.tbname, dc1.colname, dc2.colname
from docsadm.view_level VL
	left outer join docsadm.docscolumn dc1 on vl.ID_COLUMN_LINK = dc1.system_id
	left outer join docsadm.docscolumn dc2 on vl.FILTER_COLUMN_LINK= dc2.system_id
	inner join docsadm.view_level_lang vll on vl.system_id = vll.view_level_link
--where dynamic_view_link = 1790
order by level_no


