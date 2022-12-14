USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dss].[SetDatabaseRegion]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dss].[SetDatabaseRegion]
    @DatabaseID	UNIQUEIDENTIFIER,
    @Region nvarchar(256)
AS
BEGIN
    UPDATE [dss].[userdatabase]
    SET
        [region] = @Region
    WHERE [id] = @DatabaseID
END
GO
