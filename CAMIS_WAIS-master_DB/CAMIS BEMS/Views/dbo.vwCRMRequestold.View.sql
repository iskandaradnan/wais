USE [UetrackBemsdbPreProd]
GO
/****** Object:  View [dbo].[vwCRMRequestold]    Script Date: 20-09-2021 17:03:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*closed*/
CREATE VIEW [dbo].[vwCRMRequestold]
AS
SELECT        TOP (100) PERCENT CRMRequestId, CustomerId, FacilityId, ServiceId, RequestNo, RequestDateTime, RequestDateTimeUTC, RequestStatus, RequestDescription, TypeOfRequest, Remarks, CreatedBy, CreatedDate, 
                         CreatedDateUTC, ModifiedBy, ModifiedDate, ModifiedDateUTC, Timestamp, GuId, IsWorkOrder, ModelId, ManufacturerId, UserAreaId, UserLocationId, StatusValue, MobileGuid, TargetDate, RequestedPerson, AssigneeId, 
                         Requester, CRMRequest_PriorityId, Responce_Date, Responce_By
FROM            uetrackMasterdbPreProd.dbo.CRMRequest
WHERE        (RequestStatus = '142') AND (TypeOfRequest = '134') AND (ServiceId = 2)
ORDER BY ServiceId
GO
