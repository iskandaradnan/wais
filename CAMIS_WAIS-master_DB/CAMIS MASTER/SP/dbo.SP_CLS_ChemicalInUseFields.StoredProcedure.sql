USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[SP_CLS_ChemicalInUseFields]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_CLS_ChemicalInUseFields](
        @ChemicalId INT,
		@Customerid INT,
		@Facilityid INT,
		@DocumentNo nvarchar(50) ,
		@Date datetime,
		@Remarks nvarchar(100)=''
				
		)
AS
BEGIN
SET NOCOUNT ON;		
BEGIN TRY
		IF(@ChemicalId = 0)
		BEGIN
		INSERT INTO CLS_ChemicalInUse VALUES(@Customerid,@Facilityid,@DocumentNo,@Date ,@Remarks)
		--SET @NewChemicalID = @@IDENTITY
		SELECT MAX(ChemicalId) as ChemicalId FROM CLS_ChemicalInUse
	
		END
		ELSE
		BEGIN
		
		UPDATE CLS_ChemicalInUse SET DocumentNo = @DocumentNo, Date = @Date,Remarks=@Remarks
	    WHERE ChemicalId=@ChemicalId

	
		SELECT @ChemicalId as ChemicalId 


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
	Error_Procedure() as 'SP_CLS_ChemicalInUseFields',
	Error_Severity() as ErrorSeverity,
	Error_State() as ErrorState,
	GETDATE () as DateErrorRaised
END CATCH
END
GO
