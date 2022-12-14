USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dss].[GetSubscriptionByUniqueName]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dss].[GetSubscriptionByUniqueName]
    @SyncServerUniqueName nvarchar(256)
AS
    SELECT
        sub.[id],
        sub.[name],
        sub.[creationtime],
        sub.[lastlogintime],
        sub.[tombstoneretentionperiodindays],
        sub.[policyid],
        sub.[WindowsAzureSubscriptionId],
        sub.[EnableDetailedProviderTracing],
        sub.[syncserveruniquename],
        sub.[version]
    from [dss].[subscription] sub where sub.syncserveruniquename = @SyncServerUniqueName
RETURN 0
GO
