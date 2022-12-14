USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_VmVariationTxn_MonthClosing_Save]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_VmVariationTxn_MonthClosing_Save
Description			: Get the variation details for Month Closing
Authors				: Dhilip V
Date				: 16-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_VmVariationTxn_MonthClosing_Save  @pFacilityId=1,@pYear=2018,@pMonth=4

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_VmVariationTxn_MonthClosing_Save] 

		@pFacilityId		INT,                          
		@pYear				INT,
		@pMonth				INT

AS                                               

BEGIN TRY

	DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	
-- Default Values
	
-- Execution
	

		UPDATE Variation SET	
								--Variation.ClosingMonth	=	CAST(MONTH(GETDATE()) AS INT),
								--Variation.ClosingYear	=	CAST(YEAR(GETDATE()) AS INT),
								--VariationRaisedDate		=	CAST(DATEFROMPARTS(YEAR(GETDATE()) ,MONTH(GETDATE()),  CAST(01 AS INT)) AS DATETIME),
								Variation.IsMonthClosed	= 1
 		FROM	VmVariationTxn								AS	Variation			WITH(NOLOCK)	
				INNER JOIN MstCustomer						AS	Customer			WITH(NOLOCK)	ON Variation.CustomerId			=	Customer.CustomerId
				INNER JOIN MstLocationFacility				AS	Facility			WITH(NOLOCK)	ON Variation.FacilityId			=	Facility.FacilityId
				INNER JOIN EngAsset							AS	Asset				WITH(NOLOCK)	ON Variation.AssetId			=	Asset.AssetId
				INNER JOIN  FMLovMst						AS	LovVariationStatus	WITH(NOLOCK)	ON Variation.VariationStatus	=	LovVariationStatus.LovId
				INNER JOIN  EngTestingandCommissioningTxn	AS	TandC				WITH(NOLOCK)	ON Variation.AssetId			=	TandC.AssetId
		WHERE	YEAR(Variation.VariationRaisedDate)				=	@pYear 
				AND	 MONTH(Variation.VariationRaisedDate)		=	@pMonth
				AND Variation.FacilityId						=	@pFacilityId
				AND Variation.AuthorizedStatus					=	1

	IF @mTRANSCOUNT = 0
        BEGIN
            COMMIT
        END

END TRY

BEGIN CATCH

	IF @mTRANSCOUNT = 0
        BEGIN
            ROLLBACK
        END

	INSERT INTO ErrorLog(
				Spname,
				ErrorMessage,
				createddate)
	VALUES(		OBJECT_NAME(@@PROCID),
				'Error_line: '+CONVERT(VARCHAR(10),	error_line())+' - '+error_message(),
				getdate()
		   );
		   THROW;

END CATCH
GO
