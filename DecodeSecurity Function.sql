-- ================================================
-- Template generated from Template Explorer using:
-- Create Scalar Function (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the function.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Grant Nilsson>
-- Create date: <Septmember 2010>
-- Description:	<return the break down of the security when Access Rights integer value is passed in>
-- =============================================
create FUNCTION DOCSADM.DecodeSecurity
(
	-- Add the parameters for the function here
	@AccessRights	int
)
RETURNS varchar(400)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @return varchar(400)
	
	-- to work out the values bitwise or'd below, take the bit position 
	-- e.g. bit 7 and use a calculator to calculate 2 to the power of 7 (2^7) = 128
	
	--ALLOW rights
	if (@AccessRights & 1) > 0								-- Bit 0
		set @return = 'View Profile'
	if (@AccessRights & 2) > 0								-- Bit 1 
		set @return = @Return + ', Edit Profile'
	if (@AccessRights & 4) > 0								-- Bit 2
		set @return = @Return + ', View Document'
	if (@AccessRights & 8) > 0								-- Bit 3
		set @return = @Return + ', Retrieve Document'
	if (@AccessRights & 16) > 0								-- Bit 4
		set @return = @Return + ', Edit Document'
	if (@AccessRights & 32) > 0								-- Bit 5
		set @return = @Return + ', Copy'
	if (@AccessRights & 64) > 0								-- Bit 6
		set @return = @Return + ', Delete'
	if (@AccessRights & 128) > 0							-- Bit 7 
		set @return = @Return + ', Control Access'
	if (@AccessRights & 256) > 0							-- Bit 8 
		set @return = @Return + ', Assign to File'			-- RM Function
	if (@AccessRights & 512) > 0							-- Bit 9 
		set @return = @Return + ', View Published Only'
	-- DENY rights
	if (@AccessRights & 65536) > 0							-- Bit 16
		set @return = @Return + ', Deny View Profile'
	if (@AccessRights & 131072) > 0							-- Bit 17
		set @return = @Return + ', Deny Edit Profile'
	if (@AccessRights & 262144) > 0							-- Bit 18
		set @return = @Return + ', Deny View Document'
	if (@AccessRights & 524288) > 0							-- Bit 19
		set @return = @Return + ', Deny Retrieve Document'
	if (@AccessRights & 1048576) > 0						-- Bit 20
		set @return = @Return + ', Deny Edit Document'
	if (@AccessRights & 2097152) > 0						-- Bit 21
		set @return = @Return + ', Deny Copy'
	if (@AccessRights & 4194304) > 0							-- Bit 22
		set @return = @Return + ', Deny Delete'
	if (@AccessRights & 8388608) > 0							-- Bit 23
		set @return = @Return + ', Deny Control Access'

	-- NOTE: all other bits than those above are not presently used. 
	-- most of the system will assign 32255 as full rights now, 
	-- which is the bottom 16 bits turned on except View Published Only right (Bit 8) which is a deny right in a sense

	-- Return the result of the function
	RETURN @return
END
GO

