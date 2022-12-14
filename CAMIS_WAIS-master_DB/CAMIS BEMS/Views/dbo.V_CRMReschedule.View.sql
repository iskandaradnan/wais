USE [UetrackBemsdbPreProd]
GO
/****** Object:  View [dbo].[V_CRMReschedule]    Script Date: 20-09-2021 17:03:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[V_CRMReschedule]
AS
	SELECT	DISTINCT 
			RequestWorkOrder.CRMRequestWOId,
			RequestWorkOrder.FacilityId,
			RequestWorkOrder.CRMWorkOrderNo  As CRMRequestWONo,
			RequestWorkOrder.CRMWorkOrderDateTime,
			--FORMAT(RequestWorkOrder.CRMWorkOrderDateTime,'dd-MMM-yyyy hh:mm')	AS CRMWorkOrderDateTime,
			RequestWorkOrder.TypeOfRequest As TypeOfRequestId,
			TypeOfRequest.FieldValue	AS TypeOfRequest,
			RequestWorkOrder.ModifiedDateUTC

	FROM	CRMRequestWorkOrderTxn				AS	RequestWorkOrder		WITH(NOLOCK)
			INNER JOIN FMLovMst					AS	TypeOfRequest			WITH(NOLOCK)	ON	RequestWorkOrder.TypeOfRequest		=	TypeOfRequest.LovId
    WHERE   RequestWorkOrder.AssignedUserId IS NULL
			AND RequestWorkOrder.Status = 139
GO
