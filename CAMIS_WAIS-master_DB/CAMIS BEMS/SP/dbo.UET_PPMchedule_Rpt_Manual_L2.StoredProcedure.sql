USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UET_PPMchedule_Rpt_Manual_L2]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================    
Application Name : UETrack-BEMS                  
Version    : 1.0    
Procedure Name  : [UET_PPMchedule_Rpt_Manual_L2]     
Description   : Get the BER Analysis Report(Level2 Manual)    (r=Reference from uspFM_EngPlanner_PPM_Summary)
Authors    : KRISHNA S    
Date    : 13-June-2018    
-----------------------------------------------------------------------------------------------------------    
exec UET_PPMchedule_Rpt_Manual_L2 @TypeCodeId = 1057,@FacilityId=1, @Year = 2018, @TaskCodeOption = 364  
-----:------------:---------------------------------------------------------------------------------------    
Init : Date       : Details    

========================================================================================================*/    
CREATE  PROCEDURE [dbo].[UET_PPMchedule_Rpt_Manual_L2](            
			@TypeCodeId		INT,
			@Year			VARCHAR(100) = '',
			@FacilityId		int  ,
			@TaskCodeOption INT  ,	---364 ---> Manual, 365 ---> Frequency
			@Schedule		INT = null,
			@Status			INT = null,
			@AssetNo		VARCHAR(100) = ''
 )
AS 
   SET FMTONLY OFF
BEGIN TRY  
  
-- Paramter Validation   

 SET NOCOUNT ON;   
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;  
  
 DECLARE @pTypeofPlanner  INT = 34  
 DECLARE @TotalRecords  INT  
 DECLARE @pTotalPage   NUMERIC(24,2)  
  
