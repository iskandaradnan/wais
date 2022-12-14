USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[UserDepartment]    Script Date: 20-09-2021 16:25:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserDepartment](
	[UserDepartmentId] [int] IDENTITY(1,1) NOT NULL,
	[Department] [nvarchar](250) NOT NULL,
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
 CONSTRAINT [PK_UserDepartment] PRIMARY KEY CLUSTERED 
(
	[UserDepartmentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[UserDepartment] ADD  CONSTRAINT [DF_UserDepartment_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[UserDepartment] ADD  CONSTRAINT [DF_UserDepartment_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[UserDepartment] ADD  CONSTRAINT [DF_UserDepartment_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[UserDepartment] ADD  DEFAULT ((0)) FOR [IsDefault]
GO
