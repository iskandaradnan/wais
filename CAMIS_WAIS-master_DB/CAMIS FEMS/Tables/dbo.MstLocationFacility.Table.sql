USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[MstLocationFacility]    Script Date: 20-09-2021 16:53:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MstLocationFacility](
	[FacilityId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NULL,
	[FacilityName] [nvarchar](100) NULL,
	[FacilityCode] [nvarchar](25) NULL,
	[Address] [nvarchar](500) NULL,
	[Latitude] [numeric](24, 15) NOT NULL,
	[Longitude] [numeric](24, 15) NOT NULL,
	[ActiveFrom] [datetime] NULL,
	[ActiveFromUTC] [datetime] NULL,
	[ActiveTo] [datetime] NULL,
	[ActiveToUTC] [datetime] NULL,
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
	[WeeklyHoliday] [nvarchar](100) NULL,
	[Address2] [nvarchar](500) NULL,
	[Postcode] [nvarchar](10) NULL,
	[State] [nvarchar](200) NULL,
	[Country] [nvarchar](200) NOT NULL,
	[ContractPeriodInMonths] [int] NOT NULL,
	[MonthlyServiceFee] [numeric](24, 2) NULL,
	[DocumentId] [int] NULL,
	[TypeOfNomenclature] [int] NULL,
	[LifeExpectancy] [int] NULL,
	[Logo] [varbinary](max) NULL,
	[FacilityImage] [varbinary](max) NULL,
	[ContactNo] [nvarchar](200) NOT NULL,
	[FaxNo] [nvarchar](60) NULL,
	[WarrantyRenewalNoticeDays] [int] NULL,
	[InitialProjectCost] [numeric](24, 2) NULL,
	[IsContractPeriodChanged] [int] NULL,
 CONSTRAINT [PK_MstLocationFacility] PRIMARY KEY CLUSTERED 
(
	[FacilityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[MstLocationFacility] ADD  CONSTRAINT [DF_MstLocationFacility_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[MstLocationFacility] ADD  CONSTRAINT [DF_MstLocationFacility_BuiltIn]  DEFAULT ((1)) FOR [BuiltIn]
GO
ALTER TABLE [dbo].[MstLocationFacility] ADD  CONSTRAINT [DF_MstLocationFacility_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[MstLocationFacility]  WITH CHECK ADD  CONSTRAINT [FK_MstLocationFacility_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[MstLocationFacility] CHECK CONSTRAINT [FK_MstLocationFacility_MstCustomer_CustomerId]
GO
