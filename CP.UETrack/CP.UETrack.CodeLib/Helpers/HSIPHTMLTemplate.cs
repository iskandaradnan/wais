using CP.Framework.Common.StateManagement;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;

namespace CP.UETrack.CodeLib.Helpers
{
    public class HSIPHTMLTemplate
    {
        static readonly StringBuilder HTMLContent;
        static readonly StringBuilder objFilter;
        static string HtmlTemplate;
        static List<string> CommonProperties;
        static HSIPHTMLTemplate()
        {
            HTMLContent = new StringBuilder();
            objFilter = new StringBuilder();
            HtmlTemplate = GetRawTemplate();
            CommonProperties = new List<string>();
            CommonProperties.Add("IsChecked");
            CommonProperties.Add("IsDeleted");
            CommonProperties.Add("PageIndex");
            CommonProperties.Add("PageSize");
            CommonProperties.Add("TotalRecords");
            CommonProperties.Add("totalPages");
            CommonProperties.Add("PK_Id");
        }
        public static string GetHmtlContent(List<string> Header, string reportName, int ReportLookUpId, int DocumentType = 0)
        {
            var cacheKey = string.Format("hsip_download_{0}", reportName);

            var cacheProvider = new DefaultCacheProvider();
            string htmlContent = null;
            if (DocumentType == 0)
            {
                var headers = GetTableHeaders(Header, DocumentType);
                htmlContent = string.Format(HtmlTemplate, headers, GetFilters(Header, DocumentType), GetDataRows(Header));
            }
            else if (DocumentType == 1)
            {
                htmlContent = FileUpload(ReportLookUpId.ToString());
            }
            else if (DocumentType == 2)
            {
                htmlContent = ImageUpload(ReportLookUpId.ToString());
            }
            else if (DocumentType == 3)
            {
                var headers = GetTableHeaders(Header, DocumentType);
                htmlContent = string.Format(HtmlTemplate, headers, GetFilters(Header, DocumentType), Grid_Attachment(Header, DocumentType));
            }
            else if (DocumentType == 4)
            {
                htmlContent = GetBasicHospital_Data(ReportLookUpId.ToString());
            }
            return htmlContent;
        }

        static string GetRawTemplate()
        {
            var sb = new StringBuilder();

            sb.Append("<div>");
            sb.Append("<div class='table-responsive'>");
            sb.Append("<table id='dataTableCheckList' class='table table-fixedheader table-bordered'>");
            sb.Append("<thead>");
            sb.Append("<tr height='46px'>");
            sb.Append("{0}");
            sb.Append("</tr>");
            sb.Append("</thead>");
            sb.Append("<tr>");
            sb.Append("{1}");
            sb.Append("</tr>");
            sb.Append("{2}");
            sb.Append("</table>");
            sb.Append("</div>");
            sb.Append("</div>");

            return sb.ToString();
        }

        static bool IsNg_ModelShow(string obj)
        {
            return obj.Contains("PageIndex") || obj.Contains("PageSize") || obj.Contains("TotalRecords") || obj.Contains("totalPages") ? false : true;
        }

