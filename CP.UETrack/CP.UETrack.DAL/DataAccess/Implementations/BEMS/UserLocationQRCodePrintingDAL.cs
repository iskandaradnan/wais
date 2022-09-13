using CP.UETrack.DAL.DataAccess.Contracts.BEMS;
using CP.UETrack.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CP.UETrack.Model.BEMS;
using CP.Framework.Common.Logging;
using System.Data;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using UETrack.DAL;
using System.Data.SqlClient;

namespace CP.UETrack.DAL.DataAccess.Implementations.BEMS
{
    public class UserLocationQRCodePrintingDAL: IUserLocationQRCodePrintingDAL
    {
        private readonly string _FileName = nameof(UserLocationQRCodePrintingDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();

        public UserLocationQRCodePrintingModel GetModal(UserLocationQRCodePrintingModel LocationQR)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
                var strstring = "";
                var querystrcondition = "";
                int i = 0;
                foreach (var item in LocationQR.sqlQueryExpressionListData)
                {
                    i++;
                    var zz = LocationQR.sqlQueryExpressionListData.Count;
                    if (item.GroupOp == "AND")
                    {
                        if (zz != 1 && i != 1)
                        {
                            strstring += " and ";
                        }
                    }
                    if (item.GroupOp == "OR")
                    {
                        if (zz != 1 && i != 1)
                        {
                            strstring += " or ";
                        }
                    }
                    if (item.ConditionName == "ne")
                    {
                        strstring += ("(" + "[" + item.ModelName + "]" + " != " + "(\'" + item.TextName + "\')" + ")");
                    }
                    else if (item.ConditionName == "cn")
                    {
                        strstring += ("(" + "[" + item.ModelName + "]" + " LIKE " + "(" + "\'" + "%" + item.TextName + "%" + "\'" + ")" + ")");
                    }
                    else if (item.ConditionName == "eq")
                    {
                        strstring += ("(" + "[" + item.ModelName + "]" + " = " + "(\'" + item.TextName + "\')" + ")");
                    }
                    else if (item.ConditionName == "bw")
                    {
                        strstring += ("(" + "[" + item.ModelName + "]" + " LIKE " + "(" + "\'" + item.TextName + "%" + "\'" + ")" + ")");
                    }
                    else if (item.ConditionName == "ew")
                    {
                        strstring += ("(" + "[" + item.ModelName + "]" + " LIKE " + "(" + "\'" + "%" + item.TextName + "\'" + ")" + ")");
                    }

                }
                querystrcondition = strstring;
                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();

                parameters.Add("@strSorting", Convert.ToString(LocationQR.strOrderBy));
                parameters.Add("@strCondition", Convert.ToString(querystrcondition));
             //   parameters.Add("@PageIndex", Convert.ToString(LocationQR.PageIndex));
             //   parameters.Add("@PageSize", Convert.ToString(LocationQR.PageSize));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));

                DataTable dt = dbAccessDAL.GetDataTable("uspFM_QRCodeUserLocation_GetAll", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    LocationQR.BlockId = Convert.ToInt32(dt.Rows[0]["BlockId"]);
                }
                DataSet dt1 = dbAccessDAL.GetDataSet("uspFM_QRCodeUserLocation_GetAll", parameters, DataSetparameters);
                if (dt != null && dt1.Tables.Count > 0)
                {
                    LocationQR.LocationQRCodeListData = (from n in dt1.Tables[0].AsEnumerable()
                                                       select new ItemLocationQRCodeList
                                                       {
                                                           BlockId = Convert.ToInt32(n["BlockId"]),
                                                           BlockName = Convert.ToString(n["BlockName"]),
                                                           LevelId = Convert.ToInt32(n["LevelId"]),
                                                           LevelName = Convert.ToString(n["LevelName"]),
                                                           UserAreaId = Convert.ToInt32(n["UserAreaId"]),
                                                           UserAreaName = Convert.ToString(n["UserAreaName"]),
                                                           UserLocationId = Convert.ToInt32(n["UserLocationId"]),
                                                           UserLocationCode = Convert.ToString(n["UserLocationCode"]),
                                                           UserLocationName = Convert.ToString(n["UserLocationName"]),
                                                           UserLocationQRCode = n["UserLocationQRCode"] == DBNull.Value ? "" : Convert.ToBase64String((byte[])(n["UserLocationQRCode"])),

                                                         //  TotalRecords = Convert.ToInt32(n["TotalRecords"]),
                                                         //  TotalPages = Convert.ToInt32(n["TotalPageCalc"]),
                                                       }).ToList();
                    //LocationQR.LocationQRCodeListData.ForEach((x) => {
                    //    x.PageSize = LocationQR.PageSize;
                    //    x.PageIndex = LocationQR.PageIndex;
                    //    x.FirstRecord = ((LocationQR.PageIndex - 1) * LocationQR.PageSize) + 1;
                    //    x.LastRecord = ((LocationQR.PageIndex - 1) * LocationQR.PageSize) + LocationQR.PageSize;
                    //    x.LastPageIndex = x.TotalRecords % LocationQR.PageSize == 0 ? x.TotalRecords / LocationQR.PageSize : (x.TotalRecords / LocationQR.PageSize) + 1;
                    //});
                }
                Log4NetLogger.LogExit(_FileName, nameof(GetAll), Level.Info.ToString());
                return LocationQR;
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public UserLocationQRCodePrintingModel Save(UserLocationQRCodePrintingModel LocationQR)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
                var ServiceId = 2;
                var entity = new ItemLocationQRCodeList();
                var dbAccessDAL = new DBAccessDAL();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));

                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable dt = new DataTable();
                dt.Columns.Add("QRCodeUserLocationId", typeof(int));
                dt.Columns.Add("CustomerId", typeof(int));
                dt.Columns.Add("FacilityId", typeof(int));
                dt.Columns.Add("ServiceId", typeof(int));
                dt.Columns.Add("BlockId", typeof(int));
                dt.Columns.Add("LevelId", typeof(int));
                dt.Columns.Add("UserAreaId", typeof(int));
                dt.Columns.Add("UserLocationId", typeof(int));
                dt.Columns.Add("QRCodeSize1", typeof(byte[]));
                dt.Columns.Add("QRCodeSize2", typeof(byte[]));
                dt.Columns.Add("QRCodeSize3", typeof(byte[]));
                dt.Columns.Add("QRCodeSize4", typeof(byte[]));
                dt.Columns.Add("QRCodeSize5", typeof(byte[]));
                // dt.Columns.Add("BatchGenerated", typeof(string));

