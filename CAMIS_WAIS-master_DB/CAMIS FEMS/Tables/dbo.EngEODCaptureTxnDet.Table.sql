USE [UetrackFemsdbPreProd]
GO
/****** Object:  Table [dbo].[EngEODCaptureTxnDet]    Script Date: 20-09-2021 16:53:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EngEODCaptureTxnDet](
	[CaptureDetId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[FacilityId] [int] NOT NULL,
	[ServiceId] [int] NOT NULL,
	[CaptureId] [int] NOT NULL,
	[ParameterMappingDetId] [int] NULL,
	[ParamterValue] [nvarchar](150) NULL,
	[Standard] [nvarchar](250) NULL,
	[Minimum] [numeric](24, 2) NULL,
	[Maximum] [numeric](24, 2) NULL,
	[ActualValue] [nvarchar](250) NULL,
	[Status] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[GuId] [uniqueidentifier] NOT NULL,
	[UOMId] [int] NULL,
	[MobileGuid] [nvarchar](max) NULL,
 CONSTRAINT [PK_EngEodCaptureTxnDet] PRIMARY KEY CLUSTERED 
(
	[CaptureDetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[EngEODCaptureTxnDet] ADD  CONSTRAINT [DF_EngEodCaptureTxnDet_GuId]  DEFAULT (newid()) FOR [GuId]
GO
ALTER TABLE [dbo].[EngEODCaptureTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_EngEodCaptureTxnDet_EngEodCaptureTxn_CaptureId] FOREIGN KEY([CaptureId])
REFERENCES [dbo].[EngEODCaptureTxn] ([CaptureId])
GO
ALTER TABLE [dbo].[EngEODCaptureTxnDet] CHECK CONSTRAINT [FK_EngEodCaptureTxnDet_EngEodCaptureTxn_CaptureId]
GO
ALTER TABLE [dbo].[EngEODCaptureTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_EngEodCaptureTxnDet_EngEODParameterMappingDet_ParameterMappingDetId] FOREIGN KEY([ParameterMappingDetId])
REFERENCES [dbo].[EngEODParameterMappingDet] ([ParameterMappingDetId])
GO
ALTER TABLE [dbo].[EngEODCaptureTxnDet] CHECK CONSTRAINT [FK_EngEodCaptureTxnDet_EngEODParameterMappingDet_ParameterMappingDetId]
GO
ALTER TABLE [dbo].[EngEODCaptureTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_EngEodCaptureTxnDet_MstCustomer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MstCustomer] ([CustomerId])
GO
ALTER TABLE [dbo].[EngEODCaptureTxnDet] CHECK CONSTRAINT [FK_EngEodCaptureTxnDet_MstCustomer_CustomerId]
GO
ALTER TABLE [dbo].[EngEODCaptureTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_EngEodCaptureTxnDet_MstLocationFacility_FacilityId] FOREIGN KEY([FacilityId])
REFERENCES [dbo].[MstLocationFacility] ([FacilityId])
GO
ALTER TABLE [dbo].[EngEODCaptureTxnDet] CHECK CONSTRAINT [FK_EngEodCaptureTxnDet_MstLocationFacility_FacilityId]
GO
ALTER TABLE [dbo].[EngEODCaptureTxnDet]  WITH CHECK ADD  CONSTRAINT [FK_EngEodCaptureTxnDet_MstService_ServiceId] FOREIGN KEY([ServiceId])
REFERENCES [dbo].[MstService] ([ServiceId])
GO
ALTER TABLE [dbo].[EngEODCaptureTxnDet] CHECK CONSTRAINT [FK_EngEodCaptureTxnDet_MstService_ServiceId]
GO
