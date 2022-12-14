USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_TreatmentPlant_LicenseCodeFetch]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--- exec sp_HWMS_Dept_ItemCodeFetch 'Code',5,0,25
CREATE PROCEDURE [dbo].[Sp_HWMS_TreatmentPlant_LicenseCodeFetch]

(
      @LicenseCode				NVARCHAR(100)	=	NULL,
	  @pPageIndex					INT,
	  @pPageSize					INT,
	  @pFacilityId					INT


)
AS                                              

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration

	DECLARE @TotalRecords INT
	set @pFacilityId = ''
-- Default Values  -- select * from MstLocationUserArea 

-- Execution

		SELECT		@TotalRecords	=	COUNT(*)
		FROM		HWMS_LicenseTypeTableSave A WITH(NOLOCK)
		where  ((ISNULL(@LicenseCode,'') = '' )	OR (ISNULL(@LicenseCode,'') <> '' AND A.LicenseCode LIKE + '%' + @LicenseCode + '%' ))
		
		select A.LicenseTypeId,A.LicenseCode,
		       --(SELECT COUNT(*) FROM EngAsset WHERE ConsumablesTableId	=	A.ConsumablesTableId) AS AssetCount,
		@TotalRecords AS TotalRecords

		FROM		HWMS_LicenseTypeTableSave A WITH(NOLOCK)
		where  ((ISNULL(@LicenseCode,'') = '' )	OR (ISNULL(@LicenseCode,'') <> '' AND A.LicenseCode LIKE + '%' + @LicenseCode + '%' ))
		ORDER BY	A.LicenseTypeId DESC
		OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY 

		END TRY

BEGIN CATCH

	INSERT INTO ErrorLog(
				Spname,
				ErrorMessage,
				createddate)

	VALUES(		OBJECT_NAME(@@PROCID),
				'Error_line: '+CONVERT(VARCHAR(10),	ERROR_LINE())+' - '+ERROR_MESSAGE(),
				GETDATE()
		   )


END CATCH
GO
