USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[usp_FM_FmsContractDetailsAndDuration_L3]    Script Date: 20-09-2021 16:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                  
Application Name : ASIS                  
Version       :                   
File Name      : Asis_FmsContractDetailsAndDuration_L3                  
Procedure Name  : Asis_FmsContractDetailsAndDuration_L3   
Author(s) Name(s) : Balaji M S    
Date       :     
Purpose       : SP For Contract Details and Duration of Contract Report  Level 2    
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~        

EXEC [usp_FM_FmsContractDetailsAndDuration_L3] '1','2','1','2018'
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~        
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~        
Modification History        
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~        
SLNO. VERSION     JIRAID       MODIFIED BY  DATE(DD/MM/YYYY)  REMARKS        
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~        
          
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/                    
CREATE PROCEDURE [dbo].[usp_FM_FmsContractDetailsAndDuration_L3]                                        
(                                                    
  @Facility_Id varchar(5),
  @Service_Id varchar(5),
  @Contractor_Id varchar(MAX),         
  @Year varchar(5)    
 )                 
AS                                                    
BEGIN                                      
SET NOCOUNT ON                                         
SELECT '' AS Hospital_Name,'' AS	Contract_No,'' AS	Contract_Name, '' AS	Contract_Type,'' AS	Contract_Start_Date,'' AS	Contract_End_Date
SET NOCOUNT OFF  
                                                
END
GO
