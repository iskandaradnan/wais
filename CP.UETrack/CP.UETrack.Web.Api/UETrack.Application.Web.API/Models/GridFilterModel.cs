using System.Collections.Generic;

namespace UETrack.Application.Web.API.Models
{
    public class GridFilterModel
    {
        public string groupOp { get; set; }
        public List<GridRuleModel> rules { get; set; }
        public List<GridAdvanceFilterModel> groups { get; set; }
        ///To remove after checking with Dev - 16/Nov/2017
        //public List<GridRuleModel> gridRules
        //{
        //    get; set;
        //}

    }
    public class GridAdvanceFilterModel {
        public string groupOp { get; set; }
        public List<GridRuleModel> rules { get; set; }
    }
}
