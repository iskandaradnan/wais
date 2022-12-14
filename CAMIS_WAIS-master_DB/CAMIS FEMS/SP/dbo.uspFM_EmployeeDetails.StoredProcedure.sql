USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EmployeeDetails]    Script Date: 20-09-2021 16:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- =============================================
-- Author:		Aravinda Raja 
-- Create date: 14-05-2018
-- Description: BD EmployeeDetails

-- =============================================
Create PROCEDURE [dbo].[uspFM_EmployeeDetails]
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
	
select 
 staff.UserRegistrationId StaffEmployeeId
,staff.StaffName
,ISNULL(FORMAT(a.StartDateTime,'dd-MMM-yyyy HH:mm'),'')as StartDateTime
,ISNULL(FORMAT(a.ENDDateTime,'dd-MMM-yyyy HH:mm'),'')as ENDDateTime
,ISNULL(FORMAT(a.EndDateTime,'HH:mm '),'')as EndTime

From 
EngMwoCompletionInfoTxn as a
join EngMaintenanceWorkOrderTxn work on a.WorkOrderId=work.WorkOrderId
join UMUserRegistration staff on staff.UserRegistrationId=a.CompletedBy
where a.WorkOrderId=@WorkOrderId 
END TRY
BEGIN CATCH

insert into ErrorLog(Spname,ErrorMessage,createddate)
values(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())

END CATCH
SET NOCOUNT OFF
END

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
GO
