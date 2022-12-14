USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_FMItemMaster_Search]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_FMItemMaster_Search
Description			: StaffName search popup
Authors				: Dhilip V
Date				: 04-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_FMItemMaster_Search  @pItemNo='b',@pPageIndex=1,@pPageSize=5

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_FMItemMaster_Search]                           
  @pItemNo				NVARCHAR(100) = NULL,
  @pItemDescription		NVARCHAR(500) = NULL,
  @pPageIndex			INT,
  @pPageSize			INT
AS                                              

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration

	DECLARE @TotalRecords INT
-- Default Values


-- Execution

		SELECT		@TotalRecords	=	COUNT(*)
		FROM		FMItemMaster ItemMaster WITH(NOLOCK)
		WHERE		ItemMaster.Active =1
					AND ((ISNULL(@pItemNo,'') = '' )	OR (ISNULL(@pItemNo,'') <> '' AND ItemMaster.ItemNo LIKE + '%' + @pItemNo + '%' ))
					AND ((ISNULL(@pItemDescription,'') = '' )	OR (ISNULL(@pItemDescription,'') <> '' AND ItemMaster.ItemDescription LIKE + '%' + @pItemDescription + '%' ))

		SELECT		ItemMaster.ItemId,
					ItemMaster.ItemNo,
					ItemMaster.ItemDescription,
					ItemMaster.ModifiedDateUTC,
					@TotalRecords AS TotalRecords
		FROM		FMItemMaster ItemMaster WITH(NOLOCK)
		WHERE		ItemMaster.Active =1
					AND ((ISNULL(@pItemNo,'') = '' )	OR (ISNULL(@pItemNo,'') <> '' AND ItemMaster.ItemNo LIKE + '%' + @pItemNo + '%' ))
					AND ((ISNULL(@pItemDescription,'') = '' )	OR (ISNULL(@pItemDescription,'') <> '' AND ItemMaster.ItemDescription LIKE + '%' + @pItemDescription + '%' ))
		ORDER BY	ItemMaster.ModifiedDateUTC DESC
		OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY 



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
