USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_BERApplicationTxn_BERAnalysis_Rpt_L1]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  
/*========================================================================================================  
Application Name : UETrack-BEMS                
Version    : 1.0  
Procedure Name  : [uspFM_BERApplicationTxn_BERAnalysis_Rpt_L1]   
Description   : Get the BER Analysis Report(Level1)  
Authors    : Ganesan S  
Date    : 13-June-2018  
-----------------------------------------------------------------------------------------------------------  
  
Unit Test:  
exec [uspFM_BERApplicationTxn_BERAnalysis_Rpt_L1] @FacilityId = 1,  @From_Date = '01/01/2015', @To_Date= '01/01/2019'
@To_Month= '07',@To_Year=2018 ,@Type_id=2,@MenuName = ''  
  
-----------------------------------------------------------------------------------------------------------  
Version History   
exec [uspFM_BERApplicationTxn_BERAnalysis_Rpt_L1] @Service = 2,@From_Date='01',@From_Year= 2018,  
@To_Month= '07',@To_Year=2018 ,@Type_id=2,@MenuName = ''  
-----:------------:---------------------------------------------------------------------------------------  
Init : Date       : Details  
========================================================================================================*/  
CREATE  PROCEDURE [dbo].[uspFM_BERApplicationTxn_BERAnalysis_Rpt_L1]                                    
(          
       @From_Date  VARCHAR(100) = '',      
          @To_Date   VARCHAR(100) = ''  ,   
          @FacilityId    int            
 )             
AS                                                
BEGIN   
  
SET NOCOUNT ON  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
BEGIN TRY  
    
 DECLARE @mydate DATETIME  
SELECT @mydate = GETDATE()  
  
Declare @CMFirstDay Datetime, @CMLastDay Datetime , @LMFirstDay Datetime, @LMlastDay Datetime  
  
set @CMFirstDay=(SELECT CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(@mydate)-1),@mydate),101))  
set @CMLastDay = (SELECT CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(DATEADD(mm,1,@mydate))),DATEADD(mm,1,@mydate)),101))  
set @LMFirstDay=(SELECT CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(DATEADD(mm,1,@mydate))-1),DATEADD(mm,1,@mydate)),101))  
set @LMlastDay= (SELECT CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(@mydate)),@mydate),101))  
  
DECLARE @@BERAnalysisTable TABLE(      
ID    INT IDENTITY(1,1),    
FacilityName NVARCHAR(512),    
CustomerName NVARCHAR(512),    
CurrentMonthCount  INT,    
PreviousMonthCount INT,     
TotalCount INT,    
FacilityManagerCount  INT,    
HDCount  INT,  
LACount   INT  
)    
  
  
Insert into @@BERAnalysisTable(FacilityName,   
                               CustomerName ,  
          CurrentMonthCount,  
          PreviousMonthCount ,  
        TotalCount,   
        FacilityManagerCount,  
        HDCount,  
        LACount  
        )  
                                      
select  fac.FacilityName,  
        cust.CustomerName,  
  
SUM(CASE WHEN CAST(ber.ApplicationDate AS DATE) >= CAST(@CMFirstDay  AS DATE) AND CAST(ber.ApplicationDate  AS DATE) <= CAST(@CMLastDay AS DATE) THEN 1 ELSE 0 END) AS CurrentMonthCount  ,  
SUM(CASE WHEN CAST(ber.ApplicationDate AS DATE) >= CAST(@LMFirstDay  AS DATE) AND CAST(ber.ApplicationDate  AS DATE) <= CAST(@LMlastDay AS DATE) THEN 1 ELSE 0 END) AS PreviousMonthCount,  
  
 (select count(1) from BERApplicationTxn a where a.BERStatus not  in (206,210) and a.FacilityId=@FacilityId and   
 (CAST(a.ApplicationDate AS DATE) BETWEEN CAST(@From_Date  AS DATE) AND CAST(@To_Date AS DATE) )) as TotalCount,  
   
 (select count(1) from BERApplicationTxn a where a.BERStatus in (202,204,205) and a.FacilityId=@FacilityId and   
 (CAST(a.ApplicationDate AS DATE) BETWEEN CAST(@From_Date  AS DATE) AND CAST(@To_Date AS DATE) )) as FacilityManagerCount,  
  
 (select count(1) from BERApplicationTxn a where a.BERStatus in (203,208,209) and a.FacilityId=@FacilityId and   
 (CAST(a.ApplicationDate AS DATE) BETWEEN CAST(@From_Date  AS DATE) AND CAST(@To_Date AS DATE) )) as HDCount,  
 (select count(1) from BERApplicationTxn a where a.BERStatus in (207) and a.FacilityId=@FacilityId and   
 (CAST(a.ApplicationDate AS DATE) BETWEEN CAST(@From_Date  AS DATE) AND CAST(@To_Date AS DATE) )) as LACount   
 from   
BERApplicationTxn ber   
  
inner join MstCustomer cust on cust.CustomerId= ber.CustomerId  
inner join MstLocationFacility fac on fac.FacilityId= ber.FacilityId  
  
where   
 ((ber.FacilityId = @FacilityId) OR (@FacilityId IS NULL) OR (@FacilityId = ''))   AND  
    (CAST(ber.ApplicationDate AS DATE) BETWEEN CAST(@From_Date  AS DATE) AND CAST(@To_Date AS DATE))    
group by cust.CustomerName, fac.FacilityName  
  
  
SELECT *  
, ISNULL(@From_Date,'') AS FromDateParam    
, ISNULL(@To_Date,'') AS ToDateParam    
       
From @@BERAnalysisTable  
  
  
END TRY  
BEGIN CATCH  
  
insert into ErrorLog(Spname,ErrorMessage,createddate)  
  values(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())  
  
END CATCH  
SET NOCOUNT OFF  
  
  
END
GO
