USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_BEMSDARHeader_Rpt]    Script Date: 20-09-2021 16:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~              
Application Name	: UETRACK BEMS              
Version				:               
File Name			:              
Procedure Name		: uspFM_BEMSDAR_Rpt
Author(s) Name(s)	: Hari Haran N
Date				:  
Purpose				:  BEMS Dar Report
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
EXEC SPNAME Parameter    
EXEC uspFM_BEMSDAR_Rpt  '@Hospital_Id','@Year','@Month','@Reference_No','@DedGenerationType'   
EXEC uspFM_BEMSDAR_Rpt   '1','2018','3','12','12'
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
Modification History    
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
SLNO. VERSION     JIRAID       MODIFIED BY  DATE(DD/MM/YYYY)  REMARKS    
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~       
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/   
 			          
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[uspFM_BEMSDARHeader_Rpt]
(                                                
  @Hospital_Id		INT,
  @Year             INT,
  @Month			INT,
  @Reference_No		VARCHAR(50),
  @DedGenerationType int= null

)             
AS                                                
BEGIN    

                              
SET NOCOUNT ON
	DECLARE @MonthName varchar(100), @DocumentNo varchar(100), @Remarks nvarchar(1000)
	SELECT @MonthName = FieldValue FROM FMLovMst WHERE FieldName = 'Month' AND FieldCode = @Month
	SELECT @DocumentNo = DocumentNo, @Remarks = Remarks FROM DedGenerationTxn WHERE [ServiceId] = 2 AND FacilityId =@Hospital_Id AND [Month] = @Month AND [Year] = @Year 

	SELECT C.FacilityName AS 'Hospital',(B.BemsMSF) as 'Monthly_Service_Fee',CONVERT(NUMERIC(13,2),(B.BemsMSF)*0.975) as 'Monthly_Service_Fee_For_BEMS',
	CONVERT(NUMERIC(13,2),(B.BemsMSF)*0.025) as 'Monthly_Service_Fee_For_FMS',
	@DocumentNo as 'Reference_Number',@MonthName as 'Month',@Year as 'Year', @Remarks AS Remarks
	FROM FinMonthlyFeeTxn A,FinMonthlyFeeTxnDet B,MstLocationFacility C
	WHERE C.FacilityId=@Hospital_Id


	AND A.FacilityId=C.FacilityId
	AND A.Year=@Year
	AND B.Month=@Month
	AND A.MonthlyFeeId=B.MonthlyFeeId
	--AND B.VersionNo = (SELECT MAX(VersionNo) FROM FinMonthlyFeeTxnDet)
	
SET NOCOUNT OFF
END
GO
