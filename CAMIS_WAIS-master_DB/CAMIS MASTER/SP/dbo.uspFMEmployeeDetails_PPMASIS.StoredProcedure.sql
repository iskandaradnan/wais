USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFMEmployeeDetails_PPMASIS]    Script Date: 20-09-2021 16:43:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--drop proc EmployeeDetails_PPMASIS
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- =============================================
-- Author:		N.Hari Haran N
-- Create date: 09-05-2017
-- Description:	PPMASISEMployeeDetails
-- exec  dbo.[uspFMEmployeeDetails_PPMASIS]  25
-- =============================================
CREATE PROCEDURE [dbo].[uspFMEmployeeDetails_PPMASIS]
	-- Add the parameters for the stored procedure here
	@WorkOrderId int 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select 
c.StaffEmployeeId
,c.StaffName
,format(a.StartDateTime,'dd-MMM-yyyy HH:mm') as startdate
,format(a.EndDateTime,'dd-MMM-yyyy  HH:mm') as Enddate
--,format(b.StartDateTime,'HH:mm') as startTime
--,format(b.EndDateTime,'HH:mm') as EndTime
,j.TaskCode
,j.TaskDescription
,a.DowntimeHoursMin
,datediff(mi, a.StartDateTime, a.EndDateTime) / 60.0 as Datedifferent
--b.RepairHours
from EngMaintenanceWorkOrderTxn as n
left join EngMwoCompletionInfoTxn as a
on a.WorkOrderId=n.WorkOrderId
left join MstStaff as c
on c.StaffMasterId=a.CompletedBy
left join EngPlannerTxn as m
on m.PlannerId=n.PlannerId and m.AssetId=n.AssetId
left join EngAssetTypeCodeStandardTasksDet as j
on m.StandardTaskDetId=j.StandardTaskDetId
where a.WorkOrderId=@WorkOrderId 
order by CompletionInfoId desc

END
GO
