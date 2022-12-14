USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngPPMCheckList]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- =============================================
-- Author:		<Aravinda Raja>
-- Create date: <08/May/2018>
-- Description:	<Create a KKM check list>
-- =============================================
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--EXEC [uspFM_EngPPMCheckList]  '5','1' 
 
CREATE PROCEDURE [dbo].[uspFM_EngPPMCheckList]	
(                                                    
    @HeppmCheckListId   int,@Version_No        int  
 )                 
   
AS
BEGIN
	
SELECT 
am.Model as Model 
,an.Manufacturer as Manufacturer
,[dbo].[Fn_DisplayNameofLov](m.PPMFrequency) as PPMFrequency
,m.PpmHours
,m.SpecialPrecautions
,m.Description
,n.PpmChecklistNo
,a.EffectiveDate
,a.[Version] as versionNo
,[dbo].[fn_DisplayTypeCode](m.AssetTypeCodeId) as AssetTypeCodeId
,(select top 1 Logo from MstCustomer
where CustomerId=1) as 'MOH_Logo'
  
FROM EngAssetPPMCheckList m
left join EngPPMRegisterMst as n on n.PPMId=m.PPMCheckListId
left join EngPPMRegisterHistoryMst a on n.PPMId=a.PPMId
left join EngAssetStandardizationModel am on am.ModelId=n.ModelId
left join EngAssetStandardizationManufacturer an on an.ManufacturerId=n.ManufacturerId
WHERE m.Active=1  AND m.ServiceId=2 and n.Active=1
AND m.PPMCheckListId=@HeppmCheckListId AND a.[Version]=@Version_No

END

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
GO
