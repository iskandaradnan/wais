using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.DAL.DataAccess.Contracts.VM;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.Model;
using CP.UETrack.Model.VM;
using CP.UETrack.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UETrack.DAL;

namespace CP.UETrack.DAL.DataAccess.Implementations.VM
{
   public class SummaryofFeeReportDAL: ISummaryofFeeReportDAL
    {
        private readonly string _FileName = nameof(SummaryofFeeReportDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();

        public SFRLovEntity Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                SFRLovEntity Dropdownentityval = new SFRLovEntity();

                var ds = new DataSet();
                var dbAccessDALMaster = new MASTERDBAccessDAL();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDALMaster.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Dropdown_Others";
                        cmd.Parameters.AddWithValue("@pLovKey", null);
                        cmd.Parameters.AddWithValue("@pTableName", "FMTimeMonth");
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables.Count != 0)
                        {

                            Dropdownentityval.FMTimeMonth = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                            var year = DateTime.Now.Year;
                            var add = new List<LovValue>();
                            add.Add(new LovValue() { LovId = year-1, FieldValue = (year-1).ToString() });
                            add.Add(new LovValue() { LovId = year, FieldValue = year.ToString() });
                            //Dropdownentityval.Yearlist.Add(add);
                            add.Add(new LovValue() { LovId = year + 1, FieldValue = (year + 1).ToString() });
                            Dropdownentityval.Yearlist = add;
                        }

                        ds.Clear();
                       
                        cmd.Parameters.Clear();
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Dropdown_Others";
                        cmd.Parameters.AddWithValue("@pLovKey", null);
                        cmd.Parameters.AddWithValue("@pTableName", "VMSummaryFee");
                        var da1 = new SqlDataAdapter();
                        da1.SelectCommand = cmd;
                        da1.Fill(ds);

                        if (ds.Tables.Count != 0)
                        {

                            //Dropdownentityval.FMTimeMonth = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                            //var year = DateTime.Now.Year;
                            //var add = new List<LovValue>();
                            //add.Add(new LovValue() { LovId = year, FieldValue = year.ToString() });
                            ////Dropdownentityval.Yearlist.Add(add);
                            //add.Add(new LovValue() { LovId = year + 1, FieldValue = (year + 1).ToString() });
                            //Dropdownentityval.Yearlist = add;

                            Dropdownentityval.AssetClassificationList = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                            //var today = DateTime.Today;

                            //var MonthLastDay = new DateTime(today.Year, today.Month, 1).AddDays(-1).Day;
                            //Dropdownentityval.CutoffDate = new DateTime(today.Year, today.Month, MonthLastDay).Date;
                            //Dropdownentityval.CurrentYear = today.Month - 1 <= 0 ? today.Year - 1 : today.Year;
                            //Dropdownentityval.PreviousMonth = today.Month - 1 <= 0 ? 12 : today.Month - 1;
                        }
                        ds.Clear();

                        cmd.Parameters.Clear();
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Dropdown_Others";
                        cmd.Parameters.AddWithValue("@pLovKey", null);
                        cmd.Parameters.AddWithValue("@pTableName", "ServiceAll");
                        var da2 = new SqlDataAdapter();
                        da2.SelectCommand = cmd;
                        da2.Fill(ds);

