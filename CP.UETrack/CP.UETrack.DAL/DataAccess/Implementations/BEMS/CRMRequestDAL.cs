using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.DAL.DataAccess.Contracts.BEMS;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.DAL.DataAccess.Implementations.Common;
using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using CP.UETrack.Models;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UETrack.DAL;
using static CP.UETrack.DAL.DataAccess.MasterUserAreaDAL;

namespace CP.UETrack.DAL.DataAccess.Implementations.BEMS
{
    public class CRMRequestDAL : ICRMRequestDAL
    {
        private readonly string _FileName = nameof(UserRoleDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        DataSet DST = new DataSet();
        DataSet DST1 = new DataSet();
        DataSet DST2 = new DataSet();

        MasterUserAreaDAL muDal = new MasterUserAreaDAL();

        //public CORMDropdownList Load()
        //{
        //    try
        //    {
        //        Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
        //        CORMDropdownList CORMDropdownList = new CORMDropdownList();

        //        var ds = new DataSet();
        //        var ds1 = new DataSet();
        //        var dbAccessDAL = new DBAccessDAL();
        //        using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
        //        {
        //            using (SqlCommand cmd = new SqlCommand())
        //            {


        //                var da = new SqlDataAdapter();


        //                da = new SqlDataAdapter();
        //                cmd.Connection = con;
        //                cmd.CommandType = CommandType.StoredProcedure;
        //                cmd.CommandText = "uspFM_Dropdown";
        //                cmd.Parameters.Clear();
        //                cmd.Parameters.AddWithValue("@pLovKey", "CRMRequestTypeValue,CRMRequestStatusValue");
        //                da.SelectCommand = cmd;
        //                da.Fill(ds1);
        //            }
        //        }

        //        if (ds1.Tables.Count != 0)
        //        {
        //            CORMDropdownList.RequestStatusList = dbAccessDAL.GetLovRecords(ds1.Tables[0], "CRMRequestStatusValue");
        //            CORMDropdownList.RequestTypeList = dbAccessDAL.GetLovRecords(ds1.Tables[0], "CRMRequestTypeValue");

        //        }
        //        Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
        //        return CORMDropdownList;
        //    }
        //    catch (DALException dalex)
        //    {
        //        throw new DALException(dalex);
        //    }
        //    catch (Exception ex)
        //    {
        //        throw ex;
        //    }
        //}

        public CORMDropdownList Load()
        {
            //GET_ServiceIndicator();
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                CORMDropdownList CORMDropdownList = new CORMDropdownList();
                CORMDropdownList CORMdnlist = new CORMDropdownList();
                var ds = new DataSet();
                var ds3 = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                List<LovValue> lv = new List<LovValue>();
                List<LovValue> IndicatorLists = new List<LovValue>();
                List<LovValueDesc> PriorityLists = new List<LovValueDesc>();

                List<LovValueDesc> IndicatorListsDes = new List<LovValueDesc>();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        var da = new SqlDataAdapter();
                        da = new SqlDataAdapter();
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Dropdown";
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@pLovKey", "CRMRequestTypeValue,CRMRequestStatusValue,WorkGroup,WasteCategoryValue,CRMJustificationValue");
                        da.SelectCommand = cmd;
                        da.Fill(DST1);
                        DST1.Tables[0].Columns.Add("Description", typeof(string));

                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Dropdown_group";
                        cmd.Parameters.Clear();
                        da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds3);
                        //DST2.Tables[0].Columns.Add("Priority_Type_Description", typeof(string));
                        DataSet ServiceIndicator = GET_ServiceIndicator();

                        DataTable IndicatorTable = new DataTable("Newtables");
                        IndicatorTable.Columns.Add("LovId", typeof(int));
                        IndicatorTable.Columns.Add("FieldValue", typeof(string));
                        IndicatorTable.Columns.Add("LovKey", typeof(string));
                        IndicatorTable.Columns.Add("IsDefault", typeof(bool));
                        IndicatorTable.Columns.Add("Description", typeof(string));

                        for (int i = 0; i < ServiceIndicator.Tables[0].Rows.Count; i++)
                        {
                            DataRow DR = ServiceIndicator.Tables[0].Rows[i];
                            DST1.Tables[0].ImportRow(DR);
                        }
                        for (int i = 0; i < ServiceIndicator.Tables[0].Rows.Count; i++)
                        {
                            DataRow DR = DST1.Tables[0].Rows[i];
                            IndicatorTable.ImportRow(DR);
                        }

                        //-----------Get Priority Data-------

                        DataSet CRMReqPriority = GET_CRMReqPriority();

                        DataTable PriorityTable = new DataTable("Newtables");
                        PriorityTable.Columns.Add("LovId", typeof(int));
                        PriorityTable.Columns.Add("FieldValue", typeof(string));
                        PriorityTable.Columns.Add("LovKey", typeof(string));
                        PriorityTable.Columns.Add("IsDefault", typeof(bool));
                        PriorityTable.Columns.Add("Description", typeof(string));
                        //PriorityTable.Columns.Add("Priority_Type_Description", typeof(string));


                        for (int i = 0; i < CRMReqPriority.Tables[0].Rows.Count; i++)
                        {
                            DataRow DR = CRMReqPriority.Tables[0].Rows[i];
                            DST1.Tables[0].ImportRow(DR);
                        }
                        //for (int i = 0; i < CRMReqPriority.Tables[0].Rows.Count; i++)
                        //{
                        //    DataRow DR = DST1.Tables[0].Rows[i];
                        //    PriorityTable.ImportRow(DR);
                        //}

                        //-----------End Here---------------

                        DataTable dsp = new DataTable("Newtable");
                        dsp.Columns.Add("LovId", typeof(int));
                        dsp.Columns.Add("FieldValue", typeof(string));
                        dsp.Columns.Add("Description", typeof(string));


                        for (int i = 0; i < ServiceIndicator.Tables[0].Rows.Count; i++)
                        {
                            DataRow DR = ServiceIndicator.Tables[0].Rows[i];
                            dsp.ImportRow(DR);
                        }
                    }
                }

                if (ds3.Tables.Count != 0)
                {
                    CORMDropdownList.WorkGroup = dbAccessDAL.GetLovRecords(ds3.Tables[0]);
                }
                if (DST1.Tables.Count != 0)
                {


                    //CORMDropdownList.WorkGroup = dbAccessDAL.GetLovRecords(DST1.Tables[0], "WorkGroup");
                    CORMDropdownList.WasteCategory = dbAccessDAL.GetLovRecords(DST1.Tables[0], "WasteCategoryValue");
                    CORMDropdownList.CRMJUstification = dbAccessDAL.GetLovRecords(DST1.Tables[0], "CRMJustificationValue");
                    CORMDropdownList.RequestStatusList = dbAccessDAL.GetLovRecords(DST1.Tables[0], "CRMRequestStatusValue");
                  CORMDropdownList.RequestTypeList = dbAccessDAL.GetLovRecords(DST1.Tables[0], "CRMRequestTypeValue");
                    CORMDropdownList.IndicatorList = dbAccessDAL.GetLovRecords(DST1.Tables[0], "FEMS");
                    IndicatorLists = CORMDropdownList.IndicatorList;

                    CORMDropdownList.IndicatorList = dbAccessDAL.GetLovRecords(DST1.Tables[0], "BEMS");
                    IndicatorLists.AddRange(CORMDropdownList.IndicatorList);
                    CORMDropdownList.IndicatorList = dbAccessDAL.GetLovRecords(DST1.Tables[0], "LLS");
                    IndicatorLists.AddRange(CORMDropdownList.IndicatorList);

                    CORMDropdownList.IndicatorList_Descr = dbAccessDAL.GetLovDescRecords(DST1.Tables[0], "FEMS");
                    IndicatorListsDes = CORMDropdownList.IndicatorList_Descr;
                    CORMDropdownList.IndicatorList_Descr = dbAccessDAL.GetLovDescRecords(DST1.Tables[0], "BEMS");
                    IndicatorListsDes.AddRange(CORMDropdownList.IndicatorList_Descr);
                    CORMDropdownList.IndicatorList_Descr = dbAccessDAL.GetLovDescRecords(DST1.Tables[0], "LLS");
                    IndicatorListsDes.AddRange(CORMDropdownList.IndicatorList_Descr);

                    CORMDropdownList.PriorityList = dbAccessDAL.GetLovDescRecords(DST1.Tables[0], "PriorityList");

                    CORMDropdownList.IndicatorList = IndicatorLists;
                    CORMDropdownList.IndicatorList_Descr = IndicatorListsDes;

                }
                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {

                    using (SqlCommand cmd = new SqlCommand())
                    {
                        var da = new SqlDataAdapter();
                        da = new SqlDataAdapter();
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Get_Services_byFacilityId";
                        cmd.Parameters.Clear();
                        //cmd.Parameters.AddWithValue("@pLovKey", "CRMRequestTypeValue,CRMRequestStatusValue");
                        cmd.Parameters.AddWithValue("@FacilityID", _UserSession.FacilityId);
                        da.SelectCommand = cmd;
                        da.Fill(DST1);
                        if (DST1.Tables.Count != 0)
                        {
                            //CORMdnlist.RequestServiceList = dbAccessDAL.GetLovRecords(DST1.Tables[0], "FacilityId");
                            CORMDropdownList.RequestServiceList = dbAccessDAL.GetLovRecords(DST1.Tables[0], "FacilityId");
                            //CORMDropdownList.RequestTypeList = dbAccessDAL.GetLovRecords(ds1.Tables[0], "CRMRequestTypeValue");
                        }
                    }
                    if (_UserSession.FEMS == 1)
                    {
                        lv.Add(new LovValue() { LovId = 1, FieldValue = "FEMS", DefaultValue = false });
                    }
                    if (_UserSession.BEMS == 1)
                    {
                        lv.Add(new LovValue() { LovId = 2, FieldValue = "BEMS", DefaultValue = false });
                    }
                    if (_UserSession.CLS == 1)
                    {
                        lv.Add(new LovValue() { LovId = 6, FieldValue = "ICT", DefaultValue = false });
                    }
                    if (_UserSession.LLS == 1)
                    {
                        lv.Add(new LovValue() { LovId = 4, FieldValue = "LLS", DefaultValue = false });
                    }
                    if (_UserSession.HWMS == 1)
                    {
                        lv.Add(new LovValue() { LovId = 5, FieldValue = "HWMS", DefaultValue = false });
                    }
                    
                }
                CORMDropdownList.RequestServiceList = lv;
                return CORMDropdownList;

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

        #region
        //public void save(ref CRMRequestEntity model)
        //{
        //    try
        //    {
        //        var reqid = model.CRMRequestId;

        //        Log4NetLogger.LogEntry(_FileName, nameof(save), Level.Info.ToString());
        //        CRMRequestEntity griddata = new CRMRequestEntity();
        //        var dbAccessDAL = new DBAccessDAL();
        //        var parameters = new Dictionary<string, string>();
        //        parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));
        //        parameters.Add("@pCRMRequestId", Convert.ToString(model.CRMRequestId));
        //        parameters.Add("@CustomerId", Convert.ToString(_UserSession.CustomerId));
        //        parameters.Add("@FacilityId", Convert.ToString(_UserSession.FacilityId));
        //        parameters.Add("@ServiceId", Convert.ToString(2));
        //        parameters.Add("@RequestNo", Convert.ToString(model.RequestNo));
        //        //parameters.Add("@RequestDateTime", model.RequestDateTime.ToString("yyyy-MM-dd h:mm tt"));
        //        parameters.Add("@RequestDateTime", Convert.ToString(model.RequestDateTime == null || model.RequestDateTime == DateTime.MinValue ? null : model.RequestDateTime.ToString("MM-dd-yyy HH:mm")));
        //        //parameters.Add("@RequestDateTimeUTC", model.RequestDateTimeUTC.ToString("yyyy-MM-dd h:mm tt"));
        //        parameters.Add("@RequestDateTimeUTC", Convert.ToString(model.RequestDateTimeUTC == null || model.RequestDateTimeUTC == DateTimeOffset.MinValue ? null : model.RequestDateTimeUTC.ToString("MM-dd-yyy HH:mm")));
        //        parameters.Add("@RequestDescription", Convert.ToString(model.RequestDescription));
        //        parameters.Add("@RequestStatus", Convert.ToString(model.RequestStatus));
        //        parameters.Add("@TypeOfRequest", Convert.ToString(model.TypeOfRequest));
        //        parameters.Add("@Remarks", Convert.ToString(model.Remarks));

        //        parameters.Add("@pModelId", Convert.ToString(model.ModelId));
        //        parameters.Add("@pManufacturerid", Convert.ToString(model.ManufacturerId));
        //        parameters.Add("@pUserAreaId", Convert.ToString(model.UserAreaId));
        //        parameters.Add("@pUserLocationId", Convert.ToString(model.UserLocationId));
        //        parameters.Add("@pTargetDate", Convert.ToString(model.TargetDate == null || model.TargetDate == DateTime.MinValue ? null : model.TargetDate.Value.ToString("MM-dd-yyy")));
        //        parameters.Add("@pRequestedPerson", Convert.ToString(model.RequestPersonId));
        //        parameters.Add("@pFlag", Convert.ToString(model.AccessFlag));
        //        parameters.Add("@pRequester", Convert.ToString(model.ReqStaffId));
        //        parameters.Add("@pAssigneeId", Convert.ToString(model.AssigneeId));
        //        parameters.Add("@pEntryUser", Convert.ToString(model.ChkEntUser));
        //        parameters.Add("@CurrDateTime", Convert.ToString(model.CurrentDatetimeLocal == null || model.CurrentDatetimeLocal == DateTime.MinValue ? null : model.CurrentDatetimeLocal.ToString("MM-dd-yyy HH:mm")));

        //        var dec = new Dictionary < string, DataTable>();
        //        DataTable dt = new DataTable();
        //        if(model.CRMRequestGridData != null)
        //        {
        //            dt.Columns.Add("CRMRequestDetId", typeof(int));
        //            dt.Columns.Add("CRMRequestId", typeof(int));
        //            dt.Columns.Add("AssetId", typeof(int));

        //            var deletedId = model.CRMRequestGridData.Where(y => y.IsDeleted).Select(x => x.CRMRequestDetId).ToList();
        //            var idstring = string.Empty;
        //            if (deletedId.Count() > 0)
        //            {
        //                foreach (var item in deletedId.Select((value, i) => new { i, value }))
        //                {
        //                    idstring += item.value;
        //                    if (item.i != deletedId.Count() - 1)
        //                    { idstring += ","; }
        //                }
        //                deleteChildrecords(idstring);
        //            }

        //            //updateNotification(model);

        //            foreach (var i in model.CRMRequestGridData.Where(y => !y.IsDeleted))
        //            {
        //                dt.Rows.Add(i.CRMRequestDetId, i.CRMRequestId, i.AssetId);
        //            }
        //            dec.Add("@pCRMDet", dt);

        //        }



        //        DataTable ds = dbAccessDAL.GetDataTable("uspFM_CRMRequest_Save", parameters,dec);
        //        if (ds != null)
        //        {
        //            foreach (DataRow row in ds.Rows)
        //            {
        //                model.CRMRequestId = Convert.ToInt32(row["CRMRequestId"]);
        //                model.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
        //                // model.err = Convert.ToBase64String((byte[])(row["Timestamp"]));
        //                model.HiddenId = Convert.ToString(row["GuId"]);

        //            }
        //        }

        //        model = Get(model.CRMRequestId,5,1);
        //        if(reqid == 0)
        //        {
        //            SendMailRequest(model);
        //        }

        //        Log4NetLogger.LogEntry(_FileName, nameof(save), Level.Info.ToString());

        //    }


        //    catch (DALException dalex)
        //    {
        //        throw new DALException(dalex);
        //    }
        //    catch (Exception ex)
        //    {
        //        throw ex;
        //    }
        //}
        #endregion
        public void save(ref CRMRequestEntity model)
        {
            CustomerDAL get_customers = new CustomerDAL();
            
            MasterBlockDAL get_Facilitys = new MasterBlockDAL();
            MasterUserAreaDAL get_userAreas = new MasterUserAreaDAL();
            MasterUserLocationDAL get_userLocation = new MasterUserLocationDAL();
            var BdbAccessDAL = new MASTERBEMSDBAccessDAL();
            var FdbAccessDAL = new MASTERFEMSDBAccessDAL();
            var com = get_customers.GET_Customar_Mapping_IDS(_UserSession.CustomerId);
            var facilities = get_Facilitys.GET_Facility_Mapping_IDS(_UserSession.FacilityId);


            User_Area bs = new User_Area();
            int masterId = 0, childId = 0;
            string services = "";
            CRMRequestEntity crmrReqest = new CRMRequestEntity();
            User_Area ua = new User_Area();
            //ua = muDal.Get_User_Areaids(Convert.ToInt32(model.UserAreaId));

            try
            {
                if (model.ServiceId == 1)
                {
                    services = "FEMS";
                    if (model.CRMRequestId > 0 & model.CRMRequestId > 900000000)
                    {

                        model.CRMRequestId = model.CRMRequestId - 1000000000;
                    }
                }
                else
                {
                    services = "BEMS";
                    if (model.CRMRequestId > 0 & model.CRMRequestId > 900000000)
                    {
                        model.CRMRequestId = model.CRMRequestId - 900000000;
                    }
                }
                crmrReqest = GET_ServiceAndCustomer_ID(model.TypeOfServiceRequest, _UserSession.CustomerId, _UserSession.FacilityId);
                var reqid = model.CRMRequestId;

                Log4NetLogger.LogEntry(_FileName, nameof(save), Level.Info.ToString());
                CRMRequestEntity griddata = new CRMRequestEntity();
                var dbAccessDAL = new MASTERDBAccessDAL();
                var GMdbAccessDAL = new DBAccessDAL();
                var parameters = new Dictionary<string, string>();
                var parametersS = new Dictionary<string, string>();
                var otherparameters = new Dictionary<string, string>();
                var Ncrparameters = new Dictionary<string, string>();
                var DataSetparameters = new Dictionary<string, DataTable>();

                parametersS.Add("@pManufacturerId", Convert.ToString(model.ManufacturerId));
                parametersS.Add("@pModelId", Convert.ToString(model.ModelId));
                DataSet dts = new DataSet();
                //if (model.CRMRequestId != 0 && model.TypeOfRequest == 137 || model.TypeOfRequest == 136 || model.TypeOfRequest == 374)
                //{

                //}
                //else
                //{
                if (model.ModelId > 0)
                {
                    dts = dbAccessDAL.MasterGetDataSet("uspFM_ManufacturerId_ModelId_Get_BYIDS_mappingTo_SeviceDB", parametersS, DataSetparameters);
                }
                else
                {
                }

                if (model.TypeOfRequest == 137 || model.TypeOfRequest == 136 || model.TypeOfRequest == 374)
                {

                    foreach (DataRow row in dts.Tables[0].Rows)
                    {
                        model.ManufacturerId = Convert.ToInt32(row["ManufacturerId_mappingTo_SeviceDB"]);
                        model.ModelId = Convert.ToInt32(row["ModelId_mappingTo_SeviceDB"]);
                    }

                }
                else
                {
                }
                //}
                parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));
                parameters.Add("@TypeOfRequest", Convert.ToString(model.TypeOfRequest));
                //parameters.Add("@TypeOfServiceRequest", Convert.ToString(model.TypeOfServiceRequest));
                parameters.Add("@Remarks", Convert.ToString(model.Remarks));
                parameters.Add("@pModelId", Convert.ToString(model.ModelId));
                parameters.Add("@pManufacturerid", Convert.ToString(model.ManufacturerId));
                parameters.Add("@pTargetDate", Convert.ToString(model.TargetDate == null || model.TargetDate == DateTime.MinValue ? null : model.TargetDate.Value.ToString("MM-dd-yyy")));
                parameters.Add("@pRequestedPerson", Convert.ToString(model.RequestPersonId));
                parameters.Add("@pFlag", Convert.ToString(model.AccessFlag));
                parameters.Add("@pRequester", Convert.ToString(model.ReqStaffId));
                parameters.Add("@pAssigneeId", Convert.ToString(model.AssigneeId));
                parameters.Add("@pEntryUser", Convert.ToString(model.ChkEntUser));
                parameters.Add("@CurrDateTime", Convert.ToString(model.CurrentDatetimeLocal == null || model.CurrentDatetimeLocal == DateTime.MinValue ? null : model.CurrentDatetimeLocal.ToString("MM-dd-yyy HH:mm")));
                parameters.Add("@RequestStatus", Convert.ToString(model.RequestStatus));
                parameters.Add("@RequestDescription", Convert.ToString(model.RequestDescription));
                parameters.Add("@ServiceId", Convert.ToString(model.ServiceId));
                parameters.Add("@pServiceName", Convert.ToString(services));
                parameters.Add("@RequestDateTimeUTC", Convert.ToString(model.RequestDateTimeUTC == null || model.RequestDateTimeUTC == DateTimeOffset.MinValue ? null : model.RequestDateTimeUTC.ToString("MM-dd-yyy HH:mm")));
                parameters.Add("@RequestNo", Convert.ToString(model.RequestNo));
                parameters.Add("@RequestDateTime", Convert.ToString(model.RequestDateTime == null || model.RequestDateTime == DateTime.MinValue ? null : model.RequestDateTime.ToString("MM-dd-yyy HH:mm")));
                parameters.Add("@pCRMRequestId", Convert.ToString(model.CRMRequestId));
                otherparameters = parameters;
                parameters.Add("@CustomerId", Convert.ToString(_UserSession.CustomerId));
                parameters.Add("@FacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@pUserLocationId", Convert.ToString(model.UserLocationId));
                parameters.Add("@pUserAreaId", Convert.ToString(model.UserAreaId));

