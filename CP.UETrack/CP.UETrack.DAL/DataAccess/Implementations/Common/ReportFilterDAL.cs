using CP.UETrack.DAL.DataAccess.Contracts.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
//using CP.Framework.ReportHelper;
using CP.UETrack.Model;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.UETrack.Model.Common;

namespace CP.UETrack.DAL.DataAccess.Implementations.Common
{
    //public class ReportFilterDAL : IReportFilterDAL
    //{
    //    private readonly string _FileName = nameof(ReportFilterDAL);
    //    readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();

    //    public ReportMasterEntity GetReportParameters(string spName, string reportKeyId)
    //    {
    //        throw new NotImplementedException();
    //        //try
    //        //{
    //        //    Log4NetLogger.LogEntry(_FileName, nameof(GetReportParameters), Level.Info.ToString());
    //        //    var rptEntity = new ReportEntity();
    //        //    var reportMapper = new ReportMapper();
    //        //    using (var context = new ASISReportEntities())
    //        //    {
    //        //        var levelDetailsForParameter = (from rptLevels in context.RptReportLevels
    //        //                                        where rptLevels.ReportKeyId == reportKeyId && rptLevels.SpName == spName
    //        //                                        select rptLevels).FirstOrDefault();

    //        //        var parameterDetails = (from rptParameters in context.RptReportParameters
    //        //                                where rptParameters.LevelKeyId == levelDetailsForParameter.LevelKeyId && rptParameters.ReportKeyId == reportKeyId
    //        //                                select rptParameters).ToList();

    //        //        var paramEntitiesModel = AutoMapper.Mapper.Map<List<RptReportParameters>, List<ReportParameters>>(parameterDetails);

    //        //        foreach (var paramEntity in paramEntitiesModel)
    //        //        {
    //        //            //To get multi parameters
    //        //            if (paramEntity.IsMultiParamHasCondition != null && paramEntity.IsMultiParamHasCondition.Value)
    //        //            {
    //        //                var ReportMultiParameters = (from rptMultiParameters in context.RptReportMultiParameters
    //        //                                             where rptMultiParameters.LevelKeyId == paramEntity.LevelKeyId && rptMultiParameters.ParamKeyId == paramEntity.ParamKeyId && rptMultiParameters.ReportKeyId == reportKeyId
    //        //                                             select rptMultiParameters).ToList();
    //        //                var ReportMultiParametersModel = AutoMapper.Mapper.Map<List<RptReportMultiParameters>, List<ReportMultiParameters>>(ReportMultiParameters);
    //        //                paramEntity.ReportMultiParameters = ReportMultiParametersModel;
    //        //            }
    //        //            else
    //        //            {
    //        //                paramEntity.ReportMultiParameters = null;
    //        //            }

    //        //            //To get backtoSP name
    //        //            var parentReportDetails = (from rptMaster in context.RptReportLevels
    //        //                                       where rptMaster.LevelKeyId == paramEntity.LevelKeyId && rptMaster.ReportKeyId == paramEntity.ReportKeyId
    //        //                                       select rptMaster).FirstOrDefault();

    //        //            var parentLevelId = parentReportDetails.ParentLevelId != null ? Convert.ToInt32(parentReportDetails.ParentLevelId) : 1;
    //        //            rptEntity.ParentReportID = parentLevelId;
    //        //            var prevReportDetails = (from rptMaster in context.RptReportLevels
    //        //                                     where rptMaster.LevelKeyId == parentLevelId && rptMaster.ReportKeyId == paramEntity.ReportKeyId
    //        //                                     select rptMaster).FirstOrDefault();
    //        //            if (prevReportDetails != null)
    //        //            {
    //        //                rptEntity.CurrentReportHeading = string.IsNullOrEmpty(prevReportDetails.ReportHeading) ? string.Empty : prevReportDetails.ReportHeading;
    //        //                rptEntity.BackToSpName = string.IsNullOrEmpty(prevReportDetails.SpName) ? string.Empty : prevReportDetails.SpName;
    //        //            }
    //        //            rptEntity.ParamEntity = paramEntitiesModel;

