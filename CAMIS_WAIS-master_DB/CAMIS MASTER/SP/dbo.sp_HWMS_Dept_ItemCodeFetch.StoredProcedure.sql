USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_HWMS_Dept_ItemCodeFetch]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--- exec sp_HWMS_Dept_ItemCodeFetch 'c', 10576, 1,10,25
-- select * from HWMS_ConsumablesReceptaclesItems
CREATE procedure [dbo].[sp_HWMS_Dept_ItemCodeFetch]
	@pItemCode	NVARCHAR(100),
	@pWasteTypeCode	INT,
	@pPageIndex	INT,
	@pPageSize	INT,
	@pFacilityId	INT

AS                                              
BEGIN TRY
SET NOCOUNT ON; 
	
	DECLARE @TotalRecords INT
	SELECT	@TotalRecords	=	COUNT(*)
	FROM HWMS_ConsumablesReceptacles A
	JOIN HWMS_ConsumablesReceptaclesItems B
	WITH(NOLOCK) ON A.ConsumablesId = B.ConsumablesId 
	WHERE A.WasteType = @pWasteTypeCode AND ((ISNULL(@pItemCode,'') = '' )	OR (ISNULL(@pItemCode,'') <> '' AND B.ItemCode LIKE + '%' + @pItemCode + '%' ))

	select B.ItemCodeId, B.ItemCode, B.ItemName, B.Size, B.UOM, @TotalRecords AS TotalRecords 	
	FROM HWMS_ConsumablesReceptacles A
	JOIN HWMS_ConsumablesReceptaclesItems B WITH(NOLOCK)
	ON A.ConsumablesId = B.ConsumablesId 
	WHERE  A.WasteType = @pWasteTypeCode AND ((ISNULL(@pItemCode,'') = '' )	OR (ISNULL(@pItemCode,'') <> '' AND B.ItemCode LIKE + '%' + @pItemCode + '%' )) 
	ORDER BY B.ConsumablesId DESC OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY 

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
