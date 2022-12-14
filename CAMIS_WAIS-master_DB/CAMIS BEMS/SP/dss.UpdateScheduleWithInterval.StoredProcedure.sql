USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dss].[UpdateScheduleWithInterval]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dss].[UpdateScheduleWithInterval]
    @SyncGroupId UNIQUEIDENTIFIER,
    @Interval bigint
AS
BEGIN
    UPDATE [dss].[ScheduleTask]
    SET
        Interval = @Interval,
        [ExpirationTime] = DATEADD(SECOND, @Interval, GETUTCDATE()) -- Also update the due time for the task when the interval is updated.
    WHERE [SyncGroupId] = @SyncGroupId
END
GO