-- Execution  
  
  
 SET DATEFIRST 1  
 --declare @pYear int  
 IF OBJECT_ID('tempdb..#CONSTEMP') IS NOT NULL  
  DROP TABLE #CONSTEMP  
  
 CREATE TABLE #CONSTEMP( RowId INT IDENTITY(1,1),  
       Assetno Varchar(max),  
       AssetDescription  Varchar(max),  
       Frequency varchar(200),  
       PlannerDate datetime,  
       CustomerId int,  
       TaskCode Varchar(max),  
       Year int,  
       WeekNo int,  
       UserAreaCode varchar(200),  
       UserAreaName varchar(300),  
       CompanyLogo varbinary(max),  
       FacilityLogo varbinary(max)  
      )  
  
 INSERT #CONSTEMP( Assetno,  
      AssetDescription,  
      CustomerId,  
      TaskCode,  
      Year,  
      WeekNo,  
      UserAreaCode,  
      UserAreaName,  
      CompanyLogo,  
      FacilityLogo  
     )  
   
 Select Assetno,AssetDescription,CustomerId,TaskCode,[year]  
 ,WeekNo,UserAreaCode,UserAreaName,NULL CompanyLogo,NULL FacilityLogo  
 FROM  
  (  
    select AssetNo  
     ,a.AssetDescription  
     ,EPTD.CustomerId  
     ,ESTDMD.TaskCode  
     ,@Year as [year]  
     ,datepart(ww,EPTDet.PlannerDate) WeekNo  
     ,MAX(datepart(DD,EPTDet.PlannerDate)) WeekDay  
     ,EUAM.UserAreaCode  
     ,EUAM.UserAreaName  
     from EngPlannerTxn EPTD   
       INNER JOIN EngPlannerTxnDet EPTDet ON EPTD.PlannerId =EPTDet.PlannerId  
       INNER JOIN EngAsset a ON EPTD.AssetId =a.AssetId  
       LEFT JOIN EngAssetPPMCheckList ESTDMD ON ESTDMD.PPMCheckListId=EPTD.StandardTaskDetId    
       LEFT JOIN EngAssetTypeCode td ON td.AssetTypeCodeId=a.AssetTypeCodeId  
       LEFT JOIN EngAssetStandardizationModel Sm ON Sm.ModelId=a.Model   
       LEFT JOIN MstLocationUserArea EUAM ON euam.UserAreaId =A.UserAreaId  
       LEFT JOIN MstLocationFacility c           ON c.FacilityId=EPTD.FacilityId   
       LEFT JOIN MstCustomer d                    ON d.CustomerId=c.CustomerId  
     where EPTD.TypeOfPlanner=34  
     --EPTD.WorkGroupId =@pWorkGroupid AND 
		AND EPTD.FacilityId=@FacilityId  
        AND EPTD.Year=@Year
		--And a.AssetNo=@AssetNo
      --  AND ((A.AssetTypeCodeId = @TypeCodeId) OR (@TypeCodeId IS NULL) OR (@TypeCodeId = '')) 
		AND ((EPTD.GenerationType = @TaskCodeOption) OR (@TaskCodeOption IS NULL) OR (@TaskCodeOption = ''))
       ------AND EPTD.TypeOfPlanner=34  
     GROUP BY AssetNo,a.AssetDescription,EPTD.CustomerId,ESTDMD.TaskCode,EUAM.UserAreaCode,EUAM.UserAreaName,(datepart(ww,EPTDet.PlannerDate))   
  )bb  
     
 SELECT AssetNo,  
   AssetDescription,  
   CustomerId,  
   TaskCode,  
   UserAreaCode,  
   UserAreaName,  
   Sum(Week1) Week1,  
   Sum(Week2) Week2,  
   Sum(Week3) Week3,  
   Sum(Week4) Week4,  
   Sum(Week5) Week5,  
   Sum(Week6) Week6,  
   Sum(Week7) Week7,  
   Sum(Week8) Week8,  
   Sum(Week9) Week9,  
   Sum(Week10) Week10,  
   Sum(Week11) Week11,  
   Sum(Week12) Week12,  
   Sum(Week13) Week13,  
   Sum(Week14) Week14,  
   Sum(Week15) Week15,  
   Sum(Week16) Week16,  
   Sum(Week17) Week17,  
   Sum(Week18) Week18,  
   Sum(Week19) Week19,  
   Sum(Week20) Week20,  
   Sum(Week21) Week21,  
   Sum(Week22) Week22,  
   Sum(Week23) Week23,  
   Sum(Week24) Week24,  
   Sum(Week25) Week25,  
   Sum(Week26) Week26,  
   Sum(Week27) Week27,  
   Sum(Week28) Week28,  
   Sum(Week29) Week29,  
   Sum(Week30) Week30,  
   Sum(Week31) Week31,  
   Sum(Week32) Week32,  
   Sum(Week33) Week33,  
   Sum(Week34) Week34,  
   Sum(Week35) Week35,  
   Sum(Week36) Week36,  
   Sum(Week37) Week37,  
   Sum(Week38) Week38,  
   Sum(Week39) Week39,  
   Sum(Week40) Week40,  
   Sum(Week41) Week41,  
   Sum(Week42) Week42,  
   Sum(Week43) Week43,  
   Sum(Week44) Week44,  
   Sum(Week45) Week45,  
   Sum(Week46) Week46,  
   Sum(Week47) Week47,  
   Sum(Week48) Week48,  
   Sum(Week49) Week49,  
   Sum(Week50) Week50,  
   Sum(Week51) Week51,  
   Sum(Week52) Week52,  
   Sum(Week53) Week53  
 INTO #ResPPMSummary  
 FROM (  
  SELECT Assetno  
    ,AssetDescription  
    ,CustomerId  
    , TaskCode  
    ,'W2' WorkGroupCode  
    ,'Biomedical Engineering' as WorkGroupDescription  
    --,dbo.Fn_GetLogo(@pFacilityId, 'MOH') as 'MOH_Logo'  
    --,dbo.Fn_GetLogo(@pFacilityId, 'Company') as 'Company_logo'  
    ,'' as 'Facility_Logo'  
    ,'' as 'Company_Logo'  
    ,dbo.udf_DisplayHospitalName(2) 'FacilityName'  
    ,UserAreaCode  
    ,UserAreaName  
    ,ISNULL(CASE WHEN ISNULL(WeekNo ,0) =1 THEN 1 END,0) AS Week1   
    ,ISNULL(CASE WHEN ISNULL(WeekNo ,0) =2 THEN 1 END,0) AS Week2   
    ,ISNULL(CASE WHEN ISNULL(WeekNo ,0) =3 THEN 1 END,0) AS Week3   
    ,ISNULL(CASE WHEN ISNULL(WeekNo ,0) =4 THEN 1 END,0) AS Week4   
    ,ISNULL(CASE WHEN ISNULL(WeekNo ,0) =5 THEN 1 END,0) AS Week5   
    ,ISNULL(CASE WHEN ISNULL(WeekNo ,0) =6 THEN 1 END,0) AS Week6   
    ,ISNULL(CASE WHEN ISNULL(WeekNo ,0) =7 THEN 1 END,0) AS Week7   
    ,ISNULL(CASE WHEN ISNULL(WeekNo ,0) =8 THEN 1 END,0) AS Week8   
    ,ISNULL(CASE WHEN ISNULL(WeekNo ,0) =9 THEN 1 END,0) AS Week9   
    ,ISNULL(CASE WHEN ISNULL(WeekNo ,0) =10 THEN 1 END,0) AS Week10  
    ,ISNULL(CASE WHEN ISNULL(WeekNo ,0) =11 THEN 1 END,0) AS Week11  
    ,ISNULL(CASE WHEN ISNULL(WeekNo ,0) =12 THEN 1 END,0) AS Week12  
    ,ISNULL(CASE WHEN ISNULL(WeekNo ,0) =13 THEN 1 END,0) AS Week13  
    ,ISNULL(CASE WHEN ISNULL(WeekNo ,0) =14 THEN 1 END,0) AS Week14  
    ,ISNULL(CASE WHEN ISNULL(WeekNo ,0) =15 THEN 1 END,0) AS Week15  
    ,ISNULL(CASE WHEN ISNULL(WeekNo ,0) =16 THEN 1 END,0) AS Week16  
    ,ISNULL(CASE WHEN ISNULL(WeekNo ,0) =17 THEN 1 END,0) AS Week17  
    ,ISNULL(CASE WHEN ISNULL(WeekNo ,0) =18 THEN 1 END,0) AS Week18  
    ,ISNULL(CASE WHEN ISNULL(WeekNo ,0) =19 THEN 1 END,0) AS Week19  
    ,ISNULL(CASE WHEN ISNULL(WeekNo ,0) =20 THEN 1 END,0) AS Week20  
    ,ISNULL(CASE WHEN ISNULL(WeekNo ,0) =21 THEN 1 END,0) AS Week21  
    ,ISNULL(CASE WHEN ISNULL(WeekNo ,0) =22 THEN 1 END,0) AS Week22  
    ,ISNULL(CASE WHEN ISNULL(WeekNo ,0) =23 THEN 1 END,0) AS Week23  
    ,ISNULL(CASE WHEN ISNULL(WeekNo ,0) =24 THEN 1 END,0) AS Week24  
    ,ISNULL(CASE WHEN ISNULL(WeekNo ,0) =25 THEN 1 END,0) AS Week25  
    ,ISNULL(CASE WHEN ISNULL(WeekNo ,0) =26 THEN 1 END,0) AS Week26  
    ,ISNULL(CASE WHEN ISNULL(WeekNo ,0) =27 THEN 1 END,0) AS Week27  
    ,ISNULL(CASE WHEN ISNULL(WeekNo ,0) =28 THEN 1 END,0) AS Week28  
    ,ISNULL(CASE WHEN ISNULL(WeekNo ,0) =29 THEN 1 END,0) AS Week29  
    ,ISNULL(CASE WHEN ISNULL(WeekNo ,0) =30 THEN 1 END,0) AS Week30  
    ,ISNULL(CASE WHEN ISNULL(WeekNo ,0) =31 THEN 1 END,0) AS Week31  
    ,ISNULL(CASE WHEN ISNULL(WeekNo ,0) =32 THEN 1 END,0) AS Week32  
    ,ISNULL(CASE WHEN ISNULL(WeekNo ,0) =33 THEN 1 END,0) AS Week33  
    ,ISNULL(CASE WHEN ISNULL(WeekNo ,0) =34 THEN 1 END,0) AS Week34  
    ,ISNULL(CASE WHEN ISNULL(WeekNo ,0) =35 THEN 1 END,0) AS Week35  
    ,ISNULL(CASE WHEN ISNULL(WeekNo ,0) =36 THEN 1 END,0) AS Week36  
    ,ISNULL(CASE WHEN ISNULL(WeekNo ,0) =37 THEN 1 END,0) AS Week37  
    ,ISNULL(CASE WHEN ISNULL(WeekNo ,0) =38 THEN 1 END,0) AS Week38  
    ,ISNULL(CASE WHEN ISNULL(WeekNo ,0) =39 THEN 1 END,0) AS Week39  
    ,ISNULL(CASE WHEN ISNULL(WeekNo ,0) =40 THEN 1 END,0) AS Week40  
    ,ISNULL(CASE WHEN ISNULL(WeekNo ,0) =41 THEN 1 END,0) AS Week41  
    ,ISNULL(CASE WHEN ISNULL(WeekNo ,0) =42 THEN 1 END,0) AS Week42  
    ,ISNULL(CASE WHEN ISNULL(WeekNo ,0) =43 THEN 1 END,0) AS Week43  
    ,ISNULL(CASE WHEN ISNULL(WeekNo ,0) =44 THEN 1 END,0) AS Week44  
    ,ISNULL(CASE WHEN ISNULL(WeekNo ,0) =45 THEN 1 END,0) AS Week45  
    ,ISNULL(CASE WHEN ISNULL(WeekNo ,0) =46 THEN 1 END,0) AS Week46  
    ,ISNULL(CASE WHEN ISNULL(WeekNo ,0) =47 THEN 1 END,0) AS Week47  
    ,ISNULL(CASE WHEN ISNULL(WeekNo ,0) =48 THEN 1 END,0) AS Week48  
    ,ISNULL(CASE WHEN ISNULL(WeekNo ,0) =49 THEN 1 END,0) AS Week49  
    ,ISNULL(CASE WHEN ISNULL(WeekNo ,0) =50 THEN 1 END,0) AS Week50  
    ,ISNULL(CASE WHEN ISNULL(WeekNo ,0) =51 THEN 1 END,0) AS Week51  
    ,ISNULL(CASE WHEN ISNULL(WeekNo ,0) =52 THEN 1 END,0) AS Week52  
    ,ISNULL(CASE WHEN ISNULL(WeekNo ,0) =53 THEN 1 END,0) AS Week53  
    --, a.*  
   FROM #CONSTEMP   
  ) a GROUP BY AssetNo,AssetDescription,CustomerId,TaskCode,UserAreaCode,UserAreaName  


 SELECT *, ISNULL(@TaskCodeOption,0) TaskCodeOptionPARAM,
   @TotalRecords AS TotalRecords,  
   @pTotalPage AS TotalPageCalc  
 FROM #ResPPMSummary   

  
END TRY  
  
BEGIN CATCH  
  
 INSERT INTO ErrorLog(  
    Spname,  
    ErrorMessage,  
    createddate)  
 VALUES(  OBJECT_NAME(@@PROCID),  
    'Error_line: '+CONVERT(VARCHAR(10), error_line())+' - '+error_message(),  
    getdate()  
     )  
  
END CATCH
GO
