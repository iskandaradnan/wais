USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_FollowUpCARNoFetch]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Sp_HWMS_FollowUpCARNoFetch]
-- exec [dbo].[Sp_CLS_CARNoFetch] 'A', 0,5,25
(
      @CARNo				NVARCHAR(100),
	  @pPageIndex					INT,
	  @pPageSize					INT,
	  @pFacilityId					INT
)
AS                                              

BEGIN TRY
	    SET NOCOUNT ON; 
	    DECLARE @TotalRecords INT
		SELECT		@TotalRecords	=	COUNT(*)
		FROM		HWMS_CorrectiveActionReport A  WITH(NOLOCK)
		where  ((ISNULL(@CARNo	,'') = '' )	OR (ISNULL(@CARNo	,'') <> '' AND A.CARNo	 LIKE + '%' + @CARNo + '%' ))		
		SELECT A.CARId,A.CARNo,@TotalRecords AS TotalRecords	
		FROM	HWMS_CorrectiveActionReport A  WITH(NOLOCK)
		where  ((ISNULL(@CARNo,'') = '' )	OR (ISNULL(@CARNo,'') <> '' AND A.CARNo LIKE + '%' + @CARNo + '%' ))
		ORDER BY	A.CARId DESC
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
