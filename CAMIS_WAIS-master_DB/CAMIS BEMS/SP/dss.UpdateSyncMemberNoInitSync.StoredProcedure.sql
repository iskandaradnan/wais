USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dss].[UpdateSyncMemberNoInitSync]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dss].[UpdateSyncMemberNoInitSync]
    @syncMemberId uniqueidentifier,
    @noInitSync bit
AS
BEGIN
    SET NOCOUNT ON

    UPDATE [dss].[syncgroupmember]
    SET
        [noinitsync] = @noInitSync
    WHERE [id] = @syncMemberId

END
GO
