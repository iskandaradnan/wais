USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_CLS_DeptAreaDetailsDisplayHospitalRepresentative]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_CLS_DeptAreaDetailsDisplayHospitalRepresentative](@pHospitalRepresentative varchar(75))
as
begin
select Hospitalrepresentativedesignation from CLS_DeptAreaDetails where Hospitalrepresentative=@pHospitalRepresentative
end
GO
