USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[FMLovMst]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FMLovMst](
	[LovId] [int] IDENTITY(1,1) NOT NULL,
	[ModuleName] [nvarchar](50) NOT NULL,
	[ScreenName] [nvarchar](50) NOT NULL,
	[FieldName] [nvarchar](50) NOT NULL,
	[LovKey] [nvarchar](50) NOT NULL,
	[FieldCode] [nvarchar](10) NOT NULL,
	[FieldValue] [nvarchar](100) NOT NULL,
	[Remarks] [nvarchar](500) NULL,
	[ParentId] [int] NULL,
	[SortNo] [int] NOT NULL,
	[IsDefault] [bit] NOT NULL,
	[IsEditable] [bit] NOT NULL,
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
	[LovType] [int] NULL,
 CONSTRAINT [PK_FmLovMst] PRIMARY KEY CLUSTERED 
(
	[LovId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FMLovMst] ADD  CONSTRAINT [DF_FmLovMst_SortNo]  DEFAULT ((10)) FOR [SortNo]
GO
ALTER TABLE [dbo].[FMLovMst] ADD  CONSTRAINT [DF_FmLovMst_IsDefault]  DEFAULT ((0)) FOR [IsDefault]
GO
ALTER TABLE [dbo].[FMLovMst] ADD  CONSTRAINT [DF_FmLovMst_IsEditable]  DEFAULT ((0)) FOR [IsEditable]
GO
ALTER TABLE [dbo].[FMLovMst] ADD  CONSTRAINT [DF_FmLovMst_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[FMLovMst] ADD  CONSTRAINT [DF_FmLovMst_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[FMLovMst] ADD  CONSTRAINT [DF_FmLovMst_GuId]  DEFAULT (newid()) FOR [GuId]
GO
