USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_Deduction_Summary]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~              
Application Name	: ASIS              
Version				:               
File Name			:              
Procedure Name		: [usp_FM_Deduction_Summary] 
Author(s) Name(s)	: Balaji M S
Date				: 31/06/2018
Purpose				: 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
EXEC SPNAME Parameter    
EXEC [uspFM_Deduction_Summary]  '@pFacilityId','@pMonth','@pYear'
EXEC [uspFM_Deduction_Summary] '2',05,2018

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
Modification History    
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
SLNO. VERSION     JIRAID       MODIFIED BY  DATE(DD/MM/YYYY)  REMARKS    
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~       
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/  
CREATE PROCEDURE [dbo].[uspFM_Deduction_Summary]
(                                                
	@pFacilityId						INT,                                           
	@pMonth								INT,
	@pYear								INT


)             
AS                                                
BEGIN    



                              
SET NOCOUNT ON
SET FMTONLY OFF;

CREATE TABLE #TABLE1 
(
	Facility							VARCHAR(30),
	Month								VARCHAR(30),
	Year								INT,

)

CREATE TABLE #TABLE2
(
	Services							NVARCHAR(200),
	MSF									NUMERIC(13,2),
	RM									NUMERIC(13,2),
	Deduction_Percentage 				NUMERIC(13,2),
	CF									NUMERIC(13,2)
)

INSERT INTO #TABLE1
EXEC [uspFM_Summary_DAR_Header] @pFacilityId,@pMonth,@pYear

INSERT INTO #TABLE2
EXEC [uspFM_Summary_DAR_Data]   @pFacilityId,@pMonth,@pYear

SELECT * FROM #TABLE1 A, #TABLE2 B

DROP TABLE #TABLE1
DROP TABLE #TABLE2


SET NOCOUNT OFF  
END
GO
