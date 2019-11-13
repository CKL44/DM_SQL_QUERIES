CREATE FUNCTION DOCSADM.HAS_SECURITY 
(
	@ThingId	int
)
RETURNS int
AS
BEGIN
	declare @cnt	int
	SELECT @cnt = count(*) from docsadm.security where thing = @thingId

	return @cnt
END
GO

grant all on docsadm.HAS_SECURITY to docs_users 
go
