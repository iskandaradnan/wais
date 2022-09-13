USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dss].[GetAgentVersions]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dss].[GetAgentVersions]
    AS
BEGIN
    SELECT
        [Id],
        [Version],
        [ExpiresOn],
        [Comment]

    FROM [dss].[agent_version]
END
GO
