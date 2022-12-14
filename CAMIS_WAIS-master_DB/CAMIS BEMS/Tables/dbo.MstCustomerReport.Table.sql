USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[MstCustomerReport]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MstCustomerReport](
	[CustomerReportId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NULL,
	[ReportName] [nvarchar](500) NULL,
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
	[FacilityId] [int] NULL,
 CONSTRAINT [PK_MstCustomerReport] PRIMARY KEY CLUSTERED 
(
	[CustomerReportId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MstCustomerReport] ADD  CONSTRAINT [DF_MstCustomerReport_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[MstCustomerReport] ADD  CONSTRAINT [DF_MstCustomerReport_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[MstCustomerReport] ADD  CONSTRAINT [DF_MstCustomerReport_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[MstCustomerReport]  WITH CHECK ADD  CONSTRAINT [FK_MstCustomerReport_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[MstCustomerReport] CHECK CONSTRAINT [FK_MstCustomerReport_MstCustomer_CustomerId]
GO
