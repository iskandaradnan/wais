using iTextSharp.text;
using iTextSharp.text.pdf;
using OfficeOpenXml;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Reflection;
using System.Text;

namespace CP.UETrack.Application.Web.Helper
{
    public class ExportHelper
    {

        /// <summary>
        /// /
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="data"></param>
        /// <param name="exportType"></param>
        /// <param name="gridColumnNames"></param>
        /// <param name="headerColumnNames"></param>
        /// <param name="screenName"></param>
        /// <returns></returns>
        public static HttpResponseMessage Export<T>(dynamic data, string exportType, List<string> gridColumnNames, List<string> headerColumnNames, string screenName = "Screen_Name")
        {
            switch (exportType)
            {

                case "EXCEL":
                    {
                        return ExcelExport<T>(data, gridColumnNames, headerColumnNames, screenName);
                    }
                case "PDF":
                    {
                        return PdfExport<T>(data, gridColumnNames, headerColumnNames, screenName);
                    }
                case "CSV":
                    {
                        return CsvExport<T>(data, gridColumnNames, headerColumnNames, screenName);
                    }
                default:
                    {
                        return ExcelExport<T>(data, gridColumnNames, headerColumnNames, screenName);
                    }
            }

        }

        /// <summary>
        /// Exports data to Excel
        /// </summary>
        /// <typeparam name="T">Entity Name</typeparam>
        /// <param name="data">Export data</param>
        /// <param name="gridColumnNames">Grid columns</param>
        /// <param name="headerColumnNames">HeaderName columns</param>
        ///  /// <param name="screenName">HeaderName columns</param>
        /// <returns>HttpResponseMessage</returns>
        public static HttpResponseMessage ExcelExport<T>(dynamic data, List<string> gridColumnNames, List<string> headerColumnNames, string screenName = "")
        {

            var sb = new StringBuilder();
            var table = new DataTable();

            if (string.Equals(typeof(T).Name, "DataTable", StringComparison.InvariantCultureIgnoreCase))
            {
                table = data;
            }
            else
            {
                table = ToDataTable<T>(data, gridColumnNames);
            }            
            // var headerValues = table.Columns.OfType<DataColumn>().Select(column => QuoteValue(column.ColumnName));

            sb.Append("<table border='1px' cellpadding='1' cellspacing='1'>");
            sb.Append("<tr>");

            foreach (string _title in headerColumnNames)
            {
                var _data = _title.TrimStart('"');
                _data = _data.TrimEnd('"');
                sb.Append("<td align=\"center\">");
                sb.Append(_data);
                sb.Append("</td>");
            }
            sb.Append("</tr>");

            foreach (DataRow myRow in table.Rows)
            {
                sb.Append("<tr>");
                foreach (string ColumnData in myRow.ItemArray.Select(o => QuoteValue(o.ToString())))
                {
                    var _data = ColumnData.TrimStart('"');
                    _data = _data.TrimEnd('"');
                    sb.Append("<td align=\"left\">");
                    sb.Append(_data);
                    sb.Append("</td>");
                }
                sb.Append("</tr>");
            }
            sb.Append("</table>");

            table.Dispose(); 

            var byteArray = Encoding.UTF8.GetBytes(sb.ToString());

            sb = null;
            var stream = new MemoryStream(byteArray);
            var responseObject = new HttpResponseMessage();

            responseObject.Headers.AcceptRanges.Add("bytes");
            responseObject.Content = new StreamContent(stream);
            responseObject.Content.Headers.ContentType = new MediaTypeHeaderValue("application/vnd.ms-excel");
            responseObject.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment")
            {
                FileName = screenName + "_" + DateTime.Now.ToString("dd_MMM_yyyy") + ".xls"
            };

            return (responseObject);
        }

