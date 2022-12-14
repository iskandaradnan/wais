USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_CollectionDetailsFetch_Get]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Sp_HWMS_CollectionDetailsFetch_Get]
AS
BEGIN
SET NOCOUNT ON; 
BEGIN TRY
BEGIN
		SELECT UserAreaCode,C.FieldValue AS [CollectionFrequency],D.FieldValue AS [FrequencyType]
		FROM HWMS_DeptAreaDetails A		
		INNER JOIN HWMS_DeptAreaCollectionFrequency B ON A.DeptAreaId=B.DeptAreaId
		LEFT JOIN FMLovMst C ON B.CollectionFrequency = C.LovId 
		LEFT JOIN FMLovMst D ON B.FrequencyType = D.LovId 


		
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
		Error_Procedure() as 'Sp_HWMS_CollectionDetailsFetch_Get',  
		Error_Severity() as ErrorSeverity,  
		Error_State() as ErrorState,  
		GETDATE () as DateErrorRaised  
END CATCH 
END
GO
