USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngAssetPPMCheckList_GetHistoryById]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngAssetPPMCheckList_GetById
Description			: Get the staff details by passing the staffId.
Authors				: Dhilip V
Date				: 02-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_EngAssetPPMCheckList_GetById  @pPPMCheckListId=1

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_EngAssetPPMCheckList_GetHistoryById]                           
  @pPPMCheckListId		INT
AS                                               

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration


-- Default Values


-- Execution


	IF(ISNULL(@pPPMCheckListId,0) = 0) RETURN





	--	1	EngAssetPPMCheckList
			select Version,EffectiveFromDate,ModifiedBy  from (
			select row_number() over (partition by Version order by Version,EffectiveFromDate desc ) as sno ,Version,EffectiveFromDate,ModifiedBy  from 
			( 
	     SELECT VersionNo Version, A.CreatedDate EffectiveFromDate, B.StaffName ModifiedBy
		 FROM EngAssetPPMCheckListCategoryHistory A
		 INNER JOIN UMUserRegistration B ON A.CreatedBy=B.UserRegistrationId
		 WHERE PPMCheckListId=@pPPMCheckListId
		 GROUP BY VersionNo,A.CreatedDate,B.StaffName
		--ORDER BY  VERSIONNO


		 union all

	     SELECT VersionNo Version, A.CreatedDate EffectiveFromDate, B.StaffName ModifiedBy
		 FROM EngAssetPPMCheckListQuantasksMstDetHistory A
		 INNER JOIN UMUserRegistration B ON A.CreatedBy=B.UserRegistrationId
		 WHERE PPMCheckListId=@pPPMCheckListId
		 GROUP BY VersionNo,A.CreatedDate,B.StaffName)a
		 )b	
		 where sno=1
		 ORDER BY  Version
	

		

		 SELECT VersionNo Version, A.CreatedDate EffectiveFromDate, B.StaffName ModifiedBy
		 FROM EngAssetPPMCheckListCategoryHistory A
		 INNER JOIN UMUserRegistration B ON A.CreatedBy=B.UserRegistrationId
		 WHERE PPMCheckListId=@pPPMCheckListId
		 and 1=2
		 GROUP BY VersionNo,A.CreatedDate,B.StaffName
	




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
