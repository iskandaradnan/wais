//using Excel;
using System;
using System.Data;
using System.IO;


namespace UETrack.Application.Web.Helpers
{
    public class ExcelDataReader
    {
        //public static List<TestCaseData> ReadCsvData(string csvFile, string cmdText = "SELECT * FROM [{0}]")
        //{
        //    if (!File.Exists(csvFile))
        //        throw new Exception(string.Format("File name: {0}", csvFile), new FileNotFoundException());
        //    var file = Path.GetFileName(csvFile);
        //    var pathOnly = Path.GetFullPath(csvFile).Replace(file, "");
        //    var tableName = string.Format("{0}#{1}", Path.GetFileNameWithoutExtension(file), Path.GetExtension(file).Remove(0, 1));

        //    cmdText = string.Format(cmdText, tableName);
        //    var connectionStr = string.Format("Provider=Microsoft.ACE.OLEDB.12.0;Data Source={0};Extended Properties=\"Text;HDR=Yes\"", pathOnly);
        //    var ret = new List<TestCaseData>();
        //    using (var connection = new OleDbConnection())
        //    {
        //        connection.ConnectionString = connectionStr;
        //        connection.Open();

        //        var cmd = connection.CreateCommand();
        //        cmd.CommandText = cmdText;
        //        var reader = cmd.ExecuteReader();

        //        if (reader == null)
        //            throw new Exception(string.Format("No data return from file, file name:{0}", csvFile));
        //        while (reader.Read())
        //        {
        //            var row = new List<string>();
        //            var feildCnt = reader.FieldCount;
        //            for (var i = 0; i < feildCnt; i++)
        //                row.Add(reader.GetValue(i).ToString());
        //            ret.Add(new TestCaseData(row.ToArray()));
        //        }
        //    }
        //    return ret;
        //}

        //public static List<TestCaseData> ReadExcelData(string excelFile, string cmdText = "SELECT * FROM [Sheet1$]")
        //{
        //    if (!File.Exists(excelFile))
        //        throw new Exception(string.Format("File name: {0}", excelFile), new FileNotFoundException());
        //    var connectionStr = string.Format("Provider=Microsoft.ACE.OLEDB.12.0;Data Source={0};Extended Properties=\"Excel 12.0 Xml;HDR=YES\";", excelFile);
        //    var ret = new List<TestCaseData>();
        //    using (var connection = new OleDbConnection(connectionStr))
        //    {
        //        connection.Open();
        //        using (var command = new OleDbCommand(cmdText, connection))
        //        {
        //            var reader = command.ExecuteReader();
        //            if (reader == null)
        //                throw new Exception(string.Format("No data return from file, file name:{0}", excelFile));
        //            while (reader.Read())
        //            {
        //                var row = new List<string>();
        //                var feildCnt = reader.FieldCount;
        //                for (var i = 0; i < feildCnt; i++)
        //                    row.Add(reader.GetValue(i).ToString());
        //                ret.Add(new TestCaseData(row.ToArray()));
        //            }
        //        }
        //    }
        //    return ret;
        //}

        //public static DataTable ReadExcelData(string excelFile, string extention, bool isFirstRowAsColumnNames, string SheetName)
        //{
        //    if (!File.Exists(excelFile))
        //        throw new Exception(string.Format("File name: {0}", excelFile), new FileNotFoundException());

        //    DataTable _result;
        //    using (var stream = File.Open(excelFile, FileMode.Open, FileAccess.Read, FileShare.ReadWrite))
        //    {
        //        using (var excelReader = GetExcelDataReader(excelFile, extention, stream))
        //        {
        //            //3. DataSet - Create column names from first row
        //            excelReader.IsFirstRowAsColumnNames = isFirstRowAsColumnNames;
                    
        //            //4. DataSet - The result of each spreadsheet will be created in the result.Tables
        //            _result = excelReader.AsDataSet().Tables[SheetName];

        //            excelReader.Close();
        //        }
        //        stream.Close();
        //    }
        //    return _result;
        //}

        //private static IExcelDataReader GetExcelDataReader(string excelFile, string extention, FileStream stream)
        //{
        //    IExcelDataReader excelReader;
        //    if (extention.ToLower() == "xls")
        //    {
        //        //1. Reading from a binary Excel file ('97-2003 format; *.xls)
            //    excelReader = ExcelReaderFactory.CreateBinaryReader(stream);
            //}
            //else if (extention.ToLower() == "xlsx")
            //{
            //    //2. Reading from a OpenXml Excel file (2007 format; *.xlsx)
            //    excelReader = ExcelReaderFactory.CreateOpenXmlReader(stream);
            //}
            //else
            //{
            //    throw new Exception(string.Format("Extension is not valid for the filename : {0}", excelFile), new FileLoadException());
            //}

            //return excelReader;
    //    }
    }
}