<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="UETrack.Application.Web.ReportDashboard.Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title><%: Page.Title %> - My ASP.NET Application</title>
    <link href="../js/datetimepicker-master/jquery.datetimepicker.css" rel="stylesheet" />
    <link href="../css/bootstrap.min.css" rel="stylesheet" />
    <link href="../css/bootstrap-theme.min.css" rel="stylesheet" />
    <link href="../css/style.css" rel="stylesheet" />
    <link href="~/favicon.ico" rel="shortcut icon" type="image/x-icon" />
    <script type="text/javascript" src="../Scripts/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="../js/datetimepicker-master/jquery.datetimepicker.js"></script>
    <script src="../Scripts/ng/common/page-message.js"></script>
    <style type="text/css">
        .PaginationCtrl td {
            padding: 8px 3px;
        }

        #rptViewer_ctl09 {
            height: 500px !important;
            position: absolute;
            overflow: auto;
        }
    </style>
</head>
<body>
    <form runat="server">
        <div class="error_title" id="errorTitle" runat="server" visible="false">
            Unable to load report
        </div>
        <hr />
        <%--<div class="error" id="errorDetail" runat="server" visible="false">
            An error occured while loading report. Please contact the system administrator!
        </div>--%>
        <br />

        <asp:ScriptManager ID="ScriptManager" runat="server" EnablePartialRendering="true"></asp:ScriptManager>
        <!-- Use an UpdatePanel to contain the custom toolbar items. While the page only contains the custom toolbar and the ReportViewer control, a trigger 
             is defined here so that in case there are other UpdatePanel controls, the custom toolbar is only updated by changes in the ReportViewer control. 
             Also, both the enabled and disabled buttons are defined. At run time the client-side code will toggle the visibility of the buttons accordingly.
             NOTE: If there are other controls on your page that cause changes in the ReportViewer on asynchronous postbacks, you should add them here as 
             triggers, or call UpdatePanel.Update() in the code behind to force the toolbar to be updated. -->
        <asp:UpdatePanel ID="ToolBarPanel" runat="server" UpdateMode="Conditional">
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="rptViewer" />
            </Triggers>
            <ContentTemplate>
                <div class="container-fluid">
                    <div class="row">
                        <div class="col-sm-12">
                            <div class="container-fluid" <%--style="margin: 10px 10px 10px 0px;"--%>>
                                <asp:PlaceHolder ID="rptFilterToggle" runat="server"></asp:PlaceHolder>
                            </div>
                            <asp:Panel ID="rptFilterPanel" runat="server">
                                <asp:PlaceHolder ID="rptPreviousFilter" runat="server"></asp:PlaceHolder>
                                <asp:PlaceHolder ID="rptFilterHolder" runat="server"></asp:PlaceHolder>
                                <%-- <div class="container-fluid" style="margin: 10px 10px 10px 0px;display:none;">--%>
                                <asp:PlaceHolder ID="rptFilterSearch" runat="server"></asp:PlaceHolder>
                                <%-- </div>--%>
                            </asp:Panel>                            
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-12 errMsg" style="color: red; display:none;">
                            <ul class="errormsgcenter">
                                
                            </ul>

                        </div>
                    </div>
                    <div class="row">

                        <div class="col-sm-12">


                            <!-- Hide the default toolbar in the ReportViewer control. -->
                            <rsweb:ReportViewer
                                ID="rptViewer"
                                runat="server"
                                Width="100%"
                                ShowToolBar="true"
                                ShowRefreshButton="true"
                                ShowPageNavigationControls="true"
                                ShowFindControls="false"
                                ShowBackButton="true"
                                ShowPrintButton="true"
                                KeepSessionAlive="true"
                                SizeToReportContent="false"
                                AsyncRendering="false"
                                OnDrillthrough="rptViewer_Drillthrough"
                                OnBack="rptViewer_Back"
                                OnReportRefresh="rptViewer_ReportRefresh" />

                        </div>
                    </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </form>
</body>
</html>


