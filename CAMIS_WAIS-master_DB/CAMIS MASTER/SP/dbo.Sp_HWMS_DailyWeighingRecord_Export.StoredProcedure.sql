USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_DailyWeighingRecord_Export]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec [dbo].[Sp_HWMS_DailyWeighingRecord_Export] 'FacilityId = 25', 'DWRId desc'
CREATE proc [dbo].[Sp_HWMS_DailyWeighingRecord_Export]  
	@StrCondition	NVARCHAR(MAX) = NULL,
	@StrSorting		NVARCHAR(MAX) = NULL

AS 

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @qry NVARCHAR(MAX);


SET @qry = 'SELECT [DWRNo], [TotalWeight], [Date], [TotalBags], [TotalNoofBins], HospitalRepresentative, ConsignmentNo  FROM ( 
			SELECT	A.[DWRId], A.[CustomerId], A.[FacilityId], A.[DWRNo], A.[TotalWeight], 
			CONVERT(varchar(10), DAY(A.[Date])) + ''-'' +  UPPER(CONVERT(varchar(3), DATENAME(m, A.[Date]))) + ''-'' + DATENAME(YEAR, A.[Date])  AS [Date],  A.[TotalBags], A.[TotalNoofBins], A.[HospitalRepresentative],
			  B.ConsignmentNoteNo AS ConsignmentNo, A.[Status]
			FROM [HWMS_DailyWeighingRecord] A
			LEFT JOIN HWMS_ConsignmentNoteCWCN B ON A.ConsignmentNo = B.ConsignmentId ) A
			WHERE 1 = 1 ' 
			+ CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' and '+ REPLACE(ISNULL(@strCondition,''),'where',' AND ')  END  
			+ ' ORDER BY ' +  ISNULL(@strSorting,'DWRId DESC')
			
print @qry;
EXECUTE sp_executesql @qry

-- select * from HWMS_DailyWeighingRecord
	
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
