USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[MstLocationUserArea]    Script Date: 20-09-2021 16:53:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MstLocationUserArea](
	[UserAreaId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[BlockId] [int] NOT NULL,
	[LevelId] [int] NOT NULL,
	[UserAreaCode] [nvarchar](25) NOT NULL,
	[UserAreaName] [nvarchar](100) NOT NULL,
	[CustomerUserId] [int] NOT NULL,
	[FacilityUserId] [int] NOT NULL,
	[ActiveFromDate] [datetime] NOT NULL,
	[ActiveFromDateUTC] [datetime] NOT NULL,
	[ActiveToDate] [datetime] NULL,
	[ActiveToDateUTC] [datetime] NULL,
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
	[migratedFlag] [int] NULL,
	[MigratedDAte] [datetime] NULL,
 CONSTRAINT [PK_MstLocationUserArea] PRIMARY KEY CLUSTERED 
(
	[UserAreaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UC_Area] UNIQUE NONCLUSTERED 
(
	[UserAreaCode] ASC,
	[UserAreaName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[MstLocationUserArea] ADD  CONSTRAINT [DF_MstLocationUserArea_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[MstLocationUserArea] ADD  CONSTRAINT [DF_MstLocationUserArea_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[MstLocationUserArea] ADD  CONSTRAINT [DF_MstLocationUserArea_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[MstLocationUserArea] ADD  DEFAULT ((0)) FOR [migratedFlag]
GO
ALTER TABLE [dbo].[MstLocationUserArea] ADD  DEFAULT (getdate()) FOR [MigratedDAte]
GO
ALTER TABLE [dbo].[MstLocationUserArea]  WITH CHECK ADD  CONSTRAINT [FK_MstLocationUserArea_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[MstLocationUserArea] CHECK CONSTRAINT [FK_MstLocationUserArea_MstCustomer_CustomerId]
GO
ALTER TABLE [dbo].[MstLocationUserArea]  WITH CHECK ADD  CONSTRAINT [FK_MstLocationUserArea_MstLocationBlock_BlockId] FOREIGN KEY([BlockId])
REFERENCES [dbo].[MstLocationBlock] ([BlockId])
GO
ALTER TABLE [dbo].[MstLocationUserArea] CHECK CONSTRAINT [FK_MstLocationUserArea_MstLocationBlock_BlockId]
GO
ALTER TABLE [dbo].[MstLocationUserArea]  WITH CHECK ADD  CONSTRAINT [FK_MstLocationUserArea_MstLocationFacility_FacilityId] FOREIGN KEY([FacilityId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[MstLocationUserArea] CHECK CONSTRAINT [FK_MstLocationUserArea_MstLocationFacility_FacilityId]
GO
ALTER TABLE [dbo].[MstLocationUserArea]  WITH CHECK ADD  CONSTRAINT [FK_MstLocationUserArea_MstLocationLevel_LevelId] FOREIGN KEY([LevelId])
REFERENCES [dbo].[MstLocationLevel] ([LevelId])
GO
ALTER TABLE [dbo].[MstLocationUserArea] CHECK CONSTRAINT [FK_MstLocationUserArea_MstLocationLevel_LevelId]
GO
ALTER TABLE [dbo].[MstLocationUserArea]  WITH CHECK ADD  CONSTRAINT [FK_MstLocationUserArea_UMUserRegistration_CustomerUserId] FOREIGN KEY([CustomerUserId])
REFERENCES [dbo].[UMUserRegistration] ([UserRegistrationId])
GO
ALTER TABLE [dbo].[MstLocationUserArea] CHECK CONSTRAINT [FK_MstLocationUserArea_UMUserRegistration_CustomerUserId]
GO
ALTER TABLE [dbo].[MstLocationUserArea]  WITH CHECK ADD  CONSTRAINT [FK_MstLocationUserArea_UMUserRegistration_FacilityUserId] FOREIGN KEY([FacilityUserId])
REFERENCES [dbo].[UMUserRegistration] ([UserRegistrationId])
GO
ALTER TABLE [dbo].[MstLocationUserArea] CHECK CONSTRAINT [FK_MstLocationUserArea_UMUserRegistration_FacilityUserId]
GO
