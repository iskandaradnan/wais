USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngContractOutRegister_Export]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspFM_EngContractOutRegister_Export]



	@StrCondition	NVARCHAR(MAX)		=	NULL,

	@StrSorting		NVARCHAR(MAX)		=	NULL



AS 



BEGIN TRY



-- Paramter Validation 



	SET NOCOUNT ON; 

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;





-- Declaration

	DECLARE @countQry	NVARCHAR(MAX);

	DECLARE @qry		NVARCHAR(MAX);

	DECLARE @condition	VARCHAR(MAX);

	DECLARE @TotalRecords INT;



-- Default Values





-- Execution



SET @qry = ' 

			SELECT 	ContractNo AS [Contract No.],

					ContractorCode,

					ContractorName,

					--ContactNo,
					FORMAT(ContractStartDate,''dd-MMM-yyyy'')	AS [ContractStartDate],
					
					FORMAT(ContractEndDate,''dd-MMM-yyyy'')	AS [ContractEndDate],
					

					StatusVal AS [Status],
					FORMAT(NotificationForInspection,''dd-MMM-yyyy'')	AS [NotificationForInspection],
					

					ScopeofWork AS [Scope Of Work],

					AssetNo  AS [Asset No.],

					AssetTypeDescription AS [Asset Type Code Description],

					ContractType,

					ContractValue AS [ContractValue (RM)]

			FROM	[V_EngContractOutRegister_Export]

			WHERE 1 = 1 ' 

			+ '  ' + CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' and '+ REPLACE(ISNULL(@strCondition,''),'where',' AND ')  END  

			+ ' ' + ' ORDER BY ' +  ISNULL(@strSorting,'[V_EngContractOutRegister_Export].ModifiedDateUTC DESC')



PRINT @qry;	



EXECUTE sp_executesql @qry, N' @TotalRecords INT', @TotalRecords = @TotalRecords

	

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
