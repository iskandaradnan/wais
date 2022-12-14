USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngContractOutRegister_Save]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================

Application Name	: UETrack-BEMS              

Version				: 1.0

Procedure Name		: uspFM_EngContractOutRegister_Save

Description			: If Penalty already exists then update else insert.

Authors				: Balaji M S

Date				: 05-April-2018

-----------------------------------------------------------------------------------------------------------



Unit Test:

DECLARE @EngContractOutRegisterDet AS [dbo].[udt_EngContractOutRegisterDet]

 insert into  @EngContractOutRegisterDet( ContractDetId, CustomerId, FacilityId, ServiceId, ContractId, AssetId, ContractType, ContractValue) VALUES

('2','1','1','2','2','1','23',50.2)





EXEC [uspFM_EngContractOutRegister_Save] @EngContractOutRegisterDet,

@Renew=1,@pUserId=1,@pContractId='2',@CustomerId=1,@FacilityId=1,@ServiceId=2,@ContractNo='AAA',@ContractorId=1,@ContractStartDate='2018-04-19 19:57:09.383',@ContractEndDate='2018-04-25 19:57:09.383',		

@AResponsiblePerson='',@APersonDesignation='',@AContactNumber='',@AFaxNo='',@ScopeofWork='egrg',@Remarks='doo',@Status=1



DECLARE @EngContractOutRegisterDet AS [dbo].[udt_EngContractOutRegisterDet]

 insert into  @EngContractOutRegisterDet( ContractDetId, CustomerId, FacilityId, ServiceId, ContractId, AssetId, ContractType, ContractValue) VALUES

('','1','1','2','2','1','23',50.2)





EXEC [uspFM_EngContractOutRegister_Save] @EngContractOutRegisterDet,

@Renew=0,@pUserId=1,@pContractId='',@CustomerId=1,@FacilityId=1,@ServiceId=2,@ContractNo='bbb',@ContractorId=1,@ContractStartDate='2018-04-19 19:57:09.383',@ContractEndDate='2018-04-25 19:57:09.383',		

@AResponsiblePerson='',@APersonDesignation='',@AContactNumber='',@AFaxNo='',@ScopeofWork='egrg',@Remarks='doo',@Status=1

-----------------------------------------------------------------------------------------------------------

Version History 

-----:------------:---------------------------------------------------------------------------------------

Init :  Date       : Details

========================================================================================================*/



CREATE PROCEDURE  [dbo].[uspFM_EngContractOutRegister_Save]



			@EngContractOutRegisterDet		AS [dbo].[udt_EngContractOutRegisterDet] READONLY,

			@Renew							BIT,

			@pUserId						INT = null,	

			@pContractId					INT,

			@CustomerId						INT,

			@FacilityId						INT,

			@ServiceId						INT,

			@ContractNo						NVARCHAR(100),

			@ContractorId					INT,

			@ContractStartDate				DATETIME,

			@ContractEndDate				DATETIME,

			@AResponsiblePerson				NVARCHAR(100)		=NULL,

			@APersonDesignation				NVARCHAR(100)		=NULL,

			@AContactNumber					NVARCHAR(30)		=NULL,

			@AFaxNo							NVARCHAR(30)		=NULL,

			@ScopeofWork					NVARCHAR(1000),

			@Remarks						NVARCHAR(1000)		=NULL,

			@Status							INT,

			@pNotificationForInspection		DATETIME			= NULL

			

			







AS                                              



BEGIN TRY



	DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	BEGIN TRANSACTION



-- Paramter Validation 



	SET NOCOUNT ON;

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;



-- Declaration

	DECLARE @DuplicateCount INT,@mContractNo	NVARCHAR(100)

	DECLARE @Table TABLE (ID INT)

	DECLARE @HistoryTable TABLE (ID INT)



	SET @mContractNo = (SELECT ContractNo FROM EngContractOutRegister WHERE ContractId=@pContractId)



			IF EXISTS (SELECT 1 FROM @EngContractOutRegisterDet GROUP BY AssetId HAVING COUNT(*) > 1) --(@DuplicateCount>0)

			BEGIN



			SELECT @pContractId As ContractId,

			CONVERT(varbinary(8), CAST(CONVERT(DATETIME, GETDATE()) AS TIMESTAMP)) AS  [timestamp],

			NEWID() AS Guid,

			'Asset No should be unique' AS ErrorMessage



			END



		ELSE IF((SELECT COUNT(*) FROM EngContractOutRegisterDet A INNER JOIN @EngContractOutRegisterDet B ON A.AssetId = B.AssetId AND A.ContractId = @pContractId

		WHERE B.ContractDetId =0) > 0)

	BEGIN

			SELECT @pContractId As ContractId,

			CONVERT(varbinary(8), CAST(CONVERT(DATETIME, GETDATE()) AS TIMESTAMP)) AS  [timestamp],

			NEWID() AS Guid,

			'Asset No should be unique' AS ErrorMessage

	END

	ELSE IF exists (SELECT 1 FROM EngContractOutRegister A where A.ContractNo = @ContractNo and A.FacilityId = @FacilityId  and (  isnull(@pContractId,0)=0 ))

	BEGIN

			SELECT @pContractId As ContractId,

			CONVERT(varbinary(8), CAST(CONVERT(DATETIME, GETDATE()) AS TIMESTAMP)) AS  [timestamp],

			NEWID() AS Guid,

			'Contract No should be unique' AS ErrorMessage

	END

	

	

