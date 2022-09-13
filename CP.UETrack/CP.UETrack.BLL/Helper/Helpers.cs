using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq.Expressions;
using System.Reflection;
using System.Text.RegularExpressions;
using FluentValidation;
using FluentValidation.Results;

namespace CP.UETrack.BLL
{
    public static class Helpers
    {
        //TODO Constants needs to be moved to resource file
        public const string noDataString = "unavailable";

        public static string MergeSpaces(this string value)
        {
            value = Regex.Replace(value.Trim(), @"\s+", " ");
            return value.Trim();
        }

        public static byte[] ToBinaryStream(this string fileData)
        {
            return System.Text.Encoding.UTF8.GetBytes(fileData);
        }

        public static Expression<Func<TTo, bool>> Convert<TFrom, TTo>(this Expression<Func<TFrom, bool>> from)
        {
            return ConvertImpl<Func<TFrom, bool>, Func<TTo, bool>>(from);
        }

        private static Expression<TTo> ConvertImpl<TFrom, TTo>(Expression<TFrom> from)
            where TFrom : class
            where TTo : class
        {
            // figure out which types are different in the function-signature
            var fromTypes = from.Type.GetGenericArguments();
            var toTypes = typeof(TTo).GetGenericArguments();
            if (fromTypes.Length != toTypes.Length)
                throw new NotSupportedException(
                    "Incompatible lambda function-type signatures");
            Dictionary<Type, Type> typeMap = new Dictionary<Type, Type>();
            for (int i = 0; i < fromTypes.Length; i++)
            {
                if (fromTypes[i] != toTypes[i])
                    typeMap[fromTypes[i]] = toTypes[i];
            }

            // re-map all parameters that involve different types
            Dictionary<Expression, Expression> parameterMap
                = new Dictionary<Expression, Expression>();
            ParameterExpression[] newParams =
                new ParameterExpression[from.Parameters.Count];
            for (int i = 0; i < newParams.Length; i++)
            {
                Type newType;
                if (typeMap.TryGetValue(from.Parameters[i].Type, out newType))
                {
                    parameterMap[from.Parameters[i]] = newParams[i] =
                        Expression.Parameter(newType, from.Parameters[i].Name);
                }
                else
                {
                    newParams[i] = from.Parameters[i];
                }
            }

            // rebuild the lambda
            var body = new TypeConversionVisitor(parameterMap).Visit(from.Body);
            return Expression.Lambda<TTo>(body, newParams);
        }

        /// <summary>
        /// This method help in mapping the return data from store procedure into model.
        /// Model and return type should have the name and type for below method to work.
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="dr"></param>
        /// <returns></returns>
        public static List<T> AutoMap<T>(IDataReader dr) where T : new()
        {
            Type businessEntityType = typeof(T);
            List<T> entitys = new List<T>();
            Hashtable hashtable = new Hashtable();
            PropertyInfo[] properties = businessEntityType.GetProperties();
            foreach (PropertyInfo info in properties)
            {
                hashtable[info.Name.ToUpper()] = info;
            }
            while (dr.Read())
            {
                T newObject = new T();
                for (int index = 0; index < dr.FieldCount; index++)
                {
                    PropertyInfo info = (PropertyInfo)
                                        hashtable[dr.GetName(index).ToUpper()];
                    if ((info != null) && info.CanWrite)
                    {
                        object value = dr.GetValue(index);
                        if (value == DBNull.Value)
                            value = null;
                        info.SetValue(newObject, value, null);
                    }
                }
                entitys.Add(newObject);
            }
            dr.Close();
            return entitys;
        }

        /// <summary>
        /// This method converts the nullable float number into pounds format 
        /// </summary>
        /// <param name="price"></param>
        /// <returns></returns>
        public static string ToPounds(this float? price)
        {
            var c = new CultureInfo("en-GB");
            if (price.HasValue)
            {
                //if (price != 0)
                return price.Value.ToString("c", c);
                //else
                //    return noDataString;
            }
            else
            {
                return noDataString;

            }
        }

        /// <summary>
        /// This method converts the nullable decimal number into pounds format 
        /// </summary>
        /// <param name="price"></param>
        /// <returns></returns>
        public static string ToPounds(this decimal? price)
        {
            var c = new CultureInfo("en-GB");
            if (price.HasValue)
            {
                //if (price != 0)
                return price.Value.ToString("c", c);
                //else
                //    return noDataString;
            }
            else
            {
                return noDataString;
            }
        }

        /// <summary>
        /// This method converts the decimal number into pounds format
        /// </summary>
        /// <param name="price"></param>
        /// <returns></returns>
        public static string ToPounds(this decimal price)
        {
            var c = new CultureInfo("en-GB");
            return price.ToString("c", c);
        }

        /// <summary>
        /// This method converts the decimal number into pounds format
        /// </summary>
        /// <param name="price"></param>
        /// <returns></returns>
        public static string ToPounds(this string price)
        {
            var c = new CultureInfo("en-GB");
            return price.ToString(c);
        }

        /// <summary>
        /// This method helps in retrieving the images
        /// </summary>
        /// <param name="ImageID"></param>
        /// <param name="url"></param>
        /// <returns></returns>
        public static string ToVehicleImagePath(this int? ImageID, string url)
        {
            string str = "999999";
            if (ImageID.HasValue)
                str = ImageID.ToString();
            return string.Format("{0}{1}.jpg", (object)url, (object)str);
        }

        public static List<ValidationFailure> GetFirstErrorMessage(ValidationException ex)
        {
            var abc = (List<FluentValidation.Results.ValidationFailure>)ex.Errors;
            var abc1 = new List<FluentValidation.Results.ValidationFailure>();
            abc1.Add(abc[0]);
            return abc1; 
        }

    }
}
