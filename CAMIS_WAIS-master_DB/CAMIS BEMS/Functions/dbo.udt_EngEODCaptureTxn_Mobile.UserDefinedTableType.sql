USE [UetrackBemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_EngEODCaptureTxn_Mobile]    Script Date: 20-09-2021 17:09:19 ******/
CREATE TYPE [dbo].[udt_EngEODCaptureTxn_Mobile] AS TABLE(
	[CaptureId] [int] NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[ServiceId] [int] NULL,
	[RecordDate] [datetime] NULL,
	[AssetClassificationId] [int] NULL,
	[AssetTypeCodeId] [int] NULL,
	[CaptureStatusLovId] [int] NULL,
	[AssetId] [int] NULL,
	[UserAreaId] [int] NULL,
	[UserLocationId] [int] NULL,
	[UserId] [int] NULL,
	[NextCaptureDate] [datetime] NULL,
	[MobileGuid] [nvarchar](max) NULL
)
GO
