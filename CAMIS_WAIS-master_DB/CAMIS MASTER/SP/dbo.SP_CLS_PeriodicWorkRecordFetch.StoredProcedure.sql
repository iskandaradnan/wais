USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[SP_CLS_PeriodicWorkRecordFetch]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 --exec [dbo].[SP_CLS_PeriodicWorkRecordFetch] 0  
 --exec [dbo].[SP_CLS_PeriodicWorkRecordFetch] 63  
CREATE PROC [dbo].[SP_CLS_PeriodicWorkRecordFetch]  
@PeriodicId int  
as  
begin  
SET NOCOUNT ON;  
  
BEGIN TRY   


  
  IF(EXISTS(SELECT 1 FROM CLS_PeriodicWorkRecordTable WHERE PeriodicId = @PeriodicId))  
  BEGIN  
   SELECT Userareacode, Status, A1 AS ContainerWashing, A2 AS Ceiling, A3 AS Lights, A4 AS FloorScrubbing, A5 AS FloorPolishing, A6 AS FloorBuffing , A7 AS FloorBB, A8 AS FloorShampooing, A9 AS FloorExtraction,   
   A10 AS WallWiping, A11 AS WindowDW, A12 AS PerimeterDrain , A13 AS ToiletDescaling, A14 AS HighRiseNetting, A15 AS ExternalFacade , A16 AS ExternalHighLevelGlass, A17 AS InternetGlass, A18 AS FlatRoof ,  
   A19 AS StainlessSteelPolishing, A20 AS ExposeCeiling, A21 AS LedgesDampWipe , A22 AS SkylightHighDusting, A23 AS SignagesWiping, A24 AS DecksHighDusting   
   From CLS_PeriodicWorkRecordTable WHERE CLS_PeriodicWorkRecordTable.PeriodicId =  @PeriodicId  
  END  
  ELSE  
  BEGIN  
   SELECT A.Userareacode, A.Status,      
    (select FieldValue from FMLovMst where LovId = B.ContainerWashing) AS ContainerWashing,  
    (select FieldValue from FMLovMst where LovId = B.Ceiling) AS Ceiling,  
    (select FieldValue from FMLovMst where LovId = B.Lights) AS Lights,  
    (select FieldValue from FMLovMst where LovId = B.FloorScrubbing) AS FloorScrubbing,    
    (select FieldValue from FMLovMst where LovId = B.FloorPolishing) AS FloorPolishing,  
    (select FieldValue from FMLovMst where LovId = B.FloorBuffing) AS FloorBuffing,  
    (select FieldValue from FMLovMst where LovId = B.FloorBB) AS FloorBB,  
    (select FieldValue from FMLovMst where LovId = B.FloorShampooing) AS FloorShampooing,  
    (select FieldValue from FMLovMst where LovId = B.FloorExtraction) AS FloorExtraction,  
    (select FieldValue from FMLovMst where LovId = B.WallWiping) AS WallWiping,  
    (select FieldValue from FMLovMst where LovId = B.WindowDW) AS WindowDW,  
    (select FieldValue from FMLovMst where LovId = B.PerimeterDrain) AS PerimeterDrain,  
    (select FieldValue from FMLovMst where LovId = B.ToiletDescaling) AS ToiletDescaling,  
    (select FieldValue from FMLovMst where LovId = B.HighRiseNetting) AS HighRiseNetting,  
    (select FieldValue from FMLovMst where LovId = B.ExternalFacade) AS ExternalFacade,  
    (select FieldValue from FMLovMst where LovId = B.ExternalHighLevelGlass) AS ExternalHighLevelGlass,  
    (select FieldValue from FMLovMst where LovId = B.InternetGlass) AS InternetGlass,  
    (select FieldValue from FMLovMst where LovId = B.FlatRoof) AS FlatRoof,  
    (select FieldValue from FMLovMst where LovId = B.StainlessSteelPolishing) AS StainlessSteelPolishing,  
    (select FieldValue from FMLovMst where LovId = B.ExposeCeiling) AS ExposeCeiling,  
    (select FieldValue from FMLovMst where LovId = B.LedgesDampWipe) AS LedgesDampWipe,  
    (select FieldValue from FMLovMst where LovId = B.SkylightHighDusting) AS SkylightHighDusting,  
    (select FieldValue from FMLovMst where LovId = B.SignagesWiping) AS SignagesWiping,  
    (select FieldValue from FMLovMst where LovId = B.DecksHighDusting) AS DecksHighDusting  
   FROM CLS_DeptAreaDetails A  
   INNER JOIN CLS_DeptAreaPeriodicWork B ON A.DeptAreaId= B.DeptAreaId  
   JOIN FMLovMst C ON A.[Status] = C.LovId  
    WHERE C.FieldValue = 'Active' ORDER BY A.Userareacode   
  END  
    
     
  
    
END TRY  
BEGIN CATCH  
 INSERT INTO ExceptionLog (  
 ErrorLine, ErrorMessage, ErrorNumber,  
 ErrorProcedure, ErrorSeverity, ErrorState,  
 DateErrorRaised  
 )  
 SELECT  
 ERROR_LINE () as ErrorLine,  
 Error_Message() as ErrorMessage,  
 Error_Number() as ErrorNumber,  
 Error_Procedure() as 'SP_CLS_PeriodicWorkRecordFetch',  
 Error_Severity() as ErrorSeverity,  
 Error_State() as ErrorState,  
 GETDATE () as DateErrorRaised  
END CATCH  
END
GO