        public static HttpResponseMessage ExportToExcel1<T>(dynamic data, List<string> gridColumnNames)
        {
            string DownloadPath = Convert.ToString(System.Configuration.ConfigurationManager.AppSettings["DownLoadPath"]);
            var fileInfo = new FileInfo(DownloadPath + "\\" +
                               DateTime.Now.Ticks + ".csv");


            var table = new DataTable();
            if (string.Equals(typeof(T).Name, "DataTable", StringComparison.InvariantCultureIgnoreCase))
            {
                table = data;
            }
            else
            {
                table = ToDataTable<T>(data, gridColumnNames);
            }
            //using (var xls = new ExcelPackage(fileInfo))
            //{
            //    var sheet = xls.Workbook.Worksheets.Add("Sheet1");
            //    var i = 1;

            //    for (i = 1; i <= gridColumnNames.Count; i++)
            //    {
            //        sheet.Cell(1, i).Value = gridColumnNames[i - 1].ToString();

            //        var DataColumn = gridColumnNames[i - 1].ToString();
            //        var RowIndex = 2;
            //        foreach (DataRow dr in table.Rows)
            //        {

            //            sheet.Cell(RowIndex, i).Value = dr[DataColumn].ToString();
            //            RowIndex++;
            //        }
            //    }
            //    xls.Save();
            //    xls.Dispose();

            //}
            table.Dispose();
            var byteArray = Encoding.UTF8.GetBytes(table.ToString());
            using (var stream = new MemoryStream(byteArray))
            {
                var responseObject = new HttpResponseMessage();

                responseObject.Headers.AcceptRanges.Add("bytes");
                responseObject.Content = new StreamContent(stream);
                responseObject.Content.Headers.ContentType = new MediaTypeHeaderValue("text/csv");
                //responseObject.Content.Headers.ContentType = new MediaTypeHeaderValue("application/vnd.ms-excel");
                responseObject.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment")
                {
                    FileName = fileInfo.Name
                };

                return (responseObject);
            }
        }

        /// <summary>
        /// Exports date to PDF Document
        /// </summary>
        /// <typeparam name="T">Entity name</typeparam>
        /// <param name="data">Export data</param>
        /// <param name="gridColumnNames">Grid Columns</param>
        /// <param name="screenName">Header Columns</param>
        /// <param name="headerColumnNames">Header Columns</param>
        /// <returns></returns>
        public static HttpResponseMessage PdfExport<T>(dynamic data, List<string> gridColumnNames, List<string> headerColumnNames, string screenName = "")
        {

            var dt = new DataTable();

            if (string.Equals(typeof(T).Name, "DataTable", StringComparison.InvariantCultureIgnoreCase))
            {
                dt = data;
            }
            else
            {
                dt = ToDataTable<T>(data, gridColumnNames);
            }

            using (

            var document = new Document(PageSize.A4))
            {
                using (var pdfstream = new MemoryStream())
                {
                    document.SetMargins(document.LeftMargin, document.RightMargin, document.TopMargin, document.BottomMargin + 10f);
                    var writer = PdfWriter.GetInstance(document, pdfstream);

                    document.Open();
                    var font7 = FontFactory.GetFont(FontFactory.HELVETICA_BOLD, 7);
                    var font6 = FontFactory.GetFont(FontFactory.HELVETICA_BOLD, 6);
                    var table = new PdfPTable(dt.Columns.Count)
                    {

                        WidthPercentage = 100
                    };
                    var cell = new PdfPCell
                    {
                        Colspan = dt.Columns.Count
                    };

                    //foreach (DataColumn c in dt.Columns)
                    //{
                    //    table.AddCell(new Phrase(c.ColumnName, font7));
                    //}
                    foreach (string title in headerColumnNames)
                    {
                        table.AddCell(new Phrase(title, font7));
                    }

                    for (int rows = 0; rows < dt.Rows.Count; rows++)
                    {
                        for (int column = 0; column < dt.Columns.Count; column++)
                        {
                            cell = new PdfPCell(new Phrase(new Chunk(dt.Rows[rows][column].ToString(), font6)));
                            table.AddCell(cell);
                        }
                    }
                    document.Add(table);
                    document.Close();

                    var responseObject = new HttpResponseMessage
                    {
                        Content = new StreamContent(new MemoryStream(pdfstream.ToArray()))
                    };
                    responseObject.Content.Headers.ContentType = new MediaTypeHeaderValue("application/pdf");
                    responseObject.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment")
                    {
                        FileName = screenName + "_" + DateTime.Now.ToString("dd_MMM_yyyy") + ".pdf"
                    };

                    return (responseObject);
                }
            }
        }
        //public static DataTable ExcelReader(string FileNameWithPath)
        //{
        //    var dt = new DataTable();
        //    FileInfo existingFile = new FileInfo(FileNameWithPath);
        //    using (ExcelPackage xlPackage = new ExcelPackage(existingFile))
        //    {
        //        ExcelWorksheet worksheet = xlPackage.Workbook.Worksheets[1];