                parameters.Add("@pCRMRequest_PriorityId", Convert.ToString(model.PriorityList));
                if (model.WorkGroup == null)
                {
                    parameters.Add("@pWorkGroup", Convert.ToString(model.WorkGroup = 0));
                }
                else {
                    parameters.Add("@pWorkGroup", Convert.ToString(model.WorkGroup == null || model.WorkGroup == int.MinValue ? null : model.WorkGroup.ToString()));
                }
                if (model.WasteCategory == null)
                {
                    parameters.Add("@pWasteCategory", Convert.ToString(model.WasteCategory = 0));
                }
                else
                {
                    parameters.Add("@pWasteCategory", Convert.ToString(model.WasteCategory == null || model.WasteCategory == int.MinValue ? null : model.WasteCategory.ToString()));
                }
                //   parameters.Add("@pIndicators_all", Convert.ToString(model.Indicators_all));


                if (model.TypeOfRequest == 10021 && model.RequestStatus == 140)
                {
                    parameters.Add("@pResponce_Date", Convert.ToString(model.Responce_Date) == null || model.Responce_Date == DateTime.MinValue ? null : model.Responce_Date.ToString("MM-dd-yyy HH:mm"));
                    parameters.Add("@pCompleted_Date", Convert.ToString(model.Completed_Date) == null || model.Completed_Date == DateTime.MinValue ? null : model.Completed_Date.ToString("MM-dd-yyy HH:mm"));
                    parameters.Add("@pCompleted_By", Convert.ToString(model.Completed_By));
                    parameters.Add("@pAction_Taken", Convert.ToString(model.LLSAction_Taken));
                    parameters.Add("@pJustification", Convert.ToString(model.LLSJustification));
                    parameters.Add("@pValidation", Convert.ToString(model.LLSValidation));

                    parameters.Add("@pIndicators_all ", Convert.ToString(model.Indicators_all));

                }
                else
                {
                }
                if (model.TypeOfRequest == 10020 && model.RequestStatus == 140)
                {
                    parameters.Remove("@Remarks");
                    parameters.Remove("@Remarks");
                    parameters.Add("@pResponce_Date", Convert.ToString(model.Responce_Date) == null || model.Responce_Date == DateTime.MinValue ? null : model.Responce_Date.ToString("MM-dd-yyy HH:mm"));
                    parameters.Add("@pAction_Taken", Convert.ToString(model.Action_Taken));
                    parameters.Add("@Remarks", Convert.ToString(model.NcrRemarks));
                    parameters.Add("@pCompleted_Date", Convert.ToString(model.Completed_Date) == null || model.Completed_Date == DateTime.MinValue ? null : model.Completed_Date.ToString("MM-dd-yyy HH:mm"));
                    parameters.Add("@pCompleted_By", Convert.ToString(model.Completed_By));


                }

                if (model.TypeOfRequest == 10020)
                {
                    if (model.Indicators_all != null || model.Indicators_all != "")
                    {
                        parameters.Add("@pNCRDescription", Convert.ToString(model.NCRDescription));
                        parameters.Add("@pIndicators_all ", Convert.ToString(model.Indicators_all));
                        
                    }
                    else
                    {

                    }


                }

                if (model.TypeOfRequest == 136 || model.TypeOfRequest == 375)
                {

                }
                else
                {
                    parameters.Add("@pAssetNo ", Convert.ToString(model.AssetNo));
                    parameters.Add("@pAssetId ", Convert.ToString(model.AssetId));
                }

                parameters.Add("@pRequested_Date ", Convert.ToString(model.RequestedDate) == null || model.RequestedDate == DateTime.MinValue ? null : model.RequestedDate.ToString("MM-dd-yyy HH:mm"));

                var dec = new Dictionary<string, DataTable>();
                DataTable dt = new DataTable();
                DataTable dt2 = new DataTable();
                if (model.CRMRequestGridData != null)
                {
                    dt.Columns.Add("CRMRequestDetId", typeof(int));
                    dt.Columns.Add("CRMRequestId", typeof(int));
                    dt.Columns.Add("AssetId", typeof(int));

                    var deletedId = model.CRMRequestGridData.Where(y => y.IsDeleted).Select(x => x.CRMRequestDetId).ToList();
                    var idstring = string.Empty;
                    if (deletedId.Count() > 0)
                    {
                        foreach (var item in deletedId.Select((value, i) => new { i, value }))
                        {
                            idstring += item.value;
                            if (item.i != deletedId.Count() - 1)
                            { idstring += ","; }
                        }
                        deleteChildrecords(idstring);
                    }

                    //  updateNotification(model);

                    foreach (var i in model.CRMRequestGridData.Where(y => !y.IsDeleted))
                    {
                        dt.Rows.Add(i.CRMRequestDetId, i.CRMRequestId, i.AssetId);
                    }
                    dec.Add("@pCRMDet", dt);
                }
                DataTable ds = new DataTable();
                if (model.TypeOfRequest == 137 || model.TypeOfRequest == 136 || model.TypeOfRequest == 374)
                {
                    // otherparameters.Add("@pCRMRequest_PriorityId", Convert.ToString(model.PriorityList));
                    if (model.ServiceId == 1)
                    {
                        //if (model.TypeOfRequest == 138)
                        //{

                        //var location = get_userLocation.Get_UserLocation(Convert.ToInt32(model.UserLocationId));
                        //var UserArea = get_userAreas.Get_User_Areaids(Convert.ToInt32(model.UserAreaId));
                        //otherparameters["@pUserAreaId"] = UserArea.FEMS_UA_ID.ToString();
                        //otherparameters["@pUserLocationId"] = location.FEMS_UL_ID.ToString();
                        //otherparameters["@CustomerId"] = com.FEMS_B_ID.ToString();
                        //otherparameters["@FacilityId"] = facilities.FEMS_B_ID.ToString();

                        //ds = FdbAccessDAL.GetMasterDataTable("uspFM_CRMRequest_Save", otherparameters, dec);
                        //}
                        //else
                        //{
                        //    ds = FdbAccessDAL.GetMasterDataTable("uspFM_CRMRequest_Save", parameters, dec);
                        //}

                        ds = FdbAccessDAL.GetMasterDataTable("uspFM_CRMRequest_Save", parameters, dec);
                    }
                    else
                    {
                        if (model.ServiceId == 2)
                        {
                            //if (model.TypeOfRequest == 138)
                            //{

                            //    var location = get_userLocation.Get_UserLocation(Convert.ToInt32(model.UserLocationId));
                            //var UserArea = get_userAreas.Get_User_Areaids(Convert.ToInt32(model.UserAreaId));
                            //otherparameters["@pUserAreaId"] = UserArea.BEMS_UA_ID.ToString();
                            //otherparameters["@pUserLocationId"] = location.BEMS_UL_ID.ToString();
                            //otherparameters["@CustomerId"] = com.BEMS_B_ID.ToString();
                            //otherparameters["@FacilityId"] = facilities.BEMS_B_ID.ToString();
                            //ds = BdbAccessDAL.GetMasterDataTable("uspFM_CRMRequest_Save", otherparameters, dec);
                            //}
                            //else
                            //{
                            //    ds = FdbAccessDAL.GetMasterDataTable("uspFM_CRMRequest_Save", parameters, dec);
                            //}
                            ds = BdbAccessDAL.GetMasterDataTable("uspFM_CRMRequest_Save", parameters, dec);
                        }
                        else
                        {
                        }

                    }

                }
                else
                {
                    ds = dbAccessDAL.GetMASTERDataTable("uspFM_CRMRequest_Save", parameters, dec);
                }

                DataSet subper = new DataSet();
                //--------UPDATE
                if (model.CRMRequestId > 0 && model.TypeOfRequest == 375)
                {
                    if (model.ServiceId == 1)
                    {
                        subper = Get_subIDCRMREQestFEMS(model.CRMRequestId);
                    }
                    else
                    {
                        subper = Get_subIDCRMREQestBEMS(model.CRMRequestId);
                    }
                    if (subper != null)
                    {
                        if (subper.Tables[0].Rows.Count > 0)
                        {
                            otherparameters["@pCRMRequestId"] = Convert.ToString(subper.Tables[0].Rows[0]["CRMRequestId"]);

                        }
                    }
                }
                else
                {
                }

                CRMRequestEntity ModelMaster = model;
                if (ds != null)
                {
                    foreach (DataRow row in ds.Rows)
                    {
                        model.CRMRequestId = Convert.ToInt32(row["CRMRequestId"]);
                        model.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                        model.RequestNo = row["RequestNo"].ToString();
                        model.HiddenId = Convert.ToString(row["GuId"]);
                    }
                }

                if (model.UserLocationId == null)
                {
                    model.UserLocationId = 0;
                }
                if (model.UserAreaId == null)
                {
                    model.UserAreaId = 0;
                }


                DataTable dtt1 = new DataTable();



                subper.Clear();

                //    if (model.ModelId >= 0)
                //{


                //    subper = Get_subIDStypecode(model.ModelId, model.ManufacturerId);
                //    if (subper != null)
                //    {
                //        otherparameters["@pManufacturerid"] = Convert.ToString(subper.Tables[0].Rows[0]["ManufacturerId_mappingTo_SeviceDB"]);
                //        otherparameters["@pModelId"] = Convert.ToString(subper.Tables[0].Rows[0]["ModelId_mappingTo_SeviceDB"]);
                //    }
                //}

                var serviceid = model.ServiceId;

                dec.Clear();

                subper.Clear();

                if (model.TypeOfRequest == 375)
                {
                    if (model.ModelId >= 0)
                    {


                        subper = Get_subIDStypecode(model.ModelId, model.ManufacturerId);
                        if (subper != null)
                        {
                            otherparameters["@pManufacturerid"] = Convert.ToString(subper.Tables[0].Rows[0]["ManufacturerId_mappingTo_SeviceDB"]);
                            otherparameters["@pModelId"] = Convert.ToString(subper.Tables[0].Rows[0]["ModelId_mappingTo_SeviceDB"]);
                        }
                    }
                    if (model.TypeOfServiceRequest != 1)
                    {
                        services = "BEMS";
                        if (model.TypeOfRequest == 375)
                        {
                            var location = get_userLocation.Get_UserLocation(Convert.ToInt32(model.UserLocationId));
                            var UserArea = get_userAreas.Get_User_Areaids(Convert.ToInt32(model.UserAreaId));
                            otherparameters["@pUserAreaId"] = UserArea.BEMS_UA_ID.ToString();
                            otherparameters["@pUserLocationId"] = location.BEMS_UL_ID.ToString();

                        }
                        else
                        {
                            otherparameters["@pUserAreaId"] = Convert.ToString(model.UserAreaId);
                            otherparameters["@pUserLocationId"] = Convert.ToString(model.UserLocationId);
                        }
                        otherparameters["@CustomerId"] = com.BEMS_B_ID.ToString();
                        otherparameters["@FacilityId"] = facilities.BEMS_B_ID.ToString();
                        otherparameters["@DocumentNumber_master"] = services + "/" + model.RequestNo.ToString();
                        otherparameters["@pMaster_CRMRequestId"] = model.CRMRequestId.ToString();
                        // var BdbAccessDAL = new MASTERBEMSDBAccessDAL();
                        dtt1 = BdbAccessDAL.GetMasterDataTable("uspFM_CRMRequest_Save_Master", otherparameters, dec);
                    }
                    else
                    {
                        services = "FEMS";
                        if (model.TypeOfRequest == 375)
                        {
                            var location = get_userLocation.Get_UserLocation(Convert.ToInt32(model.UserLocationId));
                            var UserArea = get_userAreas.Get_User_Areaids(Convert.ToInt32(model.UserAreaId));
                            otherparameters["@pUserAreaId"] = UserArea.FEMS_UA_ID.ToString();
                            otherparameters["@pUserLocationId"] = location.FEMS_UL_ID.ToString();

                        }
                        else
                        {
                            otherparameters["@pUserAreaId"] = Convert.ToString(model.UserAreaId);
                            otherparameters["@pUserLocationId"] = Convert.ToString(model.UserLocationId);
                        }
                        otherparameters["@CustomerId"] = com.FEMS_B_ID.ToString();
                        otherparameters["@FacilityId"] = facilities.FEMS_B_ID.ToString();
                        //otherparameters.Add("FacilityId", facilities.FEMS_B_ID.ToString());
                        otherparameters["@DocumentNumber_master"] = services + "/" + model.RequestNo.ToString();
                        otherparameters["@pMaster_CRMRequestId"] = model.CRMRequestId.ToString();
                        otherparameters["@pWorkGroup"] = model.WorkGroup.ToString();
                        // var FdbAccessDAL = new MASTERFEMSDBAccessDAL();
                        dtt1 = FdbAccessDAL.GetMasterDataTable("uspFM_CRMRequest_Save_Master", otherparameters, dec);
                    }

                }
                else
                { }
                //==============================End=here===================



                // parameters.Add("@pCRMRequestId", Convert.ToString(model.CRMRequestId));
                model = Get(model.CRMRequestId, 5, 1);
                if (reqid == 0)
                {
                    SendMailRequest(ModelMaster);
                }

                Log4NetLogger.LogExit(_FileName, nameof(save), Level.Info.ToString());

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

