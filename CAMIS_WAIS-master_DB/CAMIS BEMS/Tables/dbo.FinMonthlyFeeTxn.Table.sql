USE [UetrackBemsdbPreProd]
GO
/****** Object:  Table [dbo].[FinMonthlyFeeTxn]    Script Date: 20-09-2021 17:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FinMonthlyFeeTxn](
	[MonthlyFeeId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[Year] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
	[VersionNo] [int] NULL,
 CONSTRAINT [PK_FinMonthlyFeeTxn] PRIMARY KEY CLUSTERED 
(
	[MonthlyFeeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FinMonthlyFeeTxn] ADD  CONSTRAINT [DF_FinMonthlyFeeTxn_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[FinMonthlyFeeTxn]  WITH CHECK ADD  CONSTRAINT [FK_FinMonthlyFeeTxn_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[FinMonthlyFeeTxn] CHECK CONSTRAINT [FK_FinMonthlyFeeTxn_MstCustomer_CustomerId]
GO
ALTER TABLE [dbo].[FinMonthlyFeeTxn]  WITH CHECK ADD  CONSTRAINT [FK_FinMonthlyFeeTxn_MstLocationFacility_FacilityId] FOREIGN KEY([FacilityId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[FinMonthlyFeeTxn] CHECK CONSTRAINT [FK_FinMonthlyFeeTxn_MstLocationFacility_FacilityId]
GO
