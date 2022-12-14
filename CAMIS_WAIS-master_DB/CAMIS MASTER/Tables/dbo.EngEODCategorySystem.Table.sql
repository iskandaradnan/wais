USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[EngEODCategorySystem]    Script Date: 20-09-2021 16:25:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngEODCategorySystem](
	[CategorySystemId] [int] IDENTITY(1,1) NOT NULL,
	[ServiceId] [int] NOT NULL,
	[CategorySystemName] [nvarchar](150) NOT NULL,
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
 CONSTRAINT [PK_EngEODCategorySystem] PRIMARY KEY CLUSTERED 
(
	[CategorySystemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngEODCategorySystem] ADD  CONSTRAINT [DF_EngEODCategorySystem_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[EngEODCategorySystem] ADD  CONSTRAINT [DF_EngEODCategorySystem_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[EngEODCategorySystem] ADD  CONSTRAINT [DF_EngEODCategorySystem_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngEODCategorySystem]  WITH CHECK ADD  CONSTRAINT [FK_EngEODCategorySystem_MstService_ServiceId] FOREIGN KEY([ServiceId])
REFERENCES [dbo].[MstService] ([ServiceId])
GO
ALTER TABLE [dbo].[EngEODCategorySystem] CHECK CONSTRAINT [FK_EngEODCategorySystem_MstService_ServiceId]
GO
