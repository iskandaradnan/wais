USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dss].[AgentKeepAlive]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dss].[AgentKeepAlive]
    @AgentId UNIQUEIDENTIFIER,
    @AgentInstanceId UNIQUEIDENTIFIER
AS
BEGIN
    DECLARE @LastAliveTime DATETIME = GETUTCDATE()

    UPDATE [dss].[agent_instance]
    SET
        [lastalivetime] = @LastAliveTime
    WHERE [id] = @AgentInstanceId AND [agentid] = @AgentId

    -- For local agents also update the agent table.
    UPDATE [dss].[agent]
    SET
        [lastalivetime] = @LastAliveTime
    WHERE [id] = @AgentId AND [is_on_premise] = 1

END
GO
