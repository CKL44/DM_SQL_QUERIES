--select * from subscriptions
--select * from level_search ls inner join level_search_lang lsl on ls.system_id = lsl.level_search_link and language = 'ENU'
--select * from level_items

-- this SQL will return all the sxearch objects associated to their respective levels (for a particular dynamic view)
select level_no, colname, tbname, level_search_id, level_search_name, form_name, criteria  
from view_level vl 
	inner join docscolumn cid on id_column_link = cid.system_id
	inner join level_items li on vl.system_id = li.view_level_link 
		inner join level_search ls on li.item_link = ls.system_id
			inner join level_search_lang lsl on ls.system_id = lsl.level_search_link and language = 'ENU'
				inner join forms f on lsl.search_form = f.system_id
where dynamic_view_link = 1732
order by vl.Level_no, order_no
