USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_GetMonth_Rpt]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----[uspFM_GetMonth_Rpt] '1'
CREATE PROCEDURE [dbo].[uspFM_GetMonth_Rpt](@Month           VARCHAR (20))
AS
BEGIN

Set NOCOUNT on

declare @@Month table (
Lov_Label Varchar(50),
Lov_Value Varchar(50)
)

IF LEN(@Month) = 1 
begin

	SET @Month = '0' + @Month

end 

Insert into @@Month(Lov_Value,Lov_Label)
values('All','All' ) ,
('01','January')  ,
('02','February')	,
('03','March')	,
('04','April')	,
('05','May')		,
('06','June')		,
('07','July')		,
('08','August')	,
('09','September'),
('10','October'),
('11','November'),
('12','December')

select Lov_Value as Lov_Value,Lov_Label as Lov_Label from @@Month where Lov_Value=@Month


--drop table @@Month
end
GO
