USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_MstWorkingCalenderDet_Save]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_MstWorkingCalenderDet_Save
Description			: If staff already exists then update else insert.
Authors				: Dhilip V
Date				: 02-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_MstWorkingCalenderDet_Save  @MstWorkingCalenderDetTable=40,@pCalenderId=1,@pCreatedBy=1,@pModifiedBy=1
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Dhilip V Date       :02-April-2018 Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_MstWorkingCalenderDet_Save]
         @MstWorkingCalenderDetTable AS [dbo].[udt_MstWorkingCalenderDet] READONLY,
		 @CustomerId    INT = NULL, 
		 @FacilityId    INT = NULL,
		 @pCalenderId	INT = NULL,
		 @Year	        INT = NULL,
		 @userid	    INT = NULL

AS                                              

BEGIN TRY

	DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	
	DECLARE @Table TABLE (ID INT)

-- Default Values


-- Execution

     Declare @count int= (select COUNT(1) from MstWorkingCalender where [Year] = @Year and FacilityId = @FacilityId and Active= 1)


    IF(@count = 0)

	  BEGIN
	          INSERT INTO MstWorkingCalender(
                            CustomerId
                           ,FacilityId
                           ,Year
                           ,CreatedBy
                           ,CreatedDate
                           ,CreatedDateUTC
                           )OUTPUT INSERTED.CalenderId INTO @Table
			  VALUES (@CustomerId,@FacilityId,@Year,@userid, GETDATE(), GETDATE())


           DECLARE @PRIMARYID INT= ( SELECT CalenderId FROM MstWorkingCalender WHERE CalenderId IN (SELECT ID FROM @Table))
			   INSERT INTO MstWorkingCalenderDet(
                             CalenderId
                            ,Year
                            ,Month
                            ,Day
                            ,IsWorking
                            ,Remarks
                            ,CreatedBy
                            ,CreatedDate
                            ,CreatedDateUTC
                         )
				   SELECT @PRIMARYID, Year, Month, Day,IsWorking, Remarks, @userid, GETDATE(), GETDATE()

				   FROM @MstWorkingCalenderDetTable

      SELECT CalenderId, Timestamp FROM MstWorkingCalender WHERE CalenderId IN (SELECT ID FROM @Table)
      END
	  ELSE
	  BEGIN

	           UPDATE MstWorkingCalender SET 

                              ModifiedBy=@userid
                              ,ModifiedDate = GETDATE()
                               ,ModifiedDateUTC= GETDATE()
			   WHERE CalenderId=@pCalenderId



			   	UPDATE CalenderDet SET
		

							CalenderDet.IsWorking			=	CalenderDetType.IsWorking,
							CalenderDet.Remarks             = CalenderDetType.Remarks,
							CalenderDet.ModifiedBy			=	@userid,
							CalenderDet.ModifiedDate		=	GETDATE(),
							CalenderDet.ModifiedDateUTC		=	GETUTCDATE()
					FROM	MstWorkingCalenderDet CalenderDet 
							INNER JOIN @MstWorkingCalenderDetTable CalenderDetType ON CalenderDet.CalenderDetId	=	CalenderDetType.CalenderDetId
						--	inner join MstWorkingCalender a on a.CalenderId= CalenderDet.CalenderId
					WHERE	CalenderDet.CalenderId=@pCalenderId

					  SELECT CalenderId, Timestamp FROM MstWorkingCalender WHERE CalenderId =@pCalenderId
		END







	IF @mTRANSCOUNT = 0
        BEGIN
            COMMIT TRANSACTION
        END   


END TRY

BEGIN CATCH

	IF @mTRANSCOUNT = 0
        BEGIN
            ROLLBACK TRAN
        END

	INSERT INTO ErrorLog(
				Spname,
				ErrorMessage,
				createddate)
	VALUES(		OBJECT_NAME(@@PROCID),
				'Error_line: '+CONVERT(VARCHAR(10),	error_line())+' - '+error_message(),
				getdate()
		   )

END CATCH
GO
