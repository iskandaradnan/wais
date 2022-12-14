USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_BEMSDAR_Rpt]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_helptext [Fn_DisplayNameofLov]

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~              
Application Name	: ASIS              
Version				:               
File Name			:              
Procedure Name		: uspFM_BEMSDAR_Rpt
Author(s) Name(s)	:  
Date				:  
Purpose				:  
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
EXEC SPNAME Parameter    
EXEC uspFM_BEMSDAR_Rpt  '@FacilityId','@Status','@Year','@FromDate','@ToDate'   

EXEC uspFM_BEMSDAR_Rpt  '1','2018','10','',''   

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
Modification History    
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
SLNO. VERSION     JIRAID       MODIFIED BY  DATE(DD/MM/YYYY)  REMARKS    
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~       
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/   

--Exec [uspFM_BEMSDAR_Rpt] 1,'','','',''
 			          
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[uspFM_BEMSDAR_Rpt]
(                                                
  @FacilityId		VARCHAR(20),
  @Year             INT,
  @Month			INT,
  @Reference_No		VARCHAR(50),
  @DedGenerationType VARCHAR(20)= null

)             
AS                                                
BEGIN                                  
SET NOCOUNT ON
SET FMTONLY OFF
SET ARITHABORT OFF
SET ANSI_WARNINGS OFF
/*
Declare  @FacilityId		INT=85,
  @Year             INT=2017,
  @Month			INT=1,
  @Reference_No		VARCHAR(50) =1
  --*/
CREATE TABLE #TABLE1 (Hospital VARCHAR(30),Monthly_Service_Fee NUMERIC(13,2),Monthly_Service_Fee_For_BEMS NUMERIC(13,2),Monthly_Service_Fee_For_FMS NUMERIC(13,2),Reference_Number VARCHAR(100),[Month] VARCHAR(20),[Year] INT, Remarks NVARCHAR(1000))

CREATE TABLE #TABLE2(Indicator_No VARCHAR(5),Indicator_Name VARCHAR(300),Weightage NUMERIC(13,2),Parameters INT,Key_Deduction_Indicators_Value NUMERIC(13,4),Ringgit_Equivalent NUMERIC(13,2),
Gearing_Ratio_Of_Ringgit_Equivalent NUMERIC(13,2),Demerit_Points NUMERIC(13,2),Deduction_Value_RM NUMERIC(13,2),Deduction_Percentage NUMERIC(13,2),Performance_Level NUMERIC(13,2), Frequency varchar(100))

CREATE TABLE #TABLE3(PreparedBy varchar(500), PreparedDesignation varchar(500), VerifiedBy varchar(500), VerifiedDesignation varchar(500))


--select * from  userDesignation
--Hospital Director
--Hospital Engineer

DECLARE @PreparedBy varchar(500), @PreparedDesignation varchar(500), @VerifiedBy varchar(500), @VerifiedDesignation varchar(500)

SELECT TOP 1 @PreparedBy = StaffName, @PreparedDesignation = b.designation ----dbo.[Fn_DisplayNameofLov](CurrentPosition) --Hospital Engineer,Hospital Director
FROM UMUserRegistration a inner join userDesignation b on a.UserDesignationId = b.UserDesignationId where  a.FacilityId=@FacilityId
 --and CurrentPosition = 2837  
and DateJoined <= getdate()  

SELECT TOP 1 @VerifiedBy = StaffName, @VerifiedDesignation = b.designation ----dbo.[Fn_DisplayNameofLov](CurrentPosition) --Hospital Engineer,Hospital Director
FROM UMUserRegistration a inner join userDesignation b on a.UserDesignationId = b.UserDesignationId where   a.FacilityId=@FacilityId
 --and CurrentPosition = 2837 
 and DateJoined <= getdate() 

INSERT INTO #TABLE3(PreparedBy, PreparedDesignation, VerifiedBy, VerifiedDesignation) VALUES (@PreparedBy, @PreparedDesignation, @VerifiedBy, @VerifiedDesignation)

INSERT INTO #TABLE1
EXEC [uspFM_BEMSDARHeader_Rpt] @FacilityId,@Year,@Month,@Reference_No

INSERT INTO #TABLE2
EXEC [uspFM_BEMSDARData_Rpt] @FacilityId,@Year,@Month,@Reference_No

if(@FacilityId=3)
begin
update #TABLE3 set PreparedBy=''
end
--SELECT * FROM #TABLE1 A, #TABLE2 B, #TABLE3

-- Below blank statement need to be removed. and uncomment above one
select '' Hospital , ''Monthly_Service_Fee , ''Monthly_Service_Fee_For_BEMS , ''Monthly_Service_Fee_For_FMS , ''Reference_Number , ''Month , ''Year , ''Remarks , ''Indicator_No , ''Indicator_Name , ''Weightage , ''Parameters , ''Key_Deduction_Indicators_Value , ''Ringgit_Equivalent , ''Gearing_Ratio_Of_Ringgit_Equivalent , ''Demerit_Points , ''Deduction_Value_RM , ''Deduction_Percentage , ''Performance_Level , ''Frequency , ''PreparedBy , ''PreparedDesignation , ''VerifiedBy , ''VerifiedDesignation


DROP TABLE #TABLE1
DROP TABLE #TABLE2

SET NOCOUNT OFF
SET ARITHABORT ON
SET ANSI_WARNINGS ON
END

--EXEC [BEMS_Deduction] '1','','',''
GO
