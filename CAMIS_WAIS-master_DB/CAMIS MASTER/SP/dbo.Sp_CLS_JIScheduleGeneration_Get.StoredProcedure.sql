USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_CLS_JIScheduleGeneration_Get]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- EXEC [dbo].[Sp_CLS_JIScheduleGeneration_Get]   57    
CREATE PROCEDURE [dbo].[Sp_CLS_JIScheduleGeneration_Get]  
 @Id INT    
AS      
        
BEGIN        
SET NOCOUNT ON        
SET TRANSACTION ISOLATION LEVEL READ COMMITTED        
BEGIN TRY        
         
        
SELECT * FROM CLS_JIScheduleGeneration where JIId = @Id      
      
SELECT A.*, REPLACE(ISNULL((
	SELECT * FROM (select D.LocationCode as UserLocationCode, E.UserLocationName as UserLocationName,
	CASE WHEN D.[Floor] = 'True' then '' else 'NA' end as [F], 
	CASE WHEN D.[Walls] = 'True' then '' else 'NA' end as [W], 
	CASE WHEN D.[Celling] = 'True' then '' else 'NA' end as [C], 
	CASE WHEN D.[WindowsDoors] = 'True' then '' else 'NA' end as [WD], 
	CASE WHEN D.[ReceptaclesContainers] = 'True' then '' else 'NA' end as [R], 
	CASE WHEN D.[FurnitureFixtureEquipments] = 'True' then '' else 'NA' end as [FF]
	FROM CLS_DeptAreaDetailsLocation D
	JOIN CLS_DeptAreaDetails B ON B.DeptAreaId = D.DeptAreaId
	JOIN MstLocationUserLocation E ON D.LocationCode = E.UserLocationCode    
	where B.UserAreaCode = A.UserAreaCode And D.[Status] = 1 ) K FOR JSON AUTO   ), '') , '''', '')  as UserAreaLocations     
 from CLS_JIScheduleDocument A where  A.JIId = @Id         
      
         
END TRY        
BEGIN CATCH        
        
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)        
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());        
        
THROW        
        
END CATCH        
SET NOCOUNT OFF        
END
GO
