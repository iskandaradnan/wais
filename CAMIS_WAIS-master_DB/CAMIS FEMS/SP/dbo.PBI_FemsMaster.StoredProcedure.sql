USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[PBI_FemsMaster]    Script Date: 20-09-2021 16:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[PBI_FemsMaster]
AS
BEGIN

INSERT INTO PBI_LOG 
(
 ProcessStartDate
,Process
)



SELECT GETDATE(),'FEMS DATA INSERTED'


EXEC [dbo].[PBIContractCreation]
EXEC [dbo].[PBICostContributionData_Upload]
EXEC [dbo].[PBIRescheduleDate]
EXEC [dbo].[PBIFemsAssetDataUpload]
EXEC [dbo].[PBIFemsDataUpload]


UPDATE A
SET A.ProcessEndDate=GETDATE()
FROM PBI_LOG A 
WHERE ID=(SELECT MAX(ID) FROM PBI_LOG)

END



GO
