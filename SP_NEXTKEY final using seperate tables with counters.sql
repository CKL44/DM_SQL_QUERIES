ALTER procedure [DOCSADM].[sp_nextkey] @table VARCHAR(30) as 
set nocount on 
set @table = 'DOCSADM.SEQ_' + REPLACE(@table,'DOCSADM.','') 
exec ('DECLARE @ID INT UPDATE ' + @table + ' SET @ID = LASTKEY = LASTKEY + 1 SELECT @ID')