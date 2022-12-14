USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[MstCustomer]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MstCustomer](
	[CustomerId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerName] [nvarchar](100) NOT NULL,
	[CustomerCode] [nvarchar](25) NOT NULL,
	[Address] [nvarchar](500) NOT NULL,
	[Latitude] [numeric](24, 15) NOT NULL,
	[Longitude] [numeric](24, 15) NOT NULL,
	[ActiveFromDate] [datetime] NULL,
	[ActiveFromDateUTC] [datetime] NULL,
	[ActiveToDate] [datetime] NULL,
	[ActiveToDateUTC] [datetime] NULL,
	[Logo] [varbinary](max) NULL,
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
	[State] [nvarchar](200) NULL,
	[Country] [nvarchar](200) NOT NULL,
	[ContractPeriodInYears] [numeric](24, 2) NOT NULL,
	[DocumentId] [int] NULL,
	[CustomerImage] [varbinary](max) NULL,
	[ContactNo] [nvarchar](200) NOT NULL,
	[FaxNo] [nvarchar](60) NULL,
	[Remarks] [nvarchar](1000) NULL,
	[CustomerType] [nvarchar](150) NULL,
 CONSTRAINT [PK_MstCustomer] PRIMARY KEY CLUSTERED 
(
	[CustomerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[MstCustomer] ADD  CONSTRAINT [DF_MstCustomer_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[MstCustomer] ADD  CONSTRAINT [DF_MstCustomer_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[MstCustomer] ADD  CONSTRAINT [DF_MstCustomer_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[MstCustomer]  WITH CHECK ADD  CONSTRAINT [FK_MstCustomer_FMDocument_DocumentId] FOREIGN KEY([DocumentId])
REFERENCES [dbo].[FMDocument] ([DocumentId])
GO
ALTER TABLE [dbo].[MstCustomer] CHECK CONSTRAINT [FK_MstCustomer_FMDocument_DocumentId]
GO
