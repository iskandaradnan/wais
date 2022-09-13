using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.DAL.DataAccess.Contracts.BEMS;
using CP.UETrack.DAL.DataAccess.Contracts.BER;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using CP.UETrack.Model.BER;
using CP.UETrack.Model.BEMS.AssetRegister;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using UETrack.DAL;



namespace CP.UETrack.DAL.DataAccess.Implementations.BEMS
{
    public class ARPApplicationDAL : IARPApplicationDAL
    {
        private readonly string _FileName = nameof(ARPApplicationDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();

        public ARPApplicationTxnLovs Load()
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                Arp arpProposals = null;
                //FinalProposal arpProposal = null;
                ARPApplicationTxnLovs Lovs = new ARPApplicationTxnLovs();
                var ds1 = new DataSet();
                var dbAccessDAL = new DBAccessDAL();

                string lovs = "SelectedProposal,ApplicationStatusValue";
               
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pLovKey", lovs);
                DataSet ds = dbAccessDAL.GetDataSet("uspFM_Dropdown", parameters, DataSetparameters);
                //using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                //{
                //    using (SqlCommand cmd = new SqlCommand())
                //    {
                //        var da = new SqlDataAdapter();
                //        cmd.Connection = con;
                //        cmd.CommandType = CommandType.StoredProcedure;
                //        cmd.CommandText = "uspFM_Dropdown";
                //        cmd.Parameters.Clear();
                //        cmd.Parameters.AddWithValue("@pLovKey", "SelectedProposal,ApplicationStatusValue");
                //        da.SelectCommand = cmd;
                //        da.Fill(ds1);

                //    }
                //}
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                   
                    Lovs.BER1StatusLovs = dbAccessDAL.GetLovRecords(ds.Tables[0], "ApplicationStatusValue");
                    Lovs.SelectProposal = dbAccessDAL.GetLovRecords(ds.Tables[0], "SelectedProposal");
                    // arpProposal.SelectedProposal = dbAccessDAL.GetLovRecords(ds1.Tables[0]);
                }
                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                //arpProposal.SelectedProposal = _UserSession.FacilityId;
             
