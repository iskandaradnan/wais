using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.DAL.DataAccess.Contracts.BEMS;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using UETrack.DAL;
using CP.UETrack;
using CP.UETrack.Model.BEMS;
using CP.UETrack.Model;
using System.Linq;

namespace CP.UETrack.DAL.DataAccess.Implementations.BEMS
{
    public class AssetRegisterWarrantyProviderTabDAL : IAssetRegisterWarrantyProviderTabDAL
    {
        private readonly string _FileName = nameof(AssetRegisterWarrantyProviderTabDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();

        public WarrantyProviderCategoryLov Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                WarrantyProviderCategoryLov warrantyProviderCategoryLovs = null;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();

                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Dropdown_Others";
                        cmd.Parameters.AddWithValue("@pTablename", "EngAssetSupplierWarranty");
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables.Count != 0)
                        {
                            warrantyProviderCategoryLovs = new WarrantyProviderCategoryLov();
                            warrantyProviderCategoryLovs.CategoryLovMain = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                            warrantyProviderCategoryLovs.CategoryLovLar = dbAccessDAL.GetLovRecords(ds.Tables[1]);
                            warrantyProviderCategoryLovs.CategoryLovthirdparty = dbAccessDAL.GetLovRecords(ds.Tables[2]);
                        }

                        //ds.Clear();
                        //var AssetRegisterWarrantyProvider = new AssetRegisterWarrantyProvider();
                        //cmd.Parameters.Clear();
                        //cmd.CommandText = "uspFM_EngAssetSupplierWarranty_Fetch";
                        //cmd.Parameters.AddWithValue("@pContractorCode", AssetRegisterWarrantyProvider.SSMNo);
                        //cmd.Parameters.AddWithValue("@pPageIndex", AssetRegisterWarrantyProvider.PageIndex);
                        //cmd.Parameters.AddWithValue("@pPageSize", AssetRegisterWarrantyProvider.PageSize);
                        //da = new SqlDataAdapter();
                        //da.SelectCommand = cmd;
                        //da.Fill(ds);

                        //if (ds.Tables.Count != 0)
                        //{
                        //    LicenseCert = (from n in ds.Tables[0].AsEnumerable()
                        //                   select new AssetRegisterWarrantyProvider
                        //                   {

                        //                   }).ToList();
                        //}
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return warrantyProviderCategoryLovs;
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

