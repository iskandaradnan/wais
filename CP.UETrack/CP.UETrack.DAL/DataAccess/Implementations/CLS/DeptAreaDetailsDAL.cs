using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.DAL.DataAccess.Contracts.CLS;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.Model;
using CP.UETrack.Model.CLS;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UETrack.DAL;

namespace CP.UETrack.DAL.DataAccess.Implementations.CLS
{
    public class DeptAreaDetailsDAL : IDeptAreaDetailsDAL
    {
        private readonly string _FileName = nameof(BlockDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();

        public DeptAreaDetailsDAL()
        {

        }

        public DeptAreaDetailsDropdown Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();

                DeptAreaDetailsDropdown deptAreaDetailsDropdown = new DeptAreaDetailsDropdown();

                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        var da = new SqlDataAdapter();
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Sp_CLS_DeptAreaDetails_Dropdown";
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@pScreenName", "DeptAreaDetail");

                        da.SelectCommand = cmd;
                        da.Fill(ds);

                       
                        if (ds.Tables[0] != null)
                        {
                            deptAreaDetailsDropdown.CategoryOfAreaLovs = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                        }
                        if (ds.Tables[1] != null)
                        {
                            deptAreaDetailsDropdown.StatusLovs = dbAccessDAL.GetLovRecords(ds.Tables[1]);
                        }
                        if (ds.Tables[2] != null)
                        {
                            deptAreaDetailsDropdown.OperatingDateLovs = dbAccessDAL.GetLovRecords(ds.Tables[2]);
                        }
                        if (ds.Tables[3] != null)
                        {
                            deptAreaDetailsDropdown.WorkingHoursLovs = dbAccessDAL.GetLovRecords(ds.Tables[3]);
                        }
                        if (ds.Tables[4] != null)
                        {
                            deptAreaDetailsDropdown.JIScheduleLovs = dbAccessDAL.GetLovRecords(ds.Tables[4]);
                        }
                        if (ds.Tables[5] != null)
                        {
                            deptAreaDetailsDropdown.PeriodicWorkLovs = dbAccessDAL.GetLovRecords(ds.Tables[5]);
                        }
                        if (ds.Tables[6] != null)
                        {
                            deptAreaDetailsDropdown.ToiletLovs = dbAccessDAL.GetLovRecords(ds.Tables[6]);
                        }
                        if (ds.Tables[7] != null)
                        {
                            deptAreaDetailsDropdown.VariationDetailsLovs = dbAccessDAL.GetLovRecords(ds.Tables[7]);
                        }
                        if (ds.Tables[8] != null)
                        {
                            deptAreaDetailsDropdown.ToiletTypeLovs = dbAccessDAL.GetLovRecords(ds.Tables[8]);
                        }
                        if (ds.Tables[9] != null)
                        {
                            deptAreaDetailsDropdown.ToiletDetailsLovs = dbAccessDAL.GetLovRecords(ds.Tables[9]);
                        }

                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return deptAreaDetailsDropdown;
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

        public DeptAreaDetails Save(DeptAreaDetails model, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
                ErrorMessage = string.Empty;
                var spName = string.Empty;
                
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();

                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "SP_CLS_DeptAreaDetailsFields";

                        cmd.Parameters.AddWithValue("@pDeptAreaId", model.DeptAreaId);
                        cmd.Parameters.AddWithValue("@pUserAreaId", model.UserAreaId);
                        cmd.Parameters.AddWithValue("@pCustomerId", model.CustomerId);
                        cmd.Parameters.AddWithValue("@pFacilityId", model.FacilityId);
                        cmd.Parameters.AddWithValue("@pUserAreaCode", model.UserAreaCode);
                        cmd.Parameters.AddWithValue("@pUserAreaName", model.UserAreaName);
                        cmd.Parameters.AddWithValue("@pCategoryOfArea", model.CategoryOfArea);
                        cmd.Parameters.AddWithValue("@pStatus", model.Status);
                        cmd.Parameters.AddWithValue("@pOperatingDays", model.OperatingDays);
                        cmd.Parameters.AddWithValue("@pWorkingHours", model.WorkingHours);
                        cmd.Parameters.AddWithValue("@pTotalReceptacles", model.TotalReceptacles);
                        cmd.Parameters.AddWithValue("@pCleaningArea", model.CleanableArea);
                        cmd.Parameters.AddWithValue("@pNoOfHandWashingFacilities", model.NoOfHandWashingFacilities);
                        cmd.Parameters.AddWithValue("@pNoOfBeds", model.NoOfBeds);
                        cmd.Parameters.AddWithValue("@pTotalNoOfUserLocations", model.TotalNoOfUserLocations);
                        cmd.Parameters.AddWithValue("@pHospitalRepresentative", model.HospitalRepresentative);
                        cmd.Parameters.AddWithValue("@pHospitalRepresentativeDesignation", model.HospitalRepresentativeDesignation);
                        cmd.Parameters.AddWithValue("@pCompanyRepresentative", model.CompanyRepresentative);
                        cmd.Parameters.AddWithValue("@pCompanyRepresentativeDesignation", model.CompanyRepresentativeDesignation);
                        cmd.Parameters.AddWithValue("@pEffectiveFromDate", model.EffectiveFromDate);
                        cmd.Parameters.AddWithValue("@pEffectiveToDate", model.EffectiveToDate);
                        cmd.Parameters.AddWithValue("@pJISchedule", model.JISchedule);
                        cmd.Parameters.AddWithValue("@pRemarks", model.Remarks);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                        //cmd.Parameters.Clear();

                        if (ds.Tables.Count != 0)
                        {
                            cmd.Parameters.Clear();
                            model.DeptAreaId = Convert.ToInt32(ds.Tables[0].Rows[0]["DeptAreaId"]);
                            var ds1 = new DataSet();
                            cmd.CommandText = "SP_CLS_DeptAreaDetailsLocation";

                            foreach (var Dept in model.LocationDetailsList)
                            {
                                cmd.Parameters.AddWithValue("@pDeptAreaId", model.DeptAreaId);
                                cmd.Parameters.AddWithValue("@pUserAreaId", model.UserAreaId);
                                cmd.Parameters.AddWithValue("@pLocationId", Dept.LocationId);
                                cmd.Parameters.AddWithValue("@pLocationCode",Dept.LocationCode);
                                cmd.Parameters.AddWithValue("@pStatus", Dept.Status);
                                cmd.Parameters.AddWithValue("@pFloor", Dept.Floor);
                                cmd.Parameters.AddWithValue("@pWalls", Dept.Walls);
                                cmd.Parameters.AddWithValue("@pCelling", Dept.Celling);
                                cmd.Parameters.AddWithValue("@pWindowsDoors", Dept.WindowsDoors);
                                cmd.Parameters.AddWithValue("@pReceptaclesContainers", Dept.ReceptaclesContainers);
                                cmd.Parameters.AddWithValue("@pFurnitureFixtureEquipments", Dept.FurnitureFixtureEquipments);
                                                             
                                da.SelectCommand = cmd;
                                da.Fill(ds1);
                                cmd.Parameters.Clear();
                            }
                        }                       
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return model;
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

        public Receptacles SaveReceptacles(Receptacles _receptacles, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(SaveReceptacles), Level.Info.ToString());
                ErrorMessage = string.Empty;
                var spName = string.Empty;


                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Sp_CLS_DeptAreaReceptaclesSave";

                        cmd.Parameters.AddWithValue("@pDeptAreaId", _receptacles.DeptAreaId);
                        cmd.Parameters.AddWithValue("@pUserAreaId", _receptacles.UserAreaId);
                        cmd.Parameters.AddWithValue("@pBin660L", _receptacles.Bin660L);
                        cmd.Parameters.AddWithValue("@pBin240L", _receptacles.Bin240L);
                        cmd.Parameters.AddWithValue("@pWastePaperBasket", _receptacles.WastePaperBasket);
                        cmd.Parameters.AddWithValue("@pPedalBin", _receptacles.PedalBin);
                        cmd.Parameters.AddWithValue("@pBedsideBin", _receptacles.BedsideBin);
                        cmd.Parameters.AddWithValue("@pFlipFlop", _receptacles.FilpFlop);
                        cmd.Parameters.AddWithValue("@pFoodBin", _receptacles.FoodBin);
                        
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                        cmd.Parameters.Clear();

                        if (ds.Tables.Count != 0)
                        {           
                            _receptacles.UserAreaId = Convert.ToInt32(ds.Tables[0].Rows[0]["UserAreaId"]);   
                        }
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(SaveReceptacles), Level.Info.ToString());
                return _receptacles;
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

        public DailyCleaningSchedule SaveDailyClean(DailyCleaningSchedule _dailyCleaning, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(SaveDailyClean), Level.Info.ToString());
                ErrorMessage = string.Empty;
                var spName = string.Empty;


                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Sp_CLS_DeptAreaDailyCleaningSave";

                        cmd.Parameters.AddWithValue("@pDeptAreaId", _dailyCleaning.DeptAreaId);
                        cmd.Parameters.AddWithValue("@pUserAreaId", _dailyCleaning.UserAreaId);
                        cmd.Parameters.AddWithValue("@pDustmop", _dailyCleaning.Dustmop);
                        cmd.Parameters.AddWithValue("@pDampmop", _dailyCleaning.Dampmop);
                        cmd.Parameters.AddWithValue("@pVacuum", _dailyCleaning.Vacuum);
                        cmd.Parameters.AddWithValue("@pWash", _dailyCleaning.Washing);
                        cmd.Parameters.AddWithValue("@pSweeping", _dailyCleaning.Sweeping);
                        cmd.Parameters.AddWithValue("@pWiping", _dailyCleaning.Wiping);  
                        cmd.Parameters.AddWithValue("@pPaperHandTowel", _dailyCleaning.PaperHandTowel);
                        cmd.Parameters.AddWithValue("@pToiletJumbo", _dailyCleaning.ToiletJumbo);
                        cmd.Parameters.AddWithValue("@pHandSoap", _dailyCleaning.HandSoap);
                        cmd.Parameters.AddWithValue("@pDeodorisers", _dailyCleaning.Deodorisers);
                        cmd.Parameters.AddWithValue("@pDomesticWasteCollection", _dailyCleaning.DomesticWasteCollection);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                        cmd.Parameters.Clear();

                        if (ds.Tables.Count != 0)
                        {
                            _dailyCleaning.UserAreaId = Convert.ToInt32(ds.Tables[0].Rows[0]["UserAreaId"]);
                        }
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(SaveDailyClean), Level.Info.ToString());
                return _dailyCleaning;
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
        
