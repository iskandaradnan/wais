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
using CP.UETrack.DAL.DataAccess.Implementation;

namespace CP.UETrack.DAL.DataAccess.Implementations.BEMS
{
    public class AssetQRCodePrintDAL : IAssetQRCodePrintDAL
    {
        private readonly string _FileName = nameof(AssetQRCodePrintDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        
        public AssetQRCodePrintModel GetModal(AssetQRCodePrintModel AssetQR)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
                var entity = new sqlQueryExpressionList();
                var strstring = "";
                var querystrcondition = "";                
                int i = 0;
                foreach(var item in AssetQR.sqlQueryExpressionListData)
                {
                    i++;
                    var zz = AssetQR.sqlQueryExpressionListData.Count;
                    if (item.GroupOp == "AND")
                    {                        
                        if (zz!=1 && i!=1 )
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

                parameters.Add("@strSorting", Convert.ToString(AssetQR.strOrderBy));
                parameters.Add("@strCondition", Convert.ToString(querystrcondition));
                //parameters.Add("@PageIndex", Convert.ToString(AssetQR.PageIndex));
                //parameters.Add("@PageSize", Convert.ToString(AssetQR.PageSize));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));

                DataTable dt = dbAccessDAL.GetDataTable("uspFM_QRCodeAsset_GetAll", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    AssetQR.AssetId = Convert.ToInt32(dt.Rows[0]["AssetId"]);
                    AssetQR.AssetNo = Convert.ToString(dt.Rows[0]["AssetNo"]);                                     
                }
                DataSet dt1 = dbAccessDAL.GetDataSet("uspFM_QRCodeAsset_GetAll", parameters, DataSetparameters);
                if (dt != null && dt1.Tables.Count > 0)
                {
                    AssetQR.AssetQRCodeListData = (from n in dt1.Tables[0].AsEnumerable()
                                                   select new ItemAssetQRCodeList
                                                   {
                                                       AssetId = Convert.ToInt32(n["AssetId"]),
                                                       AssetNo = Convert.ToString(n["AssetNo"]),
                                                       UserAreaId = Convert.ToInt32(n["UserAreaId"]),
                                                       UserLocationId = Convert.ToInt32(n["UserLocationId"]),
                                                       UserAreaName = Convert.ToString(n["UserAreaName"]),
                                                       UserLocationName = Convert.ToString(n["UserLocationName"]),
                                                       AssetDescription = Convert.ToString(n["AssetDescription"]),
                                                       AssetTypeCode = Convert.ToString(n["AssetTypeCode"]),
                                                       Manufacturer = Convert.ToString(n["Manufacturer"]),
                                                       Model = Convert.ToString(n["Model"]),
                                                       ContractType = Convert.ToString(n["ContractType"]),
                                                       AssetQRCode = n["AssetQRCode"] == DBNull.Value ? "" : Convert.ToBase64String((byte[])(n["AssetQRCode"])),
                                                       
                                                       //TotalRecords = Convert.ToInt32(n["TotalRecords"]),
                                                       //TotalPages = Convert.ToInt32(n["TotalPageCalc"])                                                          
                                                    }).ToList();
                    //AssetQR.AssetQRCodeListData.ForEach((x) => {
                    //    x.PageSize = AssetQR.PageSize;
                    //    x.PageIndex = AssetQR.PageIndex;
                    //    x.FirstRecord = ((AssetQR.PageIndex - 1) * AssetQR.PageSize) + 1;
                    //    x.LastRecord = ((AssetQR.PageIndex - 1) * AssetQR.PageSize) + AssetQR.PageSize;
                    //    x.LastPageIndex = x.TotalRecords % AssetQR.PageSize == 0 ? x.TotalRecords / AssetQR.PageSize : (x.TotalRecords / AssetQR.PageSize) + 1;
                    //});
                }
                Log4NetLogger.LogExit(_FileName, nameof(GetAll), Level.Info.ToString());                
                return AssetQR;
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

        public AssetQRCodePrintModel Save(AssetQRCodePrintModel AssetQR)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
                var entity = new ItemAssetQRCodeList();
                var ServiceId = 2;
                var commonDAL = new CommonDAL();          
                //byte[] image = commonDAL.GenerateQRCode("iutiuyyiuyuyiuy");
                var dbAccessDAL = new DBAccessDAL();
                var parameters = new Dictionary<string, string>();                
                parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));                            

                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable dt = new DataTable();
                dt.Columns.Add("QRCodeAssetId", typeof(int));
                dt.Columns.Add("CustomerId", typeof(int));
                dt.Columns.Add("FacilityId", typeof(int));
                dt.Columns.Add("ServiceId", typeof(int));
                dt.Columns.Add("UserAreaId", typeof(int));                
                dt.Columns.Add("UserLocationId", typeof(int));
                dt.Columns.Add("AssetId", typeof(int));
                dt.Columns.Add("AssetNo", typeof(string));
                dt.Columns.Add("QRCodeSize1", typeof(byte[]));
                dt.Columns.Add("QRCodeSize2", typeof(byte[]));
                dt.Columns.Add("QRCodeSize3", typeof(byte[]));
                dt.Columns.Add("QRCodeSize4", typeof(byte[]));
                dt.Columns.Add("QRCodeSize5", typeof(byte[]));            

                //var deletedId = AssetQR.AssetQRCodeListData.Where(y => y.IsDeleted).Select(x => x.AssetId).ToList();
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

                //foreach (var i in AssetQR.AssetQRCodeListData.Where(y => !y.IsDeleted))
                foreach (var i in AssetQR.AssetQRCodeListData)
                {
                    dt.Rows.Add(i.QRCodeAssetId, _UserSession.CustomerId, _UserSession.FacilityId, ServiceId, i.UserAreaId, i.UserLocationId, i.AssetId, 
                        i.AssetNo,Convert.FromBase64String(i.AssetQRCode), null, null, null, null);
                    
                }
                DataSetparameters.Add("@pQRCodeAsset", dt);
                DataTable dt1 = dbAccessDAL.GetDataTable("uspFM_QRCodeAsset_Save", parameters, DataSetparameters);
                if (dt1 != null)
                {
                    foreach (DataRow row in dt1.Rows)
                    {
                        foreach (var val in AssetQR.AssetQRCodeListData)

                        {
                            val.QRCodeAssetId = Convert.ToInt32(row["QRCodeAssetId"]);                            
                        }
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return AssetQR;
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
                        cmd.CommandText = "uspFM_QRCodeAsset_Delete";
                        cmd.Parameters.AddWithValue("@pQRCodeAssetId", id);

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


        public bool IsAssetQRCodePrintCodeDuplicate(AssetQRCodePrintModel AssetQR)
        {
            throw new NotImplementedException();
        }

        public bool IsRecordModified(AssetQRCodePrintModel AssetQR)
        {
            throw new NotImplementedException();
        }

        public AssetQRCodePrintModel Load()
        {
            throw new NotImplementedException();
        }

        public AssetQRCodePrintModel Get(AssetQRCodePrintModel AssetQR)
        {
            throw new NotImplementedException();
        }

        public GridFilterResult GetAll(SortPaginateFilter pageFilter)
        {
            throw new NotImplementedException();
        }

        public bool Delete(int Id)
        {
            throw new NotImplementedException();
        }
    }
}
