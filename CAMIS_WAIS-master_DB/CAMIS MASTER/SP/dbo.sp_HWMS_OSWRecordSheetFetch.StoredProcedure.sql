USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_HWMS_OSWRecordSheetFetch]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- EXEC [dbo].[sp_HWMS_OSWRecordSheetFetch] 'L',1,5,25
CREATE procedure [dbo].[sp_HWMS_OSWRecordSheetFetch]
(
      @UserAreaCode				nvarchar(100)	=	NULL,
	  @pPageIndex					INT,
	  @pPageSize					INT,
	  @pFacilityId					INT
)
AS                                              

BEGIN TRY
	SET NOCOUNT ON; 

	DECLARE @TotalRecords INT
	

		SELECT		@TotalRecords	=	COUNT(*)
		FROM		HWMS_DeptAreaDetails A WITH(NOLOCK)
		where  ((ISNULL(@UserAreaCode	,'') = '' )	OR (ISNULL(@UserAreaCode	,'') <> '' AND UserAreaCode	 LIKE + '%' + @UserAreaCode + '%' ))
		
		SELECT A.DeptAreaId,A.UserAreaCode, A.UserAreaName ,C.FieldValue AS [CollectionFrequency],	@TotalRecords AS TotalRecords
		FROM		HWMS_DeptAreaDetails A WITH(NOLOCK)
		INNER JOIN HWMS_DeptAreaCollectionFrequency B ON A.DeptAreaId = B.DeptAreaId
		LEFT JOIN FMLovMst C ON B.CollectionFrequency = C.LovId 
		where  ((ISNULL(@UserAreaCode,'') = '' )	OR (ISNULL(@UserAreaCode,'') <> '' AND UserAreaCode LIKE + '%' + @UserAreaCode + '%' ))
		ORDER BY	A.DeptAreaId DESC 	OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY 

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
