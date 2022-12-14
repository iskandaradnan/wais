USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[EngAssetWorkGroup]    Script Date: 20-09-2021 16:53:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngAssetWorkGroup](
	[WorkGroupId] [int] IDENTITY(1,1) NOT NULL,
	[ServiceId] [int] NOT NULL,
	[WorkGroupCode] [nvarchar](25) NOT NULL,
	[WorkGroupDescription] [nvarchar](100) NOT NULL,
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
 CONSTRAINT [PK_EngAssetWorkGroup] PRIMARY KEY CLUSTERED 
(
	[WorkGroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngAssetWorkGroup] ADD  CONSTRAINT [DF_EngAssetWorkGroup_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[EngAssetWorkGroup] ADD  CONSTRAINT [DF_EngAssetWorkGroup_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[EngAssetWorkGroup] ADD  CONSTRAINT [DF_EngAssetWorkGroup_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngAssetWorkGroup]  WITH CHECK ADD  CONSTRAINT [FK_EngAssetWorkGroup_MstService_ServiceId] FOREIGN KEY([ServiceId])
REFERENCES [dbo].[MstService] ([ServiceId])
GO
ALTER TABLE [dbo].[EngAssetWorkGroup] CHECK CONSTRAINT [FK_EngAssetWorkGroup_MstService_ServiceId]
GO
