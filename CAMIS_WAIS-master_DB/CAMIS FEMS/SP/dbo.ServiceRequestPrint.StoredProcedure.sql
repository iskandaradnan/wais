USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[ServiceRequestPrint]    Script Date: 20-09-2021 16:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--sp_helptext [ServiceRequestPrint]


--EXEC ServiceRequestPrint 12


CREATE PROCEDURE [dbo].[ServiceRequestPrint]      
(      
@CRMRequestId INT      
)      
AS      
BEGIN       
      
      
--DECLARE @CRMRequestId INT      
--SET @CRMRequestId=1      
      
--RequestNo      
--CRM/WCH/202002/000149      
      
      
SELECT A.RequestNo      
,A.CRMRequestId      
,A.RequestDateTime      
,B.StaffName AS RequestedBy      
,C.Designation      
,ISNULL(B.PhoneNumber,B.MobileNumber) AS ContactNo        
,D.FieldValue AS RequestType        
,E.Priority_Type_Description AS [Priority]        
,ISNULL (F.IndicatorName ,'NA')AS IndicatorName        
,ISNULL(F.IndicatorDesc,'NA') AS IndicatorDescription        
,ISNULL(G.WorkGroupDescription,'NA') AS WorkGroup        
,H.FieldValue AS Status        
,A.TargetDate        
,A.WasteCategory        
,ISNULL(I.UserLocationCode,'NA')AS UserLocationCode  
,ISNULL(I.UserLocationname,'NA') AS  UserLocationName        
,ISNULL(J.UserAreaCode,'NA') AS UserAreaCode        
,ISNULL(J.UserAreaName,'NA') AS UserAreaName        
,ISNULL( K.AssetNo ,'NA') AS AssetNo        
,ISNULL( K.AssetDescription  ,'NA') AS AssetName        
,ISNULL(L.Manufacturer ,'NA') AS  Manufacturer      
,ISNULL(M.Model,'NA') AS Model       
,A.RequestDescription        
,ISNULL(N.FeedBack,'NA')AS AssesmentDetails        
,ISNULL(z.StaffName ,'NA')AS ResponseBy        
,'' AS AssetWorkingStatus        
,ISNULL(P.StaffName,'NA') AS CompletedBy        
,ISNULL(A.Action_Taken,'NA') AS CompletedAction        
,ISNULL(A.Remarks,'NA') AS CancelRemarks
FROM [uetrackMasterdbPreProd].[DBO].CRMRequest A WITH(NOLOCK)       
LEFT OUTER JOIN UMUserRegistration B WITH(NOLOCK)       
ON A.Requester=B.UserRegistrationId       
LEFT OUTER JOIN UserDesignation C WITH(NOLOCK)       
ON B.UserDesignationId=C.UserDesignationId      
LEFT OUTER JOIN FMLovMst D WITH(NOLOCK)       
ON A.TypeOfRequest=D.LovId      
LEFT OUTER JOIN [uetrackMasterdbPreProd].[DBO].CRMRequest_Priority E WITH(NOLOCK)       
ON E.CRMRequest_PriorityId=A.CRMRequest_PriorityId      
LEFT OUTER JOIN MstDedIndicatorDet F WITH(NOLOCK)       
ON A.Indicators_all=F.IndicatorDetId      
LEFT OUTER JOIN EngAssetWorkGroup G WITH(NOLOCK)       
ON A.WorkGroup=G.WorkGroupId      
LEFT OUTER JOIN FMLovMst H WITH(NOLOCK)       
ON A.RequestStatus=H.LovId      
LEFT OUTER JOIN MstLocationUserLocation I WITH(NOLOCK)       
ON A.UserLocationId=I.UserLocationId      
LEFT OUTER JOIN MstLocationUserArea J WITH(NOLOCK)       
ON A.UserAreaId=J.UserAreaId      
LEFT OUTER JOIN EngAsset K WITH(NOLOCK)       
ON A.AssetId=K.AssetId      
LEFT OUTER JOIN EngAssetStandardizationManufacturer L WITH(NOLOCK)       
ON A.ManufacturerId=L.ManufacturerId      
LEFT OUTER JOIN EngAssetStandardizationModel M WITH(NOLOCK)       
ON A.ModelId=M.ModelId      
LEFT OUTER JOIN CRMRequestAssessment N WITH(NOLOCK)       
ON A.CRMRequestId=N.CRMRequestWOId      
LEFT OUTER JOIN UMUserRegistration O  WITH(NOLOCK)       
ON N.UserId=O.UserRegistrationId      
LEFT  OUTER JOIN UMUserRegistration P WITH(NOLOCK)       
ON A.Completed_By=P.UserRegistrationId      
LEFT  OUTER JOIN UMUserRegistration z WITH(NOLOCK)       
ON A.Completed_By=z.UserRegistrationId      

WHERE CRMRequestId=@CRMRequestId      
      
      
      
END 
GO
