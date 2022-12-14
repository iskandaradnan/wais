USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_DailyWeighingRecord_BinNoCodeFetch]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Sp_HWMS_DailyWeighingRecord_BinNoCodeFetch]
-- exec [dbo].[Sp_HWMS_DailyWeighingRecord_BinNoCodeFetch] 'B', 1,5,25
(
      @BinNo				varchar(30),
	  @pPageIndex					INT,
	  @pPageSize					INT,
	  @pFacilityId					INT
)
AS                                              

BEGIN TRY

	SET NOCOUNT ON; 

	DECLARE @TotalRecords INT

		SELECT		@TotalRecords	=	COUNT(*)
		FROM		HWMS_BinMasterBins A  WITH(NOLOCK)
		where  ((ISNULL(@BinNo	,'') = '' )	OR (ISNULL(@BinNo	,'') <> '' AND A.BinNo	 LIKE + '%' + @BinNo + '%' ))
		


		SELECT A.BinNoId,A.BinNo,@TotalRecords AS TotalRecords	
		FROM		HWMS_BinMasterBins A  WITH(NOLOCK)
		where  ((ISNULL(@BinNo,'') = '' )	OR (ISNULL(@BinNo,'') <> '' AND A.BinNo LIKE + '%' + @BinNo + '%' ))
		ORDER BY	A.BinNoId DESC
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