        public PeriodicWorkSchedule SavePeriodicWork(PeriodicWorkSchedule _periodicWorkSchedule, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(SavePeriodicWork), Level.Info.ToString());
                ErrorMessage = string.Empty;
                var spName = string.Empty;
                
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();

                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Sp_CLS_DeptAreaPeriodicWorkSave";

                        cmd.Parameters.AddWithValue("@pDeptAreaId", _periodicWorkSchedule.DeptAreaId);
                        cmd.Parameters.AddWithValue("@pUserAreaId", _periodicWorkSchedule.UserAreaId);
                        cmd.Parameters.AddWithValue("@pContainerReceptaclesWashing", _periodicWorkSchedule.ContainerReceptaclesWashing);
                        cmd.Parameters.AddWithValue("@pCeilingHighDusting", _periodicWorkSchedule.CeilingHighDusting);
                        cmd.Parameters.AddWithValue("@pLightsAirCondOutletFanWiping", _periodicWorkSchedule.LightsAirCondOutletFanWiping);
                        cmd.Parameters.AddWithValue("@pFloorNonPolishableScrubbing", _periodicWorkSchedule.FloorNonPolishableScrubbing);
                        cmd.Parameters.AddWithValue("@pFloorPolishablePolishing", _periodicWorkSchedule.FloorPolishablePolishing);
                        cmd.Parameters.AddWithValue("@pFloorPolishableBuffing", _periodicWorkSchedule.FloorPolishableBuffing);
                        cmd.Parameters.AddWithValue("@pFloorCarpetBonnetBuffing", _periodicWorkSchedule.FloorCarpetBonnetBuffing);
                        cmd.Parameters.AddWithValue("@pFloorCarpetShampooing", _periodicWorkSchedule.FloorCarpetShampooing);
                        cmd.Parameters.AddWithValue("@pFloorCarpetHeatSteamExtraction", _periodicWorkSchedule.FloorCarpetHeatSteamExtraction);
                        cmd.Parameters.AddWithValue("@pWallWiping", _periodicWorkSchedule.WallWiping);
                        cmd.Parameters.AddWithValue("@pWindowDoorWiping", _periodicWorkSchedule.WindowDoorWiping);
                        cmd.Parameters.AddWithValue("@pPerimeterDrainWashScrub", _periodicWorkSchedule.PerimeterDrainWashScrub);
                        cmd.Parameters.AddWithValue("@pToiletDescaling", _periodicWorkSchedule.ToiletDescaling);
                        cmd.Parameters.AddWithValue("@pHighRiseNetttingHighDusting", _periodicWorkSchedule.HighRiseNetttingHighDusting);
                        cmd.Parameters.AddWithValue("@pExternalFacadeCleaning", _periodicWorkSchedule.ExternalFacadeCleaning);
                        cmd.Parameters.AddWithValue("@pExternalHighLevelGlassCleaning", _periodicWorkSchedule.ExternalHighLevelGlassCleaning);
                        cmd.Parameters.AddWithValue("@pInternetGlass", _periodicWorkSchedule.InternetGlass);
                        cmd.Parameters.AddWithValue("@pFlatRoofWashScrub", _periodicWorkSchedule.FlatRoofWashScrub);
                        cmd.Parameters.AddWithValue("@pStainlessSteelPolishing", _periodicWorkSchedule.StainlessSteelPolishing);
                        cmd.Parameters.AddWithValue("@pExposeCeilingTruss", _periodicWorkSchedule.ExposeCeilingTruss);
                        cmd.Parameters.AddWithValue("@pLedgesDampWipe", _periodicWorkSchedule.LedgesDampWipe);
                        cmd.Parameters.AddWithValue("@pSkylightHighDusting", _periodicWorkSchedule.SkylightHighDusting);
                        cmd.Parameters.AddWithValue("@pSignagesWiping", _periodicWorkSchedule.SignagesWiping);
                        cmd.Parameters.AddWithValue("@pDecksHighDusting", _periodicWorkSchedule.DecksHighDusting);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                        cmd.Parameters.Clear();

