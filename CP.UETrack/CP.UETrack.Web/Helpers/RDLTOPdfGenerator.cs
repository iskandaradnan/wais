using CP.UETrack.Model;
using CP.Framework.Common.Logging;
using iTextSharp.text;
using iTextSharp.text.pdf;
using Microsoft.Reporting.WebForms;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;

namespace UETrack.Application.Web.Helpers
{
    public class RDLTOPdfGenerator
    {
        public static byte[] GenerateHeppmPdf(string checklistNo, string version, string rdlPath)
        {
            try
            {
               // var RdlLocation = ConfigurationManager.AppSettings["RdlFileLocation"];
                var bytes = GenereateRDLToPdf_HeppmCheckList(checklistNo, version, "EngHeppmCheckList_old", rdlPath);
                return bytes;
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        public static byte[] GenereateRDLToPdf_HeppmCheckList(string checklistNo, string version, string spName, string rdlPath)
        {
            try
            {
                Warning[] warnings;
                string[] streamids;
                string mimeType;
                string encoding;
                string filenameExtension;
                var param = new ReportParameter[2];
                param[0] = new ReportParameter("CheckList_No", checklistNo.ToString(), true);
                param[1] = new ReportParameter("Version_No", version.ToString(), true);

                using (var con = new SqlConnection(ConfigurationManager.ConnectionStrings["AsisReportDataBase"].ToString()))
                {
                    var cmd = new SqlCommand();
                    using (SqlDataAdapter da = new SqlDataAdapter())
                    {
                        using (DataTable dt = new DataTable())
                        {
                            using (cmd = new SqlCommand(spName, con))
                            {
                                cmd.Parameters.Add(new SqlParameter("@CheckList_No", checklistNo));
                                cmd.Parameters.Add(new SqlParameter("@Version_No", version));
                                cmd.CommandType = CommandType.StoredProcedure;
                                da.SelectCommand = cmd;
                                da.Fill(dt);
                                var rdsAct = new ReportDataSource("DataSet1", dt);
                                using (ReportViewer rptviewer = new ReportViewer())
                                {
                                    rptviewer.ProcessingMode = ProcessingMode.Local;
                                    rptviewer.LocalReport.ReportPath = rdlPath;
                                    rptviewer.LocalReport.SetParameters(param);
                                    rptviewer.LocalReport.DataSources.Add(rdsAct);
                                    var bytes = rptviewer.LocalReport.Render("PDF", null, out mimeType, out encoding, out filenameExtension, out streamids, out warnings);
                                    return bytes;
                                }
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw;
            }
        }
    }
}