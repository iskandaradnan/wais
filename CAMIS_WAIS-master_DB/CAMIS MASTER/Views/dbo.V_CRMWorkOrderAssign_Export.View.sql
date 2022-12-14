USE [UetrackMasterdbPreProd]
GO
/****** Object:  View [dbo].[V_CRMWorkOrderAssign_Export]    Script Date: 20-09-2021 16:29:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [dbo].[V_CRMWorkOrderAssign_Export]
AS
    SELECT	CRMWO.CRMRequestWOId,
			CRMWO.CustomerId,
			CRMWO.FacilityId,
			CRMWO.CRMWorkOrderNo  AS CRMRequestWONo,
			FORMAT(CRMWO.CRMWorkOrderDateTime,'dd-MMM-yyyy'+' '+ convert(char(5), CRMWO.CRMWorkOrderDateTime, 108) )	AS CRMWorkOrderDateTime,
			LovReqType.FieldValue			AS	TypeOfRequest,
			CRMWO.ModifiedDateUTC               AS ModifiedDateUTC
 	FROM	CRMRequestWorkOrderTxn								AS CRMWO			WITH(NOLOCK)
			INNER JOIN  FMLovMst								AS	LovReqType		WITH(NOLOCK)	ON CRMWO.TypeOfRequest		=	LovReqType.LovId
	 WHERE  CRMWO.AssignedUserId IS NULL
			AND CRMWO.Status = 139
GO
