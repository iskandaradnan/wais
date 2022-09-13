using System;
using System.Collections.Generic;
using System.Reflection;
using System.Globalization;
using UETrack.Application.Web.API.Models;
using CP.UETrack.Model;

namespace CP.UETrack.Application.Web.API.Helpers
{
    public static class LinqDynamicConditionHelper
    {
        private static Dictionary<string, string> WhereOperation =
                new Dictionary<string, string>
                {
                    { "eq", "{1} = {2}({0})" },
                    { "ne", "{1} != {2}({0})" },
                    { "lt", "{1} < {2}({0})" },
                    { "le", "{1} <= {2}({0})" },
                    { "gt", "{1} > {2}({0})" },
                    { "ge", "{1} >= {2}({0})" },
                    { "bw", "{1}.StartsWith({2}({0}))" },
                    { "bn", "!{1}.StartsWith({2}({0}))" },
                    { "in", "{1}.Equals({2}({0}))" },
                    { "ni", "!{1}.Equals({2}({0}))" },
                    { "ew", "{1}.EndsWith({2}({0}))" },
                    { "en", "!{1}.EndsWith({2}({0}))" },
                    { "cn", "{1}.Contains({2}({0}))" },
                    { "nc", "!{1}.Contains({2}({0}))" },
                    { "nu", "{1} = {2}(null) or {1} = {2}({0})" },
                    { "nn", "{1} != {2}(null) and {1} != {2}({0})" }
                };

