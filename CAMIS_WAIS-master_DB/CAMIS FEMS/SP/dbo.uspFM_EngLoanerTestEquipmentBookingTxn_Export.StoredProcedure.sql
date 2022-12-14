USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngLoanerTestEquipmentBookingTxn_Export]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngLoanerTestEquipmentBookingTxn_Export
Description			: To export the asset Booking details
Authors				: Dhilip V
Date				: 11-July-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_EngLoanerTestEquipmentBookingTxn_Export  @StrCondition='',@StrSorting=null

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE [dbo].[uspFM_EngLoanerTestEquipmentBookingTxn_Export]

	@StrCondition	NVARCHAR(MAX) = NULL,
	@StrSorting		NVARCHAR(MAX) = NULL

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


SET @qry = 'SELECT	LoanerTestNo		AS [Loaner /TestEquipmentNo.],
					WorkOrderNo			AS [WorkOrderNo.],
					BookingStartFrom	AS [BookingStartsFrom],
					BookingEnd,
					MovementCategory,
					ToFacility,
					ToBlock,
					ToLevel,
					ToUserArea,
					ToUserLocation,
					RequestorName,
					Position as Designation,
					RequestType,
					TypeDescription,
					TypeCode,
					Model,
					Manufacturer,
					BookingStatusValue	AS [BookingStatus]
			FROM [V_EngLoanerTestEquipmentBookingTxn_Export]
			WHERE 1 = 1 ' 
			+ '  ' + CASE WHEN ISNULL(@strCondition,'' ) = '' THEN '' ELSE ' and '+ REPLACE(ISNULL(@strCondition,''),'where',' AND ')  END  
			+ ' ' + ' ORDER BY ' +  ISNULL(@strSorting,'[V_EngLoanerTestEquipmentBookingTxn_Export].ModifiedDateUTC DESC')

print @qry;
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
