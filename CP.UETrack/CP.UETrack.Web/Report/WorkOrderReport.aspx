<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WorkOrderReport.aspx.cs" Inherits="UETrack.Application.Web.Report.WorkOrderReport" %>
<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=12.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title><%: Page.Title %></title>
    <link href="../js/datetimepicker-master/jquery.datetimepicker.css" rel="stylesheet" />
    <link href="../css/bootstrap.min.css" rel="stylesheet" />
    <link href="../css/bootstrap-theme.min.css" rel="stylesheet" />
    <link href="../css/style.css" rel="stylesheet" />
    <link href="~/favicon.ico" rel="shortcut icon" type="image/x-icon" />
    <script type="text/javascript" src="../Scripts/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="../js/datetimepicker-master/jquery.datetimepicker.js"></script>

        <style type="text/css">
        #reportViewer_ctl09 {
            height: 500px !important;
            overflow-y:auto;
        }
        #reportViewer_fixedTable {
            width:100% !important;
        }
    </style>

</head>
<body style="width: 100%; height: 100%;">   
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
        <asp:UpdatePanel ID="ToolBarPanel" runat="server" UpdateMode="Conditional">
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="reportViewer" />
            </Triggers>
            <ContentTemplate>
                <div class="container-fluid">
                        <div class="row">
                            <div class="col-sm-12" style="height:100%;">
                                <rsweb:ReportViewer ID="reportViewer" runat="server"
                                    Width="100%" 
				                    ShowParameterPrompts="false"
                                    ShowToolBar="true"
                                    ShowRefreshButton="false"
                                    ShowPageNavigationControls="true"
                                    ShowFindControls="false"
                                    ShowBackButton="true"                                    
                                    ShowPrintButton="false"                                   
                                    KeepSessionAlive="true"
                                    SizeToReportContent="true"
                                    AsyncRendering ="false"
                                    SizeToReport="true" 									
                                   PageCountMode ="Actual">
                                </rsweb:ReportViewer>
                            </div>
                        </div>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </form>
</body>
</html>
