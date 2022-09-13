using iTextSharp.text;
using iTextSharp.text.pdf;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;

namespace CP.Framework.ReportHelper
{
    public class ReportExportHelper
    {
        Font fnt6 = FontFactory.GetFont(FontFactory.HELVETICA, 6);
        Font fntBld6 = FontFactory.GetFont(FontFactory.HELVETICA_BOLD, 6);
        Font fnt7 = FontFactory.GetFont(FontFactory.HELVETICA, 7);
        Font fntBld7 = FontFactory.GetFont(FontFactory.HELVETICA_BOLD, 7);
        Font fnt8 = FontFactory.GetFont(FontFactory.HELVETICA, 8);
        Font fntBld8 = FontFactory.GetFont(FontFactory.HELVETICA_BOLD, 8);
        Font fnt9 = FontFactory.GetFont(FontFactory.HELVETICA, 9);
        Font fntBld9 = FontFactory.GetFont(FontFactory.HELVETICA_BOLD, 9);
        Font fnt10 = FontFactory.GetFont(FontFactory.HELVETICA, 10);
        Font fntBld10 = FontFactory.GetFont(FontFactory.HELVETICA_BOLD, 10);

        public void ExcelExport(DataTable dataTable, Dictionary<string, string> filterData, string fileName)
        {
            try
            {
                var table = dataTable;
                HttpContext.Current.Response.Clear();
                HttpContext.Current.Response.ClearContent();
                HttpContext.Current.Response.ClearHeaders();
                HttpContext.Current.Response.Buffer = true;
                HttpContext.Current.Response.ContentType = "application/ms-excel";
                HttpContext.Current.Response.AddHeader("Content-Disposition", "attachment;filename=" + fileName + ".xls");
                HttpContext.Current.Response.Charset = "utf-8";
                HttpContext.Current.Response.ContentEncoding = Encoding.GetEncoding("windows-1250");
                //sets font
                var htmlTable = this.BuildDataTableAsHtmlTable(dataTable, filterData);
                HttpContext.Current.Response.Write(htmlTable);
                HttpContext.Current.Response.Flush();
                //Prevents any other content from being sent to the browser
                HttpContext.Current.Response.SuppressContent = true;
                //Directs the thread to finish, bypassing additional processing
                HttpContext.Current.ApplicationInstance.CompleteRequest();
            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }
        }

