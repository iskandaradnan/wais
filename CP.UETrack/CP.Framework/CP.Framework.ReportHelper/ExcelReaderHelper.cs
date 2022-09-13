using Excel;
using System;
using System.Data;
using System.IO;

namespace CP.Framework.ReportHelper
{
    public class ExcelReaderHelper
    {
        public const string Xls = ".xls";
        public const string Xlsx = ".xlsx";

        public static DataTable ReadExcelData(string excelPath, string extention, bool isFirstRowAsColumnNames, string sheetName)
        {
            try
            {
                if (!File.Exists(excelPath))
                {
                    throw new Exception(string.Format("File name: {0}", excelPath), new FileNotFoundException());
                }
                DataTable dt = null;
                using (var stream = File.Open(excelPath, FileMode.Open, FileAccess.Read, FileShare.ReadWrite))
                {
                    using (var excelReader = GetExcelDataReader(excelPath, extention, stream))
                    {
                        //1. DataSet - Create column names from first row
                        excelReader.IsFirstRowAsColumnNames = isFirstRowAsColumnNames;

                        //2. DataSet - The result of each spreadsheet will be created in the result.Tables
                        dt = excelReader.AsDataSet().Tables[sheetName];

                        excelReader.Close();
                    }
                    stream.Close();
                }
                return dt;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

         static IExcelDataReader GetExcelDataReader(string excelPath, string extention, FileStream stream)
        {
            try
            {
                IExcelDataReader excelReader;
                if (extention.ToLower() == Xls.ToLower())
                {
                    //1. Reading from a binary Excel file ('97-2003 format; *.xls)
                    excelReader = ExcelReaderFactory.CreateBinaryReader(stream);
                }
                else if (extention.ToLower() == Xlsx.ToLower())
                {
                    //2. Reading from a OpenXml Excel file (2007 format; *.xlsx)
                    excelReader = ExcelReaderFactory.CreateOpenXmlReader(stream);
                }
                else
                {
                    throw new Exception(string.Format("Extension is not valid for the filename : {0}", excelPath), new FileLoadException());
                }
                return excelReader;
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }
                
    }
}