        public CRMRequestEntity updateNotification(CRMRequestEntity ent)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(save), Level.Info.ToString());
            CRMRequestEntity griddata = new CRMRequestEntity();
            var dbAccessDAL = new MASTERDBAccessDAL();
            var parameters = new Dictionary<string, string>();

            //parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));

            var data = new Dictionary<string, DataTable>();
            DataTable dt1 = new DataTable();

            dt1.Columns.Add("NotificationId", typeof(int));
            dt1.Columns.Add("CustomerId", typeof(int));
            dt1.Columns.Add("FacilityId", typeof(int));
            dt1.Columns.Add("UserId", typeof(int));

            dt1.Columns.Add("NotificationAlerts", typeof(string));
            dt1.Columns.Add("Remarks", typeof(string));
            dt1.Columns.Add("HyperLink", typeof(string));
            dt1.Columns.Add("IsNew", typeof(Boolean));
            dt1.Columns.Add("SessionUserId", typeof(int));
            dt1.Columns.Add("NotificationDateTime", typeof(DateTime));

            foreach (var i in ent.CRMRequestGridData)
            {
                dt1.Rows.Add(i.NotificationId, _UserSession.CustomerId, _UserSession.FacilityId, _UserSession.UserId, "CRM Work Order generated",
                    "", "/bems/crmworkorder", 1, _UserSession.UserId, null);
            }
            data.Add("@pWebNotification", dt1);

            DataTable ds = dbAccessDAL.GetMASTERDataTable("uspFM_WebNotification_Save", parameters, data);


            if (ds != null)
            {
                foreach (DataRow row in ds.Rows)
                {
                    //model.CRMRequestId = Convert.ToInt32(row["CRMRequestId"]);
                    //model.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                    //// model.err = Convert.ToBase64String((byte[])(row["Timestamp"]));
                    //model.HiddenId = Convert.ToString(row["GuId"]);
                }
            }

            return ent;
        }

        public CRMRequestEntity updateNotificationSingle(CRMRequestEntity ent)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(save), Level.Info.ToString());
            CRMRequestEntity griddata = new CRMRequestEntity();
            var dbAccessDAL = new MASTERDBAccessDAL();
            var parameters = new Dictionary<string, string>();
            var DataSetparameters = new Dictionary<string, DataTable>();

            var notalert = ent.CRMWorkorderNo + " " + "CRM Work Order has been generated";

            var hyplink = "/bems/crmworkorder?id=" + ent.CRMWorkorderId;

            parameters.Add("@pNotificationId", Convert.ToString(ent.NotificationId));
            parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
            parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
            parameters.Add("@pUserId", Convert.ToString(ent.ReqStaffId));
            parameters.Add("@pNotificationAlerts", Convert.ToString(notalert));
            parameters.Add("@pRemarks", Convert.ToString(""));
            parameters.Add("@pHyperLink", Convert.ToString(hyplink));
            parameters.Add("@pIsNew", Convert.ToString(1));
            parameters.Add("@pNotificationDateTime", Convert.ToString(null));
            parameters.Add("@pEmailTempId", Convert.ToString(ent.TemplateId));

            parameters.Add("@pmScreenName", Convert.ToString("CRMRequestStatus"));
            parameters.Add("@pMGuid", Convert.ToString(ent.HiddenIdReq));



            DataTable ds = dbAccessDAL.GetMASTERDataTable("uspFM_WebNotificationSingle_Save", parameters, DataSetparameters);
            if (ds != null)
            {
                foreach (DataRow row in ds.Rows)
                {
                    //model.CRMRequestId = Convert.ToInt32(row["CRMRequestId"]);
                    //model.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                    //// model.err = Convert.ToBase64String((byte[])(row["Timestamp"]));
                    //model.HiddenId = Convert.ToString(row["GuId"]);
                }
            }

            return ent;
        }
        public void update(ref CRMRequestEntity model)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(update), Level.Info.ToString());
                model.CustomerId = 1;
                int userid = model.CreatedBy = _UserSession.UserId;
                model.FacilityId = 1;

                model.ServiceId = 2;

                model.CreatedDate = DateTime.Now;
                var dbAccessDAL = new DBAccessDAL();
                var obj = new EngAssetClassification();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pUserId", Convert.ToString(userid));
                parameters.Add("@pCRMRequestId", Convert.ToString(model.CRMRequestId));
                parameters.Add("@CustomerId", Convert.ToString(model.CustomerId));
                parameters.Add("@FacilityId", Convert.ToString(model.FacilityId));
                parameters.Add("@ServiceId", Convert.ToString(model.ServiceId));
                parameters.Add("@RequestNo", Convert.ToString(model.RequestNo));
                parameters.Add("@RequestDateTime", model.RequestDateTime.ToString("yyyy-MM-dd h:mm tt"));
                parameters.Add("@RequestDateTimeUTC", model.RequestDateTimeUTC.ToString("yyyy-MM-dd h:mm tt"));
                parameters.Add("@RequestDescription", Convert.ToString(model.RequestDescription));
                parameters.Add("@RequestStatus", Convert.ToString(model.RequestStatus));
                parameters.Add("@TypeOfRequest", Convert.ToString(model.TypeOfRequest));
                parameters.Add("@Remarks", Convert.ToString(model.Remarks));


                var Dictionary = new Dictionary<string, DataTable>();

                DataTable ds = dbAccessDAL.GetDataTable("uspFM_CRMRequest_Save", parameters, Dictionary);
                if (ds != null)
                {
                    foreach (DataRow row in ds.Rows)
                    {
                        model.CRMRequestId = Convert.ToInt32(row["CRMRequestId"]);
                        model.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                    }
                }

                // model = Get(model.CRMRequestId);
                Log4NetLogger.LogEntry(_FileName, nameof(update), Level.Info.ToString());

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

        //public CRMRequestEntity Get(int id , int pagesize, int pageindex)
        //{
        //    try
        //    {
        //        var dbAccessDAL = new DBAccessDAL();
        //        CRMRequestEntity entity = new CRMRequestEntity();
        //        var DataSetparameters = new Dictionary<string, DataTable>();
        //        var parameters = new Dictionary<string, string>();
        //        parameters.Add("@pCRMRequestId", id.ToString());
        //        parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));
        //        parameters.Add("@pPageIndex", pageindex.ToString());
        //        parameters.Add("@pPageSize", pagesize.ToString());
        //        DataSet ds = dbAccessDAL.GetDataSet("uspFM_CRMRequest_GetById", parameters, DataSetparameters);
        //        if (ds != null)
        //        {
        //            if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
        //            {
        //                entity.CRMRequestId = Convert.ToInt16(ds.Tables[0].Rows[0]["CRMRequestId"]);
        //                entity.RequestNo = Convert.ToString(ds.Tables[0].Rows[0]["RequestNo"]);
        //                entity.RequestDateTime = Convert.ToDateTime(ds.Tables[0].Rows[0]["RequestDateTime"]);
        //                entity.RequestStatus = Convert.ToInt32(ds.Tables[0].Rows[0]["RequestStatus"]);
        //                entity.TypeOfRequest = Convert.ToInt32(ds.Tables[0].Rows[0]["TypeOfRequest"]);
        //                entity.RequestDescription = Convert.ToString(ds.Tables[0].Rows[0]["RequestDescription"]);
        //                entity.Remarks = Convert.ToString(ds.Tables[0].Rows[0]["Remarks"]);
        //                //entity.ManufacturerId = Convert.ToInt32(ds.Tables[0].Rows[0]["UserAreaId"]);
        //                entity.ManufacturerId = (ds.Tables[0].Rows[0].Field<int?>("ManufacturerId"));
        //                entity.Manufacturer = Convert.ToString(ds.Tables[0].Rows[0]["Manufacturer"]);
        //               // entity.ModelId = Convert.ToInt32(ds.Tables[0].Rows[0]["UserAreaId"]);
        //                entity.ModelId = (ds.Tables[0].Rows[0].Field<int?>("ModelId"));
        //                entity.Model = Convert.ToString(ds.Tables[0].Rows[0]["Model"]);
        //                //entity.UserAreaId = Convert.ToInt32(ds.Tables[0].Rows[0]["UserAreaId"]);
        //                entity.UserAreaId = (ds.Tables[0].Rows[0].Field<int?>("UserAreaId"));
        //                entity.UserAreaCode = Convert.ToString(ds.Tables[0].Rows[0]["UserAreaCode"]);
        //                entity.UserAreaName = Convert.ToString(ds.Tables[0].Rows[0]["UserAreaName"]);
        //                //entity.UserLocationId = Convert.ToInt32(ds.Tables[0].Rows[0]["UserLocationId"]);
        //                entity.UserLocationId = (ds.Tables[0].Rows[0].Field<int?>("UserLocationId"));
        //                entity.UserLocationCode = Convert.ToString(ds.Tables[0].Rows[0]["UserLocationCode"]);
        //                entity.UserLocationName = Convert.ToString(ds.Tables[0].Rows[0]["UserLocationName"]);
        //                entity.WorkOrderStatus = Convert.ToString(ds.Tables[0].Rows[0]["RequestStatusName"]);
        //                entity.IsWorkorderGen = Convert.ToBoolean(ds.Tables[0].Rows[0]["IsWorkorderGen"]);
        //                entity.FMREQProcess = Convert.ToString(ds.Tables[0].Rows[0]["StatusValue"]);
        //                entity.Timestamp = Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["Timestamp"]));
        //                entity.TargetDate = (ds.Tables[0].Rows[0].Field<DateTime?>("TargetDate"));
        //                entity.RequestPersonId = (ds.Tables[0].Rows[0].Field<int?>("RequestedPerson"));
        //                entity.RequestPerson = Convert.ToString(ds.Tables[0].Rows[0]["RequestedPersonName"]);
        //                entity.AssigneeId = (ds.Tables[0].Rows[0].Field<int?>("AssigneeId"));
        //                entity.Assignee = Convert.ToString(ds.Tables[0].Rows[0]["AssigneeIdName"]);

        //                entity.HiddenId = Convert.ToString((ds.Tables[0].Rows[0]["GuId"]));
        //            }

        //            var griddata = (from n in ds.Tables[1].AsEnumerable()
        //                            select new CRMRequestGrid
        //                            {
        //                                CRMRequestDetId = Convert.ToInt32(n["CRMRequestDetId"]),
        //                                CRMRequestId = Convert.ToInt32(n["CRMRequestId"]),
        //                                AssetId = Convert.ToInt32(n["AssetId"]),
        //                                AssetNo = Convert.ToString(n["AssetNo"]),
        //                                SerialNo = Convert.ToString(n["SerialNo"] == DBNull.Value ? "" : (Convert.ToString(n["SerialNo"]))),
        //                                //Minimum = Convert.ToDecimal(n["Minimum"] == DBNull.Value ? 0 : (Convert.ToDecimal(n["Minimum"]))),
        //                                SoftwareVersion = Convert.ToString(n["SoftwareVersion"] == DBNull.Value ? "" : (Convert.ToString(n["SoftwareVersion"]))),
        //                                TotalRecords = Convert.ToInt32(n["TotalRecords"]),
        //                                TotalPages = Convert.ToInt32(n["TotalPageCalc"]),
        //                            }).ToList();

        //            var RemHis = (from n in ds.Tables[2].AsEnumerable()
        //                            select new CRMRequestRemHisGrid
        //                            {
        //                              CRMRequestHistId = Convert.ToInt32(n["CRMRequestRemarksHistoryId"]),
        //                                CRMRequestId = Convert.ToInt32(n["CRMRequestId"]),
        //                                SNo = Convert.ToInt32(n["SNo"]),
        //                                Remarks = Convert.ToString(n["Remarks"] == DBNull.Value ? "" : (Convert.ToString(n["Remarks"]))),
        //                                DoneBy = Convert.ToString(n["DoneBy"] == DBNull.Value ? "" : (Convert.ToString(n["DoneBy"]))),                                      
        //                                Date = n.Field<DateTime?>("DoneDate"),
        //                                StatusId = Convert.ToInt32(n["RequestStatus"]),
        //                                Status = Convert.ToString(n["RequestStatusValue"]),

        //                            }).ToList();
        //            if (griddata != null && griddata.Count > 0)
        //            {
        //                entity.CRMRequestGridData = griddata;
        //            }

        //            if (RemHis != null && RemHis.Count > 0)
        //            {
        //                entity.CRMRequestRemHisGridData = RemHis;
        //            }


        //            if (entity.CRMRequestGridData != null)
        //            {
        //                entity.CRMRequestGridData.ForEach((x) =>
        //                {
        //                    x.PageIndex = pageindex;
        //                    x.FirstRecord = ((pageindex - 1) * pagesize) + 1;
        //                    x.LastRecord = ((pageindex - 1) * pagesize) + pagesize;
        //                });
        //            }


        //        }
        //        Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
        //        return entity;
        //    }
        //    catch (DALException dalex)
        //    {
        //        throw new DALException(dalex);
        //    }
        //    catch (Exception ex)
        //    {
        //        throw ex;
        //    }
        //}

        public CRMRequestEntity Get(int id, int pagesize, int pageindex)
        {
            try
            {
                var dbAccessDAL = new MASTERDBAccessDAL();
                var dbAccessDALF = new MASTERFEMSDBAccessDAL();
                var dbAccessDALB = new MASTERBEMSDBAccessDAL();

                CRMRequestEntity entity = new CRMRequestEntity();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                var parameterss = new Dictionary<string, string>();
                DataSet DTS = new DataSet(); /// dedection
                var DTS_parameters = new Dictionary<string, string>();
                parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));
                parameters.Add("@pPageIndex", pageindex.ToString());
                parameters.Add("@pPageSize", pagesize.ToString());
                DataSet ds = new DataSet();
                if (id >= 900000000 & id < 1000000000)
                {
                    id = id - 900000000;
                    parameters.Add("@pCRMRequestId", id.ToString());

                    DataSet dl = dbAccessDALB.GetDataSet("uspFM_CRMRequest_GetById", parameters, DataSetparameters);
                    //Get_Master_Model_Manf()
                    ds = dl;
                }
                else
                {
                    if (id >= 1000000000)
                    {
                        id = id - 1000000000;
                        parameters.Add("@pCRMRequestId", id.ToString());
                        //parameters.Add("@StrCondition", "TypeOfRequestVal!=' T&C'");
                        DataSet dl = dbAccessDALF.GetDataSet("uspFM_CRMRequest_GetById", parameters, DataSetparameters);

                        ds = dl;
                    }
                    else
                    {
                        parameters.Add("@pCRMRequestId", id.ToString());
                        DataSet dl = dbAccessDAL.MasterGetDataSet("uspFM_CRMRequest_GetById", parameters, DataSetparameters);

                        ds = dl;
                    }

                }

                if (ds != null)
                {
                    //Model and Manf mapping from sub db to master
                    if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                    {                      
                        entity.TypeOfRequest = Convert.ToInt32(ds.Tables[0].Rows[0]["TypeOfRequest"]);
                        entity.ServiceId = Convert.ToInt32(ds.Tables[0].Rows[0]["ServiceId"]);
                        ///print form binding//
                        entity.ServiceKey1 = Convert.ToString(ds.Tables[0].Rows[0]["ServiceKey"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["ServiceKey"]);
                        ///print form binding//

                        entity.RequestStatus = Convert.ToInt32(ds.Tables[0].Rows[0]["RequestStatus"]);
                        if (entity.TypeOfRequest == 137 || entity.TypeOfRequest == 136 || entity.TypeOfRequest == 374)
                        {
                            DataSet modefac = new DataSet();
                            modefac = Get_Master_Model_Manf((ds.Tables[0].Rows[0].Field<int?>("ModelId")), (ds.Tables[0].Rows[0].Field<int?>("ManufacturerId")));
                            entity.CRMRequestId = Convert.ToInt16(ds.Tables[0].Rows[0]["CRMRequestId"]);
                            if (modefac != null)
                            {

                                entity.ManufacturerId = (modefac.Tables[0].Rows[0].Field<int?>("ManufacturerId"));
                                entity.Manufacturer = Convert.ToString(modefac.Tables[0].Rows[0]["Manufacturer"]);
                                entity.ModelId = (modefac.Tables[0].Rows[0].Field<int?>("ModelId"));
                                entity.Model = Convert.ToString(modefac.Tables[0].Rows[0]["Model"]);
                            }
                            if (entity.ServiceId == 1)
                            {
                                entity.CRMRequestId = entity.CRMRequestId + 1000000000;
                            }
                            else
                            {
                                entity.CRMRequestId = entity.CRMRequestId + 900000000;
                            }

                        }
                        else
                        {
                            entity.CRMRequestId = Convert.ToInt16(ds.Tables[0].Rows[0]["CRMRequestId"]);
                            entity.ManufacturerId = (ds.Tables[0].Rows[0].Field<int?>("ManufacturerId"));
                            entity.Manufacturer = Convert.ToString(ds.Tables[0].Rows[0]["Manufacturer"]);
                            entity.ModelId = (ds.Tables[0].Rows[0].Field<int?>("ModelId"));
                            entity.Model = Convert.ToString(ds.Tables[0].Rows[0]["Model"]);

                        }

                        entity.RequestedDate = Convert.ToDateTime(ds.Tables[0].Rows[0]["Requested_Date"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["Requested_Date"]);

                                               entity.AssetId = Convert.ToInt32(ds.Tables[0].Rows[0]["AssetId"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["AssetId"]);
                        entity.AssetNo = Convert.ToString(ds.Tables[0].Rows[0]["AssetNo"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["AssetNo"]);

                        if (entity.TypeOfRequest == 10021)
                        {
                            entity.Responce_Date = Convert.ToDateTime(ds.Tables[0].Rows[0]["Responce_Date"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["Responce_Date"]);
                            entity.Completed_Date = Convert.ToDateTime(ds.Tables[0].Rows[0]["Completed_Date"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["Completed_Date"]);
                            entity.Completed_By = Convert.ToInt32(ds.Tables[0].Rows[0]["Completed_By"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["Completed_By"]);
                            entity.Completed_By_Name = Convert.ToString(ds.Tables[0].Rows[0]["StaffName"]);
                            entity.LLSResponse_by_ID = Convert.ToInt32(ds.Tables[0].Rows[0]["Responce_By"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["Responce_By"]);
                            entity.LLSResponse_by = Convert.ToString(ds.Tables[0].Rows[0]["respon_StaffName"]);
                            if (entity.RequestStatus == 142)
                            {
                                entity.LLSAction_Taken = Convert.ToString(ds.Tables[0].Rows[0]["Action_Taken"]);
                                entity.LLSJustification = Convert.ToString(ds.Tables[0].Rows[0]["Justification"]);
                                entity.LLSValidation = Convert.ToInt32(ds.Tables[0].Rows[0]["Validation"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["Validation"]);
                                entity.Indicators_all = Convert.ToString(ds.Tables[0].Rows[0]["Indicators_all"]);

                                DTS_parameters.Add("@pIndicators", entity.Indicators_all);
                                if (entity.Indicators_all != null && entity.Indicators_all != "")
                                {
                                    if (entity.ServiceId == 1)
                                    {
                                        DTS = dbAccessDALF.GetDataSet("uspFM_MstDedIndicator_GetByServiceId_string", DTS_parameters, DataSetparameters);
                                    }
                                    else
                                    {
                                        if (entity.ServiceId == 2)
                                        {
                                            DTS = dbAccessDALB.GetDataSet("uspFM_MstDedIndicator_GetByServiceId_string", DTS_parameters, DataSetparameters);

                                        }
                                        else
                                        {
                                            DTS = dbAccessDAL.MasterGetDataSet("uspFM_MstDedIndicator_GetByServiceId_string", DTS_parameters, DataSetparameters);

                                        }
                                    }
                                    entity.Indicators = (from n in DTS.Tables[0].AsEnumerable()
                                                         select new Indicator
                                                         {
                                                             Indicator_Code = Convert.ToString(n["IndicatorNo"]),
                                                             Indicator_Name = Convert.ToString(n["IndicatorDesc"]),
                                                         }).ToList();
                                }
                                else
                                {
                                }
                                // @pIndicators

                            }


                        }
                        else
                        {
                        }

                        if (entity.TypeOfRequest == 10020)
                        {
                            //entity.Responce_Date = Convert.ToDateTime(ds.Tables[0].Rows[0]["Responce_Date"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["Responce_Date"]);
                            //entity.Completed_Date = Convert.ToDateTime(ds.Tables[0].Rows[0]["Completed_Date"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["Completed_Date"]);
                            entity.Completed_By = Convert.ToInt32(ds.Tables[0].Rows[0]["Completed_By"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["Completed_By"]);
                            entity.Completed_By_Name = Convert.ToString(ds.Tables[0].Rows[0]["StaffName"]);
                            //entity.LLSResponse_by_ID = Convert.ToInt32(ds.Tables[0].Rows[0]["Responce_By"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["Responce_By"]);
                            entity.LLSResponse_by = Convert.ToString(ds.Tables[0].Rows[0]["respon_StaffName"]);
                            entity.Responce_Date = Convert.ToDateTime(ds.Tables[0].Rows[0]["Responce_Date"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["Responce_Date"]);
                            entity.LLSResponse_by_ID = Convert.ToInt32(ds.Tables[0].Rows[0]["Responce_By"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["Responce_By"]);
                            entity.LLSAction_Taken = Convert.ToString(ds.Tables[0].Rows[0]["Action_Taken"]);
                            //    entity.LLSJustification = Convert.ToString(ds.Tables[0].Rows[0]["Justification"]);
                            entity.NCRDescription = Convert.ToString(ds.Tables[0].Rows[0]["NCRDescription"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["NCRDescription"]);
                            entity.Indicators_all = Convert.ToString(ds.Tables[0].Rows[0]["Indicators_all"]);
                            entity.Completed_Date = Convert.ToDateTime(ds.Tables[0].Rows[0]["Completed_Date"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["Completed_Date"]);
                            entity.AssetId = Convert.ToInt32(ds.Tables[0].Rows[0]["AssetId"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["AssetId"]);
                            entity.AssetNo = Convert.ToString(ds.Tables[0].Rows[0]["AssetNo"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["AssetNo"]);
                            DTS_parameters.Add("@pIndicators", entity.Indicators_all);
                            if (entity.Indicators_all != null && entity.Indicators_all != "")
                            {
                                if (entity.ServiceId == 1)
                                {
                                    DataTable dt2 = dbAccessDALF.GetMasterDataTable("uspFM_MstDedIndicator_GetByServiceId_string", DTS_parameters, DataSetparameters);
                                    if (dt2 != null && dt2.Rows.Count > 0)
                                    {
                                        entity.Indicator_ID = Convert.ToInt32(dt2.Rows[0]["IndicatorDetId"]);
                                        entity.Indicator_Code = Convert.ToString(dt2.Rows[0]["IndicatorNo"]);
                                        entity.Indicator_Name = Convert.ToString(dt2.Rows[0]["IndicatorDesc"]);
                                    }
                                    else { }
                                }
                                else if (entity.ServiceId == 2)
                                {
                                    DataTable dt1 = dbAccessDALB.GetMasterDataTable("uspFM_MstDedIndicator_GetByServiceId_string", DTS_parameters, DataSetparameters);
                                    if (dt1 != null && dt1.Rows.Count > 0)
                                    {
                                        entity.Indicator_ID = Convert.ToInt32(dt1.Rows[0]["IndicatorDetId"]);
                                        entity.Indicator_Code = Convert.ToString(dt1.Rows[0]["IndicatorNo"]);
                                        entity.Indicator_Name = Convert.ToString(dt1.Rows[0]["IndicatorDesc"]);
                                    }
                                    else { }
                                }
                                else if (entity.ServiceId == 4)
                                {
                                    DataTable dt = dbAccessDAL.GetMASTERDataTable("uspFM_MstDedIndicator_GetByServiceId_string", DTS_parameters, DataSetparameters);
                                    if (dt != null && dt.Rows.Count > 0)
                                    {
                                        entity.Indicator_ID = Convert.ToInt32(dt.Rows[0]["IndicatorDetId"]);
                                        entity.Indicator_Code = Convert.ToString(dt.Rows[0]["IndicatorNo"]);
                                        entity.Indicator_Name = Convert.ToString(dt.Rows[0]["IndicatorDesc"]);
                                    }
                                    else { }
                                }
                                else if (entity.ServiceId == 3)
                                {
                                    DataTable dt = dbAccessDAL.GetMASTERDataTable("uspFM_MstDedIndicator_GetByServiceId_string", DTS_parameters, DataSetparameters);
                                    if (dt != null && dt.Rows.Count > 0)
                                    {
                                        entity.Indicator_ID = Convert.ToInt32(dt.Rows[0]["IndicatorDetId"]);
                                        entity.Indicator_Code = Convert.ToString(dt.Rows[0]["IndicatorNo"]);
                                        entity.Indicator_Name = Convert.ToString(dt.Rows[0]["IndicatorDesc"]);
                                    }
                                    else { }
                                }
                                else if (entity.ServiceId == 5)
                                {
                                    DataTable dt = dbAccessDAL.GetMASTERDataTable("uspFM_MstDedIndicator_GetByServiceId_string", DTS_parameters, DataSetparameters);
                                    if (dt != null && dt.Rows.Count > 0)
                                    {
                                        entity.Indicator_ID = Convert.ToInt32(dt.Rows[0]["IndicatorDetId"]);
                                        entity.Indicator_Code = Convert.ToString(dt.Rows[0]["IndicatorNo"]);
                                        entity.Indicator_Name = Convert.ToString(dt.Rows[0]["IndicatorDesc"]);
                                    }
                                    else { }
                                }
                                else
                                {
                                }
                                // @pIndicators

                            }
                        }
                        else
                        {
                        }
                        // entity.CRMRequestId = Convert.ToInt16(ds.Tables[0].Rows[0]["CRMRequestId"]);
                        entity.RequestNo = Convert.ToString(ds.Tables[0].Rows[0]["RequestNo"]);
                        entity.RequestDateTime = Convert.ToDateTime(ds.Tables[0].Rows[0]["RequestDateTime"]);
                        ///print form binding///
                        entity.Designation = Convert.ToString(ds.Tables[0].Rows[0]["Designation"]);
                        entity.MobileNumber = Convert.ToString(ds.Tables[0].Rows[0]["MobileNumber"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["MobileNumber"]);
                        ///print form binding///
                        entity.RequestDescription = Convert.ToString(ds.Tables[0].Rows[0]["RequestDescription"]);
                        entity.Remarks = Convert.ToString(ds.Tables[0].Rows[0]["Remarks"]);


                        // entity.ModelId = Convert.ToInt32(ds.Tables[0].Rows[0]["UserAreaId"]);

                        //entity.UserAreaId = Convert.ToInt32(ds.Tables[0].Rows[0]["UserAreaId"]);
                        entity.UserAreaId = (ds.Tables[0].Rows[0].Field<int?>("UserAreaId"));
                        entity.UserAreaCode = Convert.ToString(ds.Tables[0].Rows[0]["UserAreaCode"]);
                        entity.UserAreaName = Convert.ToString(ds.Tables[0].Rows[0]["UserAreaName"]);
                        entity.UserAreaCompRepId = (ds.Tables[0].Rows[0].Field<int?>("CustomerUserId"));
                        entity.UserAreaFacRepId = (ds.Tables[0].Rows[0].Field<int?>("FacilityUserId"));
                        entity.UserAreaCompRep = Convert.ToString(ds.Tables[0].Rows[0]["CustomerUserEmail"]);
                        entity.UserAreaFacRep = Convert.ToString(ds.Tables[0].Rows[0]["FacilityUserEmail"]);

                        //entity.UserLocationId = Convert.ToInt32(ds.Tables[0].Rows[0]["UserLocationId"]);
                        entity.UserLocationId = (ds.Tables[0].Rows[0].Field<int?>("UserLocationId"));
                        entity.UserLocationCode = Convert.ToString(ds.Tables[0].Rows[0]["UserLocationCode"]);
                        entity.UserLocationName = Convert.ToString(ds.Tables[0].Rows[0]["UserLocationName"]);
                        entity.BlockId = (ds.Tables[0].Rows[0].Field<int?>("BlockId"));
                        entity.BlockCode = Convert.ToString(ds.Tables[0].Rows[0]["BlockCode"]);
                        entity.BlockName = Convert.ToString(ds.Tables[0].Rows[0]["BlockName"]);
                        entity.LevelId = (ds.Tables[0].Rows[0].Field<int?>("LevelId"));
                        entity.LevelCode = Convert.ToString(ds.Tables[0].Rows[0]["LevelCode"]);
                        entity.LevelName = Convert.ToString(ds.Tables[0].Rows[0]["LevelName"]);

                        entity.WorkOrderStatus = Convert.ToString(ds.Tables[0].Rows[0]["RequestStatusName"]);
                        entity.IsWorkorderGen = Convert.ToBoolean(ds.Tables[0].Rows[0]["IsWorkorderGen"]);
                        entity.FMREQProcess = Convert.ToString(ds.Tables[0].Rows[0]["StatusValue"]);
                        entity.Timestamp = Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["Timestamp"]));
                        entity.TargetDate = (ds.Tables[0].Rows[0].Field<DateTime?>("TargetDate"));
                        entity.ISTargetDateOver = Convert.ToString(ds.Tables[0].Rows[0]["TargetDateStatus"] == DBNull.Value ? "" : (Convert.ToString(ds.Tables[0].Rows[0]["TargetDateStatus"])));
                        entity.RequestPersonId = (ds.Tables[0].Rows[0].Field<int?>("RequestedPerson"));
                        entity.RequestPerson = Convert.ToString(ds.Tables[0].Rows[0]["RequestedPersonName"]);
                        entity.AssigneeId = (ds.Tables[0].Rows[0].Field<int?>("AssigneeId"));
                        entity.Assignee = Convert.ToString(ds.Tables[0].Rows[0]["AssigneeIdName"]);
                        entity.ChkStsApproveorNot = Convert.ToString(ds.Tables[0].Rows[0]["StatusValue"]);
                        entity.HiddenId = Convert.ToString((ds.Tables[0].Rows[0]["GuId"]));
                        entity.ReqStaffId = (ds.Tables[0].Rows[0].Field<int?>("RequesterId"));
                        entity.ReqStaff = Convert.ToString(ds.Tables[0].Rows[0]["Requester"] == DBNull.Value ? "" : (Convert.ToString(ds.Tables[0].Rows[0]["Requester"])));
                        entity.RequesterEmail = Convert.ToString(ds.Tables[0].Rows[0]["RequesterEmail"] == DBNull.Value ? "" : (Convert.ToString(ds.Tables[0].Rows[0]["RequesterEmail"])));
                        entity.WOAssigneeId = (ds.Tables[0].Rows[0].Field<int?>("WOAssigneId"));
                        entity.WOAssignee = Convert.ToString(ds.Tables[0].Rows[0]["WOAssigne"] == DBNull.Value ? "" : (Convert.ToString(ds.Tables[0].Rows[0]["WOAssigne"])));
                        entity.WOAssigneeEmail = Convert.ToString(ds.Tables[0].Rows[0]["WOAssigneEmail"] == DBNull.Value ? "" : (Convert.ToString(ds.Tables[0].Rows[0]["WOAssigneEmail"])));
                        entity.WorkGroup = Convert.ToInt32(ds.Tables[0].Rows[0]["WorkGroup"] == DBNull.Value ? "" : (Convert.ToString(ds.Tables[0].Rows[0]["WorkGroup"])));
                       // entity.WasteCategory = Convert.ToInt32(ds.Tables[0].Rows[0]["WasteCategory"] == DBNull.Value ? "" : (Convert.ToString(ds.Tables[0].Rows[0]["WasteCategory"])));
                        entity.WasteCategory = Convert.ToInt32(ds.Tables[0].Rows[0]["WasteCategory"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["WasteCategory"]);


                        if (entity.TypeOfRequest == 10021)
                        {
                            entity.PriorityList = Convert.ToInt32(ds.Tables[0].Rows[0]["CRMRequest_PriorityId"]);
                            ///print binding form
                            entity.CRMRequest_PriorityStatus = Convert.ToString(ds.Tables[0].Rows[0]["CRMRequest_PriorityStatus"]);
                            ///print binding form
                        }
                        else
                        {
                        }
                        //entity.PriorityList = Convert.ToInt32(ds.Tables[0].Rows[0]["CRMRequest_PriorityId"]);
                    }

                    if (entity.TypeOfRequest != 374)
                    {


                        entity.CRMRequestGridData = (from n in ds.Tables[1].AsEnumerable()
                                                     select new CRMRequestGrid
                                                     {
                                                         CRMRequestDetId = Convert.ToInt32(n["CRMRequestDetId"]),
                                                         CRMRequestId = Convert.ToInt32(n["CRMRequestId"]),
                                                         AssetId = Convert.ToInt32(n["AssetId"]),
                                                         AssetNo = Convert.ToString(n["AssetNo"]),
                                                         SerialNo = Convert.ToString(n["SerialNo"] == DBNull.Value ? "" : (Convert.ToString(n["SerialNo"]))),
                                                         //Minimum = Convert.ToDecimal(n["Minimum"] == DBNull.Value ? 0 : (Convert.ToDecimal(n["Minimum"]))),
                                                         SoftwareVersion = Convert.ToString(n["SoftwareVersion"] == DBNull.Value ? "" : (Convert.ToString(n["SoftwareVersion"]))),
                                                         // TotalRecords = Convert.ToInt32(n["TotalRecords"]),
                                                         // TotalPages = Convert.ToInt32(n["TotalPageCalc"]),
                                                     }).ToList();

                    }
                    else
                    {


                        entity.CRMRequestGridData = (from n in ds.Tables[1].AsEnumerable()
                                                     select new CRMRequestGrid
                                                     {
                                                         CRMRequestDetId = Convert.ToInt32(n["CRMRequestDetId"]),
                                                         CRMRequestId = Convert.ToInt32(n["CRMRequestId"]),
                                                         AssetId = Convert.ToInt32(n["AssetId"]),
                                                         AssetNo = Convert.ToString(n["AssetNo"]),
                                                         SerialNo = Convert.ToString(n["SerialNo"] == DBNull.Value ? "" : (Convert.ToString(n["SerialNo"]))),
                                                         //Minimum = Convert.ToDecimal(n["Minimum"] == DBNull.Value ? 0 : (Convert.ToDecimal(n["Minimum"]))),
                                                         SoftwareVersion = Convert.ToString(n["SoftwareVersion"] == DBNull.Value ? "" : (Convert.ToString(n["SoftwareVersion"]))),
                                                         //  TotalRecords = Convert.ToInt32(n["TotalRecords"]),
                                                         // TotalPages = Convert.ToInt32(n["TotalPageCalc"]),
                                                     }).ToList();

                    }


                    var RemHis = (from n in ds.Tables[2].AsEnumerable()
                                  select new CRMRequestRemHisGrid
                                  {
                                      CRMRequestHistId = Convert.ToInt32(n["CRMRequestRemarksHistoryId"]),
                                      CRMRequestId = Convert.ToInt32(n["CRMRequestId"]),
                                      SNo = Convert.ToInt32(n["SNo"]),
                                      Remarks = Convert.ToString(n["Remarks"] == DBNull.Value ? "" : (Convert.ToString(n["Remarks"]))),
                                      DoneBy = Convert.ToString(n["DoneBy"] == DBNull.Value ? "" : (Convert.ToString(n["DoneBy"]))),
                                      Date = n.Field<DateTime?>("DoneDate"),
                                      StatusId = Convert.ToInt32(n["RequestStatus"]),
                                      Status = Convert.ToString(n["RequestStatusValue"]),

                                  }).ToList();


                    //if (griddata != null && griddata.Count > 0)
                    //{
                    //    entity.CRMRequestGridData = griddata;
                    //}

                    if (RemHis != null && RemHis.Count > 0)
                    {
                        entity.CRMRequestRemHisGridData = RemHis;
                    }


                    if ((entity.CRMRequestGridData != null))
                    {
                        entity.CRMRequestGridData.ForEach((x) =>
                        {
                            x.PageIndex = pageindex;
                            x.FirstRecord = ((pageindex - 1) * pagesize) + 1;
                            x.LastRecord = ((pageindex - 1) * pagesize) + pagesize;
                        });
                    }


                }
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return entity;
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

        public CRMRequestEntity get_Indicator_by_Serviceid(int id)
        {
            CRMRequestEntity ccm = new CRMRequestEntity();
            //  List<Indicator> ind = new List<Indicator>();
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(get_Indicator_by_Serviceid), Level.Info.ToString());
                var BdbAccessDAL = new MASTERBEMSDBAccessDAL();
                var FdbAccessDAL = new MASTERFEMSDBAccessDAL();
                var dbAccessDAL = new MASTERDBAccessDAL();
                //  var dbAccessDAL = new DBAccessDAL();
                string connections;
                if (id == 1)
                {
                    connections = FdbAccessDAL.ConnectionString;


                }
                else
                {
                    if (id == 2)
                    {
                        connections = BdbAccessDAL.ConnectionString;
                    }
                    else
                    {
                        connections = dbAccessDAL.ConnectionString;
                    }
                }
                ///----code here
                /// using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))

                using (SqlConnection con = new SqlConnection(connections))
                {
                    DataSet ds = new DataSet();
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_MstDedIndicator_GetByServiceId";
                        cmd.Parameters.AddWithValue("@pServiceId", id);
                        //  cmd.Parameters.AddWithValue("@pUserId", _UserSession.UserId);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        ccm.Indicators = (from n in ds.Tables[0].AsEnumerable()
                                          select new Indicator
                                          {
                                              LovId = Convert.ToInt32(n["IndicatorDetId"]),
                                              Indicator_Name = (n["IndicatorName"]).ToString(),
                                              FieldValue = (n["IndicatorNo"]).ToString(),

                                              //CRMRequestDetId = Convert.ToInt32(n["CRMRequestDetId"]),
                                              //CRMRequestId = Convert.ToInt32(n["CRMRequestId"]),
                                              //AssetId = Convert.ToInt32(n["AssetId"]),
                                              //AssetNo = Convert.ToString(n["AssetNo"]),
                                              //SerialNo = Convert.ToString(n["SerialNo"] == DBNull.Value ? "" : (Convert.ToString(n["SerialNo"]))),
                                              ////Minimum = Convert.ToDecimal(n["Minimum"] == DBNull.Value ? 0 : (Convert.ToDecimal(n["Minimum"]))),
                                              //SoftwareVersion = Convert.ToString(n["SoftwareVersion"] == DBNull.Value ? "" : (Convert.ToString(n["SoftwareVersion"]))),
                                              //////TotalRecords = Convert.ToInt32(n["TotalRecords"]),
                                              ////TotalPages = Convert.ToInt32(n["TotalPageCalc"]),
                                          }).ToList();


                    }
                }



                Log4NetLogger.LogEntry(_FileName, nameof(get_Indicator_by_Serviceid), Level.Info.ToString());


                return ccm;
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

        public CORMDropdownList get_TypeofRequset_by_Serviceid(int id)
        {
           

            //  List<Indicator> ind = new List<Indicator>();
            try
            {
                CORMDropdownList CORMdnlist = new CORMDropdownList();
                CORMDropdownList CORMDropdownList = new CORMDropdownList();
                Log4NetLogger.LogEntry(_FileName, nameof(get_TypeofRequset_by_Serviceid), Level.Info.ToString());
              
                var dbAccessDAL = new MASTERDBAccessDAL();
                string connections;
            
                connections = dbAccessDAL.ConnectionString;
                using (SqlConnection con = new SqlConnection(connections))
                {
                    DataSet ds = new DataSet();
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "getTypeofRequsetbyServiceid";
                        cmd.Parameters.AddWithValue("@id", id);
                        //  cmd.Parameters.AddWithValue("@pUserId", _UserSession.UserId);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                    }
                    CORMDropdownList.RequestTypeList = null;
                    CORMDropdownList.RequestTypeList = dbAccessDAL.GetRecords(ds.Tables[0]);


                    Log4NetLogger.LogEntry(_FileName, nameof(get_TypeofRequset_by_Serviceid), Level.Info.ToString());


                    return CORMDropdownList;
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
        }
        public bool Cancel(int id,string Remarks)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Cancel), Level.Info.ToString());

                if (id >= 900000000 & id < 1000000000) //--BEMS
                {
                    id = id - 900000000;
                    var dbAccessDALB = new BEMSDBAccessDAL();
                    using (SqlConnection con = new SqlConnection(dbAccessDALB.ConnectionString))
                    {
                        using (SqlCommand cmd = new SqlCommand())
                        {
                            cmd.Connection = con;
                            cmd.CommandType = CommandType.StoredProcedure;
                            cmd.CommandText = "uspFM_CRMRequest_Cancel";
                            cmd.Parameters.AddWithValue("@pCRMRequestId", id);
                            cmd.Parameters.AddWithValue("@pRemarks", Remarks);
                            cmd.Parameters.AddWithValue("@pUserId", _UserSession.UserId);

                            con.Open();
                            cmd.ExecuteNonQuery();
                            con.Close();
                        }
                    }
                }
                else
                {
                    if (id >= 1000000000) //--FEMS
                    {
                        id = id - 1000000000;
                       
                        //DataSet dl = dbAccessDALF.GetDataSet("uspFM_CRMRequest_GetById", parameters, DataSetparameters);
                        var dbAccessDALF = new FEMSDBAccessDAL();
                        using (SqlConnection con = new SqlConnection(dbAccessDALF.ConnectionString))
                        {
                            using (SqlCommand cmd = new SqlCommand())
                            {
                                cmd.Connection = con;
                                cmd.CommandType = CommandType.StoredProcedure;
                                cmd.CommandText = "uspFM_CRMRequest_Cancel";
                                cmd.Parameters.AddWithValue("@pCRMRequestId", id);
                                cmd.Parameters.AddWithValue("@pRemarks", Remarks);
                                cmd.Parameters.AddWithValue("@pUserId", _UserSession.UserId);

                                con.Open();
                                cmd.ExecuteNonQuery();
                                con.Close();
                            }
                        }

                    }
                    else
                    {
                        var dbAccessDAL = new DBAccessDAL();
                        using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                        {
                            using (SqlCommand cmd = new SqlCommand())
                            {
                                cmd.Connection = con;
                                cmd.CommandType = CommandType.StoredProcedure;
                                cmd.CommandText = "uspFM_CRMRequest_Cancel";
                                cmd.Parameters.AddWithValue("@pCRMRequestId", id);
                                cmd.Parameters.AddWithValue("@pRemarks", Remarks);
                                cmd.Parameters.AddWithValue("@pUserId", _UserSession.UserId);

                                con.Open();
                                cmd.ExecuteNonQuery();
                                con.Close();
                            }
                        }
                    }

                }

               
                Log4NetLogger.LogEntry(_FileName, nameof(Cancel), Level.Info.ToString());
                return true;
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
        public GridFilterResult Getall(int id, SortPaginateFilter pageFilter)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Getall), Level.Info.ToString());
                GridFilterResult filterResult = null;
                //pageFilter.PageIndex = pageFilter.PageIndex == 0 ? 1 : pageFilter.PageIndex;
                pageFilter.Page = "1";
                pageFilter.SortColumn = "ModifiedDateUTC";
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

                var QueryCondition = pageFilter.QueryWhereCondition;
                var strCondition = string.Empty;
                if (string.IsNullOrEmpty(QueryCondition))
                {
                    strCondition = "FacilityId = " + _UserSession.FacilityId.ToString();
                }
                else
                {
                    strCondition = QueryCondition + " AND FacilityId = " + _UserSession.FacilityId.ToString();
                }

                var ds = new DataSet();
                var dbAccessDAL = new MASTERDBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_CRMRequest_GetAll";
                        cmd.Parameters.AddWithValue("@PageIndex", pageFilter.PageIndex);
                        cmd.Parameters.AddWithValue("@PageSize", pageFilter.PageSize);
                        cmd.Parameters.AddWithValue("@StrCondition", strCondition);
                        cmd.Parameters.AddWithValue("@StrSorting", strOrderBy);
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

        public GridFilterResult Getall(SortPaginateFilter pageFilter)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Getall), Level.Info.ToString());
                GridFilterResult filterResult = null;
                //pageFilter.PageIndex = pageFilter.PageIndex == 0 ? 1 : pageFilter.PageIndex;

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

                var QueryCondition = pageFilter.QueryWhereCondition;
                var strCondition = string.Empty;
                if (string.IsNullOrEmpty(QueryCondition))
                {
                    strCondition = "FacilityId = " + _UserSession.FacilityId.ToString();
                }
                else
                {
                    strCondition = QueryCondition + " AND FacilityId = " + _UserSession.FacilityId.ToString();
                }


                var ds = new DataSet();
                var dsB = new DataSet();
                var dsF = new DataSet();
                var dbAccessDAL = new MASTERDBAccessDAL();
                var dbAccessDALBEMS = new MASTERBEMSDBAccessDAL();
                var dbAccessDALFEMS = new MASTERFEMSDBAccessDAL();

                //  string olddb = ConfigurationManager.ConnectionStrings["UETrackConnectionStringMA"].ConnectionString;
                // string olddbBE = ConfigurationManager.ConnectionStrings["UETrackCommonConnectionStringBE"].ConnectionString;
                //string olddbFE = ConfigurationManager.ConnectionStrings["FEMSUETrackCommonConnectionStringFE"].ConnectionString;

                // strCondition = "FacilityId = 10";
                pageFilter.PageSize = pageFilter.PageSize / 3;


                //using (SqlConnection con = new SqlConnection(olddb))             
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_CRMRequest_GetAll";

                        cmd.Parameters.AddWithValue("@PageIndex", pageFilter.PageIndex);
                        cmd.Parameters.AddWithValue("@PageSize", pageFilter.PageSize);
                        cmd.Parameters.AddWithValue("@StrCondition", strCondition);
                        cmd.Parameters.AddWithValue("@StrSorting", strOrderBy);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                //using (SqlConnection con = new SqlConnection(olddbBE))
                using (SqlConnection con = new SqlConnection(dbAccessDALBEMS.ConnectionString))
                {
                    strCondition = strCondition + " AND TypeOfRequestVal !=' T&C'";
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_CRMRequest_GetAll";

                        cmd.Parameters.AddWithValue("@PageIndex", pageFilter.PageIndex);
                        cmd.Parameters.AddWithValue("@PageSize", pageFilter.PageSize);
                        cmd.Parameters.AddWithValue("@StrCondition", strCondition);
                        cmd.Parameters.AddWithValue("@StrSorting", strOrderBy);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(dsB);
                    }
                }
                //using (SqlConnection con = new SqlConnection(olddbFE))
                using (SqlConnection con = new SqlConnection(dbAccessDALFEMS.ConnectionString))
                {
                    strCondition = strCondition + " AND TypeOfRequestVal !=' T&C'";
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_CRMRequest_GetAll";

                        cmd.Parameters.AddWithValue("@PageIndex", pageFilter.PageIndex);
                        cmd.Parameters.AddWithValue("@PageSize", pageFilter.PageSize);
                        cmd.Parameters.AddWithValue("@StrCondition", strCondition);
                        cmd.Parameters.AddWithValue("@StrSorting", strOrderBy);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(dsF);
                    }
                }
                // ds.Tables[0].Rows;
                // ds.Tables[0].Rows.Add(ds.Tables[0].Rows);
                DataTable dtss = ds.Tables[0];
                DataTable dtsB = dsF.Tables[0];
                foreach (DataRow dtRow in dtss.Rows)
                {

                    DataRow dr = dtRow;

                    dsB.Tables[0].Rows.Add(new Object[] { dtRow["CRMRequestId"], dtRow["RequestNo"], dtRow["RequestDateTime"], dtRow["TypeOfRequestVal"], dtRow["RequestStatusValue"], dtRow["IsWorkOrder"], dtRow["ModifiedDateUTC"], dtRow["ReqStaffId"], dtRow["ReqStaff"], dtRow["Model"], dtRow["Manufacturer"], dtRow["TotalRecords"], dtRow["AssetNo"], dtRow["AssetId"] });


                }
                foreach (DataRow dtRow in dtsB.Rows)
                {

                    DataRow dr = dtRow;

                    dsB.Tables[0].Rows.Add(new Object[] { dtRow["CRMRequestId"], dtRow["RequestNo"], dtRow["RequestDateTime"], dtRow["TypeOfRequestVal"], dtRow["RequestStatusValue"], dtRow["IsWorkOrder"], dtRow["ModifiedDateUTC"], dtRow["ReqStaffId"], dtRow["ReqStaff"], dtRow["Model"], dtRow["Manufacturer"], dtRow["TotalRecords"], dtRow["AssetNo"], dtRow["AssetId"] });


                }


                // old if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                if (dsB.Tables.Count != 0 && dsB.Tables[0].Rows.Count > 0)
                {
                    int counts = dsB.Tables[0].Rows.Count;
                    pageFilter.Rows = 10;
                    int mdbcount = Convert.ToInt32(dsB.Tables[0].Rows[0]["TotalRecords"]);
                    int bemscount = Convert.ToInt32(dsB.Tables[0].Rows[counts - 1]["TotalRecords"]);
                    // var totalRecords = Convert.ToInt32(dsB.Tables[0].Rows[0]["TotalRecords"]);
                    var totalRecords = mdbcount + bemscount;
                    var totalPages = (int)Math.Ceiling((float)totalRecords / (float)pageFilter.Rows);

                    var commonDAL = new CommonDAL();
                    var currentPageList = commonDAL.ToDynamicList(dsB.Tables[0]);
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

        public GridFilterResult GetallService(int id, SortPaginateFilter pageFilter)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetallService), Level.Info.ToString());
                GridFilterResult filterResult = null;
                //pageFilter.PageIndex = pageFilter.PageIndex == 0 ? 1 : pageFilter.PageIndex;
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

                var QueryCondition = pageFilter.QueryWhereCondition;
                var strCondition = string.Empty;
                if (string.IsNullOrEmpty(QueryCondition))
                {
                    strCondition = "FacilityId = " + _UserSession.FacilityId.ToString();
                }
                else
                {
                    strCondition = QueryCondition + " AND FacilityId = " + _UserSession.FacilityId.ToString();
                }

                var ds = new DataSet();
                var dbAccessDAL = new MASTERDBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_CRMRequest_GetAll";

                        cmd.Parameters.AddWithValue("@PageIndex", pageFilter.PageIndex);
                        cmd.Parameters.AddWithValue("@PageSize", pageFilter.PageSize);
                        cmd.Parameters.AddWithValue("@StrCondition", strCondition);
                        cmd.Parameters.AddWithValue("@StrSorting", strOrderBy);

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
                Log4NetLogger.LogExit(_FileName, nameof(GetallService), Level.Info.ToString());
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
        public void deleteChildrecords(string id)
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
                        cmd.CommandText = "UspFM_CRMRequestDet_Delete";
                        cmd.Parameters.AddWithValue("@pCRMRequestDetId", id);

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

        public CRMRequestEntity ConvertWO(CRMRequestEntity model)
        {
            try
            {


                var dbAccessDAL = new MASTERDBAccessDAL();
                var BBdbAccessDAL = new MASTERBEMSDBAccessDAL();
                var FFdbAccessDAL = new MASTERFEMSDBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();

                var parametersS = new Dictionary<string, string>();
                parametersS.Add("@pManufacturerId", Convert.ToString(model.ManufacturerId));
                parametersS.Add("@pModelId", Convert.ToString(model.ModelId));
                DataSet dts = new DataSet();
                if (model.ModelId > 0)
                {
                    dts = dbAccessDAL.MasterGetDataSet("uspFM_ManufacturerId_ModelId_Get_BYIDS_mappingTo_SeviceDB", parametersS, DataSetparameters);
                    if (model.TypeOfRequest == 137 || model.TypeOfRequest == 136 || model.TypeOfRequest == 374)
                    {
                        foreach (DataRow row in dts.Tables[0].Rows)
                        {
                            model.ManufacturerId = Convert.ToInt32(row["ManufacturerId_mappingTo_SeviceDB"]);
                            model.ModelId = Convert.ToInt32(row["ModelId_mappingTo_SeviceDB"]);
                        }

                    }
                    else
                    {
                    }
                }
                else
                {
                }


                var WOAssigneEmail = model.WOAssigneeEmail;
                var WOAssId = model.WOAssigneeId;
                Log4NetLogger.LogEntry(_FileName, nameof(ConvertWO), Level.Info.ToString());
                CRMRequestEntity griddata = new CRMRequestEntity();
                // var SdbAccessDAL = new DBAccessDAL();               
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));
                parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@pServiceId", Convert.ToString(model.ServiceId));

                parameters.Add("@pCRMRequestWOId", Convert.ToString(model.CRMWorkorderId)); //
                parameters.Add("@pCRMWorkOrderNo", Convert.ToString(model.CRMWorkorderNo));
                parameters.Add("@pCRMWorkOrderDateTime", Convert.ToString(model.WorkorderTimeUTC == null || model.WorkorderTimeUTC == DateTimeOffset.MinValue ? null : model.WorkorderTimeUTC.ToString("MM-dd-yyy HH:mm")));
                parameters.Add("@pStatus", Convert.ToString(model.RequestStatus));
                parameters.Add("@pDescription", Convert.ToString(model.RequestDescription));
                parameters.Add("@pTypeOfRequest", Convert.ToString(model.TypeOfRequest));


                parameters.Add("@pAssetId", Convert.ToString(null)); //
                parameters.Add("@pAssignedUserId", Convert.ToString(model.WOAssigneeId)); //
                parameters.Add("@pTimestamp", Convert.ToString(model.Timestamp)); //

                parameters.Add("@pRemarks", Convert.ToString(model.Remarks));

                parameters.Add("@pModelId", Convert.ToString(model.ModelId));
                parameters.Add("@pManufacturerId", Convert.ToString(model.ManufacturerId));
                parameters.Add("@pUserAreaId", Convert.ToString(model.UserAreaId));
                parameters.Add("@pUserLocationId", Convert.ToString(model.UserLocationId));

                if (model.TypeOfRequest == 136 || model.TypeOfRequest == 137)
                {
                    parameters.Add("@pRequesterId", Convert.ToString(model.ReqStaffId));
                }


                var dec = new Dictionary<string, DataTable>();
                DataTable dt = new DataTable();
                if (model.TypeOfRequest == 136 || model.TypeOfRequest == 137)
                {
                    if (model.CRMRequestGridData != null)
                    {
                        // updateNotification(model);

                        dt.Columns.Add("CRMRequestDetId", typeof(int));
                        dt.Columns.Add("CRMRequestId", typeof(int));
                        dt.Columns.Add("AssetId", typeof(int));



                        DataTable ds = new DataTable();
                        DataTable bems = new DataTable();

                        if (model.ServiceId == 1)
                        {
                            model.CRMRequestId = model.CRMRequestId - 1000000000;
                            foreach (var i in model.CRMRequestGridData)
                            {
                                dt.Rows.Add(i.CRMRequestDetId, i.CRMRequestId, i.AssetId);
                            }
                            dec.Add("@pCRMDet", dt);
                            parameters.Add("@pCRMRequestId", Convert.ToString(model.CRMRequestId));
                            ds = FFdbAccessDAL.GetMasterDataTable("uspFM_CRMRequestWorkOrderTxn_Asset_Save", parameters, dec);
                        }
                        else
                        {
                            model.CRMRequestId = model.CRMRequestId - 900000000;
                            foreach (var i in model.CRMRequestGridData)
                            {
                                dt.Rows.Add(i.CRMRequestDetId, i.CRMRequestId, i.AssetId);
                            }
                            dec.Add("@pCRMDet", dt);
                            parameters.Add("@pCRMRequestId", Convert.ToString(model.CRMRequestId));
                            ds = BBdbAccessDAL.GetMasterDataTable("uspFM_CRMRequestWorkOrderTxn_Asset_Save", parameters, dec);
                        }

                        //  ds = dbAccessDAL.GetMASTERDataTable("uspFM_CRMRequestWorkOrderTxn_Asset_Save", parameters, dec);

                        if (ds != null)
                        {
                            //foreach (DataRow row in ds.Rows)
                            //{


                            //    model.CRMWorkorderId = Convert.ToInt32(row["CRMRequestWOId"]);
                            //    model.CRMRequestId = Convert.ToInt32(row["CRMRequestId"]);
                            //    model.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                            //    model.CRMWorkorderNo = Convert.ToString(row["CRMWorkOrderNo"]);
                            //    model.WorkorderDate = Convert.ToDateTime(row["CRMWorkOrderDateTime"]);
                            //    model.HiddenId = Convert.ToString(row["GuId"]);
                            //    model.HiddenIdReq = Convert.ToString(row["RequestGuid"]);

                            //    model.WOAssigneeEmail = WOAssigneEmail;
                            //    model.WOAssigneeId = WOAssId;
                            //    SendMailAssignee(model);
                                if (model.TypeOfRequest == 137 || model.TypeOfRequest == 136 || model.TypeOfRequest == 374)
                                {
                                    if (model.ServiceId == 2)
                                    {
                                        model.CRMRequestId = model.CRMRequestId + 900000000;
                                    }
                                    else
                                    {
                                        model.CRMRequestId = model.CRMRequestId + 1000000000;
                                    }
                                }

                                //   SendMailAssignee(model);
                            }
                        }
                       

                    //}
                }
                else if (model.TypeOfRequest == 134 || model.TypeOfRequest == 138)
                {
                    parameters.Add("@pCRMRequestId", Convert.ToString(model.CRMRequestId));
                    DataTable ds = dbAccessDAL.GetMASTERDataTable("uspFM_CRMRequestWorkOrderTxn_Save", parameters, dec);
                    if (ds != null)
                    {
                        foreach (DataRow row in ds.Rows)
                        {
                            model.CRMWorkorderId = Convert.ToInt32(row["CRMRequestWOId"]);
                            model.CRMRequestId = Convert.ToInt32(row["CRMRequestId"]);
                            model.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                            model.CRMWorkorderNo = Convert.ToString(row["CRMWorkOrderNo"]);
                            model.WorkorderDate = Convert.ToDateTime(row["CRMWorkOrderDateTime"]);
                            model.HiddenId = Convert.ToString(row["GuId"]);
                            model.HiddenIdReq = Convert.ToString(row["RequestGuid"]);
                        }
                        model.WOAssigneeEmail = WOAssigneEmail;
                        model.WOAssigneeId = WOAssId;
                        SendMailAssignee(model);
                    }
                    //updateNotificationSingle(model);
                }

                SendMailWorkorder(model);

                model = Get(model.CRMRequestId, 5, 1);
                Log4NetLogger.LogExit(_FileName, nameof(ConvertWO), Level.Info.ToString());
                return model;
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

        //public CRMRequestEntity ApplyingProcess(CRMRequestEntity model)
        //{
        //    try
        //    {
        //        var reqemailverify = model.RequesterEmail;
        //        Log4NetLogger.LogEntry(_FileName, nameof(ConvertWO), Level.Info.ToString());
        //        CRMRequestEntity griddata = new CRMRequestEntity();
        //        //var dbAccessDAL = new DBAccessDAL();
        //        var dbAccessDAL = new MASTERDBAccessDAL();
        //        var BBdbAccessDAL = new MASTERBEMSDBAccessDAL();
        //        var FFdbAccessDAL = new MASTERFEMSDBAccessDAL();
        //        var parameters = new Dictionary<string, string>();
        //        parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));

        //        parameters.Add("@pFlag", Convert.ToString(model.FMREQProcess));
        //        parameters.Add("@pRemarks", Convert.ToString(model.Remarks));
        //        parameters.Add("@pAssigneeId", Convert.ToString(model.AssigneeId));
        //        parameters.Add("@RequestType", Convert.ToString(model.TypeOfRequest));
        //        parameters.Add("@CurrDateTime", Convert.ToString(model.CurrentDatetimeLocal == null || model.CurrentDatetimeLocal == DateTime.MinValue ? null : model.CurrentDatetimeLocal.ToString("MM-dd-yyy HH:mm")));

        //        var Assigemail = model.AssigneeEmail;
        //        var ReqEmail = model.RequesterEmail;
        //        var dec = new Dictionary<string, DataTable>();
        //        DataTable dt = new DataTable();
        //        int addval = 0;
        //        DataTable ds = new DataTable();
        //        if (model.TypeOfRequest == 137 || model.TypeOfRequest == 136 || model.TypeOfRequest == 374)
        //        {
        //            if (model.ServiceId == 1)
        //            {
        //                model.CRMRequestId = model.CRMRequestId - 1000000000;
        //                parameters.Add("@WorkGroup", Convert.ToString(model.WorkGroup));
        //                parameters.Add("@pCRMRequestId", Convert.ToString(model.CRMRequestId));
        //                ds = FFdbAccessDAL.GetMasterDataTable("uspFM_CRMRequest_Update", parameters, dec);

        //            }
        //            else
        //            {
        //                model.CRMRequestId = model.CRMRequestId - 900000000;
        //                parameters.Add("@pCRMRequestId", Convert.ToString(model.CRMRequestId));
        //                ds = BBdbAccessDAL.GetMasterDataTable("uspFM_CRMRequest_Update", parameters, dec);
        //            }
        //        }
        //        else
        //        {
        //            parameters.Add("@pCRMRequestId", Convert.ToString(model.CRMRequestId));

        //            //if (model.ServiceId==4)
        //            //{
        //            parameters.Add("@Responce_Date", Convert.ToString(model.Responce_Date == null || model.Responce_Date == DateTime.MinValue ? null : model.Responce_Date.ToString("MM-dd-yyy HH:mm")));


        //            //}
        //            //else
        //            //{
        //            //}
        //            if (model.TypeOfRequest == 10020)
        //            {
        //                parameters.Clear();
        //                parameters.Add("@pCRMRequestId", Convert.ToString(model.CRMRequestId));
        //                parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));
        //                parameters.Add("@pFlag", Convert.ToString(model.FMREQProcess));
        //                parameters.Add("@pRemarks", Convert.ToString(model.Action_Taken));
        //                parameters.Add("@pAssigneeId", Convert.ToString(model.AssigneeId));
        //                parameters.Add("@RequestType", Convert.ToString(model.TypeOfRequest));
        //                parameters.Add("@CurrDateTime", Convert.ToString(model.CurrentDatetimeLocal == null || model.CurrentDatetimeLocal == DateTime.MinValue ? null : model.CurrentDatetimeLocal.ToString("MM-dd-yyy HH:mm")));
        //                parameters.Add("@Responce_Id", Convert.ToString(model.LLSResponse_by_ID));
        //                parameters.Add("@Responce_Date", Convert.ToString(model.Responce_Date == null || model.Responce_Date == DateTime.MinValue ? null : model.Responce_Date.ToString("MM-dd-yyy HH:mm")));
        //                parameters.Add("@pAssetId", Convert.ToString(model.AssetId));
        //                parameters.Add("@pAssetNo", Convert.ToString(model.AssetNo));
        //                parameters.Add("@WorkGroup", Convert.ToString(model.WorkGroup));
        //                ds = dbAccessDAL.GetMASTERDataTable("uspFM_CRMRequest_Update_NCR", parameters, dec);
        //            }
        //            else
        //            {
        //               // parameters.Add("@Responce_Date", Convert.ToString(model.Responce_Date == null || model.Responce_Date == DateTime.MinValue ? null : model.Responce_Date.ToString("MM-dd-yyy HH:mm")));
        //                parameters.Add("@Responce_Id", Convert.ToString(model.LLSResponse_by_ID));
        //                ds = dbAccessDAL.GetMASTERDataTable("uspFM_CRMRequest_Update", parameters, dec);

        //            }

        //            //---service for only 4
        //        }




        //        if (ds != null)
        //        {
        //            foreach (DataRow row in ds.Rows)
        //            {
        //                model.CRMRequestId = Convert.ToInt32(row["CRMRequestId"]);
        //                model.FMREQProcess = Convert.ToString(row["Flag"]);
        //                model.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
        //            }

        //        }
        //        DataTable dtt1 = new DataTable();
        //        if (model.TypeOfRequest == 375)
        //        {
        //            if (model.ServiceId == 1)
        //            {
        //                // var BdbAccessDAL = new MASTERBEMSDBAccessDAL();
        //                dtt1 = FFdbAccessDAL.GetMasterDataTable("uspFM_CRMRequest_Update", parameters, dec);
        //            }
        //            else
        //            {
        //                // var BdbAccessDAL = new MASTERBEMSDBAccessDAL();
        //                dtt1 = BBdbAccessDAL.GetMasterDataTable("uspFM_CRMRequest_Update", parameters, dec);
        //            }
        //        }
        //        if (model.TypeOfRequest == 137 || model.TypeOfRequest == 136 || model.TypeOfRequest == 374)
        //        {
        //            if (model.ServiceId == 2)
        //            {
        //                model.CRMRequestId = model.CRMRequestId + 900000000;
        //            }
        //            else
        //            {
        //                model.CRMRequestId = model.CRMRequestId + 1000000000;
        //            }
        //        }
        //        model = Get(model.CRMRequestId, 15, 1);
        //        model.AssigneeEmail = Assigemail;
        //        model.RequesterEmail = ReqEmail;
        //        //model.RequesterEmail = reqemailverify;
        //        try
        //        {


        //            if (model.TypeOfRequest == 375 && model.FMREQProcess == "Approve")
        //            {
        //                SendMailApprove(model);
        //            }

        //            if (model.FMREQProcess == "Approve")
        //            {
        //                SendMailApproveAll(model);
        //            }

        //            if (model.FMREQProcess == "Reject")
        //            {
        //                SendMailReject(model);
        //            }

        //            if (model.FMREQProcess == "Verify")
        //            {
        //                SendMailVerify(model);
        //            }

        //        }
        //        catch
        //        {
        //        }

        //        Log4NetLogger.LogExit(_FileName, nameof(ConvertWO), Level.Info.ToString());
        //        return model;
        //    }
        //    catch (DALException dalex)
        //    {
        //        throw new DALException(dalex);
        //    }
        //    catch (Exception ex)
        //    {
        //        throw ex;
        //    }
        //}

        public CRMRequestEntity ApplyingProcess(CRMRequestEntity model)
        {
            try
            {
                var reqemailverify = model.RequesterEmail;
                Log4NetLogger.LogEntry(_FileName, nameof(ConvertWO), Level.Info.ToString());
                CRMRequestEntity griddata = new CRMRequestEntity();
                //var dbAccessDAL = new DBAccessDAL();
                var dbAccessDAL = new MASTERDBAccessDAL();
                var BBdbAccessDAL = new MASTERBEMSDBAccessDAL();
                var FFdbAccessDAL = new MASTERFEMSDBAccessDAL();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));

                parameters.Add("@pFlag", Convert.ToString(model.FMREQProcess));
                parameters.Add("@pRemarks", Convert.ToString(model.Remarks));
                parameters.Add("@pAssigneeId", Convert.ToString(model.AssigneeId));
                parameters.Add("@RequestType", Convert.ToString(model.TypeOfRequest));
                parameters.Add("@CurrDateTime", Convert.ToString(model.CurrentDatetimeLocal == null || model.CurrentDatetimeLocal == DateTime.MinValue ? null : model.CurrentDatetimeLocal.ToString("MM-dd-yyy HH:mm")));
                parameters.Add("@WorkGroup", Convert.ToString(model.WorkGroup));
                var Assigemail = model.AssigneeEmail;
                var ReqEmail = model.RequesterEmail;
                var dec = new Dictionary<string, DataTable>();
                DataTable dt = new DataTable();
                int addval = 0;
                DataTable ds = new DataTable();
                if (model.TypeOfRequest == 137 || model.TypeOfRequest == 136 || model.TypeOfRequest == 374)
                {
                    if (model.ServiceId == 1)
                    {
                        model.CRMRequestId = model.CRMRequestId - 1000000000;
                        parameters.Add("@pCRMRequestId", Convert.ToString(model.CRMRequestId));
                        ds = FFdbAccessDAL.GetMasterDataTable("uspFM_CRMRequest_Update", parameters, dec);

                    }
                    else
                    {
                        model.CRMRequestId = model.CRMRequestId - 900000000;
                        parameters.Add("@pCRMRequestId", Convert.ToString(model.CRMRequestId));
                        ds = BBdbAccessDAL.GetMasterDataTable("uspFM_CRMRequest_Update", parameters, dec);
                    }
                }
                else
                {
                    parameters.Add("@pCRMRequestId", Convert.ToString(model.CRMRequestId));

                    //if (model.ServiceId==4)
                    //{
                    parameters.Add("@Responce_Date", Convert.ToString(model.Responce_Date == null || model.Responce_Date == DateTime.MinValue ? null : model.Responce_Date.ToString("MM-dd-yyy HH:mm")));


                    //}
                    //else
                    //{
                    //}
                    if (model.TypeOfRequest == 10020)
                    {
                        parameters.Clear();
                        parameters.Add("@pCRMRequestId", Convert.ToString(model.CRMRequestId));
                        parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));
                        parameters.Add("@pFlag", Convert.ToString(model.FMREQProcess));
                        parameters.Add("@pRemarks", Convert.ToString(model.Action_Taken));
                        parameters.Add("@pAssigneeId", Convert.ToString(model.AssigneeId));
                        parameters.Add("@RequestType", Convert.ToString(model.TypeOfRequest));
                        parameters.Add("@CurrDateTime", Convert.ToString(model.CurrentDatetimeLocal == null || model.CurrentDatetimeLocal == DateTime.MinValue ? null : model.CurrentDatetimeLocal.ToString("MM-dd-yyy HH:mm")));
                        parameters.Add("@Responce_Id", Convert.ToString(model.LLSResponse_by_ID));
                        parameters.Add("@Responce_Date", Convert.ToString(model.Responce_Date == null || model.Responce_Date == DateTime.MinValue ? null : model.Responce_Date.ToString("MM-dd-yyy HH:mm")));
                        parameters.Add("@pAssetId", Convert.ToString(model.AssetId));
                        parameters.Add("@pAssetNo", Convert.ToString(model.AssetNo));
                        parameters.Add("@WorkGroup", Convert.ToString(model.WorkGroup));
                        ds = dbAccessDAL.GetMASTERDataTable("uspFM_CRMRequest_Update_NCR", parameters, dec);
                    }
                    else
                    {
                        // parameters.Add("@Responce_Date", Convert.ToString(model.Responce_Date == null || model.Responce_Date == DateTime.MinValue ? null : model.Responce_Date.ToString("MM-dd-yyy HH:mm")));
                        parameters.Add("@Responce_Id", Convert.ToString(model.LLSResponse_by_ID));
                        ds = dbAccessDAL.GetMASTERDataTable("uspFM_CRMRequest_Update", parameters, dec);

                    }

                    //---service for only 4
                }



                if (ds != null)
                {
                    foreach (DataRow row in ds.Rows)
                    {
                        model.CRMRequestId = Convert.ToInt32(row["CRMRequestId"]);
                        model.FMREQProcess = Convert.ToString(row["Flag"]);
                        model.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                    }

                }
                DataTable dtt1 = new DataTable();
                if (model.TypeOfRequest == 375)
                {
                    if (model.ServiceId == 1)
                    {
                        // var BdbAccessDAL = new MASTERBEMSDBAccessDAL();
                        dtt1 = FFdbAccessDAL.GetMasterDataTable("uspFM_CRMRequest_Update", parameters, dec);
                    }
                    else
                    {
                        // var BdbAccessDAL = new MASTERBEMSDBAccessDAL();
                        dtt1 = BBdbAccessDAL.GetMasterDataTable("uspFM_CRMRequest_Update", parameters, dec);
                    }
                }
                if (model.TypeOfRequest == 137 || model.TypeOfRequest == 136 || model.TypeOfRequest == 374)
                {
                    if (model.ServiceId == 2)
                    {
                        model.CRMRequestId = model.CRMRequestId + 900000000;
                    }
                    else
                    {
                        model.CRMRequestId = model.CRMRequestId + 1000000000;
                    }
                }
                model = Get(model.CRMRequestId, 15, 1);
                model.AssigneeEmail = Assigemail;
                model.RequesterEmail = ReqEmail;
                //model.RequesterEmail = reqemailverify;
                try
                {


                    if (model.TypeOfRequest == 375 && model.FMREQProcess == "Approve")
                    {
                        SendMailApprove(model);
                    }

                    if (model.FMREQProcess == "Approve")
                    {
                        SendMailApproveAll(model);
                    }

                    if (model.FMREQProcess == "Reject")
                    {
                        SendMailReject(model);
                    }

                    if (model.FMREQProcess == "Verify")
                    {
                        SendMailVerify(model);
                    }

                }
                catch
                {
                }

                Log4NetLogger.LogExit(_FileName, nameof(ConvertWO), Level.Info.ToString());
                return model;
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


        private void SendMailWorkorder(CRMRequestEntity model)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(SendMailWorkorder), Level.Info.ToString());
            try
            {
                string emailTemplateId = string.Empty;
                string subject = string.Empty;
                string subjectVars = string.Empty;
                string templateVars = string.Empty;
                string email = string.Empty;

                emailTemplateId = "18";
                var tempid = Convert.ToInt32(emailTemplateId);
                model.TemplateId = tempid;
                templateVars = string.Join(",", model.CRMWorkorderNo);

                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable TypecodeDt = new DataTable();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pEmailTemplateId", Convert.ToString(emailTemplateId));
                parameters.Add("@pToEmailIds", email);
                parameters.Add("@pSubject", Convert.ToString(subject));
                parameters.Add("@pPriority", Convert.ToString(1));
                parameters.Add("@pSendAsHtml", Convert.ToString(1));
                parameters.Add("@pSubjectVars", Convert.ToString(subjectVars));
                parameters.Add("@pTemplateVars", Convert.ToString(templateVars));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));

                var dbAccessDAL = new MASTERDBAccessDAL();
                DataTable dt = dbAccessDAL.GetMASTERDataTable("uspFM_EmailNotify_Save", parameters, DataSetparameters);
                if (dt != null)
                {
                    foreach (DataRow rows in dt.Rows)
                    {


                    }
                }
                updateNotificationSingle(model);
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

        private void SendMailRequest(CRMRequestEntity model)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(SendMailRequest), Level.Info.ToString());
            try
            {
                string emailTemplateId = string.Empty;
                string subject = string.Empty;
                string subjectVars = string.Empty;
                string templateVars = string.Empty;
                string email = string.Empty;

                var emailIds = model.UserAreaCompRep + "," + model.UserAreaFacRep;
                emailTemplateId = "19";

                var tempid = Convert.ToInt32(emailTemplateId);
                model.TemplateId = tempid;
                templateVars = string.Join(",", model.RequestNo);

                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable TypecodeDt = new DataTable();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pEmailTemplateId", Convert.ToString(emailTemplateId));
                parameters.Add("@pToEmailIds", Convert.ToString(emailIds));
                parameters.Add("@pSubject", Convert.ToString(subject));
                parameters.Add("@pPriority", Convert.ToString(1));
                parameters.Add("@pSendAsHtml", Convert.ToString(1));
                parameters.Add("@pSubjectVars", Convert.ToString(subjectVars));
                parameters.Add("@pTemplateVars", Convert.ToString(templateVars));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));

                var dbAccessDAL = new MASTERDBAccessDAL();
                DataTable dt = dbAccessDAL.GetMASTERDataTable("uspFM_EmailNotify_Save", parameters, DataSetparameters);
                if (dt != null)
                {
                    foreach (DataRow rows in dt.Rows)
                    {


                    }
                }
                SaveNotification(model);
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

        private void SendMailApprove(CRMRequestEntity model)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(SendMailApprove), Level.Info.ToString());
            try
            {
                string emailTemplateId = string.Empty;
                string subject = string.Empty;
                string subjectVars = string.Empty;
                string templateVars = string.Empty;
                string email = string.Empty;

                email = model.AssigneeEmail;
                var emailreq = model.RequesterEmail;
                //var allemail = email + "," + emailreq;
                emailTemplateId = "32";
                var tempid = Convert.ToInt32(emailTemplateId);
                model.TemplateId = tempid;

                var TargetDate = model.TargetDate.Value.ToString("dd-MMM-yyyy");

                templateVars = string.Join(",", model.RequestNo, TargetDate);

                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable TypecodeDt = new DataTable();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pEmailTemplateId", Convert.ToString(emailTemplateId));
                parameters.Add("@pToEmailIds", email);
                parameters.Add("@pSubject", Convert.ToString(subject));
                parameters.Add("@pPriority", Convert.ToString(1));
                parameters.Add("@pSendAsHtml", Convert.ToString(1));
                parameters.Add("@pSubjectVars", Convert.ToString(subjectVars));
                parameters.Add("@pTemplateVars", Convert.ToString(templateVars));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));


                var dbAccessDAL = new MASTERDBAccessDAL();
                DataTable dt = dbAccessDAL.GetMASTERDataTable("uspFM_EmailNotify_Save", parameters, DataSetparameters);
                if (dt != null)
                {
                    foreach (DataRow rows in dt.Rows)
                    {


                    }
                }
                ApproveTCWebNotification(model);
                ApproveTCWebNotificationAssignee(model);
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

        private void SendMailApproveAll(CRMRequestEntity model)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(SendMailApproveAll), Level.Info.ToString());
            try
            {
                string emailTemplateId = string.Empty;
                string subject = string.Empty;
                string subjectVars = string.Empty;
                string templateVars = string.Empty;
                string email = string.Empty;

                email = model.RequesterEmail;
                emailTemplateId = "37";
                var tempid = Convert.ToInt32(emailTemplateId);
                model.TemplateId = tempid;
                templateVars = string.Join(",", model.RequestNo);

                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable TypecodeDt = new DataTable();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pEmailTemplateId", Convert.ToString(emailTemplateId));
                parameters.Add("@pToEmailIds", email);
                parameters.Add("@pSubject", Convert.ToString(subject));
                parameters.Add("@pPriority", Convert.ToString(1));
                parameters.Add("@pSendAsHtml", Convert.ToString(1));
                parameters.Add("@pSubjectVars", Convert.ToString(subjectVars));
                parameters.Add("@pTemplateVars", Convert.ToString(templateVars));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));

                DataTable dt = new DataTable();
                var dbAccessDAL = new DBAccessDAL();
                var FdbAccessDAL = new MASTERFEMSDBAccessDAL();
                var BdbAccessDAL = new MASTERBEMSDBAccessDAL();
                if (model.TypeOfRequest == 137 || model.TypeOfRequest == 136 || model.TypeOfRequest == 374)
                {
                    // otherparameters.Add("@pCRMRequest_PriorityId", Convert.ToString(model.PriorityList));
                    if (model.ServiceId == 1)
                    {
                        dt = FdbAccessDAL.GetMasterDataTable("uspFM_EmailNotify_Save", parameters, DataSetparameters);
                    }
                    else
                    {
                        dt = BdbAccessDAL.GetMasterDataTable("uspFM_EmailNotify_Save", parameters, DataSetparameters);
                    }


                }
                else
                {
                    dt = dbAccessDAL.GetDataTable("uspFM_EmailNotify_Save", parameters, DataSetparameters);
                }



                if (dt != null)
                {
                    foreach (DataRow rows in dt.Rows)
                    {


                    }
                }
                ApproveAllWebNotification(model);
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

        private void SendMailReject(CRMRequestEntity model)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(SendMailReject), Level.Info.ToString());
            try
            {
                string emailTemplateId = string.Empty;
                string subject = string.Empty;
                string subjectVars = string.Empty;
                string templateVars = string.Empty;
                string email = string.Empty;

                email = model.RequesterEmail;
                emailTemplateId = "38";
                var tempid = Convert.ToInt32(emailTemplateId);
                model.TemplateId = tempid;
                templateVars = string.Join(",", model.RequestNo);

                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable TypecodeDt = new DataTable();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pEmailTemplateId", Convert.ToString(emailTemplateId));
                parameters.Add("@pToEmailIds", email);
                parameters.Add("@pSubject", Convert.ToString(subject));
                parameters.Add("@pPriority", Convert.ToString(1));
                parameters.Add("@pSendAsHtml", Convert.ToString(1));
                parameters.Add("@pSubjectVars", Convert.ToString(subjectVars));
                parameters.Add("@pTemplateVars", Convert.ToString(templateVars));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));


                var dbAccessDAL = new DBAccessDAL();
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_EmailNotify_Save", parameters, DataSetparameters);
                if (dt != null)
                {
                    foreach (DataRow rows in dt.Rows)
                    {


                    }
                }
                RejectWebNotification(model);
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

        public CRMRequestEntity SaveNotification(CRMRequestEntity ent)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(save), Level.Info.ToString());
            CRMRequestEntity griddata = new CRMRequestEntity();
            var dbAccessDAL = new MASTERDBAccessDAL();
            var parameters = new Dictionary<string, string>();
            var DataSetparameters = new Dictionary<string, DataTable>();

            var notalert = ent.RequestNo + " " + "New CRM Request has been Created";

            var hyplink = "/master/mastercrmrequest?id=" + ent.CRMRequestId;

            parameters.Add("@pNotificationId", Convert.ToString(ent.NotificationId));
            parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
            parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
            parameters.Add("@pUserId", Convert.ToString(ent.ReqStaffId));
            parameters.Add("@pNotificationAlerts", Convert.ToString(notalert));
            parameters.Add("@pRemarks", Convert.ToString(""));
            parameters.Add("@pHyperLink", Convert.ToString(hyplink));
            parameters.Add("@pIsNew", Convert.ToString(1));
            parameters.Add("@pNotificationDateTime", Convert.ToString(null));
            parameters.Add("@pEmailTempId", Convert.ToString(ent.TemplateId));

            //  parameters.Add("@pMultipleUserIds", Convert.ToString(allIds));

            parameters.Add("@pmScreenName", Convert.ToString("CRMRequestStatus"));
            parameters.Add("@pMGuid", Convert.ToString(ent.HiddenId));

            DataTable ds = dbAccessDAL.GetMASTERDataTable("uspFM_WebNotificationSingle_Save", parameters, DataSetparameters);
            if (ds != null)
            {
                foreach (DataRow row in ds.Rows)
                {
                    //model.CRMRequestId = Convert.ToInt32(row["CRMRequestId"]);
                    //model.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                    //// model.err = Convert.ToBase64String((byte[])(row["Timestamp"]));
                    //model.HiddenId = Convert.ToString(row["GuId"]);
                }
            }

            return ent;
        }
        public CRMRequestEntity ApproveAllWebNotification(CRMRequestEntity ent)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(save), Level.Info.ToString());
            CRMRequestEntity griddata = new CRMRequestEntity();
            var dbAccessDAL = new DBAccessDAL();
            var FdbAccessDAL = new MASTERFEMSDBAccessDAL();
            var BdbAccessDAL = new MASTERBEMSDBAccessDAL();
            var parameters = new Dictionary<string, string>();
            var DataSetparameters = new Dictionary<string, DataTable>();

            var notalert = ent.RequestNo + " " + "CRM Request has been Approved";

            var hyplink = "/master/mastercrmrequest?id=" + ent.CRMRequestId;

            parameters.Add("@pNotificationId", Convert.ToString(ent.NotificationId));
            parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
            parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
            parameters.Add("@pUserId", Convert.ToString(ent.ReqStaffId));
            parameters.Add("@pNotificationAlerts", Convert.ToString(notalert));
            parameters.Add("@pRemarks", Convert.ToString(""));
            parameters.Add("@pHyperLink", Convert.ToString(hyplink));
            parameters.Add("@pIsNew", Convert.ToString(1));
            parameters.Add("@pNotificationDateTime", Convert.ToString(null));
            parameters.Add("@pEmailTempId", Convert.ToString(ent.TemplateId));

            parameters.Add("@pmScreenName", Convert.ToString("CRMRequestStatus"));
            parameters.Add("@pMGuid", Convert.ToString(ent.HiddenId));
            DataTable ds = new DataTable();

            if (ent.TypeOfRequest == 137 || ent.TypeOfRequest == 136 || ent.TypeOfRequest == 374)
            {
                // otherparameters.Add("@pCRMRequest_PriorityId", Convert.ToString(model.PriorityList));
                if (ent.ServiceId == 1)
                {
                    ds = FdbAccessDAL.GetMasterDataTable("uspFM_WebNotificationSingle_Save", parameters, DataSetparameters);
                }
                else
                {
                    ds = BdbAccessDAL.GetMasterDataTable("uspFM_WebNotificationSingle_Save", parameters, DataSetparameters);
                }
            }
            else
            {
                ds = dbAccessDAL.GetDataTable("uspFM_WebNotificationSingle_Save", parameters, DataSetparameters);
            }







            if (ds != null)
            {
                foreach (DataRow row in ds.Rows)
                {
                    //model.CRMRequestId = Convert.ToInt32(row["CRMRequestId"]);
                    //model.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                    //// model.err = Convert.ToBase64String((byte[])(row["Timestamp"]));
                    //model.HiddenId = Convert.ToString(row["GuId"]);
                }
            }

            return ent;
        }
        public CRMRequestEntity RejectWebNotification(CRMRequestEntity ent)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(save), Level.Info.ToString());
            CRMRequestEntity griddata = new CRMRequestEntity();
            var dbAccessDAL = new DBAccessDAL();
            var parameters = new Dictionary<string, string>();
            var DataSetparameters = new Dictionary<string, DataTable>();

            var notalert = ent.RequestNo + " " + "CRM Request has been Rejected";

            var hyplink = "/master/mastercrmrequest?id=" + ent.CRMRequestId;

            parameters.Add("@pNotificationId", Convert.ToString(ent.NotificationId));
            parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
            parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
            parameters.Add("@pUserId", Convert.ToString(ent.ReqStaffId));
            parameters.Add("@pNotificationAlerts", Convert.ToString(notalert));
            parameters.Add("@pRemarks", Convert.ToString(""));
            parameters.Add("@pHyperLink", Convert.ToString(hyplink));
            parameters.Add("@pIsNew", Convert.ToString(1));
            parameters.Add("@pNotificationDateTime", Convert.ToString(null));
            parameters.Add("@pEmailTempId", Convert.ToString(ent.TemplateId));

            parameters.Add("@pmScreenName", Convert.ToString("CRMRequestStatus"));
            parameters.Add("@pMGuid", Convert.ToString(ent.HiddenId));

            DataTable ds = dbAccessDAL.GetDataTable("uspFM_WebNotificationSingle_Save", parameters, DataSetparameters);
            if (ds != null)
            {
                foreach (DataRow row in ds.Rows)
                {
                    //model.CRMRequestId = Convert.ToInt32(row["CRMRequestId"]);
                    //model.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                    //// model.err = Convert.ToBase64String((byte[])(row["Timestamp"]));
                    //model.HiddenId = Convert.ToString(row["GuId"]);
                }
            }

            return ent;
        }
        public CRMRequestEntity ApproveTCWebNotification(CRMRequestEntity ent)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(save), Level.Info.ToString());
            CRMRequestEntity griddata = new CRMRequestEntity();
            var dbAccessDAL = new DBAccessDAL();
            var FdbAccessDAL = new MASTERFEMSDBAccessDAL();
            var BdbAccessDAL = new MASTERBEMSDBAccessDAL();

            var parameters = new Dictionary<string, string>();
            var DataSetparameters = new Dictionary<string, DataTable>();

            var notalert = ent.RequestNo + " " + "CRM Request has been Approved";

            var hyplink = "/master/mastercrmrequest?id=" + ent.CRMRequestId;

            parameters.Add("@pNotificationId", Convert.ToString(ent.NotificationId));
            parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
            parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
            parameters.Add("@pUserId", Convert.ToString(ent.AssigneeId));
            parameters.Add("@pNotificationAlerts", Convert.ToString(notalert));
            parameters.Add("@pRemarks", Convert.ToString(""));
            parameters.Add("@pHyperLink", Convert.ToString(hyplink));
            parameters.Add("@pIsNew", Convert.ToString(1));
            parameters.Add("@pNotificationDateTime", Convert.ToString(null));
            parameters.Add("@pEmailTempId", Convert.ToString(ent.TemplateId));

            parameters.Add("@pmScreenName", Convert.ToString("CRMRequestStatus"));
            parameters.Add("@pMGuid", Convert.ToString(ent.HiddenId));

            DataTable ds = new DataTable();
            if (ent.TypeOfRequest == 137 || ent.TypeOfRequest == 136 || ent.TypeOfRequest == 374)
            {
                // otherparameters.Add("@pCRMRequest_PriorityId", Convert.ToString(model.PriorityList));
                if (ent.ServiceId == 1)
                {
                    ds = FdbAccessDAL.GetMasterDataTable("uspFM_WebNotificationSingle_Save", parameters, DataSetparameters);
                }
                else
                {
                    ds = BdbAccessDAL.GetMasterDataTable("uspFM_WebNotificationSingle_Save", parameters, DataSetparameters);
                }
            }
            else
            {
                ds = dbAccessDAL.GetDataTable("uspFM_WebNotificationSingle_Save", parameters, DataSetparameters);
            }





            if (ds != null)
            {
                foreach (DataRow row in ds.Rows)
                {
                    //model.CRMRequestId = Convert.ToInt32(row["CRMRequestId"]);
                    //model.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                    //// model.err = Convert.ToBase64String((byte[])(row["Timestamp"]));
                    //model.HiddenId = Convert.ToString(row["GuId"]);
                }
            }

            return ent;
        }

        public CRMRequestEntity ApproveTCWebNotificationAssignee(CRMRequestEntity ent)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(save), Level.Info.ToString());
            CRMRequestEntity griddata = new CRMRequestEntity();
            var dbAccessDAL = new DBAccessDAL();
            var FdbAccessDAL = new MASTERFEMSDBAccessDAL();
            var BdbAccessDAL = new MASTERBEMSDBAccessDAL();
            var parameters = new Dictionary<string, string>();
            var DataSetparameters = new Dictionary<string, DataTable>();

            var notalert = ent.RequestNo + " " + "CRM Request has been Approved and Assigned To You";

            var hyplink = "/master/mastercrmrequest?id=" + ent.CRMRequestId;

            parameters.Add("@pNotificationId", Convert.ToString(ent.NotificationId));
            parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
            parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
            parameters.Add("@pUserId", Convert.ToString(ent.AssigneeId));
            parameters.Add("@pNotificationAlerts", Convert.ToString(notalert));
            parameters.Add("@pRemarks", Convert.ToString(""));
            parameters.Add("@pHyperLink", Convert.ToString(hyplink));
            parameters.Add("@pIsNew", Convert.ToString(1));
            parameters.Add("@pNotificationDateTime", Convert.ToString(null));
            parameters.Add("@pEmailTempId", Convert.ToString(ent.TemplateId));

            parameters.Add("@pmScreenName", Convert.ToString("CRMRequestStatus"));
            parameters.Add("@pMGuid", Convert.ToString(ent.HiddenId));

            DataTable ds = new DataTable();
            if (ent.TypeOfRequest == 137 || ent.TypeOfRequest == 136 || ent.TypeOfRequest == 374)
            {
                // otherparameters.Add("@pCRMRequest_PriorityId", Convert.ToString(model.PriorityList));
                if (ent.ServiceId == 1)
                {
                    ds = FdbAccessDAL.GetMasterDataTable("uspFM_WebNotificationSingle_Save", parameters, DataSetparameters);
                }
                else
                {
                    ds = BdbAccessDAL.GetMasterDataTable("uspFM_WebNotificationSingle_Save", parameters, DataSetparameters);
                }
            }
            else
            {
                ds = dbAccessDAL.GetDataTable("uspFM_WebNotificationSingle_Save", parameters, DataSetparameters);

            }

            if (ds != null)
            {
                foreach (DataRow row in ds.Rows)
                {
                    //model.CRMRequestId = Convert.ToInt32(row["CRMRequestId"]);
                    //model.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                    //// model.err = Convert.ToBase64String((byte[])(row["Timestamp"]));
                    //model.HiddenId = Convert.ToString(row["GuId"]);
                }
            }

            return ent;
        }

        public CRMRequestEntity GetObsAsset(CRMRequestEntity model)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetObsAsset), Level.Info.ToString());
            try
            {
                DataSet dt = new DataSet();
                DataSet dts = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                var BEMSdbAccessDAL = new MASTERBEMSDBAccessDAL();
                var FEMSdbAccessDAL = new MASTERFEMSDBAccessDAL();
                CRMRequestEntity entity = new CRMRequestEntity();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                //parameters.Add("@pServiceId", Convert.ToString(EODCaptur.ServiceId));
                //parameters.Add("@pCategorySystemId", Convert.ToString(EODCaptur.CategorySystemId));
                parameters.Add("@pAssetNo", Convert.ToString(null));

                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));



                //if (model.ServiceId==1)
                //{
                //    DataSet dds = Get_subIDStypecode(model.ModelId, model.ManufacturerId);

                //    parameters.Add("@pManufacturerId", Convert.ToString(dds.Tables[0].Rows[0]["ManufacturerId"]));
                //    parameters.Add("@pModelId", Convert.ToString(dds.Tables[0].Rows[0]["ModelId"]));
                //    dt = FEMSdbAccessDAL.GetDataSet("uspFM_CRMAssetObsolete_Fetch", parameters, DataSetparameters);
                //}
                //else
                //{
                //    if (model.ServiceId==2)
                //    {
                //        DataSet dds = Get_subIDStypecode(model.ModelId, model.ManufacturerId);

                //        parameters.Add("@pManufacturerId", Convert.ToString(dds.Tables[0].Rows[0][0]));
                //        parameters.Add("@pModelId", Convert.ToString(dds.Tables[0].Rows[0][1]));
                //        dt = BEMSdbAccessDAL.GetDataSet("uspFM_CRMAssetObsolete_Fetch", parameters, DataSetparameters);
                //    } else
                //    {
                //        parameters.Add("@pManufacturerId", Convert.ToString(model.ManufacturerId));
                //        parameters.Add("@pModelId", Convert.ToString(model.ModelId));
                //        dt = dbAccessDAL.GetDataSet("uspFM_CRMAssetObsolete_Fetch", parameters, DataSetparameters);
                //    }

                //}

                parameters.Add("@pManufacturerId", Convert.ToString(model.ManufacturerId));
                parameters.Add("@pModelId", Convert.ToString(model.ModelId));
                //  dt = dbAccessDAL.GetDataSet("uspFM_CRMAssetObsolete_Fetch", parameters, DataSetparameters);
                parameters.Clear();

                parameters.Add("@pManufacturerId", Convert.ToString(model.ManufacturerId));
                parameters.Add("@pModelId", Convert.ToString(model.ModelId));

                dts = dbAccessDAL.GetDataSet("uspFM_ManufacturerId_ModelId_Get_BYIDS_mappingTo_SeviceDB", parameters, DataSetparameters);
                parameters.Clear();



                foreach (DataRow row in dts.Tables[0].Rows)
                {
                    model.ManufacturerId = Convert.ToInt32(row["ManufacturerId_mappingTo_SeviceDB"]);
                    model.ModelId = Convert.ToInt32(row["ModelId_mappingTo_SeviceDB"]);
                }
                parameters.Add("@pAssetNo", Convert.ToString(null));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@pManufacturerId", Convert.ToString(model.ManufacturerId));
                parameters.Add("@pModelId", Convert.ToString(model.ModelId));

                if (model.ServiceId == 2)
                {

                    dt = BEMSdbAccessDAL.GetDataSet("uspFM_CRMAssetObsolete_Fetch", parameters, DataSetparameters);

                }
                else
                {
                    if (model.ServiceId == 1)
                    {
                        dt = FEMSdbAccessDAL.GetDataSet("uspFM_CRMAssetObsolete_Fetch", parameters, DataSetparameters);
                    }
                    else
                    {

                    }

                }

                if (dt != null && dt.Tables.Count > 0)
                {

                    entity.CRMRequestGridData = (from n in dt.Tables[0].AsEnumerable()
                                                 select new CRMRequestGrid
                                                 {
                                                     //CRMRequestDetId = Convert.ToInt32(n["CRMRequestDetId"]),
                                                     //CRMRequestId = Convert.ToInt32(n["CRMRequestId"]),
                                                     AssetId = Convert.ToInt32(n["AssetId"]),
                                                     AssetNo = Convert.ToString(n["AssetNo"]),
                                                     SerialNo = Convert.ToString(n["SerialNo"] == DBNull.Value ? "" : (Convert.ToString(n["SerialNo"]))),
                                                     //Minimum = Convert.ToDecimal(n["Minimum"] == DBNull.Value ? 0 : (Convert.ToDecimal(n["Minimum"]))),
                                                     SoftwareVersion = Convert.ToString(n["SoftwareVersion"] == DBNull.Value ? "" : (Convert.ToString(n["SoftwareVersion"]))),
                                                     ////TotalRecords = Convert.ToInt32(n["TotalRecords"]),
                                                     ////TotalPages = Convert.ToInt32(n["TotalPageCalc"]),
                                                 }).ToList();

                }
                return entity;

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
        public CRMRequestEntity GetObsAssetM(int ManId, int ModId, int pagesize, int pageindex)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetObsAssetM), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                CRMRequestEntity entity = new CRMRequestEntity();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                //parameters.Add("@pServiceId", Convert.ToString(EODCaptur.ServiceId));
                //parameters.Add("@pCategorySystemId", Convert.ToString(EODCaptur.CategorySystemId));
                //parameters.Add("@pAssetNo", Convert.ToString(null));
                parameters.Add("@pAssetNo", Convert.ToString(""));
                parameters.Add("@pManufacturerId", Convert.ToString(ManId));
                parameters.Add("@pModelId", Convert.ToString(ModId));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@pPageIndex", Convert.ToString(pageindex));
                parameters.Add("@pPageSize", Convert.ToString(pagesize));
                DataSet dt = dbAccessDAL.GetDataSet("uspFM_CRMAsset_Fetch", parameters, DataSetparameters);
                if (dt != null && dt.Tables.Count > 0)
                {

                    entity.CRMRequestGridData = (from n in dt.Tables[0].AsEnumerable()
                                                 select new CRMRequestGrid
                                                 {
                                                     //CRMRequestDetId = Convert.ToInt32(n["CRMRequestDetId"]),
                                                     //CRMRequestId = Convert.ToInt32(n["CRMRequestId"]),
                                                     AssetId = Convert.ToInt32(n["AssetId"]),
                                                     AssetNo = Convert.ToString(n["AssetNo"]),
                                                     SerialNo = Convert.ToString(n["SerialNo"] == DBNull.Value ? "" : (Convert.ToString(n["SerialNo"]))),
                                                     //Minimum = Convert.ToDecimal(n["Minimum"] == DBNull.Value ? 0 : (Convert.ToDecimal(n["Minimum"]))),
                                                     SoftwareVersion = Convert.ToString(n["SoftwareVersion"] == DBNull.Value ? "" : (Convert.ToString(n["SoftwareVersion"]))),
                                                     TotalRecords = Convert.ToInt32(n["TotalRecords"]),
                                                     //  TotalPages = Convert.ToInt32(n["TotalPageCalc"]),
                                                 }).ToList();

                    if (entity.CRMRequestGridData != null)
                    {
                        entity.CRMRequestGridData.ForEach((x) =>
                        {
                            x.PageIndex = pageindex;
                            x.FirstRecord = ((pageindex - 1) * pagesize) + 1;
                            x.LastRecord = ((pageindex - 1) * pagesize) + pagesize;
                        });
                    }

                }
                return entity;

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
        private void SendMailAssignee(CRMRequestEntity model)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(SendMailAssignee), Level.Info.ToString());
            try
            {
                string emailTemplateId = string.Empty;
                string subject = string.Empty;
                string subjectVars = string.Empty;
                string templateVars = string.Empty;
                string email = string.Empty;

                email = model.WOAssigneeEmail;
                emailTemplateId = "39";
                var tempid = Convert.ToInt32(emailTemplateId);
                model.TemplateId = tempid;
                templateVars = string.Join(",", model.CRMWorkorderNo);

                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable TypecodeDt = new DataTable();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pEmailTemplateId", Convert.ToString(emailTemplateId));
                parameters.Add("@pToEmailIds", email);
                parameters.Add("@pSubject", Convert.ToString(subject));
                parameters.Add("@pPriority", Convert.ToString(1));
                parameters.Add("@pSendAsHtml", Convert.ToString(1));
                parameters.Add("@pSubjectVars", Convert.ToString(subjectVars));
                parameters.Add("@pTemplateVars", Convert.ToString(templateVars));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));

                DataTable dt = new DataTable();
                var dbAccessDAL = new DBAccessDAL();
                var FdbAccessDAL = new MASTERFEMSDBAccessDAL();
                var BdbAccessDAL = new MASTERBEMSDBAccessDAL();

                if (model.TypeOfRequest == 137 || model.TypeOfRequest == 136 || model.TypeOfRequest == 374)
                {
                    // otherparameters.Add("@pCRMRequest_PriorityId", Convert.ToString(model.PriorityList));
                    if (model.ServiceId == 1)
                    {

                        dt = FdbAccessDAL.GetMasterDataTable("uspFM_EmailNotify_Save", parameters, DataSetparameters);
                    }
                    else
                    {
                        dt = BdbAccessDAL.GetMasterDataTable("uspFM_EmailNotify_Save", parameters, DataSetparameters);
                    }
                }
                else
                {
                    dt = dbAccessDAL.GetDataTable("uspFM_EmailNotify_Save", parameters, DataSetparameters);
                }

                if (dt != null)
                {
                    foreach (DataRow rows in dt.Rows)
                    {


                    }
                }
                AssigneeNotification(model);
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
        public CRMRequestEntity AssigneeNotification(CRMRequestEntity ent)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(AssigneeNotification), Level.Info.ToString());
            CRMRequestEntity griddata = new CRMRequestEntity();
            var dbAccessDAL = new DBAccessDAL();
            var FdbAccessDAL = new MASTERFEMSDBAccessDAL();
            var BdbAccessDAL = new MASTERBEMSDBAccessDAL();
            var parameters = new Dictionary<string, string>();
            var DataSetparameters = new Dictionary<string, DataTable>();

            var notalert = ent.CRMWorkorderNo + " " + "CRM Work Order has been Assigned to you";

            var hyplink = "/bems/crmworkorder?id=" + ent.CRMWorkorderId;

            parameters.Add("@pNotificationId", Convert.ToString(ent.NotificationId));
            parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
            parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
            parameters.Add("@pUserId", Convert.ToString(ent.WOAssigneeId));
            parameters.Add("@pNotificationAlerts", Convert.ToString(notalert));
            parameters.Add("@pRemarks", Convert.ToString(""));
            parameters.Add("@pHyperLink", Convert.ToString(hyplink));
            parameters.Add("@pIsNew", Convert.ToString(1));
            parameters.Add("@pNotificationDateTime", Convert.ToString(null));
            parameters.Add("@pEmailTempId", Convert.ToString(ent.TemplateId));

            parameters.Add("@pmScreenName", Convert.ToString("CRMRequestWorkOrderTxn"));
            parameters.Add("@pMGuid", Convert.ToString(ent.HiddenId));
            DataTable ds = new DataTable();

            if (ent.TypeOfRequest == 137 || ent.TypeOfRequest == 136 || ent.TypeOfRequest == 374)
            {
                // otherparameters.Add("@pCRMRequest_PriorityId", Convert.ToString(model.PriorityList));
                if (ent.ServiceId == 1)
                {
                    ds = FdbAccessDAL.GetMasterDataTable("uspFM_WebNotificationSingle_Save", parameters, DataSetparameters);
                }
                else
                {
                    ds = BdbAccessDAL.GetMasterDataTable("uspFM_WebNotificationSingle_Save", parameters, DataSetparameters);
                }
            }
            else
            {
                ds = dbAccessDAL.GetDataTable("uspFM_WebNotificationSingle_Save", parameters, DataSetparameters);
            }




            if (ds != null)
            {
                foreach (DataRow row in ds.Rows)
                {
                    //model.CRMRequestId = Convert.ToInt32(row["CRMRequestId"]);
                    //model.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                    //// model.err = Convert.ToBase64String((byte[])(row["Timestamp"]));
                    //model.HiddenId = Convert.ToString(row["GuId"]);
                }
            }

            return ent;
        }
        private void SendMailVerify(CRMRequestEntity model)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(SendMailReject), Level.Info.ToString());
            try
            {
                string emailTemplateId = string.Empty;
                string subject = string.Empty;
                string subjectVars = string.Empty;
                string templateVars = string.Empty;
                string email = string.Empty;

                email = model.RequesterEmail;
                emailTemplateId = "50";

                var tempid = Convert.ToInt32(emailTemplateId);
                model.TemplateId = tempid;

                templateVars = string.Join(",", model.RequestNo);

                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable TypecodeDt = new DataTable();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pEmailTemplateId", Convert.ToString(emailTemplateId));
                parameters.Add("@pToEmailIds", email);
                parameters.Add("@pSubject", Convert.ToString(subject));
                parameters.Add("@pPriority", Convert.ToString(1));
                parameters.Add("@pSendAsHtml", Convert.ToString(1));
                parameters.Add("@pSubjectVars", Convert.ToString(subjectVars));
                parameters.Add("@pTemplateVars", Convert.ToString(templateVars));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));

                var dbAccessDAL = new DBAccessDAL();
                var FdbAccessDAL = new MASTERFEMSDBAccessDAL();
                var BdbAccessDAL = new MASTERBEMSDBAccessDAL();
                DataTable dt = new DataTable();
                if (model.TypeOfRequest == 137 || model.TypeOfRequest == 136 || model.TypeOfRequest == 374)
                {
                    // otherparameters.Add("@pCRMRequest_PriorityId", Convert.ToString(model.PriorityList));
                    if (model.ServiceId == 1)
                    {
                        dt = dbAccessDAL.GetDataTable("uspFM_EmailNotify_Save", parameters, DataSetparameters);
                    }
                    else
                    {
                        dt = dbAccessDAL.GetDataTable("uspFM_EmailNotify_Save", parameters, DataSetparameters);
                    }
                }
                else
                {

                    dt = dbAccessDAL.GetDataTable("uspFM_EmailNotify_Save", parameters, DataSetparameters);
                }

                if (dt != null)
                {
                    foreach (DataRow rows in dt.Rows)
                    {


                    }
                }
                VerifyWebNotification(model);
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
        public CRMRequestEntity VerifyWebNotification(CRMRequestEntity ent)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(save), Level.Info.ToString());
            CRMRequestEntity griddata = new CRMRequestEntity();
            var dbAccessDAL = new DBAccessDAL();
            var parameters = new Dictionary<string, string>();
            var DataSetparameters = new Dictionary<string, DataTable>();

            var notalert = ent.RequestNo + " " + "CRM Request Closed";

            var hyplink = "/master/mastercrmrequest?id=" + ent.CRMRequestId;

            parameters.Add("@pNotificationId", Convert.ToString(ent.NotificationId));
            parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
            parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
            parameters.Add("@pUserId", Convert.ToString(ent.ReqStaffId));
            parameters.Add("@pNotificationAlerts", Convert.ToString(notalert));
            parameters.Add("@pRemarks", Convert.ToString(""));
            parameters.Add("@pHyperLink", Convert.ToString(hyplink));
            parameters.Add("@pIsNew", Convert.ToString(1));
            parameters.Add("@pNotificationDateTime", Convert.ToString(null));
            parameters.Add("@pEmailTempId", Convert.ToString(ent.TemplateId));

            parameters.Add("@pmScreenName", Convert.ToString("CRMRequestStatus"));
            parameters.Add("@pMGuid", Convert.ToString(ent.HiddenId));

            var FdbAccessDAL = new MASTERFEMSDBAccessDAL();
            var BdbAccessDAL = new MASTERBEMSDBAccessDAL();
            DataTable ds = new DataTable();
            if (ent.TypeOfRequest == 137 || ent.TypeOfRequest == 136 || ent.TypeOfRequest == 374)
            {
                // otherparameters.Add("@pCRMRequest_PriorityId", Convert.ToString(model.PriorityList));
                if (ent.ServiceId == 1)
                {
                    ds = FdbAccessDAL.GetMasterDataTable("uspFM_WebNotificationSingle_Save", parameters, DataSetparameters);
                }
                else
                {
                    ds = BdbAccessDAL.GetMasterDataTable("uspFM_WebNotificationSingle_Save", parameters, DataSetparameters);
                }
            }
            else
            {
                ds = dbAccessDAL.GetDataTable("uspFM_WebNotificationSingle_Save", parameters, DataSetparameters);
            }


            if (ds != null)
            {
                foreach (DataRow row in ds.Rows)
                {
                    //model.CRMRequestId = Convert.ToInt32(row["CRMRequestId"]);
                    //model.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                    //// model.err = Convert.ToBase64String((byte[])(row["Timestamp"]));
                    //model.HiddenId = Convert.ToString(row["GuId"]);
                }
            }

            return ent;
        }

        public CRMRequestEntity GET_ServiceAndCustomer_ID(int Service_ID, int CustomerId, int FacilityId)
        {
            Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
            CRMRequestEntity Get_Service_FacilityandCustomer = new CRMRequestEntity();
            var dss = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["UETrackConnectionString"].ToString()))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = con;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "Get_Services_byFacilityAndCustomerId";
                    cmd.Parameters.AddWithValue("@Services", Service_ID);
                    cmd.Parameters.AddWithValue("@CustomerId", CustomerId);
                    cmd.Parameters.AddWithValue("@FacilityId", FacilityId);
                    var da = new SqlDataAdapter();
                    da.SelectCommand = cmd;
                    da.Fill(dss);
                }
            }
            if (dss.Tables.Count != 0)
            {
                Get_Service_FacilityandCustomer.CustomerId = Convert.ToInt32(dss.Tables[0].Rows[0][1]);
                Get_Service_FacilityandCustomer.FacilityId = Convert.ToInt32(dss.Tables[0].Rows[0][2]);
            }

            return Get_Service_FacilityandCustomer;
        }

        public DataSet GET_ServiceIndicator()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                CORMDropdownList CORMDropdownList = new CORMDropdownList();
                CORMDropdownList CORMdnlist = new CORMDropdownList();
                var ds = new DataSet();
                var ds1 = new DataSet();
                var ds2 = new DataSet();
                var ds3 = new DataSet();
                var dbAccessDAL = new MASTERBEMSDBAccessDAL();
                List<LovValue> lv = new List<LovValue>();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    CORMDropdownList bemsIndicator = new CORMDropdownList();
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        var da = new SqlDataAdapter();
                        da = new SqlDataAdapter();
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "usp_GetBEMSindictor";
                        cmd.Parameters.Clear();

                        da.SelectCommand = cmd;
                        da.Fill(ds);

                    }
                }

                var dbAccessFemsDAL = new MASTERFEMSDBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessFemsDAL.ConnectionString))
                {
                    CORMDropdownList femsIndicator = new CORMDropdownList();
                    CORMDropdownList ServiceIndicator = new CORMDropdownList();
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        var da = new SqlDataAdapter();
                        da = new SqlDataAdapter();
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "usp_GetFemsindictor";
                        cmd.Parameters.Clear();
                        da.SelectCommand = cmd;
                        da.Fill(ds1);
                    }
                }

                var dbAccessmasterDAL = new MASTERDBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessmasterDAL.ConnectionString))
                {
                    CORMDropdownList femsIndicator = new CORMDropdownList();
                    CORMDropdownList ServiceIndicator = new CORMDropdownList();
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        var da = new SqlDataAdapter();
                        da = new SqlDataAdapter();
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "usp_GetLlsindictor";
                        cmd.Parameters.Clear();
                        da.SelectCommand = cmd;
                        da.Fill(ds2);
                    }
                }

                using (SqlConnection con = new SqlConnection(dbAccessmasterDAL.ConnectionString))
                {
                    CORMDropdownList femsIndicator = new CORMDropdownList();
                    CORMDropdownList ServiceIndicator = new CORMDropdownList();
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        var da = new SqlDataAdapter();
                        da = new SqlDataAdapter();
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "usp_GetCLSindictor";
                        cmd.Parameters.Clear();
                        da.SelectCommand = cmd;
                        da.Fill(ds3);
                    }
                }

                int counts = ds1.Tables[0].Rows.Count;

                for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                {
                    DataRow DR = ds.Tables[0].Rows[i];
                    ds1.Tables[0].ImportRow(DR);
                }

                int Llscounts = ds2.Tables[0].Rows.Count;

                for (int i = 0; i < ds1.Tables[0].Rows.Count; i++)
                {
                    DataRow DR = ds1.Tables[0].Rows[i];
                    ds2.Tables[0].ImportRow(DR);
                }

                int Clscounts = ds3.Tables[0].Rows.Count;
                for (int i = 0; i < ds2.Tables[0].Rows.Count; i++)
                {
                    DataRow DR = ds2.Tables[0].Rows[i];
                    ds3.Tables[0].ImportRow(DR);
                }
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                return ds3;

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

        public DataSet GET_CRMReqPriority()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                CORMDropdownList CORMDropdownList = new CORMDropdownList();
                CORMDropdownList CORMdnlist = new CORMDropdownList();
                var ds = new DataSet();
                var dbAccessDAL = new MASTERDBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        var da = new SqlDataAdapter();
                        da = new SqlDataAdapter();
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_GetPriority";
                        cmd.Parameters.Clear();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }

                //for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                //{
                //    DataRow DR = ds.Tables[0].Rows[i];
                //    ds.Tables[0].ImportRow(DR);
                //}
                return ds;

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

        public DataSet Get_subIDStypecode(int? ModelDI, int? ManufacturerId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                AssetStandardization assetStandardization = null;

                var ds = new DataSet();
                var dbAccessDAL = new MASTERDBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.Text;
                        cmd.CommandText = "select ManufacturerId_mappingTo_SeviceDB,ModelId_mappingTo_SeviceDB from EngAssetStandardization where ManufacturerId=" + ManufacturerId + " and ModelId=" + ModelDI;
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return ds;
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

        public DataSet Get_subIDCRMREQestBEMS(int? id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                AssetStandardization assetStandardization = null;

                var ds = new DataSet();
                var dbAccessDAL = new MASTERBEMSDBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.Text;
                        cmd.CommandText = "select CRMRequestId from CRMRequest where Master_CRMRequestId=" + id;
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return ds;
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
        public DataSet Get_subIDCRMREQestFEMS(int? id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                AssetStandardization assetStandardization = null;

                var ds = new DataSet();
                var dbAccessDAL = new MASTERFEMSDBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.Text;
                        cmd.CommandText = "select CRMRequestId from CRMRequest where Master_CRMRequestId=" + id;
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return ds;
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
        public DataSet Get_Master_Model_Manf(int? ModelDI, int? ManufacturerId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                AssetStandardization assetStandardization = null;

                var ds = new DataSet();
                var dbAccessDAL = new MASTERDBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.Text;
                        cmd.CommandText = "select E.ManufacturerId,E.ModelId,B.Manufacturer,M.Model from EngAssetStandardization E INNER JOIN EngAssetStandardizationManufacturer  B ON E.ManufacturerId = B.ManufacturerId INNER JOIN EngAssetStandardizationModel M on E.ModelId=M.ModelId  where E.ManufacturerId_mappingTo_SeviceDB=" + ManufacturerId + " and E.ModelId_mappingTo_SeviceDB=" + ModelDI;
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return ds;
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
        //public GridFilterResult BemsCRMGetall(int id, SortPaginateFilter pageFilter, int TypeOfRequest, int ServiceId)
        //{
        //    try
        //    {
        //        Log4NetLogger.LogEntry(_FileName, nameof(BemsCRMGetall), Level.Info.ToString());
        //        GridFilterResult filterResult = null;
        //        //pageFilter.PageIndex = pageFilter.PageIndex == 0 ? 1 : pageFilter.PageIndex;
        //        var multipleOrderBy = pageFilter.SortColumn.Split(',');
        //        var strOrderBy = string.Empty;
        //        foreach (var order in multipleOrderBy)
        //        {
        //            strOrderBy += order + " " + pageFilter.SortOrder + ",";
        //        }
        //        if (!string.IsNullOrEmpty(strOrderBy))
        //        {
        //            strOrderBy = strOrderBy.TrimEnd(',');
        //        }

        //        strOrderBy = string.IsNullOrEmpty(strOrderBy) ? pageFilter.SortColumn + " " + pageFilter.SortOrder : strOrderBy;

        //        var QueryCondition = pageFilter.QueryWhereCondition;
        //        var strCondition = string.Empty;
        //        if (string.IsNullOrEmpty(QueryCondition))
        //        {
        //            strCondition = "FacilityId = " + _UserSession.FacilityId.ToString();
        //        }
        //        else
        //        {
        //            strCondition = QueryCondition + " AND FacilityId = " + _UserSession.FacilityId.ToString();
        //        }

        //        var ds = new DataSet();
        //        var dbAccessDAL = new DBAccessDAL();
        //        using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
        //        {
        //            using (SqlCommand cmd = new SqlCommand())
        //            {
        //                cmd.Connection = con;
        //                cmd.CommandType = CommandType.StoredProcedure;
        //                cmd.CommandText = "uspFM_CRMRequest_GetAll";

        //                cmd.Parameters.AddWithValue("@PageIndex", pageFilter.PageIndex);
        //                cmd.Parameters.AddWithValue("@PageSize", pageFilter.PageSize);
        //                cmd.Parameters.AddWithValue("@StrCondition", strCondition);
        //                cmd.Parameters.AddWithValue("@StrSorting", strOrderBy);

        //                var da = new SqlDataAdapter();
        //                da.SelectCommand = cmd;
        //                da.Fill(ds);
        //            }
        //        }
        //        if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
        //        {
        //            var totalRecords = Convert.ToInt32(ds.Tables[0].Rows[0]["TotalRecords"]);
        //            var totalPages = (int)Math.Ceiling((float)totalRecords / (float)pageFilter.Rows);

        //            var commonDAL = new CommonDAL();
        //            var currentPageList = commonDAL.ToDynamicList(ds.Tables[0]);
        //            filterResult = new GridFilterResult
        //            {
        //                TotalRecords = totalRecords,
        //                TotalPages = totalPages,
        //                RecordsList = currentPageList,
        //                CurrentPage = pageFilter.Page
        //            };
        //        }
        //        Log4NetLogger.LogExit(_FileName, nameof(BemsCRMGetall), Level.Info.ToString());
        //        //return userRoles;
        //        return filterResult;
        //    }


        //    catch (DALException dalex)
        //    {
        //        throw new DALException(dalex);
        //    }
        //    catch (Exception ex)
        //    {
        //        throw;
        //    }
        //}
    }

}