                //var deletedId = LocationQR.LocationQRCodeListData.Where(y => y.IsDeleted).Select(x => x.BlockId).ToList();
                //var idstring = string.Empty;
                //if (deletedId.Count() > 0)
                //{
                //    foreach (var item in deletedId.Select((value, i) => new { i, value }))
                //    {
                //        idstring += item.value;
                //        if (item.i != deletedId.Count() - 1)
                //        { idstring += ","; }
                //    }
                //    deleteChildRecords(idstring);
                //}

                //foreach (var i in LocationQR.LocationQRCodeListData.Where(y => !y.IsDeleted))
                foreach (var i in LocationQR.LocationQRCodeListData)
                {
                    dt.Rows.Add(i.QRCodeUserLocationId, _UserSession.CustomerId, _UserSession.FacilityId, ServiceId, i.BlockId, i.LevelId, i.UserAreaId,i.UserLocationId,
                        Convert.FromBase64String(i.UserLocationQRCode),null, null, null, null);

                }
                DataSetparameters.Add("@pQRCodeUserLocation", dt);
                DataTable dt1 = dbAccessDAL.GetDataTable("uspFM_QRCodeUserLocation_Save", parameters, DataSetparameters);
                if (dt1 != null)
                {
                    foreach (DataRow row in dt1.Rows)
                    {
                        foreach (var val in LocationQR.LocationQRCodeListData)

                        {
                            val.QRCodeUserLocationId = Convert.ToInt32(row["QRCodeUserLocationId"]);
                        }
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return LocationQR;
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void deleteChildRecords(string id)
        {
            try
            {
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_QRCodeUserLocation_Delete";
                        cmd.Parameters.AddWithValue("@pQRCodeUserLocationId", id);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
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

        public UserLocationQRCodePrintingModel Get(UserLocationQRCodePrintingModel LocationQR)
        {
            throw new NotImplementedException();
        }

        public GridFilterResult GetAll(SortPaginateFilter pageFilter)
        {
            throw new NotImplementedException();
        }        

        public bool IsRecordModified(UserLocationQRCodePrintingModel LocationQR)
        {
            throw new NotImplementedException();
        }

        public bool IsUserLocationQRCodePrintingCodeDuplicate(UserLocationQRCodePrintingModel LocationQR)
        {
            throw new NotImplementedException();
        }

        public UserLocationQRCodePrintingModel Load()
        {
            throw new NotImplementedException();
        }
    }
}
