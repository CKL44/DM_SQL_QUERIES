
------------------------------------------------------------------------------------------------------------------------------------------------------------
select * from View_level where dynamic_view_link = 500 and level_no = 1

/* get the actual data for the level from the level information, for the ALL node tree - for client*/
select a.system_id, client_ID, client_name, client_id from docsadm.client a

/* get the actual data for the level from the level information, for the ALL node tree - for matter*/
select a.system_id, matter_id, matter_name, matter_id from docsadm.matter a 
where client_id = 1700


/* get the actual data for the level from the level information, for the ALL node tree - for document types - an enumeration level */
select a.system_id, type_id, description, type_id from docsadm.documenttypes a 
where not exists (
	select * from docsadm.subscriptions where dynamic_view_link = 500 and personorgroup = 1675 and thing_link = a.system_id/* and type = 'E'*/)


------------------------------------------------------------------------------------------------------------------------------------------------------------
/* get the actual data for the level from the level information, for the SUBSCRIPTIONS node tree - for client*/
select a.system_id, client_ID, client_name, client_id from docsadm.client a
where exists (
	select * from docsadm.subscriptions where dynamic_view_link = 500 and personorgroup = 1675 and thing_link = a.system_id/* and type = 'E'*/)


/* get the actual data for the level from the level information, for the SUBSCRIPTIONS node tree - for matter*/
select a.system_id, matter_id, matter_name, matter_id from docsadm.matter a 
where client_id = 1700
and exists (
	select * from docsadm.subscriptions where dynamic_view_link = 500 and personorgroup = 1675 and thing_link = a.system_id/* and type = 'E'*/)


------------------------------------------------------------------------------------------------------------------------------------------------------------
/* get the actual data for the level from the level information, for the RECENT node tree - for client*/
select distinct a1.system_id, a1.client_ID, a1.client_name, a1.client_id 
from 	docsadm.activitylog al 
	inner join docsadm.profile p on al.docnumber = p.docnumber  	-- hardcoded
	inner join DOCSADM.matter a2 on p.matter = a2.system_id		-- uses DCID.TBNAME on profile join column = it's join column
	inner join docsadm.client a1 on a2.client_id = a1.system_id	-- uses DCFTR.ftbname on 
where 
	al.activity_type < 100 and al.start_date = getdate() - 30

/* get the actual data for the level from the level information, for the RECENT tree - for matter*/
select a.system_id, matter_id, matter_name, matter_id 
from 	docsadm.activitylog al 
	inner join docsadm.profile p on al.docnumber = p.docnumber
	inner join DOCSADM.matter a on p.matter = a.system_id
where client_id = 1700 and al.activity_type < 100 and al.start_date > getdate() - 30
	and exists(select thing from security s inner join peoplegroups pg on s.personorgroup = pg.groups_system_id and pg.people_system_id = 1654
		   where p.system_id = s.thing)

------------------------------------------------------------------------------------------------------------------------------------------------------------
/* gets the links column information from the profile to the lowest level on the lookup hierarchy */
select colname, ftbname, fcolname from docscolumn 
where colname = 'rack_position_link'

------------------------------------------------------------------------------------------------------------------------------------------------------------
/* how to get all the levels below the current requested level for the above recent sql creation */
SELECT level_no, DCFTR.COLNAME, DCFTR.TBname, DCFTR.ftbname , DCFTR.fcolname
FROM docsadm.VIEW_LEVEL VL 
	left outer join docsadm.docscolumn dcFtr on filter_column_link = dcFtr.system_id
where DYNAMIC_VIEW_LINK = 600 AND LEVEL_NO > 1 and TYPE = 'L'
order by 1 desc

------------------------------------------------------------------------------------------------------------------------------------------------------------
/* get the actual data for the level from the level information, for the RECENT node tree - for location hierarchy*/
select a1.system_id, a1.PD_LOCATION_CODE, a1.pd_location_desc,  a1.PD_LOCATION_CODE
from 	docsadm.activitylog al 
	inner join docsadm.profile p on al.docnumber = p.docnumber  			-- hardcoded
	inner join DOCSADM.rack_position a4 on p.rack_position_link = a4.system_id	-- uses profile_join_link ftbname aLvl on p. profile_join_link colname = aLvl.fcolname
	inner join docsadm.storage_racks a3 on a4.rack_link = a3.system_id		-- uses ftbname alvl on prevalias.colname = curalias.fcolname
	inner join docsadm.area a2 on a3.area_link = a4.system_id
	inner join docsadm.pd_location a1 on a2.location_link = a1.system_id 
where 
	al.activity_type < 100 and al.start_date = getdate() - 30



---- questions to answer
/*
MAYBE think about just having group levels per subscription, recent, all nodes ????
as it really only makes sense for the ALL node */
