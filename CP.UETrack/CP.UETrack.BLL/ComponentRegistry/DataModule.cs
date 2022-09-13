namespace CP.UETrack.BLL.ComponentRegistry
{
    using Ninject.Modules;
    using DAL.DataAccess;
    using Ninject.Extensions.Conventions;
    using System.Reflection;
    using DAL.DataAccess.Contracts.BEMS;
    using DAL.DataAccess.Implementations.BEMS;
    using DAL.DataAccess.Contracts.FEMS;
    using DAL.DataAccess.Implementations.FEMS;
    // using DAL.DataAccess.Contracts.MASTER;
    //using DAL.DataAccess.Implementations.MASTER;
    using DAL.DataAccess.Contracts;
    using DAL.DataAccess.Implementation;
    using DAL.DataAccess.Contracts.KPI;
    using DAL.DataAccess.Implementations.KPI;
    using DAL.DataAccess.Contracts.QAP;
    using DAL.DataAccess.Implementations.QAP;
    using DAL.DataAccess.Contracts.VM;
    using DAL.DataAccess.Implementations.VM;
    using DAL.DataAccess.Contracts.BER;
    using DAL.DataAccess.Implementations.BER;
    using DAL.DataAccess.Contracts.Home;
    using DAL.DataAccess.Implementations.Home;
    using DAL.DataAccess.Contracts.Portering;
    using DAL.DataAccess.Implementations.Portering;
    using DAL.DataAccess.Contracts.GM;
    using DAL.DataAccess.Implementations.GM;
    using DAL.DataAccess.Contracts.UM;
    using DAL.DataAccess.Implementations.UM;
    using DAL.DataAccess.Contracts.SmartAssign;
    using DAL.DataAccess.Implementations.SmartAssign;
    using DAL.DataAccess.Contracts.Common;
    using DAL.DataAccess.Implementations.Common;
    using CP.UETrack.DAL.DataAccess.Contracts.LLS;
    using CP.UETrack.DAL.DataAccess.Implementations.LLS;
    using CP.UETrack.DAL.DataAccess.Implementations.LLS.Transaction;
    using CP.UETrack.DAL.DataAccess.Implementations.LLS.Master;
    using CP.UETrack.DAL.DataAccess.Contracts.LLS.Transaction;
    using DAL.DataAccess.Contracts.CLS;
    using DAL.DataAccess.Implementations.CLS;
    using DAL.DataAccess.Contracts.HWMS;
    using DAL.DataAccess.Implementations.HWMS;
    using DAL.DataAccess.Implementations;

    public class DataModule : NinjectModule
    {
        public override void Load()
        {
            try

            {
              
                Bind<IAccountDAL>().To<AccountDAL>();
                Bind<ICommonDAL>().To<CommonDAL>();
                Bind<INavigationDAL>().To<NavigationDAL>();
                Bind<IAuthorizationDAL>().To<AuthorizationDAL>();

                this.Bind(x => x.FromThisAssembly()
                         .IncludingNonePublicTypes()
                         .SelectAllClasses()
                         .BindAllInterfaces());

                Bind<ICustomerDAL>().To<CustomerDAL>();
                Bind<IUserRoleDAL>().To<UserRoleDAL>();
                Bind<IUserRegistrationDAL>().To<UserRegistrationDAL>();
                Bind<IContractorandVendorDAL>().To<ContractorandVendorDAL>();
                Bind<IFacilityDAL>().To<FacilityDAL>();
                Bind<IRoleScreenPermissionDAL>().To<RoleScreenPermissionDAL>();
                Bind<IAssetClassificationDAL>().To<AssetClassificationDAL>();
                Bind<IUserAreaDAL>().To<UserAreaDAL>();
                Bind<IUserLocationDAL>().To<UserLocationDAL>();
                Bind<IUnblockUserDAL>().To<UnblockUserDAL>();
                Bind<IBlockDAL>().To<BlockDAL>();
                Bind<IFEMSBlockDAL>().To<FEMSBlockDAL>();
                Bind<ILevelDAL>().To<LevelDAL>();
                Bind<IMasterUserAreaDAL>().To<MasterUserAreaDAL>();
                Bind<IMasterUserLocationDAL>().To<MasterUserLocationDAL>();
               // Bind<IUnblockUserDAL>().To<UnblockUserDAL>();
                Bind<IMasterBlockDAL>().To<MasterBlockDAL>();
                Bind<IMasterLevelDAL>().To<MasterlevelDAL>();
                // Bind<IAssetTypeCodeStandardTasksDAL>().To<AssetTypeCodeStandardTasksDAL>();
                Bind<IWorkingCalenderDAL>().To<WorkingCalenderDAL>();
                Bind<IAssertregisterVariationDetailsTabDAL>().To<AssertregisterVariationDetailsTabDAL>();
                Bind<IMaintananceHistoryTabAssetregisterDAL>().To<MaintananceHistoryTabAssetregisterDAL>();
                Bind<ISearchDAL>().To<SearchDAL>();
                Bind<IAssetRegisterLicenseCertTabDAL>().To<AssetRegisterLicenseCertficateTabDAL>();
                Bind<IAssertregisterAssetProcessingStatusDAL>().To<AssertregisterAssetProcessingStatusDAL>();
                Bind<IAssetregisterAttachmentDAL>().To<AssetRegisterAttachmentDAL>();
                Bind<IFetchDAL>().To<FetchDAL>();
                Bind<IAssetInformationDAL>().To<AssetInformationDAL>();
                Bind<ICompanyStaffMstDAL>().To<CompanyStaffMstDAL>();
                Bind<IFacilityStaffMstDAL>().To<FacilityStaffMstDAL>();
                Bind<IAssetRegisterWarrantyProviderTabDAL>().To<AssetRegisterWarrantyProviderTabDAL>();
                Bind<IRescheduleWODAL>().To<RescheduleWODAL>();
                Bind<IStockUpdateRegisterDAL>().To<StockUpdateRegisterDAL>();
                Bind<IFemsStockUpdateRegisterDAL>().To<FemsStockUpdateRegisterDAL>();
                Bind<IAssetRegisterDAL>().To<AssetRegisterDAL>();
                Bind<IPPMChecklistDAL>().To<PPMChecklistDAL>();
                Bind<IStockAdjustmentDAL>().To<StockAdjustmentDAL>();
               // Bind<IPPMRegisterDAL>().To<PPMRegisterDAL>();
                Bind<IEODCategorySystemDAL>().To<EODCategorySystemDAL>();
                Bind<ILayoutDAL>().To<LayoutDAL>();
                Bind<IEODTypeCodeMappingDAL>().To<EODTypeCodeMappingDAL>();
                Bind<IPenaltyMasterDAL>().To<PenaltyMasterDAL>();
                Bind<ITypeCodeDetailsDAL>().To<TypeCodeDetailsDAL>();
                Bind<IContractOutRegisterDAL>().To<ContractOutRegisterDAL>();
                Bind<IFemsContractOutRegisterDAL>().To<FemsContractOutRegisterDAL>();
                Bind<DAL.DataAccess.Contracts.KPI.IIndicatorMasterDAL>().To<DAL.DataAccess.Implementations.KPI.IndicatorMasterDAL>();
                Bind<IParameterMasterDAL>().To<ParameterMasterDAL>();
                Bind<IFacilityWorkshopDAL>().To<FacilityWorkshopDAL>();
                Bind<IMonthlyServiceFeeDAL>().To<MonthlyServiceFeeDAL>();
                Bind<ICRMRequestDAL>().To<CRMRequestDAL>();
                Bind<ITestingAndCommissioningDAL>().To<TestingAndCommissioningDAL>();
                Bind<IQAPIndicatorMasterDAL>().To<QAPIndicatorMasterDAL>();
                Bind<ILicenseAndCertificateDAL>().To<LicenseAndCertificateDAL>();
                Bind<DAL.DataAccess.Contracts.QAP.IQualityCauseMasterDAL>().To<DAL.DataAccess.Implementations.QAP.QualityCauseMasterDAL>();
                Bind<ISparepartRegisterDAL>().To<SparepartRegisterDAL>();
                Bind<IBulkAuthorizationDAL>().To<BulkAuthorizationDAL>();
                Bind<IPPMLoadBalancingDAL>().To<PPMLoadBalancingDAL>();
                Bind<IEODParameterMappingDAL>().To<EODParameterMappingDAL>();
                Bind<IEODCaptureDAL>().To<EODCaptureDAL>();
                Bind<IPPMPlannerDAL>().To<PPMPlannerDAL>();
                Bind<ISummaryReportonVariationsDAL>().To<SummaryReportonVariationsDAL>();
                Bind<IMonthlyStockRegisterDAL>().To<MonthlyStockRegisterDAL>();
                Bind<ISNFDAL>().To<SNFDAL>();
                Bind<IKPIGenerationDAL>().To<KPIGenerationDAL>();
                Bind<IBER1ApplicationDAL>().To<BER1ApplicationDAL>();
                Bind<IEODDashboardDAL>().To<EODDashboardDAL>();
                Bind<IBERDashboardDAL>().To<BERDashboardDAL>();
                Bind<IHomeDashboardDAL>().To<HomeDashboardDAL>();
                Bind<IScheduleGenerationDAL>().To<ScheduleGenerationDAL>();
                Bind<IQAPDashboardDAL>().To<QAPDashboardDAL>();
                Bind<IKPIDashboardDAL>().To<KPIDashboardDAL>();
                Bind<IMonthlyKPIAdjustmentsDAL>().To<MonthlyKPIAdjustmentsDAL>();
                Bind<IKPITransactionMappingDAL>().To<KPITransactionMappingDAL>();
                Bind<IImageVideoUploadDAL>().To<ImageVideoUploadDAL>();
                Bind<IVMMonthClosingDAL>().To<VMMonthClosingDAL>();
                Bind<IWarrantyManagementDAL>().To<WarrantyManagementDAL>();
                Bind<IScheduledWorkOrderDAL>().To<ScheduledWorkOrderDAL>();
                Bind<IAssetStandardizationDAL>().To<AssetStandardizationDAL>();
                Bind<IVVFDAL>().To<VVFDAL>();
                Bind<IChangePasswordDAL>().To<ChangePasswordDAL>();
                Bind<ICRMWorkorderDAL>().To<CRMWorkorderDAL>();
                Bind<IAssetQRCodePrintDAL>().To<AssetQRCodePrintDAL>();
                Bind<IDepartmentQRCodePrintingDAL>().To<DepartmentQRCodePrintingDAL>();
                Bind<IUserLocationQRCodePrintingDAL>().To<UserLocationQRCodePrintingDAL>();
                Bind<IVMDashboardDAL>().To<VMDashboardDAL>();
                Bind<IPorteringDAL>().To<PorteringDAL>();
                Bind<ISummaryofFeeReportDAL>().To<SummaryofFeeReportDAL>();
                Bind<IUserTrainingDAL>().To<UserTrainingDAL>();
                Bind<IForgotPasswordDAL>().To<ForgotPasswordDAL>();
                Bind<ILovMasterDAL>().To<LovMasterDAL>();
                Bind<ICustomerConfigDAL>().To<CustomerConfigDAL>();
                Bind<ILoanerBookingDAL>().To<LoanerBookingDAL>();
                Bind<IUserShiftLeaveDetailsDAL>().To<UserShiftLeaveDetailsDAL>();
                Bind<IAdditionalFieldsDAL>().To<AdditionalFieldsDAL>();
                Bind<ITrackingTechnicianDAL>().To<TrackingTechnicianDAL>();
                Bind<ISmartAssignDAL>().To<SmartAssignDAL>();
                Bind<IPorteringSmartAssignDAL>().To<PorteringSmartAssignDAL>();                
                Bind<ICurrentMaintenanceDAL>().To<CurrentMaintenanceDAL>();
                Bind<IManualassignDAL>().To<ManualassignDAL>();
                Bind<DAL.DataAccess.ICorrectiveActionReportDAL>().To<DAL.DataAccess.CorrectiveActionReportDAL>();
                Bind<IDashboardDAL>().To<DashboardDAL>();
                Bind<INotificationDeliveryConfigurationDAL>().To<NotificationDeliveryConfigurationDAL>();
                Bind<IManualassignPorteringDAL>().To<ManualAssignPorteringDAL>();
                Bind<ICRMWorkorderAssignDAL>().To<CRMWorkorderAssignDAL>();
                Bind<IReportsAndRecordsDAL>().To<ReportsAndRecordsDAL>();
                Bind<IReportLoadLovDAL>().To<ReportLoadLovDAL>();
                Bind<IARPApplicationDAL>().To<ARPApplicationDAL>();

                //------------------LLS-----------------------------//
                Bind<IDepartmentDetailsDAL>().To<DepartmentDetailsDAL>();
                Bind<ILaundryPlantDAL>().To<LaundryPlantDAL>();
                Bind<ICleanLinenIssueDAL>().To<CleanLinenIssueDAL>();
                Bind<ICleanLinenRequestDAL>().To<CleanLinenRequestDAL>();
                Bind<ICleanLinenDespatchDAL>().To<CleanLinenDespatchDAL>();
                Bind<ICentralCleanLinenStoreDAL>().To<CentralCleanLinenStoreDAL>();
                Bind<ILinenItemDetailsDAL>().To<LinenItemDetailsDAL>();
                Bind<DAL.DataAccess.Contracts.LLS.ILicenseTypeDAL>().To<DAL.DataAccess.Implementations.LLS.LicenseTypeDAL>();
                Bind<IFacilitiesEquipmentToolsDAL>().To<FacilitiesEquipmentToolsDAL>();
                Bind<IWeighingScaleDAL>().To<WeighingScaleDAL>();
                Bind<DAL.DataAccess.Contracts.LLS.IDriverDetailsDAL>().To<DAL.DataAccess.Implementations.LLS.DriverDetailsDAL>();
                Bind<DAL.DataAccess.Contracts.LLS.IVehicleDetailsDAL>().To<DAL.DataAccess.Implementations.LLS.Master.VehicleDetailsDAL>();               
                Bind<ICentralLinenStoreHKeepingDAL>().To<CentralLinenStoreHKeepingDAL>();
                Bind<ILinenCondemnationDAL>().To<LinenCondemnationDAL>();
                Bind<ILinenRepairDAL>().To<LinenRepairDAL>();
                Bind<ILinenRejectReplacementDAL>().To<LinenRejectReplacementDAL>();
                Bind<ILinenAdjustmentsDAL>().To<LinenAdjustmentsDAL>();
                Bind<ILinenInjectionDAL>().To<LinenInjectionDAL>();
                Bind<ILinenInventoryDAL>().To<LinenInventoryDAL>();
                Bind<ISoiledLinenCollectionDAL>().To<SoiledLinenCollectionDAL>();

                //CLS
                Bind<IApprovedChemicalListDAL>().To<ApprovedChemicalListDAL>();
                Bind<IChemicalInUseDAL>().To<ChemicalInuseDAL>();
                Bind<IFETCDAL>().To<FETCDAL>();
                Bind<IJIScheduleGenerationDAL>().To<JIScheduleGenerationDAL>();
                Bind<IWeekCalendarDAL>().To<WeekCalendarDAL>();
                Bind<IDeptAreaDetailsDAL>().To<DeptAreaDetailsDAL>();
                Bind<IPeriodicWorkRecordDAL>().To<PeriodicWorkRecordDAL>();
                Bind<IJIDetailsDAL>().To<JIDetailsDAL>();
                Bind<IDailyCleaningActivityDAL>().To<DailyCleaningActivityDAL>();
                Bind<IToiletInspectionDAL>().To<ToiletInspectionDAL>();
                Bind<DAL.DataAccess.Contracts.CLS.IQualityCauseMasterDAL>().To<DAL.DataAccess.Implementations.CLS.QualityCauseMasterDAL>();
                Bind<DAL.DataAccess.Contracts.CLS.IIndicatorMasterDAL>().To<DAL.DataAccess.Implementations.CLS.IndicatorMasterDAL>();
                Bind<DAL.DataAccess.Contracts.CLS.ICorrectiveActionReportDAL>().To<DAL.DataAccess.Implementations.CLS.CorrectiveActionReportDAL>();
                Bind<ICLSFetchDAL>().To<CLSFetchDAL>();

                //HWMS                
                Bind<IDeptAreaDetailDAL>().To<DeptAreaDetailDAL>();
                Bind<IBinMasterDAL>().To<BinMasterDAL>();
                Bind<DAL.DataAccess.Contracts.HWMS.IVehicleDetailsDAL>().To<DAL.DataAccess.Implementations.HWMS.VehicleDetailsDAL>();
                Bind<IWasteTypeDAL>().To<WasteTypeDAL>();
                Bind<DAL.DataAccess.Contracts.HWMS.ILicenseTypeDAL>().To<DAL.DataAccess.Implementations.HWMS.LicenseTypeDAL>();
                Bind<DAL.DataAccess.Contracts.HWMS.IDriverDetailsDAL>().To<DAL.DataAccess.Implementations.HWMS.DriverDetailsDAL>();
                Bind<IFacilitiesEquipmentDAL>().To<FacilitiesEquipmentDAL>();
                Bind<IConsumablesReceptaclesDAL>().To<ConsumablesReceptaclesDAL>();
                Bind<ICollectionCategoryDAL>().To<CollectionCategoryDAL>();
                Bind<ITransportationCategoryDAL>().To<TransportationCategoryDAL>();
                Bind<ITreatmentPlantDAL>().To<TreatmentPlantDAL>();
                Bind<IApprovedChemicalListsDAL>().To<ApprovedChemicalListsDAL>();
                Bind<IConsignmentNoteCWCNDAL>().To<ConsignmentNoteCWCNDAL>();
                Bind<IOSWRecordSheetDAL>().To<OSWRecordSheetDAL>();
                Bind<IDailyWeighingRecordDAL>().To<DailyWeighingRecordDAL>();
                Bind<ICWRecordSheetDAL>().To<CWRecordSheetDAL>();
                Bind<DAL.DataAccess.Contracts.HWMS.IIndicatorMasterDAL>().To<DAL.DataAccess.Implementations.HWMS.IndicatorMasterDAL>();
                Bind<DAL.DataAccess.Contracts.HWMS.IQualityCauseMasterDAL>().To<DAL.DataAccess.Implementations.HWMS.QualityCauseMasterDAL>();
                Bind<IDailyTemperatureLogDAL>().To<DailyTemperatureLogDAL>();

                Bind<IConsignmentNoteOSWCNDAL>().To<ConsignmentNoteOSWCNDAL>();
                Bind<IRecordsofRecyclableWasteDAL>().To<RecordsofRecyclableWasteDAL>();
                Bind<ICSWRecordSheetDAL>().To<CSWRecordSheetDAL>();
                Bind<ICorrectiveActionReportsDAL>().To<CorrectiveActionReportsDAL>();




                //CLS--Reports                
                Bind<ICLSReportsDAL>().To<CLSReportsDAL>();

                //HWMS--Reports
                Bind<IHWMSReportsDAL>().To<HWMSReportsDAL>();


            }
            catch (ReflectionTypeLoadException ex)
            {
                var loaderExceptions = ex.LoaderExceptions;
            }
        }
    }
}

