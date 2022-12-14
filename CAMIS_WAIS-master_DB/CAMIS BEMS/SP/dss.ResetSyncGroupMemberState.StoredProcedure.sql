USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dss].[ResetSyncGroupMemberState]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dss].[ResetSyncGroupMemberState]
    @SyncGroupMemberID	UNIQUEIDENTIFIER,
    @MemberState		INT,
    @ConditionalMemberState INT
AS
BEGIN
    SET NOCOUNT ON

    UPDATE [dss].[syncgroupmember]
    SET
        [memberstate] = @MemberState,
        [memberstate_lastupdated] = GETUTCDATE()
    WHERE [id] = @SyncGroupMemberID AND [memberstate] = @ConditionalMemberState

    SELECT @@ROWCOUNT
END
GO
