-- get the current users groups
select groups_system_id from docsadm.peoplegroups
where people_system_id = (select system_id from docsadm.people where user_id = 'grant.nilsson')

-- get the Dynamic Views
select SYSTEM_ID,ORDER_NO,VIEW_ID,SHOW_VIEW_NODE,TOP_NODE_ICON,SUBSCR_NODE_ICON,DAYS_FOR_RECENT,RECENT_NODE_ICON,ALL_NODE_ICON,DEFAULT_LANGUAGE,PROFILE_JOIN_LINK
from docsadm.dynamic_view
order by order_no

-- get the languages for a Dynamic View
select DVL.SYSTEM_ID,DVL.LANGUAGE,VIEW_NAME,FORM_LINK,F.FORM_NAME,SUBSCR_NODE_NAME,RECENT_NODE_NAME,ALL_NODE_NAME
from docsadm.dynamic_view_lang dvl join docsadm.forms f on FORM_LINK = f.system_id
where dynamic_view_link = 165555200
order by dvl.language

-- get the security for a Dynamic View
select s.personorgroup, s.accessrights, g.group_id, p.user_id
from docsadm.security s 
	left outer join docsadm.groups g on s.personorgroup = g.system_id and g.disabled <> 'Y'
	left outer join docsadm.people p on s.personorgroup = p.system_id 
where s.thing = 165555200

-- get the View Levels for a Dynamic View
select vl.SYSTEM_ID,LEVEL_NO,TYPE,SHOW_GROUP_LEVEL,ADHOC_FOLDERING,DROPPABLE_LEVEL,
HIDE_NEW_DOCUMENT,HIDE_NEW_EMAIL,SUPPORTS_DISABLED,ID_COLUMN_LINK,FILTER_COLUMN_LINK,
LEVEL_ICON,SHOW_DATA_AT_TOP,CAND_ID_COL_SQL,DC1.tbname, dc1.colname, dc2.colname-- JOIN_TABLE_LINKS, 
from docsadm.view_level VL
 join docsadm.docscolumn dc1 on vl.ID_COLUMN_LINK = dc1.system_id
 left outer join docsadm.docscolumn dc2 on vl.FILTER_COLUMN_LINK= dc2.system_id
where dynamic_view_link = 165555200
order by level_no

select * from docsadm.view_level

-- level languages for a dv
select SYSTEM_ID,LANGUAGE,LEVEL_NAME,ID_FIELD_NAME,DISPLAY_FORMAT,SUB_LEVEL_DEFAULTS, *
from docsadm.view_level_lang
where VIEW_LEVEL_LINK in (165555329
,165555331
,165555333
,165555335)
order by view_level_lang.LANGUAGE

-- get all the searches defined in the system
select 
SYSTEM_ID,LEVEL_SEARCH_ICON,LEVEL_SEARCH_ID,ORDER_NO
from docsadm.level_search
order by order_no

-- get all the search languages
select lsl.SYSTEM_ID,LANGUAGE,LEVEL_SEARCH_NAME,SEARCH_FORM,CRITERIA,f.form_name
from docsadm.level_search_lang lsl
join docsadm.forms f on lsl.search_form = f.system_id 
where LEVEL_SEARCH_LINK = 551 

-- get all the searches for this level
select VIEW_LEVEL_LINK,ITEM_LINK,ITEM_LIBRARY_LINK,LS.LEVEL_SEARCH_ID
from docsadm.level_items li
	join level_search ls on li.item_link = ls.System_id
where view_level_link = 1792

-- get docscolumn information
select * from 
docsadm.docscolumn
where tbname = ''


-- supporting information
-- get all the profile forms that we can possible use
select SYSTEM_ID,FORM_NAME,FORM_TITLE,FORM_DEFINITION,LANGUAGE_CODE 
from docsadm.forms
where table_name = 'profile'
order by 2

-- get all the languages from somewhere 


-- get the people and groups on the fly

