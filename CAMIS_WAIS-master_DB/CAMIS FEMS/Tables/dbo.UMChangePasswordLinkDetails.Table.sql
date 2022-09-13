USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[UMChangePasswordLinkDetails]    Script Date: 20-09-2021 16:53:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UMChangePasswordLinkDetails](
	[ChangePasswordId] [int] IDENTITY(1,1) NOT NULL,
	[LoginName] [nvarchar](75) NOT NULL,
	[Password] [nvarchar](max) NOT NULL,
	[IsExpired] [bit] NOT NULL,
	[Link] [nvarchar](250) NOT NULL,
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
 CONSTRAINT [PK_UMChangePasswordLinkDetails] PRIMARY KEY CLUSTERED 
(
	[ChangePasswordId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[UMChangePasswordLinkDetails] ADD  CONSTRAINT [DF_UMChangePasswordLinkDetails_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[UMChangePasswordLinkDetails] ADD  CONSTRAINT [DF_UMChangePasswordLinkDetails_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[UMChangePasswordLinkDetails] ADD  CONSTRAINT [DF_UMChangePasswordLinkDetails_GuId]  DEFAULT (newid()) FOR [GuId]
GO
