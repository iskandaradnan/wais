using UETrack.Application.Web.API.Models;
using CP.UETrack.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Script.Serialization;

namespace CP.UETrack.Application.Web.API.Helpers
{
    public class GridHelper
    {

        public static SortPaginateFilter GetAllFormatSearchCondition<T>(IEnumerable<KeyValuePair<string, string>> pageState)
        {
            var spf = new SortPaginateFilter();

            var gridParams = pageState;
            var page = gridParams.FirstOrDefault(x => x.Key == "page").Value;
            var rows = Convert.ToInt32(gridParams.FirstOrDefault(x => x.Key == "rows").Value);
            var sortColumn = gridParams.FirstOrDefault(x => x.Key == "sidx").Value;
            var sortType = gridParams.FirstOrDefault(x => x.Key == "sord").Value;
            var _search = Convert.ToBoolean(gridParams.FirstOrDefault(x => x.Key == "_search").Value);
            var _additionalFilters = pageState.FirstOrDefault(x => x.Key == "defaultFilters").Value;
            var filters = "";

            if (_search)
            {
                filters = gridParams.FirstOrDefault(x => x.Key == nameof(filters)).Value;
                
                
            }

            var pageIndex = Convert.ToInt32(page) - 1;
            if (pageIndex < 0)
                pageIndex = 0;

            rows = (rows == 0) ? 10 : rows;
            var pageSize = rows;


            spf.Page = page;
            spf.Rows = rows;
            spf.SortColumn = sortColumn;
            spf.SortOrder = sortType;
            spf.Search = _search;
            spf.Filters = filters;
            spf.PageIndex = pageIndex;
            spf.PageSize = pageSize;

            if (_search || !string.IsNullOrEmpty(_additionalFilters))
            {
                var gridRules = new List<GridRuleViewModel>();
                var serializer = new JavaScriptSerializer();
                if (!string.IsNullOrEmpty(filters) && !string.IsNullOrEmpty(_additionalFilters))
                {
                    var gridFilters = serializer.Deserialize<GridFilterModel>(filters);
                    var defaultFilters = serializer.Deserialize<GridFilterModel>(_additionalFilters);
                    var a = genarateCondition<T>(gridFilters,out gridRules);
                    var gridFilterRule = gridRules;
                    gridRules = new List<GridRuleViewModel>();
                    var b = genarateCondition<T>(defaultFilters,out gridRules);
                    gridRules.AddRange(gridFilterRule);

                    spf.WhereCondition = "(" + a + ") and " + b;
                    spf.QueryWhereCondition = "(" + gridFilterRule.FirstOrDefault().sqlQueryExpression + ") and (" + gridRules.FirstOrDefault().sqlQueryExpression +")";
                }
                else if (!string.IsNullOrEmpty(filters))
                {
                    var gridFilters = serializer.Deserialize<GridFilterModel>(filters);
                    var a = genarateCondition<T>(gridFilters,out gridRules);
                    spf.WhereCondition = a;
                    spf.QueryWhereCondition = "(" + gridRules.FirstOrDefault().sqlQueryExpression + ")";

                }
                else if (!string.IsNullOrEmpty(_additionalFilters))
                {
                    var defaultFilters = serializer.Deserialize<GridFilterModel>(_additionalFilters);
                    var b = genarateCondition<T>(defaultFilters,out gridRules);
                    spf.WhereCondition = b;
                    spf.QueryWhereCondition = "(" + gridRules.FirstOrDefault().sqlQueryExpression + ")";
                }
                spf.rules = gridRules;
            }

            if (string.IsNullOrEmpty(sortType))
            {
                spf.SortOrder = "desc";
            }
            spf.QueryWhereCondition = spf.QueryWhereCondition == null ? null : spf.QueryWhereCondition.Replace("IS NULL ('')", " IS NULL ");
            spf.QueryWhereCondition = spf.QueryWhereCondition == null ? null : spf.QueryWhereCondition.Replace("IS NOT NULL '')", " IS NOT NULL ");
            return spf;
        }

