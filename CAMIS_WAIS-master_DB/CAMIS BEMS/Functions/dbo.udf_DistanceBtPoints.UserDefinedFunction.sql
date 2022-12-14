USE [UetrackBemsdbPreProd]
GO
/****** Object:  UserDefinedFunction [dbo].[udf_DistanceBtPoints]    Script Date: 20-09-2021 17:09:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[udf_DistanceBtPoints]
(
	@pSourceLatitude NUMERIC(24,15), 
	@pSourceLongitude NUMERIC(24,15), 
	@pDestLatitude NUMERIC(24,15),
	@pDestLongitude NUMERIC(24,15)
)
RETURNS NUMERIC(24,15)
AS
BEGIN

DECLARE	@DegToRad AS NUMERIC(24,15),
		@Ans AS NUMERIC(24,15),
		@Miles AS NUMERIC(24,15),
		@KMs AS NUMERIC(24,15)

SET @DegToRad = 57.29577951
SET @Ans = 0
SET @Miles = 0

IF (	@pSourceLatitude IS NULL OR @pSourceLatitude = 0 OR @pSourceLongitude IS NULL OR @pSourceLongitude = 0 OR @pDestLatitude IS NULL OR 
		@pDestLatitude = 0 OR @pDestLongitude IS NULL OR @pDestLongitude = 0 
	)
BEGIN
	RETURN ( @Miles )
END
SET @Ans = SIN(@pSourceLatitude / @DegToRad) * SIN(@pDestLatitude / @DegToRad) + COS(@pSourceLatitude / @DegToRad ) * COS( @pDestLatitude / @DegToRad ) * COS(ABS(@pDestLongitude - @pSourceLongitude )/@DegToRad)
SET @Miles = 3959 * ATAN(SQRT(1 - SQUARE(@Ans)) / @Ans)
SET @Miles = round(@Miles,3)
SET @KMs = @Miles * 1.60934
SET @KMs = round(@KMs,3)

RETURN ( @KMs )
END
GO
