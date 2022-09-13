using System;
using System.Net.Mail;

namespace CP.Framework.Common.Validator
{
    public class DataValidator
    {
        public enum DataType
        {
            Integer,
            Decimal,
            Phone,
            Email,            
            Url,
            IP
        }

        internal DataValidator()
        {

        }

        public static bool IsValid(DataType T, object value)
        {
            switch (T)
            {
                case DataType.Integer: return IsValidInteger(value);
                    
                case DataType.Decimal: return IsValidDecimal(value);

                case DataType.Email: return IsValidEmailId(value.ToString());

                case DataType.Url: return IsValidUrl(value.ToString());

                default:
                    return false;
            }

        }

        public static bool IsValidUrl(string Url)
        {
            return Uri.IsWellFormedUriString(Url, UriKind.RelativeOrAbsolute);
        }

        public static bool IsValidUrl(string Url, UriKind uriKind)
        {
            return Uri.IsWellFormedUriString(Url, uriKind);            
        }

        public static bool IsValidEmailId(string emailId)
        {            
            try
            {
                var m = new MailAddress(emailId);

                return true;
            }
            catch (FormatException)
            {
                return false;
            }
         
        }

        public static bool IsValidInteger(object valueToValidate)
        {
            int i = 0;
            var validValue = int.TryParse(valueToValidate.ToString(), out i);
            return validValue;

        }

        public static bool IsValidLong(object valueToValidate)
        {
            long l = 0;
            var validValue = long.TryParse(valueToValidate.ToString(), out l);
            return validValue;

        }

        public static bool IsValidDecimal(object valueToValidate)
        {
            decimal d = 0;
            var validValue = decimal.TryParse(valueToValidate.ToString(), out d);
            return validValue;
        }

        public static bool IsInRange(int valueToValidate, int validMinInclusive, int validMaxInclusive)
        {
            return valueToValidate >= validMinInclusive && valueToValidate <= validMaxInclusive;
        }

        public static bool IsInRange(decimal valueToValidate, decimal validMinInclusive, decimal validMaxInclusive)
        {
            return valueToValidate >= validMinInclusive && valueToValidate <= validMaxInclusive;
        }

        public static bool IsInRange(double valueToValidate, double validMinInclusive, double validMaxInclusive)
        {
            return valueToValidate >= validMinInclusive && valueToValidate <= validMaxInclusive;
        }

        //Date, DateTime, Time
    }
}
