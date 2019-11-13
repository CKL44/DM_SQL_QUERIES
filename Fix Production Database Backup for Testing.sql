declare @NewServerName		varchar(60)
declare @NewDatabaseName	varchar(60)
declare @RemoveRemoteLibs	char
declare @UserName			varchar(30)
declare @Password			varchar(30)
declare @OldDocServerLoc	varchar(60)
declare @NewDocServerLoc	varchar(60)
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
----------- I M P O R T A N T ----  R E A D    T H I S --------------------------------------
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
-- This script will take a newly restored Production Library database, and go through and 
-- remove all of the links to the production database so it can be used in a test environment
-- 
-- If you open a new query window for the restored database the following variables should be 
-- correct for the servername and database name. 
-- Please set the other variables as appropriate 
---------------------------------------------------------------------------------------------
----- B E G I N   V A R I A B L E S  --------------------------------------------------------
---------------------------------------------------------------------------------------------
-- the Server name of the Databse server
set @NewServerName = convert(varchar(60), Serverproperty('ServerName'))		-- leave if this query will run on the new DB Server
-- the Database Name on the server defined above
set @NewDatabaseName = DB_NAME()						-- leave if you are running this in a query window with the new db selected
-- this setting will remove all the remotelibs by default, so they won't be accessible from the copy for testing
set @RemoveRemoteLibs = 'Y'								-- change to 'N' to NOT remove all the remote libraries 
-- this is the common user login name to run Database connections with 
-- set the Username = '***trusted***' to use trusted connections
set @UserName = ''
-- this is the password for common login, not required if using trusted connections
set @Password = '' 

-- this script can also change the Document Server for all the documents in the database
-- if these docservers are not accessible from your test environment, and you don't care to open the documents 
-- then you can leave the @OldDocServerLoc = '' and no updates to docs servers will happen, and the document opens will just fail
-- if you have copied a set of the documents from the existing document server to a new location
-- then set the @OldDocServerLoc to the old Document server location e.g. \\oldmachinename\share  OR C: (default generic setup), 
-- and set the @NewDocServerLoc to the new document server location e.g \\newmachinename\share
-- and the script will attempt to update all the documents to the new location, for testing
set @OldDocServerLoc = ''
-- this is the NEW document server name where the documents were copied from - 
set @NewDocServerLoc = ''
---------------------------------------------------------------------------------------------
----- E N D   V A R I A B L E S  ------------------------------------------------------------
---------------------------------------------------------------------------------------------

-- check and see if the have filled in the new user name - if not exit, as they are running it without fixing the parameters
if @UserName = '' 
	goto exitlabel;

-- check and see if this db server has a DOCSADM account
IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = N'DOCSADM')
	CREATE LOGIN DOCSADM WITH PASSWORD='docsadm', DEFAULT_DATABASE=[msdb];

-- fix up the DOCSADM account for the new DB Server  
exec sp_change_users_login 'update_one', 'DOCSADM', 'DOCSADM'	

-- check and see if this db server has a DOCSADM account
IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = N'DOCSUSER')
	CREATE LOGIN DOCSUSER WITH PASSWORD='docsuser', DEFAULT_DATABASE=[msdb];

-- fix up the DOCSUSER account for the new DB Server  
exec sp_change_users_login 'update_one', 'DOCSUSER ', 'DOCSUSER '

-- we need to go and fix up the REMOTE_LIBRARIES entry
update DOCSADM.REMOTE_LIBRARIES
set SERVER_LOCATION = @NewServerName,  
	DATABASE_NAME = @NewDatabaseName, 
	LIB_LOGIN_UNAME = @Username,
	SQL_PASSWORD = @Password
where system_id = 0

if (@RemoveRemoteLibs = 'Y')
	delete from DOCSADM.REMOTE_LIBRARIES
	where SYSTEM_ID <> 0

-- check and see if they want document servers fixed up
if @OldDocServerLoc <> ''
begin
	-- fix up the document server
	update DOCSADM.DOCSERVERS
	set LOCATION = @NewDocServerLoc
	where LOCATION = @OldDocServerLoc
	-- fix all the documents 
	update DOCSADM.PROFILE
	set DOCSERVER_LOC = @NewDocServerLoc
	where DOCSERVER_LOC = @OldDocServerLoc
end

exitlabel:
	return