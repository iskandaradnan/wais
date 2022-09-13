using CP.UETrack.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.CLS
{
    public class DeptAreaDetails
    {
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public int DeptAreaId { get; set; }
        public int UserAreaId { get; set; }
        public string UserAreaCode { get; set; }
        public string UserAreaName { get; set; }
        public string CategoryOfArea { get; set; }
        public string Status { get; set; }
        public string OperatingDays { get; set; }
        public int WorkingHours { get; set; }
        public int TotalReceptacles { get; set; }
        public int CleanableArea { get; set; }
        public int NoOfHandWashingFacilities { get; set; }
        public int NoOfBeds { get; set; }
        public int TotalNoOfUserLocations { get; set; }
        public string HospitalRepresentative { get; set; }
        public string HospitalRepresentativeDesignation { get; set; }
        public string CompanyRepresentative { get; set; }
        public string CompanyRepresentativeDesignation { get; set; }
        public DateTime? EffectiveFromDate { get; set; }
        public DateTime? EffectiveToDate { get; set; }
        public string JISchedule { get; set; }
        public string Remarks { get; set; }
        public string LocationCode { get; set; }
        public List<LocationDetails> LocationDetailsList { get; set; }
        public Receptacles receptacles { get; set; }
        public DailyCleaningSchedule dailyCleaningSchedule { get; set; }
        public PeriodicWorkSchedule periodicWorkSchedule { get; set; }
        public List<Toilet> toilets { get; set; }
        public Dispenser dispenser { get; set; }
        public List<VariationDetails> variationDetails { get; set; }       

    }

    // Dept Area Details Location Details
    public class LocationDetails
    {        
        public int LocationId { get; set; }
        public string LocationCode { get; set; }        
        public int Status { get; set; }
        public bool Floor { get; set; }
        public bool Walls { get; set; }
        public bool Celling { get; set; }
        public bool WindowsDoors { get; set; }
        public bool ReceptaclesContainers { get; set; }
        public bool FurnitureFixtureEquipments { get; set; }

    }

    // Receptacles Tab
    public class Receptacles
    {
        public int DeptAreaId { get; set; }
        public int UserAreaId { get; set; }
        public int Bin660L { get; set; }
        public int Bin240L { get; set; }
        public int WastePaperBasket { get; set; }
        public int PedalBin { get; set; }
        public int BedsideBin { get; set; }
        public int FilpFlop { get; set; }
        public int FoodBin { get; set; }
    }
    
    // Daily Cleaning Schedule
    public class DailyCleaningSchedule
    {
        public int DeptAreaId { get; set; }
        public int UserAreaId { get; set; }
        public int Dustmop { get; set; }
        public int Dampmop { get; set; }
        public int Vacuum { get; set; }
        public int Washing { get; set; }
        public int Sweeping { get; set; }
        public int Wiping { get; set; }      
        public int PaperHandTowel { get; set; }
        public int ToiletJumbo { get; set; }
        public int HandSoap { get; set; }
        public int Deodorisers { get; set; }
        public int DomesticWasteCollection { get; set; }
    }
    
    // Periodic Work Schedule
    public class PeriodicWorkSchedule
    {
        public int DeptAreaId { get; set; }
        public int UserAreaId { get; set; }
        public int ContainerReceptaclesWashing { get; set; }
        public int CeilingHighDusting { get; set; }
        public int LightsAirCondOutletFanWiping { get; set; }
        public int FloorNonPolishableScrubbing { get; set; }
        public int FloorPolishablePolishing { get; set; }
        public int FloorPolishableBuffing { get; set; }
        public int FloorCarpetBonnetBuffing { get; set; }
        public int FloorCarpetShampooing { get; set; }
        public int FloorCarpetHeatSteamExtraction { get; set; }
        public int WallWiping { get; set; }
        public int WindowDoorWiping { get; set; }
        public int PerimeterDrainWashScrub { get; set; }
        public int ToiletDescaling { get; set; }
        public int HighRiseNetttingHighDusting { get; set; }
        public int ExternalFacadeCleaning { get; set; }
        public int ExternalHighLevelGlassCleaning { get; set; }
        public int InternetGlass { get; set; }
        public int FlatRoofWashScrub { get; set; }
        public int StainlessSteelPolishing { get; set; }
        public int ExposeCeilingTruss { get; set; }
        public int LedgesDampWipe { get; set; }
        public int SkylightHighDusting { get; set; }
        public int SignagesWiping { get; set; }
        public int DecksHighDusting { get; set; }
    }
    
    // Toilets
    public class Toilet
    {
        public int ToiletId { get; set; }
        public int DeptAreaId { get; set; }
        public int UserAreaId { get; set; }
        public int LocationId { get; set; }
        public string LocationCode { get; set; }
        public int Type { get; set; }
        public int Frequency { get; set; }       
        public int Details { get; set; }
        public bool Mirror { get; set; }
        public bool Floor { get; set; }
        public bool Wall { get; set; }
        public bool Urinal { get; set; }
        public bool Bowl { get; set; }
        public bool Basin { get; set; }
        public bool ToiletRoll { get; set; }
        public bool SoapDispenser { get; set; }
        public bool AutoAirFreshner { get; set; }
        public bool Waste { get; set; }        
        public bool isDeleted { get; set; }
    }
   
    // Dispenser
    public class Dispenser
    {
        public int DeptAreaId { get; set; }
        public int UserAreaId { get; set; }
        public int HandPaperTowel { get; set; }
        public int JumboRollToiletRoll { get; set; }
        public int HandSoapLiquidSoapDispenser { get; set; }
        public int Deodorant { get; set; }
        public int FootPumpNonContactTypeDispenser { get; set; }
        public int HandDryers { get; set; }
        public int AutoTimerDeodorizerAirFreshenerDispenser { get; set; }
    }
    
    // VariationDetails
    public class VariationDetails
    {
        public int VariationDetailsId { get; set; }
        public int DeptAreaId { get; set; }
        public int UserAreaId { get; set; }
        public string AreaCode { get; set; }
        public string AreaName { get; set; }
        public string SNFReference { get; set; }
        public int VariationStatus { get; set; }
        public int Sqft { get; set; }
        public decimal Price { get; set; }
        public DateTime? CommissioningDate { get; set; }
        public DateTime? ServiceStartDate { get; set; }
        public DateTime? WarrantyEndDate { get; set; }
        public DateTime? VariationDate { get; set; }
        public DateTime? ServiceStopDate { get; set; }
        public bool isDeleted { get; set; }
    }

    public class DeptAreaDetailsDropdown
    {
        public List<LovValue> CategoryOfAreaLovs { get; set; }
        public List<LovValue> StatusLovs { get; set; }
        public List<LovValue> OperatingDateLovs { get; set; }
        public List<LovValue> WorkingHoursLovs { get; set; }
        public List<LovValue> JIScheduleLovs  { get; set; }
        public List<LovValue> PeriodicWorkLovs { get; set; }
        public List<LovValue> VariationDetailsLovs { get; set; }
        public List<LovValue> ToiletLovs { get; set; }
        public List<LovValue> ToiletTypeLovs { get; set; }
        public List<LovValue> ToiletDetailsLovs { get; set; }
    }

}
