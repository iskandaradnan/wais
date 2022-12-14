USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dss].[GetAgentCredentials]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dss].[GetAgentCredentials]
    @AgentID	UNIQUEIDENTIFIER
AS
BEGIN

    SELECT
        [id],
        [password_hash],
        [password_salt]
    FROM [dss].[agent]
    WHERE [id] = @AgentID

END
GO
