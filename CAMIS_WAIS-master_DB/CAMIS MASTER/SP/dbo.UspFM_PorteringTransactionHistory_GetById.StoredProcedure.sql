USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_PorteringTransactionHistory_GetById]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: UspFM_EngMwoPartReplacementTxn_GetById
Description			: To Get the data from table EngMaintenanceWorkOrderTxn using the Primary Key id
Authors				: Balaji M S
Date				: 30-Mar-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [UspFM_PorteringTransactionHistory_GetById] @pPorteringId=40,@pPageIndex=1,@pPageSize=10

SELECT * FROM PorteringTransactionHistory
SELECT * FROM EngStockUpdateRegisterTxnDet
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[UspFM_PorteringTransactionHistory_GetById]                           
 -- @pUserId			INT	=	NULL,
  @pPorteringId		INT ,
  @pPageIndex		INT,
  @pPageSize		INT	

AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @TotalRecords INT
	DECLARE	@pTotalPage		NUMERIC(24,2)

	IF(ISNULL(@pPorteringId,0) = 0) RETURN

	SELECT	@TotalRecords	=	COUNT(*)
	FROM	PorteringTransactionHistory							AS PorteringTransaction
			INNER JOIN	FMLovMst								AS WorkFlowStatusId					WITH(NOLOCK)			on PorteringTransaction.WorkFlowStatusId			= WorkFlowStatusId.LovId
			INNER JOIN  UMUserRegistration						AS WFDoneBy							WITH(NOLOCK)			on PorteringTransaction.WFDoneBy					= WFDoneBy.UserRegistrationId
			left JOIN	FMLovMst								AS PorteringStatusLovId				WITH(NOLOCK)			on PorteringTransaction.PorteringStatusLovId		= PorteringStatusLovId.LovId
			left JOIN  UMUserRegistration						AS PorteringStatusDoneBy			WITH(NOLOCK)			on PorteringTransaction.PorteringStatusDoneBy		= PorteringStatusDoneBy.UserRegistrationId
	WHERE	PorteringTransaction.PorteringId = @pPorteringId 

	SET @pTotalPage = CAST(@TotalRecords AS NUMERIC(24,2))/CAST(@pPageSize AS NUMERIC(24,2))

	SET @pTotalPage = CEILING(@pTotalPage)

	

	SELECT	Portering.PorteringDetId			   AS PorteringDetId,
			Portering.PorteringId					AS PorteringId,
			Portering.WorkFlowStatusId				AS WorkFlowStatusId,
			WorkFlowStatusId.FieldValue				AS WorkFlowStatusIdValue,
			Portering.WFDoneBy						AS WFDoneBy,
			WFDoneBy.StaffName						AS WFDoneByValue,
			Portering.WFDoneByDate					AS WFDoneByDate,
			Portering.PorteringStatusLovId			AS PorteringStatusLovId,
			PorteringStatusLovId.FieldValue			AS PorteringStatusLovIdValue,
			Portering.PorteringStatusDoneBy			AS PorteringStatusDoneBy,
			PorteringStatusDoneBy.StaffName			AS PorteringStatusDoneByValue,
			Portering.PorteringStatusDoneByDate		AS PorteringStatusDoneByDate,
			Portering.IsMoment						AS IsMoment,
			Portering.Remarks						AS Remarks,
			Portering.ModifiedBy,
			Portering.ModifiedDate					AS LastUpdatedDate,
			@TotalRecords										AS TotalRecords,
			@pTotalPage											AS TotalPageCalc
	FROM	PorteringTransactionHistory							AS Portering
			INNER JOIN	FMLovMst								AS WorkFlowStatusId					WITH(NOLOCK)			on Portering.WorkFlowStatusId			= WorkFlowStatusId.LovId
			INNER JOIN  UMUserRegistration						AS WFDoneBy							WITH(NOLOCK)			on Portering.WFDoneBy					= WFDoneBy.UserRegistrationId
			left JOIN	FMLovMst								AS PorteringStatusLovId				WITH(NOLOCK)			on Portering.PorteringStatusLovId		= PorteringStatusLovId.LovId
			left JOIN  UMUserRegistration						AS PorteringStatusDoneBy			WITH(NOLOCK)			on Portering.PorteringStatusDoneBy		= PorteringStatusDoneBy.UserRegistrationId
			left JOIN  UMUserRegistration						AS PorteringlastUpdateBy			WITH(NOLOCK)			on Portering.ModifiedBy					= PorteringlastUpdateBy.UserRegistrationId
	WHERE	Portering.PorteringId = @pPorteringId 
	ORDER BY (Portering.PorteringDetId) desc
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