    //        //            //To get drill through details

    //        //            var reportLevelsCollection = (from reportLevels in context.RptReportLevels
    //        //                                          where reportLevels.LevelKeyId == paramEntity.LevelKeyId && reportLevels.ReportKeyId == paramEntity.ReportKeyId
    //        //                                          select reportLevels).ToList();

    //        //            if (reportLevelsCollection != null)
    //        //            {
    //        //                var reportLevelCollection = AutoMapper.Mapper.Map<List<RptReportLevels>, List<ReportLevel>>(reportLevelsCollection);
    //        //                foreach (var reportLevel in reportLevelCollection)
    //        //                {
    //        //                    if (reportLevel.IsReportHasDrillThrough)
    //        //                    {
    //        //                        var reportDrillDetails = (from reportDrill in context.RptReportDrillThroughDetails
    //        //                                                  where reportDrill.LevelKeyId == paramEntity.LevelKeyId && reportDrill.ReportKeyId == paramEntity.ReportKeyId
    //        //                                                  select reportDrill).ToList();
    //        //                        var reportDrillCollection = AutoMapper.Mapper.Map<List<RptReportDrillThroughDetails>, List<ReportDrill>>(reportDrillDetails);
    //        //                        if (reportDrillCollection != null)
    //        //                        {
    //        //                            var lstReportDrillReportParameterModel = new List<ReportDrillMultiParameters>();
    //        //                            foreach (var reportDrill in reportDrillCollection)
    //        //                            {
    //        //                                var lstReportDrillMultiParameters = new List<RptReportDrillParamDetails>();
    //        //                                if (reportDrill.HasDrillParam != null && reportDrill.HasDrillParam.Value)
    //        //                                {
    //        //                                    if (reportDrill.IsDiffDrillParam != null && reportDrill.IsDiffDrillParam.Value)
    //        //                                    {
    //        //                                        lstReportDrillMultiParameters = (from rptMultiDrillParameters in context.RptReportDrillParamDetails
    //        //                                                                         where rptMultiDrillParameters.ReportKeyId == reportDrill.ReportKeyId.ToString() && rptMultiDrillParameters.DrillKeyId == reportDrill.DrillThroughId
    //        //                                                                         && rptMultiDrillParameters.IsDiffDrillParam == reportDrill.IsDiffDrillParam
    //        //                                                                         select rptMultiDrillParameters).ToList();
    //        //                                    }
    //        //                                    else
    //        //                                    {
    //        //                                        lstReportDrillMultiParameters = (from rptMultiDrillParameters in context.RptReportDrillParamDetails
    //        //                                                                         where rptMultiDrillParameters.ReportKeyId == reportDrill.ReportKeyId.ToString() && rptMultiDrillParameters.IsDiffDrillParam == reportDrill.IsDiffDrillParam
    //        //                                                                         select rptMultiDrillParameters).ToList();
    //        //                                    }
    //        //                                    lstReportDrillReportParameterModel = AutoMapper.Mapper.Map<List<RptReportDrillParamDetails>, List<ReportDrillMultiParameters>>(lstReportDrillMultiParameters);
    //        //                                    reportDrill.ReportDrillMultiParameters = lstReportDrillReportParameterModel;
    //        //                                }
    //        //                                else
    //        //                                    reportDrill.ReportDrillMultiParameters = null;
    //        //                            }
    //        //                        }
    //        //                    }
    //        //                }
    //        //            }
    //        //        }
    //        //    }
    //        //    Log4NetLogger.LogExit(_FileName, nameof(GetReportParameters), Level.Info.ToString());
    //        //    return reportMapper.MapReportEntity(rptEntity);
    //        //}
    //        //catch (DALException dalException)
    //        //{
    //        //    throw new DALException(dalException);
    //        //}
    //        //catch (Exception ex)
    //        //{
    //        //    throw new DALException(ex);
    //        //}
    //    }
    //}
    
}
