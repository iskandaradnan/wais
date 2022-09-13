using System.Collections.Generic;

namespace CP.UETrack.Model
{
    public class SortPaginateFilter
    {

        #region Properties
        public string Page
        {
            get; set;
        }
        public int Rows
        {
            get; set;
        }
        public string SortColumn
        {
            get; set;
        }
        public string SortOrder
        {
            get; set;
        }
        public bool Search
        {
            get; set;
        }
        public string Filters
        {
            get; set;
        }
        public int PageIndex
        {
            get; set;
        }
        public int PageSize
        {
            get; set;
        }
        public string WhereCondition
        {
            get; set;
        }
        public int TotalRecords
        {
            get; set;
        }
        public int TotalPages
        {
            get; set;
        }

        public int AccessLevel
        {
            get; set;
        }

        public List<GridRuleViewModel> rules
        {
            get; set;
        }
        public string QueryWhereCondition
        {
            get; set;
        }
        #endregion
    }

    public class GridRuleViewModel
    {
        public string field { get; set; }
        public string op { get; set; }
        public string data { get; set; }
        public string sqlQueryExpression { get; set; }
    }
}
