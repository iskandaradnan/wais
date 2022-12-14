USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_DriverDetails_LicenseCodeFetch]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Sp_HWMS_DriverDetails_LicenseCodeFetch]
-- exec [dbo].[Sp_HWMS_DriverDetails_LicenseCodeFetch] 'LC', 0,5,25
(
      @pLicenseCode				NVARCHAR(100),
	  @pPageIndex					INT,
	  @pPageSize					INT,
	  @pFacilityId					INT
)
AS                                              

BEGIN TRY

	SET NOCOUNT ON; 

	DECLARE @TotalRecords INT

		SELECT		@TotalRecords	=	COUNT(*)
		FROM		HWMS_LicenseType_Details A  WITH(NOLOCK)
		where  ((ISNULL(@pLicenseCode	,'') = '' )	OR (ISNULL(@pLicenseCode	,'') <> '' AND A.LicenseCode	 LIKE + '%' + @pLicenseCode + '%' ))
		


		SELECT A.LicenseId,A.LicenseCode,A.LicenseDescription,A.issuingBody , @TotalRecords AS TotalRecords	
		FROM		HWMS_LicenseType_Details A  WITH(NOLOCK)
		where  ((ISNULL(@pLicenseCode,'') = '' )	OR (ISNULL(@pLicenseCode,'') <> '' AND A.LicenseCode LIKE + '%' + @pLicenseCode + '%' ))
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
