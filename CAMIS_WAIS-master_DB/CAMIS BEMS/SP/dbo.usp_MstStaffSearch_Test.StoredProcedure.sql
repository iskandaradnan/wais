USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[usp_MstStaffSearch_Test]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_MstStaffSearch_Test]
    @PageNo            INT = 1,
    @PageSize           INT = 5,
    @StaffEmpId          INT = NULL, 
    @StaffName          NVARCHAR(50) = NULL, 
    @EmailAddress       NVARCHAR(50) = NULL, 
    @AccessLevel     INT = NULL

AS
BEGIN TRY

	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

    DECLARE
        @lStaffEmpId INT, 
        @lStaffName NVARCHAR(50), 
        @lEmailAddress NVARCHAR(50), 
        @lAccessLevel INT,
        @lPageNo   INT,
        @lPageSize  INT,
        @lFirstRec  INT,
        @lLastRec   INT,
        @lTotalRows INT
 
    SET @lStaffEmpId         = @StaffEmpId
    SET @lStaffName         = LTRIM(RTRIM(@StaffName))
    SET @lEmailAddress      = LTRIM(RTRIM(@EmailAddress))
    SET @lAccessLevel    = @lAccessLevel 
    SET @lPageNo   = @PageNo
    SET @lPageSize  = @PageSize     
    SET @lFirstRec  = ( @lPageNo - 1 ) * @lPageSize
    SET @lLastRec   = ( @lPageNo * @lPageSize + 1 ) 
    SET @lTotalRows = @lFirstRec - @lLastRec + 1
 
    ; WITH CTE_Results
    AS (
        SELECT	ROW_NUMBER() OVER (ORDER BY StaffEmployeeId) AS ROWNUM,
				FacilityId,
				StaffMasterId, 
				StaffEmployeeId, 
				StaffName, 
				StaffRoleId,
				Email ,
				AccessLevel
        FROM	MstStaff
        WHERE
				(@lStaffEmpId IS NULL OR StaffEmployeeId = @lStaffEmpId)
				AND (@lStaffName IS NULL OR staffName LIKE '%' + @lStaffName + '%')
				AND (@lEmailAddress IS NULL OR Email LIKE '%' + @lEmailAddress + '%')
				AND (@lAccessLevel IS NULL OR AccessLevel = @lAccessLevel)
		)
		SELECT	StaffMasterId, 
				StaffEmployeeId, 
				StaffName, 
				Email, 
				AccessLevel
		FROM		CTE_Results AS CPC
		WHERE
				ROWNUM > @lFirstRec 
				AND	ROWNUM < @lLastRec
		ORDER BY ROWNUM ASC
 
END TRY
BEGIN CATCH
	THROW
END CATCH
RETURN
GO
