USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_RecordsofRecyclableWaste_Save]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[Sp_HWMS_RecordsofRecyclableWaste_Save]

	@RecyclableId INT,
	@CustomerId INT,
	@FacilityId INT,
	@RRWNo VARCHAR(50),
	@TotalWeight FLOAT,
	@CSWRepresentative VARCHAR(50),
	@HospitalRepresentative VARCHAR(50),
	@VendorCode VARCHAR(50),
	@UnitRate FLOAT,
	@TotalAmount FLOAT=null,
	@WasteType VARCHAR(50),
	@TransportationCategory VARCHAR(50)=null,
	@Remarks VARCHAR(50)=null,
	@DateTime DATETIME,
	@MethodofDisposal VARCHAR(50),
	@CSWRepresentativeDesignation  VARCHAR(50)=null,
	@HospitalRepresentativeDesignation  VARCHAR(50)=null,
	@VendorName  VARCHAR(50)=null,
	@ReturnValue FLOAT=null,
	@InvoiceNoReceiptNo  VARCHAR(50)=null,
	@WasteCode  VARCHAR(50),
	@StartDate DATETIME,
	@EndDate DATETIME
						
AS
BEGIN 
SET NOCOUNT ON; 
BEGIN TRY

IF(@RecyclableId = 0)
	
	IF(NOT EXISTS (SELECT 1 FROM HWMS_RecordsofRecyclableWaste_Save WHERE [CustomerId] = @Customerid AND [FacilityId] = @Facilityid AND [RRWNo] = @RRWNo  ))
		BEGIN
		INSERT INTO HWMS_RecordsofRecyclableWaste_Save([CustomerId],[FacilityId],[RRWNo],[TotalWeight],[CSWRepresentative],[HospitalRepresentative],
		[VendorCode],[UnitRate],[TotalAmount],[WasteType],[TransportationCategory],[Remarks],[DateTime],[MethodofDisposal],[CSWRepresentativeDesignation],
		[HospitalRepresentativeDesignation],[VendorName],[ReturnValue],[InvoiceNoReceiptNo],[WasteCode],[StartDate],[EndDate])
		VALUES (@CustomerId, @FacilityId, @RRWNo, @TotalWeight,@CSWRepresentative,@HospitalRepresentative,
		@VendorCode, @UnitRate, @TotalAmount, @WasteType, @TransportationCategory,@Remarks,@DateTime,@MethodofDisposal,@CSWRepresentativeDesignation,
		@HospitalRepresentativeDesignation,@VendorName,@ReturnValue,@InvoiceNoReceiptNo,@WasteCode,@StartDate,@EndDate)

		SELECT MAX(RecyclableId) as RecyclableId FROM HWMS_RecordsofRecyclableWaste_Save
		END
	ELSE
	   BEGIN
	   SELECT -1 AS RecyclableId			
	   END		
	  
ELSE
       BEGIN		 
	   UPDATE HWMS_RecordsofRecyclableWaste_Save SET [RRWNo]=@RRWNo, [TotalWeight]=@TotalWeight,[CSWRepresentative]=@CSWRepresentative,
	   [HospitalRepresentative]=@HospitalRepresentative,[VendorCode]=@VendorCode,[UnitRate]= @UnitRate,[TotalAmount]=@TotalAmount, [WasteType]=@WasteType,
	   [TransportationCategory]= @TransportationCategory,[Remarks]=@Remarks,[DateTime]=@DateTime,[MethodofDisposal]=@MethodofDisposal,
	   [CSWRepresentativeDesignation]=@CSWRepresentativeDesignation, [HospitalRepresentativeDesignation]=@HospitalRepresentativeDesignation,
	   [VendorName]=@VendorName,[ReturnValue]=@ReturnValue,[InvoiceNoReceiptNo]=@InvoiceNoReceiptNo, [WasteCode]=@WasteCode,[StartDate]=@StartDate,
	   [EndDate]=@EndDate		   
	   WHERE RecyclableId = @RecyclableId 	

	   SELECT @RecyclableId as RecyclableId					
	   END
	
END TRY 
BEGIN CATCH  
	INSERT INTO ExceptionLog (  
	ErrorLine, ErrorMessage, ErrorNumber,  
	ErrorProcedure, ErrorSeverity, ErrorState,  
	DateErrorRaised  )  
	SELECT  
	ERROR_LINE () as ErrorLine,  
	Error_Message() as ErrorMessage,  
	Error_Number() as ErrorNumber,  
	Error_Procedure() as 'Sp_HWMS_RecordsofRecyclableWaste_Save',  
	Error_Severity() as ErrorSeverity,  
	Error_State() as ErrorState,  
	GETDATE () as DateErrorRaised  

	SELECT 'Error occured while inserting'
END CATCH 
END
GO
