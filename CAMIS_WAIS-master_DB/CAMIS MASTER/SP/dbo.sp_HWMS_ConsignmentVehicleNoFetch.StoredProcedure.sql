USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_HWMS_ConsignmentVehicleNoFetch]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_HWMS_ConsignmentVehicleNoFetch]
(
      @VehicleNo			  nvarchar(50)	=	NULL,
	  @pPageIndex					INT,
	  @pPageSize					INT,
	  @pFacilityId					INT
)
AS                                              

BEGIN TRY
	SET NOCOUNT ON; 

	DECLARE @TotalRecords INT

	
		SELECT		@TotalRecords	=	COUNT(*)
		FROM		HWMS_VehicleDetails A WITH(NOLOCK)
		where  ((ISNULL(@VehicleNo	,'') = '' )	OR (ISNULL(@VehicleNo	,'') <> '' AND VehicleNo	 LIKE + '%' + @VehicleNo + '%' ))
		
		select A.VehicleId,A.VehicleNo, @TotalRecords AS TotalRecords
		FROM		HWMS_VehicleDetails A WITH(NOLOCK)
		where  ((ISNULL(@VehicleNo,'') = '' )	OR (ISNULL(@VehicleNo,'') <> '' AND VehicleNo LIKE + '%' + @VehicleNo + '%' ))
		ORDER BY	A.VehicleId DESC
		OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY 

		END TRY
BEGIN CATCH
	INSERT INTO ErrorLog(
				Spname,
				ErrorMessage,
				createddate)

	VALUES(		OBJECT_NAME(@@PROCID),
				'Error_line: '+CONVERT(VARCHAR(10),	ERROR_LINE())+' - '+ERROR_MESSAGE(),
				GETDATE()
		   )
END CATCH
GO
