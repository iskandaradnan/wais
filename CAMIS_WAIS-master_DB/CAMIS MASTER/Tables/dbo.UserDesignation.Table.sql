USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[UserDesignation]    Script Date: 20-09-2021 16:25:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserDesignation](
	[UserDesignationId] [int] IDENTITY(1,1) NOT NULL,
	[Designation] [nvarchar](250) NOT NULL,
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
	[IsDefault] [bit] NULL,
 CONSTRAINT [PK_UserDesignation] PRIMARY KEY CLUSTERED 
(
	[UserDesignationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[UserDesignation] ADD  CONSTRAINT [DF_UserDesignation_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[UserDesignation] ADD  CONSTRAINT [DF_UserDesignation_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[UserDesignation] ADD  CONSTRAINT [DF_UserDesignation_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[UserDesignation] ADD  DEFAULT ((0)) FOR [IsDefault]
GO