        public AssetRegisterWarrantyProvider Save(AssetRegisterWarrantyProvider WarrantyProvider)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            try
            {
                //var userid = 2;
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                var obj = new AssetRegisterWarrantyProvider();
                var parameters = new Dictionary<string, string>();

                //parameters.Add("@pUserId", Convert.ToString(userid));
                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable dt = new DataTable();

                dt.Columns.Add("SupplierWarrantyId", typeof(int));
                dt.Columns.Add("Category", typeof(int));
                dt.Columns.Add("ContractorId", typeof(int));
                dt.Columns.Add("AssetId", typeof(int));
                dt.Columns.Add("UserId", typeof(int));

                var deletedId = WarrantyProvider.AssetRegisterWarrantyProviderTabGrid.Where(y => y.IsDeleted).Select(x => x.SupplierWarrantyId).ToList();
                var idstring = string.Empty;
                if (deletedId.Count() > 0)
                {
                    foreach (var item in deletedId.Select((value, i) => new { i, value }))
                    {
                        idstring += item.value;
                        if (item.i != deletedId.Count() - 1)
                        { idstring += ","; }
                    }
                    Delete(idstring);
                }



                foreach (var val in WarrantyProvider.AssetRegisterWarrantyProviderTabGrid.Where(y => !y.IsDeleted))
                {
                    dt.Rows.Add(val.SupplierWarrantyId, val.CategoryId, val.ContractorId, val.AssetId, _UserSession.UserId);
                }
                DataSetparameters.Add("@WarrantyProviderType", dt);

                DataTable dt1 = dbAccessDAL.GetDataTable("uspFM_EngAssetSupplierWarranty_Save", parameters, DataSetparameters);
                if (dt1 != null)
                {
                    foreach (DataRow row in dt1.Rows)
                    {
                        foreach (var a in WarrantyProvider.AssetRegisterWarrantyProviderTabGrid)
                        {
                            a.SupplierWarrantyId = Convert.ToInt32(row["SupplierWarrantyId"]);
                            a.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                        }
                    }
                }

                //using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                //{
                //    using (SqlCommand cmd = new SqlCommand())
                //    {
                //        cmd.Connection = con;
                //        cmd.CommandType = CommandType.StoredProcedure;
                //        cmd.CommandText = "uspFM_EngAssetSupplierWarranty_Save";
                //        foreach (var a in WarrantyProvider.AssetRegisterWarrantyProviderTabGrid)
                //        {
                //            cmd.Parameters.AddWithValue("@pSupplierWarrantyId", a.SupplierWarrantyId);
                //            cmd.Parameters.AddWithValue("@pCustomerId", 1);
                //            cmd.Parameters.AddWithValue("@pFacilityId", 1);
                //            cmd.Parameters.AddWithValue("@pAssetId", a.AssetId);
                //            cmd.Parameters.AddWithValue("@pCategory", a.CategoryId);
                //            cmd.Parameters.AddWithValue("@pContractorId", a.ContractorId);
                //            cmd.Parameters.AddWithValue("@pActive", a.Active);
                //            cmd.Parameters.AddWithValue("@pBuiltIn", 1);
                //            cmd.Parameters.AddWithValue("@pCreatedBy", 1);
                //            cmd.Parameters.AddWithValue("@pModifiedBy", 1);
                //            var da = new SqlDataAdapter();
                //            da.SelectCommand = cmd;
                //            da.Fill(ds);
                //        }
                //    }
                //}
                //if (ds.Tables.Count != 0)
                //{
                //    foreach (var a in WarrantyProvider.AssetRegisterWarrantyProviderTabGrid)
                //    {
                //        a.SupplierWarrantyId = Convert.ToInt32(ds.Tables[0].Rows[0]["SupplierWarrantyId"]);
                //        a.Timestamp = Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["Timestamp"]));
                //    }
                //}
                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());

                return WarrantyProvider;
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

        public GridFilterResult GetAll(SortPaginateFilter pageFilter)
        {
            return null;
        }

