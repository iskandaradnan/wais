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
   public class VMMonthClosingDAL: IVMMonthClosingDAL
    {
        private readonly string _FileName = nameof(VMMonthClosingDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();

        public MCLovEntity Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                MCLovEntity Dropdownentityval = new MCLovEntity();

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
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
                            var year = DateTime.Now.Year ;
                            var add = new List<LovValue>();
                             add.Add( new LovValue() { LovId = year, FieldValue = year.ToString() });
                            //Dropdownentityval.Yearlist.Add(add);
                            add.Add(new LovValue() { LovId = year + 1, FieldValue = (year + 1).ToString() });
                            Dropdownentityval.Yearlist=add;
                            var today = DateTime.Today;

                            var MonthLastDay = new DateTime(today.Year, (today.Month+1), 1).AddDays(-1).Day;
                            Dropdownentityval.CutoffDate = new DateTime(today.Year, today.Month, MonthLastDay).Date;
                            Dropdownentityval.CurrentYear = today.Month - 1 <= 0?today.Year-1: today.Year;
                            Dropdownentityval.PreviousMonth = today.Month - 1<=0?12: today.Month - 1;
                        }

                        ds.Clear();
                       

                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return Dropdownentityval;
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

        public FetchMonthClosingDetails Get(FetchMonthClosingDetails entity)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                FetchMonthClosingDetails FetchMonthClosingDetails = new FetchMonthClosingDetails();

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_VmVariationTxn_MonthClosing_GetAll";
                        cmd.Parameters.AddWithValue("@pFacilityId", _UserSession.FacilityId);
                        cmd.Parameters.AddWithValue("@pYear", entity.Year);
                        cmd.Parameters.AddWithValue("@pMonth", entity.Month);
                        cmd.Parameters.AddWithValue("@pPageSize", entity.PageSize);
                        cmd.Parameters.AddWithValue("@pPageIndex", entity.PageIndex);
                        cmd.Parameters.AddWithValue("@pFlag", entity.Flag);
                        cmd.Parameters.AddWithValue("@pServiceId", entity.ServiceId);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0 /*&& ds.Tables[1].Rows.Count > 0
                   && ds.Tables[2].Rows.Count > 0 && ds.Tables[3].Rows.Count > 0*/)
                {
                    //FetchMonthClosingDetails = (from n in ds.Tables[0].AsEnumerable()
                    //                            select new FetchMonthClosingDetails
                    //                            {
                    //                                StockUpdateId = n.Field<int>("StockUpdateId"),
                    //                                CustomerId = n.Field<int>("CustomerId"),
                    //                                //FacilityId = n.Field<int>("FacilityCode"),
                    //                                FacilityCode = n.Field<string>("FacilityCode"),
                    //                                FacilityName = n.Field<string>("FacilityName"),
                    //                                ServiceId = n.Field<int>("ServiceId"),
                    //                                StockUpdateNo = n.Field<string>("StockUpdateNo"),
                    //                                Date = n.Field<DateTime>("Date"),
                    //                                DateUTC = n.Field<DateTime>("DateUTC"),
                    //                                //TotalCost = n.Field<decimal?>("TotalCost"),
                    //                                //SparePartsId = Convert.ToInt32(n["SparePartsId"]),
                    //                                //Timestamp = Convert.ToBase64String((byte[])(n["Timestamp"]))
                    //                            }).FirstOrDefault();

                    FetchMonthClosingDetails.VariationList = (from n in ds.Tables[0].AsEnumerable()
                                                                       select new VariationList
                                                                       {
                                                                           
                                                                           Authorised = Convert.ToInt32(n["Authorised"]),
                                                                           UnAuthorised = Convert.ToInt32(n["UnAuthorised"]),
                                                                           VariationStatus = n.Field<string>("VariationStatus"),
                                                                           

                                                                       }).ToList();

                    

                    //userRegistration.AllLocations = dbAccessDAL.GetLovRecords(ds.Tables[2]);

                    //userRegistration.LeftLocations = (from n in ds.Tables[2].AsEnumerable()
                    //                                  select new LovSelectedVisible
                    //                                  {
                    //                                      LovId = Convert.ToInt32(n["LovId"]),
                    //                                      FieldValue = Convert.ToString(n["FieldValue"]),
                    //                                      IsSelected = false,
                    //                                      IsVisible = false
                    //                                  }).ToList();

                }
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                return FetchMonthClosingDetails;
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
        public VMMonthClosingEntity MonthClose(VMMonthClosingEntity model)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(MonthClose), Level.Info.ToString());

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_VmVariationTxn_MonthClosing_Save";

                       // cmd.Parameters.AddWithValue("@pPageIndex", pageFilter.PageIndex);
                        //cmd.Parameters.AddWithValue("@PageSize", pageFilter.PageSize);
                        //cmd.Parameters.AddWithValue("@strCondition", pageFilter.QueryWhereCondition);
                        //cmd.Parameters.AddWithValue("@strSorting", strOrderBy);
                        cmd.Parameters.AddWithValue("@pFacilityId",  _UserSession.FacilityId);
                        cmd.Parameters.AddWithValue("@pYear", model.Year);
                        cmd.Parameters.AddWithValue("@pMonth", model.Month);
               

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
             
                Log4NetLogger.LogEntry(_FileName, nameof(MonthClose), Level.Info.ToString());
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
        public GridFilterResult Getall(GetallEntity pageFilter)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Getall), Level.Info.ToString());
                GridFilterResult filterResult = null;
                //  pageFilter.PageIndex= pageFilter.PageIndex == 0 ? 1 : pageFilter.PageIndex;
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
                pageFilter.PageIndex = pageFilter.PageIndex <= 0 ? 1 : pageFilter.PageIndex;
                strOrderBy = string.IsNullOrEmpty(strOrderBy) ? pageFilter.SortColumn + " " + pageFilter.SortOrder : strOrderBy;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_VmVariationTxn_MonthClosing_GetAll";

                        cmd.Parameters.AddWithValue("@pPageIndex", pageFilter.PageIndex);
                        //cmd.Parameters.AddWithValue("@PageSize", pageFilter.PageSize);
                        //cmd.Parameters.AddWithValue("@strCondition", pageFilter.QueryWhereCondition);
                        //cmd.Parameters.AddWithValue("@strSorting", strOrderBy);
                        cmd.Parameters.AddWithValue("@pFacilityId", _UserSession.FacilityId);
                        cmd.Parameters.AddWithValue("@pYear",pageFilter.Year);
                        cmd.Parameters.AddWithValue("@pMonth", pageFilter.Month);
                        cmd.Parameters.AddWithValue("@pServiceId", pageFilter.ServiceId);
                        cmd.Parameters.AddWithValue("@pPageSize", pageFilter.PageSize);
                        cmd.Parameters.AddWithValue("@pFlag", pageFilter.Flag);
                        cmd.Parameters.AddWithValue("@pVariationStatus", pageFilter.VariationStatus);
                  
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
                Log4NetLogger.LogExit(_FileName, nameof(Getall), Level.Info.ToString());
                //return userRoles;
                return filterResult;
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
    }
}
