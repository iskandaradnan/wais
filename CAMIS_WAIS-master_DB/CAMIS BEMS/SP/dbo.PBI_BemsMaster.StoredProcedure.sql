USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[PBI_BemsMaster]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[PBI_BemsMaster]
AS
BEGIN

INSERT INTO PBI_LOG 
(
 ProcessStartDate
,Process
)



SELECT GETDATE(),'BEMS DATA INSERTED'


EXEC [dbo].[PBIContractCreation]
EXEC [dbo].[PBICostContributionData_Upload]
EXEC [dbo].[PBIRescheduleDate]
EXEC [dbo].[PBIBemsAssetDataUpload]
EXEC [dbo].[PBIBemsDataUpload]


UPDATE A
SET A.ProcessEndDate=GETDATE()
FROM PBI_LOG A 
--WHERE ProcessStartDate=GETDATE()
WHERE ID=(SELECT MAX(ID) FROM PBI_LOG)


END
GO
