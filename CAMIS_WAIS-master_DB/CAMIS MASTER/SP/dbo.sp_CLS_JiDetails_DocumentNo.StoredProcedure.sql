USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_CLS_JiDetails_DocumentNo]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_CLS_JiDetails_DocumentNo]
(
      @pDocumentNo				NVARCHAR(100),
	  @pPageIndex					INT,
	  @pPageSize					INT,
	  @pFacilityId					INT


)
AS                                              
BEGIN TRY
SET NOCOUNT ON; 

DECLARE @TotalRecords INT
	SELECT		@TotalRecords	=	COUNT(*)
		FROM		CLS_JIScheduleDocument A WITH(NOLOCK)
		where  ((ISNULL(@pDocumentNo,'') = '' )	OR (ISNULL(@pDocumentNo,'') <> '' AND A.DocumentNo LIKE + '%' + @pDocumentNo + '%' ))

		select A.ScheduleId,A.DocumentNo,A.UserAreaCode,A.UserAreaName,
		 @TotalRecords AS TotalRecords FROM		CLS_JIScheduleDocument A WITH(NOLOCK)
		where  ((ISNULL(@pDocumentNo,'') = '' )	OR (ISNULL(@pDocumentNo,'') <> '' AND A.DocumentNo LIKE + '%' + @pDocumentNo + '%' ))
		ORDER BY	A.ScheduleId DESC
		OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY 
END TRY
BEGIN CATCH
INSERT INTO ErrorLog(
				Spname,
				ErrorMessage,
				createddate)
VALUES(OBJECT_NAME(@@PROCID),
				'Error_line: '+CONVERT(VARCHAR(10),	ERROR_LINE())+' - '+ERROR_MESSAGE(),
				GETDATE())
END CATCH
GO
