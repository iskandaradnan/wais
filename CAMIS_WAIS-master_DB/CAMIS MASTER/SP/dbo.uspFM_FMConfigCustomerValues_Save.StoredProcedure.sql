USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_FMConfigCustomerValues_Save]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_FMConfigCustomerValues_Save
Description			: Get the staff details by passing the staffId.
Authors				: Dhilip V
Date				: 30-June-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:

DECLARE @pConfigCustomerValues  udt_FMConfigCustomerValues
INSERT INTO @pConfigCustomerValues (ConfigValueId,CustomerId,ConfigKeyId,ConfigKeyLovId,UserId)
VALUES (0,1,1,292,1)
EXEC uspFM_FMConfigCustomerValues_Save @pConfigCustomerValues=@pConfigCustomerValues

SELECT * FROM FMConfigKeys
SELECT * FROM FMConfigCustomerValues
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/


CREATE PROCEDURE [dbo].[uspFM_FMConfigCustomerValues_Save]

	@pConfigCustomerValues  udt_FMConfigCustomerValues READONLY
	--@pTimestamp			VARBINARY(100)	=	NULL
		
AS 


BEGIN
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRY

	DECLARE @FMConfigKeysTable TABLE (ID INT)
	DECLARE @FMConfigCustomerValuesTable TABLE (ID INT)
	DECLARE @FMConfigCustomerValuesTableUpdate TABLE (ID INT)

	IF EXISTS (SELECT * FROM @pConfigCustomerValues WHERE ISNULL(ConfigValueId,0)=0)

	BEGIN

		INSERT INTO FMConfigCustomerValues (	CustomerId,
												ConfigKeyId,
												KeyName,
												ConfigKeyLovId,
												CreatedBy,
												CreatedDate,
												CreatedDateUTC,
												ModifiedBy,
												ModifiedDate,
												ModifiedDateUTC
											
											)
										OUTPUT INSERTED.ConfigValueId INTO @FMConfigCustomerValuesTable
		SELECT	udt_Config.CustomerId,
				udt_Config.ConfigKeyId,
				Keys.KeyName,
				udt_Config.ConfigKeyLovId,
				udt_Config.UserId,
				GETDATE(),
				GETUTCDATE(),
				udt_Config.UserId,
				GETDATE(),
				GETUTCDATE()			
		FROM	@pConfigCustomerValues AS udt_Config 
				LEFT JOIN FMConfigCustomerValues AS Config ON udt_Config.ConfigValueId	= Config.ConfigValueId
				LEFT JOIN FMConfigKeys AS Keys ON udt_Config.ConfigKeyId	= Keys.ConfigKeyId
		WHERE	ISNULL(udt_Config.ConfigValueId,0)=0 AND Config.ConfigValueId IS NULL

				SELECT	ConfigValueId,
						CustomerId,						ConfigKeyId,
						ConfigKeyLovId

				FROM	FMConfigCustomerValues
				WHERE	ConfigValueId in (SELECT ID FROM @FMConfigCustomerValuesTable)

			END
		ELSE
			BEGIN

					UPDATE Config SET	Config.ConfigKeyLovId	=	udt_Config.ConfigKeyLovId,	
										ModifiedBy		=	udt_Config.UserId,
										ModifiedDate	=	GETDATE(),
										ModifiedDateUTC	=	GETUTCDATE()
									OUTPUT INSERTED.ConfigValueId INTO @FMConfigCustomerValuesTableUpdate
					FROM	@pConfigCustomerValues AS udt_Config 
							INNER JOIN FMConfigCustomerValues AS Config ON udt_Config.ConfigValueId	= Config.ConfigValueId
					WHERE	ISNULL(udt_Config.ConfigValueId,0)>0

				SELECT	ConfigValueId,
						CustomerId,
						ConfigKeyId,
						ConfigKeyLovId
				FROM	FMConfigCustomerValues
				WHERE	ConfigValueId in (SELECT ID FROM @FMConfigCustomerValuesTableUpdate)

		END

END TRY
BEGIN CATCH

INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());

THROW;

END CATCH
SET NOCOUNT OFF
END
GO
