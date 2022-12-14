USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[FMAddFieldConfig]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FMAddFieldConfig](
	[AddFieldConfigId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NULL,
	[ScreenNameLovId] [int] NOT NULL,
	[FieldTypeLovId] [int] NOT NULL,
	[FieldName] [nvarchar](100) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[DropDownValues] [nvarchar](1000) NULL,
	[RequiredLovId] [int] NOT NULL,
	[PatternLovId] [int] NULL,
	[MaxLength] [int] NULL,
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
	[AddFieldConfigId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FMAddFieldConfig] ADD  CONSTRAINT [DF_FMAddFieldConfig_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[FMAddFieldConfig] ADD  CONSTRAINT [DF_FMAddFieldConfig_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[FMAddFieldConfig] ADD  CONSTRAINT [DF_FMAddFieldConfig_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[FMAddFieldConfig]  WITH CHECK ADD  CONSTRAINT [FK_FMAddFieldConfig_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[FMAddFieldConfig] CHECK CONSTRAINT [FK_FMAddFieldConfig_MstCustomer_CustomerId]
GO
