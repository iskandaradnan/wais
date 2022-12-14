USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[FieldBreakDownRequest]    Script Date: 20-09-2021 16:53:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FieldBreakDownRequest](
	[BreakDownRequestId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[UserRegistrationId] [int] NOT NULL,
	[UserId] [int] NOT NULL,
	[AssetId] [int] NOT NULL,
	[BreakDownType] [int] NULL,
	[BreakDownDetails] [nvarchar](500) NULL,
	[ImageDocumentId1] [int] NULL,
	[ImageDocumentId2] [int] NULL,
	[ImageDocumentId3] [int] NULL,
	[ImageDocumentId4] [int] NULL,
	[VideoDocumentId1] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_FieldBreakDownRequest] PRIMARY KEY CLUSTERED 
(
	[BreakDownRequestId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FieldBreakDownRequest] ADD  CONSTRAINT [DF_FieldBreakDownRequest_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[FieldBreakDownRequest]  WITH CHECK ADD  CONSTRAINT [FK_FieldBreakDownRequest_EngAsset_AssetId] FOREIGN KEY([AssetId])
REFERENCES [dbo].[EngAsset] ([AssetId])
GO
ALTER TABLE [dbo].[FieldBreakDownRequest] CHECK CONSTRAINT [FK_FieldBreakDownRequest_EngAsset_AssetId]
GO
ALTER TABLE [dbo].[FieldBreakDownRequest]  WITH CHECK ADD  CONSTRAINT [FK_FieldBreakDownRequest_UMUserRegistration_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[UMUserRegistration] ([UserRegistrationId])
GO
ALTER TABLE [dbo].[FieldBreakDownRequest] CHECK CONSTRAINT [FK_FieldBreakDownRequest_UMUserRegistration_UserId]
GO
