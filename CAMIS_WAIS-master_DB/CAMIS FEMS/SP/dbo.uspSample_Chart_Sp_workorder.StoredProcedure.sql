USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspSample_Chart_Sp_workorder]    Script Date: 20-09-2021 16:56:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE  [dbo].[uspSample_Chart_Sp_workorder]                           
	
	@pServiceId			INT,
	@pStatusId	INT
	
AS                                              

BEGIN TRY


	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;


   SELECT			'5' AS ItemId,
							'Workorder' AS ItemName,
					50 AS Active,
					25 as inactive,
					55 as inprogress,
					44 as closed
			FROM			EngMaintenanceWorkOrderTxn AS work WITH (NOLOCK)
			where	work.ServiceId = @pServiceId
					and work.WorkOrderStatus = @pStatusId


END TRY

BEGIN CATCH



END CATCH
GO
