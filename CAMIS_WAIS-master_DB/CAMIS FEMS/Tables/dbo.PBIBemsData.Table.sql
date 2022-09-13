USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[PBIBemsData]    Script Date: 20-09-2021 16:53:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PBIBemsData](
	[AssetId] [int] NOT NULL,
	[AssetClassificationDescription] [nvarchar](100) NULL,
	[AssetDescription] [nvarchar](500) NULL,
	[AssetClassificationCode] [nvarchar](25) NULL,
	[AssetClassification] [int] NULL,
	[WorkOrderId] [int] NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NULL,
	[UserID] [int] NULL,
	[UserName] [nvarchar](75) NULL,
	[FacilityName] [nvarchar](100) NULL,
	[WorkOrderStatus] [int] NULL,
	[MaintenanceWorkType] [int] NULL,
	[TypeOfWorkOrder] [int] NULL,
	[WorkOrderStatusName] [varchar](17) NULL,
	[FieldValue] [nvarchar](100) NULL,
	[WorkOrderCategory] [nvarchar](100) NULL,
	[PurchaseCostRM] [numeric](24, 2) NULL,
	[PartsCost] [numeric](24, 2) NOT NULL,
	[ContractorCost] [numeric](24, 2) NOT NULL,
	[VendorCost] [numeric](24, 2) NOT NULL,
	[RepairHours] [numeric](24, 2) NOT NULL,
	[LabourCostPerHour] [numeric](24, 2) NULL,
	[LabourCost] [numeric](38, 4) NULL,
	[MaintenanceCost] [numeric](38, 4) NULL,
	[AgeDifference] [int] NULL,
	[AgeDiffBucket] [varchar](10) NULL,
	[WarrantyStatus] [varchar](15) NOT NULL,
	[PurchaseDate] [datetime] NULL,
	[WarrantyStartDate] [datetime] NULL,
	[WarrantyEndDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL,
	[MaintenanceWorkDateTime] [datetime] NULL,
	[StartDateTime] [datetime] NULL,
	[EndDateTime] [datetime] NULL,
	[TargetDateTime] [datetime] NULL,
	[RescheduleDate] [datetime] NULL,
	[PPMCompletionStatus] [varchar](22) NOT NULL,
	[NumberOfDaysReqd] [int] NULL,
	[NumberOfhoursReqd] [int] NULL,
	[NumberOfMintReqd] [int] NULL,
	[DownTimeDays] [int] NULL,
	[AgeingDays] [int] NULL,
	[LicenseId] [int] NULL,
	[LicenseNo] [nvarchar](50) NULL,
	[ExpireDate] [datetime] NULL,
	[LicenseExpireStatus] [varchar](18) NULL,
	[ContractId] [int] NULL,
	[ContractStartDate] [datetime] NULL,
	[ContractEndDate] [datetime] NULL,
	[ContractExpireStatus] [varchar](18) NULL,
	[MonthNo] [int] NULL,
	[MonthName] [varchar](6) NULL,
	[Year] [int] NULL,
	[WorkOrderType] [varchar](10) NULL,
	[RN] [bigint] NULL,
	[PenaltyDays] [varchar](8) NOT NULL,
	[AgeingBucket] [varchar](8) NULL,
	[AssetCostStatus] [varchar](21) NOT NULL,
	[Distinct_RN] [bigint] NULL,
	[PurchaseCost] [numeric](24, 2) NOT NULL,
	[AgeingBucketOrder] [int] NULL,
	[AgeDiffBucketOrder] [int] NULL,
	[LicenseExpireStatusOrder] [int] NULL,
	[ContractExpireStatusOrder] [int] NULL
) ON [PRIMARY]
GO