        public AssetRegisterWarrantyProvider Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var warrantyProvider = new AssetRegisterWarrantyProvider();

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_EngAssetSupplierWarranty_GetByAssetId";
                        cmd.Parameters.AddWithValue("@pAssetId", Id);
                        //cmd.Parameters.AddWithValue("@pLovIdSupplierCategory", warrantyProvider.CategoryId);
                        cmd.Parameters.AddWithValue("@pPageIndex", 1);
                        cmd.Parameters.AddWithValue("@pPageSize", 5);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0)
                {
                  var   LicenseCert = (from n in ds.Tables[0].AsEnumerable()
                                   select new AssetRegisterWarrantyProviderGrid
                                   {
                                       CategoryId = Convert.ToInt32(n["CategoryLovId"]),
                                       CustomerId = Convert.ToInt32(n["CustomerId"]),
                                       //Category = Convert.ToString(n["CategoryLovName"]),
                                       ContractorId = Convert.ToInt32(n["ContractorId"]),
                                       SupplierWarrantyId = Convert.ToInt32(n["SupplierWarrantyId"]),
                                       SSMNo = Convert.ToString(n["SSMRegistrationCode"]),
                                       ContractorName = Convert.ToString(n["ContractorName"]),
                                       ContactPerson = Convert.ToString(n["ContactPerson"]),
                                       ContactNo = Convert.ToString(n["TelephoneNo"]),
                                       Email = Convert.ToString(n["Email"]),
                                       FaxNo = Convert.ToString(n["FaxNo"]),
                                       Address = Convert.ToString(n["Address"])
                                   }).ToList();

                    var WarrantyLar = (from n in ds.Tables[1].AsEnumerable()
                                       select new AssetRegisterWarrantyProviderGrid
                                       {
                                           CategoryId = Convert.ToInt32(n["CategoryLovId"]),
                                           CustomerId = Convert.ToInt32(n["CustomerId"]),
                                           //Category = Convert.ToString(n["CategoryLovName"]),
                                           SupplierWarrantyId = Convert.ToInt32(n["SupplierWarrantyId"]),
                                           ContractorId = Convert.ToInt32(n["ContractorId"]),
                                           SSMNo = Convert.ToString(n["SSMRegistrationCode"]),
                                           ContractorName = Convert.ToString(n["ContractorName"]),
                                           ContactPerson = Convert.ToString(n["ContactPerson"]),
                                           ContactNo = Convert.ToString(n["TelephoneNo"]),
                                           Email = Convert.ToString(n["Email"]),
                                           FaxNo = Convert.ToString(n["FaxNo"]),
                                           Address = Convert.ToString(n["Address"])
                                       }).ToList();

                    var WarrantyThird = (from n in ds.Tables[2].AsEnumerable()
                                       select new AssetRegisterWarrantyProviderGrid
                                       {
                                           CategoryId = Convert.ToInt32(n["CategoryLovId"]),
                                           CustomerId = Convert.ToInt32(n["CustomerId"]),
                                           //Category = Convert.ToString(n["CategoryLovName"]),
                                           ContractorId = Convert.ToInt32(n["ContractorId"]),
                                           SupplierWarrantyId = Convert.ToInt32(n["SupplierWarrantyId"]),
                                           SSMNo = Convert.ToString(n["SSMRegistrationCode"]),
                                           ContractorName = Convert.ToString(n["ContractorName"]),
                                           ContactPerson = Convert.ToString(n["ContactPerson"]),
                                           ContactNo = Convert.ToString(n["TelephoneNo"]),
                                           Email = Convert.ToString(n["Email"]),
                                           FaxNo = Convert.ToString(n["FaxNo"]),
                                           Address = Convert.ToString(n["Address"])
                                       }).ToList();

                    if (LicenseCert != null && LicenseCert.Count > 0)
                    {
                        warrantyProvider.AssetRegisterWarrantyProviderTabGrid = LicenseCert;
                    }
                    if (WarrantyLar != null && WarrantyLar.Count > 0)
                    {
                        warrantyProvider.AssetRegisterWarrantyProviderTabGrid1 = WarrantyLar;
                    }
                    if (WarrantyThird != null && WarrantyThird.Count > 0)
                    {
                        warrantyProvider.AssetRegisterWarrantyProviderTabGrid2 = WarrantyThird;
                    }

                }

                if (ds.Tables.Count != 0 && ds.Tables[3].Rows.Count > 0)
                {
                    warrantyProvider.warrantyDetails = (from n in ds.Tables[3].AsEnumerable()
                                                        select new WarrantyDetails
                                                        {
                                                            WarrantyStartDate = n.Field<DateTime?>("WarrantyStartDate"),
                                                            WarrantyEndDate = n.Field<DateTime?>("WarrantyEndDate"),
                                                            WarrantyDuration = n.Field<decimal?>("WarrantyDuration"),
                                                            PurchaseCostRM = n.Field<decimal?>("PurchaseCostRM"),
                                                        }).FirstOrDefault();
                        
                }

                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return warrantyProvider;
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

        public bool IsRoleDuplicate(AssetRegisterWarrantyProvider WarrantyProvider)
        {
            return true;
        }

        public bool IsRecordModified(AssetRegisterWarrantyProvider WarrantyProvider)
        {
            return true;
        }

        public void Delete(string Id)
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
                        cmd.CommandText = "uspFM_EngAssetSupplierWarranty_Delete";
                        cmd.Parameters.AddWithValue("@pSupplierWarrantyId", Id);

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
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
