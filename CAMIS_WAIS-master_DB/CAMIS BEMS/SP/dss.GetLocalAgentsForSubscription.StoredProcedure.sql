USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dss].[GetLocalAgentsForSubscription]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dss].[GetLocalAgentsForSubscription]
    @SubscriptionId UNIQUEIDENTIFIER
AS
BEGIN
    -- Q: Active/Inactive?
    SELECT
        a.[id],
        a.[name],
        a.[subscriptionid],
        a.[state],
        a.[lastalivetime],
        a.[is_on_premise],
        a.[version],
        a.[password_hash],
        a.[password_salt]
    FROM [dss].[agent] a
    WHERE a.[subscriptionid] = @SubscriptionId AND a.[is_on_premise] = 1

END
GO