                        if (ds.Tables.Count != 0)
                        {
                            _periodicWorkSchedule.UserAreaId = Convert.ToInt32(ds.Tables[0].Rows[0]["UserAreaId"]);
                        }
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(SavePeriodicWork), Level.Info.ToString());
                return _periodicWorkSchedule;
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

        public List<Toilet> SaveToilet(List<Toilet> _lsttoilet, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(SaveToilet), Level.Info.ToString());
                ErrorMessage = string.Empty;
                var spName = string.Empty;


                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                Toilet objToilet = new Toilet();
                List<Toilet> lstToilets = new List<Toilet>();

                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;


                        cmd.CommandText = "Sp_CLS_DeptAreaToiletSave";

                        foreach(var _toilet in _lsttoilet)
                        {
                            cmd.Parameters.AddWithValue("@pDeptAreaId", _toilet.DeptAreaId);
                            cmd.Parameters.AddWithValue("@pUserAreaId", _toilet.UserAreaId);
                            cmd.Parameters.AddWithValue("@pLocationId", _toilet.LocationId);
                            cmd.Parameters.AddWithValue("@pLocationCode", _toilet.LocationCode);
                            cmd.Parameters.AddWithValue("@pType", _toilet.Type);
                            cmd.Parameters.AddWithValue("@pFrequency", _toilet.Frequency);
                            cmd.Parameters.AddWithValue("@pDetails", _toilet.Details);
                            cmd.Parameters.AddWithValue("@pMirror", _toilet.Mirror);
                            cmd.Parameters.AddWithValue("@pFloor", _toilet.Floor);
                            cmd.Parameters.AddWithValue("@pWall", _toilet.Wall);
                            cmd.Parameters.AddWithValue("@pUrinal", _toilet.Urinal);
                            cmd.Parameters.AddWithValue("@pBowl", _toilet.Bowl);
                            cmd.Parameters.AddWithValue("@pBasin", _toilet.Basin);
                            cmd.Parameters.AddWithValue("@pToiletRoll", _toilet.ToiletRoll);
                            cmd.Parameters.AddWithValue("@pSoapDispenser", _toilet.SoapDispenser);
                            cmd.Parameters.AddWithValue("@pAutoAirFreshner", _toilet.AutoAirFreshner);
                            cmd.Parameters.AddWithValue("@pWaste", _toilet.Waste);
                            cmd.Parameters.AddWithValue("@isDeleted", _toilet.isDeleted);

                            var da = new SqlDataAdapter();
                            da.SelectCommand = cmd;
                            da.Fill(ds);

                            cmd.Parameters.Clear();
                        }                                               

