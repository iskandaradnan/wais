using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using CP.UETrack.Application.Web.ViewModel;
using System.Globalization;

namespace CP.UETrack.Application.Web.Helper
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

        public static string GetCondition<T>(GridRuleModel rule)
        {
            //if (rule.data == "%")
            //{
            //    // returns an empty string when the data is ‘%’  
            //    return "";
            //}
            //else
            //{
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
                myTypeName = myType.Name;// + "?";
                myTypeRawName = myType.Name;
            }
            // creating the condition expression  
            if (ValidOperators[myTypeRawName].Contains(rule.op + ":"))
            {
                if (myTypeRawName == "Int32" && rule.data == "")
                {
                    rule.data = "0";
                }
                var formatedData = GetFormattedData(myType, rule.data);

                var expression = !string.IsNullOrEmpty(formatedData) ? String.Format(WhereOperation[rule.op],
                                                 formatedData,
                                                  "@" + rule.field,
                                                  myTypeName):string.Empty;
                //var expression = "";
                //if (rule.op == "eq")
                //{
                //    expression=expression1+" and "+ (!string.IsNullOrEmpty(formatedData) ? String.Format(WhereOperation[rule.op == "eq" ? "le" : rule.op],
                //                                 formatedData,
                //                                  "@" + rule.field,
                //                                  myTypeName) : string.Empty);
                //}
                return expression;
            }
            else
            {
                // un-supported operator  
                return "";
            }
            //}
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
            }
            return value;
        }
    }
}