<script type="text/javascript">
    var AsisReportModule = {
        SetDatePicker: function () {
            $(".datePicker").datetimepicker({
                datepicker: true,
                timepicker: false,
                format: 'd-M-Y',
                yearStart: 1997
                
            });
        },
        SetDateTimePicker: function () {
            $(".dateTimePicker").datetimepicker({
                datepicker: true,
                timepicker: true,
                format: 'd-M-Y H:i',
                yearStart: 1997
            });
        }
    };

    $(function () {
        AsisReportModule.SetDatePicker();
        AsisReportModule.SetDateTimePicker();
    });

    var prm = Sys.WebForms.PageRequestManager.getInstance();    
    prm.add_endRequest(function () {
        AsisReportModule.SetDatePicker();
        AsisReportModule.SetDateTimePicker();
    });


    function pageLoad() {

        //$('td > div').each(function () {
        //    if ($(this).html() == 'ž') {                

        //        $(this).html('◉');                
        //    }

        //    if ($(this).html() == '™') {

        //        $(this).html('⚪');
        //    }
        //});
      
        //$('div').contents(':contains("™")')[0].nodeValue = '"Hi I am replace"';
        

        /** This is an example of promt box   ***/
        /*var tenure = prompt("Please enter preferred tenure in years", "15");
          if (tenure != null) {
          alert("You have entered " + tenure + " years");
          }  
        $("div").removeClass("xdsoft_scroller");*/


        $('body').on('contextmenu', 'div[id*=rptViewer]', function (e) {
            e.preventDefault();
            //or return false; does the same
        });

        /** This is for datepicker   ***/
     
     /*   $(".xdsoft_prev").click(function () {            

            var curYear = $("div.xdsoft_label.xdsoft_year").find("span").html();
            var curMonth = $(".xdsoft_current").attr("data-value");            
            if (curMonth == 0 && curYear == 1997 || curYear < 1997 )
            { 
                // $(".xdsoft_prev").attr("disabled", true);
               // $("div.xdsoft_label.xdsoft_year").find("span").html('999');
                $(".datePicker").datetimepicker({
                    timepicker: false,
                    closeOnDateSelect: true,                    
                    scrollMonth: false,
                    scrollInput: false,
                    yearStart: 1997,
                    prevButton: false,
                    monthChangeSpinner: false
                });

                $(".dateTimePicker").datetimepicker({
                    timepicker: false,
                    closeOnDateSelect: true,                    
                    scrollMonth: false,
                    scrollInput: false,
                    yearStart: 1997,
                    prevButton: false,
                    monthChangeSpinner: false
                });
                
            }            

        });

        $(".xdsoft_next").click(function () {

            var curYear = $("div.xdsoft_label.xdsoft_year").find("span").html();
            if (curYear >= 1997) {

                $(".datePicker").datetimepicker({
                    timepicker: false,
                    closeOnDateSelect: true,                   
                    scrollMonth: true,
                    scrollInput: true,
                    yearStart: 1997,
                    prevButton: true,
                    monthChangeSpinner: true

                });

                $(".dateTimePicker").datetimepicker({
                    timepicker: false,
                    closeOnDateSelect: true,                    
                    scrollMonth: true,
                    scrollInput: true,
                    yearStart: 1997,
                    prevButton: true,
                    monthChangeSpinner: true
                });

            }
            
        });*/


        var ReportKey = '<%= Session["ReportKeyId"].ToString() %>' == null ? "" : '<%= Session["ReportKeyId"].ToString() %>';
      

        var ID = ['VM001', 'VM002', 'VM003', 'VM004', 'VM005', 'VM006', 'VM007', 'VM008', 'VM009', 'VM010', 'VM011', 'VM012', 'VM013', 'VM014', 'VM015', 'VM016', 'VM017', 'VM018'];
        
        if ($("div[id*=rptViewer] select[title=Zoom]").length > 0) {
            $("div[id*=rptViewer] select[title=Zoom]").parents('div').first().css("display", "none");
        }
        if ($("table[title='Print']").length > 0) {
            $("table[title='Print']").css("display", "none");
        }
        $("div[id*=rptViewer] input[id*=CurrentPage]").on("keypress", function (event) { return numericValidation(event); });

        $("#RollOver_ID").on("keypress", function (event) { return numericValidation(event); });

        var ddl = $("div[id*=rptViewer] #rptViewer_fixedTable div[id*=Menu]")[0];
        
        if (ddl) {

            var rest = ID.indexOf(ReportKey) == -1 ? false : true;           
            
            if (rest) {
                if (ddl.childNodes[7]) { ddl.removeChild(ddl.childNodes[7]); }
                if (ddl.childNodes[6]) { ddl.removeChild(ddl.childNodes[6]); }
                if (ddl.childNodes[5]) { ddl.removeChild(ddl.childNodes[5]); }//excel
                if (ddl.childNodes[4]) { ddl.removeChild(ddl.childNodes[4]); }                
                if (ddl.childNodes[2]) { ddl.removeChild(ddl.childNodes[2]); }
                if (ddl.childNodes[1]) { ddl.removeChild(ddl.childNodes[1]); }
            }

            else {
                if (ddl.childNodes[7]) { ddl.removeChild(ddl.childNodes[7]); }
                if (ddl.childNodes[6]) { ddl.removeChild(ddl.childNodes[6]); }
                if (ddl.childNodes[4]) { ddl.removeChild(ddl.childNodes[4]); }
                if (ddl.childNodes[2]) { ddl.removeChild(ddl.childNodes[2]); }
                if (ddl.childNodes[1]) { ddl.removeChild(ddl.childNodes[1]); }
            }
            
        }
    }

    function numericValidation(e) {
        var charCode;
        if (window.event) {
            charCode = window.event.keyCode;
        }
        else if (e) {
            charCode = e.which;
        }
        else { return true; }
        if ((charCode > 47 && charCode < 58) || (charCode == 8) || (charCode == 127) || (charCode == 37) || (charCode == 39))
            return true;
        else
            return false;
    }

    function Redirect() {
        window.parent.location.href = window.parent.location.href;
    }
    function Redirecttohome() {
        // alert('You are redirected to the home page because service / company / location is changed in another tab')
        //document.write('You are redirected to the home page because service / company / location is changed in another tab');
        window.parent.location.href = '/home?r=mts';
    }

    

    function ValidateDateFilter() {
        var txtFromDt = $("#From_Date");
        var txtToDt = $("#To_Date");

        var ddlFromMonth = $("#From_Month");
        var ddlToMonth = $("#To_Month");

        var ddlFromYear = $("#From_Year");
        var ddlToYear = $("#To_Year");

        var ddlFromPeriod = $("#From_Period");
        var ddlToPeriod = $("#To_Period");

        var ddlYear = $("#Year");
        
        $(".errormsgcenter").empty();     

        if ($(txtFromDt).hasClass("datePicker") && $(txtToDt).hasClass("datePicker")) {
            var fromDt = new Date($(txtFromDt).val().replace(/-/g, ' '));
            var toDt = new Date($(txtToDt).val().replace(/-/g, ' '));           
            
            if ($("#Frequency").val() == "range")
            {
                if($(txtFromDt).val().trim().length == 0)
                    $(".errormsgcenter").append("<li>" + Messages.Report_FromDt_Required + "</li>");

                if ($(txtToDt).val().trim().length == 0)
                    $(".errormsgcenter").append("<li>" + Messages.Report_ToDt_Required + "</li>");

                if ($(".errormsgcenter li").length > 0) {
                    $(".errMsg").css("display", "block");
                    return false;
                }
            }

            if ($("#Year").length > 0 )
            {
                var fromDtYear = fromDt.getFullYear();
                var toDtYear = toDt.getFullYear();
                
                if (!isNaN(fromDtYear) && $("#Year").val() != fromDtYear)
                {
                    $(".errormsgcenter").append("<li>" + Messages.Report_Year_FromDt_Validation + "</li>");
                }
                if (!isNaN(toDtYear) && $("#Year").val() != toDtYear) {
                    $(".errormsgcenter").append("<li>" + Messages.Report_Year_ToDt_Validation + "</li>");
                }
                if (fromDt > toDt) {
                    $(".errormsgcenter").append("<li>" + Messages.Report_Date_Validation + "</li>");  
                }

                if ($(".errormsgcenter li").length > 0)
                {
                    $(".errMsg").css("display", "block");
                    return false;
                }   
            }
            else if (fromDt > toDt) {
                $(".errormsgcenter").append("<li>" + Messages.Report_Date_Validation + "</li>");
                $(".errMsg").css("display", "block");
                return false;
            }
        }

        if ($(ddlFromMonth).length > 0 && $(ddlToMonth).length > 0 && $(ddlYear).length > 0)
        {
            var fromMonth = $(ddlFromMonth).val();
            var toMonth = $(ddlToMonth).val();

            if(parseInt(fromMonth) > parseInt(toMonth))
            {
                $(".errormsgcenter").append("<li>" + Messages.Report_Month_Validation + "</li>");
                $(".errMsg").css("display", "block");
                return false;
            }
        }

        if ($(ddlFromYear).length > 0 && $(ddlToYear).length > 0) {

            var fromYear = $(ddlFromYear).val();
            var toYear = $(ddlToYear).val();     

            if (parseInt(fromYear) > parseInt(toYear)) {

                $(".errormsgcenter").append("<li>" + Messages.Report_Year_Validation + "</li>");
                $(".errMsg").css("display", "block");
                return false;
            }
        }

        if ($(ddlFromYear).length > 0 && $(ddlToYear).length > 0 && $(ddlFromMonth).length > 0 && $(ddlToMonth).length > 0) {

            var fromYear = $(ddlFromYear).val();
            var toYear = $(ddlToYear).val();
            var fromMonth = $(ddlFromMonth).val();
            var toMonth = $(ddlToMonth).val();

            if (parseInt(fromYear) == parseInt(toYear)) {               

                if(parseInt(fromMonth) > parseInt(toMonth))
                {
                    $(".errormsgcenter").append("<li>" + Messages.Report_Month_Validation + "</li>");
                    $(".errMsg").css("display", "block");
                    return false;
                }
            }

            if (parseInt(fromYear) > parseInt(toYear)) {               

                $(".errormsgcenter").append("<li>" + Messages.Report_Year_Validation + "</li>");
                $(".errMsg").css("display", "block");
                return false;
            }
        }



        if($(ddlFromYear).length > 0 && $(ddlToYear).length > 0 && $(ddlFromPeriod).length > 0 && $(ddlToPeriod).length > 0)
        {
            var fromYear = $(ddlFromYear).val();
            var toYear = $(ddlToYear).val();
            var fromPeriod = $(ddlFromPeriod).val();
            var toPeriod = $(ddlToPeriod).val();           

            if(fromPeriod == "h2" && toPeriod == "h1")
            {
                $(".errormsgcenter").append("<li>" + Messages.Report_Period_Validation + "</li>");
                $(".errMsg").css("display", "block");

                if (parseInt(fromYear) > parseInt(toYear)) {
                    $(".errormsgcenter").append("<li>" + Messages.Report_Year_Validation + "</li>");
                    $(".errMsg").css("display", "block");                    
                }
                return false;
            }
            else if (fromPeriod == "h1" && toPeriod == "h2")
            {
                if (parseInt(fromYear) > parseInt(toYear)) {
                    $(".errormsgcenter").append("<li>" + Messages.Report_Year_Validation + "</li>");
                    $(".errMsg").css("display", "block");
                    return false;
                }
            }
            else if (fromPeriod == toPeriod)
            {
                if (parseInt(fromYear) > parseInt(toYear)) {
                    $(".errormsgcenter").append("<li>" + Messages.Report_Year_Validation + "</li>");
                    $(".errMsg").css("display", "block");
                    return false;
                }
            }

        }

        $(".errormsgcenter").empty();
        $(".errMsg").css("display", "none");
        return true;
    }
</script>