-- Default Values





-- Execution

ELSE

BEGIN

	IF(@Renew = 0)

	

BEGIN



    IF(isnull(@pContractId,0)= 0 OR @pContractId='')

	  BEGIN



	          INSERT INTO EngContractOutRegister(

											CustomerId,			

											FacilityId,		

											ServiceId,			

											ContractNo,		

											ContractorId,		

											ContractStartDate,	

											ContractEndDate,	

											AResponsiblePerson,	

											APersonDesignation,	

											AContactNumber,		

											AFaxNo,				

											ScopeofWork,		

											Remarks,			

											Status,				

											CreatedBy,

											CreatedDate,

											CreatedDateUTC,

											ModifiedBy,

											ModifiedDate,

											ModifiedDateUTC,

											IsRenewedPreviously,

											NotificationForInspection

											                                                                                                           

                           )OUTPUT INSERTED.ContractId INTO @Table

			  VALUES						(

											@CustomerId,			

											@FacilityId,		

											@ServiceId,			

											@ContractNo,		

											@ContractorId,		

											@ContractStartDate,	

											@ContractEndDate,	

											@AResponsiblePerson,	

											@APersonDesignation,	

											@AContactNumber,		

											@AFaxNo,				

											@ScopeofWork,		

											@Remarks,			

											@Status,				

											@pUserId,

											GETDATE(), 

											GETUTCDATE(),

											@pUserId,													

											GETDATE(), 

											GETUTCDATE(),

											@Renew,

											@pNotificationForInspection

											)

			Declare @mPrimaryId int= (select DISTINCT TOP 1 ContractId from EngContractOutRegister WHERE	ContractId IN (SELECT ID FROM @Table))











			  INSERT INTO EngContractOutRegisterDet(		

													CustomerId,	

													FacilityId,	

													ServiceId,	

													ContractId,	

													AssetId,

													ContractType,

													ContractValue,

													CreatedBy,

													CreatedDate,

													CreatedDateUTC,

													ModifiedBy,

													ModifiedDate,

													ModifiedDateUTC

                                                    )



				   SELECT							

													CustomerId,	

													FacilityId,	

													ServiceId,	

													@mPrimaryId,

													AssetId,		

													ContractType,	

													ContractValue,

													@pUserId,		

													GETDATE(),

													GETUTCDATE(),

													@pUserId,

													GETDATE(),

													GETUTCDATE()

				   FROM     @EngContractOutRegisterDet		AS ContractOutRegisterDet

				   WHERE	ISNULL(ContractOutRegisterDet.ContractDetId,0)=0 

















			   	  SELECT				ContractId,

										[Timestamp],

										GuId,

										'' as ErrorMessage

				   FROM					EngContractOutRegister

				   WHERE				ContractId IN (SELECT ID FROM @Table)

	

		END

  ELSE

	  BEGIN



				UPDATE EngContractOutRegister SET 



									CustomerId									= @CustomerId,			

									FacilityId									= @FacilityId,			

									ServiceId									= @ServiceId,			

									ContractNo									= @ContractNo,		

									ContractorId								= @ContractorId,		

									ContractStartDate							= @ContractStartDate,	

									ContractEndDate								= @ContractEndDate,	

									AResponsiblePerson							= @AResponsiblePerson,	

									APersonDesignation							= @APersonDesignation,	

									AContactNumber								= @AContactNumber,		

									AFaxNo										= @AFaxNo,				

									ScopeofWork									= @ScopeofWork,		

									Remarks										= @Remarks,			

									Status										= @Status,				

									ModifiedBy									= @pUserId,

									ModifiedDate								= GETDATE(),

									ModifiedDateUTC								= GETUTCDATE(),

									IsRenewedPreviously							= @Renew,

									NotificationForInspection					= @pNotificationForInspection

			   WHERE ContractId =   @pContractId





			    UPDATE ContractOutRegisterDet SET		

									ContractOutRegisterDet.CustomerId			= ContractOutRegisterDetType.CustomerId,

									ContractOutRegisterDet.FacilityId			= ContractOutRegisterDetType.FacilityId,

									ContractOutRegisterDet.ServiceId			= ContractOutRegisterDetType.ServiceId,

									ContractOutRegisterDet.ContractId			= ContractOutRegisterDetType.ContractId,

									ContractOutRegisterDet.AssetId				= ContractOutRegisterDetType.AssetId,

									ContractOutRegisterDet.ContractType			= ContractOutRegisterDetType.ContractType,

									ContractOutRegisterDet.ContractValue		= ContractOutRegisterDetType.ContractValue,						

									ContractOutRegisterDet.ModifiedBy			= @pUserId,

									ContractOutRegisterDet.ModifiedDate			= GETDATE(),

									ContractOutRegisterDet.ModifiedDateUTC		= GETUTCDATE()

					FROM	EngContractOutRegisterDet						AS ContractOutRegisterDet 

							INNER JOIN @EngContractOutRegisterDet			AS ContractOutRegisterDetType ON ContractOutRegisterDet.ContractDetId	=	ContractOutRegisterDetType.ContractDetId

					WHERE ISNULL(ContractOutRegisterDetType.ContractDetId,0)>0



					



				  INSERT INTO EngContractOutRegisterDet(		

													CustomerId,	

													FacilityId,	

													ServiceId,	

													ContractId,	

													AssetId,

													ContractType,

													ContractValue,

													CreatedBy,

													CreatedDate,

													CreatedDateUTC,

													ModifiedBy,

													ModifiedDate,

													ModifiedDateUTC

                                                    )



				   SELECT							

													CustomerId,	

													FacilityId,	

													ServiceId,	

													@pContractId,

													AssetId,		

													ContractType,	

													ContractValue,

													@pUserId,		

													GETDATE(),

													GETUTCDATE(),

													@pUserId,

													GETDATE(),

													GETUTCDATE()

				   FROM     @EngContractOutRegisterDet		AS ContractOutRegisterDet

				   WHERE	ISNULL(ContractOutRegisterDet.ContractDetId,0)=0 





			   	  SELECT				ContractId,

										[Timestamp],

										GuId,

										'' as ErrorMessage

				   FROM					EngContractOutRegister

				   WHERE				ContractId =   @pContractId

        END   

			  	  

