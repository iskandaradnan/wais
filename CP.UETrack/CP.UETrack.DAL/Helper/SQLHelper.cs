using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity.Core.Objects;
using System.Data.SqlClient;
using System.Linq;

namespace CP.UETrack.DAL.DataAccess
{
    public class SQLHelper
    {
        private static string _connectionString;

        static SQLHelper()
        {
            var fullConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["ASISWebDatabaseEntities"].ConnectionString;
            _connectionString = fullConnectionString.Substring(fullConnectionString.IndexOf("data source", System.StringComparison.CurrentCultureIgnoreCase));
            _connectionString = _connectionString.Substring(0, _connectionString.Length - 1);
        }

        public static DataSet ExecuteSqlQuery(string sqlQuery)
        {
            var queryResult = new DataSet();
            SqlConnection sqlcon = new SqlConnection(_connectionString);
            SqlDataAdapter dataAdapter = new SqlDataAdapter(sqlQuery, sqlcon);
            dataAdapter.Fill(queryResult);

            return queryResult;
        }

        public static void ExecuteNonQuery(string sqlQuery)
        {
            using (SqlConnection sqlcon = new SqlConnection(_connectionString))
            {
                sqlcon.Open();
                SqlCommand cmd = new SqlCommand(sqlQuery, sqlcon);
                cmd.ExecuteNonQuery();
            }
        }

        public static object ExecuteScaler(string sqlQuery)
        {
            using (SqlConnection sqlcon = new SqlConnection(_connectionString))
            {
                sqlcon.Open();
                SqlCommand cmd = new SqlCommand(sqlQuery, sqlcon);
                return cmd.ExecuteScalar();
            }
        }

        public static object ExecuteNonQuery(SqlCommand sqlCommand)
        {
            using (SqlConnection sqlcon = new SqlConnection(_connectionString))
            {
                sqlcon.Open();
                sqlCommand.Connection = sqlcon;
                return sqlCommand.ExecuteNonQuery();
            }
        }
    }

    public static class Utility
    {
        /// <summary>
        /// Function: ToList
        /// Converts ObjectResult to Generic List
        /// </summary>
        /// <typeparam name="T1"></typeparam>
        /// <typeparam name="T2"></typeparam>
        /// <param name="Source"></param>
        /// <param name="Destination"></param>
        public static void ToList<T1, T2>(ObjectResult<T1> Source, List<T2> Destination) where T2 : new()
        {
            Destination.AddRange(Source.Select(CreateMapping<T1, T2>()));
        }

        /// <summary>
        /// CreateMapping
        /// Creates the mapping
        /// </summary>
        /// <typeparam name="T1"></typeparam>
        /// <typeparam name="T2"></typeparam>
        /// <returns></returns>
        private static Func<T1, T2> CreateMapping<T1, T2>() where T2 : new()
        {
            var typeOfSource = typeof(T1);
            var typeOfDestination = typeof(T2);

            // use reflection to get a list of the properties on the source and destination types
            var sourceProperties = typeOfSource.GetProperties();
            var destinationProperties = typeOfDestination.GetProperties();

            // join the source properties with the destination properties based on name
            var properties = from sourceProperty in sourceProperties
                             join destinationProperty in destinationProperties
                             on sourceProperty.Name.ToUpper() equals destinationProperty.Name.ToUpper()
                             select new { SourceProperty = sourceProperty, DestinationProperty = destinationProperty };


            return (x) =>
            {
                var y = new T2();

                foreach (var property in properties)
                {
                    var value = property.SourceProperty.GetValue(x, null);
                    property.DestinationProperty.SetValue(y, value, null);
                }

                return y;
            };
        }
    }
}

