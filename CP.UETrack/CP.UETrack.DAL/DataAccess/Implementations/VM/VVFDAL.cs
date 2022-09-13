using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.DAL.DataAccess.Contracts.VM;
using CP.UETrack.DAL.DataAccess.Implementations.BEMS;
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
    public class VVFDAL : IVVFDAL
    {
        private readonly string _FileName = nameof(VVFDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        public LoadEntity Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                LoadEntity Dropdownentityval = new LoadEntity();

                var ds = new DataSet();
                var ds1 = new DataSet();
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
                            add.Add(new LovValue() { LovId = year, FieldValue = year.ToString() });
                            add.Add(new LovValue() { LovId = year + 1, FieldValue = (year + 1).ToString() });
                            add.Add(new LovValue() { LovId = year + 2, FieldValue = (year + 2).ToString() });
                            Dropdownentityval.Yearlist = add;
                            var today = DateTime.Today;


                            Dropdownentityval.CurrentYear = today.Month - 1 <= 0 ? today.Year - 1 : today.Year;
                            Dropdownentityval.PreviousMonth = today.Month - 1 <= 0 ? 12 : today.Month - 1;
                        }

                        cmd.CommandText = "uspFM_Dropdown_Others";
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@pLovKey", null);
                        cmd.Parameters.AddWithValue("@pTableName", "ServiceAll");
                        var dap = new SqlDataAdapter();
                        dap.SelectCommand = cmd;
                        dap.Fill(ds1);

                        if (ds1.Tables.Count != 0)
                        {
                            Dropdownentityval.ServiceData = dbAccessDAL.GetLovRecords(ds1.Tables[0]);
                        }

                        ds.Clear();
                        ds1.Clear();


                        var da1 = new SqlDataAdapter();
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Dropdown";
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@pLovKey", "VariationStatusValue,ActionStatusValue,WorkFlowStatusValue");
                        da1.SelectCommand = cmd;
                        da1.Fill(ds);

                        if (ds.Tables.Count != 0)
                        {

                            Dropdownentityval.VariationStatusValue = dbAccessDAL.GetLovRecords(ds.Tables[0], "VariationStatusValue");
                            Dropdownentityval.WorkFlowStatusList = dbAccessDAL.GetLovRecords(ds.Tables[0], "WorkFlowStatusValue");
                            Dropdownentityval.ActionList = dbAccessDAL.GetLovRecords(ds.Tables[0], "ActionStatusValue");
                            
                            // Dropdownentityval.ActionList.AddRange(dbAccessDAL.GetLovRecords(ds.Tables[0], "YesNoValue"));

                        }


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
        public VVFDetails Get(VVFDetails entity)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                VVFDetails VVFDetails = new VVFDetails();

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                int serviceid = Convert.ToInt32( entity.ServiceId);
                using (SqlConnection con = new SqlConnection(dbAccessDAL.DBAccessDALByServiceId_Param(serviceid)))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;                        
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_VmVariationTxnVVF_GetAll";
                        cmd.Parameters.AddWithValue("@pFacilityId", _UserSession.FacilityId);
                        cmd.Parameters.AddWithValue("@pYear", entity.Year);
                        cmd.Parameters.AddWithValue("@pMonth", entity.Month);
                        cmd.Parameters.AddWithValue("@pPageSize", entity.PageSize);
                        cmd.Parameters.AddWithValue("@pPageIndex", entity.Pageindex);
                        cmd.Parameters.AddWithValue("@pVariationStatus", entity.VariationStatusId);
                        cmd.Parameters.AddWithValue("@pVariationApprovedStatus", null);
                        cmd.Parameters.AddWithValue("@pVariationWFStatus", entity.WorkFlowStatusId);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {


                    VVFDetails.VatiationDetailList = (from n in ds.Tables[0].AsEnumerable()
                                                      select new VatiationDetailList
                                                      {
                                                          VariationId = n.Field<int?>("VariationId"),
                                                          UserAreaName = n.Field<string>("UserAreaName"),
                                                          VariationStatus = n.Field<string>("VariationStatus"),
                                                          AssetNo = n.Field<string>("AssetNo"),
                                                          Manufacturer = n.Field<string>("Manufacturer"),
                                                          Model = n.Field<string>("Model"),
                                                          PurchaseCost = n.Field<decimal?>("PurchaseCost"),
                                                          StartServiceDate = n.Field<DateTime?>("StartServiceDate"),
                                                          WarrantyExpiryDate = n.Field<DateTime?>("WarrantyExpiryDate"),
                                                          StopServiceDate = n.Field<DateTime?>("StopServiceDate"),
                                                          MaintenanceRateDW = n.Field<decimal?>("MaintenanceRateDW"),
                                                          MaintenanceRatePW = n.Field<decimal?>("MaintenanceRatePW"),
                                                          MonthlyProposedFeeDW = n.Field<decimal?>("MonthlyProposedFeeDW"),
                                                          MonthlyProposedFeePW = n.Field<decimal?>("MonthlyProposedFeePW"),
                                                          CountingDays = n.Field<decimal>("CountingDays"),
                                                          Action = n.Field<int?>("Action"),
                                                          Remarks = n.Field<string>("Remarks"),
                                                          TotalRecords = n.Field<int>("TotalRecords"),
                                                          TotalPages = Convert.ToInt32(n["TotalPageCalc"]),
                                                          // VariationStatus = n.Field<string>("VariationStatus"),


                                                      }).ToList();

                    VVFDetails.VatiationDetailList.ForEach((x) =>
                    {
                        // x.PageSize = entity.PageSize.Value;

                        x.PageIndex = entity.Pageindex.Value;
                        x.FirstRecord = ((entity.Pageindex.Value - 1) * entity.PageSize.Value) + 1;
                        x.LastRecord = ((entity.Pageindex.Value - 1) * entity.PageSize.Value) + entity.PageSize.Value;
                        x.Remarks = x.Remarks == null ? string.Empty : x.Remarks;
                    });
                    VVFDetails.ErrorMsg = string.Empty;



                }
                else
                {
                    VVFDetails.VatiationDetailList = null;
                    VVFDetails.ErrorMsg = "No Record found";
                }

                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                return VVFDetails;
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
        public VVFEntity Update(VVFEntity model)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Update), Level.Info.ToString());


                AssetRegisterAttachmentDAL attachmentDAL = new AssetRegisterAttachmentDAL();
                
                UETrack.Model.BEMS.AssetRegisterAttachment attachment = new UETrack.Model.BEMS.AssetRegisterAttachment();
                int ServiceId = Convert.ToInt32(model.ServiceId);
                foreach (var val in model.FileUploadList)
                {

                    if (val.contentAsBase64String != null)
                    {
                        string guid = string.Empty;
                        guid = Guid.NewGuid().ToString();
                        if (!string.IsNullOrEmpty(val.contentAsBase64String))
                        {
                            val.FilePath = guid + "." + val.ContentType; 
                        }
                    }
                }

                var errorMessage = string.Empty;

                var Fileattachment = (from n in model.FileUploadList.Where(x => x.contentAsBase64String != null)
                                      select new UETrack.Model.BEMS.FileUploadDetModel
                                      {
                                          DocumentTitle = Convert.ToString(n.FilePath) == null ? "" : Convert.ToString(n.FilePath),
                                          FileType = n.FileType == 0 ? 0 : Convert.ToInt32(n.FileType),
                                          ContentType = Convert.ToString(n.ContentType) == null ? "" : Convert.ToString(n.ContentType),
                                          contentAsBase64String = n.contentAsBase64String,
                                          DocumentId = Convert.ToInt32(n.DocumentNo),
                                          FileName = Convert.ToString(n.FilePath),
                                          FilePath = Convert.ToString(n.FilePath),
                                          GuId = Convert.ToString(n.FilePath).ToUpper(),
                                          DocumentGuId = n.DocumentGuId,



                                      }).ToList();
                attachment.FileUploadList = Fileattachment;
                var result = attachmentDAL.Save_ByServiceId(attachment, ServiceId, out errorMessage);
                if (result.FileUploadList.Count > 0)
                {
                    for (int i = 0; result.FileUploadList.Count > i; i++)
                    {
                        foreach (var data in model.FileUploadList)
                        {
                            if (data.DocumentId == 0)
                                data.DocumentId = Convert.ToInt32(result.FileUploadList[i].DocumentId);
                        }
                    }
                }




              
                var dbAccessDAL = new DBAccessDAL();
                var ds = new DataSet();

                var obj = new VVFEntity();
                
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));


                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable dt = new DataTable();
                dt.Columns.Add("VariationId", typeof(int));
                dt.Columns.Add("SNFDocumentNo", typeof(string));
                dt.Columns.Add("AssetId", typeof(int));
                dt.Columns.Add("WorkFlowStatus", typeof(int));
                dt.Columns.Add("CountingDays", typeof(decimal));
                dt.Columns.Add("Action", typeof(string));

                dt.Columns.Add("Remarks", typeof(string));

                dt.Columns.Add("MonthlyProposedFeePW", typeof(decimal));
                dt.Columns.Add("MonthlyProposedFeeDW", typeof(decimal));
                dt.Columns.Add("MaintenanceRatePW", typeof(decimal));
                dt.Columns.Add("MaintenanceRateDW", typeof(decimal));
                dt.Columns.Add("UserId", typeof(int));
                dt.Columns.Add("DocumentId", typeof(string));

                int k = 0;
                foreach (var item in model.VatiationDetailList)
                {

                    //item.CreatedDate = item.CreatedDateUTC = Convert.ToDateTime(DateTime.Now.ToString("yyyy-MM-dd h:mm tt"));
                    dt.Rows.Add(item.VariationId, null, null, item.WorkFlowStatus, item.CountingDays, item.Action, item.Remarks, item.MonthlyProposedFeePW, item.MonthlyProposedFeeDW, item.MaintenanceRatePW, item.MaintenanceRateDW, _UserSession.UserId, Convert.ToInt32(result.FileUploadList[k].DocumentId));
                    k = (k + 1);
                }

                DataSetparameters.Add("@VmVariationTxnVVF", dt);

                DataTable ds1 = dbAccessDAL.GetDataTable_ByServiceID("uspFM_VmVariationTxnVVF_Save", parameters, DataSetparameters, ServiceId);
                if (ds1 != null)
                {
                    foreach (DataRow row in ds1.Rows)
                    {
                        //model.LicenseId = Convert.ToInt32(row["LicenseId"]);
                        //model.Timestamp = ((row["Timestamp"]).ToString());
                        //model.ErrorMsg = ((row["ErrorMessage"]).ToString());
                    }
                }
                var getobj = new VVFDetails() { Pageindex = 1, PageSize = 5, Month = model.Month, Year = model.Year, WorkFlowStatusId = model.WorkFlowStatusId, VariationStatusId = model.VariationStatusId, ServiceId=model.ServiceId };
                model.VatiationDetailList = Get(getobj).VatiationDetailList;
                Log4NetLogger.LogEntry(_FileName, nameof(Update), Level.Info.ToString());
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

       

    }
}