        private static Dictionary<string, string> ValidOperators =
                new Dictionary<string, string>
                {
                    { "Object"   ,  "" },
                    { "Boolean"  ,  "eq:ne:lt:le:gt:ge:bw:bn:in:ni:ew:en:cn:nc:nu:nn:" },
                    { "Char"     ,  "" },
                    { "String"   ,  "eq:ne:lt:le:gt:ge:bw:bn:in:ni:ew:en:cn:nc:nu:nn:" },
                    { "SByte"    ,  "" },
                    { "Byte"     ,  "eq:ne:lt:le:gt:ge:bw:bn:in:ni:ew:en:cn:nc:nu:nn:" },
                    { "Int16"    ,  "eq:ne:lt:le:gt:ge:bw:bn:in:ni:ew:en:cn:nc:nu:nn:" },
                    { "UInt16"   ,  "" },
                    { "Int32"    ,  "eq:ne:lt:le:gt:ge:bw:bn:in:ni:ew:en:cn:nc:nu:nn:" },
                    { "UInt32"   ,  "" },
                    { "Int64"    ,  "eq:ne:lt:le:gt:ge:bw:bn:in:ni:ew:en:cn:nc:nu:nn:" },
                    { "UInt64"   ,  "" },
                    { "Decimal"  ,  "eq:ne:lt:le:gt:ge:bw:bn:in:ni:ew:en:cn:nc:nu:nn:" },
                    { "Single"   ,  "eq:ne:lt:le:gt:ge:bw:bn:in:ni:ew:en:cn:nc:nu:nn:" },
                    { "Double"   ,  "eq:ne:lt:le:gt:ge:bw:bn:in:ni:ew:en:cn:nc:nu:nn:" },
                    { "DateTime" ,  "eq:ne:lt:le:gt:ge:bw:bn:in:ni:ew:en:cn:nc:nu:nn:" },
                    { "TimeSpan" ,  "" },
                    { "Guid"     ,  "" }
                };
        private static Dictionary<string, string> WhereOperator =
               new Dictionary<string, string>
               {
                    { "eq", "=" },
                    { "ne", "!=" },
                    { "lt", "<" },
                    { "le", "<=" },
                    { "gt", ">" },
                    { "ge", ">=" },
                    { "bw", "LIKE" },
                    { "bn", "NOT LIKE" },
                    { "in", "=" },
                    { "ni", "!=" },
                    { "ew", "LIKE" },
                    { "en", "NOT LIKE" },
                    { "cn", "LIKE" },
                    { "nc", "NOT LIKE" },
                    { "nu", "IS NULL" },
                    { "nn", "IS NOT NULL" }
               };
        private static Dictionary<string, string> QueryWhereCondition =
              new Dictionary<string, string>
              {
                    { "eq", "[{1}] = ('{0}')" },
                    { "ne", "[{1}] != ('{0}')" },
                    { "lt", "[{1}] < ('{0}')" },
                    { "le", "[{1}] <= ('{0}')" },
                    { "gt", "[{1}] > ('{0}')" },
                    { "ge", "[{1}] >= ('{0}')" },
                    { "bw", "[{1}] LIKE ('{0}%')" },
                    { "bn", "[{1}] NOT LIKE ('{0}%')" },
                    { "in", "[{1}] = ('{0}')" },
                    { "ni", "[{1}] != ('{0}')" },
                    { "ew", "[{1}] LIKE ('%{0}')" },
                    { "en", "[{1}] NOT LIKE ('%{0}')" },
                    { "cn", "[{1}] LIKE ('%{0}%')" },
                    { "nc", "[{1}] NOT LIKE ('%{0}%')" },
                    { "nu", "[{1}] IS NULL ('{0}')" },
                    { "nn", "[{1}] IS NOT NULL '{0}')" }

              };
        public static string GetCondition<T>(GridRuleModel rule, out GridRuleModel gridRule)
        {
            // initializing variables  

            Type myType = null;
            var myTypeName = string.Empty;
            var myTypeRawName = string.Empty;
            var myPropInfo = typeof(T).GetProperty(rule.field.Split('.')[0]);
            var index = 0;
            // navigating fields hierarchy  
            foreach (string wrkField in rule.field.Split('.'))
            {
                if (index > 0)
                {
                    myPropInfo = myPropInfo.PropertyType.GetProperty(wrkField);
                }
                index++;
            }
            // property type and its name  
            myType = myPropInfo.PropertyType;
            myTypeName = myPropInfo.PropertyType.Name;
            myTypeRawName = myTypeName;
            // handling ‘nullable’ fields  
            if (myTypeName.ToLower() == "nullable`1")
            {
                myType = Nullable.GetUnderlyingType(myPropInfo.PropertyType);
                myTypeName = myType.Name;
                myTypeRawName = myType.Name;
            }
            // creating the condition expression  
            if (ValidOperators[myTypeRawName].Contains(rule.op + ":"))
            {
                if (myTypeRawName == "Int32" && rule.data == "")
                {
                    rule.data = "0";
                }
                else if (myTypeRawName == "Decimal" && rule.data == "")
                {
                    rule.data = "0";
                }
                else if (myTypeRawName == "DateTime" && rule.data == "")
                {
                    rule.data = default(DateTime).ToString("dd/MMM/yyyy");
                }
                var formatedData = GetFormattedData(myType, rule.data);
                var qryFormatedData = GetQueryFormattedData(myType, rule.data);

                var expression = !string.IsNullOrEmpty(formatedData) ? String.Format(WhereOperation[rule.op],
                                                 formatedData,
                                                  "@" + rule.field,
                                                  myTypeName) : string.Empty;

                var sqlExpression = !string.IsNullOrEmpty(formatedData) ? String.Format(QueryWhereCondition[rule.op],
                                                 qryFormatedData,
                                                  rule.field,
                                                  myTypeName) : string.Empty;
                gridRule = new GridRuleModel
                {
                    data = formatedData.Replace("\"", ""),
                    field = rule.field,
                    op = WhereOperator[rule.op],
                    expression = sqlExpression
                };
                return expression;
            }
            else
            {
                gridRule = null;
                // un-supported operator  
                return "";
            }
        }

