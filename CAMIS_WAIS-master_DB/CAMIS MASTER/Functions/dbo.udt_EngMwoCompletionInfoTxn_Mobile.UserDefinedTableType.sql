USE [UetrackMasterdbPreProd]
GO
/****** Object:  UserDefinedTableType [dbo].[udt_EngMwoCompletionInfoTxn_Mobile]    Script Date: 20-09-2021 16:50:19 ******/
CREATE TYPE [dbo].[udt_EngMwoCompletionInfoTxn_Mobile] AS TABLE(
	[CompletionInfoId] [int] NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[ServiceId] [int] NULL,
	[WorkOrderId] [int] NULL,
	[RepairDetails] [nvarchar](1000) NULL,
	[PPMAgreedDate] [datetime] NULL,
	[PPMAgreedDateUTC] [datetime] NULL,
	[StartDateTime] [datetime] NULL,
	[StartDateTimeUTC] [datetime] NULL,
	[EndDateTime] [datetime] NULL,
	[EndDateTimeUTC] [datetime] NULL,
	[HandoverDateTime] [datetime] NULL,
	[HandoverDateTimeUTC] [datetime] NULL,
	[CompletedBy] [int] NULL,
	[AcceptedBy] [int] NULL,
	[Signature] [nvarchar](1000) NULL,
	[ServiceAvailability] [bit] NULL,
	[LoanerProvision] [bit] NULL,
	[HandoverDelay] [int] NULL,
	[DowntimeHoursMin] [numeric](24, 2) NULL,
	[CauseCode] [int] NULL,
	[QCCode] [int] NULL,
	[ResourceType] [int] NULL,
	[LabourCost] [numeric](24, 2) NULL,
	[PartsCost] [numeric](24, 2) NULL,
	[ContractorCost] [numeric](24, 2) NULL,
	[TotalCost] [numeric](24, 2) NULL,
	[ContractorId] [int] NULL,
	[ContractorHours] [numeric](24, 2) NULL,
	[PartsRequired] [bit] NULL,
	[Approved] [bit] NULL,
	[AppType] [int] NULL,
	[RepairHours] [numeric](24, 2) NULL,
	[ProcessStatus] [int] NULL,
	[ProcessStatusDate] [datetime] NULL,
	[ProcessStatusReason] [int] NULL,
	[UserId] [int] NULL,
	[IsSubmitted] [bit] NULL DEFAULT ((0)),
	[RunningHours] [nvarchar](100) NULL,
	[VendorCost] [numeric](24, 2) NULL,
	[MobileGuid] [nvarchar](max) NULL,
	[DownTimeHours] [numeric](24, 2) NULL,
	[WOSignature] [varbinary](max) NULL,
	[CustomerFeedback] [int] NULL
)
GO
