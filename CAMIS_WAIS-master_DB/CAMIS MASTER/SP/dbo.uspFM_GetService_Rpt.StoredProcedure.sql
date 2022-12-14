USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_GetService_Rpt]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- exec [uspFM_GetService_Rpt] '2'
CREATE PROCEDURE [dbo].[uspFM_GetService_Rpt](@Service    VARCHAR (20))
AS
BEGIN
SET NOCOUNT ON

IF(@Service = 'All')
	BEGIN
		SELECT 'All' AS ServiceID,'All' AS ServiceKey
	END

ELSE

	BEGIN
		SELECT ServiceID,ServiceKey  FROM MstService WHERE ServiceID=@Service
	END

END
GO
