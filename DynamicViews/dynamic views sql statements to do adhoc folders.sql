--select * from level_items
--select * from profile
--insert into level_items (view_level_link, item_link) values (1715, 1732)
--select * from client


/* when the level requested is in the hierarchy of lookups - attached to level 1 (clients)*/
SELECT P.DOCNUMBER, P.DOCNAME, li.*
FROM DOCSADM.LEVEL_ITEMS LI 
	INNER JOIN DOCSADM.PROFILE P ON LI.ITEM_LINK = P.SYSTEM_ID 
	inner join DOCSADM.matter a2 on p.matter = a2.system_id	and a2.client_id = 1704					-- uses DCID.TBNAME on profile join column = it's join column
--	inner join docsadm.client a1 on a2.client_id = a1.system_id and a1.system_id = 			-- uses DCFTR.ftbname on 
WHERE 
	VIEW_LEVEL_LINK = 1715 
ORDER BY P.DOCNAME



/* when the level requested is an enum level */
SELECT P.DOCNUMBER, P.DOCNAME, li.*
FROM DOCSADM.LEVEL_ITEMS LI 
	INNER JOIN DOCSADM.PROFILE P ON LI.ITEM_LINK = P.SYSTEM_ID 
		
	--inner join DOCSADM.matter a2 on p.matter = a2.system_id						-- uses DCID.TBNAME on profile join column = it's join column
	--inner join docsadm.client a1 on a2.client_id = a1.system_id and a1.system_id = 			-- uses DCFTR.ftbname on 
WHERE 
	VIEW_LEVEL_LINK = 1723 
	and documenttype = 1260				-- we must add the enumeration levels to filter the adhoc folders coming back
ORDER BY P.DOCNAME



select * from view_level
/* below is the logic to get the enumeration column filters from the PROFILE table * - need to do it when the DV info is cached */
select * from docscolumn where system_id = 211
select * from docscolumn where tbname = 'profile' and ftbname = 'documentTypes'	-- then we need to use the COLNAME returned from this query