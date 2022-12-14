USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngEODCaptureTxn_Mobile_Save]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngEODCaptureTxn_Save
Description			: QAPIndicator Insert/update
Authors				: Dhilip V
Date				: 02-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
DECLARE @EngEODCaptureTxn			[dbo].[udt_EngEODCaptureTxn_Mobile]
DECLARE @EngEODCaptureTxnDet		[dbo].[udt_EngEODCaptureTxnDet_Mobile]

INSERT INTO @EngEODCaptureTxn(CaptureId,CustomerId,FacilityId,ServiceId,RecordDate,AssetClassificationId,AssetTypeCodeId,CaptureStatusLovId,
AssetId,UserAreaId,UserLocationId,UserId,NextCaptureDate,MobileGuid)VALUES
(0,1,1,2,GETDATE(),1,1,0,137,101,51,2,GETDATE()+10,'DE214705-B419-4E65-89C7-550C3D24C6C7'),
(0,1,1,2,GETDATE(),1,1,0,137,101,51,2,GETDATE()+10,'DE214705-B419-4E65-89C7-550C3D24C6C9')
INSERT INTO @EngEODCaptureTxnDet (CaptureDetId,CustomerId,FacilityId,ServiceId,ParameterMappingDetId,ParamterValue,Standard,Minimum,Maximum,ActualValue,Status,UOMId,UserId,MobileGuid) 
VALUES 
(0,1,1,2,126,'zzz','aaa',20,40,100,1,11,2,'DE214705-B419-4E65-89C7-550C3D24C6C7'),
(0,1,1,2,126,'zzz','aaa',20,40,100,1,11,2,'DE214705-B419-4E65-89C7-550C3D24C6C9')
EXEC [uspFM_EngEODCaptureTxn_Mobile_Save] @EngEODCaptureTxn,@EngEODCaptureTxnDet

SELECT * FROM EngEODCaptureTxn
SELECT * FROM EngEODCaptureTxnDet
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_EngEODCaptureTxn_Mobile_Save]
	@EngEODCaptureTxn			[dbo].[udt_EngEODCaptureTxn_Mobile]	READONLY,
	@EngEODCaptureTxnDet		[dbo].[udt_EngEODCaptureTxnDet_Mobile]	READONLY
				
AS                                              

