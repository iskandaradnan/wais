USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dss].[DeleteSchedule]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dss].[DeleteSchedule]
    @SyncGroupId UNIQUEIDENTIFIER = NULL
AS
BEGIN
BEGIN TRY
    DELETE
    FROM [dss].[ScheduleTask]
    WHERE [SyncGroupId] = @SyncGroupId

END TRY
BEGIN CATCH
         -- get error infromation and raise error
            EXECUTE [dss].[RethrowError]
        RETURN

END CATCH

END
GO
