using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.DAL.DataAccess.Contracts.CLS;
using CP.UETrack.Model;
using UETrack.DAL;

namespace CP.UETrack.DAL.DataAccess.Implementations.CLS
{
    public class CLSFetchDAL : ICLSFetchDAL
    {
        private readonly string _FileName = nameof(CLSFetchDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        public List<UserLocationCodeSearch> LocationCodeFetch(UserLocationCodeSearch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LocationCodeFetch), Level.Info.ToString());
                List<UserLocationCodeSearch> result = null;
                var pageIndex = SearchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_MstLocationUserLocation_Fetch";

                        cmd.Parameters.AddWithValue("@pUserLocationCode", SearchObject.UserLocationCode ?? "");
                        if (SearchObject.UserAreaId != 0)
                        {
                            cmd.Parameters.AddWithValue("@pUserAreaId", SearchObject.UserAreaId);
                        }
                        cmd.Parameters.AddWithValue("@pPageIndex", pageIndex);
                        cmd.Parameters.AddWithValue("@pPageSize", pageSize);
                        cmd.Parameters.AddWithValue("@pFacilityId", _UserSession.FacilityId);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(ds.Tables[0].Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + ds.Tables[0].Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in ds.Tables[0].AsEnumerable()
                              select new UserLocationCodeSearch
                              {
                                  UserLocationId = Convert.ToInt32(n["UserLocationId"]),
                                  UserLocationCode = Convert.ToString(n["UserLocationCode"]),
                                  UserLocationName = Convert.ToString(n["UserLocationName"]),
                                  UserAreaId = n.Field<int>("UserAreaId"),
                                  UserAreaCode = Convert.ToString(n["UserAreaCode"]),
                                  UserAreaName = Convert.ToString(n["UserAreaName"]),
                                  LevelName = n.Field<string>("LevelName"),
                                  LevelCode = n.Field<string>("LevelCode"),
                                  BlockName = n.Field<string>("BlockName"),
                                  BlockCode = n.Field<string>("BlockCode"),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();

                }

                Log4NetLogger.LogExit(_FileName, nameof(LocationCodeFetch), Level.Info.ToString());
                return result;
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
