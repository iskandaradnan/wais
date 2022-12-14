USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_CLS_DeptAreaDispenserSave]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Sp_CLS_DeptAreaDispenserSave]

 

@pDeptAreaId INT, @pUserAreaId int,@pHandPaperTowel int,@pJumboRoll int,
                    @pHandSoap int,@pDeodorant int,@pFootPump int,@pHandDryers int,
                    @pAutoTimerDeodorizer int
AS 
BEGIN
SET NOCOUNT ON;

 

BEGIN TRY
    IF(EXISTS(SELECT 1 FROM CLS_DeptAreaDispenser WHERE UserAreaId = @pUserAreaId ))
    BEGIN 
        UPDATE CLS_DeptAreaDispenser SET DeptAreaId = @pDeptAreaId, HandPaperTowel=@pHandPaperTowel,JumboRoll=@pJumboRoll,HandSoap=@pHandSoap,
                    Deodorant=@pDeodorant,FootPump=@pFootPump,HandDryers=@pHandDryers,AutoTimer=@pAutoTimerDeodorizer
                    WHERE UserAreaId=@pUserAreaId
        SELECT * FROM CLS_DeptAreaDispenser WHERE  UserAreaId = @pUserAreaId
    END 
    ELSE
    BEGIN 
        INSERT INTO CLS_DeptAreaDispenser
        ( [DeptAreaId], [UserAreaId], [HandPaperTowel], [JumboRoll], [HandSoap], [Deodorant], [FootPump], [HandDryers], [AutoTimer] ) 
         VALUES(@pDeptAreaId, @pUserAreaId,@pHandPaperTowel,@pJumboRoll,@pHandSoap,
                        @pDeodorant,@pFootPump,@pHandDryers,@pAutoTimerDeodorizer)
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
    Error_Procedure() as 'Sp_CLS_DeptAreaDispenserSave',
    Error_Severity() as ErrorSeverity,
    Error_State() as ErrorState,
    GETDATE () as DateErrorRaised
END CATCH
END
GO
