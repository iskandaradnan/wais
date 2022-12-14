USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[MstContractorandVendor]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MstContractorandVendor](
	[ContractorId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[SSMRegistrationCode] [nvarchar](25) NOT NULL,
	[ContractorName] [nvarchar](100) NOT NULL,
	[ContractorStatus] [int] NOT NULL,
	[ContractorType] [int] NOT NULL,
	[SpecializationDetails] [nvarchar](100) NULL,
	[Address] [nvarchar](500) NOT NULL,
	[State] [nvarchar](50) NULL,
	[FaxNo] [nvarchar](30) NULL,
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
	[Address2] [nvarchar](500) NULL,
	[Postcode] [nvarchar](10) NULL,
	[Country] [nvarchar](200) NULL,
	[NoOfUserAccess] [int] NULL,
	[CountryId] [int] NULL,
	[ContactNo] [nvarchar](200) NOT NULL,
 CONSTRAINT [PK_MstContractorandVendor] PRIMARY KEY CLUSTERED 
(
	[ContractorId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MstContractorandVendor] ADD  CONSTRAINT [DF_MstContractorandVendor_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[MstContractorandVendor] ADD  CONSTRAINT [DF_MstContractorandVendor_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[MstContractorandVendor] ADD  CONSTRAINT [DF_MstContractorandVendor_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[MstContractorandVendor]  WITH CHECK ADD  CONSTRAINT [FK_MstContractorandVendor_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[MstContractorandVendor] CHECK CONSTRAINT [FK_MstContractorandVendor_MstCustomer_CustomerId]
GO
