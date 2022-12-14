USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_CSWRecordSheet_Load]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[Sp_HWMS_CSWRecordSheet_Load]                          
  @pScreenName	nvarchar(400)
  -- exec Sp_HWMS_CSWRecordSheet_Load
AS                                              
BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
-- Default Values
-- Execution
	
	if(@pScreenName = 'CSWRecordSheet')
	BEGIN

        	 SELECT LovId, FieldValue, IsDefault FROM FMLovMst WITH(NOLOCK)
            WHERE Active = 1 AND ScreenName = 'Waste Type' and FieldName = 'WasteType'
				 

			SELECT	LovId, FieldValue, IsDefault FROM	FMLovMst WITH(NOLOCK)
			WHERE	Active = 1 	AND LovKey='MonthValues' and ScreenName = @pScreenName

	        SELECT	LovId	AS LovId,		FieldValue	AS FieldValue	, IsDefault				
			FROM	FMLovMst WITH(NOLOCK)
			WHERE	Active = 1 	AND LovKey='YearValues' and  ScreenName = @pScreenName

		    SELECT	LovId	AS LovId,		FieldValue	AS FieldValue	, IsDefault				
			FROM	FMLovMst WITH(NOLOCK)
			WHERE	Active = 1 	AND LovKey='CollectionTypeValues' and  ScreenName = @pScreenName

			SELECT LovId, FieldValue, IsDefault FROM FMLovMst WITH(NOLOCK)
              WHERE Active = 1 AND LovKey='StatusValues' and ScreenName = @pScreenName

			
		    SELECT	LovId	AS LovId,		FieldValue	AS FieldValue	, IsDefault				
			FROM	FMLovMst WITH(NOLOCK)
			WHERE	Active = 1 	AND LovKey='CollectionStatusValues' and  ScreenName = @pScreenName

					    SELECT	LovId	AS LovId,		FieldValue	AS FieldValue	, IsDefault				
			FROM	FMLovMst WITH(NOLOCK)
			WHERE	Active = 1 	AND LovKey='CollectionFrequencyValues' and  ScreenName = @pScreenName
		
		  SELECT	LovId, FieldValue, IsDefault FROM	FMLovMst WITH(NOLOCK)
			WHERE	Active = 1 	AND ScreenName = 'ConsignmentNoteCWCN' and FieldName = 'QC'



	 END

END TRY

BEGIN CATCH

	INSERT INTO ErrorLog(
				Spname,
				ErrorMessage,
				createddate)
	VALUES(		OBJECT_NAME(@@PROCID),
				'Error_line: '+CONVERT(VARCHAR(10),	error_line())+' - '+error_message(),
				getdate()
		   )

END CATCH
GO
