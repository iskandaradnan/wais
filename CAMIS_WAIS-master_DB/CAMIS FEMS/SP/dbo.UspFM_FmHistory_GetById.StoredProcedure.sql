USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_FmHistory_GetById]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: UspFM_FinMonthlyFeeTxn_GetById
Description			: To Get the data from table FinMonthlyFeeTxn using the Primary Key id
Authors				: Dhilip V
Date				: 30-Mar-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [UspFM_FmHistory_GetById] @pTableGuid='1DDC1F6D-8782-4C25-BFCD-3A41D4CA0B74',@pPageIndex=1,@pPageSize=10
select * from FmHistory
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE  PROCEDURE  [dbo].[UspFM_FmHistory_GetById]                           

  @pTableGuid		NVARCHAR(MAX),
  @pPageIndex		INT,
  @pPageSize		INT	
  
AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE	  @TotalRecords		INT
	DECLARE   @pTotalPage		NUMERIC(24,2)
	DECLARE   @pTotalPageCalc	NUMERIC(24,2)

	IF(ISNULL(@pTableGuid,'') = '') RETURN

	SELECT	@TotalRecords	=	COUNT(*)
	FROM	[FmHistory]											AS History	WITH(NOLOCK)
	WHERE	History.TableGuid = @pTableGuid

	SET @pTotalPage = CAST(@TotalRecords AS NUMERIC(24,2))/CAST(@pPageSize AS NUMERIC(24,2))

	SET @pTotalPage = CEILING(@pTotalPage)

    SELECT	TableRowData,
	@TotalRecords as TotalRecords
	FROM	[FmHistory]											AS History	WITH(NOLOCK)
	WHERE	History.TableGuid = @pTableGuid

	ORDER BY History.[ModifiedDate] ASC
	OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY



END TRY

BEGIN CATCH
throw
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
