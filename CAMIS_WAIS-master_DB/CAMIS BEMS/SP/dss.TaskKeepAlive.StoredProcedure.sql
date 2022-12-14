USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dss].[TaskKeepAlive]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dss].[TaskKeepAlive]
    @TaskId	UNIQUEIDENTIFIER
AS
BEGIN

    DECLARE @State INT
    SELECT @State = 0
    SET NOCOUNT ON

    UPDATE [dss].[task]
    SET [lastheartbeat] = GETUTCDATE(),
        @State = [state]
    WHERE [id] = @TaskId

    -- check if the task is cancelling
    IF (@State <> -4) -- -4: cancelling
        SELECT 1
    ELSE
        SELECT 0

END
GO
