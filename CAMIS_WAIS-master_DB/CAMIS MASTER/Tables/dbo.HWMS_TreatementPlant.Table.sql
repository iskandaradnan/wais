USE [UetrackMasterdbPreProd]
GO
/****** Object:  Table [dbo].[HWMS_TreatementPlant]    Script Date: 20-09-2021 16:25:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HWMS_TreatementPlant](
	[TreatmentPlantId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NULL,
	[FacilityId] [int] NULL,
	[TreatmentPlantCode] [nvarchar](50) NULL,
	[TreatmentPlantName] [nvarchar](50) NULL,
	[RegistrationNo] [nvarchar](50) NULL,
	[AdressLine1] [nvarchar](100) NULL,
	[AdressLine2] [nvarchar](100) NULL,
	[City] [nvarchar](50) NULL,
	[State] [nvarchar](50) NULL,
	[PostCode] [nvarchar](50) NULL,
	[Ownership] [nvarchar](50) NULL,
	[ContactNumber] [bigint] NULL,
	[FaxNumber] [nvarchar](50) NULL,
	[DOEFileNo] [nvarchar](50) NULL,
	[OwnerName] [nvarchar](50) NULL,
	[NumberOfStore] [int] NULL,
	[CapacityOfStorage] [int] NULL,
	[Remarks] [nvarchar](100) NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[CreateDateUTC] [datetime] NULL,
	[ModifiedDateUTC] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[TreatmentPlantId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[TreatmentPlantCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
