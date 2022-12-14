USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[MstContractorandVendorContactInfo]    Script Date: 20-09-2021 16:53:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MstContractorandVendorContactInfo](
	[ContractorContactInfoId] [int] IDENTITY(1,1) NOT NULL,
	[ContractorId] [int] NULL,
	[Name] [nvarchar](100) NULL,
	[Designation] [nvarchar](200) NULL,
	[ContactNo] [nvarchar](200) NULL,
	[Email] [nvarchar](200) NULL,
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
 CONSTRAINT [PK_MstContractorandVendorContactInfo] PRIMARY KEY CLUSTERED 
(
	[ContractorContactInfoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MstContractorandVendorContactInfo] ADD  CONSTRAINT [DF_MstContractorandVendorContactInfo_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[MstContractorandVendorContactInfo] ADD  CONSTRAINT [DF_MstContractorandVendorContactInfo_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[MstContractorandVendorContactInfo] ADD  CONSTRAINT [DF_MstContractorandVendorContactInfo_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[MstContractorandVendorContactInfo]  WITH CHECK ADD  CONSTRAINT [FK_MstContractorandVendorContactInfo_MstContractorandVendor_ContractorId] FOREIGN KEY([ContractorId])
REFERENCES [dbo].[MstContractorandVendor] ([ContractorId])
GO
ALTER TABLE [dbo].[MstContractorandVendorContactInfo] CHECK CONSTRAINT [FK_MstContractorandVendorContactInfo_MstContractorandVendor_ContractorId]
GO
