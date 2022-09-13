USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Asis_DS_Service]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec [Asis_DS_Service] 'all'
CREATE PROCEDURE [dbo].[Asis_DS_Service](@Service           VARCHAR (20))
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