        static string ColumnHeaderDict(string objColumnName)
        {
            if (objColumnName.Equals("Staff No"))
            {
                return "Staff No.";
            }
            else if (objColumnName.Contains("Asset No"))
            {
                return "Asset No.";
            }
            else if (objColumnName.Contains("Subcontractor Name_ Vendor"))
            {
                return "Subcontractor Name / Vendor";
            }
            else if (objColumnName.Contains("Size_ Area_sqm"))
            {
                return "Size/Area (Sq m)";
            }
            else if (objColumnName.Contains("Typeof Facility"))
            {
                return "Type of Facility";
            }
            else if (objColumnName.Contains("Item_ Part No"))
            {
                return "Item/Part No.";
            }
            else if (objColumnName.Contains("Item_ Part Description"))
            {
                return "Item/Part Description";
            }
            else if (objColumnName.Contains("Certificate No"))
            {
                return "Certificate No.";
            }
            else if (objColumnName.Equals("Staff I D_ Employee I D"))
            {
                return "Staff ID / Employee ID";
            }
            else if (objColumnName.Equals("B E R Reference No"))
            {
                return "BER Reference No.";
            }
            else if (objColumnName.Equals("R W Reference"))
            {
                return "RW Reference";
            }
            else if (objColumnName.Equals("Date R W Approval"))
            {
                return "Date RW Approval";
            }
            else if (objColumnName.Equals("Approved R W Price"))
            {
                return "Approved RW Price";
            }
            else if (objColumnName.Equals("B E R Status"))
            {
                return "BER Status";
            }
            else if (objColumnName.Equals("Ber Reference No"))
            {
                return "BER Reference No.";
            }
            else if (objColumnName.Equals("Staffid_ Employeeid"))
            {
                return "StaffID / EmployeeID";
            }
            else if (objColumnName.Equals("C A Reference No"))
            {
                return "CA Reference No.";
            }
            else if (objColumnName.Equals("Purchase Cost R M"))
            {
                return "Purchase Cost RM";
            }
            else if (objColumnName.Equals("Schedule1 Time"))
            {
                return "Schedule 1 Time";
            }
            else if (objColumnName.Equals("Schedule2 Time"))
            {
                return "Schedule 2 Time";
            }
            else if (objColumnName.Equals("Schedule3 Time"))
            {
                return "Schedule 3 Time";
            }
            else if (objColumnName.Equals("Schedule4 Time"))
            {
                return "Schedule 4 Time";
            }
            else if (objColumnName.Equals("Indicator No"))
            {
                return "Indicator No.";
            }
            else if (objColumnName.Equals("Floor Area_ Sq_m_"))
            {
                return "Floor Area (Sq. m)";
            }
            else if (objColumnName.Equals("Floor Type"))
            {
                return "Floor type";
            }
            else if (objColumnName.Equals("No Of Location"))
            {
                return "No. of Location";
            }
            else if (objColumnName.Contains("Contact No"))
            {
                return "Contact No.";
            }
            else if (objColumnName.Contains("No Of Washing Machines"))
            {
                return "No of Washing Machines";
            }
            else if (objColumnName.Equals("Area Of Expertise"))
            {
                return "Area of Expertise";
            }
            else if (objColumnName.Equals("List Of Training Attended"))
            {
                return "List of Training Attended";
            }
            else if (objColumnName.Equals("Rolesand Responsibilitiesof The Key Personnel"))
            {
                return "Roles and Responsibilities of The Key Personnel";
            }
            else if (objColumnName.Equals("Delivery Time1"))
            {
                return "Delivery Time 1";
            }
            else if (objColumnName.Equals("Delivery Time2"))
            {
                return "Delivery Time 2";
            }
            else if (objColumnName.Equals("Delivery Time3"))
            {
                return "Delivery Time 3";
            }
            else if (objColumnName.Equals("Collection Time1"))
            {
                return "Collection Time 1";
            }
            else if (objColumnName.Equals("Collection Time2"))
            {
                return "Collection Time 2";
            }
            else if (objColumnName.Equals("Collection Time3"))
            {
                return "Collection Time 3";
            }
            else if (objColumnName.Equals("Advisory Service No"))
            {
                return "Advisory Service No.";
            }
            else if (objColumnName.Equals("Dateof Raising"))
            {
                return "Date of Raising";
            }
            else if (objColumnName.Equals("Locationof Particular C A"))
            {
                return "Location of Particular CA";
            }
            else if (objColumnName.Equals("Collectionfrequency"))
            {
                return "Collection frequency";
            }
            else if (objColumnName.Equals("Delivery Time1s Window"))
            {
                return "Delivery Time 1st Window (Clean Linen) ";
            }
            else if (objColumnName.Equals("Delivery Time2 Window"))
            {
                return "Delivery Time 2nd Window (Clean Linen) ";
            }
            else if (objColumnName.Equals("Delivery Time3 Window"))
            {
                return "Delivery Time 3rd  Window (Clean Linen)  ";
            }
            else if (objColumnName.Equals("Collection Time1st"))
            {
                return "Collection Time 1st Window (Soiled Linen) ";
            }
            else if (objColumnName.Equals("Collection Time2st"))
            {
                return "Collection Time 2nd Window (Soiled Linen)";
            }
            else if (objColumnName.Equals("Collection Time3st"))
            {
                return "Collection Time 3rd Window (Soiled Linen) ";
            }
            else if (objColumnName.Equals("Q C Code"))
            {
                return "QC Code";
            }
            else if (objColumnName.Contains("Defect No"))
            {
                return "Defect No.";
            }
            else if (objColumnName.Contains("Tand C Document No"))
            {
                return "T&C Document No.";
            }
            else if (objColumnName.Contains("Building No"))
            {
                return "Building No.";
            }
            else if (objColumnName.Contains("Primary Laundry Plant Facility Code"))
            {
                return "Primary Laundry Plant/Facility Code.";
            }
            else if (objColumnName.Contains("Primary Laundry Plant Facility Name"))
            {
                return "Primary Laundry Plant/Facility Name";
            }
            else if (objColumnName.Contains("Secondary Laundry Plant Facility Code"))
            {
                return "Secondary Laundry Plant/Facility Code.";
            }
            else if (objColumnName.Contains("Secondary Laundry Plant Facility Name"))
            {
                return "Secondary Laundry Plant/Facility Name";
            }
            else if (objColumnName.Contains("Noof Trolley Clean"))
            {
                return "No. of Trolley Clean.";
            }
            else if (objColumnName.Contains("Noof Trolley Soiled"))
            {
                return "No. of Trolley Soiled.";
            }
            else if (objColumnName.Contains("User Area Code"))
            {
                return "User Department/Area Code";
            }
            else if (objColumnName.Contains("User Area Name"))
            {
                return "User Department/Area Name";
            }
            else if (objColumnName.Contains("White Bag"))
            {
                return "WhiteBag (Pcs)";
            }
            else if (objColumnName.Contains("Red Bag"))
            {
                return "RedBag (Pcs)";
            }
            else if (objColumnName.Contains("Green Bag"))
            {
                return "GreenBag (Pcs)";
            }
            else if (objColumnName.Contains("Brown Bag"))
            {
                return "BrownBag (Pcs)";
            }
            else if (objColumnName.Contains("Alginate Bag"))
            {
                return "AlginateBag (Pcs)";
            }
            else if (objColumnName.Contains("Soiled Linen Bag Holder"))
            {
                return "Soiled Linen BagHolder (Unit)";
            }
            else if (objColumnName.Contains("Reject Linen Bag Holder"))
            {
                return "Reject Linen BagHolder (Unit)";
            }
            else if (objColumnName.Contains("Soiled Linen Rack"))
            {
                return "Soiled Linen Rack (Unit)";
            }
                return objColumnName;           
        }
        static string GetTableHeaders(List<string> Header, int objDocumentType)
        {
            var sb = new StringBuilder();
            objFilter.Clear();

            var headerWidth = Decimal.Divide(97, (Header.Except(CommonProperties).Count()));
            var headerWidthAttach = Decimal.Divide(100, (Header.Except(CommonProperties).Count()));
            var columnWidth = objDocumentType == 0 || objDocumentType == 3 ? headerWidth : headerWidthAttach;

            foreach (var x in Header.Select((value, index) => new { value, index }))
            {
                var IsShow = IsNg_ModelShow(x.value);
                if (IsShow)
                {
                    var objHeaderWithSpace = Regex.Replace(x.value, "(\\B[A-Z])", " $1");
                    objHeaderWithSpace = ColumnHeaderDict(objHeaderWithSpace);
                    if (x.index == 0)
                    {
                        if (objDocumentType == 0)
                        {
                            sb.Append("<th width='3%' height='52px' class='text-center'><input type='checkbox' onclick='angular.element(this).scope().IsSelectAll(angular.element(this).scope().Collections);' ng-disabled='isDisabled' ng-model='isCheckedAll'></th>");
                            sb.Append("<th width='" + columnWidth + "%' height='52px' class='text-center'>" + objHeaderWithSpace + "</th>");
                            objFilter.Append("" + x.value + ":Search.Filter" + x.index + ",");
                        }
                        else if (objDocumentType == 3)
                        {
                            sb.Append("<th width='3%' height='46px' class='text-center'><input type='checkbox' onclick='angular.element(this).scope().IsSelectAll(angular.element(this).scope().Collections);' ng-disabled='isDisabled' ng-model='isCheckedAll'></th>");
                            sb.Append("<th width='" + columnWidth + "%' height='46px' class='text-center'>" + objHeaderWithSpace + "</th>");
                            objFilter.Append("" + x.value + ":Search.Filter" + x.index + ",");
                        }
                    }
                    else
                    {
                        if (!(x.value == "IsChecked" || x.value == "PK_Id"))
                        {
                            objFilter.Append("" + x.value + ":Search.Filter" + x.index + ",");
                            sb.Append("<th width='" + columnWidth + "%' height='52px' class='text-center'>" + objHeaderWithSpace + "</th>");
                        }
                    }
                }
            }
            return sb.ToString();
        }
        static string GetFilters(List<string> Header, int objDocumentType)
        {
            var sb = new StringBuilder();

            var headerWidth = Decimal.Divide(97, (Header.Except(CommonProperties).Count()));
            var headerWidthAttach = Decimal.Divide(100, (Header.Except(CommonProperties).Count()));
            var columnWidth = objDocumentType == 0 || objDocumentType == 3 ? headerWidth : headerWidthAttach;

            foreach (var z in Header.Select((value, index) => new { value, index }))
            {
                var NgModel = Header.ElementAt(z.index).ToString().Trim();
                var IsShow = IsNg_ModelShow(z.value);
                var objFilterWithSpace = Regex.Replace(z.value, "(\\B[A-Z])", " $1");
                objFilterWithSpace = ColumnHeaderDict(objFilterWithSpace);
                // objFilterWithSpace = ColumnHeaderDict(objFilterWithSpace);
                if (IsShow)
                {
                    if (z.index == 0)
                    {
                        if (objDocumentType == 0)
                        {
                            sb.Append("<td width='3%' height='46px'>");
                            sb.Append("</td>");
                            //sb.Append("<td>");
                            //sb.Append("</td>");
                            sb.Append("<td width='" + columnWidth + "%' height='46px'>");
                            //+objFilterWithSpace + "
                            sb.Append("<input  ng-disabled='IsDisable' unique-cols=" + NgModel + " ng-change='ApplyFilter(this," + z.index + ")' ng-model='Search.Filter" + z.index + "' placeholder ='Search For..' class='form-control' type='text' title='" + objFilterWithSpace + "'>");
                            sb.Append("</td>");
                        }
                        else
                        {
                            sb.Append("<td width='3%' height='46px'>");
                            sb.Append("</td>");
                            sb.Append("<td width='" + columnWidth + "%' height='46px'>");
                            //" + objFilterWithSpace + "
                            sb.Append("<input  ng-disabled='IsDisable' unique-cols=" + NgModel + " ng-change='ApplyFilter(this," + z.index + ")' ng-model='Search.Filter" + z.index + "' placeholder ='Search For..' class='form-control' type='text' title='" + objFilterWithSpace + "'>");
                            sb.Append("</td>");
                        }
                    }
                    else
                    {
                        if (!(z.value == "IsChecked" || z.value == "PK_Id"))
                        {
                            if (z.value == "Download")
                            { // Remove Filter when Column name is Download
                                sb.Append("<td width='" + columnWidth + "%' height='46px'>");
                                sb.Append("</td>");
                            }
                            else
                            {
                                sb.Append("<td width='" + columnWidth + "%' height='46px'>");
                                //" + objFilterWithSpace + "
                                sb.Append("<input ng-disabled='IsDisable' ng-model='Search.Filter" + z.index + "' ng-change='ApplyFilter(this," + z.index + ")' placeholder ='Search For..' class='form-control' type='text' title='" + objFilterWithSpace + "'>");
                                sb.Append("</td>");
                            }
                        }
                    }
                }

            }
            return sb.ToString();
        }
        static string ImageUpload(string ReportLookUpId)
        {
            var sb = new StringBuilder();
            sb.Append("<div class='table-responsive'>");
            #region Row
            sb.Append("<div class='row'>");
            #region Image Browse Content
            sb.Append("<div class='col-sm-2'>");
            sb.Append("<label class=\"col-sm-12 control-label\">Organization Chart<span class=\"red\"> *</span></label>");
            sb.Append("</div>");
            sb.Append("<div class=\"col-sm-10\">");
            sb.Append("<div class=\"form-group\">");
            //angular.element(this).scope().getImageeDetails(this, 0, angular.element(this).scope().Collections)
            sb.Append(" <input id='file' name='" + ReportLookUpId + "' class='form-con/trol' required type='file' accept='image/*' onchange=' angular.element(this).scope().getFileDetails(this, 0, angular.element(this).scope().Collections,2)' />");
            sb.Append("</div>");
            sb.Append("</div>");
            sb.Append("</div>");
            #endregion
            #region Remarks
            sb.Append("<div class='col-sm-2'>");
            sb.Append("<label class=\"col-sm-7 control-label\">Remarks<span class=\"red\"></span></label>");
            sb.Append("</div>");
            sb.Append("<div class=\"col-sm-10\">");
            sb.Append("<div class=\"form-group\">");
            sb.Append("<textarea maxlength=\"500\" type=\"text\" only-description id = \"Remarks\" name =\"Remarks\" rows=\"2\" cols=\"50\" ng-model = \"Remarks\" class=\"form-control\" required autocomplete =\"off\" />");
            sb.Append("</div>");
            sb.Append("</div>");
            sb.Append("</div>");
            #endregion
            sb.Append("</div>");
            #endregion

            sb.Append(" <div class=\"row\">");
            #region Image Contant
            sb.Append("<div class=\"col-xs-6 col-sm- 12\">");
            sb.Append("<img id = \"chart\" alt =\"Image\" data-toggle =\"modal\" data-target = \"#empPhoto\" />");
            sb.Append("</div>");
            #endregion
            sb.Append("</div>");
            sb.Append("</div>");

            sb.Append("<div class=\"tab-content\">");
            sb.Append("<div id =\"tab-companySiteOfficeProfile\" class=\"tab-pane fade in active\">");
            sb.Append("<form class=\"form-horizontal\" name=\"formOne\" id=\"formOne\" novalidate>");
            sb.Append("<div id = \"empPhoto\" class=\"modal fade\" role=\"dialog\">");
            sb.Append("<div class=\"col-sm-10\">");//modal-dialog

            sb.Append("<div  class=\"modal-content\">");
            sb.Append("<div class=\"modal-header\">");

            sb.Append("<button type =\"button\" class=\"close\" ng-click=\"SubChildPopUpHide()\">&times;</button>");
            sb.Append("<h4 class=\"modal-title\">Organization Chart</h4>");

            sb.Append("<div class=\"modal-body\">");

            sb.Append("<img id =\"chart1\" alt= \"Organization Chart\" style= \"width:100%;height:100%;\" />");

            sb.Append("<div class=\"text-center paddingTop\">");

            sb.Append("<button type =\"button\" class=\"btn btn-grey\" ng-click=\"SubChildPopUpHide()\">Close</button>");

            sb.Append("</div>");

            sb.Append("</div>");
            sb.Append("</div>");



            sb.Append("</div>");

            sb.Append("</div>");

            sb.Append("</div>");

            sb.Append("</div>");
            sb.Append("</div>");
            sb.Append("</form>");
            sb.Append("</div>");
            sb.Append("</div>");

            return sb.ToString();
        }
        static string FileUpload(string ReportLookUpId)
        {
            var sb = new StringBuilder();
            //foreach (var x in objAttachment.Select((value, index) => new { value, index }))
            //{

            //// Table Header
            //sb.Append("<table class='table table-striped table-bordered alignCenter'>");
            //sb.Append("<thead class='tableHeading'>");
            //sb.Append("<tr>");
            //sb.Append("<th class='text-center' width='70 %' colspan='2'>" + Title + "</th>");
            //sb.Append("</tr>");
            //sb.Append("</thead>");
            //sb.Append("</table>");


            sb.Append(" <div class='table-responsive'>");
            sb.Append("<div class='row'>");
            #region Remarks
            sb.Append("<div class='col-sm-1'>");
            sb.Append("<label class=\"col-sm-7 control-label\">Remarks<span class=\"red\"></span></label>");
            sb.Append("</div>");
            sb.Append("<div class=\"col-sm-11\">");
            sb.Append("<div class=\"form-group\">");
            sb.Append("<textarea maxlength=\"500\" type=\"text\" only-description id = \"Remarks\" name =\"Remarks\" rows=\"2\" cols=\"50\" ng-model = \"Remarks\" class=\"form-control\" required autocomplete =\"off\" />");
            sb.Append("</div>");
            sb.Append("</div>");
            sb.Append("</div>");
            #endregion
            sb.Append("</div>");
            sb.Append("<table id='dataTableCheckList' class='table table-bordered'>");
            #region Header
            sb.Append("<thead class='tableHeading'>");
            sb.Append("<tr>");
            //sb.Append("<th width='3%' class='text-center'><span class='glyphicon glyphicon-trash'></span></th>");
            sb.Append("<th width = '30%' height='46px' class='text-center'>File Type <span class='red'>*</span> </th>");
            sb.Append("<th width = '30%' height='46px' class='text-center'>File Name <span class='red'>*</span> </th>");
            sb.Append("<th width = '30%' height='46px' class='text-center'>Attachment<span class='red'>*</span></th>");
            //
            sb.Append("<th width = '10%' height='46px' class='text-center'>Download</th>");
            sb.Append("</tr>");
            sb.Append("</thead>");
            #endregion
            #region Body
            sb.Append("<tbody>");

            sb.Append("<tr ng-repeat='obj in Collections track by $index'>");

            //sb.Append("<td id = 'FileUpload"+ "_{{$index}}'>");
            //sb.Append("<div class='checkbox text-center'>");
            //sb.Append("<label>");
            //sb.Append("<input id ='checkbox' type='checkbox' name='checkboxes' value='{{obj.IsDeleted}}' ng-model='obj.IsDeleted'  ng-disabled = 'IsCheckboxDisabled' ng-change = 'MultipleDelete(this)' > ");
            //sb.Append("<input type = 'hidden' ng-model='fileAttach.ServiceId' ng-init='fileAttach.ServiceId = fileServiceId'>");
            //sb.Append("<input type = 'hidden' ng-model='fileAttach.MenuId' ng-init='fileAttach.MenuId = fileMenuId'>");
            //sb.Append("<input type = 'hidden' ng-model='fileAttach.Islatest'>");
            //sb.Append("</label>");
            //sb.Append("</div>");
            //sb.Append("</td>");
            sb.Append("<td width='30%' height='46px' id='FileUpload" + "_{{$index}}'>");
            sb.Append("<ng-form novalidate name='FileType'>");
            //File Type
            //
            sb.Append("<div>");
            sb.Append("<select class='form-control ' id='ddlFileType' name='FileType' ng-required='obj.isFileTypeRequired'");
            sb.Append("ng-model='obj.FileType' ng-options='f.LovId as f.FieldValue for f in FileTypeList' ng-disabled='IsFileTypeDisabled'></select>");
            sb.Append("</div>");
            sb.Append("</td>");
            //File Name
            sb.Append("<td width='30%' height='46px'>");
            // ng -class='{ 'has-error': FileName.FileName.$invalid && (FileName.FileName.$dirty || isAttachmentsSubmitted)}'
            sb.Append("<div>");
            sb.Append("<input id='fileName' ng-model='obj.FileName' name='FileName' ng-required='obj.isFileNamepRequired' class='form-control required' type='text' autocomplete='off' only-Name maxlength='50' ng-disabled='IsFileNameDisabled'>");
            sb.Append("</div>");
            sb.Append("</td>");
            // Browse 
            sb.Append("<td width='30%' height='46px'>");
            sb.Append("<input type='file' name='" + ReportLookUpId + "' id='file' name='file' accept='application/pdf' ng-disabled='IdFileAttachmentHide' onchange = 'angular.element(this).scope().getFileDetails(this, angular.element(this).scope().$index, angular.element(this).scope().obj,1)' /> ");
            sb.Append("</td>");

            ////Down Load
            sb.Append("<td width='10%' height='46px'>");
            sb.Append("<div>");
            sb.Append("<a href = '' ng-click = 'downloadFiles(obj.ReportLookUpAttachId)' class='glyphicon glyphicon-download-alt' ng-show='IsFileUploadHide' />");
            sb.Append("&nbsp;");
            sb.Append("<a href = '' ng-click='downloadFiles(obj.ReportLookUpAttachId,1)' class='text-nowrap' ng-show='IsFileUploadHide' ng-model='obj.DownloadFileName'>{{obj.DownloadFileName}}</a>");
            sb.Append("</div>");
            sb.Append("</td>");

            sb.Append("</tr");
            sb.Append("</tbody>");
            #endregion
            sb.Append("</table>");
            sb.Append("</div>");
            //}
            return sb.ToString();
        }

