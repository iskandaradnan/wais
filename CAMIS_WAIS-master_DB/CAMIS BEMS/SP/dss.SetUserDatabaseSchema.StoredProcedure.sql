USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dss].[SetUserDatabaseSchema]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dss].[SetUserDatabaseSchema]
    @DatabaseId UNIQUEIDENTIFIER,
    @AgentId UNIQUEIDENTIFIER,
    @DbSchema dss.DB_SCHEMA
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM [dss].[userdatabase] WHERE [id] = @DatabaseId AND [agentid] = @AgentId)
    BEGIN
        RAISERROR('INVALID_DATABASE', 15, 1)
        RETURN
    END

    UPDATE [dss].[userdatabase]
    SET
        [db_schema] = @DbSchema,
        [last_schema_updated] = GETUTCDATE()
    WHERE [id] = @DatabaseId

    RETURN @@ROWCOUNT
END
GO
