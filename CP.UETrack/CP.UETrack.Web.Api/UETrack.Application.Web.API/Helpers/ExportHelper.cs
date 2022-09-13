using CP.UETrack.DAL.DataAccess;
using iTextSharp.text;
using iTextSharp.text.pdf;
using iTextSharp.text.pdf.draw;
using OfficeOpenXml;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Reflection;
using System.Text;

namespace CP.UETrack.Application.Web.API.Helpers
{
    public class ExportHelper
    {
        public static string sExportType = string.Empty;
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
        public static HttpResponseMessage Export<T>(dynamic data, string exportType, List<string> gridColumnNames, List<string> headerColumnNames, string screenName, byte[] companylogo = null, byte[] MohLogo = null)
        {
            sExportType = exportType;

            switch (exportType)
            {

                case "EXCEL":
                    {
                        return ExcelExport<T>(data, gridColumnNames, headerColumnNames, screenName);
                    }
                case "PDF":
                    {
                        return PdfExport<T>(data, gridColumnNames, headerColumnNames, screenName, companylogo, MohLogo);
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
        public static HttpResponseMessage ExcelExport<T>(dynamic data, List<string> gridColumnNames, List<string> headerColumnNames, string screenName, DateTime? dateTime = null)
        {

            var sb = new StringBuilder();
            var table = new DataTable();
            screenName = string.IsNullOrEmpty(screenName) ? "" : screenName;
            if (string.Equals(typeof(T).Name, "DataTable", StringComparison.InvariantCultureIgnoreCase))
            {
                table = data;
            }
            else
            {
                table = ToDataTable<T>(data, gridColumnNames, screenName);
            }

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
                var i = 1;
                var index = 0;
                sb.Append("<tr>");
                foreach (string ColumnData in myRow.ItemArray.Select(o => QuoteValue(o.ToString())))
                {
                    var _data = ColumnData.TrimStart('"');

                    //temporary 
                    var tempColumnName = table.Columns[index].ToString();
                    var tempcolumnDatatype = table.Columns[index].DataType.Name; 
                    // temporary 

                    _data = _data.TrimEnd('"');
                    if (table.Columns[index].ToString().Contains("Phone") || table.Columns[index].ToString().Contains("Mobile")
                        || table.Columns[index].ToString().Contains("Contact") || table.Columns[index].ToString().Contains("Fax")
                        || table.Columns[index].ToString().Contains("BinNo") || table.Columns[index].ToString().Contains("AssetTypeCode")
                        || table.Columns[index].ToString().Contains("MaintenanceRateDW") || table.Columns[index].ToString().Contains("MaintenanceRatePW")
                        || table.Columns[index].ToString().Contains("MonthlyProposedFeeDW") || table.Columns[index].ToString().Contains("MonthlyProposedFeePW")
                        || table.Columns[index].ToString().Contains("CountingDays"))
                    {
                        sb.Append("<td style='mso-number-format:\\@'>");
                        sb.Append(_data);
                        sb.Append("</td>");
                    }
                    //else
                    //{
                    //    var columnName = table.Columns[index].ToString();

                    //    if (!string.IsNullOrEmpty(columnName) && columnName.Contains("AssetTypeCode"))
                    //    {
                    //        sb.Append("<td align=\"left\">");
                    //        sb.Append(_data);
                    //        sb.Append("</td>");
                    //    }

                    else
                    {
                        if (tempcolumnDatatype == "String")
                        {   sb.Append("<td align=\"left\">");                            
                            sb.Append(_data);
                            sb.Append("</td>");
                        }
                        else
                        {
                            sb.Append("<td>");
                            sb.Append(_data);
                            sb.Append("</td>");

                        }

                        
                    }

                    //}
                    i++;
                    index++;
                    if (i > headerColumnNames.Count) break;

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
            responseObject.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment");
            var FileName = screenName + ".xls";
            if (dateTime == null)
            {
                FileName = screenName + "_" + DateTime.Now.ToString("dd_MMM_yyyy", new CultureInfo("en-US")) + ".xls";
            }
            else
            {
                FileName = screenName + "_" + dateTime.Value.ToString("dd_MMM_yyyy", new CultureInfo("en-US")) + ".xls";

                if (screenName == "Monthly Stock Register")
                {
                    FileName = screenName + "_" + dateTime.Value.ToString("MMM_yyyy") + ".xls";
                }
            }
            responseObject.Content.Headers.ContentDisposition.FileName = FileName;

            return (responseObject);
        }

        public static HttpResponseMessage ExportToExcel1<T>(dynamic data, List<string> gridColumnNames)
        {
            var DownloadPath = Convert.ToString(System.Configuration.ConfigurationManager.AppSettings["DownLoadPath"]);
            var fileInfo = new FileInfo(DownloadPath + "\\" +
                               DateTime.Now.Ticks + ".csv");


            var table = new DataTable();
            if (string.Equals(typeof(T).Name, "DataTable", StringComparison.InvariantCultureIgnoreCase))
            {
                table = data;
            }
            else
            {
                table = ToDataTable<T>(data, gridColumnNames, "");
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
        public static HttpResponseMessage PdfExport<T>(dynamic data, List<string> gridColumnNames, List<string> headerColumnNames, string screenName = "", byte[] companylogo = null, byte[] MohLogo = null)
        {

            var dt = new DataTable();

            if (string.Equals(typeof(T).Name, "DataTable", StringComparison.InvariantCultureIgnoreCase))
            {
                dt = data;
            }
            else
            {
                dt = ToDataTable<T>(data, gridColumnNames, "");
            }
            if (screenName == "Project_Details")
            {
                using (var document = new Document(PageSize.A4.Rotate()))
                {
                    using (var pdfstream = new MemoryStream())
                    {
                        document.SetMargins(document.LeftMargin, document.RightMargin, document.TopMargin, document.BottomMargin + 10f);
                        var writer = PdfWriter.GetInstance(document, pdfstream);

                        writer.ViewerPreferences = PdfWriter.PageModeUseOutlines;
                        // Our custom Header and Footer is done using Event Handler
                        var PageEventHandler = new TwoColumnHeaderFooter();
                        writer.PageEvent = PageEventHandler;
                        // Define the page header
                        PageEventHandler.Title = screenName.Replace("_", " ");
                        PageEventHandler.HeaderFont = FontFactory.GetFont(BaseFont.HELVETICA_BOLD, 8);
                        PageEventHandler.HeaderValueFont = FontFactory.GetFont(BaseFont.HELVETICA, 8);
                        PageEventHandler.MohLogo = MohLogo;
                        PageEventHandler.CompanyLogo = companylogo;
                        PageEventHandler.PdfExportType = 2;

                        document.Open();
                        var font7 = FontFactory.GetFont(FontFactory.HELVETICA_BOLD, 7);
                        var font6 = FontFactory.GetFont(FontFactory.HELVETICA, 6);
                        var table = new PdfPTable(dt.Columns.Count)
                        {
                            WidthPercentage = 100
                        };
                        table.HeaderRows = 1;
                        var _UserSession = new SessionHelper().UserSession();
                        //if (_UserSession.CompanyName == null)
                        //{
                        //    table.SpacingBefore = 50;
                        //}
                        //else
                        //{
                        //    table.SpacingBefore = 1;
                        //}
                        var cell = new PdfPCell
                        {
                            Colspan = dt.Columns.Count
                        };

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

                        if (MohLogo != null && IsValidImage(MohLogo))
                        {
                            var mohLogo = iTextSharp.text.Image.GetInstance(MohLogo); // Converting bytes to Image
                            //mohLogo.SetAbsolutePosition(40, 750);
                            mohLogo.SetAbsolutePosition(40, 500);

                            if (mohLogo.ScaledHeight > mohLogo.ScaledWidth)
                            {
                                mohLogo.ScaleAbsoluteHeight(90);
                                mohLogo.ScaleAbsoluteWidth(70);
                            }
                            else if (mohLogo.ScaledHeight == mohLogo.ScaledWidth)
                            {
                                mohLogo.ScaleAbsoluteHeight(70);
                                mohLogo.ScaleAbsoluteWidth(70);
                            }
                            else
                            {
                                mohLogo.ScaleAbsoluteHeight(70);
                                mohLogo.ScaleAbsoluteWidth(120);
                            }
                            document.Add(mohLogo);


                        }
                        if (companylogo != null && IsValidImage(companylogo))
                        {
                            var CompanyLogo = iTextSharp.text.Image.GetInstance(companylogo); // Converting bytes to Image
                            CompanyLogo.SetAbsolutePosition(680, 500);
                            if (CompanyLogo.ScaledHeight > CompanyLogo.ScaledWidth)
                            {
                                CompanyLogo.ScaleAbsoluteHeight(80);
                                CompanyLogo.ScaleAbsoluteWidth(60);
                            }
                            else if (CompanyLogo.ScaledHeight == CompanyLogo.ScaledWidth)
                            {
                                CompanyLogo.ScaleAbsoluteHeight(60);
                                CompanyLogo.ScaleAbsoluteWidth(60);
                            }
                            else
                            {
                                CompanyLogo.ScaleAbsoluteHeight(60);
                                CompanyLogo.ScaleAbsoluteWidth(120);
                            }
                            document.Add(CompanyLogo);

                        }
                        var cb = writer.DirectContent;
                        // select the font properties
                        var bf = BaseFont.CreateFont(BaseFont.HELVETICA_BOLD, BaseFont.CP1252, BaseFont.NOT_EMBEDDED);
                        cb.SetColorFill(BaseColor.BLACK);
                        cb.SetFontAndSize(bf, 11);
                        // write the text in the pdf content
                        cb.BeginText();
                        var text = screenName.Replace("_", " ");
                        // put the alignment and coordinates here
                        cb.ShowTextAligned(PdfContentByte.ALIGN_CENTER, text, 380, 520, 0);
                        cb.EndText();

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
            else
            {
                using (var document = new Document(PageSize.A4))
                {
                    using (var pdfstream = new MemoryStream())
                    {
                        document.SetMargins(document.LeftMargin, document.RightMargin, document.TopMargin, document.BottomMargin + 10f);
                        var writer = PdfWriter.GetInstance(document, pdfstream);
                        writer.ViewerPreferences = PdfWriter.PageModeUseOutlines;
                        // Our custom Header and Footer is done using Event Handler
                        var PageEventHandler = new TwoColumnHeaderFooter();
                        writer.PageEvent = PageEventHandler;
                        // Define the page header
                        PageEventHandler.Title = screenName.Replace("_", " ");
                        PageEventHandler.HeaderFont = FontFactory.GetFont(BaseFont.HELVETICA_BOLD, 8);
                        PageEventHandler.HeaderValueFont = FontFactory.GetFont(BaseFont.HELVETICA, 8);
                        PageEventHandler.MohLogo = MohLogo;
                        PageEventHandler.CompanyLogo = companylogo;
                        PageEventHandler.PdfExportType = 1;
                        document.Open();
                        var font7 = FontFactory.GetFont(FontFactory.HELVETICA_BOLD, 7);
                        var font6 = FontFactory.GetFont(FontFactory.HELVETICA, 6);
                        var table = new PdfPTable(dt.Columns.Count)
                        {
                            WidthPercentage = 100
                        };
                        table.HeaderRows = 1;
                        var _UserSession = new SessionHelper().UserSession();
                        //if (_UserSession.CompanyName == null)
                        //{
                        //    table.SpacingBefore = 50;
                        //}
                        //else
                        //{
                        //    table.SpacingBefore = 1;
                        //}
                        var cell = new PdfPCell
                        {
                            Colspan = dt.Columns.Count
                        };

                        foreach (string title in headerColumnNames)
                        {
                            var HeaderCell = new PdfPCell(new Phrase(title, font7));
                            HeaderCell.HorizontalAlignment = Element.ALIGN_CENTER;
                            //var myColor = WebColors.GetRGBColor("#b02f41");
                            //HeaderCell.BackgroundColor = myColor;
                            table.AddCell(HeaderCell);
                        }

                        decimal result;
                        for (int rows = 0; rows < dt.Rows.Count; rows++)
                        {
                            for (int column = 0; column < dt.Columns.Count; column++)
                            {
                                if (decimal.TryParse(dt.Rows[rows][column].ToString(), out result))
                                {
                                    cell = new PdfPCell(new Phrase(new Chunk(dt.Rows[rows][column].ToString(), font6)));
                                    cell.HorizontalAlignment = Element.ALIGN_RIGHT;
                                    table.AddCell(cell);
                                }
                                else
                                {
                                    cell = new PdfPCell(new Phrase(new Chunk(dt.Rows[rows][column].ToString(), font6)));
                                    table.AddCell(cell);
                                }
                            }
                        }

                        //for (int rows = 0; rows < dt.Rows.Count; rows++)
                        //{
                        //    for (int column = 0; column < dt.Columns.Count; column++)
                        //    {
                        //        cell = new PdfPCell(new Phrase(new Chunk(dt.Rows[rows][column].ToString(), font6)));
                        //        table.AddCell(cell);
                        //    }
                        //}



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
        }
        public static bool IsValidImage(byte[] bytes)
        {
            try
            {
                using (MemoryStream ms = new MemoryStream(bytes))
                    System.Drawing.Image.FromStream(ms);
            }
            catch (ArgumentException)
            {
                return false;
            }
            return true;
        }
        public static DataTable ExcelReader(string FileNameWithPath)
        {
            var dt = new DataTable();
            FileInfo existingFile = new FileInfo(FileNameWithPath);
            //using (ExcelPackage xlPackage = new ExcelPackage(existingFile))
            //{
            //    ExcelWorksheet worksheet = xlPackage.Workbook.Worksheets[1];

            //    //adding columns  
            //    int iCol = 1;
            //    int iRow = 1;
            //    bool CanRead = true;
            //    while (CanRead)
            //    {
            //        if (worksheet.Cell(iRow, iCol).Value != null)
            //        {
            //            if (worksheet.Cell(iRow, iCol).Value != "")
            //            {
            //                dt.Columns.Add(worksheet.Cell(iRow, iCol).Value);
            //                iCol++;
            //            }
            //            else
            //            {
            //                CanRead = false;
            //            }
            //        }
            //        else
            //        {
            //            CanRead = false;
            //        }
            //    }
            //    //adding rows  
            //    iRow = 2;
            //    bool canRowRead = true;
            //    while (canRowRead)
            //    {
            //        DataRow dr = dt.NewRow();
            //        bool rowVal = true;
            //        int colCount = 1;
            //        while (colCount <= iCol)
            //        {
            //            if (worksheet.Cell(iRow, colCount).Value != "")
            //            {
            //                dr[colCount - 1] = worksheet.Cell(iRow, colCount).Value;
            //                rowVal = false;
            //            }
            //            colCount++;
            //        }
            //        if (rowVal)
            //        {
            //            canRowRead = false;
            //        }
            //        else
            //        {
            //            dt.Rows.Add(dr);
            //            iRow++;
            //        }
            //    }
            //}
            return dt;
        }
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
                table = ToDataTable<T>(data, gridColumnNames, "");
            }
            sb.AppendFormat(string.Join(",", headerColumnNames) + "\n");

            IEnumerable<string> items = null;

            foreach (DataRow row in table.Rows)
            {
                items = row.ItemArray.Select(o => QuoteValue(o.ToString()));
                items = row.ItemArray.Select(o => QuoteValue(o.ToString().Replace("{", "{{").Replace("}", "}}")));
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
            return (responseObject);
        }


        static string QuoteValue(string value)
        {
            return String.Concat("\"",
            value.Replace("\"", ""), "\"");
            //return String.Concat("\"", value, "\"");
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="items">Items to be exported</param>
        /// <param name="gridColumnNames">Columns to be exported</param>
        /// <param name="screenName">todo: describe screenName parameter on ToDataTable</param>
        /// <typeparam name="T">Export Entity</typeparam>
        /// <returns>DataTable</returns>
        static DataTable ToDataTable<T>(dynamic items, List<string> gridColumnNames, string screenName)
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
                    if ((((columnName.ToString().ToUpper().Contains("Date".ToUpper()) && !columnName.ToString().ToUpper().Contains("update".ToUpper())) || columnName.ToString().Contains("Effectivefrom") || columnName.ToString().Contains("EffectiveFrom") || columnName.ToString().Contains("EffectiveTo") || columnName.ToString().Equals("InspectionConductedOn")) || (screenName == "LinenPARRequirements" && columnName.ToString().ToUpper() == "LastUpdated".ToUpper())) && (!columnName.ToString().Contains("Time")))
                    {
                        dr[columnName.ToString()] = item.GetType().GetProperty(columnName.ToString()).GetValue(item, null) == null ? "" : item.GetType().GetProperty(columnName.ToString()).GetValue(item, null).ToString("dd-MMM-yyyy", new CultureInfo("en-US"));
                    }
                    else if (columnName.ToString().ToUpper().Contains("Date".ToUpper()) && columnName.ToString().ToUpper().Contains("Time".ToUpper()))
                    {
                        dr[columnName.ToString()] = item.GetType().GetProperty(columnName.ToString()).GetValue(item, null) == null ? "" : item.GetType().GetProperty(columnName.ToString()).GetValue(item, null).ToString("dd-MMM-yyyy HH:mm", new CultureInfo("en-US"));
                    }


                    else
                    {
                        try
                        {

                            if (item.GetType().GetProperty(columnName.ToString()).PropertyType.Name == "Decimal" ||
                                   ((item.GetType().GetProperty(columnName.ToString()).PropertyType.Name == "Nullable`1") && ((item.GetType().GetProperty(columnName.ToString()).PropertyType).GenericTypeArguments[0].Name == "Decimal")) ||
                                   ((item.GetType().GetProperty(columnName.ToString()).PropertyType.Name == "Nullable`1") && (item.GetType().GetProperty(columnName.ToString()).PropertyType).GenericTypeArguments[0].Name == "Double"))
                            {
                                dr[columnName.ToString()] = item.GetType().GetProperty(columnName.ToString()).GetValue(item, null) == null ? "" : item.GetType().GetProperty(columnName.ToString()).GetValue(item, null).ToString("N2", CultureInfo.InvariantCulture);
                            }
                            else
                            {
                                dr[columnName.ToString()] = item.GetType().GetProperty(columnName.ToString()).GetValue(item, null) == null ? "" : item.GetType().GetProperty(columnName.ToString()).GetValue(item, null).ToString();
                            }

                        }
                        catch (Exception ex) { }
                    }
                }

                tb.Rows.Add(dr);
            }
            return tb;
        }

        public static HttpResponseMessage Download(byte[] objDocumentBytes, string fileName)
        {
            try
            {
                var fileDetails = GetFileContentType("pdf");
                fileName = fileName + "_" + DateTime.Now.ToString("dd_MMM_yyyy") + "." + Convert.ToString(fileDetails[0]).ToLower();
                var responseObject = new HttpResponseMessage
                {
                    Content = new ByteArrayContent(objDocumentBytes)
                };
                responseObject.Content = new ByteArrayContent(objDocumentBytes);
                responseObject.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment") { FileName = fileName };
                responseObject.Content.Headers.ContentType = new MediaTypeHeaderValue(Convert.ToString(fileDetails[1]));
                return responseObject;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public static HttpResponseMessage Download(string fileRelativePath, string fileName)
        {
            try
            {
                // fileName = fileName.Replace(" ", string.Empty);
                var fileDetails = GetFileContentType(fileRelativePath);
                fileName = fileName + "_" + DateTime.Now.ToString("dd_MMM_yyyy") + "." + Convert.ToString(fileDetails[0]).ToLower();
                var responseObject = new HttpResponseMessage();
                var fileBytes = System.IO.File.ReadAllBytes(fileRelativePath);
                responseObject.Content = new ByteArrayContent(fileBytes);
                responseObject.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment") { FileName = fileName };
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
                string[] fileDetails = new string[2];

                fileDetails[0] = fileRelativePath.Substring(fileRelativePath.LastIndexOf('.') + 1, (fileRelativePath.Length - (fileRelativePath.LastIndexOf('.') + 1)));
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
                    case "jpeg":
                        fileDetails[1] = "image/jpeg";
                        break;
                    case "jpg":
                        fileDetails[1] = "image/jpg";
                        break;
                    case "png":
                        fileDetails[1] = "image/png";
                        break;
                    case "gif":
                        fileDetails[1] = "image/gif";
                        break;
                    case "doc":
                        fileDetails[1] = "application/msword";
                        break;
                    case "docx":
                        fileDetails[1] = "application/vnd.openxmlformats-officedocument.wordprocessingml.document";
                        break;
                    case "xls":
                        fileDetails[1] = "application/vnd.ms-excel";
                        break;
                    case "xlsx":
                        fileDetails[1] = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
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
                    case "xls": contentType = "application/xls"; break;
                    case "xlsx": contentType = "application/xlsx"; break;
                    case "doc": contentType = "application/msword"; break;
                    case "docx": contentType = "application/vnd.openxmlformats-officedocument.wordprocessingml.document"; break;
                    case "zip": contentType = "application/zip"; break;
                }

                fileName = fileName.Replace(" ", string.Empty);
                fileName = fileName + "_" + DateTime.Now.ToString("dd_MMM_yyyy") + "." + fileExtension;
                var responseObject = new HttpResponseMessage();
                var fileBytes = System.IO.File.ReadAllBytes(fileRelativePath);
                responseObject.Content = new ByteArrayContent(fileBytes);
                responseObject.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment") { FileName = fileName };
                responseObject.Content.Headers.ContentType = new MediaTypeHeaderValue(contentType);
                return responseObject;
            }
            catch (Exception e)
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

            table = ToDataTable<T>(data, gridColumnNames, screenName);
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
            return (responseObject);
        }

        public static HttpResponseMessage ExportData<T>(dynamic data, string screenName)
        {
            var sb = new StringBuilder();
            var table = new DataTable();
            table = data;

            sb.Append("<table border='1px' cellpadding='1' cellspacing='1'>");
            sb.Append("<tr>");

            var headerColumnNames = string.Empty;
            var count = 0;
            var builder = new StringBuilder();
            builder.Append(headerColumnNames);
            var builder1 = new StringBuilder();
            builder1.Append(headerColumnNames);
            foreach (DataColumn column in data.Columns)
            {
                var ColumnName = column.ColumnName;
                if (count == 0)
                {
                    builder.Append(ColumnName);
                }
                else
                {
                    builder1.Append(',' + ColumnName);
                }
                count++;
            }
            headerColumnNames = builder.ToString() + builder1.ToString();
            var headerColumn = headerColumnNames.Split(',').ToList<string>();

            foreach (string _title in headerColumn)
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

                    if (_data.Contains("-Jan-") || _data.Contains("-Feb-") || _data.Contains("-Mar-") || _data.Contains("-Apr-") || _data.Contains("-May-") || _data.Contains("-Jun-") || _data.Contains("-Jul-") || _data.Contains("-Aug-") || _data.Contains("-Sep-") || _data.Contains("-Oct-") || _data.Contains("-Nov-") || _data.Contains("-Dec-"))
                    {
                        _data = "'" + _data;
                    }

                    sb.Append("<td>");
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
        public static byte[] MergePDFs(IEnumerable<string> fileNames, string targetPdf)
        {
            var merged = true;
            using (FileStream stream = new FileStream(targetPdf, FileMode.Create))
            {
                using (var document = new Document())
                {
                    using (
                    var pdf = new PdfCopy(document, stream))
                    {
                        PdfReader reader = null;
                        try
                        {
                            document.Open();
                            foreach (string file in fileNames)
                            {
                                using (reader = new PdfReader(file))
                                {
                                    pdf.AddDocument(reader);
                                    reader.Close();
                                }
                                // File.Delete(file);
                            }
                        }
                        catch (Exception)
                        {
                            merged = false;
                            if (reader != null)
                            {
                                reader.Close();
                            }
                        }
                        finally
                        {
                            if (document != null)
                            {
                                document.Close();
                            }
                        }
                    }
                }
            }
            return ReadAllBytes(targetPdf);
        }

        public static byte[] ReadAllBytes(string fileName)
        {
            byte[] buffer = null;
            using (FileStream fs = new FileStream(fileName, FileMode.Open, FileAccess.Read))
            {
                buffer = new byte[fs.Length];
                fs.Read(buffer, 0, (int)fs.Length);
            }
            return buffer;
        }

        //public static HttpResponseMessage PDFExport(dynamic obj,string ReportName ="")
        //{
        //    Type typeParameterType = typeof(obj);

        //}

        public static HttpResponseMessage PdfExport(MemoryStream objMemoryStream)
        {
            var responseObject = new HttpResponseMessage
            {
                Content = new StreamContent(new MemoryStream(objMemoryStream.ToArray()))
            };
            responseObject.Content.Headers.ContentType = new MediaTypeHeaderValue("application/pdf");
            responseObject.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment")
            {
                FileName = "HSIP" + "_" + DateTime.Now.ToString("dd_MMM_yyyy") + ".pdf"
            };
            return (responseObject);
        }

        public static HttpResponseMessage HSIPPdfExport(byte[] objMemoryStream, string ReportName = "")
        {
            var responseObject = new HttpResponseMessage
            {
                Content = new StreamContent(new MemoryStream(objMemoryStream.ToArray()))
            };
            responseObject.Content.Headers.ContentType = new MediaTypeHeaderValue("application/pdf");
            responseObject.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment")
            {
                FileName = "HSIP" + "_" + DateTime.Now.ToString("dd_MMM_yyyy") + ".pdf"
            };
            return (responseObject);
        }

        public static HttpResponseMessage PdfExport(List<string> ObjAttachmentPath, string ReportName = "")
        {
            var outputPdfPath = ConfigurationManager.AppSettings["FileUpload"].ToString() + "\\Merge.pdf"; ;
            var obj = MergePDFs(ObjAttachmentPath, outputPdfPath);
            var responseObject = new HttpResponseMessage
            {
                Content = new StreamContent(new MemoryStream(obj.ToArray()))
            };
            responseObject.Content.Headers.ContentType = new MediaTypeHeaderValue("application/pdf");
            responseObject.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment")
            {
                FileName = ReportName + "_" + DateTime.Now.ToString("dd_MMM_yyyy") + ".pdf"
            };
            return (responseObject);
        }

    }

    public class TwoColumnHeaderFooter : PdfPageEventHelper
    {
        readonly Model.UserDetailsModel _UserSession = new SessionHelper().UserSession();
        // This is the contentbyte object of the writer
        PdfContentByte cb;
        // we will put the final number of pages in a template
        PdfTemplate template;
        // this is the BaseFont we are going to use for the header / footer
        BaseFont bf = null;
        BaseFont bfNormal = null;
        // This keeps track of the creation time
        DateTime PrintTime = DateTime.Now;
        #region Properties
        public string Title { get; set; }
        public string HeaderLeft { get; set; }
        public string HeaderRight { get; set; }
        public Font HeaderFont { get; set; }
        public Font HeaderValueFont { get; set; }
        public Font FooterFont { get; set; }
        public byte[] CompanyLogo { get; set; }
        public byte[] MohLogo { get; set; }
        public int PdfExportType { get; set; }
        #endregion
        // we override the onOpenDocument method
        public override void OnOpenDocument(PdfWriter writer, Document document)
        {
            try
            {
                PrintTime = DateTime.Now;
                bf = BaseFont.CreateFont(BaseFont.HELVETICA_BOLD, BaseFont.CP1252, BaseFont.NOT_EMBEDDED);
                bfNormal = BaseFont.CreateFont(BaseFont.HELVETICA, BaseFont.CP1252, BaseFont.NOT_EMBEDDED);
                cb = writer.DirectContent;
                template = cb.CreateTemplate(50, 50);
            }
            catch (DocumentException de)
            {
            }
            catch (System.IO.IOException ioe)
            {
            }
        }
        public static bool IsValidImage(byte[] bytes)
        {
            try
            {
                using (MemoryStream ms = new MemoryStream(bytes))
                    System.Drawing.Image.FromStream(ms);
            }
            catch (ArgumentException)
            {
                return false;
            }
            return true;
        }
        public override void OnStartPage(PdfWriter writer, Document document)
        {

            base.OnStartPage(writer, document);
            if (PdfExportType == 1)
            {

                if (writer.PageNumber == 1)
                {
                    var pageSize = document.PageSize;
                    if (MohLogo != null && IsValidImage(MohLogo))
                    {
                        var mohLogo = iTextSharp.text.Image.GetInstance(MohLogo); // Converting bytes to Image
                        mohLogo.SetAbsolutePosition(40, 750);

                        if (mohLogo.ScaledHeight > mohLogo.ScaledWidth)
                        {
                            mohLogo.ScaleAbsoluteHeight(90);
                            mohLogo.ScaleAbsoluteWidth(70);
                        }
                        else if (mohLogo.ScaledHeight == mohLogo.ScaledWidth)
                        {
                            mohLogo.ScaleAbsoluteHeight(70);
                            mohLogo.ScaleAbsoluteWidth(70);
                        }
                        else
                        {
                            mohLogo.ScaleAbsoluteHeight(70);
                            mohLogo.ScaleAbsoluteWidth(120);
                        }
                        document.Add(mohLogo);


                    }
                    if (CompanyLogo != null && IsValidImage(CompanyLogo))
                    {
                        var CompanyLogoImage = iTextSharp.text.Image.GetInstance(CompanyLogo); // Converting bytes to Image
                        CompanyLogoImage.SetAbsolutePosition(440, 750);
                        if (CompanyLogoImage.ScaledHeight > CompanyLogoImage.ScaledWidth)
                        {
                            CompanyLogoImage.ScaleAbsoluteHeight(80);
                            CompanyLogoImage.ScaleAbsoluteWidth(60);
                        }
                        else if (CompanyLogoImage.ScaledHeight == CompanyLogoImage.ScaledWidth)
                        {
                            CompanyLogoImage.ScaleAbsoluteHeight(60);
                            CompanyLogoImage.ScaleAbsoluteWidth(60);
                        }
                        else
                        {
                            CompanyLogoImage.ScaleAbsoluteHeight(60);
                            CompanyLogoImage.ScaleAbsoluteWidth(120);
                        }
                        document.Add(CompanyLogoImage);

                    }
                    var HeaderTable = new PdfPTable(2) { WidthPercentage = 100 };
                    HeaderTable.DefaultCell.VerticalAlignment = Element.ALIGN_MIDDLE;
                    //if (_UserSession.CompanyName != null)
                    //{
                    //    //HeaderLeft = "Company Name: " + _UserSession.CompanyName;
                    //    var phrase = new Phrase();
                    //    phrase.Add(new Chunk("Company Name: ", HeaderFont));
                    //    phrase.Add(new Chunk(_UserSession.CompanyName, HeaderValueFont));
                    //    var HeaderLeftCell = new PdfPCell(phrase);
                    //    HeaderLeftCell.Padding = 5;
                    //    HeaderLeftCell.PaddingBottom = 10;
                    //    HeaderLeftCell.BorderWidthRight = 0;
                    //    //HeaderLeftCell.Border = 0;
                    //    HeaderTable.AddCell(HeaderLeftCell);
                    //}
                    //if (_UserSession.HospitalName != null)
                    //{

                    //    //HeaderRight = "Hospital Name: " + _UserSession.HospitalName;
                    //    var phrase = new Phrase();
                    //    phrase.Add(new Chunk("Hospital Name: ", HeaderFont));
                    //    phrase.Add(new Chunk(_UserSession.HospitalName, HeaderValueFont));
                    //    var HeaderRightCell = new PdfPCell(phrase);
                    //    HeaderRightCell.HorizontalAlignment = PdfPCell.ALIGN_LEFT;
                    //    HeaderRightCell.Padding = 5;
                    //    HeaderRightCell.PaddingBottom = 10;
                    //    HeaderRightCell.BorderWidthLeft = 0;
                    //    //HeaderRightCell.Border = 0;
                    //    HeaderTable.AddCell(HeaderRightCell);
                    //    // document.Add(HeaderTable);
                    //}
                    //else if (_UserSession.CompanyName != null && _UserSession.HospitalName == null)
                    //{
                    //    //HeaderRight = "Hospital Name: " + _UserSession.HospitalName;
                    //    var phrase = new Phrase();
                    //    phrase.Add(new Chunk("Hospital Name: ", HeaderFont));
                    //    phrase.Add(new Chunk(_UserSession.HospitalName, HeaderValueFont));
                    //    var HeaderRightCell = new PdfPCell(phrase);
                    //    HeaderRightCell.HorizontalAlignment = PdfPCell.ALIGN_LEFT;
                    //    HeaderRightCell.Padding = 5;
                    //    HeaderRightCell.PaddingBottom = 10;
                    //    HeaderRightCell.BorderWidthLeft = 0;
                    //    //HeaderRightCell.Border = 0;
                    //    HeaderTable.AddCell(HeaderRightCell);
                    //}


                    document.Add(new Paragraph(" "));
                    HeaderTable.SpacingBefore = 50;
                    HeaderTable.SpacingAfter = 10;
                    document.Add(HeaderTable);

                    var cb = writer.DirectContent;
                    // select the font properties
                    var bf = BaseFont.CreateFont(BaseFont.HELVETICA_BOLD, BaseFont.CP1252, BaseFont.NOT_EMBEDDED);
                    cb.SetColorFill(BaseColor.BLACK);
                    cb.SetFontAndSize(bf, 11);
                    // write the text in the pdf content
                    cb.BeginText();
                    // put the alignment and coordinates here
                    cb.ShowTextAligned(PdfContentByte.ALIGN_CENTER, Title, 280, 775, 0);
                    cb.EndText();
                }
            }
            else if (PdfExportType == 2)
            {

                if (writer.PageNumber == 1)
                {
                    var pageSize = document.PageSize;
                    if (MohLogo != null && IsValidImage(MohLogo))
                    {
                        var mohLogo = iTextSharp.text.Image.GetInstance(MohLogo); // Converting bytes to Image
                        mohLogo.SetAbsolutePosition(40, 500);

                        if (mohLogo.ScaledHeight > mohLogo.ScaledWidth)
                        {
                            mohLogo.ScaleAbsoluteHeight(90);
                            mohLogo.ScaleAbsoluteWidth(70);
                        }
                        else if (mohLogo.ScaledHeight == mohLogo.ScaledWidth)
                        {
                            mohLogo.ScaleAbsoluteHeight(70);
                            mohLogo.ScaleAbsoluteWidth(70);
                        }
                        else
                        {
                            mohLogo.ScaleAbsoluteHeight(70);
                            mohLogo.ScaleAbsoluteWidth(120);
                        }
                        document.Add(mohLogo);


                    }
                    if (CompanyLogo != null && IsValidImage(CompanyLogo))
                    {
                        var CompanyLogoImage = iTextSharp.text.Image.GetInstance(CompanyLogo); // Converting bytes to Image
                        CompanyLogoImage.SetAbsolutePosition(680, 500);
                        if (CompanyLogoImage.ScaledHeight > CompanyLogoImage.ScaledWidth)
                        {
                            CompanyLogoImage.ScaleAbsoluteHeight(80);
                            CompanyLogoImage.ScaleAbsoluteWidth(60);
                        }
                        else if (CompanyLogoImage.ScaledHeight == CompanyLogoImage.ScaledWidth)
                        {
                            CompanyLogoImage.ScaleAbsoluteHeight(60);
                            CompanyLogoImage.ScaleAbsoluteWidth(60);
                        }
                        else
                        {
                            CompanyLogoImage.ScaleAbsoluteHeight(60);
                            CompanyLogoImage.ScaleAbsoluteWidth(120);
                        }
                        document.Add(CompanyLogoImage);

                    }
                    var HeaderTable = new PdfPTable(2) { WidthPercentage = 100 };
                    HeaderTable.DefaultCell.VerticalAlignment = Element.ALIGN_MIDDLE;
                    //if (_UserSession.CompanyName != null)
                    //{
                    //    //HeaderLeft = "Company Name: " + _UserSession.CompanyName;
                    //    var phrase = new Phrase();
                    //    phrase.Add(new Chunk("Company Name: ", HeaderFont));
                    //    phrase.Add(new Chunk(_UserSession.CompanyName, HeaderValueFont));
                    //    var HeaderLeftCell = new PdfPCell(phrase);
                    //    HeaderLeftCell.Padding = 5;
                    //    HeaderLeftCell.PaddingBottom = 10;
                    //    HeaderLeftCell.BorderWidthRight = 0;
                    //    //HeaderLeftCell.Border = 0;
                    //    HeaderTable.AddCell(HeaderLeftCell);
                    //}
                    //if (_UserSession.HospitalName != null)
                    //{

                    //    //HeaderRight = "Hospital Name: " + _UserSession.HospitalName;
                    //    var phrase = new Phrase();
                    //    phrase.Add(new Chunk("Hospital Name: ", HeaderFont));
                    //    phrase.Add(new Chunk(_UserSession.HospitalName, HeaderValueFont));
                    //    var HeaderRightCell = new PdfPCell(phrase);
                    //    HeaderRightCell.HorizontalAlignment = PdfPCell.ALIGN_LEFT;
                    //    HeaderRightCell.Padding = 5;
                    //    HeaderRightCell.PaddingBottom = 10;
                    //    HeaderRightCell.BorderWidthLeft = 0;
                    //    //HeaderRightCell.Border = 0;
                    //    HeaderTable.AddCell(HeaderRightCell);
                    //    // document.Add(HeaderTable);
                    //}
                    //else if (_UserSession.CompanyName != null && _UserSession.HospitalName == null)
                    //{
                    //    //HeaderRight = "Hospital Name: " + _UserSession.HospitalName;
                    //    var phrase = new Phrase();
                    //    phrase.Add(new Chunk("Hospital Name: ", HeaderFont));
                    //    phrase.Add(new Chunk(_UserSession.HospitalName, HeaderValueFont));
                    //    var HeaderRightCell = new PdfPCell(phrase);
                    //    HeaderRightCell.HorizontalAlignment = PdfPCell.ALIGN_LEFT;
                    //    HeaderRightCell.Padding = 5;
                    //    HeaderRightCell.PaddingBottom = 10;
                    //    HeaderRightCell.BorderWidthLeft = 0;
                    //    //HeaderRightCell.Border = 0;
                    //    HeaderTable.AddCell(HeaderRightCell);
                    //}


                    document.Add(new Paragraph(" "));
                    HeaderTable.SpacingBefore = 50;
                    HeaderTable.SpacingAfter = 10;
                    document.Add(HeaderTable);

                    var cb = writer.DirectContent;
                    // select the font properties
                    var bf = BaseFont.CreateFont(BaseFont.HELVETICA_BOLD, BaseFont.CP1252, BaseFont.NOT_EMBEDDED);
                    cb.SetColorFill(BaseColor.BLACK);
                    cb.SetFontAndSize(bf, 11);
                    // write the text in the pdf content
                    cb.BeginText();
                    // put the alignment and coordinates here
                    cb.ShowTextAligned(PdfContentByte.ALIGN_CENTER, Title, 380, 520, 0);
                    cb.EndText();
                }
            }

        }
        public override void OnEndPage(PdfWriter writer, Document document)
        {
            base.OnEndPage(writer, document);
            var pageN = writer.PageNumber;
            var Pagetext = "Page " + pageN + " of ";
            //var dt = DateTime.ParseExact(PrintTime.ToString(),
            //                 "dd-MM-yyyy hh:mm:ss tt",
            //                 CultureInfo.InvariantCulture);
            var Datetext = "Date & Time: " + PrintTime.ToString("dd-MMM-yyyy hh:mm:ss tt");
            var len = bfNormal.GetWidthPoint(Pagetext, 8);
            var pageSize = document.PageSize;
            cb.SetRGBColorFill(100, 100, 100);
            cb.SetColorFill(BaseColor.BLACK);
            cb.MoveTo(35, pageSize.GetBottom(40));
            cb.LineTo(pageSize.Width - 35, pageSize.GetBottom(40));
            cb.Stroke();
            cb.BeginText();
            cb.SetFontAndSize(bfNormal, 7);
            cb.SetTextMatrix(pageSize.GetLeft(40), pageSize.GetBottom(25));
            cb.ShowText(Datetext);
            cb.EndText();
            var PageMarginRgt = pageN >= 10 ? pageSize.GetRight(90) + len : (pageSize.GetRight(85) + len);
            //cb.AddTemplate(template, pageSize.GetRight(75) + len, pageSize.GetBottom(30));
            cb.AddTemplate(template, PageMarginRgt, pageSize.GetBottom(25));

            cb.BeginText();
            cb.SetFontAndSize(bfNormal, 7);
            cb.SetColorFill(BaseColor.BLACK);
            cb.ShowTextAligned(PdfContentByte.ALIGN_RIGHT,
                Pagetext,
                pageSize.GetRight(50),
                pageSize.GetBottom(25), 0);
            //cb.SetTextMatrix(pageSize.GetRight(38), pageSize.GetBottom(30));
            cb.EndText();


        }
        public override void OnCloseDocument(PdfWriter writer, Document document)
        {
            base.OnCloseDocument(writer, document);
            template.BeginText();
            template.SetFontAndSize(bfNormal, 7);
            template.SetTextMatrix(0, 0);
            template.ShowText("" + (writer.PageNumber - 1));
            template.EndText();
        }
    }
}