        private static string GetFormattedData(Type type, string value)
        {
            switch (type.Name.ToLower())
            {
                case "string":
                    value = @"""" + value + @"""";
                    break;
                case "datetime":
                    DateTime dt;
                    if (DateTime.TryParseExact(value, "dd/MMM/yyyy", CultureInfo.InvariantCulture, DateTimeStyles.None, out dt))
                    {
                        value = dt.Year.ToString() + "," +
                            dt.Month.ToString() + "," +
                            dt.Day.ToString();
                    }
                    else if (DateTime.TryParseExact(value, "dd-MMM-yyyy", CultureInfo.InvariantCulture, DateTimeStyles.None, out dt))
                    {
                        value = dt.Year.ToString() + "," +
                            dt.Month.ToString() + "," +
                            dt.Day.ToString();
                    }
                    else if (DateTime.TryParseExact(value, "dd-MMM-yyyy HH:mm", CultureInfo.InvariantCulture, DateTimeStyles.None, out dt))
                    {
                        value = dt.Year.ToString() + "," +
                            dt.Month.ToString() + "," +
                            dt.Day.ToString() + "," +
                            dt.Hour.ToString() + "," +
                            dt.Minute.ToString() + "," +
                            dt.Second.ToString();
                    }
                    else
                    {
                        value = null;
                    }
                    break;
                case "int":

                    int output;
                    if (int.TryParse(value, out output))
                    {
                        value = output.ToString();
                    }
                    else
                    {
                        value = null;
                    }
                    break;
                case "int32":

                    int int32Output;
                    if (int.TryParse(value, out int32Output))
                    {
                        value = int32Output.ToString();
                    }
                    else
                    {
                        value = "0";
                    }
                    break;
                case "decimal":

                    decimal decimalOutput;
                    if (decimal.TryParse(value, out decimalOutput))
                    {
                        value = decimalOutput.ToString();
                    }
                    else
                    {
                        value = "0";
                    }
                    break;
            }
            return value;
        }
        private static string GetQueryFormattedData(Type type, string value)
        {
            switch (type.Name.ToLower())
            {
                case "string":
                    //value = value;
                    break;
                case "datetime":
                    DateTime dt;
                    if (DateTime.TryParseExact(value, "dd/MMM/yyyy", CultureInfo.InvariantCulture, DateTimeStyles.None, out dt))
                    {
                        value = dt.Year.ToString() + "-" +
                            dt.Month.ToString() + "-" +
                            dt.Day.ToString();
                    }
                    else if (DateTime.TryParseExact(value, "dd-MMM-yyyy", CultureInfo.InvariantCulture, DateTimeStyles.None, out dt))
                    {
                        value = dt.Year.ToString() + "-" +
                            dt.Month.ToString() + "-" +
                            dt.Day.ToString();
                    }
                    else if (DateTime.TryParseExact(value, "dd-MMM-yyyy HH:mm", CultureInfo.InvariantCulture, DateTimeStyles.None, out dt))
                    {
                        value = dt.Year.ToString() + "-" +
                            dt.Month.ToString() + "-" +
                            dt.Day.ToString() + " " +
                            dt.Hour.ToString() + ":" +
                            dt.Minute.ToString() + ":" +
                            dt.Second.ToString();
                    }
                    else
                    {
                        value = null;
                    }
                    break;
                case "int":

                    int output;
                    if (int.TryParse(value, out output))
                    {
                        value = output.ToString();
                    }
                    else
                    {
                        value = null;
                    }
                    break;
                case "int32":

                    int int32Output;
                    if (int.TryParse(value, out int32Output))
                    {
                        value = int32Output.ToString();
                    }
                    else
                    {
                        value = "0";
                    }
                    break;
                case "decimal":

                    decimal decimalOutput;
                    if (decimal.TryParse(value, out decimalOutput))
                    {
                        value = decimalOutput.ToString();
                    }
                    else
                    {
                        value = "0";
                    }
                    break;
            }
            return value;
        }

    }

}
