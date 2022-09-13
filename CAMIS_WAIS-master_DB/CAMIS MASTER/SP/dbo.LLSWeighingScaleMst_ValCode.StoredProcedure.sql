USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSWeighingScaleMst_ValCode]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Weighing Scale & Equipment Calibration:LLSWeighingScaleMst
  
CREATE PROCEDURE [dbo].[LLSWeighingScaleMst_ValCode]  
(  
 @Id INT,  
 @pCustomerId INT,  
 @pFacilityId INT,   
 @SerialNo NVARCHAR(100)  
   
)  
   
AS   

--PLEASE PASS THE VALUES AS PER YOUR CHECK   
-- EXEC [LLSWeighingScaleMst_ValCode] 
  
--/*=====================================================================================================================  
--APPLICATION  : UETrack  
--NAME    : IsRoleDuplicate  
--DESCRIPTION  : CHECKS FOR THE UNIQUENESS OF USER ROLE  
--AUTHORS   : SIDDHANT   
--DATE    : 21-JAN-2020  
-------------------------------------------------------------------------------------------------------------------------  
--VERSION HISTORY   
--------------------:---------------:---------------------------------------------------------------------------------------  
--Init    : Date          : Details  
--------------------:---------------:---------------------------------------------------------------------------------------  
--SIDDHANT           : 21-JAN-2020 :   
-------:------------:----------------------------------------------------------------------------------------------------*/  
BEGIN  
SET NOCOUNT ON  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
BEGIN TRY  
   
 DECLARE  @IsDuplicate BIT = 0;  
 DECLARE @Cnt INT=0;  
  
 IF (@Id = 0)  
 SELECT @Cnt = COUNT(1) FROM LLSWeighingScaleMst 
 WHERE SerialNo = @SerialNo and CustomerId=@pCustomerId and FacilityId=@pFacilityId  
   
IF (@Cnt = 0) SET @IsDuplicate = 0;  
ELSE SET @IsDuplicate = 1;  
  
SELECT @IsDuplicate IsDuplicate  
   
END TRY  
BEGIN CATCH  
  
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)  
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),ERROR_LINE()) + ' - '+ERROR_MESSAGE(),GETDATE());  
  
THROW  
  
END CATCH  
SET NOCOUNT OFF  
END
GO
