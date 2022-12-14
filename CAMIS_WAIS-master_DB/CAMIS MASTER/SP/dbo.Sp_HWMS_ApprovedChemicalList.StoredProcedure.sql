USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_ApprovedChemicalList]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- exec [dbo].[Sp_CLS_ApprovedChemicalList] 0, 25, 25, 'AirFreshener', 'Kitchen/Engineering', 'FLORIDE','ACITICACID565', 'Flamabul', 1, '2020-01-09', null

CREATE PROC [dbo].[Sp_HWMS_ApprovedChemicalList](
		@ApprovedId int,
		@Customerid int,
		@Facilityid int,
		@Category varchar(50),
		@AreaofApplication varchar(50),
		@ChemicalName varchar(50),
		@KKMNumber varchar(50),
		@Properties varchar(50),
		@Status int,
		@EffectiveFromDate date,
		@EffectiveFTodate date =null
		)
AS
BEGIN 
SET NOCOUNT ON; 
BEGIN TRY

	IF(@ApprovedId = 0)
	BEGIN
		IF(not exists (SELECT 1 FROM HWMS_ApprovedChemicalList WHERE CustomerId = @Customerid and FacilityId = @Facilityid and KKMNumber = @KKMNumber))
			BEGIN
				INSERT INTO HWMS_ApprovedChemicalList values(@Customerid,@Facilityid,@Category,@AreaofApplication,@ChemicalName,
		@KKMNumber,@Properties,@Status, @EffectiveFromDate , @EffectiveFTodate )
			select @@Identity as 'ApprovedId'
			END
		ELSE
			BEGIN
				SELECT 'KKMNumber already exists'
			END		
	END
	ELSE
		BEGIN
		 --UPDATE
		 UPDATE HWMS_ApprovedChemicalList SET Category = @Category, AreaofApplication = @AreaofApplication,ChemicalName=@ChemicalName,KKMNumber=@KKMNumber,
		 Properties=@Properties,Status=@Status,EffectiveFromDate=@EffectiveFromDate WHERE ApprovedId=@ApprovedId
			select @ApprovedId as 'ApprovedId'
		END
		
END TRY 
BEGIN CATCH  

	INSERT INTO ExceptionLog (  
	ErrorLine, ErrorMessage, ErrorNumber,  
	ErrorProcedure, ErrorSeverity, ErrorState,  
	DateErrorRaised  
	)  
	SELECT  
	ERROR_LINE () as ErrorLine,  
	Error_Message() as ErrorMessage,  
	Error_Number() as ErrorNumber,  
	Error_Procedure() as 'Sp_HWMS_ApprovedChemicalList',  
	Error_Severity() as ErrorSeverity,  
	Error_State() as ErrorState,  
	GETDATE () as DateErrorRaised  

	SELECT 'Error occured while inserting'
END CATCH 
END
						
	
GO
