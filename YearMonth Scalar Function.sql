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
-- Author:		Grant Nilsson
-- Create date: 
-- Description:	Gets a string returning the year and the month
-- =============================================
Alter FUNCTION docsadm.YearMonth 
(
	-- Add the parameters for the function here
	@p1 datetime
)
RETURNS varchar(8)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result varchar(8)

	-- Add the T-SQL statements to compute the return value here
	SELECT @Result = datename(yy, @p1) + '/' 
	if datepart(mm, @p1) < 10 
		select @result = @Result + '0'
	select @Result = @Result + convert(varchar(2), datepart(mm, @p1))
	-- Return the result of the function
	RETURN @Result

END
GO

grant all on docsadm.yearmonth to docs_users