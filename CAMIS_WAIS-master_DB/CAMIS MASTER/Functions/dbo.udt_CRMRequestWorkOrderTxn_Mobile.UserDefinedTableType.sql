USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_CRMRequestWorkOrderTxn_Mobile]    Script Date: 20-09-2021 16:50:18 ******/
CREATE TYPE [dbo].[udt_CRMRequestWorkOrderTxn_Mobile] AS TABLE(
	[CRMRequestWOId] [int] NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[ServiceId] [int] NULL,
	[CRMWorkOrderNo] [nvarchar](50) NULL,
	[CRMWorkOrderDateTime] [datetime] NULL,
	[Status] [int] NULL,
	[Description] [nvarchar](500) NULL,
	[TypeOfRequest] [int] NULL,
	[CRMRequestId] [int] NULL,
	[AssetId] [int] NULL,
	[ManufacturerId] [int] NULL,
	[ModelId] [int] NULL,
	[AssignedUserId] [int] NULL,
	[Remarks] [nvarchar](500) NULL,
	[UserId] [int] NULL,
	[Timestamp] [varbinary](200) NULL,
	[UserAreaId] [int] NULL,
	[UserLocationId] [int] NULL
)
GO
