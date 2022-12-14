USE [UetrackFemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_QapB1AdditionalInformationTxn]    Script Date: 20-09-2021 17:00:56 ******/
CREATE TYPE [dbo].[udt_QapB1AdditionalInformationTxn] AS TABLE(
	[AdditionalInfoId] [int] NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[ServiceId] [int] NULL,
	[CarId] [int] NULL,
	[AssetId] [int] NULL,
	[WorkOrderId] [int] NULL,
	[TargetDateTime] [datetime] NULL,
	[EndDateTime] [datetime] NULL,
	[CauseCodeId] [int] NULL,
	[QcCodeId] [int] NULL,
	[UserId] [int] NULL
)
GO
