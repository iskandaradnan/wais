USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_VehicleDetails_Route]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Sp_HWMS_VehicleDetails_Route]
as
begin
select RouteCode from HWMS_RouteCollectionCategory A
LEFT JOIN FmLovMst B on A.Status = B.LovId WHERE B.FieldValue = 'Active'
UNION
select RouteCode from HWMS_RouteTransportation A
LEFT JOIN FmLovMst B on A.Status = B.LovId WHERE B.FieldValue = 'Active'

end
GO
