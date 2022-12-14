USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[LLSCentralLinenStoreHKeepingTxnDet]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LLSCentralLinenStoreHKeepingTxnDet](
	[HouseKeepingDetId] [int] IDENTITY(1,1) NOT NULL,
	[HouseKeepingId] [int] NOT NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[Date] [datetime] NULL,
	[HousekeepingDone] [int] NULL,
	[DateTimeStamp] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedDateUTC] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_LLSCentralLinenStoreHKeepingTxnDet] PRIMARY KEY CLUSTERED 
(
	[HouseKeepingDetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LLSCentralLinenStoreHKeepingTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_LLSCentralLinenStoreHKeepingTxnDet_LLSCentralLinenStoreHKeepingTxn_HouseKeepingId] FOREIGN KEY([HouseKeepingId])
REFERENCES [dbo].[LLSCentralLinenStoreHKeepingTxn] ([HouseKeepingId])
GO
ALTER TABLE [dbo].[LLSCentralLinenStoreHKeepingTxnDet] CHECK CONSTRAINT [FK_LLSCentralLinenStoreHKeepingTxnDet_LLSCentralLinenStoreHKeepingTxn_HouseKeepingId]
GO
