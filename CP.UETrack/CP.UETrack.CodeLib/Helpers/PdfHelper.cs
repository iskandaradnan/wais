using iTextSharp.text;
using iTextSharp.text.pdf;
using System;

namespace CP.UETrack.CodeLib.Helpers
{
    public class PdfHeaderHelper : PdfPageEventHelper
    {
        string leftLogoPath = string.Empty;
        string rightLogoPath = string.Empty;
        Byte[] CompanyLogo1 = null;

        public PdfHeaderHelper(string leftLogoPathPara, string rightLogoPathPara,Byte[] CompanyLogo)
        {
            leftLogoPath = leftLogoPathPara;
            rightLogoPath = rightLogoPathPara;
            CompanyLogo1 = CompanyLogo;
        }
        public override void OnStartPage(PdfWriter writer, Document document)
        {
            try
            {
                var fntBld10 = FontFactory.GetFont(FontFactory.HELVETICA_BOLD, 10);
                var fntBld16 = FontFactory.GetFont(FontFactory.HELVETICA_BOLD, 16);

                //create iTextSharp.text Image object using local image path
                var imgRightPDF = Image.GetInstance(CompanyLogo1);
                imgRightPDF.ScalePercent(70f);
                // placing image and text in one cell
                var paraRightLogo = new Paragraph();
                paraRightLogo.Add(new Chunk(imgRightPDF, 0, 0, true));

                // placing image and text in one cell
                var imgLeftPDF = Image.GetInstance(leftLogoPath);
                imgLeftPDF.ScalePercent(70f);
                // placing image and text in one cell
                var paraLeftLogo = new Paragraph();
                paraLeftLogo.Add(new Chunk(imgLeftPDF, 0, 0, true));

                //Create PdfTable object                
                var pdfTableHeader = new PdfPTable(2)
                {
                    SpacingBefore = 0,
                    WidthPercentage = 100,
                    SpacingAfter = 10F
                };

                //We will have to create separate cells to include image logo and 2 separate strings
                var pdfCellLeftLogo = new PdfPCell(paraLeftLogo)
                {
                    HorizontalAlignment = Element.ALIGN_LEFT,
                    VerticalAlignment = Element.ALIGN_TOP,
                    PaddingTop = 70,
                    PaddingBottom = 15,
                    PaddingLeft = 50,
                    PaddingRight = 50,
                    Border = 0
                };

                var pdfCellRightLogo = new PdfPCell(paraRightLogo)
                {
                    HorizontalAlignment = Element.ALIGN_RIGHT,
                    VerticalAlignment = Element.ALIGN_TOP,
                    PaddingTop = 70,
                    PaddingBottom = 15,
                    PaddingLeft = 50,
                    PaddingRight = 50,
                    Border = 0
                };

                //set the alignment of all two cells and set border to 0                
                //add all two cells into PdfTable                
                pdfTableHeader.AddCell(pdfCellLeftLogo);
                pdfTableHeader.AddCell(pdfCellRightLogo);
                document.Add(pdfTableHeader);
                base.OnStartPage(writer, document);
            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }
        }
    }

}
