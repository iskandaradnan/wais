USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_PartDetails]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- =============================================
-- Author:		Aravinda Raja 
-- Create date: 14-05-2018
-- Description:	BD PART DETAILS Sub report
-- =============================================
CREATE PROCEDURE [dbo].[uspFM_PartDetails]
	-- Add the parameters for the stored procedure here
@WorkOrderId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN TRY

    -- Insert statements for procedure here
SELECT  b.PartNo, b.PartDescription, a.Quantity, a.Cost
FROM   EngMwoPartReplacementTxn AS a 
LEFT OUTER JOIN EngSpareParts AS b ON a.SparePartStockRegisterId = b.SparePartsId
WHERE        (a.WorkOrderId = @WorkOrderId) and b.Active=1
ORDER BY a.SparePartStockRegisterId
END TRY
BEGIN CATCH

insert into ErrorLog(Spname,ErrorMessage,createddate)
		values(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())

END CATCH
SET NOCOUNT OFF
END

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
GO
