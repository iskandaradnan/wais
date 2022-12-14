USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Get_MasterServices_byBlockId]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Get_MasterServices_byBlockId]
(
	@MasterBlockID INT
)
	
AS 

-- Exec [GetUserRoleLovs] 

--/*=====================================================================================================================
--APPLICATION		: UETrack
--NAME				: GetUserRoleLovs
--DESCRIPTION		: GET LOV VALUES FOR USERROLE 
--AUTHORS			: BIJU NB
--DATE				: 12-March-2018
-------------------------------------------------------------------------------------------------------------------------
--VERSION HISTORY 
--------------------:---------------:---------------------------------------------------------------------------------------
--Init				: Date          : Details
--------------------:---------------:---------------------------------------------------------------------------------------
--BIJU NB           : 15-March-2018 : 
-------:------------:----------------------------------------------------------------------------------------------------*/
BEGIN
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRY
	
	--Gets service coloums of the Selected Block
	SELECT BlockId LovId, BlockName FieldValue, 0  IsDefault,MstServices_Mapping_block.BEMS,MstServices_Mapping_block.FEMS,MstServices_Mapping_block.FEMS,FacilityId
FROM MstLocationBlock
LEFT JOIN MstServices_Mapping_block
ON MstLocationBlock.BlockId = MstServices_Mapping_block.Master_Block_ID WHERE MstLocationBlock.BlockId = @MasterBlockID ORDER BY MstLocationBlock.BlockName 
	
END TRY
BEGIN CATCH

INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());

THROW

END CATCH
SET NOCOUNT OFF
END
GO