        //        //adding columns  
        //        int iCol = 1;
        //        int iRow = 1;
        //        bool CanRead = true;
        //        while (CanRead)
        //        {
        //            if (worksheet.Cell(iRow, iCol).Value != null)
        //            {
        //                if (worksheet.Cell(iRow, iCol).Value != "")
        //                {
        //                    dt.Columns.Add(worksheet.Cell(iRow, iCol).Value);
        //                    iCol++;
        //                }
        //                else
        //                {
        //                    CanRead = false;
        //                }
        //            }
        //            else
        //            {
        //                CanRead = false;
        //            }
        //        }
        //        //adding rows  
        //        iRow = 2;
        //        bool canRowRead = true;
        //        while (canRowRead)
        //        {
        //            DataRow dr = dt.NewRow();
        //            bool rowVal = true;
        //            int colCount = 1;
        //            while (colCount <= iCol)
        //            {
        //                if (worksheet.Cell(iRow, colCount).Value != "")
        //                {
        //                    dr[colCount - 1] = worksheet.Cell(iRow, colCount).Value;
        //                    rowVal = false;
        //                }
        //                colCount++;
        //            }
        //            if (rowVal)
        //            {
        //                canRowRead = false;
        //            }
        //            else
        //            {
        //                dt.Rows.Add(dr);
        //                iRow++;
        //            }
        //        }
        //    }
        //    return dt;
        //}
        /// <summary>
        /// Exports date to CSV Document
        /// </summary>
        /// <typeparam name="T">Entity name</typeparam>
        /// <param name="data">Export data</param>
        /// <param name="gridColumnNames">Grid Columns</param>
        /// <param name="headerColumnNames">Header Columns</param>
        /// <param name="screenName">Header Columns</param>
        /// <param name="UserID">Optional Param</param>
        /// <returns></returns>
        public static HttpResponseMessage CsvExport<T>(dynamic data, List<string> gridColumnNames, List<string> headerColumnNames, string screenName = "", string UserID = null)
        {
            var sb = new StringBuilder();
            var table = new DataTable();

            if (string.Equals(typeof(T).Name, "DataTable", StringComparison.InvariantCultureIgnoreCase))
            {
                table = data;
            }
            else
            {
                table = ToDataTable<T>(data, gridColumnNames);
            }

            //var headerValues = table.Columns.OfType<DataColumn>().Select(column => QuoteValue(column.ColumnName));

            // sb.AppendFormat(string.Join(",", headerValues) + "\n");
            sb.AppendFormat(string.Join(",", headerColumnNames) + "\n");

            IEnumerable<string> items = null;

            foreach (DataRow row in table.Rows)
            {
                items = row.ItemArray.Select(o => QuoteValue(o.ToString()));
                sb.AppendFormat(string.Join(",", items) + "\n");
            }
            table.Dispose();

            var byteArray = Encoding.UTF8.GetBytes(sb.ToString());
            sb = null;

            var stream = new MemoryStream(byteArray);
            var responseObject = new HttpResponseMessage();

            responseObject.Headers.AcceptRanges.Add("bytes");
            responseObject.Content = new StreamContent(stream);
            responseObject.Content.Headers.ContentType = new MediaTypeHeaderValue("APPLICATION/OCTET-STREAM");
            if (UserID == null)
            {
                responseObject.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment")
                {
                    FileName = screenName + "_" + DateTime.Now.ToString("dd_MMM_yyyy") + ".csv"
                };
            }
            else
            {
                responseObject.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment")
                {
                    FileName = screenName + "_" + DateTime.Now.ToString("dd_MMM_yyyy") + "_" + UserID + ".csv"
                };
            }
            //stream.Dispose();
            return (responseObject);
        }