        public static SortPaginateFilter GetAllFormatSearchConditionForExport<T>(IEnumerable<KeyValuePair<string, string>> pageState)
        {
            var spf = new SortPaginateFilter();

            var gridParams = pageState;
            var _additionalFilters = pageState.FirstOrDefault(x => x.Key == "defaultFilters").Value;
            var filters = "";

            filters = gridParams.FirstOrDefault(x => x.Key == nameof(filters)).Value;
            spf.Filters = filters;

            var gridRules = new List<GridRuleViewModel>();
            var serializer = new JavaScriptSerializer();
            if (!string.IsNullOrEmpty(filters) && !string.IsNullOrEmpty(_additionalFilters))
            {
                var gridFilters = serializer.Deserialize<GridFilterModel>(filters);
                var defaultFilters = serializer.Deserialize<GridFilterModel>(_additionalFilters);
                var a = genarateCondition<T>(gridFilters, out gridRules);
                var gridFilterRule = gridRules;
                gridRules = new List<GridRuleViewModel>();
                var b = genarateCondition<T>(defaultFilters, out gridRules);
                gridRules.AddRange(gridFilterRule);


                spf.WhereCondition = "(" + a + ") and " + b;
                spf.QueryWhereCondition = "(" + gridFilterRule.FirstOrDefault().sqlQueryExpression + ") and (" + gridRules.FirstOrDefault().sqlQueryExpression + ")";
            }
            else if (!string.IsNullOrEmpty(filters))
            {
                var gridFilters = serializer.Deserialize<GridFilterModel>(filters);
                var a = genarateCondition<T>(gridFilters, out gridRules);
                spf.WhereCondition = a;
                spf.QueryWhereCondition = "(" + gridRules.FirstOrDefault().sqlQueryExpression + ")";

            }
            else if (!string.IsNullOrEmpty(_additionalFilters))
            {
                var defaultFilters = serializer.Deserialize<GridFilterModel>(_additionalFilters);
                var b = genarateCondition<T>(defaultFilters, out gridRules);
                spf.WhereCondition = b;
                spf.QueryWhereCondition = "(" + gridRules.FirstOrDefault().sqlQueryExpression + ")";
            }
            spf.rules = gridRules;

            spf.QueryWhereCondition = spf.QueryWhereCondition == null ? null : spf.QueryWhereCondition.Replace("IS NULL ('')", " IS NULL ");
            spf.QueryWhereCondition = spf.QueryWhereCondition == null ? null : spf.QueryWhereCondition.Replace("IS NOT NULL '')", " IS NOT NULL ");
            return spf;
        }

        public static string genarateCondition<T>(GridFilterModel gridFilters,out List<GridRuleViewModel> resGridRule)
        {
            var gridRules = new List<GridRuleViewModel>();
            GridRuleViewModel gridRule = null;
            GridRuleModel outGridRule = null;
            var sb = new StringBuilder();
            var sqlQueryExpression = new StringBuilder();
            var rtRule = string.Empty;
            foreach (GridRuleModel rule in gridFilters.rules)
            {
                gridRule = new GridRuleViewModel();
                outGridRule = new GridRuleModel();
                if (rtRule.Length > 0)
                {
                    sb.Append(gridFilters.groupOp.ToLower() == "and" ? " and " : " or ");
                    sqlQueryExpression.Append(gridFilters.groupOp.ToLower() == "and" ? " and " : " or ");
                }
                rtRule = LinqDynamicConditionHelper.GetCondition<T>(rule, out outGridRule);
                if (rtRule.Length > 0)
                {
                    if (gridFilters.rules.Count > 1)
                    {
                        rtRule = "(" + rtRule + ")";
                        outGridRule.expression = "(" + outGridRule.expression + ")";
                    }
                    sb.Append(rtRule);
                    sqlQueryExpression.Append(outGridRule.expression);
                    gridRule.data = outGridRule.data;
                    gridRule.op = outGridRule.op;
                    gridRule.field = outGridRule.field;
                    gridRules.Add(gridRule);
                }
            }
            if (gridFilters.groups != null)
            {
                var rulesCount = gridFilters.groups.Sum(x => x.rules.Count());
                if (rulesCount > 0)
                {
                    var str = sb.ToString();
                    var strQry = sqlQueryExpression.ToString();
                    sb = new StringBuilder();
                    sqlQueryExpression = new StringBuilder();
                    sb.Append("(");
                    sb.Append(str);
                    sb.Append(")");
                    sqlQueryExpression.Append("(");
                    sqlQueryExpression.Append(strQry);
                    sqlQueryExpression.Append(")");
                    foreach (GridAdvanceFilterModel grp in gridFilters.groups)
                    {
                        sb.Append(grp.groupOp.ToLower() == "and" ? " and " : " or ");
                        sqlQueryExpression.Append(grp.groupOp.ToLower() == "and" ? " and " : " or ");
                        rtRule = string.Empty;
                        foreach (GridRuleModel rule in grp.rules)
                        {
                            if (rtRule.Length > 0)
                            {
                                sb.Append(grp.groupOp.ToLower() == "and" ? " and " : " or ");
                                sqlQueryExpression.Append(grp.groupOp.ToLower() == "and" ? " and " : " or ");
                            }
                            rtRule = LinqDynamicConditionHelper.GetCondition<T>(rule, out outGridRule);
                            if (rtRule.Length > 0)
                            {
                                sb.Append(rtRule);
                                sqlQueryExpression.Append(outGridRule.expression);
                            }
                        }
                    }
                }
            }
            var s = sb.ToString();
            sb = new StringBuilder();
            sb.Append("(");
            sb.Append(s);
            sb.Append(")");
            resGridRule = gridRules;
            if (resGridRule.Count > 0)
            {
                resGridRule[0].sqlQueryExpression = sqlQueryExpression.ToString();
            }
            return sb.ToString();
        }

