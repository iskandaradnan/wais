USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[MstSupplier]    Script Date: 20-09-2021 16:53:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MstSupplier](
	[SupplierId] [int] IDENTITY(1,1) NOT NULL,
	[SupplierName] [nvarchar](250) NOT NULL,
	[SupplierNo] [nvarchar](50) NOT NULL,
	[SupplierContactName] [nvarchar](250) NULL,
	[SupplierContactTitle] [nvarchar](250) NULL,
	[SupplierAddress] [nvarchar](300) NULL,
	[SupplierCity] [nvarchar](100) NULL,
	[SupplierCountry] [nvarchar](100) NULL,
	[SupplierEmail] [nvarchar](50) NULL,
	[SupplierPhone] [nvarchar](50) NULL,
	[SupplierFax] [nvarchar](50) NULL,
	[SupplierService] [nvarchar](500) NULL,
	[SupplierCompId] [int] NULL,
	[SupplierBranchId] [int] NULL,
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
 CONSTRAINT [PK_MstSuppliers] PRIMARY KEY CLUSTERED 
(
	[SupplierId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MstSupplier] ADD  CONSTRAINT [DF_MstSupplier_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[MstSupplier] ADD  CONSTRAINT [DF_MstSupplier_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[MstSupplier] ADD  CONSTRAINT [DF_MstSupplier_GuId]  DEFAULT (newid()) FOR [GuId]
GO