        static string QuoteValue(string value)
        {
            return String.Concat("\"",
            value.Replace("\"", "\"\""), "\"");
        }

        /// <summary>
        /// 
        /// </summary>
        /// <typeparam name="T">Export Entity</typeparam>
        /// <param name="items">Items to be exported</param>
        /// <param name="gridColumnNames">Columns to be exported</param>
        /// <returns>DataTable</returns>
        static DataTable ToDataTable<T>(dynamic items, List<string> gridColumnNames)
        {
            var tb = new DataTable(typeof(T).Name);
            var props = typeof(T).GetProperties(BindingFlags.Public | BindingFlags.Instance);

            foreach (var prop in gridColumnNames)
            {
                if (!prop.Equals("EDIT", StringComparison.OrdinalIgnoreCase) &&
                    !prop.Equals("VIEW", StringComparison.OrdinalIgnoreCase) &&
                    !prop.Equals("DELETE", StringComparison.OrdinalIgnoreCase))
                    tb.Columns.Add(prop);
            }

            foreach (var item in items)
            {
                var dr = tb.NewRow();
                foreach (var columnName in tb.Columns)
                {
                    if (((columnName.ToString().ToUpper().Contains("Date".ToUpper()) && !columnName.ToString().ToUpper().Contains("update".ToUpper())) || columnName.ToString().Contains("EffectiveFrom") || columnName.ToString().Contains("EffectiveTo") || columnName.ToString().Equals("InspectionConductedOn")) && (!columnName.ToString().Contains("Time")))
                    {
                        dr[columnName.ToString()] = item.GetType().GetProperty(columnName.ToString()).GetValue(item, null) == null ? "" : item.GetType().GetProperty(columnName.ToString()).GetValue(item, null).ToString("dd/MM/yyyy");
                        DateTime? dt = item.GetType().GetProperty(columnName.ToString()).GetValue(item, null) == null ? null : item.GetType().GetProperty(columnName.ToString()).GetValue(item, null);
                        if (dt != null)
                        {
                            var zeroConstant = "0";
                            var notNullableDate = dt ?? DateTime.Now;
                            var date = dt.Value.Day < 10 ? zeroConstant + dt.Value.Day : dt.Value.Day.ToString();
                            var month = notNullableDate.ToString("MMM");
                            var res = date + "/" + month + "/" + dt.Value.Year;
                            dr[columnName.ToString()] = res;
                        }
                        else
                            dr[columnName.ToString()] = "";
                    }
                    else
                    {
                        if (columnName.ToString().ToUpper().Contains("Date".ToUpper()) && columnName.ToString().ToUpper().Contains("Time".ToUpper()))
                        {
                            dr[columnName.ToString()] = item.GetType().GetProperty(columnName.ToString()).GetValue(item, null) == null ? "" : item.GetType().GetProperty(columnName.ToString()).GetValue(item, null).ToString("dd/MMM/yyyy HH:mm");
                        }
                        else {
                            dr[columnName.ToString()] = item.GetType().GetProperty(columnName.ToString()).GetValue(item, null) == null ? "" : item.GetType().GetProperty(columnName.ToString()).GetValue(item, null).ToString();
                        }
                        
                    }
                }

                tb.Rows.Add(dr);
            }
            return tb;
        }