                return Lovs;
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception EX)
            {
                throw EX;
            }
        }

        public void Delete(int Id, out string ErrorMessage)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            try
            {
                ErrorMessage = string.Empty;
                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pApplicationId", Id.ToString());
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_BERApplicationTxn_Delete", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    ErrorMessage = Convert.ToString(dt.Rows[0]["ErrorMessage"]);
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


        public Arp Save(Arp model, out string ErrorMessage)
        {
            //ProposalSave(model);
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            try
            {

                ErrorMessage = string.Empty;
                string syoValues = string.Empty;
                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable TypecodeDt = new DataTable();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@CustomerId", Convert.ToString(_UserSession.CustomerId));
                parameters.Add("@FacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@BERno", Convert.ToString(model.BERno));
                parameters.Add("@AssetID", Convert.ToString(model.AssetId));
                parameters.Add("@AssetNo", Convert.ToString(model.AssetNo));
                parameters.Add("@ConditionAppraisalNo", Convert.ToString(model.ConditionAppraisalRefNo));
                parameters.Add("@BERRemarks", Convert.ToString(model.BERRemarks));
                parameters.Add("@AssetName", Convert.ToString(model.AssetName));
                parameters.Add("@AssetTypeDescription", Convert.ToString(model.AssetTypeDescription));
                parameters.Add("@AssetTypeCodeID", Convert.ToString(model.AssetTypeCodeId));
                parameters.Add("@DepartmentNameID", Convert.ToString(model.UserAreaId));
                parameters.Add("@LocationNameID", Convert.ToString(model.UserLocationId));
                parameters.Add("@ApplicationDate", Convert.ToString(model.BERApplicationDate == null || model.BERApplicationDate == DateTime.MinValue ? null : model.BERApplicationDate.ToString("MM-dd-yyy")));
                parameters.Add("@ItemNo", Convert.ToString(model.ItemNo));
                //parameters.Add("@Quantity", Convert.ToString(model.Quantity));
                //parameters.Add("@PurchaseCost", Convert.ToString(model.PurchaseCostRM));
                decimal amount = decimal.Parse(model.PurchaseCostRM);
                parameters.Add("@PurchaseCost", amount.ToString());
                //parameters.Add("@PurchaseDate", Convert.ToString(model.PurchaseDate));
                parameters.Add("@PurchaseDate", Convert.ToString(model.PurchaseDate == null || model.PurchaseDate == DateTime.MinValue ? null : model.PurchaseDate.ToString("MM-dd-yyy")));
                parameters.Add("@BatchNo", Convert.ToString(model.BatchNo));

               
                if (model.PackageCode == null)
                {
                    parameters.Add("@PackageCode", Convert.ToString(0));
                }
                else {
                parameters.Add("@PackageCode", Convert.ToString(model.PackageCode));
                }
                if (model.Status == null || model.Status == "")
                {
                    model.Status = "202";
                    parameters.Add("@Status", Convert.ToString(model.Status));
                }
                //decimal amount = decimal.Parse(model.PurchaseCostRM);
                //parameters.Add("@PurchaseCost", amount.ToString());

                var dbAccessDAL = new MASTERBEMSDBAccessDAL();
                // DataTable dt= new DataTable();
                DataTable dt = dbAccessDAL.GetMasterDataTable("uspFM_EngARPDetails_Save", parameters, DataSetparameters);

                if (dt != null)
                {

                    foreach (DataRow rows in dt.Rows)
                    {
                        model.ARPID = Convert.ToInt32(rows["ARPID"]);
                        ErrorMessage = Convert.ToString(rows["ErrorMessage"]);

                    }
                }

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

        public Arp Submit(Arp model, out string ErrorMessage)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Submit), Level.Info.ToString());
            try
            {
                ErrorMessage = string.Empty;
                //string syoValues = string.Empty;
                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable TypecodeDt = new DataTable();
                var parameters = new Dictionary<string, string>();

                parameters.Add("@CustomerId", Convert.ToString(model.CustomerId));
                parameters.Add("@FacilityId", Convert.ToString(model.FacilityId));
                parameters.Add("@ARPID", Convert.ToString(model.ARPID));
                //------------pp1
                parameters.Add("@Model1", Convert.ToString(model.Model1));
                parameters.Add("@PROP_ID1", Convert.ToString(1));
                parameters.Add("@Brand1", Convert.ToString(model.Brand1));
                parameters.Add("@Manufacturer1", Convert.ToString(model.Manufacture1));
                parameters.Add("@EstimationPrice1", Convert.ToString(model.EstimationPrice1));
                parameters.Add("@SupplierName1", Convert.ToString(model.SupplierName1));
                parameters.Add("@ContactNo1", Convert.ToString(model.ContactNo1));
                //------------pp2
                parameters.Add("@Model2", Convert.ToString(model.Model2));
                parameters.Add("@PROP_ID2", Convert.ToString(2));
                parameters.Add("@Brand2", Convert.ToString(model.Brand2));
                parameters.Add("@Manufacturer2", Convert.ToString(model.Manufacture2));
                parameters.Add("@EstimationPrice2", Convert.ToString(model.EstimationPrice2));
                parameters.Add("@SupplierName2", Convert.ToString(model.SupplierName2));
                parameters.Add("@ContactNo2", Convert.ToString(model.ContactNo2));
                //------------pp3
                parameters.Add("@Model3", Convert.ToString(model.Model3));
                parameters.Add("@PROP_ID3", Convert.ToString(3));
                parameters.Add("@Brand3", Convert.ToString(model.Brand3));
                parameters.Add("@Manufacturer3", Convert.ToString(model.Manufacture3));
                parameters.Add("@EstimationPrice3", Convert.ToString(model.EstimationPrice3));
                parameters.Add("@SupplierName3", Convert.ToString(model.SupplierName3));
                parameters.Add("@ContactNo3", Convert.ToString(model.ContactNo3));


                var dbAccessDAL = new MASTERBEMSDBAccessDAL();
                // DataTable dt= new DataTable();
                DataTable dt = dbAccessDAL.GetMasterDataTable("[uspFM_EngARPDetails_Prop_Save]", parameters, DataSetparameters);
                if (dt != null)
                {

                    foreach (DataRow rows in dt.Rows)
                    {
                        model.ArpProposalId = Convert.ToString(rows["ARP_Proposal_ID"]);
                    }
                }
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
        public Arp ProposalSave(Arp model, out string ErrorMessage)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(ProposalSave), Level.Info.ToString());
            try
            {
                ErrorMessage = string.Empty;
                //var berstage = model.BERStage;
                string syoValues = string.Empty;
                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable TypecodeDt = new DataTable();
                var parameters = new Dictionary<string, string>();

               
               
               
                //parameters.Add("@ARPProposalID", Convert.ToString(model.ArpProposalId));
                //parameters.Add("@PROP_ID", Convert.ToString(model.PROP_ID));
                //------------pp1
                parameters.Add("@ARPID1", Convert.ToString(model.ARPID));
                parameters.Add("@PROP_ID1", Convert.ToString(1));
                parameters.Add("@CustomerId", Convert.ToString(_UserSession.CustomerId));
                parameters.Add("@FacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@Model1", Convert.ToString(model.Model1));
                parameters.Add("@Brand1", Convert.ToString(model.Brand1));
                parameters.Add("@Manufacturer1", Convert.ToString(model.Manufacture1));
                parameters.Add("@EstimationPrice1", Convert.ToString(model.EstimationPrice1));
                parameters.Add("@SupplierName1", Convert.ToString(model.SupplierName1));
                parameters.Add("@ContactNo1", Convert.ToString(model.ContactNo1));
                //------------pp2
                parameters.Add("@ARPID2", Convert.ToString(model.ARPID));
                parameters.Add("@PROP_ID2", Convert.ToString(2));
                parameters.Add("@CustomerId2", Convert.ToString(_UserSession.CustomerId));
                parameters.Add("@FacilityId2", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@Model2", Convert.ToString(model.Model2));
                parameters.Add("@Brand2", Convert.ToString(model.Brand2));
                parameters.Add("@Manufacturer2", Convert.ToString(model.Manufacture2));
                parameters.Add("@EstimationPrice2", Convert.ToString(model.EstimationPrice2));
                parameters.Add("@SupplierName2", Convert.ToString(model.SupplierName2));
                parameters.Add("@ContactNo2", Convert.ToString(model.ContactNo2));
                //------------pp3
                parameters.Add("@ARPID3", Convert.ToString(model.ARPID));
                parameters.Add("@CustomerId3", Convert.ToString(_UserSession.CustomerId));
                parameters.Add("@FacilityId3", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@PROP_ID3", Convert.ToString(3));
                parameters.Add("@Model3", Convert.ToString(model.Model3));
                parameters.Add("@Brand3", Convert.ToString(model.Brand3));
                parameters.Add("@Manufacturer3", Convert.ToString(model.Manufacture3));
                parameters.Add("@EstimationPrice3", Convert.ToString(model.EstimationPrice3));
                parameters.Add("@SupplierName3", Convert.ToString(model.SupplierName3));
                parameters.Add("@ContactNo3", Convert.ToString(model.ContactNo3));


                if (model.Status == null || model.Status == "")
                {
                    model.Status = "203";
                    parameters.Add("@Status", Convert.ToString(model.Status));
                }
                
                var dbAccessDAL = new MASTERBEMSDBAccessDAL();
                // DataTable dt= new DataTable();
                DataTable dt = dbAccessDAL.GetMasterDataTable("[uspFM_EngARPDetails_Prop_Save]", parameters, DataSetparameters);
                if (dt != null)
                {

                    foreach (DataRow rows in dt.Rows)
                    {
                        model.ArpProposalId = Convert.ToString(rows["ARP_Proposal_ID"]);
                    }
                }
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


        public Arp Get(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var obj = new Arp();

                var obj1 = new FirstProposal();
                var obj2 = new SecondProposal();
                var obj3 = new ThirdProposal();
                var obj4 = new FinalProposal();


                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pArpid", Id.ToString());
                //parameters.Add("@PageIndex", Convert.ToString(1));
                //parameters.Add("@pPageSize", Convert.ToString(5));
                DataSet ds = dbAccessDAL.GetDataSet("[uspFM_ARPDetails_GetAllbyID]", parameters, DataSetparameters);
                parameters.Clear();
                parameters.Add("@pArpid", Convert.ToString(Id));
               DataSet ds1 = null;
                
                if (ds != null)
                {
                    if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                    {
                        obj.BERno = Convert.ToString(ds.Tables[0].Rows[0]["BERNo"]);
                        obj.AssetNo = ds.Tables[0].Rows[0]["AssetNo"] != DBNull.Value ? (Convert.ToString(ds.Tables[0].Rows[0]["AssetNo"])) : (string)null;
                        //obj.AssetId = ds.Tables[0].Rows[0]["AssetId"] != DBNull.Value ? (Convert.ToInt32(ds.Tables[0].Rows[0]["AssetId"])) : (int ?)null;
                        obj.ConditionAppraisalRefNo = ds.Tables[0].Rows[0]["ConditionAppraisalNo"] != DBNull.Value ? (Convert.ToString(ds.Tables[0].Rows[0]["ConditionAppraisalNo"])) : (string)null;
                        obj.AssetTypeCode = ds.Tables[0].Rows[0]["AssetTypeCode"] != DBNull.Value ? (Convert.ToString(ds.Tables[0].Rows[0]["AssetTypeCode"])) : (string)null;
                        obj.AssetTypeDescription = ds.Tables[0].Rows[0]["AssetTypeDescription"] != DBNull.Value ? (Convert.ToString(ds.Tables[0].Rows[0]["AssetTypeDescription"])) : (string)null;
                        obj.BERRemarks = ds.Tables[0].Rows[0]["BERRemarks"] != DBNull.Value ? (Convert.ToString(ds.Tables[0].Rows[0]["BERRemarks"])) : (string)null;
                        obj.ApplicationDate = Convert.ToDateTime(ds.Tables[0].Rows[0]["ApplicationDate"] != DBNull.Value ? (Convert.ToDateTime(ds.Tables[0].Rows[0]["ApplicationDate"])) : (DateTime?)null);
                        obj.AssetName = ds.Tables[0].Rows[0]["AssetName"] != DBNull.Value ? (Convert.ToString(ds.Tables[0].Rows[0]["AssetName"])) : (string)null;
                        //obj.UserLocationCode = Convert.ToString(ds.Tables[0].Rows[0]["UserLocationCode"]);
                        obj.UserLocationName = ds.Tables[0].Rows[0]["UserLocationName"] != DBNull.Value ? (Convert.ToString(ds.Tables[0].Rows[0]["UserLocationName"])) : (string)null;
                        obj.UserAreaName = ds.Tables[0].Rows[0]["DepartmentName"] != DBNull.Value ? (Convert.ToString(ds.Tables[0].Rows[0]["DepartmentName"])) : (string)null;
                        obj.PurchaseCost = ds.Tables[0].Rows[0]["PurchaseCost"] != DBNull.Value ? (Convert.ToDecimal(ds.Tables[0].Rows[0]["PurchaseCost"])) : (Decimal?)null;
                        obj.PurchaseDate = Convert.ToDateTime(ds.Tables[0].Rows[0]["PurchaseDate"] != DBNull.Value ? (Convert.ToDateTime(ds.Tables[0].Rows[0]["PurchaseDate"])) : (DateTime?)null);
                        obj.ItemNo = Convert.ToInt32(ds.Tables[0].Rows[0]["ItemNo"]);
                        obj.PackageCode = Convert.ToString(ds.Tables[0].Rows[0]["PackageCode"]);
                        obj.BatchNo = Convert.ToString(ds.Tables[0].Rows[0]["BatchNo"]);
                        obj.ARPID = Convert.ToInt32(ds.Tables[0].Rows[0]["ARPID"]);
                        obj.Status = Convert.ToString(ds.Tables[0].Rows[0]["Status"]);



                    }
                }

                if (ds != null)
                {
                    if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 1)
                    {
                        // obj.PROP_ID = Convert.ToInt32(ds1.Tables[0].Rows[0]["PROP_ID"]);
                        //obj1.ArpProposalId = Convert.ToString(ds1.Tables[0].Rows[0]["ARP_Proposal_ID"]);
                        obj.Model1 = Convert.ToString(ds.Tables[0].Rows[0]["Model"]);
                        obj.Brand1 = Convert.ToString(ds.Tables[0].Rows[0]["Brand"]);
                        obj.Manufacture1 = Convert.ToString(ds.Tables[0].Rows[0]["Manufacturer"]);
                        obj.EstimationPrice1 = Convert.ToString(ds.Tables[0].Rows[0]["EstimationPrice"]);
                        obj.SupplierName1 = Convert.ToString(ds.Tables[0].Rows[0]["SupplierName"]);
                        obj.ContactNo1 = Convert.ToString(ds.Tables[0].Rows[0]["ContactNo"]);
                        obj.ProposalStatus = Convert.ToInt32(ds.Tables[0].Rows[0]["ProposalStatus"]);

                        //obj2.PROP_ID = Convert.ToInt32(ds1.Tables[0].Rows[1]["PROP_ID"]);
                        //obj2.ArpProposalId = Convert.ToString(ds1.Tables[1].Rows[0]["ARP_Proposal_ID"]);
                        obj.Model2 = Convert.ToString(ds.Tables[0].Rows[1]["Model"]);
                        obj.Brand2 = Convert.ToString(ds.Tables[0].Rows[1]["Brand"]);
                        obj.Manufacture2 = Convert.ToString(ds.Tables[0].Rows[1]["Manufacturer"]);
                        obj.EstimationPrice2 = Convert.ToString(ds.Tables[0].Rows[1]["EstimationPrice"]);
                        obj.SupplierName2 = Convert.ToString(ds.Tables[0].Rows[1]["SupplierName"]);
                        obj.ContactNo2 = Convert.ToString(ds.Tables[0].Rows[1]["ContactNo"]);
                        obj.ProposalStatus = Convert.ToInt32(ds.Tables[0].Rows[0]["ProposalStatus"]);

                        //obj3.PROP_ID = Convert.ToInt32(ds1.Tables[0].Rows[2]["PROP_ID"]);
                        //obj3.ArpProposalId = Convert.ToString(ds1.Tables[0].Rows[2]["ARP_Proposal_ID"]);
                        obj.Model3 = Convert.ToString(ds.Tables[0].Rows[2]["Model"]);
                        obj.Brand3 = Convert.ToString(ds.Tables[0].Rows[2]["Brand"]);
                        obj.Manufacture3 = Convert.ToString(ds.Tables[0].Rows[2]["Manufacturer"]);
                        obj.EstimationPrice3 = Convert.ToString(ds.Tables[0].Rows[2]["EstimationPrice"]);
                        obj.SupplierName3 = Convert.ToString(ds.Tables[0].Rows[2]["SupplierName"]);
                        obj.ContactNo3 = Convert.ToString(ds.Tables[0].Rows[2]["ContactNo"]);
                        obj.ProposalStatus = Convert.ToInt32(ds.Tables[0].Rows[0]["ProposalStatus"]);

                    }
                }
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());

                return obj;

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

        public Arp ArpGet(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var obj = new Arp();
                var obj1 = new FirstProposal();
                var obj2 = new SecondProposal();
                var obj3 = new ThirdProposal();
                var obj4 = new FinalProposal();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pArpid", Id.ToString());
                //parameters.Add("@PageIndex", Convert.ToString(1));
                //parameters.Add("@pPageSize", Convert.ToString(5));
                DataSet ds = dbAccessDAL.GetDataSet("[uspFM_ARPDetails_GetAllbyID]", parameters, DataSetparameters);
                parameters.Clear();
                parameters.Add("@pArpid", Convert.ToString(Id));
                DataSet ds1 = dbAccessDAL.GetDataSet("[uspFM_ARPDetails_GetAllbyID]", parameters, DataSetparameters);

                if (ds != null)
                {
                    if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                    {
                        obj.ARPID = Convert.ToInt32(ds.Tables[0].Rows[0]["ARPID"]);
                        //obj.CustomerId = Convert.ToInt32(ds.Tables[0].Rows[0]["CustomerId"]);
                        //obj.FacilityId = Convert.ToInt32(ds.Tables[0].Rows[0]["FacilityId"]);
                        //obj.ServiceId = Convert.ToInt32(ds.Tables[0].Rows[0]["ServiceId"]);
                        //obj.BERNo = Convert.ToString(ds.Tables[0].Rows[0]["BERNo"]);
                        obj.AssetNo = Convert.ToString(ds.Tables[0].Rows[0]["AssetNo"]);
                        //obj.AssetId = Convert.ToInt32(ds.Tables[0].Rows[0]["AssetId"]);
                        obj.AssetName = Convert.ToString(ds.Tables[0].Rows[0]["AssetName"]);
                        obj.AssetTypeCode = Convert.ToString(ds.Tables[0].Rows[0]["AssetTypeCode"]);
                        obj.AssetTypeDescription = Convert.ToString(ds.Tables[0].Rows[0]["AssetTypeDescription"]);
                        obj.AssetTypeCode = Convert.ToString(ds.Tables[0].Rows[0]["AssetTypeCode"]);
                        obj.AreaName = Convert.ToString(ds.Tables[0].Rows[0]["DepartmentName"]);
                        obj.LocationName = Convert.ToString(ds.Tables[0].Rows[0]["LocationName"]);
                        obj.Quantity = Convert.ToString(ds.Tables[0].Rows[0]["Quantity"]);
                        obj.PurchaseCost = Convert.ToInt32(ds.Tables[0].Rows[0]["PurchaseCostRM"]);
                        obj.PurchaseDate = Convert.ToDateTime(ds.Tables[0].Rows[0]["PurchaseDate"] != DBNull.Value ? (Convert.ToDateTime(ds.Tables[0].Rows[0]["PurchaseDate"])) : (DateTime?)null);
                        obj.BatchNo = Convert.ToString(ds.Tables[0].Rows[0]["BatchNo"]);
                        obj.PackageCode = Convert.ToString(ds.Tables[0].Rows[0]["PackageCode"]);
                        obj.BERRemarks = Convert.ToString(ds.Tables[0].Rows[0]["BERRemarks"]);
                        obj.SelectedProposal = Convert.ToInt32(ds.Tables[0].Rows[0]["SelectedProposal"]);
                        obj.Justification = Convert.ToString(ds.Tables[0].Rows[0]["Justification"]);

                    }
                }
                if (ds1 != null)
                {
                    if (ds1.Tables[0] != null && ds1.Tables[0].Rows.Count > 0)
                    {
                        obj1.PROP_ID = Convert.ToInt32(ds1.Tables[0].Rows[0]["PROP_ID"]);
                        obj1.ArpProposalId = Convert.ToString(ds1.Tables[0].Rows[0]["ARP_Proposal_ID"]);
                        obj1.Model1 = Convert.ToString(ds1.Tables[0].Rows[0]["Model"]);
                        obj1.Brand1 = Convert.ToString(ds1.Tables[0].Rows[0]["Brand"]);
                        obj1.Manufacture1 = Convert.ToString(ds1.Tables[0].Rows[0]["Manufacture"]);
                        obj1.EstimationPrice1 = Convert.ToString(ds1.Tables[0].Rows[0]["Estimation Price(RM)"]);
                        obj1.SupplierName1 = Convert.ToString(ds1.Tables[0].Rows[0]["Supplier Name"]);
                        obj1.ContactNo1 = Convert.ToString(ds1.Tables[0].Rows[0]["Contact No"]);

                        obj2.PROP_ID = Convert.ToInt32(ds1.Tables[0].Rows[1]["PROP_ID"]);
                        obj2.ArpProposalId = Convert.ToString(ds1.Tables[1].Rows[0]["ARP_Proposal_ID"]);
                        obj2.Model2 = Convert.ToString(ds1.Tables[0].Rows[1]["Model"]);
                        obj2.Brand2 = Convert.ToString(ds1.Tables[0].Rows[1]["Brand"]);
                        obj2.Manufacture2 = Convert.ToString(ds1.Tables[0].Rows[1]["Manufacture"]);
                        obj2.EstimationPrice2 = Convert.ToString(ds1.Tables[0].Rows[1]["Estimation Price(RM)"]);
                        obj2.SupplierName2 = Convert.ToString(ds1.Tables[0].Rows[1]["Supplier Name"]);
                        obj2.ContactNo2 = Convert.ToString(ds1.Tables[0].Rows[1]["Contact No"]);

                        obj3.PROP_ID = Convert.ToInt32(ds1.Tables[0].Rows[2]["PROP_ID"]);
                        obj3.ArpProposalId = Convert.ToString(ds1.Tables[0].Rows[2]["ARP_Proposal_ID"]);
                        obj3.Model3 = Convert.ToString(ds1.Tables[0].Rows[2]["Model"]);
                        obj3.Brand3 = Convert.ToString(ds1.Tables[0].Rows[2]["Brand"]);
                        obj3.Manufacture3 = Convert.ToString(ds1.Tables[0].Rows[2]["Manufacture"]);
                        obj3.EstimationPrice3 = Convert.ToString(ds1.Tables[0].Rows[2]["Estimation Price(RM)"]);
                        obj3.SupplierName3 = Convert.ToString(ds1.Tables[0].Rows[2]["Supplier Name"]);
                        obj3.ContactNo3 = Convert.ToString(ds1.Tables[0].Rows[2]["Contact No"]);
                    }
                }
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return obj;

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
        public Arp GetAttachmentDetails(int id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var obj = new Arp();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@ApplicationId", id.ToString());

                DataTable dt = dbAccessDAL.GetDataTable("uspFM_BERApplicationAttachmentTxn_GetById", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    var historyList = (from n in dt.AsEnumerable()
                                       select new FileUploadDetModels
                                       {
                                           FileType = Convert.ToInt32(n["FileType"]),
                                           FileName = Convert.ToString(n["FileName"]),
                                           FilePath = Convert.ToString(n["FilePath"]),
                                           DocumentId = Convert.ToInt32(n["DocumentId"]),
                                           DocumentTitle = Convert.ToString(n["DocumentTitle"]),
                                           DocumentExtension = Convert.ToString(n["DocumentExtension"]),
                                           Active = false,
                                           GuId = Convert.ToString(n["GuId"])

                                       }).ToList();

                    if (historyList != null && historyList.Count > 0)
                    {
                        obj.FileUploadList = historyList;
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return obj;

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
                        cmd.CommandText = "GetAllCustomerID_ARP";

                        cmd.Parameters.AddWithValue("@PageIndex", pageFilter.PageIndex);
                        cmd.Parameters.AddWithValue("@PageSize", pageFilter.PageSize);

                        cmd.Parameters.AddWithValue("@pCustomer", _UserSession.CustomerId);
                        cmd.Parameters.AddWithValue("@pfacility", _UserSession.FacilityId);
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
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public AssetRegisterModel GetBERNoDetails(string Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetBERNoDetails), Level.Info.ToString());
                AssetRegisterModel assetRegister = null;

                var ds = new DataSet();
                var dbAccessDAL = new BEMSDBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "UspFM_ARP_info_GetByBERno";
                        cmd.Parameters.AddWithValue("@pBERno", Id);
                        //cmd.Parameters.AddWithValue("@pWorkGroup", Work_Group);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    assetRegister = (from n in ds.Tables[0].AsEnumerable()
                                     select new AssetRegisterModel
                                     {
                                         AssetId = Convert.ToInt32((n["AssetId"])),
                                         CustomerId = Convert.ToInt32((n["CustomerId"])),
                                         FacilityId = Convert.ToInt32((n["FacilityId"])),
                                         AssetNo = Convert.ToString((n["AssetNo"])),
                                         TestingandCommissioningDetId = n.Field<int?>("TestingandCommissioningDetId"),
                                         TypeOfAsset = n.Field<int?>("TypeOfAsset"),
                                         AssetPreRegistrationNo = Convert.ToString((n["AssetPreRegistrationNo"])),
                                         AssetTypeCodeId = Convert.ToInt32((n["AssetTypeCodeId"])),
                                         AssetTypeCode = Convert.ToString((n["AssetTypeCode"])),
                                         AssetTypeDescription = n.Field<string>("AssetTypeDescription"),
                                         AssetClassification = n.Field<int?>("AssetClassification"),
                                         AssetDescription = Convert.ToString((n["AssetDescription"])),

                                         CommissioningDate = Convert.ToDateTime((n["CommissioningDate"])),
                                         AssetParentId = n.Field<int?>("AssetParentId"),
                                         ParentAssetNo = n.Field<string>("ParentAssetNo"),
                                         ServiceStartDate = Convert.ToDateTime((n["ServiceStartDate"])),
                                         EffectiveDate = n["EffectiveDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime((n["EffectiveDate"])),
                                         ExpectedLifespan = n.Field<int?>("ExpectedLifespan"),
                                         RealTimeStatusLovId = n.Field<int?>("RealTimeStatusLovId"),
                                         AssetStatusLovId = n.Field<int?>("AssetStatusLovId"),
                                         AssetAge = n.Field<decimal?>("AssetAge"),
                                         YearsInService = n.Field<decimal?>("YearsInService"),
                                         OperatingHours = n.Field<decimal?>("OperatingHours"),

                                         TransferUserLocation = n.Field<string>("TransferUserLocation"),
                                         TransferDate = n.Field<DateTime?>("TransferDate"),
                                         OtherTransferDate = n.Field<DateTime?>("OtherTransferDate"),
                                         OtherFacilityId = n.Field<int?>("OtherFacilityId"),
                                         OtherSpecify = n.Field<string>("OtherSpecify"),
                                         OtherPreviousAssetNo = n.Field<string>("OtherPreviousAssetNo"),

                                         UserLocationId = Convert.ToInt32((n["UserLocationId"])),
                                         UserLocationCode = Convert.ToString(n["UserLocationCode"]),
                                         UserLocationName = n.Field<string>("UserLocationName"),
                                         CurrentAreaCode = n.Field<string>("CurrentAreaCode"),
                                         CurrentAreaName = n.Field<string>("CurrentAreaName"),
                                         UserAreaCode = n.Field<string>("UserAreaCode"),
                                         UserAreaName = n.Field<string>("UserAreaName"),
                                         UserAreaId = n.Field<int>("UserAreaId"),

                                         Manufacturer = Convert.ToInt32((n["Manufacturer"])),
                                         ManufacturerName = Convert.ToString(n["ManufacturerName"]),
                                         NamePlateManufacturer = Convert.ToString(n["NamePlateManufacturer"]),
                                         Model = Convert.ToInt32((n["Model"])),
                                         ModelName = Convert.ToString(n["ModelName"]),
                                         AppliedPartTypeLovId = Convert.ToInt32((n["AppliedPartTypeLovId"])),
                                         EquipmentClassLovId = n.Field<int?>("EquipmentClassLovId"),
                                         Specification = n.Field<int?>("Specification"),
                                         SerialNo = Convert.ToString((n["SerialNo"])),
                                         MainSupplier = Convert.ToString((n["MainSupplier"])),
                                         ManufacturingDate = n["ManufacturingDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime((n["ManufacturingDate"])),
                                         PowerSpecification = n.Field<int?>("PowerSpecification"),
                                         PowerSpecificationWatt = n.Field<decimal?>("PowerSpecificationWatt"),
                                         PowerSpecificationAmpere = n.Field<decimal?>("PowerSpecificationAmpere"),
                                         Volt = n.Field<decimal?>("Volt"),

                                         PpmPlannerId = Convert.ToInt32((n["PpmPlannerId"])),
                                         RiPlannerId = Convert.ToInt32((n["RiPlannerId"])),
                                         OtherPlannerId = Convert.ToInt32((n["OtherPlannerId"])),
                                         LastSchduledWorkOrderNo = n.Field<string>("LastSchduledWorkOrderNo"),
                                         LastSchduledWorkOrderDateTime = n.Field<DateTime?>("LastSchduledWorkOrderDateTime"),

                                         //SchduledTotDowntimeHoursMinYTD = n.Field<decimal?>("SchduledTotDowntimeHoursMinYTD"),
                                         SchduledTotDowntimeHoursMinYTD = n.Field<decimal?>("UnSchduledTotDowntimeHoursMinYTD"),
                                         LastUnSchduledWorkOrderNo = n.Field<string>("LastUnSchduledWorkOrderNo"),
                                         LastUnSchduledWorkOrderDateTime = n.Field<DateTime?>("LastUnSchduledWorkOrderDateTime"),
                                         DefectList = n.Field<int?>("DefectList"),

                                         PurchaseCostRM = n.Field<decimal?>("PurchaseCostRM"),
                                         PurchaseDate = n["PurchaseDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime((n["PurchaseDate"])),
                                         PurchaseCategory = n.Field<int?>("PurchaseCategory"),
                                         WarrantyDuration = n.Field<decimal?>("WarrantyDuration"),
                                         WarrantyStartDate = n["WarrantyStartDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime((n["WarrantyStartDate"])),
                                         WarrantyEndDate = n["WarrantyEndDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime((n["WarrantyEndDate"])),
                                         CumulativePartCost = n.Field<decimal?>("CumulativePartCost"),
                                         CumulativeLabourCost = n.Field<decimal?>("CumulativeLabourCost"),
                                         CumulativeContractCost = n.Field<decimal?>("CumulativeContractCost"),

                                         RiskRating = n.Field<int?>("RiskRating"),
                                         TransferFacilityName = n.Field<string>("TransferFacilityName"),
                                         TransferRemarks = n.Field<string>("TransferRemarks"),
                                         PreviousAssetNo = n.Field<string>("PreviousAssetNo"),
                                         PurchaseOrderNo = n.Field<string>("PurchaseOrderNo"),
                                         InstalledLocationName = n.Field<string>("InstalledLocationName"),
                                         InstalledLocationCode = n.Field<string>("InstalledLocationCode"),
                                         SoftwareVersion = n.Field<string>("SoftwareVersion"),
                                         SoftwareKey = n.Field<string>("SoftwareKey"),
                                         LevelName = n.Field<string>("LevelName"),
                                         LevelCode = n.Field<string>("LevelCode"),
                                         BlockName = n.Field<string>("BlockName"),
                                         BlockCode = n.Field<string>("BlockCode"),
                                         TransferMode = n.Field<int?>("TransferMode"),
                                         MainsFuseRating = n.Field<decimal?>("MainsFuseRating"),
                                         CalculatedFeeDW = n.Field<decimal?>("CalculatedFeeDW"),
                                         CalculatedFeePW = n.Field<decimal?>("CalculatedFeePW"),
                                         TotalWarrantyDownTime = n.Field<decimal?>("TotalWarrantyDownTime"),
                                         AuthorizationName = n.Field<string>("AuthorizationName"),
                                         AssetWorkingStatusValue = n.Field<string>("AssetWorkingStatusValue"),
                                         QRCode = n["QRCode"] == DBNull.Value ? "" : Convert.ToBase64String((byte[])n["QRCode"]),
                                         Timestamp = Convert.ToBase64String((byte[])(n["Timestamp"])),
                                         HiddenId = Convert.ToString((n["GuId"])),
                                         RunningHoursCapture = n.Field<int?>("RunningHoursCapture"),
                                         ContractType = n.Field<int?>("ContractType"),
                                         CompanyStaffId = n.Field<int?>("CompanyStaffId"),
                                         CompanyStaffName = n.Field<string>("StaffName"),
                                         Asset_Name = n.Field<string>("Asset_Name"),
                                         Item_Code = n.Field<string>("Item_Code"),
                                         Item_Description = n.Field<string>("Item_Description"),
                                         Package_Code = n.Field<string>("Package_Code"),
                                         Package_Description = n.Field<string>("Package_Description"),
                                         Asset_Category = Convert.ToInt32((n["Asset_Category"])),
                                         //  Work_Group = n.Field<string>("Work_Group"),
                                         WorkGroup = n.Field<string>("WorkGroup"),
                                         BatchNo = Convert.ToInt32((n["BatchNo"]))

                                     }).FirstOrDefault();


                    //assetRegister.RunningHoursCapture = assetRegister.RunningHoursCapture == null || assetRegister.RunningHoursCapture == 0 ?
                    //    (int)YesNo.No : assetRegister.RunningHoursCapture;

                    //if (assetRegister.EffectiveDate == DateTime.MinValue) assetRegister.EffectiveDate = null;
                    //if (assetRegister.ManufacturingDate == DateTime.MinValue) assetRegister.ManufacturingDate = null;
                    //if (assetRegister.PurchaseDate == DateTime.MinValue) assetRegister.PurchaseDate = null;
                    //if (assetRegister.WarrantyStartDate == DateTime.MinValue) assetRegister.WarrantyStartDate = null;
                    //if (assetRegister.WarrantyEndDate == DateTime.MinValue) assetRegister.WarrantyEndDate = null;

                    //if (ds.Tables[1].Rows.Count > 0)
                    //{
                    //    assetRegister.AssetSpecifications = (from n in ds.Tables[1].AsEnumerable()
                    //                                         select new LovValue
                    //                                         {
                    //                                             LovId = n.Field<int>("AssetTypeCodeAddSpecId"),
                    //                                             FieldValue = n.Field<string>("SpecificationTypeName")
                    //                                         }).ToList();
                    //}
                }
                Log4NetLogger.LogExit(_FileName, nameof(GetBERNoDetails), Level.Info.ToString());
                return assetRegister;
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

    }
}
