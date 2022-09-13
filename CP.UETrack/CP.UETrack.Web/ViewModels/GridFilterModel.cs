using System.Collections.Generic;

namespace CP.UETrack.Application.Web.ViewModel
{
    public class GridFilterModel
    {
        public string groupOp { get; set; }

        public List<GridRuleModel> rules { get; set; }
    }
}
