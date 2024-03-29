USE [IDBDOCS]
GO
/****** Object:  StoredProcedure [DOCSADM].[sp_nextkey]    Script Date: 09/11/2008 10:31:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--ALTER procedure [DOCSADM].[sp_nextkey] @table VARCHAR(30) as 
--set nocount on 
--set @table = 'DOCSADM.SEQ_' + REPLACE(@table,'DOCSADM.','')
--EXEC ('BEGIN TRAN NEXTKEY INSERT INTO ' + @table + ' (FIELD) VALUES (0) SELECT SCOPE_IDENTITY() COMMIT TRAN NEXTKEY') 


--ALTER procedure [DOCSADM].[sp_nextkey] @table VARCHAR(30) as 
--set nocount on 
--set @table = 'DOCSADM.SEQ_' + REPLACE(@table,'DOCSADM.','')
--EXEC ('INSERT INTO ' + @table + ' (FIELD) VALUES (0) SELECT SCOPE_IDENTITY()') 
--

ALTER procedure [DOCSADM].[sp_nextkey] @table VARCHAR(30) as 
set nocount on 
set @table = 'DOCSADM.' + REPLACE(@table,'DOCSADM.','') + '_KEY'
exec ('declare @id int UPDATE ' + @table + ' set @id = LASTKEY = LASTKEY + 1 select @id')

--docsadm.sp_nextkey 'systemkey'

create table docsadm.NEEDS_INDEXING_key
(	Lastkey int )
grant all on docsadm.NEEDS_INDEXING_key to docs_users
insert into docsadm.NEEDS_INDEXING_key values (1)

SELECT * FROM DOCSADM.SYSTEMKEY_key
--
--delete  DOCSADM.SEQ_SYSTEMKEY


select * from docsadm.seq_systemkey
select * from docsadm.seq_profile
select * from docsadm.seq_versions
select * from docsadm.seq_NEEDS_INDEXING 