        static string Grid_Attachment(List<string> Header, int objDocumentType)
        {
            var sb = new StringBuilder();
            var objFilterContent = "";

            var headerWidth = Decimal.Divide(97, (Header.Except(CommonProperties).Count()));


            sb.Append("<tr ng-show='NoRecordMessage'  ><td colspan='" + Header.Count + "' width='100%' align='center'><h4 class='text-center'> No records to display </h4></td></tr>");
            foreach (var x in Header.Select((value, index) => new { value, index }))
            {
                var NgModel = Header.ElementAt(x.index);
                var IsShow = IsNg_ModelShow(NgModel);
                if (x.index == 0)
                {
                    objFilterContent = objFilter.ToString().Substring(0, objFilter.Length - 1);
                }
                var objFilterWithSpace = Regex.Replace(x.value, "(\\B[A-Z])", " $1");
                //objFilterWithSpace = ColumnHeaderDict(objFilterWithSpace);
                if (IsShow)
                {
                    if (x.index == 0)
                    {
                        //| filter:{ " + objFilterContent + " }
                        sb.Append("<tr ng-repeat='obj in Collections track by $index'>");
                        sb.Append("<td width='3%' height='46px'>");
                        sb.Append("<div class='checkbox text-center'>");
                        sb.Append("<label>");
                        sb.Append("<input id='checkbox' ng-disabled='IsDisable' ng-change='MultipleSelected(this, this.Collections)' type='checkbox' name='checkboxes' value='{{obj.IsChecked}}' ng-model='obj.IsChecked'>");
                        sb.Append("</div>");
                        sb.Append("</label>");
                        sb.Append("</td>");


                        sb.Append("<td width='" + headerWidth + "%' height='46px'>");
                        sb.Append("<input ng-model='::obj." + NgModel + "' disabled  class='form-control  required' autocomplete='off'> ");
                        sb.Append("</td>");
                    }
                    else if (x.value == "Download")
                    {
                        sb.Append("<td width='" + headerWidth + "%' height='46px'>");
                        sb.Append("<div>");
                        sb.Append("<a href = '' ng-click = 'downloadFiles(obj.Download,0,3)' class='glyphicon glyphicon-download-alt' ng-show='IsFileUploadHide' />");
                        sb.Append("&nbsp;");
                        sb.Append("<a href = '' ng-click='downloadFiles(obj.Download,1,3)' class='text-nowrap' ng-show='IsFileUploadHide' ng-model='obj.FileName'>{{obj.FileName}}</a>");
                        sb.Append("</div>");
                        sb.Append("</td>");
                    }
                    else
                    {
                        if (!(x.value == "IsChecked" || x.value == "PK_Id"))
                        {
                            sb.Append("<td width='" + headerWidth + "%' height='46px'>");
                            sb.Append("<input ng-model='obj." + NgModel + "' disabled  class='form-control required' autocomplete='off'> ");
                            sb.Append("</td>");
                        }
                    }
                }
            }
            sb.Append("</tr>");
            return sb.ToString();
        }
        static string GetDataRows(List<string> Header)
        {
            var sb = new StringBuilder();
            string objFilterContent = "";
            var headerWidth = Decimal.Divide(97, (Header.Except(CommonProperties).Count()));

            sb.Append("<tr ng-show='NoRecordMessage'  ><td colspan='" + Header.Count + "' width='100%' align='center'><h4 class='text-center'> No records to display </h4></td></tr>");

            foreach (var x in Header.Select((value, index) => new { value, index }))
            {
                var NgModel = Header.ElementAt(x.index);
                var IsShow = IsNg_ModelShow(NgModel);
                if (x.index == 0)
                {
                    objFilterContent = objFilter.ToString().Substring(0, objFilter.Length - 1);
                }
                var objFilterWithSpace = Regex.Replace(x.value, "(\\B[A-Z])", " $1");
                //objFilterWithSpace = ColumnHeaderDict(objFilterWithSpace);
                if (IsShow)
                {
                    if (x.index == 0)
                    {
                        //| filter:{ " + objFilterContent + " }
                        sb.Append("<tr ng-repeat='obj in Collections | filter:{ " + objFilterContent + " }  track by $index'>");
                        sb.Append("<td width='3%' height='46px'>");
                        sb.Append("<div class='checkbox text-center'>");
                        sb.Append("<label>");
                        sb.Append("<input id='checkbox' ng-disabled='IsDisable' ng-change='MultipleSelected(this, this.Collections)' type='checkbox' name='checkboxes' value='{{obj.IsChecked}}' ng-model='obj.IsChecked'>");
                        sb.Append("</div>");
                        sb.Append("</label>");
                        sb.Append("</td>");
                        sb.Append("<td width='" + headerWidth + "%' height='46px'>");
                        sb.Append("<input ng-model='::obj." + NgModel + "' disabled  class='form-control  required' autocomplete='off'> ");
                        sb.Append("</td>");
                    }
                    else
                    {
                        if (!(x.value == "IsChecked" || x.value == "PK_Id"))
                        {
                            sb.Append("<td width='" + headerWidth + "%' height='46px'>");
                            if (x.value == "NoOfLocation")
                            {
                                sb.Append("<input ng-model='obj." + NgModel + "' disabled number comma class='form-control required' autocomplete='off'> ");
                            }
                            else if (x.value == "FloorArea_Sq_m_")
                            {
                                sb.Append("<input ng-model='obj." + NgModel + "' disabled number comma decimal-length='2'  class='form-control required' autocomplete='off'> ");
                            }
                            else
                            {
                                sb.Append("<input ng-model='obj." + NgModel + "' disabled  class='form-control required' autocomplete='off'> ");
                            }
                            sb.Append("</td>");
                        }
                    }
                }

            }
            sb.Append("</tr>");
            return sb.ToString();
        }
        #region Basic Hospital Data	
        static string GetBasicHospital_Data(string ReportLookUpId)
        {
            var sb = new StringBuilder();
            sb.Append(" <div id=\"HOS\" class=\"tab-pane fade\">");
            sb.Append("<form name=\"formhos\" id=\"formhos\" class=\"form-horizontal\" novalidate>");
            #region New Row
            sb.Append("<div class=\"row\">");
            #region Hospital Code
            sb.Append("<div class=\"col-sm-6\">");
            sb.Append("<div class=\"form-group\">");
            sb.Append("<label class=\"col-sm-6 control-label\">Hospital Code</label>");
            sb.Append("<div class=\"col-sm-6\">");
            sb.Append("Hospital Code");
            sb.Append("</div>");
            sb.Append("</div>");
            sb.Append("</div>");
            #endregion
            #region Hospital Name
            sb.Append("<div class=\"col-sm-6\">");
            sb.Append("<div class=\"form-group\">");
            sb.Append("<label class=\"col-sm-6 control-label\">Hospital Name</label>");
            sb.Append("<div class=\"col-sm-6\">");
            sb.Append("Hospital Name");
            sb.Append("</div>");
            sb.Append("</div>");
            sb.Append("</div>");
            #endregion
            sb.Append("</div>");
            #endregion
            sb.Append("</form>");

            sb.Append("</div>");





            return sb.ToString();
        }
        #endregion
    }

}