                        if (ds.Tables.Count != 0)
                        {
                            Dropdownentityval.ServiceData = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                        }

                    }
               
                    Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                    return Dropdownentityval;
                }
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception e)
            {
                throw;
            }
        }


        public FetchDetails Get(FetchDetails entity, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                ErrorMessage = string.Empty;
                FetchDetails FetchDetails = entity;
                if (entity.RollOverFeeId == 0)
                {


                    var ds = new DataSet();
                    var dbAccessDAL = new DBAccessDAL();
                    using (SqlConnection con = new SqlConnection(dbAccessDAL.DBAccessDALByServiceId_Param(entity.ServiceId)))
                    {
                        using (SqlCommand cmd = new SqlCommand())
                        {
                            cmd.Connection = con;
                            cmd.CommandType = CommandType.StoredProcedure;
                            cmd.CommandText = "uspFM_VMSummaryFeeRpt_Fetch";
                            cmd.Parameters.AddWithValue("@pFacilityId", _UserSession.FacilityId);
                            cmd.Parameters.AddWithValue("@pYear", entity.Year);
                            cmd.Parameters.AddWithValue("@pMonth", entity.Month);
                            cmd.Parameters.AddWithValue("@pServiceId", entity.ServiceId);

                            cmd.Parameters.Add("@pErrorMessage", SqlDbType.NVarChar);
                            cmd.Parameters["@pErrorMessage"].Size = 1000;
                            cmd.Parameters["@pErrorMessage"].Direction = ParameterDirection.Output;

                            var da = new SqlDataAdapter();
                            da.SelectCommand = cmd;
                            da.Fill(ds);

                            ErrorMessage = cmd.Parameters["@pErrorMessage"].Value.ToString();
                        }
                    }
                    if (ErrorMessage == "" && ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                    {
                        FetchDetails.SummaryList = (from n in ds.Tables[0].AsEnumerable()
                                                    select new SummaryEntity
                                                    {

                                                        HospitalName = Convert.ToString(n["Facility_Name"]),
                                                        DuringWarrantytotalFee = n.Field<decimal?>("DWTotalFee"),
                                                        DuringWarrantyCount = n.Field<int?>("DWCOUNT"),
                                                        PostWarrantyCount = n.Field<int?>("PWCOUNT"),
                                                        PostWarrantyTotalFee = n.Field<decimal?>("PWTotalFe"),
                                                        TotalFeePayable = n.Field<decimal?>("Total_Fee"),
                                                    }).ToList();

                    }
                    return FetchDetails;
                }
                else
                {
                    var ds = new DataSet();
                    var dbAccessDAL = new DBAccessDAL();
                    using (SqlConnection con = new SqlConnection(dbAccessDAL.DBAccessDALByServiceId_Param(entity.ServiceId)))
                    {
                        using (SqlCommand cmd = new SqlCommand())
                        {
                            cmd.Connection = con;
                            cmd.CommandType = CommandType.StoredProcedure;
                            cmd.CommandText = "uspFM_VMSummaryFeeRpt_GetById";
                            cmd.Parameters.AddWithValue("@pRollOverID", entity.RollOverFeeId);


                            var da = new SqlDataAdapter();
                            da.SelectCommand = cmd;
                            da.Fill(ds);
                        }
                    }
                    if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0 && ds.Tables[1].Rows.Count > 0)
                    {
                        FetchDetails = (from n in ds.Tables[0].AsEnumerable()
                                        select new FetchDetails
                                        {
                                           Year = n.Field<int?>("Year"),
                                           Month = n.Field<int?>("Month"),
                                        }).FirstOrDefault();

                        FetchDetails.SummaryList = (from n in ds.Tables[1].AsEnumerable()
                                                    select new SummaryEntity
                                                    {
                                                        HospitalName = Convert.ToString(n["Facility_Name"]),
                                                        DuringWarrantytotalFee = n.Field<decimal?>("DWTotalFee"),
                                                        DuringWarrantyCount = n.Field<int?>("DWCOUNT"),
                                                        PostWarrantyCount = n.Field<int?>("PWCOUNT"),
                                                        PostWarrantyTotalFee = n.Field<decimal?>("PWTotalFe"),
                                                        TotalFeePayable = n.Field<decimal?>("Total_Fee"),
                                                        VerifiedBy = Convert.ToString(n["VerifiedBy"]),
                                                        VerifiedDate = Convert.ToString(n["VerifiedDate"]),
                                                        ApprovedBy = Convert.ToString(n["ApprovedBy"]),
                                                        ApprovedDate = Convert.ToString(n["ApprovedDate"]),
                                                    }).ToList();

                    }

                    return FetchDetails;
                }
            }


            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception ex)
            {
                throw;
            }
            finally
                {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            }
        }

        public SFRSaveEntity Save(SFRSaveEntity model)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
                //if (model.Flag == "delete")
                //{
                //   var ErrorMessage = model.ErrorMessage;
                //    Delete(model.ReportId,out ErrorMessage);
                //    return model;
                //}
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.DBAccessDALByServiceId_Param(model.ServiceId)))
                { 
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_VMSummaryFeeRpt_Save";

                        cmd.Parameters.AddWithValue("@pServiceId", model.ServiceId);
                        cmd.Parameters.AddWithValue("@pFacilityId", _UserSession.FacilityId);
                        cmd.Parameters.AddWithValue("@pAssetClassificationId", model.AssetClassificationId);
                        cmd.Parameters.AddWithValue("@pMonth", model.Month);
                        cmd.Parameters.AddWithValue("@pYear", model.Year);
                            cmd.Parameters.AddWithValue("@pRollOverID", model.ReportId);
                        cmd.Parameters.AddWithValue("@pStatusFlag", model.Flag);
                        cmd.Parameters.AddWithValue("@pUserId", _UserSession.UserId);
                        //cmd.Parameters.AddWithValue("@pStatus", model.Status);



                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    model.ReportId = Convert.ToInt32(ds.Tables[0].Rows[0]["RollOverFeeId"]);
                    var getentity = new FetchDetails() { RollOverFeeId = model.ReportId.Value,ServiceId=model.ServiceId };
                    var ErrorMessage = string.Empty;
                    model.SummaryList = Get(getentity, out ErrorMessage).SummaryList;
                }

                    Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
                return model;

            }


            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception ex)
            {
                throw;
            }
        }
        public GridFilterResult GetAll(SortPaginateFilter pageFilter)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
                GridFilterResult filterResult = null;

                var multipleOrderBy = pageFilter.SortColumn.Split(',');
                var strOrderBy = string.Empty;
                foreach (var order in multipleOrderBy)
                {
                    strOrderBy += order + " " + pageFilter.SortOrder + ",";
                }
                if (!string.IsNullOrEmpty(strOrderBy))
                {
                    strOrderBy = strOrderBy.TrimEnd(',');
                }

                strOrderBy = string.IsNullOrEmpty(strOrderBy) ? pageFilter.SortColumn + " " + pageFilter.SortOrder : strOrderBy;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_VMRollOverFeeReport_GetAll";

                        cmd.Parameters.AddWithValue("@PageIndex", pageFilter.PageIndex);
                        cmd.Parameters.AddWithValue("@PageSize", pageFilter.PageSize);
                        cmd.Parameters.AddWithValue("@StrCondition", pageFilter.QueryWhereCondition);
                        cmd.Parameters.AddWithValue("@StrSorting", strOrderBy);
                        cmd.Parameters.AddWithValue("@FacilityId", _UserSession.FacilityId);


                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(ds.Tables[0].Rows[0]["TotalRecords"]);
                    var totalPages = (int)Math.Ceiling((float)totalRecords / (float)pageFilter.Rows);

                    var commonDAL = new CommonDAL();
                    var currentPageList = commonDAL.ToDynamicList(ds.Tables[0]);
                    filterResult = new GridFilterResult
                    {
                        TotalRecords = totalRecords,
                        TotalPages = totalPages,
                        RecordsList = currentPageList,
                        CurrentPage = pageFilter.Page
                    };
                }
                Log4NetLogger.LogExit(_FileName, nameof(GetAll), Level.Info.ToString());
                return filterResult;
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception)
            {
                throw;
            }
        }


        public void Delete(int Id, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
                ErrorMessage = string.Empty;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_VMRollOverFeeReport_Delete";
                        cmd.Parameters.AddWithValue("@pRollOverFeeId", Id);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    ErrorMessage = Convert.ToString(ds.Tables[0].Rows[0]["ErrorMessage"]);
                }
                Log4NetLogger.LogExit(_FileName, nameof(Delete), Level.Info.ToString());
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception)
            {
                throw;
            }
        }

       
    }
}
