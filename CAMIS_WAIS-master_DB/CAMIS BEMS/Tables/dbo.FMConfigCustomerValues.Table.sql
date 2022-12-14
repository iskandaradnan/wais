USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[FMConfigCustomerValues]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FMConfigCustomerValues](
	[ConfigValueId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[ConfigKeyId] [int] NULL,
	[KeyName] [nvarchar](100) NULL,
	[ConfigKeyLovId] [int] NULL,
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
PRIMARY KEY CLUSTERED 
(
	[ConfigValueId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FMConfigCustomerValues] ADD  CONSTRAINT [DF_FMConfigCustomerValues_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[FMConfigCustomerValues] ADD  CONSTRAINT [DF_FMConfigCustomerValues_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[FMConfigCustomerValues] ADD  CONSTRAINT [DF_FMConfigCustomerValues_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[FMConfigCustomerValues]  WITH CHECK ADD  CONSTRAINT [FK_FMConfigCustomerValues_ConfigKeyId] FOREIGN KEY([ConfigKeyId])
REFERENCES [dbo].[FMConfigKeys] ([ConfigKeyId])
GO
ALTER TABLE [dbo].[FMConfigCustomerValues] CHECK CONSTRAINT [FK_FMConfigCustomerValues_ConfigKeyId]
GO
