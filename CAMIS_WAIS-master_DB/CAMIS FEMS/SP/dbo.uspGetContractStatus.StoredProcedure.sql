USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspGetContractStatus]    Script Date: 20-09-2021 16:56:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
EXEC GetContractStatus
*/
CREATE Procedure [dbo].[uspGetContractStatus]
As
BEGIN
SET NOCOUNT ON  
create table  #contract_status 
(    
Lov_Label Varchar(50),
	Lov_Value int
	
)
BEGIN   
	Insert into #contract_status(Lov_Label,Lov_Value) 
values('All','3'),('Valid','1'),('Expired','2')

END 
SELECT * FROM #contract_status

DROP TABLE #contract_status
SET NOCOUNT OFF                                           
END
GO