        public static SortPaginateFilter ExportFormatSearchCondition<T>(string filters, string sortColumn, string sortOrder, string defaultFilters = "")
        {
            var spf = new SortPaginateFilter();
            var gridRules = new List<GridRuleViewModel>();

            var serializer = new JavaScriptSerializer();
            if (!string.IsNullOrEmpty(filters) && !string.IsNullOrEmpty(defaultFilters))
            {
                var gridFilters = serializer.Deserialize<GridFilterModel>(filters);
                var defaultFilter = serializer.Deserialize<GridFilterModel>(defaultFilters);
                var a = genarateCondition<T>(gridFilters,out gridRules);
                var b = genarateCondition<T>(defaultFilter,out gridRules);
                spf.WhereCondition = "(" + a + ") and " + b;
            }
            else if (!string.IsNullOrEmpty(filters))
            {
                var gridFilters = serializer.Deserialize<GridFilterModel>(filters);
                var a = genarateCondition<T>(gridFilters, out gridRules);
                spf.WhereCondition = a;
            }
            else if (!string.IsNullOrEmpty(defaultFilters))
            {
                var defaultFilter = serializer.Deserialize<GridFilterModel>(defaultFilters);
                var b = genarateCondition<T>(defaultFilter,out gridRules);
                spf.WhereCondition = b;
            }
            spf.SortOrder = sortOrder;
            spf.SortColumn = sortColumn;
            return spf;
        }

        public static SortPaginateFilter FormatSearchCondition<T>(IEnumerable<KeyValuePair<string, string>> pageState, bool isWebPortal=false, bool SerarchFilter = false)
        {
            var spf = new SortPaginateFilter();

            var gridParams = pageState;
            var page = gridParams.Where(x => x.Key == "page").FirstOrDefault().Value;
            var rows = Convert.ToInt32(gridParams.Where(x => x.Key == "rows").FirstOrDefault().Value);
            var sortColumn = gridParams.Where(x => x.Key == "sidx").FirstOrDefault().Value;
            var sortType = gridParams.Where(x => x.Key == "sord").FirstOrDefault().Value;
            var _search = Convert.ToBoolean(gridParams.Where(x => x.Key == "_search").FirstOrDefault().Value);
            var filters = "";
            if (_search && !SerarchFilter)
            {
                filters = gridParams.Where(x => x.Key == nameof(filters)).FirstOrDefault().Value;
            }
           if(SerarchFilter)//Asset Process Tab having mutiple grid issue
            { 
                filters = gridParams.Where(x => x.Key == "defaultFilters").FirstOrDefault().Value;
                _search = true;
            }


            var pageIndex = Convert.ToInt32(page) - 1;
            if (pageIndex < 0)
                pageIndex = 1;

            rows = (rows == 0) ? 10 : rows;
            var pageSize = rows;
            var sb = new StringBuilder();

            spf.Page = page;
            spf.Rows = rows;
            spf.SortColumn = sortColumn;
            spf.SortOrder = sortType;
            spf.Search = _search;
            spf.Filters = filters;
            spf.PageIndex = pageIndex;
            spf.PageSize = pageSize;

            if (_search && !isWebPortal)
            {
                var serializer = new JavaScriptSerializer();
                var gridFilters = serializer.Deserialize<GridFilterModel>(filters);
                var rtRule = string.Empty;
                var gridRule = new GridRuleModel();
                if (gridFilters != null)
                {
                    foreach (GridRuleModel rule in gridFilters.rules)
                    {
                        if (rtRule.Length > 0)
                        {
                            sb.Append(gridFilters.groupOp.ToLower() == "and" ? " and " : " or ");
                        }
                        rtRule = LinqDynamicConditionHelper.GetCondition<T>(rule, out gridRule);
                        if (rtRule.Length > 0)
                        {
                            sb.Append(rtRule);
                        }
                    }
                }
            }

            var whereCondition = sb.ToString();
            spf.WhereCondition = !string.IsNullOrWhiteSpace(whereCondition) ? "(" + whereCondition + ") " : whereCondition;

            if (!string.IsNullOrEmpty(sortType))
            {
                spf.SortColumn = sortColumn;
                spf.SortOrder = sortType;
            }

            return spf;
        }

        public static SortPaginateFilter FormatSearchCondition<T>(string filters, string sortColumn, string sortOrder)
        {
            var spf = new SortPaginateFilter();
            var sb = new StringBuilder();

            if (!string.IsNullOrEmpty(filters))
            {
                var serializer = new JavaScriptSerializer();
                var gridFilters = serializer.Deserialize<GridFilterModel>(filters);
                var rtRule = string.Empty;
                var gridRule = new GridRuleModel();
                foreach (GridRuleModel rule in gridFilters.rules)
                {
                    if (rtRule.Length > 0)
                    {
                        sb.Append(gridFilters.groupOp.ToLower() == "and" ? " and " : " or ");
                    }
                    rtRule = LinqDynamicConditionHelper.GetCondition<T>(rule,out gridRule);
                    if (rtRule.Length > 0)
                    {
                        sb.Append(rtRule);
                    }
                }
            }
            spf.SortOrder = sortOrder;
            spf.SortColumn = sortColumn;
            spf.WhereCondition = sb.ToString();
            return spf;
        }
    }
}
