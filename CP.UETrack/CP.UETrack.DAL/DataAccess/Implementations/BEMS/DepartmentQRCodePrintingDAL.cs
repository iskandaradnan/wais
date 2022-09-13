using CP.UETrack.DAL.DataAccess.Contracts.BEMS;
using CP.UETrack.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CP.UETrack.Model.BEMS;
using CP.Framework.Common.Logging;
using UETrack.DAL;
using System.Data;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using System.Data.SqlClient;

namespace CP.UETrack.DAL.DataAccess.Implementations.BEMS
{
    public class DepartmentQRCodePrintingDAL : IDepartmentQRCodePrintingDAL
    {
        private readonly string _FileName = nameof(DepartmentQRCodePrintingDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();        

        public DepartmentQRCodePrintingModel GetModal(DepartmentQRCodePrintingModel DepartmentQR)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
                var entity = new sqlQueryExpressionList();
                var strstring = "";
                var querystrcondition = "";
                int i = 0;
                foreach (var item in DepartmentQR.sqlQueryExpressionListData)
                {
                    i++;
                    var zz = DepartmentQR.sqlQueryExpressionListData.Count;
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

                parameters.Add("@strSorting", Convert.ToString(DepartmentQR.strOrderBy));
                parameters.Add("@strCondition", Convert.ToString(querystrcondition));
              //  parameters.Add("@PageIndex", Convert.ToString(DepartmentQR.PageIndex));
             //   parameters.Add("@PageSize", Convert.ToString(DepartmentQR.PageSize));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));

                DataTable dt = dbAccessDAL.GetDataTable("uspFM_QRCodeUserArea_GetAll", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    DepartmentQR.BlockId = Convert.ToInt32(dt.Rows[0]["BlockId"]);
                }
                DataSet dt1 = dbAccessDAL.GetDataSet("uspFM_QRCodeUserArea_GetAll", parameters, DataSetparameters);
                if (dt != null && dt1.Tables.Count > 0)
                {
                    DepartmentQR.DeptQRCodeListData = (from n in dt1.Tables[0].AsEnumerable()
                                                   select new ItemDeptQRCodeList
                                                   {
                                                       BlockId = Convert.ToInt32(n["BlockId"]),
                                                       BlockName = Convert.ToString(n["BlockName"]),
                                                       LevelId = Convert.ToInt32(n["LevelId"]),
                                                       LevelName = Convert.ToString(n["LevelName"]),
                                                       UserAreaId = Convert.ToInt32(n["UserAreaId"]),
                                                       UserAreaName = Convert.ToString(n["UserAreaName"]),
                                                       //UserLocationName = Convert.ToString(n["UserLocationCode"]),
                                                       DeptQRCode = n["UserAreaQRCode"] == DBNull.Value ? "" : Convert.ToBase64String((byte[])(n["UserAreaQRCode"])),


                                                      // TotalRecords = Convert.ToInt32(n["TotalRecords"]),
                                                      // TotalPages = Convert.ToInt32(n["TotalPageCalc"]),

                                                   }).ToList();
                    //DepartmentQR.DeptQRCodeListData.ForEach((x) => {
                    //    x.PageSize = DepartmentQR.PageSize;
                    //    x.PageIndex = DepartmentQR.PageIndex;
                    //    x.FirstRecord = ((DepartmentQR.PageIndex - 1) * DepartmentQR.PageSize) + 1;
                    //    x.LastRecord = ((DepartmentQR.PageIndex - 1) * DepartmentQR.PageSize) + DepartmentQR.PageSize;
                    //    x.LastPageIndex = x.TotalRecords % DepartmentQR.PageSize == 0 ? x.TotalRecords / DepartmentQR.PageSize : (x.TotalRecords / DepartmentQR.PageSize) + 1;
                    //});
                }
                Log4NetLogger.LogExit(_FileName, nameof(GetAll), Level.Info.ToString());
                return DepartmentQR;
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

        public DepartmentQRCodePrintingModel Save(DepartmentQRCodePrintingModel DepartmentQR)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
                var ServiceId = 2;
                var entity = new ItemDeptQRCodeList();
                var dbAccessDAL = new DBAccessDAL();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));

                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable dt = new DataTable();
                dt.Columns.Add("QRCodeUserAreaId", typeof(int));
                dt.Columns.Add("CustomerId", typeof(int));
                dt.Columns.Add("FacilityId", typeof(int));
                dt.Columns.Add("ServiceId", typeof(int));
                dt.Columns.Add("BlockId", typeof(int));
                dt.Columns.Add("LevelId", typeof(int));
                dt.Columns.Add("UserAreaId", typeof(int));                
                dt.Columns.Add("QRCodeSize1", typeof(byte[]));
                dt.Columns.Add("QRCodeSize2", typeof(byte[]));
                dt.Columns.Add("QRCodeSize3", typeof(byte[]));
                dt.Columns.Add("QRCodeSize4", typeof(byte[]));
                dt.Columns.Add("QRCodeSize5", typeof(byte[]));
                dt.Columns.Add("BatchGenerated", typeof(string));

                //var deletedId = DepartmentQR.DeptQRCodeListData.Where(y => y.IsDeleted).Select(x => x.BlockId).ToList();
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

                //foreach (var i in DepartmentQR.DeptQRCodeListData.Where(y => !y.IsDeleted))
                foreach (var i in DepartmentQR.DeptQRCodeListData)
                {
                    dt.Rows.Add(i.QRCodeUserAreaId, _UserSession.CustomerId, _UserSession.FacilityId, ServiceId, i.BlockId, i.LevelId, i.UserAreaId,
                       Convert.FromBase64String(i.DeptQRCode), null, null, null, null,i.BatchGenerated);

                }
                DataSetparameters.Add("@pQRCodeUserArea", dt);
                DataTable dt1 = dbAccessDAL.GetDataTable("uspFM_QRCodeUserArea_Save", parameters, DataSetparameters);
                if (dt1 != null)
                {
                    foreach (DataRow row in dt1.Rows)
                    {
                        foreach (var val in DepartmentQR.DeptQRCodeListData)

                        {
                            val.QRCodeUserAreaId = Convert.ToInt32(row["QRCodeUserAreaId"]);
                        }
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return DepartmentQR;
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
                        cmd.CommandText = "uspFM_QRCodeUserArea_Delete";
                        cmd.Parameters.AddWithValue("@pQRCodeUserAreaId", id);

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
        public bool IsDepartmentQRCodePrintingModelCodeDuplicate(DepartmentQRCodePrintingModel DepartmentQR)
        {
            throw new NotImplementedException();
        }

        public bool IsRecordModified(DepartmentQRCodePrintingModel DepartmentQR)
        {
            throw new NotImplementedException();
        }

        public DepartmentQRCodePrintingModel Load()
        {
            throw new NotImplementedException();
        }

        public DepartmentQRCodePrintingModel Get(DepartmentQRCodePrintingModel DepartmentQR)
        {
            throw new NotImplementedException();
        }

        public GridFilterResult GetAll(SortPaginateFilter pageFilter)
        {
            throw new NotImplementedException();
        }
    }
}
