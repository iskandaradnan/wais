USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[HWMS_RouteTransportationHospital]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HWMS_RouteTransportationHospital](
	[RouteHospitalId] [int] IDENTITY(1,1) NOT NULL,
	[RouteTransportationId] [int] NOT NULL,
	[HospitalCode] [nvarchar](100) NULL,
	[HospitalName] [nvarchar](100) NULL,
	[Remarks] [nvarchar](100) NULL,
	[isDeleted] [bit] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[HWMS_RouteTransportationHospital]  WITH CHECK ADD  CONSTRAINT [Transportations_FK_Id] FOREIGN KEY([RouteTransportationId])
REFERENCES [dbo].[HWMS_RouteTransportation] ([RouteTransportationId])
GO
ALTER TABLE [dbo].[HWMS_RouteTransportationHospital] CHECK CONSTRAINT [Transportations_FK_Id]
GO