BEGIN TRY

	DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	
	DECLARE @Table TABLE (ID INT)
	DECLARE	@PrimaryKeyId	 INT
	DECLARE	@TotalRecords INT
	DECLARE	@pTotalPage		NUMERIC(24,2)
	DECLARE @mLoopStart INT =1,@mLoopLimit INT
	DECLARE @pOutParam NVARCHAR(50) 
	DECLARE @pCaptureDocumentNo NVARCHAR(100)
	
	DECLARE @mMonth INT,@mYear INT
	DECLARE @pRecordDate DATETIME, @mDefaultkey NVARCHAR(100)

	DECLARE @pCustomerId INT
	DECLARE @pFacilityId INT

	SET @pRecordDate = (SELECT [dbo].[udf_GetMalaysiaDateTime] (GETDATE())) --(SELECT RecordDate FROM @EngEODCaptureTxn)

	DECLARE	@pRecordDateUTC DATETIME

	SELECT * INTO #TEMPResultWo FROM @EngEODCaptureTxn where CaptureId =0 or CaptureId is null or CaptureId =''
	--SELECT * FROM #TEMPResultWo
	ALTER TABLE #TEMPResultWo ADD CaptureDocumentNo NVARCHAR(100)
	ALTER TABLE #TEMPResultWo ADD SWOid INT IDENTITY(1,1) NOT NULL

	SELECT @mLoopLimit	=	COUNT(1) FROM #TEMPResultWo
	WHILE (@mLoopStart<=@mLoopLimit)
	BEGIN
	SET @pCustomerId = (SELECT CustomerId FROM #TEMPResultWo WHERE SWOid=@mLoopStart )
	SET @pFacilityId = (SELECT FacilityId FROM #TEMPResultWo WHERE SWOid=@mLoopStart)
	SET @mMonth	=	(SELECT MONTH(RecordDate) FROM #TEMPResultWo WHERE SWOid=@mLoopStart)
	SET @mYear	=	(SELECT YEAR(RecordDate) FROM #TEMPResultWo WHERE SWOid=@mLoopStart)


-- Default Values

	--SET @pRecordDateUTC			= DATEADD(hh, DATEDIFF(hh, GETDATE(), GETUTCDATE()), @pRecordDate)

-- Execution



	 EXEC [uspFM_GenerateDocumentNumber] @pFlag='EngEODCaptureTxn',@pCustomerId=@pCustomerId,@pFacilityId=@pFacilityId,@Defaultkey='ER',@pModuleName='BEMS',@pService=NULL,@pMonth=@mMonth,@pYear=@mYear,@pOutParam=@pOutParam output
	 SELECT @pCaptureDocumentNo=@pOutParam
	 
	 UPDATE #TEMPResultWo SET CaptureDocumentNo	= @pCaptureDocumentNo WHERE SWOid	=	@mLoopStart
	 SET @mLoopStart	=	@mLoopStart+1

	 END



	 IF(1=1)
	 BEGIN
	          INSERT INTO EngEODCaptureTxn (	CustomerId,
												FacilityId,
												ServiceId,
												CaptureDocumentNo,
												RecordDate,
												RecordDateUTC,
												AssetClassificationId,
												--CategorySystemDetId,
												AssetTypeCodeId,
												CaptureStatusLovId,
												AssetId,
												UserAreaId,
												UserLocationId,
												CreatedBy,
												CreatedDate,
												CreatedDateUTC,
												ModifiedBy,
												ModifiedDate,
												ModifiedDateUTC,
												NextCaptureDate,
												MobileGuid						                                                                                                           
											)OUTPUT INSERTED.CaptureId INTO @Table
			  SELECT							CustomerId,
												FacilityId,
												ServiceId,
												CaptureDocumentNo,
												RecordDate,
												DATEADD(hh, DATEDIFF(hh, GETDATE(), GETUTCDATE()),RecordDate),
												AssetClassificationId,
												--@pCategorySystemDetId,
												AssetTypeCodeId,
												CaptureStatusLovId,
												AssetId,
												UserAreaId,
												UserLocationId,
												UserId,
												GETDATE(),
												GETUTCDATE(),
												UserId,
												GETDATE(),
												GETUTCDATE(),
												NextCaptureDate,
												MobileGuid				
					FROM #TEMPResultWo WHERE CaptureId =0


			DECLARE @mPrimaryId INT;
			SELECT @mPrimaryId	=	CaptureId from EngEODCaptureTxn WHERE	CaptureId IN (SELECT ID FROM @Table)

	        INSERT INTO EngEODCaptureTxnDet(	CaptureId,
												CustomerId,
												FacilityId,
												ServiceId,
												--AssetTypeCodeId,
												ParameterMappingDetId,
												ParamterValue,
												Standard,
												Minimum,
												Maximum,
												ActualValue,
												Status,
												CreatedBy,
												CreatedDate,
												CreatedDateUTC,
												ModifiedBy,
												ModifiedDate,
												ModifiedDateUTC,
												UOMId,
												MobileGuid							                                                                                                           
											)
									SELECT	B.CaptureId,
											A.CustomerId,
											A.FacilityId,
											A.ServiceId,
											--AssetTypeCodeId,
											A.ParameterMappingDetId,
											A.ParamterValue,
											A.Standard,
											A.Minimum,
											A.Maximum,
											A.ActualValue,
											A.Status,
											A.UserId,
											GETDATE(),
											GETUTCDATE(),
											A.UserId,
											GETDATE(),
											GETUTCDATE(),
											A.UOMId,
											A.MobileGuid
									FROM	@EngEODCaptureTxnDet  A INNER JOIN EngEODCaptureTxn B ON A.MobileGuid = B.MobileGuid
									WHERE	ISNULL(A.CaptureDetId,0)= 0



			   	   SELECT				CaptureId,
										[Timestamp],
										'' as ErrorMessage,
										CaptureDocumentNo,
										GuId
				   FROM					EngEODCaptureTxn
				   WHERE				CaptureId IN (SELECT ID FROM @Table)
	


	declare @TableNotification1 table (id int, userid int)

						INSERT INTO	FENotification (	UserId,
										NotificationAlerts,
										Remarks,
										CreatedBy,
										CreatedDate,
										CreatedDateUTC,
										ModifiedBy,
										ModifiedDate,
										ModifiedDateUTC,
										ScreenName,
										DocumentId,
										SingleRecord
									) OUTPUT INSERTED.NotificationId , INSERTED.UserId INTO @TableNotification1
						SELECT
								UserId,
								'New Capture Due Date for ' + isnull(AssetNo,'')+ ' is ' + REPLACE(CONVERT(VARCHAR, NextCaptureDate, 6),' ','-') ,
								'ER Capture' AS Remarks,
								a.UserId,
								GETDATE(),
								GETUTCDATE(),
								UserId,
								GETDATE(),
								GETUTCDATE(),
								'ERCapture',
								MobileGuid,
								1
						FROM #TEMPResultWo a left join EngAsset  b on a.AssetId=b.assetid WHERE CaptureId =0


									INSERT INTO QueueWebtoMobile	(		TableName,
												Tableprimaryid,
												UserId
										)
						SELECT	'FENotification',
								ID,
								userid
						FROM @TableNotification1

						declare @WebNotification1 table (id int)
						
								  INSERT INTO WebNotification (	CustomerId,
											FacilityId,
											UserId,
											NotificationAlerts,
											Remarks,
											HyperLink,
											IsNew,
											CreatedBy,
											CreatedDate,
											CreatedDateUTC,
											ModifiedBy,
											ModifiedDate,
											ModifiedDateUTC	,
											NotificationDateTime,
											IsNavigate							                                                                                                           
										)OUTPUT INSERTED.NotificationId INTO @WebNotification1
								SELECT
								A.CustomerId,
								A.FacilityId,
								UserId,
								'New Capture Due Date for ' + isnull(AssetNo,'')+ ' is ' + REPLACE(CONVERT(VARCHAR, NextCaptureDate, 6),' ','-') ,
								'ER Capture' AS Remarks,
								'/bems/eodcapture?id='+CAST((select top 1 id from @Table  ) AS NVARCHAR(100)), 
								1,
								a.UserId,
								GETDATE(),
								GETUTCDATE(),
								UserId,
								GETDATE(),
								GETUTCDATE(),
								GETDATE(),
								0
						FROM #TEMPResultWo a left join EngAsset  b on a.AssetId=b.assetid WHERE CaptureId =0



SELECT	NotificationDeliveryId,
			NotificationTemplateId,
			UserRoleId,
			UserRegistrationId,
			FacilityId
	INTO	#Notification
	FROM	NotificationDeliveryDet
	WHERE	NotificationTemplateId = 23

	
		
	SELECT	distinct A.UserRegistrationId,
			b.FacilityId,
			b.CustomerId		
		INTO	#TempUserEmails_all
	FROM	UMUserRegistration AS A	
			INNER JOIN UMUserLocationMstDet AS B ON A.UserRegistrationId = B.UserRegistrationId
	WHERE	B.UserRoleId	IN (SELECT DISTINCT UserRoleId FROM #Notification)
	AND B.FacilityId	= @pFacilityId
	--IN (SELECT DISTINCT FacilityId FROM #Notification)
	
		
					INSERT INTO WebNotification (	CustomerId,
											FacilityId,
											UserId,
											NotificationAlerts,
											Remarks,
											HyperLink,
											IsNew,
											CreatedBy,
											CreatedDate,
											CreatedDateUTC,
											ModifiedBy,
											ModifiedDate,
											ModifiedDateUTC	,
											NotificationDateTime,
											IsNavigate							                                                                                                           
										)

										select  	b.CustomerId,
													b.FacilityId,
													a.UserRegistrationId,
													b.NotificationAlerts,
													b.Remarks,
													b.HyperLink,
													b.IsNew,
													b.CreatedBy,
													b.CreatedDate,
													b.CreatedDateUTC,
													b.ModifiedBy,
													b.ModifiedDate,
													b.ModifiedDateUTC	,
													b.NotificationDateTime,
													b.IsNavigate		
										from #TempUserEmails_all a  cross join   WebNotification  b
										where b.NotificationId  in (select top 1 id  from @WebNotification1 ) 
										


				declare @TableNotificationdet1 table (id int,userid int)

					INSERT INTO FENotification ( UserId,
							  NotificationAlerts,
							  Remarks,
							  CreatedBy,
							  CreatedDate,
							  CreatedDateUTC,
							  ModifiedBy,
							  ModifiedDate,
							  ModifiedDateUTC,
							  ScreenName,
							  DocumentId,
							  SingleRecord
							 ) OUTPUT INSERTED.NotificationId,INSERTED.UserId INTO @TableNotificationdet1
						  SELECT  
						  a.UserRegistrationId,
						  NotificationAlerts,
						  Remarks,
						  CreatedBy,
						  CreatedDate,
						  CreatedDateUTC,
						  ModifiedBy,
						  ModifiedDate,
						  ModifiedDateUTC,
						  ScreenName,
						  DocumentId,
						  SingleRecord
						from #TempUserEmails_all a  cross join   FENotification  b
										where b.NotificationId  in (select top 1 id  from @TableNotification1 ) 
					 
					 
					 
					  INSERT INTO QueueWebtoMobile (  TableName,
								Tableprimaryid,
								UserId
							  )
						  SELECT 'FENotification',
							ID,
							UserId
						  FROM @TableNotificationdet1

							





		END
  ELSE
	  BEGIN



				UPDATE A SET				A.CustomerId				=	B.CustomerId,
											A.FacilityId				=	B.FacilityId,
											A.ServiceId					=	B.ServiceId,
											--CaptureDocumentNo			=	CaptureDocumentNo,
											A.RecordDate				=	B.RecordDate,
											A.RecordDateUTC				=	DATEADD(hh, DATEDIFF(hh, GETDATE(), GETUTCDATE()),B.RecordDate),
											A.AssetClassificationId		=	B.AssetClassificationId,
											--CategorySystemDetId		=	B.CategorySystemDetId,
											A.AssetTypeCodeId			=	B.AssetTypeCodeId,
											A.CaptureStatusLovId		=	B.CaptureStatusLovId,
											A.AssetId					=	B.AssetId,
											A.UserAreaId				=	B.UserAreaId,
											A.UserLocationId			=	B.UserLocationId,
											A.ModifiedBy				=	B.UserId,
											A.ModifiedDate				=	GETDATE(),
											A.ModifiedDateUTC			=	GETUTCDATE(),
											A.NextCaptureDate			=	B.NextCaptureDate
											OUTPUT INSERTED.CaptureId INTO @Table
				FROM  EngEODCaptureTxn A INNER JOIN @EngEODCaptureTxn B ON A.CaptureId = B.CaptureId
				WHERE	ISNULL(B.CaptureId,0)> 0

				UPDATE EODCaptureDet SET	EODCaptureDet.CustomerId				= udtEODCaptureDet.CustomerId,
											EODCaptureDet.FacilityId				= udtEODCaptureDet.FacilityId,
											EODCaptureDet.ServiceId					= udtEODCaptureDet.ServiceId,

											--EODCaptureDet.AssetTypeCodeId			= udtEODCaptureDet.AssetTypeCodeId,
											EODCaptureDet.ParameterMappingDetId		= udtEODCaptureDet.ParameterMappingDetId,
											EODCaptureDet.ParamterValue				= udtEODCaptureDet.ParamterValue,
											EODCaptureDet.Standard					= udtEODCaptureDet.Standard,
											EODCaptureDet.Minimum					= udtEODCaptureDet.Minimum,
											EODCaptureDet.Maximum					= udtEODCaptureDet.Maximum,
											EODCaptureDet.ActualValue				= udtEODCaptureDet.ActualValue,
											EODCaptureDet.Status					= udtEODCaptureDet.Status,
											EODCaptureDet.ModifiedBy				= UserId,
											EODCaptureDet.ModifiedDate				= GETDATE(),
											EODCaptureDet.ModifiedDateUTC			= GETUTCDATE(),
											EODCaptureDet.UOMId						= udtEODCaptureDet.UOMId
				FROM	EngEODCaptureTxnDet				AS	EODCaptureDet
						INNER JOIN @EngEODCaptureTxnDet	AS	udtEODCaptureDet	ON	EODCaptureDet.CaptureDetId	=	udtEODCaptureDet.CaptureDetId
				WHERE	ISNULL(udtEODCaptureDet.CaptureDetId,0)> 0

			   	SELECT	CaptureId,
						[Timestamp],
						'' ErrorMessage,
						CaptureDocumentNo,
						GuId
				FROM	EngEODCaptureTxn
				WHERE	CaptureId IN (SELECT CaptureId FROM @EngEODCaptureTxn WHERE ISNULL(CaptureId,0) >0)


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


---------------------------------------------------------------------------------UDT Creation-------------------------------------------------------------------------------------


--drop proc uspFM_EngEODCaptureTxn_Mobile_Save
--drop type udt_EngEODCaptureTxn_Mobile
--drop type udt_EngEODCaptureTxnDet_Mobile


--CREATE TYPE [dbo].[udt_EngEODCaptureTxn_Mobile] AS TABLE(
--	CaptureId						INT,
--	CustomerId						INT,
--	FacilityId						INT,
--	ServiceId						INT,
--	RecordDate						DATETIME,
--	AssetClassificationId			INT						NULL,
--	AssetTypeCodeId					INT,
--	CaptureStatusLovId				INT						NULL,
--	AssetId							INT,
--	UserAreaId						INT						NULL,
--	UserLocationId					INT						NULL,
--	UserId							INT,
--	NextCaptureDate					DATETIME 				NULL,
--	MobileGuid						NVARCHAR(MAX)
--)
--GO

--CREATE TYPE [dbo].[udt_EngEODCaptureTxnDet_Mobile] AS TABLE(
--	[CaptureDetId] [int] NULL,
--	[CustomerId] [int] NULL,
--	[FacilityId] [int] NULL,
--	[ServiceId] [int] NULL,
--	[ParameterMappingDetId] [int] NULL,
--	[ParamterValue] [nvarchar](150) NULL,
--	[Standard] [nvarchar](250) NULL,
--	[Minimum] [numeric](24, 2) NULL,
--	[Maximum] [numeric](24, 2) NULL,
--	[ActualValue] [nvarchar](250) NULL,
--	[Status] [int] NULL,
--	[UOMId] [int] NULL,
--	[UserId] [int] NULL,
--	MobileGuid						NVARCHAR(MAX)
--)
--GO
GO
