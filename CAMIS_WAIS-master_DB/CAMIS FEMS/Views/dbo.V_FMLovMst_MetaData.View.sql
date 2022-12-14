USE [UetrackFemsdbPreProd]
GO
/****** Object:  View [dbo].[V_FMLovMst_MetaData]    Script Date: 20-09-2021 16:54:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE VIEW [dbo].[V_FMLovMst_MetaData]
AS

	SELECT	DISTINCT UserDesignationId		AS LovId,
			'UM'					AS ModuleName,
			'User Registration'		AS ScreenName,
			'UserDesignation'		AS FieldName,
			'UserDesignationValue'	AS LovKey,
			CAST(UserDesignationId AS NVARCHAR(10))				AS FieldCode,
			Designation				AS FieldValue,
			Remarks				AS Remarks,
			NULL					AS ParentId,
			UserDesignationId		AS SortNo,
			Active,
			0 as BuiltIn,
			IsDefault AS  IsDefault,
			'User' AS LovType,
			Timestamp,
			ModifiedDateUTC
	FROM	UserDesignation	
	WHERE	Active	=	1

UNION


	SELECT	DISTINCT UserTypeId		AS LovId,
			'UM'					AS ModuleName,
			'User Registration'		AS ScreenName,
			'UMUserType'			AS FieldName,
			'UMUserTypeValue'		AS LovKey,
			CAST(UserTypeId AS NVARCHAR(10))				AS FieldCode,
			Name					AS FieldValue,
			Name					AS Remarks,
			NULL					AS ParentId,
			UserTypeId				AS SortNo,
			Active,
			BuiltIn,
			0 AS  IsDefault,
			'System' AS LovType,
			Timestamp,
			ModifiedDateUTC
	FROM	UMUserType	
	WHERE	Active	=	1

UNION

	SELECT	DISTINCT QAPIndicatorId		AS LovId,
			'QAP'						AS ModuleName,
			'QAP Indicator'				AS ScreenName,
			'QAPIndicator'				AS FieldName,
			'QAPIndicatorValue'			AS LovKey,
			CAST(QAPIndicatorId AS NVARCHAR(10))				AS FieldCode,
			IndicatorCode				AS FieldValue,
			IndicatorCode				AS Remarks,
			NULL						AS ParentId,
			QAPIndicatorId				AS SortNo,
			Active,
			BuiltIn,
			0 AS  IsDefault,
			'System' AS LovType,
			Timestamp,
			ModifiedDateUTC
	FROM	MstQAPIndicator	
	WHERE	Active	=	1

UNION

	SELECT	DISTINCT IndicatorDetId		AS LovId,
			'KPI'						AS ModuleName,
			'Ded Indicator'				AS ScreenName,
			'DedIndicator'				AS FieldName,
			'DedIndicatorValue'			AS LovKey,
			CAST(IndicatorDetId AS NVARCHAR(10))				AS FieldCode,
			IndicatorNo					AS FieldValue,
			IndicatorNo					AS Remarks,
			NULL						AS ParentId,
			IndicatorDetId				AS SortNo,
			Active,
			BuiltIn,
			0 AS  IsDefault,
			'System' AS LovType,
			Timestamp,
			ModifiedDateUTC
	FROM	MstDedIndicatorDet	
	WHERE	Active	=	1

UNION

	SELECT	DISTINCT IndicatorDetId		AS LovId,
			'KPI'						AS ModuleName,
			'Ded Indicator'				AS ScreenName,
			'DedIndicator'				AS FieldName,
			'DedIndicatorValue'			AS LovKey,
			CAST(IndicatorDetId AS NVARCHAR(10))				AS FieldCode,
			IndicatorNo					AS FieldValue,
			IndicatorNo					AS Remarks,
			NULL						AS ParentId,
			IndicatorDetId				AS SortNo,
			Active,
			BuiltIn,
			0 AS  IsDefault,
			'System' AS LovType,
			Timestamp,
			ModifiedDateUTC
	FROM	MstDedIndicatorDet	
	WHERE	Active	=	1

UNION

	SELECT	DISTINCT SparePartsCategoryId		AS LovId,
			'GM'						AS ModuleName,
			'Spare Parts Category'		AS ScreenName,
			'SparePartsCategory'		AS FieldName,
			'SparePartsCategoryValue'	AS LovKey,
			CAST(SparePartsCategoryId AS NVARCHAR(10))				AS FieldCode,
			Category					AS FieldValue,
			Category					AS Remarks,
			NULL						AS ParentId,
			SparePartsCategoryId		AS SortNo,
			Active,
			BuiltIn,
			0 AS  IsDefault,
			'System' AS LovType,
			Timestamp,
			ModifiedDateUTC
	FROM	[EngSparePartsCategory]	
	WHERE	Active	=	1

UNION

	SELECT	DISTINCT ConfigKeyId		AS LovId,
			'GM'						AS ModuleName,
			'Customer Registration'		AS ScreenName,
			'ConfigKeys'				AS FieldName,
			'ConfigKeysValue'			AS LovKey,
			CAST(ConfigKeyId AS NVARCHAR(10))				AS FieldCode,
			KeyName						AS FieldValue,
			KeyName						AS Remarks,
			NULL						AS ParentId,
			ConfigKeyId					AS SortNo,
			Active,
			BuiltIn,
			0 AS  IsDefault,
			'System' AS LovType,
			Timestamp,
			ModifiedDateUTC
	FROM	FMConfigKeys	
	WHERE	Active	=	1

UNION

	SELECT	DISTINCT FileTypeId		AS LovId,
			'BEMS'						AS ModuleName,
			'Attachment'				AS ScreenName,
			'DocumentFileType'			AS FieldName,
			'DocumentFileTypeValue'		AS LovKey,
			CAST(FileTypeId AS NVARCHAR(10))				AS FieldCode,
			FileType					AS FieldValue,
			Remarks						AS Remarks,
			NULL						AS ParentId,
			FileTypeId					AS SortNo,
			Active,
			0 AS	BuiltIn,
			IsDefault  AS   IsDefault,
			'User' AS LovType,
			Timestamp,
			ModifiedDateUTC
	FROM	FMDocumentFileType	
	WHERE	Active	=	1

UNION

	SELECT	DISTINCT ModuleId			AS LovId,
			'Common'					AS ModuleName,
			'Common'					AS ScreenName,
			'Modules'					AS FieldName,
			'ModulesValue'				AS LovKey,
			CAST(ModuleId AS NVARCHAR(10))				AS FieldCode,
			ModuleName					AS FieldValue,
			ModuleName					AS Remarks,
			NULL						AS ParentId,
			ModuleId					AS SortNo,
			Active,
			BuiltIn,
			0 AS	IsDefault,
			'System' AS LovType,
			Timestamp,
			ModifiedDateUTC
	FROM	FMModules
	WHERE	Active	=	1

UNION

	SELECT	DISTINCT MonthId			AS LovId,
			'Common'					AS ModuleName,
			'Common'					AS ScreenName,
			'TimeMonth'					AS FieldName,
			'TimeMonthValue'			AS LovKey,
			CAST(MonthId AS NVARCHAR(10))				AS FieldCode,
			Month						AS FieldValue,
			Month						AS Remarks,
			NULL						AS ParentId,
			MonthId						AS SortNo,
			Active,
			BuiltIn,
			0 AS	IsDefault,
			'System' AS LovType,
			Timestamp,
			ModifiedDateUTC
	FROM	FMTimeMonth
	WHERE	Active	=	1

UNION

	SELECT	DISTINCT WeekDayId			AS LovId,
			'Common'					AS ModuleName,
			'Common'					AS ScreenName,
			'TimeWeekDay'				AS FieldName,
			'TimeWeekDayValue'			AS LovKey,
			CAST(WeekDayId AS NVARCHAR(10))				AS FieldCode,
			WeekDay						AS FieldValue,
			WeekDay						AS Remarks,
			NULL						AS ParentId,
			WeekDayId					AS SortNo,
			Active,
			BuiltIn,
			0 AS	IsDefault,
			'System' AS LovType,
			Timestamp,
			ModifiedDateUTC
	FROM	FMTimeWeekDay
	WHERE	Active	=	1
	
UNION

	SELECT	DISTINCT UOMId				AS LovId,
			'Common'					AS ModuleName,
			'Common'					AS ScreenName,
			'UOM'						AS FieldName,
			'UOMValue'					AS LovKey,
			CAST(UOMId AS NVARCHAR(10))				AS FieldCode,
			UnitOfMeasurement			AS FieldValue,
			UnitOfMeasurementDescription AS Remarks,
			NULL						AS ParentId,
			UOMId						AS SortNo,
			Active,
			0 BuiltIn,
			IsDefault  AS IsDefault,
			'User' AS LovType,
			Timestamp,
			ModifiedDateUTC
	FROM	FMUOM
	WHERE	Active	=	1
		
--UNION

--	SELECT	DISTINCT SpecializationId								AS LovId,
--			'GM'										AS ModuleName,
--			'Contractor and Vendor'						AS ScreenName,
--			'ContractorandVendorSpecialization'			AS FieldName,
--			'ContractorandVendorSpecializationValue'	AS LovKey,
--			CAST(SpecializationId AS NVARCHAR(10))				AS FieldCode,
--			Specialization								AS FieldValue,
--			Specialization								AS Remarks,
--			NULL										AS ParentId,
--			SpecializationId							AS SortNo,
--			Active,
--			BuiltIn,
--			0 AS	IsDefault,
--			'System' AS LovType,
--			Timestamp,
--			ModifiedDateUTC
--	FROM	MstContractorandVendorSpecialization
--	WHERE	Active	=	1
			
UNION

	SELECT	DISTINCT IssuingBodyId			AS LovId,
			'BEMS'							AS ModuleName,
			'License and Certificate'		AS ScreenName,
			'IssuingBody'					AS FieldName,
			'IssuingBodyValue'				AS LovKey,
			CAST(IssuingBodyId AS NVARCHAR(10))				AS FieldCode,
			IssuingBodyName					AS FieldValue,
			IssuingBodyName					AS Remarks,
			NULL							AS ParentId,
			IssuingBodyId					AS SortNo,
			Active,
			BuiltIn,
			0 AS	IsDefault,
			'System' AS LovType,
			Timestamp,
			ModifiedDateUTC
	FROM	MstIssuingBody
	WHERE	Active	=	1
				
--UNION

--	SELECT	DISTINCT UserCompetencyId	AS LovId,
--			'UM'						AS ModuleName,
--			'User Registration'			AS ScreenName,
--			'UserCompetency'			AS FieldName,
--			'UserCompetencyValue'		AS LovKey,
--			CAST(UserCompetencyId AS NVARCHAR(10))				AS FieldCode,
--			Competency					AS FieldValue,
--			Competency					AS Remarks,
--			NULL						AS ParentId,
--			UserCompetencyId			AS SortNo,
--			Active,
--			BuiltIn,
--			0 AS	IsDefault,
--			'System' AS LovType,
--			Timestamp,
--			ModifiedDateUTC
--	FROM	UserCompetency
--	WHERE	Active	=	1
					
UNION

	SELECT	DISTINCT UserDepartmentId	AS LovId,
			'UM'						AS ModuleName,
			'User Registration'			AS ScreenName,
			'UserDepartment'			AS FieldName,
			'UserDepartmentValue'		AS LovKey,
			CAST(UserDepartmentId AS NVARCHAR(10))				AS FieldCode,
			Department					AS FieldValue,
			Remarks					AS Remarks,
			NULL						AS ParentId,
			UserDepartmentId			AS SortNo,
			Active,
			0 as BuiltIn,
			IsDefault  AS IsDefault,
			'User' AS LovType,
			Timestamp,
			ModifiedDateUTC
	FROM	UserDepartment
	WHERE	Active	=	1
						
UNION

	SELECT	DISTINCT UserGradeId	AS LovId,
			'UM'					AS ModuleName,
			'User Registration'		AS ScreenName,
			'UserGrade'				AS FieldName,
			'UserGradeValue'		AS LovKey,
			CAST(UserGradeId AS NVARCHAR(10))				AS FieldCode,
			UserGrade				AS FieldValue,
			UserGrade				AS Remarks,
			NULL					AS ParentId,
			UserGradeId				AS SortNo,
			Active,
			BuiltIn,
			0 AS	IsDefault,
			'System' AS LovType,
			Timestamp,
			ModifiedDateUTC
	FROM	UserGrade
	WHERE	Active	=	1
						
--UNION

--	SELECT	DISTINCT UserRoleId		AS LovId,
--			'UM'					AS ModuleName,
--			'User Registration'		AS ScreenName,
--			'UserRole'				AS FieldName,
--			'UserRoleValue'			AS LovKey,
--			CAST(UserRoleId AS NVARCHAR(10))				AS FieldCode,
--			UserRole				AS FieldValue,
--			UserRole				AS Remarks,
--			NULL					AS ParentId,
--			UserRoleId				AS SortNo,
--			Active,
--			BuiltIn,
--			0 AS	IsDefault,
--			'System' AS LovType,
--			Timestamp,
--			ModifiedDateUTC
--	FROM	UserRole
--	WHERE	Active	=	1
							
UNION

	SELECT	DISTINCT UserSpecialityId		AS LovId,
			'UM'					AS ModuleName,
			'User Registration'		AS ScreenName,
			'UserRole'				AS FieldName,
			'UserRoleValue'			AS LovKey,
			CAST(UserSpecialityId AS NVARCHAR(10))				AS FieldCode,
			Speciality				AS FieldValue,
			Speciality				AS Remarks,
			NULL					AS ParentId,
			UserSpecialityId		AS SortNo,
			Active,
			BuiltIn,
			0 AS	IsDefault,
			'System' AS LovType,
			Timestamp,
			ModifiedDateUTC
	FROM	UserSpeciality
	WHERE	Active	=	1
GO
