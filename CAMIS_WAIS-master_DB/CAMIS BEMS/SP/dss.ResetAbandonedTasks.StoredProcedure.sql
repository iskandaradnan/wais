USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dss].[ResetAbandonedTasks]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dss].[ResetAbandonedTasks]
    @TimeInSeconds	INT
AS
BEGIN
    -- Reset the tasks and set them to ready if we have not received a heartbeat for some time.
    UPDATE [dss].[task]
    SET
        [state] = (CASE [state] WHEN -4 THEN [state] ELSE 0 END), -- 0: ready -4: cancelling
        [retry_count] = 0,
        [owning_instanceid] = NULL,
        [pickuptime] = NULL,
        [response] = NULL,
        [lastheartbeat] = NULL,
        [lastresettime] = GETUTCDATE()
    -- [state] < 0 means task is picked up and not completed yet.
    -- Date comparison will be false if [lastheartbeat] is NULL
    FROM [dss].[task] WITH (FORCESEEK)
    WHERE [state] < 0 AND
    [lastheartbeat] < DATEADD(SECOND, -@TimeInSeconds, GETUTCDATE())
END
GO
