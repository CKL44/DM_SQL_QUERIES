SELECT VIEW_ID, SHOW_VIEW_NODE, TOP_NODE_ICON, SUBSCR_NODE_ICON, DAYS_FOR_RECENT, RECENT_NODE_ICON, ALL_NODE_ICON, DEFAULT_LANGUAGE, colname, ftbname, fcolname  
FROM DOCSADM.DYNAMIC_VIEW DV INNER JOIN DOCSADM.DOCSCOLUMN DC ON DV.PROFILE_JOIN_LINK = DC.SYSTEM_ID
WHERE DV.SYSTEM_ID = 500

SELECT LANGUAGE, VIEW_NAME, FORM_NAME, SUBSCR_NODE_NAME, RECENT_NODE_NAME, ALL_NODE_NAME
FROM DOCSADM.DYNAMIC_VIEW_LANG DVL INNER JOIN DOCSADM.FORMS F ON DVL.FORM_LINK = F.SYSTEM_ID
WHERE DYNAMIC_VIEW_LINK = 500

select personorgroup, accessrights from docsadm.security
where thing = 500

select VL.SYSTEM_ID, level_no, Type, show_group_level, adhoc_foldering, droppable_level, hide_new_document, hide_new_email, order_direction, level_icon, show_data_at_top,
	DCID.TBNAME, DCID.COLNAME, DCFTR.COLNAME, DCORDER.COLNAME 
from view_level vl
	inner join docsadm.docscolumn dcID on ID_COLUMN_LINK = dcid.system_id
	left outer join docsadm.docscolumn dcFtr on filter_column_link = dcFtr.system_id
	left outer join docsadm.docscolumn dcOrder on order_column_link = dcOrder.system_id
where DYNAMIC_VIEW_LINK = 500
order by level_no

select language, Level_name, ID_FIELD_NAME, Display_format, sub_level_defaults from docsadm.view_level_lang where view_level_link = 501

select ls.system_id,  Level_search_icon, order_no from docsadm.level_search ls 
where view_level_link = 501
order by order_no

SELECT LANGUAGE, level_search_name, form_name, criteria from docsadm.level_search_lang lsl inner join docsadm.forms f on lsl.search_form = f.system_id
where lsl.level_search_link = 550


select * from dynamic_view_lang
