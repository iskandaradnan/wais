USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[LLSVehicleDetailsMstDet]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LLSVehicleDetailsMstDet](
	[VehicleDetId] [int] IDENTITY(1,1) NOT NULL,
	[VehicleId] [int] NOT NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[LicenseTypeDetId] [int] NOT NULL,
	[LicenseNo] [nvarchar](150) NOT NULL,
	[ClassGrade] [int] NULL,
	[IssuedBy] [int] NULL,
	[IssuedDate] [datetime] NULL,
	[ExpiryDate] [datetime] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedDateUTC] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
	[Timestamp] [timestamp] NOT NULL,
	[IsDeleted] [int] NULL,
 CONSTRAINT [PK_LLSVehicleDetailsMstDet] PRIMARY KEY CLUSTERED 
(
	[VehicleDetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LLSVehicleDetailsMstDet]  WITH CHECK ADD  CONSTRAINT [FK_LLSVehicleDetailsMstDet_LLSVehicleDetailsMst_VehicleId] FOREIGN KEY([VehicleId])
REFERENCES [dbo].[LLSVehicleDetailsMst] ([VehicleId])
GO
ALTER TABLE [dbo].[LLSVehicleDetailsMstDet] CHECK CONSTRAINT [FK_LLSVehicleDetailsMstDet_LLSVehicleDetailsMst_VehicleId]
GO