END



ELSE



		BEGIN



		UPDATE EngContractOutRegister SET 



									CustomerId									= @CustomerId,			

									FacilityId									= @FacilityId,			

									ServiceId									= @ServiceId,			

									ContractNo									= @ContractNo,		

									ContractorId								= @ContractorId,		

									ContractStartDate							= @ContractStartDate,	

									ContractEndDate								= @ContractEndDate,	

									AResponsiblePerson							= @AResponsiblePerson,	

									APersonDesignation							= @APersonDesignation,	

									AContactNumber								= @AContactNumber,		

									AFaxNo										= @AFaxNo,				

									ScopeofWork									= @ScopeofWork,		

									Remarks										= @Remarks,			

									Status										= @Status,				

									ModifiedBy									= @pUserId,

									ModifiedDate								= GETDATE(),

									ModifiedDateUTC								= GETUTCDATE(),

									IsRenewedPreviously							= @Renew,

									NotificationForInspection					= @pNotificationForInspection

			   WHERE ContractId =   @pContractId





			    UPDATE ContractOutRegisterDet SET		

									ContractOutRegisterDet.CustomerId			= ContractOutRegisterDetType.CustomerId,

									ContractOutRegisterDet.FacilityId			= ContractOutRegisterDetType.FacilityId,

									ContractOutRegisterDet.ServiceId			= ContractOutRegisterDetType.ServiceId,

									ContractOutRegisterDet.ContractId			= ContractOutRegisterDetType.ContractId,

									ContractOutRegisterDet.AssetId				= ContractOutRegisterDetType.AssetId,

									ContractOutRegisterDet.ContractType			= ContractOutRegisterDetType.ContractType,

									ContractOutRegisterDet.ContractValue		= ContractOutRegisterDetType.ContractValue,						

									ContractOutRegisterDet.ModifiedBy			= @pUserId,

									ContractOutRegisterDet.ModifiedDate			= GETDATE(),

									ContractOutRegisterDet.ModifiedDateUTC		= GETUTCDATE()

					FROM	EngContractOutRegisterDet						AS ContractOutRegisterDet 

							INNER JOIN @EngContractOutRegisterDet			AS ContractOutRegisterDetType ON ContractOutRegisterDet.ContractDetId	=	ContractOutRegisterDetType.ContractDetId

					WHERE ISNULL(ContractOutRegisterDetType.ContractDetId,0)>0



					



				  INSERT INTO EngContractOutRegisterDet(		

													CustomerId,	

													FacilityId,	

													ServiceId,	

													ContractId,	

													AssetId,

													ContractType,

													ContractValue,

													CreatedBy,

													CreatedDate,

													CreatedDateUTC,

													ModifiedBy,

													ModifiedDate,

													ModifiedDateUTC

                                                    )



				   SELECT							

													CustomerId,	

													FacilityId,	

													ServiceId,	

													@pContractId,

													AssetId,		

													ContractType,	

													ContractValue,

													@pUserId,		

													GETDATE(),

													GETUTCDATE(),

													@pUserId,

													GETDATE(),

													GETUTCDATE()

				   FROM     @EngContractOutRegisterDet		AS ContractOutRegisterDet

				   WHERE	ISNULL(ContractOutRegisterDet.ContractDetId,0)=0 

			

		INSERT INTO EngContractOutRegisterHistory(ContractId,CustomerId,FacilityId,ContractStartDate,ContractEndDate,CreatedBy,CreatedDate,CreatedDateUTC,ModifiedBy,ModifiedDate,ModifiedDateUTC,ContractNo) OUTPUT INSERTED.ContractHistoryId INTO @HistoryTable



		SELECT A.ContractId,A.CustomerId,A.FacilityId,A.ContractStartDate,A.ContractEndDate,2,GETDATE(),GETUTCDATE(),2,GETDATE(),GETUTCDATE(),@mContractNo

		FROM EngContractOutRegister A 

		INNER JOIN	(

						SELECT DISTINCT Cont.ContractId,CONVERT(DATE,ContractStartDate) AS ContractStartDate,CONVERT(DATE,ContractEndDate) AS ContractEndDate

						FROM EngContractOutRegister AS Cont --INNER JOIN EngContractOutRegisterDet  AS ContDet ON Cont.ContractId	=	ContDet.ContractId

						EXCEPT

						SELECT DISTINCT ContractId,CONVERT(DATE,ContractStartDate) AS ContractStartDate,CONVERT(DATE,ContractEndDate) AS ContractEndDate

						FROM EngContractOutRegisterHistory

					)	B ON A.ContractId = B.ContractId WHERE A.ContractId = @pContractId



		DECLARE @mHistoryId INT

		SET @mHistoryId = (select top 1 ID from @HistoryTable)

		IF EXISTS (SELECT 1 FROM @HistoryTable)



			BEGIN

				INSERT INTO EngContractOutRegisterAssetHistory(ContractHistoryId,ContractId,AssetId,ContractType,ContractValue,CreatedBy,CreatedDate,CreatedDateUTC,ModifiedBy,ModifiedDate,ModifiedDateUTC)



				SELECT ContractHistoryId,Sub.ContractId,Sub.AssetId,Sub.ContractType,Sub.ContractValue,2,GETDATE(),GETUTCDATE(),2,GETDATE(),GETUTCDATE()

				FROM EngContractOutRegister A 

				INNER JOIN	(

								SELECT DISTINCT @mHistoryId as ContractHistoryId,Cont.ContractId,ContDet.AssetId,ContDet.ContractType,ContDet.ContractValue

								FROM EngContractOutRegister AS Cont INNER JOIN EngContractOutRegisterDet  AS ContDet ON Cont.ContractId	=	ContDet.ContractId

								EXCEPT

								SELECT DISTINCT @mHistoryId as ContractHistoryId,ContractId,AssetId,ContractType,ContractValue

								FROM EngContractOutRegisterAssetHistory

							)	Sub ON A.ContractId = Sub.ContractId WHERE A.ContractId = @pContractId



			END

				UPDATE EngContractOutRegister SET 



									ContractStartDate							= @ContractStartDate,	

									ContractEndDate								= @ContractEndDate,	

									ModifiedBy									= @pUserId,

									ModifiedDate								= GETDATE(),

									ModifiedDateUTC								= GETUTCDATE()

			   WHERE ContractId =   @pContractId



			   	  SELECT				ContractId,

										[Timestamp],

										GuId,
										'' as ErrorMessage
				   FROM					EngContractOutRegister

				   WHERE				ContractId =   @pContractId

				   		

		END



		END





	IF @mTRANSCOUNT = 0

        BEGIN

            COMMIT TRANSACTION

        END   





END TRY



BEGIN CATCH



	IF @mTRANSCOUNT = 0

        BEGIN

            ROLLBACK TRAN

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



-------------------------------------------------------------------UDT CREATION----------------------------------------------------------



--DROP TYPE [udt_EngContractOutRegisterDet]



--CREATE TYPE [dbo].[udt_EngContractOutRegisterDet] AS TABLE(

--ContractDetId				INT,

--CustomerId					INT,

--FacilityId					INT,

--ServiceId					INT,

--ContractId					INT,

--AssetId						INT,

--ContractType				INT,

--ContractValue				NUMERIC(24,2)

--)

--GO
GO
