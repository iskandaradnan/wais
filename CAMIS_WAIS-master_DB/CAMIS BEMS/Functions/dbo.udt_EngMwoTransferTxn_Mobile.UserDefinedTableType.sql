USE [UetrackBemsdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_EngMwoTransferTxn_Mobile]    Script Date: 20-09-2021 17:09:19 ******/
CREATE TYPE [dbo].[udt_EngMwoTransferTxn_Mobile] AS TABLE(
	[WOTransferId] [int] NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[ServiceId] [int] NULL,
	[WorkOrderId] [int] NULL,
	[AssignedUserId] [int] NULL,
	[TransferReasonLovId] [int] NULL,
	[UserId] [int] NULL,
	[IsChangeToVendor] [int] NULL,
	[AssignedVendor] [int] NULL,
	[TransferStatus] [nvarchar](200) NULL
)
GO
