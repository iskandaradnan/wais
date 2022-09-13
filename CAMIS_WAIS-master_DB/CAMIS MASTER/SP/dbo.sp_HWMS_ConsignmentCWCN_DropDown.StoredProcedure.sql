USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_HWMS_ConsignmentCWCN_DropDown]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_HWMS_ConsignmentCWCN_DropDown]
@pScreenName	nvarchar(400)
AS                                              

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration

-- Default Values

-- Execution
	if(@pScreenName = 'ConsignmentNoteCWCN')
	BEGIN

			SELECT	LovId, FieldValue, IsDefault FROM	FMLovMst WITH(NOLOCK)
			WHERE	Active = 1 	AND LovKey='QcValues' and ScreenName = @pScreenName

			SELECT	LovId	AS LovId,		FieldValue	AS FieldValue	, IsDefault				
			FROM	FMLovMst WITH(NOLOCK)
			WHERE	Active = 1 	AND LovKey='OnScheduleValues' and  ScreenName = @pScreenName	 
	      
		   SELECT	LovId	AS LovId,	FieldValue	AS FieldValue, IsDefault,SortNo		FROM	FMLovMst WITH(NOLOCK)
		    WHERE	Active = 1 	AND LovKey='FileTypeValues' and  ScreenName = 'ApprovedChemicalList'
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
