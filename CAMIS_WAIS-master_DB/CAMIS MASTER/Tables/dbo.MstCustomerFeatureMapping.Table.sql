USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[MstCustomerFeatureMapping]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MstCustomerFeatureMapping](
	[MappingId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FeatureId] [int] NOT NULL,
	[FeatureStatus] [int] NOT NULL,
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
 CONSTRAINT [PK_MstCustomerFeatureMapping] PRIMARY KEY CLUSTERED 
(
	[MappingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MstCustomerFeatureMapping] ADD  CONSTRAINT [DF_MstCustomerFeatureMapping_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[MstCustomerFeatureMapping] ADD  CONSTRAINT [DF_MstCustomerFeatureMapping_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[MstCustomerFeatureMapping] ADD  CONSTRAINT [DF_MstCustomerFeatureMapping_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[MstCustomerFeatureMapping]  WITH CHECK ADD  CONSTRAINT [FK_MstCustomerFeatureMapping_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[MstCustomerFeatureMapping] CHECK CONSTRAINT [FK_MstCustomerFeatureMapping_MstCustomer_CustomerId]
GO
ALTER TABLE [dbo].[MstCustomerFeatureMapping]  WITH CHECK ADD  CONSTRAINT [FK_MstCustomerFeatureMapping_MstFeatures_FeatureId] FOREIGN KEY([FeatureId])
REFERENCES [dbo].[MstFeatures] ([FeatureId])
GO
ALTER TABLE [dbo].[MstCustomerFeatureMapping] CHECK CONSTRAINT [FK_MstCustomerFeatureMapping_MstFeatures_FeatureId]
GO
