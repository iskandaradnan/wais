USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dss].[GetTaskByIdV2]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dss].[GetTaskByIdV2]
    @TaskId UNIQUEIDENTIFIER
AS
BEGIN
    SELECT
        [id],
        [actionid],
        [agentid],
        [request],
        [response],
        [state],
        [retry_count],
        [dependency_count],
        [owning_instanceid],
        [creationtime],
        [pickuptime],
        [priority],
        [type],
        [completedtime],
        [lastheartbeat],
        [lastresettime],
        [taskNumber],
        [version]
    FROM [dss].[task]
    WHERE [id] = @TaskId
END
GO