                        if (ds.Tables.Count != 0)
                        {                            
                            foreach (DataRow dr in ds.Tables[0].Rows)
                            {
                                objToilet = new Toilet();

                                objToilet.ToiletId = Convert.ToInt32(dr["ToiletId"]);
                                objToilet.DeptAreaId = Convert.ToInt32(dr["DeptAreaId"]);
                                objToilet.UserAreaId = Convert.ToInt32(dr["UserAreaId"]);
                                objToilet.LocationId = Convert.ToInt32(dr["LocationId"]);
                                objToilet.LocationCode = dr["LocationCode"].ToString();
                                objToilet.Type = Convert.ToInt32(dr["Type"]);
                                objToilet.Frequency = Convert.ToInt32(dr["Frequency"]);
                                objToilet.Details = Convert.ToInt32(dr["Details"]);
                                objToilet.Mirror = Convert.ToBoolean(dr["Mirror"]);
                                objToilet.Floor = Convert.ToBoolean(dr["Floor"]);
                                objToilet.Wall = Convert.ToBoolean(dr["Wall"]);
                                objToilet.Urinal = Convert.ToBoolean(dr["Urinal"]);
                                objToilet.Bowl = Convert.ToBoolean(dr["Bowl"]);
                                objToilet.Basin = Convert.ToBoolean(dr["Basin"]);
                                objToilet.ToiletRoll = Convert.ToBoolean(dr["ToiletRoll"]);
                                objToilet.SoapDispenser = Convert.ToBoolean(dr["SoapDispenser"]);
                                objToilet.AutoAirFreshner = Convert.ToBoolean(dr["AutoAirFreshner"]);
                                objToilet.Waste = Convert.ToBoolean(dr["Waste"]);
                                
                                lstToilets.Add(objToilet);
                            }                            
                        }
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(SaveToilet), Level.Info.ToString());
                return lstToilets;
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

        public Dispenser SaveDispenser(Dispenser _dispenser, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(SaveDispenser), Level.Info.ToString());
                ErrorMessage = string.Empty;
                var spName = string.Empty;


                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Sp_CLS_DeptAreaDispenserSave";

                        cmd.Parameters.AddWithValue("@pDeptAreaId", _dispenser.DeptAreaId);
                        cmd.Parameters.AddWithValue("@pUserAreaId", _dispenser.UserAreaId);
                        cmd.Parameters.AddWithValue("@pHandPaperTowel", _dispenser.HandPaperTowel);
                        cmd.Parameters.AddWithValue("@pJumboRoll", _dispenser.JumboRollToiletRoll);
                        cmd.Parameters.AddWithValue("@pHandSoap", _dispenser.HandSoapLiquidSoapDispenser);
                        cmd.Parameters.AddWithValue("@pDeodorant", _dispenser.Deodorant);
                        cmd.Parameters.AddWithValue("@pFootPump", _dispenser.FootPumpNonContactTypeDispenser);
                        cmd.Parameters.AddWithValue("@pHandDryers", _dispenser.HandDryers);
                        cmd.Parameters.AddWithValue("@pAutoTimerDeodorizer", _dispenser.AutoTimerDeodorizerAirFreshenerDispenser);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                        cmd.Parameters.Clear();

                        if (ds.Tables.Count != 0)
                        {
                            _dispenser.UserAreaId = Convert.ToInt32(ds.Tables[0].Rows[0]["UserAreaId"]);
                        }
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(SaveDispenser), Level.Info.ToString());
                return _dispenser;
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
        
        public List<VariationDetails> SaveVariationDetails(List<VariationDetails> _lstVariationDetails, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(SaveVariationDetails), Level.Info.ToString());
                ErrorMessage = string.Empty;                
                
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                VariationDetails variationDetails = new VariationDetails();
                List<VariationDetails> lstVariationDetails = new List<VariationDetails>();

                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Sp_CLS_DeptAreaVariationDetailsSave";

                        foreach(var _VariationDetails in _lstVariationDetails)
                        {
                            cmd.Parameters.AddWithValue("@pDeptAreaId", _VariationDetails.DeptAreaId);
                            cmd.Parameters.AddWithValue("@pUserAreaId", _VariationDetails.UserAreaId);
                            cmd.Parameters.AddWithValue("@pAreacode", _VariationDetails.AreaCode);
                            cmd.Parameters.AddWithValue("@pAreaname", _VariationDetails.AreaName);
                            cmd.Parameters.AddWithValue("@pSNFReference", _VariationDetails.SNFReference);
                            cmd.Parameters.AddWithValue("@pVariationStatus", _VariationDetails.VariationStatus);
                            cmd.Parameters.AddWithValue("@pSqft", _VariationDetails.Sqft);
                            cmd.Parameters.AddWithValue("@pPrice", _VariationDetails.Price);
                            cmd.Parameters.AddWithValue("@pCommissioningDate", _VariationDetails.CommissioningDate);
                            cmd.Parameters.AddWithValue("@pServiceStartDate", _VariationDetails.ServiceStartDate);
                            cmd.Parameters.AddWithValue("@pWarrentyEndDate", _VariationDetails.WarrantyEndDate);
                            cmd.Parameters.AddWithValue("@pVariationDate", _VariationDetails.VariationDate);
                            cmd.Parameters.AddWithValue("@pServiceStopDate", _VariationDetails.ServiceStopDate);
                            cmd.Parameters.AddWithValue("@isDeleted", _VariationDetails.isDeleted);

                            var da = new SqlDataAdapter();
                            da.SelectCommand = cmd;
                            da.Fill(ds);

                            cmd.Parameters.Clear();
                        }

                        if (ds.Tables.Count != 0)
                        {
                            
                            foreach(DataRow dr in ds.Tables[0].Rows)
                            {
                                variationDetails = new VariationDetails();

                                variationDetails.VariationDetailsId = Convert.ToInt32(dr["VariationDetailsId"]);
                                variationDetails.DeptAreaId = Convert.ToInt32(dr["DeptAreaId"]);
                                variationDetails.UserAreaId = Convert.ToInt32(dr["UserAreaId"]);
                                variationDetails.AreaCode = dr["AreaCode"].ToString();
                                variationDetails.AreaName = dr["AreaName"].ToString();
                                variationDetails.SNFReference = dr["SNFReferenceNo"].ToString();
                                variationDetails.VariationStatus = Convert.ToInt32(dr["VariationStatus"]);
                                variationDetails.Sqft = Convert.ToInt32(dr["Sqft"]);
                                variationDetails.Price = Convert.ToInt32(dr["Price"]);
                                if(dr["CommissioningDate"] != System.DBNull.Value)
                                variationDetails.CommissioningDate = Convert.ToDateTime(dr["CommissioningDate"]);
                                if (dr["ServiceStartDate"] != System.DBNull.Value)
                                    variationDetails.ServiceStartDate = Convert.ToDateTime(dr["ServiceStartDate"]);
                                if (dr["WarrentyEndDate"] != System.DBNull.Value)
                                    variationDetails.WarrantyEndDate = Convert.ToDateTime(dr["WarrentyEndDate"]);
                                if (dr["VariationDate"] != System.DBNull.Value)
                                    variationDetails.VariationDate = Convert.ToDateTime(dr["VariationDate"]);
                                if (dr["ServiceStopDate"] != System.DBNull.Value)
                                    variationDetails.ServiceStopDate = Convert.ToDateTime(dr["ServiceStopDate"]);
                                
                                lstVariationDetails.Add(variationDetails);
                            }

                           
                        }
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(SaveVariationDetails), Level.Info.ToString());
                return lstVariationDetails;
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
                var strCondition = string.Empty;
                var QueryCondition = pageFilter.QueryWhereCondition;
                if (string.IsNullOrEmpty(QueryCondition))
                {
                    strCondition = "FacilityId = " + _UserSession.FacilityId.ToString();
                }
                else
                {
                    strCondition = QueryCondition + " AND FacilityId = " + _UserSession.FacilityId.ToString();
                }
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Sp_CLS_DeptAreaDetails_GetAll";

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
                Log4NetLogger.LogExit(_FileName, nameof(GetAll), Level.Info.ToString());
                //return Blocks;
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
        
        public DeptAreaDetails Get(int DeptAreaId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                DeptAreaDetails dept = new DeptAreaDetails();

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Sp_CLS_DeptAreaDetails_Get";                       
                        cmd.Parameters.AddWithValue("@DeptAreaId", DeptAreaId);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0)
                {
                    if (ds.Tables[0].Rows.Count > 0)
                    {
                        dept.UserAreaId = Convert.ToInt32(ds.Tables[0].Rows[0]["UserAreaId"]);
                        dept.DeptAreaId = Convert.ToInt32(ds.Tables[0].Rows[0]["DeptAreaId"]);
                        dept.CustomerId = Convert.ToInt32(ds.Tables[0].Rows[0]["CustomerId"]);
                        dept.FacilityId = Convert.ToInt32(ds.Tables[0].Rows[0]["FacilityId"]);
                        dept.UserAreaCode = Convert.ToString(ds.Tables[0].Rows[0]["UserAreaCode"]);
                        dept.UserAreaName = Convert.ToString(ds.Tables[0].Rows[0]["UserAreaName"]);
                        dept.CategoryOfArea = Convert.ToString(ds.Tables[0].Rows[0]["CategoryOfArea"]);
                        dept.Status = ds.Tables[0].Rows[0]["Status"].ToString();
                        dept.OperatingDays = Convert.ToString(ds.Tables[0].Rows[0]["OperatingDays"]);
                        dept.WorkingHours = Convert.ToInt32(ds.Tables[0].Rows[0]["WorkingHours"]);
                        dept.TotalReceptacles = Convert.ToInt32(ds.Tables[0].Rows[0]["TotalReceptacles"]);
                        dept.CleanableArea = Convert.ToInt32(ds.Tables[0].Rows[0]["CleanableArea"]);
                        dept.NoOfHandWashingFacilities = Convert.ToInt32(ds.Tables[0].Rows[0]["NoOfHandWashingFacilities"]);
                        dept.NoOfBeds = Convert.ToInt32(ds.Tables[0].Rows[0]["NoOfBeds"]);
                        dept.TotalNoOfUserLocations = Convert.ToInt32(ds.Tables[0].Rows[0]["TotalNoOfUserLocations"]);
                        dept.HospitalRepresentative = Convert.ToString(ds.Tables[0].Rows[0]["HospitalRepresentative"]);
                        dept.HospitalRepresentativeDesignation = Convert.ToString(ds.Tables[0].Rows[0]["HospitalRepresentativeDesignation"]);
                        dept.CompanyRepresentative = Convert.ToString(ds.Tables[0].Rows[0]["CompanyRepresentative"]);
                        dept.CompanyRepresentativeDesignation = Convert.ToString(ds.Tables[0].Rows[0]["CompanyRepresentativeDesignation"]);
                        
                        if (ds.Tables[0].Rows[0]["EffectiveFromDate"].ToString() == "")
                            dept.EffectiveFromDate = null;                        
                        else
                            dept.EffectiveFromDate = Convert.ToDateTime(ds.Tables[0].Rows[0]["EffectiveFromDate"]);


                        if (ds.Tables[0].Rows[0]["EffectiveToDate"].ToString() == "")
                            dept.EffectiveToDate = null;
                        else
                            dept.EffectiveToDate = Convert.ToDateTime(ds.Tables[0].Rows[0]["EffectiveToDate"]);

                        dept.JISchedule = Convert.ToString(ds.Tables[0].Rows[0]["JISchedule"]);
                        dept.Remarks = Convert.ToString(ds.Tables[0].Rows[0]["Remarks"]);
                    }

                    if (ds.Tables[1].Rows.Count > 0)
                    {
                        dept.LocationDetailsList = (from n in ds.Tables[1].AsEnumerable()
                                                      select new LocationDetails
                                                      {
                                                          LocationId = n.Field<int>("LocationId"),
                                                          LocationCode = n.Field<string>("LocationCode"),
                                                          Status = n.Field<int>("Status"),
                                                          Floor = n.Field<Boolean>("Floor"),
                                                          Walls = n.Field<Boolean>("Walls"),
                                                          Celling = n.Field<Boolean>("Celling"),
                                                          WindowsDoors = n.Field<Boolean>("WindowsDoors"),
                                                          ReceptaclesContainers = n.Field<Boolean>("ReceptaclesContainers"),
                                                          FurnitureFixtureEquipments = n.Field<Boolean>("FurnitureFixtureEquipments")
                                                      }).ToList();

                        //foreach (DataRow dr in ds.Tables[1].Rows)
                        //{
                        //    LocationDetails _loc = new LocationDetails();
                                                        
                        //    _loc.LocationId = Convert.ToInt32(dr["LocationId"]);
                        //    _loc.LocationCode = Convert.ToString(dr["LocationCode"]);
                        //    _loc.Status = Convert.ToInt32(dr["Status"]);
                        //    _loc.Floor = Convert.ToBoolean(dr["Floor"]);
                        //    _loc.Walls = Convert.ToBoolean(dr["Walls"]);
                        //    _loc.Celling = Convert.ToBoolean(dr["Ceiling"]);
                        //    _loc.WindowsDoors = Convert.ToBoolean(dr["WindowsDoors"]);
                        //    _loc.ReceptaclesContainers = Convert.ToBoolean(dr["ReceptaclesContainers"]);
                        //    _loc.FurnitureFixtureEquipments = Convert.ToBoolean(dr["FurnitureFixtureEquipments"]);

                        //    dept.LocationDetailsList.Add(_loc);
                        //}                       
                    }

                    if (ds.Tables[2].Rows.Count > 0)
                    {
                        foreach (DataRow dr in ds.Tables[2].Rows)
                        {
                            Receptacles _rec = new Receptacles();

                            _rec.UserAreaId = Convert.ToInt32(dr["UserAreaId"]);
                            _rec.Bin660L = Convert.ToInt32(dr["Bin660L"]);
                            _rec.Bin240L = Convert.ToInt32(dr["Bin240L"]);
                            _rec.WastePaperBasket = Convert.ToInt32(dr["WastePaperBasket"]);
                            _rec.PedalBin = Convert.ToInt32(dr["PedalBin"]);
                            _rec.BedsideBin = Convert.ToInt32(dr["BedsideBin"]);
                            _rec.FilpFlop = Convert.ToInt32(dr["FilpFlop"]);
                            _rec.FoodBin = Convert.ToInt32(dr["FoodBin"]);                            

                            dept.receptacles = _rec;
                        }
                    }

                    if (ds.Tables[3].Rows.Count > 0)
                    {
                        foreach (DataRow dr in ds.Tables[3].Rows)
                        {
                            DailyCleaningSchedule _dcs = new DailyCleaningSchedule();

                            _dcs.UserAreaId = Convert.ToInt32(dr["UserAreaId"]);
                            _dcs.Dustmop = Convert.ToInt32(dr["Dustmop"]);
                            _dcs.Dampmop = Convert.ToInt32(dr["Dampmop"]);
                            _dcs.Vacuum = Convert.ToInt32(dr["Vacuum"]);
                            _dcs.Washing = Convert.ToInt32(dr["Washing"]);
                            _dcs.Sweeping = Convert.ToInt32(dr["Sweeping"]);
                            _dcs.Wiping = Convert.ToInt32(dr["Wiping"]);
                            _dcs.PaperHandTowel = Convert.ToInt32(dr["PaperHandTowel"]);
                            _dcs.ToiletJumbo = Convert.ToInt32(dr["Toilet"]);
                            _dcs.HandSoap = Convert.ToInt32(dr["HandSoap"]);
                            _dcs.Deodorisers = Convert.ToInt32(dr["Deodorisers"]);
                            _dcs.DomesticWasteCollection = Convert.ToInt32(dr["DomesticWasteCollection"]);

                            dept.dailyCleaningSchedule = _dcs;
                        }
                    }

                    if (ds.Tables[4].Rows.Count > 0)
                    {
                        foreach (DataRow dr in ds.Tables[4].Rows)
                        {
                            PeriodicWorkSchedule _pws = new PeriodicWorkSchedule();

                            _pws.UserAreaId = Convert.ToInt32(dr["UserAreaId"]);
                            _pws.ContainerReceptaclesWashing = Convert.ToInt32(dr["ContainerWashing"]);
                            _pws.CeilingHighDusting = Convert.ToInt32(dr["Ceiling"]);
                            _pws.LightsAirCondOutletFanWiping = Convert.ToInt32(dr["Lights"]);
                            _pws.FloorNonPolishableScrubbing = Convert.ToInt32(dr["FloorScrubbing"]);
                            _pws.FloorPolishablePolishing = Convert.ToInt32(dr["FloorPolishing"]);
                            _pws.FloorPolishableBuffing = Convert.ToInt32(dr["FloorBuffing"]);
                            _pws.FloorCarpetBonnetBuffing = Convert.ToInt32(dr["FloorBB"]);
                            _pws.FloorCarpetShampooing = Convert.ToInt32(dr["FloorShampooing"]);
                            _pws.FloorCarpetHeatSteamExtraction = Convert.ToInt32(dr["FloorExtraction"]);
                            _pws.WallWiping = Convert.ToInt32(dr["WallWiping"]);
                            _pws.WindowDoorWiping = Convert.ToInt32(dr["WindowDW"]);
                            _pws.PerimeterDrainWashScrub = Convert.ToInt32(dr["PerimeterDrain"]);
                            _pws.ToiletDescaling = Convert.ToInt32(dr["ToiletDescaling"]);
                            _pws.HighRiseNetttingHighDusting = Convert.ToInt32(dr["HighRiseNetting"]);
                            _pws.ExternalFacadeCleaning = Convert.ToInt32(dr["ExternalFacade"]);
                            _pws.ExternalHighLevelGlassCleaning = Convert.ToInt32(dr["ExternalHighLevelGlass"]);
                            _pws.InternetGlass = Convert.ToInt32(dr["InternetGlass"]);
                            _pws.FlatRoofWashScrub = Convert.ToInt32(dr["FlatRoof"]);
                            _pws.StainlessSteelPolishing = Convert.ToInt32(dr["StainlessSteelPolishing"]);
                            _pws.ExposeCeilingTruss = Convert.ToInt32(dr["ExposeCeiling"]);
                            _pws.LedgesDampWipe = Convert.ToInt32(dr["LedgesDampWipe"]);
                            _pws.SkylightHighDusting = Convert.ToInt32(dr["SkylightHighDusting"]);
                            _pws.SignagesWiping = Convert.ToInt32(dr["SignagesWiping"]);
                            _pws.DecksHighDusting = Convert.ToInt32(dr["DecksHighDusting"]);

                            dept.periodicWorkSchedule = _pws;
                        }
                    }

                    if (ds.Tables[5].Rows.Count > 0)
                    {
                        List<Toilet> _lstToliets = new List<Toilet>();
                        foreach (DataRow dr in ds.Tables[5].Rows)
                        {
                            Toilet _toilet = new Toilet();
                            _toilet.ToiletId = Convert.ToInt32(dr["UserAreaId"]);
                            _toilet.UserAreaId = Convert.ToInt32(dr["UserAreaId"]);
                            _toilet.LocationId = Convert.ToInt32(dr["LocationId"]);
                            _toilet.LocationCode = Convert.ToString(dr["LocationCode"]);
                            _toilet.Type = Convert.ToInt32(dr["Type"]);
                            _toilet.Frequency = Convert.ToInt32(dr["Frequency"]);
                            _toilet.Details = Convert.ToInt32(dr["Details"]);
                            _toilet.Mirror = Convert.ToBoolean(dr["Mirror"]);
                            _toilet.Floor = Convert.ToBoolean(dr["Floor"]);
                            _toilet.Wall = Convert.ToBoolean(dr["Wall"]);
                            _toilet.Urinal = Convert.ToBoolean(dr["Urinal"]);
                            _toilet.Bowl = Convert.ToBoolean(dr["Bowl"]);
                            _toilet.Basin = Convert.ToBoolean(dr["Basin"]);
                            _toilet.ToiletRoll = Convert.ToBoolean(dr["ToiletRoll"]);
                            _toilet.SoapDispenser = Convert.ToBoolean(dr["SoapDispenser"]);
                            _toilet.AutoAirFreshner = Convert.ToBoolean(dr["AutoAirFreshner"]);
                            _toilet.Waste = Convert.ToBoolean(dr["Waste"]);

                            _lstToliets.Add(_toilet);
                           
                        }

                        dept.toilets = _lstToliets;
                    }

                    if (ds.Tables[6].Rows.Count > 0)
                    {
                        foreach (DataRow dr in ds.Tables[6].Rows)
                        {
                            Dispenser _dispenser = new Dispenser();

                            _dispenser.UserAreaId = Convert.ToInt32(dr["UserAreaId"]);
                            _dispenser.HandPaperTowel = Convert.ToInt32(dr["HandPaperTowel"]);
                            _dispenser.JumboRollToiletRoll = Convert.ToInt32(dr["JumboRoll"]);
                            _dispenser.HandSoapLiquidSoapDispenser = Convert.ToInt32(dr["HandSoap"]);
                            _dispenser.Deodorant = Convert.ToInt32(dr["Deodorant"]);
                            _dispenser.FootPumpNonContactTypeDispenser = Convert.ToInt32(dr["FootPump"]);
                            _dispenser.HandDryers = Convert.ToInt32(dr["HandDryers"]);
                            _dispenser.AutoTimerDeodorizerAirFreshenerDispenser = Convert.ToInt32(dr["AutoTimer"]);

                            dept.dispenser = _dispenser;
                        }
                    }

                    if (ds.Tables[7].Rows.Count > 0)
                    {
                        List<VariationDetails> _lstVariationDetails = new List<VariationDetails>();

                        foreach (DataRow dr in ds.Tables[7].Rows)
                        {
                            VariationDetails _variationDetails = new VariationDetails();

                            _variationDetails.VariationDetailsId = Convert.ToInt32(dr["VariationDetailsId"]);
                            _variationDetails.UserAreaId = Convert.ToInt32(dr["UserAreaId"]);
                            _variationDetails.AreaCode = Convert.ToString(dr["AreaCode"]);
                            _variationDetails.AreaName = Convert.ToString(dr["AreaName"]);
                            _variationDetails.SNFReference = Convert.ToString(dr["SNFReferenceNo"]);
                            _variationDetails.VariationStatus = Convert.ToInt32(dr["VariationStatus"]);
                            _variationDetails.Sqft = Convert.ToInt32(dr["Sqft"]);
                            _variationDetails.Price = Convert.ToDecimal(dr["Price"]);
                            
                            if (dr["CommissioningDate"] == System.DBNull.Value)
                                _variationDetails.CommissioningDate = null;
                            else
                                _variationDetails.CommissioningDate = Convert.ToDateTime(dr["CommissioningDate"]);

                            if (dr["ServiceStartDate"] == System.DBNull.Value)
                                _variationDetails.ServiceStartDate = null;
                            else
                            _variationDetails.ServiceStartDate = Convert.ToDateTime(dr["ServiceStartDate"]);

                            if (dr["WarrentyEndDate"] == System.DBNull.Value)
                                _variationDetails.WarrantyEndDate = null;
                            else
                            _variationDetails.WarrantyEndDate = Convert.ToDateTime(dr["WarrentyEndDate"]);

                            if (dr["VariationDate"] == System.DBNull.Value)
                                _variationDetails.VariationDate = null;
                            else
                           _variationDetails.VariationDate = Convert.ToDateTime(dr["VariationDate"]);

                            if (dr["ServiceStopDate"] == System.DBNull.Value)
                                _variationDetails.ServiceStopDate = null;
                            else
                            _variationDetails.ServiceStopDate = Convert.ToDateTime(dr["ServiceStopDate"]);

                            _lstVariationDetails.Add(_variationDetails);
                            
                        }
                        dept.variationDetails = _lstVariationDetails;
                    }

                }
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return dept;
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

        public DeptAreaDetails UserAreaCodeFetch(DeptAreaDetails dat)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(UserAreaCodeFetch), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                DeptAreaDetails entity = new DeptAreaDetails();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pUserAreaId", Convert.ToString(dat.UserAreaId));
                DataSet dt = dbAccessDAL.GetDataSet("sp_CLS_DeptAreaDetailsFetch", parameters, DataSetparameters);
                if (dt != null && dt.Tables.Count > 0)
                {
                    entity.LocationDetailsList = (from n in dt.Tables[0].AsEnumerable()
                                                  select new LocationDetails
                                                  {                                                      
                                                      LocationId = n.Field<int>("LocationId"),
                                                      LocationCode = n.Field<string>("LocationCode"),
                                                      Status = n.Field<int>("Status"),
                                                      Floor = n.Field<Boolean>("Floor"),
                                                      Walls = n.Field<Boolean>("Walls"),
                                                      Celling = n.Field<Boolean>("Celling"),
                                                      WindowsDoors = n.Field<Boolean>("WindowsDoors"),
                                                      ReceptaclesContainers = n.Field<Boolean>("ReceptaclesContainers"),
                                                      FurnitureFixtureEquipments = n.Field<Boolean>("FurnitureFixtureEquipments")
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


    }
}
