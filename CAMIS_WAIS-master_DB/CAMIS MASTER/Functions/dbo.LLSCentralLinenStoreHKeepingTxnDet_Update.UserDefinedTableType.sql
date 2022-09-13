USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[LLSCentralLinenStoreHKeepingTxnDet_Update]    Script Date: 20-09-2021 16:50:18 ******/
CREATE TYPE [dbo].[LLSCentralLinenStoreHKeepingTxnDet_Update] AS TABLE(
	[HouseKeepingDetId] [int] NULL,
	[HousekeepingDone] [int] NULL,
	[Date] [datetime2](7) NULL,
	[ModifiedBy] [int] NOT NULL
)
GO