        string BuildDataTableAsHtmlTable(DataTable dataTable, Dictionary<string, string> filterData)
        {
            StringBuilder sb = null;
            try
            {
                if (dataTable.Rows.Count > 0)
                {
                    sb = new StringBuilder();
                    if (filterData != null && filterData.Count > 0)
                    {
                        var i = 0;
                        var tdList = new Dictionary<string, string>();
                        sb.Append("<table><tr><td></td></tr></table>");
                        sb.Append("<table border='1' bgColor='#ffffff' borderColor='#000000' cellSpacing='0' cellPadding='0' style='font-size:12px; background:white;'>");
                        foreach (var col in filterData)
                        {
                            var modulosFlag = i != 0 && i % 3 == 0;
                            if (modulosFlag)
                            {
                                //write in new row
                                sb.Append("<tr>");
                                foreach (var item in tdList)
                                {
                                    sb.Append("<td bgcolor='#b02f41'>");
                                    sb.Append("<font face='Arial' color='white'><b>");
                                    sb.Append(item.Key);
                                    sb.Append("</b></font>");
                                    sb.Append("</td>");
                                    sb.Append("<td><font face='Arial' color='black'>");
                                    sb.Append(item.Value);
                                    sb.Append("</font></td>");
                                }
                                sb.Append("</tr>");
                                tdList.Clear();
                            }
                            tdList.Add(col.Key, col.Value);
                            i++;
                        }
                        if (tdList != null && tdList.Count > 0)
                        {
                            //write in new row
                            sb.Append("<tr>");
                            foreach (var item in tdList)
                            {
                                sb.Append("<td bgcolor='#b02f41'>");
                                sb.Append("<font face='Arial' color='white'><b>");
                                sb.Append(item.Key);
                                sb.Append("</b></font>");
                                sb.Append("</td>");
                                sb.Append("<td><font face='Arial' color='black'>");
                                sb.Append(item.Value);
                                sb.Append("</font></td>");
                            }
                            sb.Append("</tr>");
                            tdList.Clear();
                        }
                        sb.Append("</table>");
                    }
                    sb.Append("<table><tr><td></td></tr><tr><td></td></tr></table>"); //set space for one row.
                    //sets the table border, cell spacing, border color, font of the text, background, foreground, font height
                    sb.Append("<table border='1' bgColor='#ffffff' borderColor='#000000' cellSpacing='0' cellPadding='0' style='font-size:12px; background:white;'><tr>");
                    //am getting my grid's column headers
                    var columnscount = dataTable.Columns.Count;
                    for (int i = 0; i < columnscount; i++)
                    {      //write in new column
                        sb.Append("<td bgcolor='#b02f41' style='color:white;' align='center'>");
                        //Get column headers  and make it as bold in excel columns
                        sb.Append("<font face='Arial' color='white'><b>");
                        sb.Append(dataTable.Columns[i].Caption.Replace("_", " ").ToString());
                        sb.Append("</b></font>");
                        sb.Append("</td>");
                    }
                    sb.Append("</tr>");
                    foreach (DataRow row in dataTable.Rows)
                    {//write in new row
                        sb.Append("<tr>");
                        for (int j = 0; j < dataTable.Columns.Count; j++)
                        {
                            sb.Append("<td><font face='Arial' color='black'>");
                            sb.Append(row[j].ToString());
                            sb.Append("</font></td>");
                        }
                        sb.Append("</tr>");
                    }
                    sb.Append("</table>");
                }
                if (sb != null)
                {
                    return sb.ToString();
                }
                else
                {
                    sb = new StringBuilder();
                    sb.Append("<table><tr><td>No Records Found.</td></tr></table>");
                    return sb.ToString();
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }
        }

        public void CsvExport(DataTable dataTable, Dictionary<string, string> filterData, string fileName)
        {
            try
            {
                var table = dataTable;
                HttpContext.Current.Response.Clear();
                HttpContext.Current.Response.ClearContent();
                HttpContext.Current.Response.ClearHeaders();
                HttpContext.Current.Response.Buffer = true;
                HttpContext.Current.Response.ContentType = "text/csv";
                HttpContext.Current.Response.AddHeader("Content-Disposition", "attachment;filename=" + fileName + ".csv");
                HttpContext.Current.Response.Charset = string.Empty;
                var commaSeparateValues = this.BuildDataTableAsCommaSeparate(dataTable, filterData);
                HttpContext.Current.Response.Write(commaSeparateValues);
                HttpContext.Current.Response.Flush();
                //Prevents any other content from being sent to the browser
                HttpContext.Current.Response.SuppressContent = true;
                //Directs the thread to finish, bypassing additional processing
                HttpContext.Current.ApplicationInstance.CompleteRequest();
            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }
        }

        string BuildDataTableAsCommaSeparate(DataTable dataTable, Dictionary<string, string> filterData)
        {
            StringBuilder sb = null;
            try
            {
                if (dataTable.Rows.Count > 0)
                {
                    sb = new StringBuilder();
                    if (filterData != null && filterData.Count > 0)
                    {
                        var i = 0;
                        var tdList = new Dictionary<string, string>();
                        foreach (var col in filterData)
                        {
                            var modulosFlag = i != 0 && i % 3 == 0;
                            if (modulosFlag)
                            {
                                foreach (var item in tdList)
                                {
                                    var idx = tdList.Keys.ToList().IndexOf(item.Key);
                                    sb.Append(item.Key);
                                    sb.Append(",");
                                    sb.Append(item.Value);
                                    if (idx != tdList.Count - 1)
                                    {
                                        sb.Append(",");
                                    }
                                }
                                tdList.Clear();
                                sb.Append(Environment.NewLine);
                            }
                            tdList.Add(col.Key, col.Value);
                            i++;
                        }
                        if (tdList != null && tdList.Count > 0)
                        {
                            foreach (var item in tdList)
                            {
                                var idx = tdList.Keys.ToList().IndexOf(item.Key);
                                sb.Append(item.Key);
                                sb.Append(",");
                                sb.Append(item.Value);
                                if (idx != tdList.Count - 1)
                                {
                                    sb.Append(",");
                                }
                            }
                            tdList.Clear();
                        }
                    }
                    sb.Append(Environment.NewLine);
                    sb.Append(Environment.NewLine);
                    for (int i = 0; i < dataTable.Columns.Count; i++)
                    {
                        sb.Append(dataTable.Columns[i].Caption.Replace("_", " ").ToString());
                        if (i < dataTable.Columns.Count - 1)
                        {
                            sb.Append(",");
                        }
                    }
                    sb.Append(Environment.NewLine);
                    foreach (DataRow dr in dataTable.Rows)
                    {
                        for (int i = 0; i < dataTable.Columns.Count; i++)
                        {
                            if (!Convert.IsDBNull(dr[i]))
                            {
                                string value = dr[i].ToString();
                                if (value.Contains(","))
                                {
                                    value = string.Format("\"{0}\"", value);
                                    sb.Append(value);
                                }
                                else
                                {
                                    sb.Append(dr[i].ToString());
                                }
                            }
                            if (i < dataTable.Columns.Count - 1)
                            {
                                sb.Append(",");
                            }
                        }
                        sb.Append(Environment.NewLine);
                    }
                }
                if (sb != null)
                {
                    return sb.ToString();
                }
                else
                {
                    sb = new StringBuilder();
                    sb.Append("No Records Found.");
                    return sb.ToString();
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }
        }

        public void PdfExport(DataTable dataTable, Dictionary<string, string> filterData, string fileName, string logoPath, string heading, string companyLogoPath)
        {
            try
            {
                var dt = dataTable;
                using (var document = new Document(PageSize.A4))
                {
                    document.SetMargins(document.LeftMargin, document.RightMargin, document.TopMargin, document.BottomMargin + 10f);

                    if (dt.Columns.Count > 5)
                    {
                        document.SetPageSize(PageSize.A4.Rotate());//Page Landscape Mode.
                    }
                    else
                    {
                        document.SetPageSize(PageSize.A4);//Page Portrait Mode.
                    }

                    var pdfBytes = this.DocumentCreator(filterData, dt, document, logoPath, heading, companyLogoPath);

                    HttpContext.Current.Response.Clear();
                    HttpContext.Current.Response.Buffer = true;
                    HttpContext.Current.Response.ContentType = "application/pdf";
                    HttpContext.Current.Response.AddHeader("content-disposition", "attachment;filename=" + fileName + ".pdf");     // to open file prompt Box open or Save file         
                    HttpContext.Current.Response.Charset = string.Empty;
                    HttpContext.Current.Response.Cache.SetCacheability(HttpCacheability.NoCache);
                    HttpContext.Current.Response.BinaryWrite(pdfBytes);
                    HttpContext.Current.Response.Flush();
                    // Prevents any other content from being sent to the browser
                    HttpContext.Current.Response.SuppressContent = true;
                    //Directs the thread to finish, bypassing additional processing
                    HttpContext.Current.ApplicationInstance.CompleteRequest();
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }
        }

        byte[] DocumentCreator(Dictionary<string, string> filterData, DataTable dt, Document document, string logoPath, string heading, string companyLogoPath)
        {
            try
            {
                using (var pdfStream = new MemoryStream())
                {
                    var writer = PdfWriter.GetInstance(document, pdfStream);

                    writer.PageEvent = new PdfHeaderFooterHealper(logoPath, heading, companyLogoPath, dt);

                    document.Open();

                    var filterTable = new PdfPTable(6)
                    {
                        SpacingBefore = 0,
                        WidthPercentage = 100,
                        SpacingAfter = 10F
                    };

                    filterTable.DefaultCell.Border = 0;
                    filterTable.DefaultCell.HorizontalAlignment = Element.ALIGN_CENTER; //ALIGN_LEFT
                    filterData.Add(string.Empty, string.Empty);
                    filterData.Add(" ", string.Empty);
                    foreach (var col in filterData)
                    {
                        filterTable.AddCell(new Phrase(col.Key, fntBld10));
                        filterTable.AddCell(new Phrase(col.Value, fnt9));
                    }

                    document.Add(filterTable);

                    var dataPdfTable = new PdfPTable(dt.Columns.Count)
                    {
                        SpacingBefore = 0,
                        WidthPercentage = 100,
                        SpacingAfter = 10F
                    };
                    dataPdfTable.DefaultCell.Border = Rectangle.NO_BORDER;

                    if (writer.PageNumber == 1)
                    {
                        foreach (DataColumn c in dt.Columns)
                        {
                            var pdfCellGridHeader = new PdfPCell(new Phrase(c.ColumnName.Replace("_", " ").ToString(), fntBld10));
                            pdfCellGridHeader.UseVariableBorders = true;
                            pdfCellGridHeader.BorderColor = BaseColor.LIGHT_GRAY;
                            pdfCellGridHeader.HorizontalAlignment = Element.ALIGN_CENTER;
                            dataPdfTable.AddCell(pdfCellGridHeader);
                        }
                    }

                    foreach (DataRow dr in dt.Rows)
                    {
                        int index = dt.Rows.IndexOf(dr);
                        foreach (DataColumn dc in dt.Columns)
                        {
                            var intValue = 0;
                            var doubleValue = 0.0;
                            var intFlag = int.TryParse(dr[dc.ColumnName].ToString(), out intValue);
                            var doubleFlag = double.TryParse(dr[dc.ColumnName].ToString(), out doubleValue);
                            PdfPCell pdfCellGridData = null;
                            if (intFlag)
                            {
                                pdfCellGridData = new PdfPCell(new Phrase(dr[dc.ColumnName].ToString(), fnt9))
                                {
                                    HorizontalAlignment = Element.ALIGN_RIGHT
                                };
                            }
                            else if (doubleFlag)
                            {
                                pdfCellGridData = new PdfPCell(new Phrase(dr[dc.ColumnName].ToString(), fnt9))
                                {
                                    HorizontalAlignment = Element.ALIGN_RIGHT
                                };
                            }
                            else
                            {
                                pdfCellGridData = new PdfPCell(new Phrase(dr[dc.ColumnName].ToString(), fnt9))
                                {
                                    HorizontalAlignment = Element.ALIGN_LEFT
                                };
                            }
                            pdfCellGridData.UseVariableBorders = true;
                            pdfCellGridData.BorderColor = BaseColor.LIGHT_GRAY;
                            dataPdfTable.AddCell(pdfCellGridData);
                        }
                    }
                    document.Add(dataPdfTable);
                    document.Close();
                    return pdfStream.ToArray();
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }
        }
    }

    public class PdfHeaderFooterHealper : PdfPageEventHelper
    {
        string strLogoPath = string.Empty;
        string strHeading = string.Empty;
        string strCompanyLogoPath = string.Empty;
        DataTable dt = null;

        // This is the contentbyte object of the writer
        PdfContentByte cb = null;
        // we will put the final number of pages in a template
        PdfTemplate footerTemplate = null;
        // this is the BaseFont we are going to use for the header / footer
        BaseFont bf = null;

        public PdfHeaderFooterHealper(string logoPath, string heading, string companyLogoPath, DataTable dataTable)
        {
            this.strLogoPath = logoPath;
            this.strHeading = heading;
            this.strCompanyLogoPath = companyLogoPath;
            this.dt = dataTable;
        }

        // write on top of document
        public override void OnOpenDocument(PdfWriter writer, Document document)
        {
            try
            {
                bf = BaseFont.CreateFont(BaseFont.HELVETICA, BaseFont.CP1252, BaseFont.NOT_EMBEDDED);
                cb = writer.DirectContent;
                footerTemplate = cb.CreateTemplate(50, 50);
                base.OnOpenDocument(writer, document);
            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }
        }

        // write on start of each page
        public override void OnStartPage(PdfWriter writer, Document document)
        {
            try
            {
                var fntBld10 = FontFactory.GetFont(FontFactory.HELVETICA_BOLD, 10);
                var fntBld16 = FontFactory.GetFont(FontFactory.HELVETICA_BOLD, 16);
                var rptHeading = new Phrase(strHeading, fntBld16);

                //create iTextSharp.text Image object using local image path
                var imgMohLogo = Image.GetInstance(strLogoPath);
                imgMohLogo.ScalePercent(60f);
                // placing image and text in one cell
                Paragraph paraMohLogo = new Paragraph();
                paraMohLogo.Add(new Chunk(imgMohLogo, 0, 0, true));

                //create iTextSharp.text Image object using local image path
                var imgCompanyLogo = Image.GetInstance(strCompanyLogoPath);
                imgCompanyLogo.ScalePercent(60f);
                // placing image and text in one cell
                Paragraph paraCompanyLogo = new Paragraph();
                paraCompanyLogo.Add(new Chunk(imgCompanyLogo, 0, 0, true));

                //Create PdfTable object                
                var pdfTableHeader = new PdfPTable(3)
                {
                    SpacingBefore = 0,
                    WidthPercentage = 100,
                    SpacingAfter = 10F
                };

                //We will have to create separate cells to include image logo and 2 separate strings
                var pdfCellMohLogo = new PdfPCell(paraMohLogo)
                {
                    HorizontalAlignment = Element.ALIGN_LEFT,
                    VerticalAlignment = Element.ALIGN_TOP,
                    PaddingTop = 0,
                    PaddingBottom = 10,
                    PaddingLeft = 10,
                    PaddingRight = 10,
                    Border = 2,
                    BorderColor = BaseColor.LIGHT_GRAY
                };

                var pdfCellRptHeading = new PdfPCell(rptHeading)
                {
                    HorizontalAlignment = Element.ALIGN_CENTER,
                    VerticalAlignment = Element.ALIGN_MIDDLE,
                    PaddingLeft = 10,
                    Border = 2,
                    BorderColor = BaseColor.LIGHT_GRAY
                };

                var pdfCellCompanyLogo = new PdfPCell(paraCompanyLogo)
                {
                    HorizontalAlignment = Element.ALIGN_RIGHT,
                    VerticalAlignment = Element.ALIGN_MIDDLE,
                    PaddingTop = 0,
                    PaddingBottom = 10,
                    PaddingLeft = 10,
                    PaddingRight = 10,
                    Border = 2,
                    BorderColor = BaseColor.LIGHT_GRAY
                };

                //set the alignment of all two cells and set border to 0                
                //add all two cells into PdfTable                
                pdfTableHeader.AddCell(pdfCellMohLogo);
                pdfTableHeader.AddCell(pdfCellRptHeading);
                pdfTableHeader.AddCell(pdfCellCompanyLogo);
                document.Add(pdfTableHeader);
                //For Grid Th Captions
                if (writer.PageNumber > 1)
                {
                    var dataPdfTableTh = new PdfPTable(dt.Columns.Count)
                    {
                        SpacingBefore = 0,
                        WidthPercentage = 100,
                        SpacingAfter = 0
                    };
                    foreach (DataColumn c in dt.Columns)
                    {
                        var pdfCellGridHeader = new PdfPCell(new Phrase(new Chunk(c.ColumnName.Replace("_", " ").ToString(), fntBld10)));
                        pdfCellGridHeader.UseVariableBorders = true;
                        pdfCellGridHeader.BorderColor = BaseColor.LIGHT_GRAY;
                        pdfCellGridHeader.HorizontalAlignment = Element.ALIGN_CENTER;
                        dataPdfTableTh.AddCell(pdfCellGridHeader);
                    }
                    document.Add(dataPdfTableTh);
                }
                base.OnStartPage(writer, document);
            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }
        }

        // write on end of each page
        public override void OnEndPage(PdfWriter writer, Document document)
        {
            try
            {
                var fnt9 = FontFactory.GetFont(FontFactory.HELVETICA, 9);
                var convertedDate = DateTime.Parse(DateTime.Now.ToString()).ToString("dd-MMM-yyyy HH:mm:ss", CultureInfo.InvariantCulture);
                var paraTimeStamp = new Paragraph("Date & Time : " + convertedDate, fnt9)
                {
                    Alignment = Element.ALIGN_LEFT
                };

                var paraCopyright = new Paragraph("© Copyright. ASIS - Ministry of Health", fnt9)
                {
                    Alignment = Element.ALIGN_CENTER
                };

                //var strPageNo = string.Format("Page {0} of", writer.PageNumber);
                //var paraPageNo = new Paragraph(strPageNo, fnt9)
                //{
                //    Alignment = Element.ALIGN_RIGHT
                //};
                var paraPageNo = new Paragraph(string.Empty, fnt9)
                {
                    Alignment = Element.ALIGN_RIGHT
                };

                float pageWidth = document.PageSize.Width;
                var pdfTableFooter = new PdfPTable(3)
                {
                    SpacingBefore = 0,
                    TotalWidth = pageWidth,
                    SpacingAfter = 10F
                };

                var pdfCellBorder = new PdfPCell()
                {
                    Colspan = 3,
                    Border = 2,
                    BorderColor = BaseColor.LIGHT_GRAY
                };

                var pdfCellTimeStamp = new PdfPCell(paraTimeStamp)
                {
                    HorizontalAlignment = Element.ALIGN_LEFT,
                    VerticalAlignment = Element.ALIGN_BOTTOM,
                    Border = 0,
                    PaddingLeft = 10
                };

                var pdfCellCopyright = new PdfPCell(paraCopyright)
                {
                    HorizontalAlignment = Element.ALIGN_CENTER,
                    VerticalAlignment = Element.ALIGN_BOTTOM,
                    Border = 0,
                    PaddingLeft = 0
                };

                var pdfCellPageNo = new PdfPCell(paraPageNo)
                {
                    HorizontalAlignment = Element.ALIGN_RIGHT,
                    VerticalAlignment = Element.ALIGN_BOTTOM,
                    Border = 0,
                    PaddingRight = 10
                };

                pdfTableFooter.AddCell(pdfCellBorder);
                pdfTableFooter.AddCell(pdfCellTimeStamp);
                pdfTableFooter.AddCell(pdfCellCopyright);
                pdfTableFooter.AddCell(pdfCellPageNo);
                pdfTableFooter.WriteSelectedRows(0, -1, 0, document.Bottom, writer.DirectContent);

                //Add paging to footer
                {
                    string strPageNo = "Page " + writer.PageNumber + " of ";
                    cb.BeginText();
                    cb.SetFontAndSize(bf, 9);
                    cb.SetTextMatrix(document.PageSize.GetRight(80), document.PageSize.GetBottom(35));
                    cb.ShowText(strPageNo);
                    cb.EndText();
                    float len = bf.GetWidthPoint(strPageNo, 9);
                    cb.AddTemplate(footerTemplate, document.PageSize.GetRight(80) + len, document.PageSize.GetBottom(35));
                }

                //Move the pointer and draw line to separate footer section from rest of page
                cb.MoveTo(40, document.PageSize.GetBottom(50));
                cb.Stroke();
                base.OnEndPage(writer, document);
            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }
        }

        //write on close of document
        public override void OnCloseDocument(PdfWriter writer, Document document)
        {
            try
            {
                base.OnCloseDocument(writer, document);
                footerTemplate.BeginText();
                footerTemplate.SetFontAndSize(bf, 9);
                footerTemplate.SetTextMatrix(0, 0);
                footerTemplate.ShowText((writer.PageNumber - 1).ToString());
                footerTemplate.EndText();
            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }
        }
    }
}
