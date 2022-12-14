USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_HWMS_DeptAreaDetails_Export]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec sp_HWMS_DeptAreaDetails_Export 'FacilityId = 25','DeptAreaId desc'
CREATE procedure [dbo].[sp_HWMS_DeptAreaDetails_Export]

	@StrCondition	NVARCHAR(MAX) = NULL,
	@StrSorting		NVARCHAR(MAX) = NULL

AS 

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;	

	DECLARE @qry	NVARCHAR(MAX);



SET @qry = 'SELECT [UserAreaCode], [UserAreaName], [OperatingDays],[Status],[Category] FROM ( 
			SELECT	[DeptAreaId], [CustomerId], [FacilityId], [UserAreaCode], [UserAreaName],C.FieldValue AS [OperatingDays],B.FieldValue AS [Status],
			D.FieldValue AS [Category],A.[Remarks] 
			FROM [HWMS_DeptAreaDetails] A
			  LEFT JOIN FMLovMst B ON A.Status = B.LovId
			  LEFT JOIN FMLovMst C ON A.OperatingDays = C.LovId	
			  LEFT JOIN FMLovMst D ON A.Category = D.LovId	 ) A
			WHERE 1 = 1 ' 
			+ CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' and '+ REPLACE(ISNULL(@strCondition,''),'where',' AND ')  END  
			+ ' ORDER BY ' +  ISNULL(@strSorting,'A.DeptAreaId DESC')
			
print @qry;

EXECUTE sp_executesql @qry
	
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
