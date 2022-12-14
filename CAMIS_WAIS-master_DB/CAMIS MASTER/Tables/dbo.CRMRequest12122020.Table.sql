USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[CRMRequest12122020]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CRMRequest12122020](
	[CRMRequestId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[ServiceId] [int] NOT NULL,
	[RequestNo] [nvarchar](50) NULL,
	[RequestDateTime] [datetime] NULL,
	[RequestDateTimeUTC] [datetime] NULL,
	[RequestStatus] [int] NULL,
	[RequestDescription] [nvarchar](500) NULL,
	[TypeOfRequest] [int] NOT NULL,
	[Remarks] [nvarchar](500) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
	[IsWorkOrder] [bit] NULL,
	[ModelId] [int] NULL,
	[ManufacturerId] [int] NULL,
	[UserAreaId] [int] NULL,
	[UserLocationId] [int] NULL,
	[StatusValue] [nvarchar](100) NULL,
	[MobileGuid] [nvarchar](max) NULL,
	[TargetDate] [datetime] NULL,
	[RequestedPerson] [int] NULL,
	[AssigneeId] [int] NULL,
	[Requester] [int] NULL,
	[CRMRequest_PriorityId] [int] NULL,
	[Responce_Date] [datetime] NULL,
	[Completed_Date] [datetime] NULL,
	[Completed_By] [int] NULL,
	[Responce_By] [int] NULL,
	[Action_Taken] [nvarchar](max) NULL,
	[Validation] [int] NULL,
	[Justification] [nvarchar](max) NULL,
	[Indicators_all] [nvarchar](max) NULL,
	[NCRDescription] [nvarchar](1000) NULL,
	[AssetId] [int] NULL,
	[AssetNo] [varchar](50) NULL,
	[WorkGroup] [int] NULL,
	[WasteCategory] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