        public static HttpResponseMessage Download(string fileRelativePath, string fileName)
        {
            try
            {
                //fileName = fileName.Replace(" ", string.Empty).Replace("–", string.Empty);

                fileName = fileName.Replace(" ", string.Empty);
                var fileDetails = GetFileContentType(fileRelativePath);
                //fileName = fileName + "_" + DateTime.Now.ToString("ddMMyyyy")+"." + Convert.ToString(fileDetails[0]).ToLower();
                fileName = fileName + "_" + DateTime.Now.ToString("dd_MMM_yyyy") +"." + Convert.ToString(fileDetails[0]).ToLower();
                var responseObject = new HttpResponseMessage();
                var fileBytes = System.IO.File.ReadAllBytes(fileRelativePath);
                responseObject.Content = new ByteArrayContent(fileBytes);
                responseObject.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue(fileName);
                responseObject.Content.Headers.ContentType = new MediaTypeHeaderValue(Convert.ToString(fileDetails[1]));
                return responseObject;
            }
            catch (Exception)
            {
                throw;
            }
        }
        static string[] GetFileContentType(string fileRelativePath)
        {
            try
            {
                //fileName = fileName.Replace(" ", string.Empty).Replace("–", string.Empty);
                string[] fileDetails = new string[2];
                
                fileDetails[0] = fileRelativePath.Substring(fileRelativePath.LastIndexOf('.') + 1, (fileRelativePath.Length -(fileRelativePath.LastIndexOf('.')+1)));
                switch (fileDetails[0].ToLower())
                {
                    case "pdf":
                        fileDetails[1] = "application/pdf";
                        break;
                    case "avi":
                        fileDetails[1] = "video/avi";
                        break;
                    case "flv":
                        fileDetails[1] = "video/flv";
                        break;
                    case "mkv":
                        fileDetails[1] = "video/mkv";
                        break;
                    case "mp4":
                        fileDetails[1] = "video/mp4";
                        break;
                }
                return fileDetails;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public static HttpResponseMessage DownloadMultipleTypes(string fileRelativePath, string fileName)
        {
            try
            {
                var fileExtension = fileName.Substring(fileName.LastIndexOf('.') + 1).ToLower();
                var contentType = string.Empty;
                switch (fileExtension)
                {
                    case "png": contentType = "image/png"; break;
                    case "jpg":
                    case "jpeg": contentType = "image/jpeg"; break;
                    case "pdf": contentType = "application/pdf"; break;
                    case "doc": contentType = "application/msword"; break;
                    case "docx": contentType = "application/vnd.openxmlformats-officedocument.wordprocessingml.document"; break;
                }

                fileName = fileName.Replace(" ", string.Empty);
                fileName = fileName + "_" + DateTime.Now.ToString("dd_MMM_yyyy") + "." + fileExtension;
                var responseObject = new HttpResponseMessage();
                var fileBytes = System.IO.File.ReadAllBytes(fileRelativePath);
                responseObject.Content = new ByteArrayContent(fileBytes);
                responseObject.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue(fileName);
                responseObject.Content.Headers.ContentType = new MediaTypeHeaderValue(contentType);
                return responseObject;
            }
            catch (Exception)
            {
                throw;
            }
        }

        /// <summary>
        /// Exports date to CSV Download
        /// </summary>
        /// <typeparam name="T">Entity name</typeparam>
        /// <param name="data">Export data</param>
        /// <param name="gridColumnNames">Grid Columns</param>
        /// <param name="headerColumnNames">Header Columns</param>
        /// <param name="screenName">Header Columns</param>
        /// <returns></returns>
        public static HttpResponseMessage CsvDownload<T>(dynamic data, List<string> gridColumnNames, List<string> headerColumnNames, string screenName)
        {
            var sb = new StringBuilder();
            var table = new DataTable();

            table = ToDataTable<T>(data, gridColumnNames);

            //var headerValues = table.Columns.OfType<DataColumn>().Select(column => QuoteValue(column.ColumnName));

            // sb.AppendFormat(string.Join(",", headerValues) + "\n");
            sb.AppendFormat(string.Join(",", headerColumnNames) + "\n");

            IEnumerable<string> items = null;

            foreach (DataRow row in table.Rows)
            {
                items = row.ItemArray.Select(o => QuoteValue(o.ToString()));
                sb.AppendFormat(string.Join(",", items) + "\n");
            }
            table.Dispose();

            var byteArray = Encoding.UTF8.GetBytes(sb.ToString());
            sb = null;

            var stream = new MemoryStream(byteArray);
            var responseObject = new HttpResponseMessage();

            responseObject.Headers.AcceptRanges.Add("bytes");
            responseObject.Content = new StreamContent(stream);
            responseObject.Content.Headers.ContentType = new MediaTypeHeaderValue("APPLICATION/OCTET-STREAM");
            responseObject.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment")
            {
                FileName = screenName + "_" + DateTime.Now.ToString("dd_MMM_yyyy") + ".csv"
            };
            //stream.Dispose();
            return (responseObject);
        }


    }
}
