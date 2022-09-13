using System;
using System.ComponentModel;
using System.Data;

namespace CP.Framework.ReportHelper
{
    public static class DbToCsTypeHelper
    {
        public static Type GetCsDataType(SqlDbType sqlType)
        {
            switch (sqlType)
            {
                case SqlDbType.BigInt:
                    return typeof(long?);

                case SqlDbType.Binary:
                case SqlDbType.Image:
                case SqlDbType.Timestamp:
                case SqlDbType.VarBinary:
                    return typeof(byte[]);

                case SqlDbType.Bit:
                    return typeof(bool?);

                case SqlDbType.Char:
                case SqlDbType.NChar:
                case SqlDbType.NText:
                case SqlDbType.NVarChar:
                case SqlDbType.Text:
                case SqlDbType.VarChar:
                case SqlDbType.Xml:
                    return typeof(string);

                case SqlDbType.DateTime:
                case SqlDbType.SmallDateTime:
                case SqlDbType.Date:
                case SqlDbType.Time:
                case SqlDbType.DateTime2:
                    return typeof(DateTime?);

                case SqlDbType.Decimal:
                case SqlDbType.Money:
                case SqlDbType.SmallMoney:
                    return typeof(decimal?);

                case SqlDbType.Float:
                    return typeof(double?);

                case SqlDbType.Int:
                    return typeof(int?);

                case SqlDbType.Real:
                    return typeof(float?);

                case SqlDbType.UniqueIdentifier:
                    return typeof(Guid?);

                case SqlDbType.SmallInt:
                    return typeof(short?);

                case SqlDbType.TinyInt:
                    return typeof(byte?);

                case SqlDbType.Variant:
                case SqlDbType.Udt:
                    return typeof(object);

                case SqlDbType.Structured:
                    return typeof(DataTable);

                case SqlDbType.DateTimeOffset:
                    return typeof(DateTimeOffset?);

                default:
                    throw new ArgumentOutOfRangeException("sqlType in DbToCsTypeHelper.");
            }
        }

        public static object ConvertToCs(string value, Type type)
        {
            object result = null;
            try
            {
                if (string.IsNullOrWhiteSpace(value))
                {
                    return null;
                }
                try
                {
                    var converter = TypeDescriptor.GetConverter(type);
                    result = converter.ConvertFromString(value);
                }
                catch (Exception ex)
                {
                    throw ex;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return result;
        }
    }
}
