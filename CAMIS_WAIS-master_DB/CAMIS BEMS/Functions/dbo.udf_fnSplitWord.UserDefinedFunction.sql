USE [UetrackBemsdbPreProd]
GO
/****** Object:  UserDefinedFunction [dbo].[udf_fnSplitWord]    Script Date: 20-09-2021 17:09:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[udf_fnSplitWord] 
(
 @Word VARCHAR(MAX)
) 
RETURNS @output TABLE(ID INT IDENTITY(1,1),SplitWord NVARCHAR(MAX))
BEGIN

 DECLARE @t VARCHAR(MAX)
 DECLARE @I INT 
    SELECT @I = 1 
    WHILE(@I < LEN(@Word)+1)
    BEGIN

      SELECT @t = SUBSTRING(@Word,@I,1)  
	  INSERT INTO @output (SplitWord) 
      SELECT @t
      SET @I = @I + 1
	END
	RETURN
END
GO
