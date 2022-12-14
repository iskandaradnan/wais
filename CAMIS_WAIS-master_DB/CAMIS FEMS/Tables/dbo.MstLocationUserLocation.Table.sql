USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[MstLocationUserLocation]    Script Date: 20-09-2021 16:53:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MstLocationUserLocation](
	[UserLocationId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[BlockId] [int] NOT NULL,
	[LevelId] [int] NOT NULL,
	[UserAreaId] [int] NOT NULL,
	[UserLocationCode] [nvarchar](50) NOT NULL,
	[UserLocationName] [nvarchar](100) NOT NULL,
	[ActiveFromDate] [datetime] NOT NULL,
	[ActiveFromDateUTC] [datetime] NOT NULL,
	[ActiveToDate] [datetime] NULL,
	[ActiveToDateUTC] [datetime] NULL,
	[AuthorizedUserId] [int] NOT NULL,
	[Remarks] [nvarchar](500) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[Active] [bit] NOT NULL,
	[BuiltIn] [bit] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
	[QRCode] [varbinary](max) NULL,
	[CompanyStaffId] [int] NULL,
	[MigratedDate] [date] NULL,
 CONSTRAINT [PK_MstLocationUserLocation] PRIMARY KEY CLUSTERED 
(
	[UserLocationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[MstLocationUserLocation] ADD  CONSTRAINT [DF_MstLocationUserLocation_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[MstLocationUserLocation] ADD  CONSTRAINT [DF_MstLocationUserLocation_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[MstLocationUserLocation] ADD  CONSTRAINT [DF_MstLocationUserLocation_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[MstLocationUserLocation]  WITH CHECK ADD  CONSTRAINT [FK_MstLocationUserLocation_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[MstLocationUserLocation] CHECK CONSTRAINT [FK_MstLocationUserLocation_MstCustomer_CustomerId]
GO
ALTER TABLE [dbo].[MstLocationUserLocation]  WITH CHECK ADD  CONSTRAINT [FK_MstLocationUserLocation_MstLocationBlock_BlockId] FOREIGN KEY([BlockId])
REFERENCES [dbo].[MstLocationBlock] ([BlockId])
GO
ALTER TABLE [dbo].[MstLocationUserLocation] CHECK CONSTRAINT [FK_MstLocationUserLocation_MstLocationBlock_BlockId]
GO
ALTER TABLE [dbo].[MstLocationUserLocation]  WITH CHECK ADD  CONSTRAINT [FK_MstLocationUserLocation_MstLocationFacility_FacilityId] FOREIGN KEY([FacilityId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[MstLocationUserLocation] CHECK CONSTRAINT [FK_MstLocationUserLocation_MstLocationFacility_FacilityId]
GO
ALTER TABLE [dbo].[MstLocationUserLocation]  WITH CHECK ADD  CONSTRAINT [FK_MstLocationUserLocation_MstLocationLevel_LevelId] FOREIGN KEY([LevelId])
REFERENCES [dbo].[MstLocationLevel] ([LevelId])
GO
ALTER TABLE [dbo].[MstLocationUserLocation] CHECK CONSTRAINT [FK_MstLocationUserLocation_MstLocationLevel_LevelId]
GO
ALTER TABLE [dbo].[MstLocationUserLocation]  WITH CHECK ADD  CONSTRAINT [FK_MstLocationUserLocation_MstLocationUserArea_UserAreaId] FOREIGN KEY([UserAreaId])
REFERENCES [dbo].[MstLocationUserArea] ([UserAreaId])
GO
ALTER TABLE [dbo].[MstLocationUserLocation] CHECK CONSTRAINT [FK_MstLocationUserLocation_MstLocationUserArea_UserAreaId]
GO
ALTER TABLE [dbo].[MstLocationUserLocation]  WITH CHECK ADD  CONSTRAINT [FK_MstLocationUserLocation_UMUserRegistration_AuthorizedUserId] FOREIGN KEY([AuthorizedUserId])
REFERENCES [dbo].[UMUserRegistration] ([UserRegistrationId])
GO
ALTER TABLE [dbo].[MstLocationUserLocation] CHECK CONSTRAINT [FK_MstLocationUserLocation_UMUserRegistration_AuthorizedUserId]
GO
