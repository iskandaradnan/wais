using CP.UETrack.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.GM
{
    public class LovMasterViewModel
    {
        public int ParameterMappingId { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public string LovKey { get; set; }
        public string ModuleName { get; set; }
        public string ScreenName { get; set; }
        public int LovId { get; set; }
        public string FieldName { get; set; }
        public string IsDefault { get; set; }
        public string Timestamp { get; set; }
        public string LovType { get; set; }
        public List<LovMasterGrid> LovMasterGridData { get; set; }
    }
    public class LovMasterGrid
    {
        public int LovId { get; set; }
        public string LovKey { get; set; }
        public string DefaultValue { get; set; }
        public string Fieldcode { get; set; }
        public string FieldValue { get; set; }
        public string Remarks { get; set; }
        public int SortNo { get; set; }
        public Boolean IsDefault { get; set; }
        public int PageSize { get; set; }
        public int Pageindex { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int TotalRecords { get; set; }
        public int TotalPageCalc { get; set; }
        public string ModuleName { get; set; }
        public string ScreenName { get; set; }
        public Boolean BuiltIn { get; set; }
        public string FieldName { get; set; }
        public string LovType { get; set; }
        public string HelpDescription { get; set; }

    }
    public class LovMasterDropdownValues
    {
        public List<LovValue> LovType { get; set; }
        public List<LovValue> Services { get; set; }
    }
    
}


