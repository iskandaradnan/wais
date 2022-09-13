var pageindex = 1, pagesize = 5;
var GridtotalRecords = 0;
var TotalPages = 1, FirstRecord = 0, LastRecord = 0;
var requestupdate = "";
var LOVlist = {};
var ActionType;
var id;

$(document).ready(function () {
    $('#btnDelete').hide();
    $('#btnApprove').hide();
    $('#btnReject').hide();
    $('#btnVerify').hide();
    $('#btnClarify').hide();
    $('#btnEdit').hide();
    $('#crmReqManu').prop('disabled', false);
    $('#Modelrow').show();
    $('#RequestDescDiv').show();
    $('#crmReqPriority').hide();
    $('#Assessment').hide();
    $('#lblCrmpriority').hide();
    $('indicatorDiv').hide();
    $('#crmReqManu').attr('required', false).attr('disabled', false);
    $('#Vaidation').attr('required', false).attr('disabled', false);
    $('#lblcrmAction').hide();
    $('#RequestAction').hide();
    // $('#Responseby').prop('required', false);
    // $('#Responseby').prop('required', true);
    $('#ResponceDateTimeAndResponseby').css('visibility', 'hidden');
    $('#test').show();
    ActionType = $("#ActionType").val();

    if (ActionType == "View") {
        $("#btnConverttoWO,#btnsave,#btnAddNew").hide();
    }

    //if (ActionType == "EDIT") {
    //    $('#btnConverttoWO').css('visibility', 'visible');
    //    $('#btnConverttoWO').show();
    //}

    (ActionType != "Add") ? $("#btnAddNew").hide() : $("#btnAddNew").show();
    id = $("#CRMRequestId").val();
    formInputValidation("Testform");
    var jqxhr = $.get("/api/CRMRequestApi/Load", function (response) {
        var result = response;
        LOVlist = result;
        //$("#jQGridCollapse1").click();
        $(LOVlist.RequestStatusList).each(function (_index, _data) {
            $('#RequestStatus').append($('<option></option>').val(_data.LovId).html(_data.FieldValue))
        });
        $(LOVlist.RequestTypeList).each(function (_index, _data) {
            if (_data.LovId != 133)
                $('#TypeOfRequest').append($('<option></option>').val(_data.LovId).html(_data.FieldValue))
        });
        $(LOVlist.IndicatorList).each(function (_index, _data) {
            $('#TypeOfDeduction').append($('<option></option>').val(_data.LovId).html(_data.FieldValue))
        });
        $(LOVlist.RequestServiceList).each(function (_index, _data) {
            $('#TypeOfServiceRequest').append($('<option></option>').val(_data.LovId).html(_data.FieldValue))
        });
        $(LOVlist.PriorityList).each(function (_index, _data) {
            $('#crmReqPriority').append($('<option></option>').val(_data.LovId).html(_data.FieldValue))
        });
        $.each(LOVlist.WorkGroup, function (index, value) {
            $('#selWorkGroupGM').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
        });
        $.each(LOVlist.WasteCategory, function (index, value) {
            $('#selWasteCategory').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
        });

        $.each(LOVlist.CRMJUstification, function (index, value) {
            $('#JustificationForReason').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
        });
        $('#RequestStatus option[value="' + 139 + '"]').prop('selected', true);

        $('#CrmReqPlus').hide();
        $('#crmReqTarDat').css("background-color", "#fff");
        $('#WorkAssiDiv').css('visibility', 'hidden');
        $('#WorkAssiDiv').hide();

        var today = new Date();
        var CurDate = GetCurrentDate();
        var hour = today.getHours();
        var time = today.getMinutes();
        //  var time = time.toString();

        if (time < 10) {
            time = 0 + '' + time;
        }

        var gettime = hour + ":" + time;

        var CurDateTime = CurDate + " " + gettime;

        $('#RequestDateTime').val(CurDateTime);



        function GetCurrentDateAddDates() {
            var m_names = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];


            var currentDateS = new Date();
            var numberOfDayToAdd = 14;
            currentDateS.setDate(currentDateS.getDate() + numberOfDayToAdd);
            var d = currentDateS;
            var format_date = ("0" + d.getDate()).slice(-2);
            var format_month = d.getMonth();
            var format_year = d.getFullYear();

            return format_date + "-" + m_names[format_month] + "-" + format_year;
        }

        $("#TypeOfRequest").change(function () {

            $('indicatorDiv').hide();
            $('#crmReqModel').prop('required', true);
            $("#lblCrmreqMod").html("Model <span class='red'>*</span>");
            $("#Testform :input:not(:button)").parent().removeClass('has-error');
            $("div.errormsgcenter").text("");
            $('#errorMsg').css('visibility', 'hidden');
            $('#crmReqModel').val('');
            $('#crmReqManu').val('');
            $('#CrmReqUsrAreaCd').val('');
            $('#CrmReqUsrLocCde').val('');
            $('#RequestDescription').val('');
            $('#crmObsoleteSec').css('visibility', 'hidden');
            $('#crmObsoleteSec').hide();
            $('#btnSave').prop('disabled', false);
            $('#btnSaveandAddNew').prop('disabled', false);

            if (this.value == 132) {
                $('#RequestedDateTime').show();
                $('#lblRequestedDateTime').show();
                var today = new Date();
                //var today = currentDateS.setDate(currentDateS.getDate() + numberOfDayToAdd);;
                var CurDate = GetCurrentDateAddDates();
                var hour = today.getHours();
                var time = today.getMinutes();
                //  var time = time.toString();

                if (time < 10) {
                    time = 0 + '' + time;
                }

                var gettime = hour + ":" + time;

                var CurDateTime = CurDate + " " + gettime;

                $('#RequestedDateTime').val(CurDateTime);
            }
            else {
                $('#RequestedDateTime').val('');
                $('#RequestedDateTime').hide();
                $('#lblRequestedDateTime').hide();
            }
            if (this.value == 10809 || this.value == 132 || this.value == 134 || this.value == 374) {
                $("#lblAssetNo").html("Asset No. <span class='red'>*</span>");
            }
            else {
                $("#lblAssetNo").html("Asset No.");
            }

            //$("#RequestedDateTime").val(datestring);

            if (this.value == 137 || this.value == 374) {
                //$('#CrmAssetGrid').css('visibility', 'visible');
                //$('#CrmAssetGrid').show();  
                $('#txtAssetNo').prop('disabled', false);
                $('#TypeOfRequest').focus();
                $('#CrmReqPlus').show();
                $('#crmReqManu').prop('required', false);
                // $("#lblCrmReqmanu").html("Manufacturer <span class='red'>*</span>");
                $('#crmReqModel').prop('required', true);
                $("#lblCrmreqMod").html("Model <span class='red'>*</span>");
                $("#lblCrmReqTarDat").html("Target Date");
                $('#crmReqTarDat').prop('required', false);
                $("#lblCrmreqReqPer").html("Requested Person");
                $('#crmReqReqPer').prop('required', false);
                $('#ResponceDateTime').prop('required', false);
                $('#CompleteDateTime').prop('required', false);
                $('#Completedby').prop('required', false);
                $('#ServiceInd').hide();
                $('#NonConformance').hide();
                //$('#btnSaveConverttoWO').css('visibility', 'visible');
                //$('#btnSaveConverttoWO').show();
                //$('#RequestDescription').prop('required', true);
                //$("#lblcrmReqDesc").html("Request Description <span class='red'>*</span>");
                $('#AreaLocDiv').css('visibility', 'hidden');
                $('#AreaLocDiv').hide();
                $('#ReqTypTCDiv').css('visibility', 'hidden');
                $('#ReqTypTCDiv').hide();
                $('#CrmReqUsrAreaCd').prop('required', false);
                $('#CrmReqUsrLocCde').prop('required', false);
                // $("#CRMRequestGrid").empty();
                // AddNewRowCRMRequest();

                $("#CrmObsoleteFetchSave").css('visibility', 'visible');
                $('#crmObsoleteSec').css('visibility', 'visible');
                $('#crmObsoleteSec').show();
                $('#CrmReqPlus').hide();

                $('#btnSave').prop('disabled', true);
                $('#btnSaveandAddNew').prop('disabled', true);
                $('#CrmAssetGrid').css('visibility', 'hidden');
                $('#CrmAssetGrid').hide();
                $('#RequestDescription').prop('required', false);
                $("#lblcrmReqDesc").html("Request Description");

                $('#DateTimeDiv').hide();
                $('#crmReqManu').prop('disabled', false);
                $('#Modelrow').show();
                $('#RequestDescDiv').show();
                $('#crmReqPriority').hide();
                $('#lblCrmpriority').hide();
                $('#TypeOfDeduction').prop('disabled', false);
                $('#NonConformance').prop('disabled', false);
                $('#NonConformanceRequestDescription').prop('required', false);
                $('#TypeOfDeduction').prop('required', false);
                $('#crmReqPriority').prop('required', false);

                $('#DeductionIndDiv option:selected').text();
                $('#DeductionIndDiv').show();
                $('#divdeduction').hide();

            }
            else if (this.value == 136) {
                $('#txtAssetNo').prop('disabled', false);
                //$('#CrmAssetGrid').css('visibility', 'visible');
                //$('#CrmAssetGrid').show();  
                $('#TypeOfRequest').focus();
                $('#CrmReqPlus').show();
                $('#crmReqManu').prop('required', false);
                // $("#lblCrmReqmanu").html("Manufacturer <span class='red'>*</span>");
                $('#crmReqModel').prop('required', true);
                $("#lblCrmreqMod").html("Model <span class='red'>*</span>");
                $("#lblCrmReqTarDat").html("Target Date");
                $('#crmReqTarDat').prop('required', false);
                $("#lblCrmreqReqPer").html("Requested Person");
                $('#crmReqReqPer').prop('required', false);
                $('#ResponceDateTime').prop('required', false);
                $('#CompleteDateTime').prop('required', false);
                $('#Completedby').prop('required', false);
                $('#ServiceInd').hide();
                $('#NonConformance').hide();
                //$('#btnSaveConverttoWO').css('visibility', 'visible');
                //$('#btnSaveConverttoWO').show();
                //$('#RequestDescription').prop('required', true);
                //$("#lblcrmReqDesc").html("Request Description <span class='red'>*</span>");
                $('#AreaLocDiv').css('visibility', 'hidden');
                $('#AreaLocDiv').hide();
                $('#ReqTypTCDiv').css('visibility', 'hidden');
                $('#ReqTypTCDiv').hide();
                $('#CrmReqUsrAreaCd').prop('required', false);
                $('#CrmReqUsrLocCde').prop('required', false);
                // $("#CRMRequestGrid").empty();
                // AddNewRowCRMRequest();

                $("#CrmObsoleteFetchSave").css('visibility', 'visible');
                $('#crmObsoleteSec').css('visibility', 'visible');
                $('#crmObsoleteSec').show();
                $('#CrmReqPlus').hide();

                $('#btnSave').prop('disabled', true);
                $('#btnSaveandAddNew').prop('disabled', true);
                $('#CrmAssetGrid').css('visibility', 'hidden');
                $('#CrmAssetGrid').hide();
                $('#RequestDescription').prop('required', false);
                $("#lblcrmReqDesc").html("Request Description");

                $('#DateTimeDiv').hide();
                $('#crmReqManu').prop('disabled', false);
                $('#Modelrow').show();
                $('#RequestDescDiv').show();
                $('#crmReqPriority').hide();
                $('#lblCrmpriority').hide();
                $('#TypeOfDeduction').prop('disabled', false);
                $('#NonConformance').prop('disabled', false);
                $('#NonConformanceRequestDescription').prop('required', false);
                $('#TypeOfDeduction').prop('required', false);
                $('#crmReqPriority').prop('required', false);
                $('#DeductionIndDiv').hide();

                $('#divdeduction').hide();
            }
            else if (this.value == 132 || this.value == 135 || this.value == 10809) {
                $('#txtAssetNo').prop('disabled', false);
                $('#AreaLocDiv').css('visibility', 'hidden');
                $('#AreaLocDiv').hide();
                $('#ReqTypTCDiv').css('visibility', 'hidden');
                $('#ReqTypTCDiv').hide();
                $('#CrmAssetGrid').css('visibility', 'hidden');
                $('#CrmAssetGrid').hide();
                $('#CrmReqPlus').hide();
                $('#ServiceInd').hide();
                $('#NonConformance').hide();

                $('#DateTimeDiv').hide();
                $('#crmReqManu').prop('disabled', false);
                $('#Modelrow').show();
                $('#RequestDescDiv').show();


                $('#crmReqPriority').hide();
                $('#lblCrmpriority').hide();
                $('#TypeOfDeduction').prop('disabled', false);
                $('#NonConformance').prop('disabled', false);

                $('#NonConformanceRequestDescription').prop('required', false);
                $('#TypeOfDeduction').prop('required', false);
                $('#crmReqPriority').prop('required', false);
                $('#ResponceDateTime').prop('required', false);
                $('#CompleteDateTime').prop('required', false);
                $('#Completedby').prop('required', false);
                $('#printfm').hide();
                $('#selWorkGroupGM').prop('disabled', false);
                $('#DeductionIndDiv option:selected').text();
                $('#DeductionIndDiv').show();
                $('#divdeduction').hide();

            }
            else if (this.value == 134 || this.value == 138) {
                $('#txtAssetNo').prop('disabled', false);
                $('#lblCrmReqRem').show();
                $('#crmReqModel').prop('required', false);
                $("#lblCrmreqMod").html("Model <span class='red'>*</span>");
                //$('#btnSaveConverttoWO').css('visibility', 'visible');
                //$('#btnSaveConverttoWO').show();
                $('#CrmAssetGrid').css('visibility', 'hidden');
                $('#CrmAssetGrid').hide();
                $("#CRMRequestGrid").empty();
                $('#CrmReqPlus').hide();
                $('#AreaLocDiv').css('visibility', 'visible');
                $('#AreaLocDiv').show();
                $('#ReqTypTCDiv').css('visibility', 'hidden');
                $('#ReqTypTCDiv').hide();
                // $("#labCrmReqAreaCd").html("Area Code <span class='red'>*</span>");
                $("#labCrmReqLocCd").html("Location Code <span class='red'>*</span>");
                // $('#CrmReqUsrAreaCd').prop('required', true);
                $('#CrmReqUsrAreaCd').prop('disabled', true);
                $('#CrmReqUsrLocCde').prop('required', true);
                $('#crmReqManu').prop('required', false);
                $("#lblCrmReqmanu").html("Manufacturer");
                $('#crmReqModel').prop('required', false);
                $("#lblCrmreqMod").html("Model");
                $("#lblCrmReqTarDat").html("Target Date");
                $('#crmReqTarDat').prop('required', false);
                $("#lblCrmreqReqPer").html("Requested Person");
                $('#crmReqReqPer').prop('required', false);
                $('#RequestDescription').prop('required', true);
                $("#lblcrmReqDesc").html("Request Description <span class='red'>*</span>");
                $('#DateTimeDiv').hide();
                $('#Modelrow').show();
                $('#RequestDescDiv').show();
                $('#DeductionIndDiv').hide();
                $('#crmReqPriority').hide();
                $('#lblCrmpriority').hide();
                $('#TypeOfDeduction').prop('disabled', false);
                $('#NonConformance').prop('disabled', false);
                $('#NonConformanceRequestDescription').prop('required', false);
                $('#TypeOfDeduction').prop('required', false);
                $('#crmReqPriority').prop('required', false);
                $('#ResponceDateTime').prop('required', false);
                $('#CompleteDateTime').prop('required', false);
                $('#Completedby').prop('required', false);
                $('#ResponceDateTimeAndResponseby').css('visibility', 'hidden');
                $('#ServiceInd').hide();
                $('#NonConformance').hide();
                $('#DeductionIndDiv option:selected').text();
                $('#DeductionIndDiv').show();
                $('#divdeduction').hide();

            }
            else if (this.value == 375) {
                $('#txtAssetNo').prop('disabled', false);
                //$('#btnSaveConverttoWO').css('visibility', 'visible');
                //$('#btnSaveConverttoWO').show();
                $('#CrmAssetGrid').css('visibility', 'hidden');
                $('#CrmAssetGrid').hide();
                $("#CRMRequestGrid").empty();
                $('#CrmReqPlus').hide();

                $('#AreaLocDiv').css('visibility', 'visible');
                $('#AreaLocDiv').show();
                $('#ReqTypTCDiv').css('visibility', 'visible');
                $('#ReqTypTCDiv').show();
                $("#lblCrmreqMod").html("Model <span class='red'>*</span>");
                //  $("#labCrmReqAreaCd").html("Area Code <span class='red'>*</span>");
                $("#labCrmReqLocCd").html("Location Code <span class='red'>*</span>");
                //$('#CrmReqUsrAreaCd').prop('required', true);
                $("#crmReqModel").html("Model <span class='red'>*</span>");
                $('#CrmReqUsrLocCde').prop('required', true);
                $('#crmReqModel').prop('required', true);
                $('#crmReqManu').prop('required', false);
                $("#lblCrmReqmanu").html("Manufacturer");

                // $("#lblCrmreqMod").html("Model");
                $("#lblCrmReqTarDat").html("Target Date <span class='red'>*</span>");
                $('#crmReqTarDat').prop('required', true);
                $("#lblCrmreqReqPer").html("Requested Person <span class='red'>*</span>");
                $('#crmReqReqPer').prop('required', true);
                $('#RequestDescription').prop('required', true);
                $("#lblcrmReqDesc").html("Request Description <span class='red'>*</span>");

                $('#DateTimeDiv').hide();
                $('#Modelrow').show();
                $('#RequestDescDiv').show();
                $('#crmReqPriority').hide();
                $('#lblCrmpriority').hide();
                $('#TypeOfDeduction').prop('disabled', false);
                $('#NonConformance').prop('disabled', false);
                $('#NonConformanceRequestDescription').prop('required', false);
                $('#TypeOfDeduction').prop('required', false);
                $('#crmReqPriority').prop('required', false);
                $('#ResponceDateTime').prop('required', false);
                $('#CompleteDateTime').prop('required', false);
                $('#Completedby').prop('required', false);

                //---------------------------

                $('#ServiceInd').hide();
                $('#NonConformance').hide();
                $('#DeductionIndDiv').hide();
            }
            else if (this.value == 374) {
                $('#txtAssetNo').prop('disabled', false);
                $('#CrmAssetGrid').css('visibility', 'hidden');
                $('#CrmAssetGrid').hide();
                $("#CrmObsoleteFetchSave").css('visibility', 'visible');
                //$("#CRMRequestGrid").empty();
                //AddNewRowCRMRequest();               
                $('#crmReqManu').prop('required', false);
                //$("#lblCrmReqmanu").html("Manufacturer <span class='red'>*</span>");
                $('#crmReqModel').prop('required', true);
                $("#lblCrmreqMod").html("Model <span class='red'>*</span>");
                $("#lblCrmReqTarDat").html("Target Date");
                $('#crmReqTarDat').prop('required', false);
                $("#lblCrmreqReqPer").html("Requested Person");
                $('#crmReqReqPer').prop('required', false);
                $('#AreaLocDiv').css('visibility', 'hidden');
                $('#AreaLocDiv').hide();
                $('#ReqTypTCDiv').css('visibility', 'hidden');
                $('#ReqTypTCDiv').hide();
                $('#CrmReqUsrAreaCd').prop('required', false);
                $('#CrmReqUsrLocCde').prop('required', false);
                $('#crmObsoleteSec').css('visibility', 'visible');
                $('#crmObsoleteSec').show();
                $('#btnSave').prop('disabled', true);
                $('#btnSaveandAddNew').prop('disabled', true);
                $('#RequestDescription').prop('required', false);
                $("#lblcrmReqDesc").html("Request Description");
                $('#CrmReqPlus').hide();
                $('#DateTimeDiv').hide();
                $('#Modelrow').show();
                $('#RequestDescDiv').show();
                $('#DeductionIndDiv').hide();
                $('#crmReqPriority').hide();
                $('#lblCrmpriority').hide();
                $('#TypeOfDeduction').prop('disabled', false);
                $('#NonConformance').prop('disabled', false);
                $('#NonConformanceRequestDescription').prop('required', false);
                $('#TypeOfDeduction').prop('required', false);
                $('#crmReqPriority').prop('required', false);
                $('#ResponceDateTime').prop('required', false);
                $('#CompleteDateTime').prop('required', false);
                $('#Completedby').prop('required', false);
                $('#ServiceInd').hide();
                $('#NonConformance').hide();
                $('#DeductionIndDiv option:selected').text();
                $('#DeductionIndDiv').hide();
                $('#divdeduction').hide();
            }
            else if (this.value == 10020) {
                ServiceClicked();
                $('#ResponceDateTime').prop('required', false);
                $('#CompleteDateTime').prop('required', false);
                $('#Completedby').prop('required', false);
                // $('#TypeOfRequest').focus();
                $('#CrmReqPlus').show();
                $('#crmReqManu').prop('required', false);
                // $("#lblCrmReqmanu").html("Manufacturer <span class='red'>*</span>");
                $('#crmReqModel').prop('required', true);
                $("#lblCrmreqMod").html("Model <span class='red'>*</span>");
                $("#lblCrmReqTarDat").html("Target Date");
                $('#crmReqTarDat').prop('required', false);
                $("#lblCrmreqReqPer").html("Requested Person");
                $('#crmReqReqPer').prop('required', false);
                $('#crmReqModel').prop('required', false);
                $('#ServiceInd').show();
                $('#NonConformance').show();
                //$('#btnSaveConverttoWO').css('visibility', 'visible');
                //$('#btnSaveConverttoWO').show();
                //$('#RequestDescription').prop('required', true);
                //$("#lblcrmReqDesc").html("Request Description <span class='red'>*</span>");
                $('#AreaLocDiv').css('visibility', 'hidden');
                $('#AreaLocDiv').hide();
                $('#ReqTypTCDiv').css('visibility', 'hidden');
                $('#ReqTypTCDiv').hide();
                $('#CrmReqUsrAreaCd').prop('required', false);
                $('#CrmReqUsrLocCde').prop('required', false);
                // $("#CRMRequestGrid").empty();
                // AddNewRowCRMRequest();

                $("#CrmObsoleteFetchSave").css('visibility', 'hidden');
                $('#crmObsoleteSec').css('visibility', 'visible');
                $('#crmObsoleteSec').show();
                $('#CrmReqPlus').hide();
                $('#btnSave').prop('disabled', false);
                $('#btnSaveandAddNew').prop('disabled', false);
                $('#CrmAssetGrid').css('visibility', 'hidden');
                $('#CrmAssetGrid').hide();
                $('#RequestDescription').prop('required', false);
                //$("#lblcrmReqDesc").html("Request Description");


                $('#txtAssetNo').prop('disabled', false);
                $('#crmReqManu').prop('disabled', false);
                $('#Modelrow').hide();
                $('#RequestDescDiv').hide();
                $('#DeductionIndDiv option:selected').text();
                $('#DeductionIndDiv').show();
                $('#divdeduction').show();
                $('#crmReqPriority').hide();
                $('#lblCrmpriority').hide();
                $('#NonConformanceRequestDescription').prop('required', true);
                $('#TypeOfDeduction').prop('required', true);
                $('#crmReqPriority').prop('required', false);
                $('#test').css('visibility', 'visible');
                $('#lblcrmAction').hide();
                $('#RequestAction').hide();
                //$('#RequestAction').hide();
                $('#DateTimeDiv').hide();
                $('#lblCrmReqRem').show();
                $("#Remarks").show();

            }
            else if (this.value == 10021) {
                $('#txtAssetNo').prop('disabled', false);
                $('#ServiceInd').hide();
                $('#NonConformance').hide();
                $('#ReqTypTCDiv').css('visibility', 'visible');
                $('#ReqTypTCDiv').show();
                $('indicatorDiv').hide();
                $('#Modelrow').hide();
                $('#RequestDescDiv').show();
                $('#DeductionIndDiv').hide();
                $('#crmReqPriority').show();
                $('#lblCrmpriority').show();
                $('#NonConformanceRequestDescription').prop('required', false);
                $('#TypeOfDeduction').prop('required', false);
                $('#crmReqPriority').prop('required', true);
                $('#crmReqModel').prop('required', false);
                $('#crmReqManu').prop('required', false);
                $('#ResponceDateTime').show();
                $('#CompleteDateTime').show();
                $('#Completedby').show();
                $('#ResponceDateTime').prop('required', false);
                $('#CompleteDateTime').prop('required', false);
                $('#Completedby').prop('required', false);
                $('#DateTimeDiv').hide();
                var typerequId = $('#TypeOfServiceRequest').val();
                $('#lblCrmReqRem').hide();
                $('#Assessment').hide();
                $("#Remarks").hide();
                $('#AreaLocDiv').css('visibility', 'visible');
                $('#AreaLocDiv').show();
                $("#Assessment").html("Assessment Details <span class='red'>*</span>");
                //if (typerequId== 4)
                //{
                //   $('#lblCrmReqRem').hide();
                //   $('#Assessment').hide();    
                //   $("#Remarks").hide();
                //   $('#AreaLocDiv').css('visibility', 'visible');
                //   $('#AreaLocDiv').show();
                //    //$('#hdnCrmReqUsrLocCdeId').show();
                //    //$('#CrmReqUsrLocCde').show();
                //    //$('#labCrmReqLocCd').show();
                //    //$('#labCrmReqAreaCd').show();
                //    //$('#spnPopup-ReqUsrLocCde').show();
                //    //$('#Popup-ReqUsrLocCde').show();

                //    //$('#Popup-ReqUsrLocCde').show();
                //    //$('#Popup-ReqUsrLocCde').show();
                //    //$('#Popup-ReqUsrLocCde').show();
                //}
                //else
                //{
                //    $('#AreaLocDiv').css('visibility', 'hidden');
                //    $('#AreaLocDiv').hide();
                //    $('#Assessment').hide();
                //    $('#lblCrmReqRem').show();  
                //    $("#Remarks").show();  
                //}
                $('#DeductionIndDiv option:selected').text();
                $('#DeductionIndDiv').show();
                $('#divdeduction').hide();

            }
            else if (this.value == 10022) {
                $('#txtAssetNo').prop('disabled', false);
                $('#ServiceInd').hide();
                $('#NonConformance').hide();
                $('#DateTimeDiv').hide();
                $('#Modelrow').show();
                $('#DeductionIndDiv').hide();
                $('#crmReqPriority').hide();
                $('#lblCrmpriority').hide();
                $('#TypeOfDeduction').prop('disabled', false);
                $('#NonConformance').prop('disabled', false);
                $('#NonConformanceRequestDescription').prop('required', false);
                $('#TypeOfDeduction').prop('required', false);
                $('#crmReqPriority').prop('required', false);
                $('#ResponceDateTime').prop('required', false);
                $('#CompleteDateTime').prop('required', false);
                $('#Completedby').prop('required', false);

                $('#DeductionIndDiv option:selected').text();
                $('#DeductionIndDiv').show();
                $('#divdeduction').hide();

            }
                //else if ((this.value == 136 || this.value == 137 || this.value == 134 || this.value == 138) && (priId > 0)) {
                //    $('#btnSaveConverttoWO').css('visibility', 'visible');
                //    $('#btnSaveConverttoWO').show();
                //}
            else {
                $('#CrmAssetGrid').css('visibility', 'hidden');
                $('#CrmAssetGrid').hide();
                $('#ReqTypTCDiv').css('visibility', 'hidden');
                $('#ReqTypTCDiv').hide();
                $('#CrmReqPlus').hide();
                $('#crmReqManu').prop('required', false);
                $("#lblCrmReqmanu").html("Manufacturer");
                $('#crmReqModel').prop('required', false);
                $("#lblCrmreqMod").html("Model");
                $('#btnSaveConverttoWO').css('visibility', 'hidden');
                $('#btnSaveConverttoWO').hide();
                $('#AreaLocDiv').css('visibility', 'hidden');
                $('#AreaLocDiv').hide();
                $('#CrmReqUsrAreaCd').prop('required', false);
                $('#CrmReqUsrLocCde').prop('required', false);
                $("#lblCrmReqTarDat").html("Target Date");
                $('#crmReqTarDat').prop('required', false);
                $("#lblCrmreqReqPer").html("Requested Person");
                $('#crmReqReqPer').prop('required', false);
                $('#RequestDescription').prop('required', true);
                $("#lblcrmReqDesc").html("Request Description <span class='red'>*</span>");
                $('#ResponceDateTime').prop('required', false);
                $('#CompleteDateTime').prop('required', false);
                $('#Completedby').prop('required', false);
                $('#DeductionIndDiv').hide();
                $('#DeductionIndDiv option:selected').text();
                $('#DeductionIndDiv').show();
                $('#divdeduction').hide();
                $('#txtAssetNo').prop('disabled', false);
            }

            if (this.value == 138 || this.value == 137 || this.value == 374) {
                // $("#grid").trigger('reloadGrid');
                // loadTable();
                // var RequestService = "Advisory Services:Advisory Services;Alert:Alert;Feedback:Feedback;Hazard:Hazard;Incident:Incident;Recall:Recall;T&C:T&C;Obsolete:Obsolete;";
                // var ServiceValues = "Open:Open;Work In Progress:Work In Progress;Completed:Completed;Closed:Closed;Cancelled:Cancelled;Reassigned:Reassigned;";

                // genarateGrid(ServiceValues, RequestService);
            }
            else {
            }
            var typeofser = $('#TypeOfServiceRequest').val();
            if (typeofser == 1 || typeofser == 2) {
            }
            else {
                if (typeofser == 6) { }
                else {

                    $('#crmReqModel').prop("disabled", true);
                    $('#crmReqModel').prop("required", false);
                    $('#crmReqManu').prop("disabled", true);
                    $('#crmReqManu').prop("required", false);
                    $("#lblCrmreqMod").html("Model");
                    $("#lblCrmReqmanu").html("Manufacturer");
                }
            }
        });

        // added no validation for model for only lls



        function loadTable() {
            $('#txtAssetNo').prop('disabled', false);
            var requestService = "Advisory Services:Advisory Services;Alert:Alert;Feedback:Feedback;Hazard:Hazard;Incident:Incident;Recall:Recall;T&C:T&C;Obsolete:Obsolete;";
            var serviceValues = "Open:Open;Work In Progress:Work In Progress;Completed:Completed;Closed:Closed;Cancelled:Cancelled;Reassigned:Reassigned;";
            var ServiceValues = serviceValues.replace(/[,;]$/, '').toString();
            var RequestService = requestService.replace(/[,;]$/, '').toString();
            var serviceId = $('#TypeOfServiceRequest option:selected').val();
            URLS = "/api/CRMRequestApi/Getall/"
            //  $('#grid').jqGrid('GridUnload');  //this does the work of clearing out the table content and loading fresh data
            var grid = $("#grid"),
                prmSearch = { multipleSearch: true, overlay: false };
            grid.jqGrid({
                url: URLS + serviceId,
                datatype: 'json',
                mtype: 'Get',
                ajaxGridOptions: { contentType: 'application/json; charset=utf-8' },
                colNames: ['Id', 'Request No.', 'Request Date /Time', 'Request Type', 'Request Status', 'Model', 'Manufacturer', 'Requester', 'IsWorkOrder'],
                colModel: [
                    { key: true, hidden: true, name: 'CRMRequestId', width: '0%' },
                    { key: false, search: true, name: 'RequestNo', width: '20%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
                    { key: false, search: true, name: 'RequestDateTime', width: '15%', formatoptions: { srcformat: "d-M-Y H:i", newformat: "d-M-Y H:i" }, formatter: "date", resizable: true, searchoptions: { dataInit: function (elem) { $(elem).datetimepicker({ timepicker: true, format: 'd-M-Y H:i', step: 15, scrollInput: false }) }, sopt: ['eq', 'ne', 'lt', 'gt', 'le', 'ge'] } },
                    { key: false, search: true, name: 'TypeOfRequestVal', width: '10%', stype: "select", searchoptions: { sopt: ["eq", "ne"], value: RequestService, defaultValue: "Advisory Services" } },
                    { key: false, name: 'RequestStatusValue', width: '15%', stype: "select", searchoptions: { sopt: ["eq", "ne"], value: ServiceValues, defaultValue: "Open" } },
                    { key: false, search: true, name: 'Model', width: '10%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
                    { key: false, search: true, name: 'Manufacturer', width: '10%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
                    { key: false, search: true, name: 'ReqStaff', width: '20%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
                    { key: true, hidden: true, name: 'IsWorkOrder', width: '0%' },

                    //{ name: 'edit', search: false, index: 'CRMRequestId', width: '5%', sortable: false, formatter: editLink },
                    //{ name: 'delete', search: false, index: 'CRMRequestId', width: '5%', sortable: false, formatter: deleteLink },
                    //{ name: 'view', search: false, index: 'CRMRequestId', width: '5%', sortable: false, formatter: viewLink },

                ],

                pager: jQuery('#pager'),
                rowNum: 5,
                rowList: [5, 10, 20, 50],
                height: 'auto',
                width: '100%',
                viewrecords: true,
                // caption: 'Customer Relationship Management',
                sortname: 'ModifiedDateUTC',
                sortorder: 'desc',
                excel: true,
                subGrid: false,
                subGridOptions: {
                    "plusicon": "ui-icon-triangle-1-e", "minusicon": "ui-icon-triangle-1-s", "openicon": "ui-icon-arrowreturn-1-e",
                    "reloadOnExpand": false,
                    "selectOnExpand": true
                },
                onCellSelect: function (rowId, iCol, content, event) {

                    var rowData = $(this).jqGrid("getRowData", rowId);
                    LinkClicked(rowId, rowData);
                },
                onPaging: function (pgButton) {
                    curPage = $(".ui-pg-input").val();// current page
                    if (pgButton == "user") {
                        if (parseInt(totalPage) < parseInt(curPage) || parseInt(curPage) == 0) {
                            bootbox.alert(Messages.PAGE_NUMBER_ALERT_MESSAGE);
                            return "stop";
                        }
                    }
                },
                loadComplete: function (data) {
                    $("tr.jqgrow:odd").css("background", "#F0F8FF");
                    totalPage = $("#sp_1_pager").text();// total pages
                    curPage = $(".ui-pg-input").val();// current page
                    $("#ExporttoExcel").removeClass('ui-state-disabled');
                    $("#ExporttoPDF").removeClass('ui-state-disabled');
                    $("#ExporttoCSV").removeClass('ui-state-disabled');

                    if ($('#sp_1_pager').text() == "0") {
                        $("#sp_1_pager").text("1");
                        $("#next_pager").addClass('ui-state-disabled');
                        $("#last_pager").addClass('ui-state-disabled');
                    }
                    $("tr.jqgrow").css("hover", "#F0F8FF");
                    $('#refresh_grid_top').hide();
                    $('.ui-icon-csv').prop('title', 'Export To CSV');
                    $('.ui-icon-excel').prop('title', 'Export To Excel');
                    $('.ui-icon-refresh1').prop('title', 'Reload Grid');
                    if (!isFromSave) {
                        $(".content").scrollTop(3000);
                        isFromSave = true;
                    }
                    else {
                        if ((!gridClicked) && (!isFromSave)) {
                            $(".content").scrollTop(0);
                        } else {
                            gridClicked = false;
                        }
                    }
                    $('#fbox_grid_search, #fbox_grid_reset,#first_pager,#prev_pager,#next_pager,#last_pager,#refresh_grid_top').click(function () {
                        gridClicked = true;
                    });
                    $('.ui-pg-selbox').change(function () {
                        gridClicked = true;
                    });
                    //if (!hasAddPermission) {
                    //    $("#Add").hide();
                    //}
                    //setGridPermission(data);
                },
                loadError: function (responce) {
                    if (responce.status == 404) {
                        $(this).clearGridData();
                    }
                    // if (responce.status === 406) {
                    //        window.location.href = "/home?r=mts";
                    //    }
                    //if (responce.status === 409) {
                    //        window.location.href = "/account/Logout";
                    //    }
                    if ($('#sp_1_pager').text() == "0") {
                        $("#sp_1_pager").text("1");
                        $("#next_pager").addClass('ui-state-disabled');
                        $("#last_pager").addClass('ui-state-disabled');

                        $("#ExporttoExcel").addClass('ui-state-disabled');
                        $("#ExporttoPDF").addClass('ui-state-disabled');
                        $("#ExporttoCSV").addClass('ui-state-disabled');
                    }
                    $('#refresh_grid_top').hide();
                    //if (!hasAddPermission) {
                    //    $("#Add").hide();
                    //}
                    // setGridPermission(responce);
                },
                emptyrecords: 'No records to display',
                jsonReader: {
                    root: "rows",
                    page: "page",
                    total: "total",
                    records: "records",
                    repeatitems: false,
                    Id: "0"
                },
                autowidth: true,
                multiselect: false,
                toppager: true,
                toolbar: [true, "top"]
            }).navGrid('#pager', { cloneToTop: true, edit: false, add: false, del: false, search: false, refresh: true },
                {
                    multipleSearch: true,
                    multipleGroup: true,
                })

                .navButtonAdd('#pager_left', {
                    id: "refresh_grid_top",
                    caption: "",
                    buttonicon: "ui-icon-refresh1",
                    onClickButton: function () {
                        $('#grid').jqGrid().setGridParam({ page: 1 }).trigger('reloadGrid');
                    }
                })

                .navButtonAdd('#pager_left', {
                    id: "ExporttoExcel",
                    caption: "",
                    buttonicon: "ui-icon-excel",
                    onClickButton: function () {
                        Export("Excel");
                    }
                })

                .navButtonAdd('#pager_left', {
                    id: "ExporttoCSV",
                    caption: "",
                    buttonicon: "ui-icon-csv",
                    onClickButton: function () {
                        Export("CSV");
                    }
                });

        }
        $('#hdncrmReqModId').on('change', function () {
            var modId = $('#hdncrmReqModId').val();
            //var manufacturerId = $('#EODParamMapManu').val();
            if (modId != '') {
                $('#crmReqManu').attr('disabled', true);
            }
            else {
                $('#crmReqManu').attr('disabled', true);
                $('#crmReqManu').val('');
                //$('#CrmAssetGrid').css('visibility', 'hidden');
                //$('#CrmAssetGrid').hide();
                //$("#CRMRequestGrid").empty();
            }
        });

        $('#hdncrmReqManuId').on('change', function () {
            var manId = $('#hdncrmReqManuId').val();
            //var manufacturerId = $('#EODParamMapManu').val();
            if (manId != '') {

            }
            else {
                //$('#CrmAssetGrid').css('visibility', 'hidden');
                //$('#CrmAssetGrid').hide();
                //$("#CRMRequestGrid").empty();
            }
        });

        $('#RequestedDateTime').on('change input', function () {
            if ($('#RequestedDateTime').val() != '')
                {
            var RequestDateTime = Date.parse($('#RequestDateTime').val());
            var RequestedDateTime = Date.parse($('#RequestedDateTime').val());
            if (RequestDateTime < RequestedDateTime)
                {
                $("div.errormsgcenter").text("");
                $('#errorMsg').css('visibility', 'hidden');
                }
            else
                {
                $("div.errormsgcenter").text("Required Date/Time Should be greater than or equal to Request Date/Time");
                $('#errorMsg').css('visibility', 'visible');
                // $('#RequestedDateTime').focus();
                $('#RequestedDateTime').val('');
                }
            }
        });

        $('#crmReqModel').on('change input', function () {
            var modId = $('#hdncrmReqModId').val();
            var reqtyp = $('#TypeOfRequest').val();
            reqtyp = parseInt(reqtyp);
            if (modId != '') {

            }
            else {
                //$('#CrmAssetGrid').css('visibility', 'hidden');
                //$('#CrmAssetGrid').hide();
                //$("#CRMRequestGrid").empty();
                //$('#CrmAssetGrid').css('visibility', 'visible');
                //$('#CrmAssetGrid').show();
                //AddNewRowCRMRequest();
                $('#crmReqModel').focus();
            }

            if (reqtyp == 374 || reqtyp == 136 || reqtyp == 137) {
                if (modId != '') {
                    $("#crmObsoleteSec").css('visibility', 'visible');
                    $('#crmObsoleteSec').show();
                    $("#CrmObsoleteFetchSave").css('visibility', 'visible');
                }
                else {
                    $('#CrmAssetGrid').css('visibility', 'hidden');
                    $('#CrmAssetGrid').hide();
                    $("#CRMRequestGrid").empty();
                    $('#btnSave').prop('disabled', true);
                    $('#btnSaveandAddNew').prop('disabled', true);
                    $("#crmObsoleteSec").css('visibility', 'visible');
                    $('#crmObsoleteSec').show();
                    $("#CrmObsoleteFetchSave").css('visibility', 'visible');
                }
            }
            if (reqtyp != 137 && reqtyp != 136) {
                $('#CrmAssetGrid').css('visibility', 'hidden');
                $('#CrmAssetGrid').hide();
                $("#CRMRequestGrid").empty();
            }
        });

        $('#crmReqManu').on('change input', function () {
            var manId = $('#hdncrmReqManuId').val();
            var reqtyp = $('#TypeOfRequest').val();
            if (manId != '') {

            }
            else {
                $('#CrmAssetGrid').css('visibility', 'hidden');
                $('#CrmAssetGrid').hide();
                $("#CRMRequestGrid").empty();
                $('#CrmAssetGrid').css('visibility', 'visible');
                $('#CrmAssetGrid').show();
                AddNewRowCRMRequest();
                $('#crmReqManu').focus();
            }
            if (reqtyp == 374) {
                if (manId != '') {

                }
                else {
                    $('#CrmAssetGrid').css('visibility', 'hidden');
                    $('#CrmAssetGrid').hide();
                    $("#CRMRequestGrid").empty();
                    $('#btnSave').prop('disabled', true);
                    $('#btnSaveandAddNew').prop('disabled', true);
                }
            }

            if (reqtyp != 136 && reqtyp != 137) {
                $('#CrmAssetGrid').css('visibility', 'hidden');
                $('#CrmAssetGrid').hide();
                $("#CRMRequestGrid").empty();
            }
        });

        $('#btnVerify').hide();
        $('#btnClarify').hide();
        var reqtyp = $("#TypeOfRequest").val();
        var priId = $("#primaryID").val();
        if ((reqtyp == 136 || reqtyp == 137 || reqtyp == 134 || reqtyp == 138) && (priId > 0)) {
            $('#btnSaveConverttoWO').css('visibility', 'visible');
            $('#btnSaveConverttoWO').show();
        }

        var htmlval = ""; $('#tablebody').empty();

        setTimeout(function () {
            $("#top-notifications").modal('hide');
        }, 5000);
        $('#btnSave').attr('disabled', false);
        $('#myPleaseWait').modal('hide');
    })
        .fail(function (response) {
            var errorMessage = "";
            if (response.status == 400) {
                errorMessage = response.responseJSON;
            }
            else {
                errorMessage = Messages.COMMON_FAILURE_MESSAGE;
            }
            $("div.errormsgcenter").text(errorMessage);
            $('#errorMsg').css('visibility', 'visible');
            $('#btnSave').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
        });


    //    var jqxhr = $.get("/api/CRMRequestApi/Load", function (response) {
    //        var result = response;
    //        var serviceid = $("#TypeOfServiceRequest").val();
    //        LOVlist = result;
    //        if (serviceid == 1) {
    //            $(LOVlist.IndicatorList).each(function (_index, _data) {
    //                var test = _data.FieldValue;
    //                // alert(test);
    //                if (test.includes('F')) {

    //                    $('#TypeOfDeduction').append($('<option></option>').val(_data.LovId).html(_data.FieldValue))
    //                }
    //            });
    //        }
    //        else {
    //            $(LOVlist.IndicatorList).each(function (_index, _data) {
    //                var test = _data.FieldValue;
    //                // alert(test);
    //                if (test.includes('B')) {
    //                    $('#TypeOfDeduction').append($("<option>Selected</option>").val(_data.LovId).html(_data.FieldValue))
    //                }
    //            });
    //        }

    //    })
    //        .fail(function (response) {
    //            var errorMessage = "";
    //            if (response.status == 400) {
    //                errorMessage = response.responseJSON;
    //            }
    //            else {
    //                errorMessage = Messages.COMMON_FAILURE_MESSAGE;
    //            }
    //            $("div.errormsgcenter").text(errorMessage);
    //            $('#errorMsg').css('visibility', 'visible');
    //            $('#btnSave').attr('disabled', false);
    //            $('#myPleaseWait').modal('hide');
    //        });

    //});
    //------

    //function appendIndicator(indexs) {

    //    var ID = $("#TypeOfServiceRequest").val();

    //    $.get("/api/CRMRequestApi/get_Indicator_by_Serviceid/" + ID)
    //        .done(function (result) {
    //            // var getResult = JSON.parse(result);
    //            $('#LicenseCode_' + indexs).prop('disabled', false);
    //            $(result.Indicators).each(function (_index, _data) {
    //                $('#LicenseCode_' + indexs).append($('<option></option>').val(_data.LovId).html(_data.FieldValue));
    //            });
    //        }).fail(function (result) {

    //        });
    //}
    $("#TypeOfDeduction").change(function () {
        $('#ServiceIndicator').empty();
        var jqxhr = $.get("/api/CRMRequestApi/Load", function (response) {
            var result = response;

            var TypeOfDeductionValue = $("#TypeOfDeduction option:selected").text();
            //var serviceid = $("#TypeOfDeduction option:selected").val();
            LOVlist = result;
            $(result.IndicatorList_Descr).each(function (_index, _data) {
                var IndicatorDescription = _data.FieldValue;
                if (IndicatorDescription == TypeOfDeductionValue) {
                    var description = _data.Description
                    console.log(description);
                    $('#ServiceIndicator').val(description);
                    return false;
                }
            });


        }).fail(function (response) {
            var errorMessage = "";
            if (response.status == 400) {
                errorMessage = response.responseJSON;
            }
            else {
                errorMessage = Messages.COMMON_FAILURE_MESSAGE;
            }
            $("div.errormsgcenter").text(errorMessage);
            $('#errorMsg').css('visibility', 'visible');
            $('#btnSave').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
        });

    });

    //$("#btnsave").click(function () {
    //    alert();
    //});
    $("#TypeOfServiceRequest").change(function () {

        var servicetypeRequestId = $("#TypeOfServiceRequest").val();

        $("#TypeOfRequest").empty();
        $('#TypeOfRequest option:Please Select').val();

        var jqxhr = $.get("/api/CRMRequestApi/get_TypeofRequset_by_Serviceid/" + servicetypeRequestId)
            .done(function (result) {

                $(result.RequestTypeList).each(function (_index, _data) {
                    $('#TypeOfRequest').append($('<option></option>').val(_data.LovId).html(_data.FieldValue))
                });
                var ServiceRequestID = $("#TypeOfServiceRequest").val();
                if (ServiceRequestID == 1) {
                    $('#WorkGroupGMCDiv').show();
                    $('#WasteCategoryDiv').hide();
                    $("#selWorkGroupGM").val(getResult.WorkGroup);
                    // $('#selWorkGroupGM').prop('disabled', false);
                    $('#selWasteCategory').prop('required', false);
                    $("#TypeOfRequest").val(result.TypeOfRequest);
                }
                if (ServiceRequestID == 5) {
                    $('#WasteCategoryDiv').show();
                    $('#WorkGroupGMCDiv').hide();
                    $('#btnApprove').show();
                    $('#btnReject').show();
                    $('#btnClarify').show();
                    $('#btnDelete').show();
                    $('#btnCancel').show();
                    $("#selWasteCategory").val(getResult.WasteCategory);
                    $('#selWasteCategory').prop('disabled', false);
                    $('#selWorkGroupGM').prop('required', false);
                    $('#RequestDescription').prop('disabled', false);
                    $("#RequestDescription").val(result.RequestDescription);

                }
                if (ServiceRequestID == 2 || ServiceRequestID == 3 || ServiceRequestID == 4) {
                    $('#WasteCategoryDiv').hide();
                    $('#WorkGroupGMCDiv').hide();

                    $('#selWorkGroupGM').prop('disabled', false);
                    $('#selWasteCategory').prop('disabled', false);
                    $("#TypeOfRequest").val(result.TypeOfRequest);
                }
            }).fail(function (result) {

            });


        //========================




    });

    $("#btnSave,#btnEdit,#btnSaveandAddNew").click(function () {
        
        $('#btnlogin').attr('disabled', true);
        $('#myPleaseWait').modal('show');
        var CurrentbtnID = $(this).attr("Id");
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
        $('#TypeOfDeduction').prop('disabled', false);
        $('#NonConformance').prop('disabled', false);
        var TypeReq = $("#TypeOfRequest").val();

        if (this.value == 10809 || this.value == 132 || this.value == 134 || this.value == 374) {
            $('#txtAssetNo').prop('required', true);
        }
        else {
           
        }

        var _index;
        $('#CRMRequestGrid tr').each(function () {
            _index = $(this).index();
        });
        var Indexing = $('#SummaryResultId tr:last').index();
        var indicators_all;
        ///-----indicators save----------

        for (var i = 0; i <= Indexing; i++) {
            var lod;
            var chec;
            chec = $('#chkContactDeleteAll_' + i).is(":checked");
            if ($('#chkContactDeleteAll_' + i).is(":checked")) {

            }
            else {
                lod = $('#LicenseCode_' + i).val();

                if (indicators_all != null) {
                    indicators_all = indicators_all + ',' + lod;
                } else {
                    indicators_all = lod;
                }

            }

        }

        var ServiceRequestID = $("#TypeOfServiceRequest").val();

        if (ServiceRequestID == 1) {
            $('#WorkGroupGMCDiv').show();
            $('#WasteCategoryDiv').hide();

            $('#selWorkGroupGM').prop('required', true);
            $('#selWasteCategory').prop('required', false);
        }
        if (ServiceRequestID == 5) {
            $('#WasteCategoryDiv').show();
            $('#WorkGroupGMCDiv').hide();
            $('#btnApprove').show();
            $('#btnReject').show();
            $('#btnClarify').show();
            $('#btnDelete').show();
            $('#btnCancel').show();

            $('#selWasteCategory').prop('disabled', false);
            $('#selWorkGroupGM').prop('required', false);
            $('#RequestDescription').prop('disabled', false);
            $('#selWasteCategory').prop('required', true);

        }
        if (ServiceRequestID == 2 || ServiceRequestID == 3 || ServiceRequestID == 4) {
            $('#WasteCategoryDiv').hide();
            $('#WorkGroupGMCDiv').hide();

            $('#selWorkGroupGM').prop('disabled', false);
            $('#selWasteCategory').prop('disabled', false);
            $('#selWasteCategory').prop('required', false);
            $('#selWorkGroupGM').prop('required', false);
        }

        var isapproved = $("#hdnCrmReqChkstsApp").val();
        var serviceIndicator = $("#ServiceIndicator").val();
        var PriorityList = $('#crmReqPriority option:selected').val();
        var CRMRequestId = $("#primaryID").val();
        var ReqNo = $("#RequestNo").val();
        var ReqDateTime = $("#RequestDateTime").val();
       
        var Requested_Date = $("#RequestedDateTime").val();
        var ReqDateTimeUTC = new Date().toUTCString();
        var requesterName = $("#crmReqRequester").val();
        var requester = $("#hdncrmReqRequesterId").val();

        var tcassigne = $("#crmReqAssigne").val();
        var tcassigneId = $("#hdncrmReqAssigneId").val();
        var typeOfServiceRequest = $("#TypeOfServiceRequest").val();
        var priorityList = $("#crmReqPriority").val();
        var Manu = $('#crmReqManu').val();
        var Mod = $('#crmReqModel').val();
        var Manuid = $('#hdncrmReqManuId').val();
        var Modid = $('#hdncrmReqModId').val();
        var ReqDesc = $("#RequestDescription").val();
        var ReqDeductiontype = $("#TypeOfDeduction").val();
        var assetId = $("#hdnAssetId").val();
        var assetNo = $("#txtAssetNo").val();
        var Remarks = $("#Remarks").val();
        var RemarksNcr = $("#RemarkLls").val();
        var RequestStatus = $("#RequestStatus").val();
        var AreaId = $('#hdnCrmReqUsrAreaCdId').val();
        var LocationId = $('#hdnCrmReqUsrLocCdeId').val();
        var LocationCode = $('#CrmReqUsrLocCde').val();
        var timeStamp = $("#Timestamp").val();
        var TarDat = $("#crmReqTarDat").val();
        var reqPer = $("#crmReqReqPer").val();
        var reqPerId = $("#hdncrmReqReqPeId").val();
        var nonConformanceRequestDescription = $("#NonConformanceRequestDescription").val();
        var requestAction = $("#RequestAction").val();
        var responceDateTime = $("#ResponceDateTime").val();
        var completeDateTime = $("#CompleteDateTime").val();
        var completedbyName = $("#Completedby").val();
        var completedby = $("#hdncrmReqCompletedbyId").val();
        var Assessment = $("#hdncrmReqCompletedbyId").val();
        var Responseby = $("#Responseby").val();
        var RequestActionLLS = $("#RequestActionLLS").val();
        var JustificationLLS = $("#JustificationLLS").val();
        var Vaidation = $("#Vaidation").val();
        var Workgroup = $("#selWorkGroupGM").val();
        var wastecategory = $("#selWasteCategory").val();
        if (Vaidation == 100) {
            Indicators_all = 0;
        } else {
        }
        if (Manuid == "") {
            var Manuid = null;
        }
        if (Modid == "") {
            var Modid = null;
        }

        if (AreaId == "") {
            var AreaId = null;
        }
        if (LocationId == "") {
            var LocationId = null;
        }

        if (requester == "") {
            var requester = null;
        }

        var result = [];
        if (TypeReq == 136 || TypeReq == 137 || TypeReq == 374) {
            for (var i = 0; i <= _index; i++) {
                var _CRMReqGrid = {
                    CRMRequestId: $('#primaryID').val(),
                    CRMRequestDetId: $('#hdnCrmReqdetId_' + i).val(),
                    AssetId: $('#hdnCrmreqAssetId_' + i).val(),
                    IsDeleted: chkIsDeletedRow(i, $('#Isdeleted_' + i).is(":checked")),
                }
                result.push(_CRMReqGrid);
            }


            var deletedCount = Enumerable.From(result).Where(x => x.IsDeleted).Count();
            var Isdeleteavailable = deletedCount > 0;
            if (deletedCount == result.length && (TotalPages == 1 || TotalPages == 0)) {
                bootbox.alert("Sorry!. You cannot delete all rows");
                $('#myPleaseWait').modal('hide');
                return false;
            }

            var isFormValid = formInputValidation("Testform", 'save');
            if (!isFormValid) {
                $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
                $('#errorMsg').css('visibility', 'visible');

                $('#btnlogin').attr('disabled', false);
                $('#myPleaseWait').modal('hide');
                return false;
            }


            if ((Mod != "") && (Modid == null)) {
                DisplayErrorMessage("Valid Model is required.");
                return false;
            }


            $('#CRMRequestGrid tr').each(function () {
                _indexLar = $(this).index();
            });


            for (var i = 0; i <= _indexLar; i++) {
                var LarConId = $('#hdnCrmreqAssetId_' + i).val();
                if (result[i].IsDeleted == false) {
                    if (LarConId == '') {
                        DisplayErrorMessage("Valid Asset No. required.");
                        return false;
                    }
                }
            }

            var duplicates = false;
            for (i = 0; i < result.length; i++) {
                if (result[i].IsDeleted == false) {
                    var assetId = result[i].AssetId;
                    for (j = i + 1; j < result.length; j++) {
                        if (assetId == result[j].AssetId && result[j].IsDeleted == false) {
                            duplicates = true;
                        }
                    }
                }
            }

            if (duplicates) {
                $("div.errormsgcenter").text("Asset No. should be unique.");
                $('#errorMsg').css('visibility', 'visible');
                $('#myPleaseWait').modal('hide');
                return false;
            }
        }

        else {
            if ((Mod != "") && (Modid == null)) {
                DisplayErrorMessage("Valid Model is required.");
                return false;
            }
            if ((Manu != "") && (Manuid == null)) {
                DisplayErrorMessage("Valid Manufacturer is required.");
                return false;
            }
        }


        if (TypeReq == 134 || TypeReq == 138 || TypeReq == 375) {
            if ((LocationCode != "") && (LocationId == null)) {
                DisplayErrorMessage("Valid Location Code is required.");
                return false;
            }
        }

        function chkIsDeletedRow(i, delrec) {
            if (delrec == true) {
                $('#CrmreqAssetNo_' + i).prop("required", false);
                return true;
            }
            else {
                return false;
            }
        }


        function DisplayErrorMessage(errorMessage) {
            $("div.errormsgcenter").text(errorMessage);
            $('#errorMsg').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            return false;
        }



        var tardt = $('#crmReqTarDat').val();

        var datetar = Date.parse($('#crmReqTarDat').val());
        var curdate = new Date();
        var curdateFormatd = DateFormatter(curdate);
        curdateFormatd = Date.parse(curdateFormatd);

        //if (tardt != "") {
        //    if (datetar < curdateFormatd) {
        //        $("div.errormsgcenter").text("Target Date must be greater than or equal to Current Date");
        //        $('#errorMsg').css('visibility', 'visible');
        //        $('#myPleaseWait').modal('hide');
        //        return false;
        //    }
        //}

        //if (TypeReq == 375) {
        //    var primaryId = $("#primaryID").val();
        //    var tcassigneId = $("#hdncrmReqAssigneId").val();
        //    if (tcassigneId == "" && primaryId >0) {
        //        $("div.errormsgcenter").text("Valid Assignee required");
        //        $('#errorMsg').css('visibility', 'visible');
        //        $('#myPleaseWait').modal('hide');
        //        return false;
        //    }
        //}

        if (TypeReq != 375) {
            tcassigneId = null;
        }

        var hasveracc = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Verify'");
        if (hasveracc == true && (TypeReq == 132 || TypeReq == 135 || TypeReq == 10022)) {
            RequestStatus = 139;
        }

        var Chkentryuser = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Approve'");
        if (Chkentryuser == true && (TypeReq == 132 || TypeReq == 135 || TypeReq == 10022)) {
            var entusr = "FM";
        }
        else {
            var entusr = "Req";
        }

        var today = new Date();
        var CurDate = GetCurrentDate();
        var hour = today.getHours();
        var time = today.getMinutes();

        if (time < 10) {
            time = 0 + '' + time;
        }

        var gettime = hour + ":" + time;
        var CurDateTime = CurDate + " " + gettime;

        var primaryId = $("#primaryID").val();
        if (primaryId != null) {
            CRMRequestId = primaryId;
            Timestamp = timeStamp;
        }
        else {
            CRMRequestId = 0;
            Timestamp = "";
        }
        if (TypeReq == 10020) {
            if (RequestStatus == 139) {
                $("#Remarks").prop('required', false);
                $('#RequestDescription').prop('required', false);
                $('#RequestAction').prop('required', false);
                $("#lblcrmAction").html("Action Taken<span class='red'>*</span>");

            }
        }
        if (TypeReq == 10020) {
            if (RequestStatus == 140) {
                $('#RemarkLls').prop('required', true);
                $("#lblCrmReqLLS").html("Remarks <span class='red'>*</span>");
                $("#LabCompleteDateTime").html("Completed Date / Time <span class='red'>*</span>");
                $("#LabCompletedby").html("Completed By <span class='red'>*</span>");
                $('#CompleteDateTime').prop('required', true);
                $('#Completedby').prop('required', true);
                $("#Remarks").prop('required', false);
                $('#RequestDescription').prop('required', false);
                $('#RequestAction').prop('required', false);
                $("#lblcrmActionLLS").html("Action Taken<span class='red'>*</span>");
                $('#RequestActionLLS').prop('required', false);
            }
            indicators_all = $("#TypeOfDeduction").val();
        }
        if (TypeReq == 10021) {
            if (RequestStatus == 140) {
                $("#Assessment").html("Assessment Details <span class='red'>*</span>");
                $("#lblcrmActionLLS").html("Action Taken<span class='red'>*</span>");
                $("#lblcrmActionLLS").show();
                $('#RequestActionLLS').prop('required', true);
                $('#printfm').show();
            }
        }
        
        var obj = {
            CRMRequestGridData: result,
            CRMRequestId: CRMRequestId,
            RequestNo: ReqNo,
            RequestDateTime: ReqDateTime,
            RequestDateTimeUTC: ReqDateTimeUTC,
            ReqStaffId: requester,
            RequestStatus: RequestStatus,
            ManufacturerId: Manuid,
            ModelId: Modid,
            UserAreaId: AreaId,
            UserLocationId: LocationId,
            serviceid: typeOfServiceRequest,
            RequestDescription: ReqDesc,
            TypeOfRequest: TypeReq,
            Remarks: Remarks,
            Timestamp: Timestamp,
            TargetDate: TarDat,
            RequestPersonId: reqPerId,
            AccessFlag: isapproved,
            AssigneeId: tcassigneId,
            ChkEntUser: entusr,
            CurrentDatetimeLocal: CurDateTime,
            //Indicators_all: ReqDeductiontype,
            TypeOfServiceRequest: typeOfServiceRequest,
            PriorityList: priorityList,
            ServiceIndicator: serviceIndicator,
            NCRDescription: nonConformanceRequestDescription,
            Completedstaffid: completedby,
            Action_Taken: requestAction,
            ResponceDateTime: responceDateTime,
            CompleteDateTime: completeDateTime,
            Responce_Date: responceDateTime,
            Completed_Date: completeDateTime,
            Completed_By: completedby,
            LLSAssessment: Assessment,
            LLSResponse_by_ID: Responseby,
            LLSAction_Taken: RequestActionLLS,
            LLSJustification: JustificationLLS,
            LLSValidation: Vaidation,
            Indicators_all: indicators_all,
            NcrRemarks: RemarksNcr,

            AssetId: assetId,
            AssetNo: assetNo,
            WorkGroup: Workgroup,
            WasteCategory: wastecategory,
            RequestedDate: Requested_Date
        }

        var isFormValid = formInputValidation("Testform", 'save');
        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');

            $('#btnlogin').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            return false;
        }

        if (requesterName != "" && obj.ReqStaffId == null) {
            $("div.errormsgcenter").text("Valid Requester required");
            $('#errorMsg').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            return false;
        }
        if (completedbyName != "" && completedby == null) {
            $("div.errormsgcenter").text("Valid Requester required");
            $('#errorMsg').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');

            return false;
        }
        //if (TypeReq == 10021) {

        //    alert('ripsss');
        //    $('#myPleaseWait').modal('hide');
        //}

        //if (TypeReq == 375) {
        //    var primaryId = $("#primaryID").val();
        //    var tcassigneId = $("#hdncrmReqAssigneId").val();
        //    if (tcassigneId == "" && primaryId > 0) {
        //        $("div.errormsgcenter").text("Valid Assignee required");
        //        $('#errorMsg').css('visibility', 'visible');
        //        $('#myPleaseWait').modal('hide');
        //        return false;
        //    }
        //}

        if (Isdeleteavailable == true) {
            bootbox.confirm(Messages.MULTIPLE_DELETE_CONFIRMATION, function (result) {
                if (result) {
                    SaveCrmRequest(obj);
                }
                else {
                    $('#myPleaseWait').modal('hide');
                }
            });
        }
        else {
            SaveCrmRequest(obj);
        }

        function SaveCrmRequest(obj) {
            var jqxhr = $.post("/api/CRMRequestApi/save", obj, function (response) {
                var result = JSON.parse(response);
                $("#primaryID").val(result.CRMRequestId);
                $("#Timestamp").val(result.Timestamp);
                $("#grid").trigger('reloadGrid');

                //if ((result.TypeOfRequest == 136 || result.TypeOfRequest == 137 || result.TypeOfRequest == 134 || result.TypeOfRequest == 138)) {
                //    $('#btnSaveConverttoWO').css('visibility', 'visible');
                //    $('#btnSaveConverttoWO').show();
                //}

                if (result.CRMRequestId != 0) {
                    // $('#LevelCode').prop('disabled', true);
                    $('#btnNextScreenSave').show();
                    $('#btnEdit').show();
                    $('#btnSave').hide();
                    $('#RequestAction').css('visibility', 'visible');
                }

                BindDatatoHeader(result);


                $("#hdnAssetId").val(assetId);
                $("#txtAssetNo").val(assetNo);

                $('#btnEdit').hide();
                $('#btnSaveandAddNew').hide();
                $('#btnClarify').hide();


                //$("#Remarks").val('');
                $(".content").scrollTop(0);
                showMessage('Request', CURD_MESSAGE_STATUS.SS);
                $("#top-notifications").modal('show');
                setTimeout(function () {
                    $("#top-notifications").modal('hide');
                }, 5000);

                $('#btnSave').attr('disabled', false);
                $('#myPleaseWait').modal('hide');
                if (CurrentbtnID == "btnSaveandAddNew") {
                    EmptyFields();
                }
            },
                "json")
                .fail(function (response) {
                    var errorMessage = "";
                    if (response.status == 400) {
                        errorMessage = response.responseJSON;
                    }
                    else {
                        errorMessage = Messages.COMMON_FAILURE_MESSAGE(response);
                    }
                    $("div.errormsgcenter").text(errorMessage);
                    $('#errorMsg').css('visibility', 'visible');
                    $('#btnSave').attr('disabled', false);
                    $('#myPleaseWait').modal('hide');
                });

        }
        // $("#grid").trigger('reloadGrid');
    });


    $("#btnReject").click(function () {
        $('#btnlogin').attr('disabled', true);
        $('#myPleaseWait').modal('show');

        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');

        var CRMRequestId = $("#primaryID").val();
        var flag = "Reject";
        var rem = $("#Remarks").val();
        var reqeml = $("#hdncrmReqRequesterEmail").val();
        var ReqType = $("#TypeOfRequest").val();

        var today = new Date();
        var CurDate = GetCurrentDate();
        var hour = today.getHours();
        var time = today.getMinutes();

        if (time < 10) {
            time = 0 + '' + time;
        }

        var gettime = hour + ":" + time;
        var CurDateTime = CurDate + " " + gettime;

        var obj = {
            CRMRequestId: CRMRequestId,
            FMREQProcess: flag,
            Remarks: rem,
            RequesterEmail: reqeml,
            TypeOfRequest: ReqType,
            CurrentDatetimeLocal: CurDateTime
        }

        $('#crmReqAssigne').prop('required', false);

        //var isFormValid = formInputValidation("Testform", 'save');
        //if (!isFormValid) {
        //    $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        //    $('#errorMsg').css('visibility', 'visible');

        //    $('#btnlogin').attr('disabled', false);
        //    $('#myPleaseWait').modal('hide');
        //    return false;
        //}
        if (obj.TypeOfRequest == 10020) {
            isFormValid = true;
        }
        else {
            isFormValid = formInputValidation("Testform", 'save');
        }

        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');

            $('#btnlogin').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            return false;
        }

        FmReqApplyProcess(obj);
        $('#btnSaveConverttoWO').css('visibility', 'hidden');
        $('#btnSaveConverttoWO').hide();

    });

    $("#btnApprove").click(function () {

        $('#btnlogin').attr('disabled', true);
        $('#myPleaseWait').modal('show');
        $('#TypeOfServiceRequest').prop('required', false);
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
        var CRMRequestId = $("#primaryID").val();
        var flag = "Approve";
        var rem = $("#Remarks").val();
        var priorityList = $("#crmReqPriority").val();
        var ReqType = $("#TypeOfRequest").val();
        var serviceId = $('#TypeOfServiceRequest option:selected').val();
        var AppAssigne = $("#crmReqAssigne").val();
        var AssEmail = $("#hdncrmReqAssigneEmail").val();
        var ReqEmail = $("#hdncrmReqRequesterEmail").val();
        var Remarks = $("#Remarks").val();
        var Responce_Date = $("#ResponceDateTime").val();
        var LLSResponse_by_id = $("#hdncrmReqResponsebyId").val();
        var Request = $("#RequestAction").val();
        var RequestStatus = $("#RequestStatus").val();
        var assetNo = $("#txtAssetNo").val();
        var assetId = $("#hdnAssetId").val();
        var Workgroup = $("#selWorkGroupGM").val();

        if (serviceId == 1) {

            //$('#WorkGroupGMCDiv').show();
            $('#selWasteCategory').prop('required', false);
            $('#selWorkGroupGM').prop('disabled', false);
        }
        else {
            //$('#WorkGroupGMCDiv').hide();

        }

        if (serviceId == 5) {

            //$('#WasteCategoryDiv').show();
            $('#selWorkGroupGM').prop('required', false);
            $('#WorkGroupGMCDiv').prop('required', false);

        }
        else {
            //$('#WasteCategoryDiv').hide();

        }
        if (serviceId == 2 || serviceId == 3 || serviceId == 4) {
            //$('#WasteCategoryDiv').hide();
            //$('#WorkGroupGMCDiv').hide();
            $('#selWasteCategory').prop('required', false);
            $('#selWorkGroupGM').prop('required', false);
        }
        else {


        }

        //if (serviceId == 1) {
        //    //$('#WasteCategoryDiv').show();
        //    $('#selWasteCategory').prop('required', false);
        //}
        if (ReqType == 375) {
            if (AppAssigne == "") {
                bootbox.alert("Assignee is mandatory for Approve");
                $('#myPleaseWait').modal('hide');
                return false;

            }
        }

        //if (ReqType == 10020) {
        //   // 
        //   var indicators_all = $("#TypeOfDeduction").val();
        //    if (indicators_all == "") {
        //        $('#myPleaseWait').modal('hide');
        //        return false;

        //    }
        //}


        if (ReqType == 375) {
            var assId = $("#hdncrmReqAssigneId").val();
            //if (assId == "") {
            //    $("div.errormsgcenter").text("Valid Assignee required");
            //    $('#errorMsg').css('visibility', 'visible');
            //    $('#myPleaseWait').modal('hide');
            //    return false;
            //}

        }
        else {
            var assId = null;
        }

        var today = new Date();
        var CurDate = GetCurrentDate();
        var hour = today.getHours();
        var time = today.getMinutes();

        if (time < 10) {
            time = 0 + '' + time;
        }

        var gettime = hour + ":" + time;
        var CurDateTime = CurDate + " " + gettime;
        var obj = {

            CRMRequestId: CRMRequestId,
            FMREQProcess: flag,
            Remarks: rem,
            AssigneeId: assId,
            AssigneeEmail: AssEmail,
            RequesterEmail: ReqEmail,
            TypeOfRequest: ReqType,
            PriorityList: priorityList,
            ServiceId: serviceId,
            Remarks: Remarks,
            Responce_Date: Responce_Date,
            Action_Taken: Request,
            LLSResponse_by_ID: LLSResponse_by_id,
            AssetNo: assetNo,
            AssetId: assetId,
            WorkGroup: Workgroup
        }
        if (ReqType == 10020) {
            $('#ResponceDateTime').show();
            $('#ResponceDateTime').prop('required', true);
            $("#lblResponceDateTime").html("Response Date / Time <span class='red'>*</span>");
            $('#Responseby').show(); 
            $('#Responseby').prop('required', true);
            $('#Responseby').attr('required', true);
            $("#lblResponseby").html("Response By <span class='red'>*</span>");
            $("#Remarks").prop('required', false);
            $('#RequestDescription').prop('required', false);
            $('#RequestAction').prop('required', true);


        }
        if (ReqType == 10021) {
            $("#lblcrmActionLLS").html("Action Taken<span class='red'>*</span>");
            $("#lblcrmActionLLS").show();
        }

        var isFormValid = formInputValidation("Testform", 'save');
        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');

            $('#btnlogin').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            return false;
        }



        if (ReqType == 375) {
            var assId = $("#hdncrmReqAssigneId").val();
            if (obj.AssigneeId == "") {
                $("div.errormsgcenter").text("Valid Assignee required");
                $('#errorMsg').css('visibility', 'visible');
                $('#myPleaseWait').modal('hide');
                return false;
            }
        }

        FmReqApplyProcess(obj);
        $('#btnApprove').hide();
        $('#btnReject').hide();
        $('#btnEdit').show();

    });




    $("#btnVerify").click(function () {

        $('#btnlogin').attr('disabled', true);
        $('#myPleaseWait').modal('show');

        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');

        //var ServiceRequestID = $("#TypeOfServiceRequest").val();
        //if (ServiceRequestID == 2) {
        $('#selWasteCategory').prop('required', false);
        $('#selWorkGroupGM').prop('required', false);
        /* }*/

        var CRMRequestId = $("#primaryID").val();
        var flag = "Verify";
        var rem = $("#Remarks").val();
        var ReqType = $("#TypeOfRequest").val();
        var reqeml = $("#hdncrmReqRequesterEmail").val();

        var today = new Date();
        var CurDate = GetCurrentDate();
        var hour = today.getHours();
        var time = today.getMinutes();

        if (time < 10) {
            time = 0 + '' + time;
        }

        var gettime = hour + ":" + time;
        var CurDateTime = CurDate + " " + gettime;

        var obj = {
            CRMRequestId: CRMRequestId,
            FMREQProcess: flag,
            Remarks: rem,
            TypeOfRequest: ReqType,
            RequesterEmail: reqeml,
            CurrentDatetimeLocal: CurDateTime
        }
        var isFormValid = formInputValidation("Testform", 'save');
        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');

            $('#btnlogin').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            return false;
        }
        FmReqApplyProcess(obj);
        $('#btnClarify').hide();
        $('#btnSave').hide();

    });

    $("#btnClarify").click(function () {
        $('#btnlogin').attr('disabled', true);
        $('#myPleaseWait').modal('show');

        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
        var CRMRequestId = $("#primaryID").val();
        var flag = "Clarify";
        var rem = $("#Remarks").val();
        var ReqType = $("#TypeOfRequest").val();
        var RequestStatus = $("#RequestStatus").val();
        var assetNo = $("#txtAssetNo").val();
        var assetId = $("#hdnAssetId").val();
        var today = new Date();
        var CurDate = GetCurrentDate();
        var hour = today.getHours();
        var time = today.getMinutes();

        if (time < 10) {
            time = 0 + '' + time;
        }

        var gettime = hour + ":" + time;
        var CurDateTime = CurDate + " " + gettime;
        if (ReqType == 10020) {
            if (RequestStatus == 139) {
                $("#lblResponseby").html("Response By <span class='red'>*</span>");
                $("#lblResponceDateTime").html("Response Date / Time <span class='red'>*</span>");
                $("#lblcrmAction").html("Action Taken <span class='red'>*</span>");
                $('#RequestAction').prop('required', true);
                $("#Remarks").prop('required', false);
                $('#RequestDescription').prop('required', false);
                $('#RequestAction').prop('required', true);
                $('#Responseby').prop('required', true);
                $('#txtAssetNo').prop('disabled', true);
            }
        }

        var obj = {
            CRMRequestId: CRMRequestId,
            FMREQProcess: flag,
            Remarks: rem,
            TypeOfRequest: ReqType,
            CurrentDatetimeLocal: CurDateTime,
            AssetNo: assetNo,
            AssetId: assetId
        }
        //if (ReqType == 10020) {
        //    isFormValid = true;
        //}
        //else {
        //    isFormValid = formInputValidation("Testform", 'save');
        //}

        //if (!isFormValid) {
        //    $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        //    $('#errorMsg').css('visibility', 'visible');

        //    $('#btnlogin').attr('disabled', false);
        //    $('#myPleaseWait').modal('hide');
        //    return false;
        //}
        var isFormValid = formInputValidation("Testform", 'save');
        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');

            $('#btnlogin').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            return false;
        }
        FmReqApplyProcess(obj);
        $('#btnApprove').hide();
        $('#btnReject').hide();
    });

    $(".nav-tabs > li:not(:first-child)").click(function () {
        var priId = $('#primaryID').val()


        if (priId == "") {

            bootbox.alert("Request Details must be saved before entering additional information");
            return false;
        }
    });


    $("#CrmObsoleteFetchSave").click(function () {

        //var SerId = $('#EodCapService').val();
        var retyp = $('#TypeOfRequest').val();
        var mod = $('#hdncrmReqModId').val();
        var manufac = $('#hdncrmReqManuId').val();
        var serviceid = $('#TypeOfServiceRequest').val();
        var obj = {
            ModelId: mod,
            ManufacturerId: manufac,
            ServiceId: serviceid
        }

        if (retyp != null && retyp != "" && mod != null && mod != "" && manufac != null && manufac != "") {
            // var jqxhr = $.get("/api/CRMRequestApi/GetObsAssetM/" + manufac + "/" + mod + "/" + pagesize + "/" + pageindex, function (response) {
            $.post("/api/CRMRequestApi/GetObsAsset", obj)
                .done(function (result) {
                    var getResult = JSON.parse(result);
                    $('#RequestDescription').prop('required', true);
                    $("#lblcrmReqDesc").html("Request Description <span class='red'>*</span>");
                    if (getResult.CRMRequestGridData != null && getResult.CRMRequestGridData.length > 0) {

                        $('#CrmAssetGrid').css('visibility', 'visible');
                        $('#CrmAssetGrid').show();
                        $("#CRMRequestGrid").empty();
                        //$("#EODCaptureTable").show();
                        GetObsAssFechGrid(getResult);

                        $('#myPleaseWait').modal('hide');
                        $("div.errormsgcenter").css('visibility', 'hidden');
                        $("#CrmObsoleteFetchSave").css('visibility', 'hidden');

                        //$('#errorMsg').hide();
                        //gridFetchRec = true;
                    }
                    else {
                        $('#CrmAssetGrid').css('visibility', 'hidden');
                        $('#CrmAssetGrid').hide();
                        $("#CRMRequestGrid").empty();
                        $("div.errormsgcenter").text("No Assets found for specified Model and Manufacturer");
                        $('#errorMsg').css('visibility', 'visible');
                        $('#btnSave').prop('disabled', true);
                        $('#btnSaveandAddNew').prop('disabled', true);
                        $('#btnlogin').attr('disabled', false);
                        $('#myPleaseWait').modal('hide');
                        $('#CrmObsoleteFetchSave').show();
                    }

                })
                .fail(function () {
                    $('#myPleaseWait').modal('hide');
                    $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
                    //$("div.errormsgcenter").text('Please enter mandatory values before fetching');

                    $('#errorMsg').css('visibility', 'visible');
                });
        }
        else {
            bootbox.alert("Please Enter Mandatory Values Before Fetching");
            //$('#myPleaseWait').modal('hide');
            //$("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            //$('#errorMsg').css('visibility', 'visible');
        }
    });



    // **** Query String to get ID Begin****\\\

    var getUrlParameter = function getUrlParameter(sParam) {
        var sPageURL = decodeURIComponent(window.location.search.substring(1)),
            sURLVariables = sPageURL.split('&'),
            sParameterName,
            i;

        for (i = 0; i < sURLVariables.length; i++) {
            sParameterName = sURLVariables[i].split('=');

            if (sParameterName[0] === sParam) {
                return sParameterName[1] === undefined ? true : sParameterName[1];
            }
        }
    };
    var ID = getUrlParameter('id');

    if (ID == null || ID == undefined || ID == 0 || ID == '' || ID == "") {
        $("#jQGridCollapse1").click();
    }
    else {
        if (ID != null && ID != "0") {
            $.get("/api/CRMRequestApi/Get/" + ID + "/" + pagesize + "/" + pageindex)
                .done(function (result) {
                    var getResult = JSON.parse(result);
                    requestupdate = getResult;

                    LinkClicked(ID, requestupdate);
                })
                .fail(function (response) {
                    $('#myPleaseWait').modal('hide');
                    $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
                    $('#errorMsg').css('visibility', 'visible');
                });
        }
    }


    $("#chk_CrmReq").change(function () {
        var Isdeletebool = this.checked;

        if (this.checked) {
            $('#CRMRequestGrid tr').map(function (i) {
                if ($("#Isdeleted_" + i).prop("disabled")) {
                    $("#Isdeleted_" + i).prop("checked", false);
                }
                else {
                    $("#Isdeleted_" + i).prop("checked", true);
                }
            });
        } else {
            $('#CRMRequestGrid tr').map(function (i) {
                $("#Isdeleted_" + i).prop("checked", false);
            });
        }
    });

});

function FmReqApplyProcess(obj) {
    var jqxhr = $.post("/api/CRMRequestApi/ApplyingProcess", obj, function (response) {
        var result = JSON.parse(response);

        //$("#primaryID").val(result.CRMRequestId);
        //$("#Timestamp").val(result.Timestamp);

        BindDatatoHeader(result);
        $("#grid").trigger('reloadGrid');

        //if (result.Flag == "Reject") {
        //    showMessage('Request', "Rejected");
        //}
        //else if (result.Flag == "Approve") {
        //    showMessage('Request', "Approved");
        //}
        //else if (result.Flag == "Verify") {
        //    showMessage('Request', "verified and Closed.");
        //}
        //else if (result.Flag == "Clarify") {
        //    showMessage('Request', "Need Clarification");
        //}

        if (result.FMREQProcess == "Reject") {
            showMessage('Request', CURD_MESSAGE_STATUS.RJS);
        }
        else {
            $(".content").scrollTop(0);
            showMessage('Request', CURD_MESSAGE_STATUS.SS);
            $("#top-notifications").modal('show');
            setTimeout(function () {
                $("#top-notifications").modal('hide');
            }, 5000);

            $('#btnSave').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
        }
    },
        "json")
        .fail(function (response) {
            var errorMessage = "";
            if (response.status == 400) {
                errorMessage = response.responseJSON;
            }
            else {
                errorMessage = Messages.COMMON_FAILURE_MESSAGE(response);
            }
            $("div.errormsgcenter").text(errorMessage);
            $('#errorMsg').css('visibility', 'visible');

            $('#btnSave').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
        });
}


function ConvertWorkorder() {
    var _index;
    $('#CRMRequestGrid tr').each(function () {
        _index = $(this).index();
    });
    // actionType = $('#ActionType').val();
    var CRMRequestId = $("#primaryID").val();
    var ReqNo = $("#RequestNo").val();
    var ReqDateTime = $("#RequestDateTime").val();
    var TypeReq = $("#TypeOfRequest").val();
    var RequestStatus = $("#RequestStatus").val();
    var ReqDesc = $("#RequestDescription").val();
    var serviceId = $('#TypeOfServiceRequest').val();
    var ReqDeductiontype = $("#TypeOfDeduction option:selected").text();
    var Manuid = $('#hdncrmReqManuId').val();
    var Modid = $('#hdncrmReqModId').val();
    var AreaId = $('#hdnCrmReqUsrAreaCdId').val();
    var LocationId = $('#hdnCrmReqUsrLocCdeId').val();
    var timeStamp = $("#Timestamp").val();
    var ReqTypeName = $('#TypeOfRequest option:selected').text();
    var WOAsd = $("#CrmreqReqWOAss").val();
    var WOAssId = $("#hdncrmReqWOAssigneId").val();
    var WOAssEmail = $("#hdncrmReqWOAssigneEmail").val();
    var reqid = $("#hdncrmReqRequesterId").val();
    if (Manuid == "") {
        var Manuid = null;
    }
    if (Modid == "") {
        var Modid = null;
    }

    if (AreaId == "") {
        var AreaId = null;
    }
    if (LocationId == "") {
        var LocationId = null;
    }
    var today = new Date();
    var CurDate = GetCurrentDate();
    var hour = today.getHours();
    var time = today.getMinutes();
    //  var time = time.toString();

    if (time < 10) {
        time = 0 + '' + time;
    }

    var gettime = hour + ":" + time;

    var CurDateTime = CurDate + " " + gettime;
    var WorkorderTime = (CurDateTime);
    var WorkorderTimeUTC = new Date().toUTCString();
    // alert(WorkorderTimeUTC);
    var result = [];
    //-----------------------
    //if (TypeReq == 136 || TypeReq == 137) {
    //    for (var i = 0; i <= _index; i++) {
    //        var _CRMWorkOrd = {
    //            RequestNo: ReqNo,
    //            TypeOfRequest: TypeReq,
    //            RequestStatus: RequestStatus,
    //            ModelId: Modid,
    //            ManufacturerId:Manuid,
    //            AssetId: $('#hdnCrmreqAssetId_' + i).val(),
    //        }
    //        result.push(_CRMWorkOrd);
    //    }
    //}
    //else if (TypeReq == 134 || TypeReq == 138) {
    //    var _CRMWorkOrd = {
    //        RequestNo: ReqNo,
    //        TypeOfRequest: TypeReq,
    //        RequestStatus: RequestStatus,
    //        ModelId: Modid,
    //        ManufacturerId: Manuid,
    //        UserAreaId:AreaId,
    //        UserLocationId: LocationId,
    //    }
    //    result.push(_CRMWorkOrd);
    //}
    //-----------------------
    if (TypeReq == 136 || TypeReq == 137) {
        for (var i = 0; i <= _index; i++) {
            var _CRMReqGrid = {
                CRMRequestId: $('#primaryID').val(),
                CRMRequestDetId: $('#hdnCrmReqdetId_' + i).val(),
                AssetId: $('#hdnCrmreqAssetId_' + i).val(),
            }
            result.push(_CRMReqGrid);
        }
    }
    else {

    }


    if (WOAsd == "") {
        bootbox.alert("Assignee is mandatory for Convert to WO");
        $('#myPleaseWait').modal('hide');
        return false;

    }

    if (WOAsd != "" && WOAssId == "") {
        bootbox.alert("Valid Assignee required");
        $('#myPleaseWait').modal('hide');
        return false;

    }

    var obj = {
        ServiceId: serviceId,
        CRMRequestGridData: result,
        CRMRequestId: CRMRequestId,
        RequestNo: ReqNo,
        TypeOfRequest: TypeReq,
        RequestStatus: RequestStatus,
        ManufacturerId: Manuid,
        ModelId: Modid,
        UserAreaId: AreaId,
        UserLocationId: LocationId,
        RequestDescription: ReqDesc,
        Timestamp: timeStamp,
        TypeOfRequestVal: ReqTypeName,
        WOAssigneeId: WOAssId,
        WOAssigneeEmail: WOAssEmail,
        WorkorderTimeUTC: WorkorderTimeUTC,
        ReqStaffId: reqid
    }


    var jqxhr = $.post("/api/CRMRequestApi/ConvertWO", obj, function (response) {
        var result = JSON.parse(response);
        BindDatatoHeader(result);
        $(".content").scrollTop(0);
        showMessage('Request', CURD_MESSAGE_STATUS.SS);
        $("#top-notifications").modal('show');
        setTimeout(function () {
            $("#top-notifications").modal('hide');
        }, 5000);

        $('#btnSave').attr('disabled', false);
        $('#myPleaseWait').modal('hide');
        $("#grid").trigger('reloadGrid');
        //EmptyFields();
    },
        "json")
        .fail(function (response) {
            var errorMessage = "";
            if (response.status == 400) {
                errorMessage = response.responseJSON;
            }
            else {
                errorMessage = Messages.COMMON_FAILURE_MESSAGE(response);
            }
            $("div.errormsgcenter").text(errorMessage);
            $('#errorMsg').css('visibility', 'visible');

            $('#btnSave').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
        });


}


function GetObsAssFechGrid(getResult) {
    $('#CrmAssetGrid').css('visibility', 'visible');
    $('#CrmAssetGrid').show();
    $("#CRMRequestGrid").empty();
    $('#btnSave').prop('disabled', false);
    $('#btnSaveandAddNew').prop('disabled', false);
    $("#lblCrmObsolete").html("Asset No. ");
    var requesttyp = $('#TypeOfRequest').val();
    $.each(getResult.CRMRequestGridData, function (index, value) {
        AddNewRowCRMRequest();

        // $("#hdnCrmReqdetId_" + index).val(getResult.CRMRequestGridData[index].CRMRequestDetId);
        if (requesttyp == 374) {
            $("#Isdeleted_" + index).prop('disabled', true);
            $("#chk_CrmReq").prop('disabled', true);
        }
        $("#CrmreqAssetNo_" + index).val(getResult.CRMRequestGridData[index].AssetNo).prop('disabled', true);
        $("#hdnCrmreqAssetId_" + index).val(getResult.CRMRequestGridData[index].AssetId).prop('disabled', true);
        $("#CrmReqSerNo_" + index).val(getResult.CRMRequestGridData[index].SerialNo).prop('disabled', true);
        $("#CrmReqSoftVer_" + index).val(getResult.CRMRequestGridData[index].SoftwareVersion).prop('disabled', true);
    });

    if (requesttyp != 374) {
        $("#chk_CrmReq").prop('disabled', false);
    }
}



function goBack() {
    window.location.replace("/bems/CRMRequest");

}

$("#btnCancel").click(function () {
    var message = Messages.Reset_Alert_CONFIRMATION;
    bootbox.confirm(message, function (result) {
        if (result) {
            $('#TypeOfServiceRequest').val(0);
            EmptyFields();
            location.reload();
        }
        else {
            $('#myPleaseWait').modal('hide');
        }
    });
});
function EmptyFieldss() {
    $('#crmReqPriority').val('null');
    $('#TypeOfServiceRequest').val(0);
}

$("#jQGridCollapse1").click(function () {
    // $(".jqContainer").toggleClass("hide_container");
    var pro = new Promise(function (res, err) {
        $(".jqContainer").toggleClass("hide_container");
        res(1);
    })
    pro.then(
        function resposes() {
            setTimeout(() => $(".content").scrollTop(3000), 1);
        })
})

$('#btnAddNew').on('click', function () {

    window.location.replace("/bems/CRMRequest/add");
});


function AddNewRow() {
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    var rowCount = $('#CRMRequestGrid tr:last').index();
    var TypecodeCount = $('#CrmreqAssetNo_' + rowCount).val();
    if (rowCount < 0)
        AddNewRowCRMRequest();
    else if (rowCount >= "0" && TypecodeCount == "") {
        bootbox.alert("Please enter values in existing row");
    }
    else {
        AddNewRowCRMRequest();
    }
}

function AddNewRowCRMRequest() {
    var inputpar = {
        inlineHTML: AddNewRowCRMRequestHtml(),
        IdPlaceholderused: "maxindexval",
        TargetId: "#CRMRequestGrid",
        TargetElement: ["tr"]
    }

    AddNewRowToDataGrid(inputpar);

    var rowCount = $('#CRMRequestGrid tr:last').index();
    $('#CrmreqAssetNo_' + rowCount).focus();
    formInputValidation("Testform");
}

function AddNewRowCRMRequestHtml() {

    return ' <tr class="ng-scope" style=""><td width="5%" data-original-title="" title=""><div class="checkbox text-center"> <label for="checkboxes-0"> <input type="checkbox" id="Isdeleted_maxindexval" value="false" autocomplete="off" class="ng-pristine ng-untouched ng-valid" onchange="IsDeleteCheckAll(CRMRequestGrid,chk_CrmReq)"> </label></div> \
                        <input type="hidden" width="0%" id="hdnCrmReqdetId_maxindexval"></td> \
                    <td width="45%" style="text-align:left;" data-original-title="" title=""><div> <input type="text" id="CrmreqAssetNo_maxindexval" class="form-control" autocomplete="off" placeholder="Please Select" onkeyup="FetchAsset(event,maxindexval)" onpaste="FetchAsset(event,maxindexval)" change="FetchAsset(event,maxindexval)" oninput="FetchAsset(CrmreqAssetNo_maxindexval,maxindexval)" required></div> \
                        <input type="hidden" id="hdnCrmreqAssetId_maxindexval"><div class="col-sm-12" id="CRMAssetNoFetch_maxindexval"></div></td> \
                    <td width="25%" style="text-align: left;" data-original-title="" title=""><div> <input type="text" id="CrmReqSerNo_maxindexval" class="form-control" autocomplete="off" disabled></div></td> \
                    <td width="25%" style="text-align: center;" data-original-title="" title=""><div> <input type="text" id="CrmReqSoftVer_maxindexval" class="form-control" autocomplete="off" disabled></div></td></tr>'
}
//-----------------------------Modified on 15/10/2019---------------------------------search--------------------------------------------------------------------------------------------------//
var FetchModelObj = {
    Heading: "Model Details",//Heading of the popup
    SearchColumns: ['Model-Model', ],//ModelProperty - Space seperated label value
    ResultColumns: ["ModelId-Primary Key", 'Model-Model', 'Manufacturer-Manufacturer', ],//Columns to be returned for display
    FieldsToBeFilled: ["hdncrmReqModId-ModelId", 'crmReqModel-Model', "hdncrmReqManuId-ManufacturerId", 'crmReqManu-Manufacturer', ]//id of element - the model property--, , 
};
$('#spnPopup-RequestMdl').click(function () {
    var RequestServiceList = 0;
    RequestServiceList = $('#TypeOfServiceRequest').val();
    var FetchModelObjs = {
        Heading: "Model Details",//Heading of the popup
        SearchColumns: ['Model-Model', ],//ModelProperty - Space seperated label value
        ResultColumns: ["ModelId-Primary Key", 'Model-Model', 'Manufacturer-Manufacturer', ],//Columns to be returned for display
        FieldsToBeFilled: ["hdncrmReqModId-ModelId", 'crmReqModel-Model', "hdncrmReqManuId-ManufacturerId", 'crmReqManu-Manufacturer', ],//id of element - the model property--, , 
        TypeOfServices: RequestServiceList
    };
    DisplaySeachPopup('divSearchPopup', FetchModelObjs, "/api/Search/ModelSearch");

});

//--------------------------------------------------------------search--------------------------------------------------------------------------------------------------//

var FetchUserLocationObj = {
    Heading: "Location Details",//Heading of the popup
    SearchColumns: ['UserLocationName-Location Name', ],//Id of Fetch field
    ResultColumns: ["UserLocationId-Primary Key", 'UserLocationName-Location Name', 'UserAreaName-Area Name', 'BlockName-Block Name', 'LevelName-Level Name', ],//Columns to be displayed
    AdditionalConditions: ["UserAreaId-hdnCrmReqUsrAreaCdId", ],
    FieldsToBeFilled: ["hdnCrmReqUsrLocCdeId-UserLocationId", 'CrmReqUsrLocCde-UserLocationCode', 'CrmReqUsrLocNam-UserLocationName', 'CrmReqUsrAreaCd-UserAreaCode', 'hdnCrmReqUsrAreaCdId-UserAreaId', 'CrmReqUsrAreaNam-UserAreaName', 'CrmReqUsrBlockNam-BlockName', 'CrmReqUsrBlockCd-BlockCode', 'CrmReqUsrLevelCd-LevelCode', 'CrmReqUsrLevelNam-LevelName', ]//id of element - the model property
};
$('#spnPopup-ReqUsrLocCde').click(function () {
    DisplaySeachPopup('divSearchPopup', FetchUserLocationObj, "/api/Search/LocationCodeSearch");
});
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
//function ConvertWorkorder(reqid, reqno, reqtyp) {

function FetchModel(event) {

    var ItemMst = {
        SearchColumn: 'crmReqModel' + '-Model',//Id of Fetch field
        ResultColumns: ["ModelId" + "-Primary Key", 'Model' + '-crmReqModel'],//Columns to be displayed
        //AdditionalConditions: ["AssetClassificationId-EODParamMapClss", "Model-crmReqModel"],
        FieldsToBeFilled: ["hdncrmReqModId" + "-ModelId", 'crmReqModel' + '-Model', "hdncrmReqManuId" + "-ManufacturerId", 'crmReqManu' + '-Manufacturer']//id of element - the model property
    };
    DisplayFetchResult('ModelFetch', ItemMst, "/api/Fetch/ModelFetch", "Ulfetch1", event, 1);
}

function FetchManufacturer(event) {
    var ItemMst = {
        SearchColumn: 'crmReqManu' + '-Manufacturer',//Id of Fetch field
        ResultColumns: ["ManufacturerId" + "-Primary Key", 'Manufacturer' + '-crmReqManu'],//Columns to be displayed
        AdditionalConditions: ["Manufacturer-crmReqManu", "ModelId-hdncrmReqModId"],
        FieldsToBeFilled: ["hdncrmReqManuId" + "-ManufacturerId", 'crmReqManu' + '-Manufacturer']//id of element - the model property
    };
    DisplayFetchResult('ManuFetch', ItemMst, "/api/Fetch/ManufacturerFetch", "Ulfetch2", event, 1);
}

function FetchUserArea(event) {
    var ItemMst = {
        SearchColumn: 'CrmReqUsrAreaCd' + '-UserAreaCode',//Id of Fetch field
        ResultColumns: ["UserAreaId" + "-Primary Key", 'UserAreaCode' + '-CrmReqUsrAreaCd'],//Columns to be displayed
        //AdditionalConditions: ["Manufacturer-crmReqManu", "ModelId-hdncrmReqModId"],
        FieldsToBeFilled: ["hdnCrmReqUsrAreaCdId" + "-UserAreaId", 'CrmReqUsrAreaCd' + '-UserAreaCode', 'CrmReqUsrAreaNam' + '-UserAreaName']//id of element - the model property
    };
    DisplayFetchResult('UserAreaCodeFetch', ItemMst, "/api/Fetch/UserAreaFetch", "Ulfetch3", event, 1);
}

function FetchUserLocation(event) {
    var ItemMst = {
        SearchColumn: 'CrmReqUsrLocCde' + '-UserLocationCode',//Id of Fetch field
        ResultColumns: ["UserLocationId" + "-Primary Key", 'UserLocationCode' + '-CrmReqUsrLocCde'],//Columns to be displayed
        AdditionalConditions: ["UserAreaId-hdnCrmReqUsrAreaCdId"],
        FieldsToBeFilled: ["hdnCrmReqUsrLocCdeId" + "-UserLocationId", 'CrmReqUsrLocCde' + '-UserLocationCode', 'CrmReqUsrLocNam' + '-UserLocationName', 'CrmReqUsrAreaCd' + '-UserAreaCode', 'hdnCrmReqUsrAreaCdId' + '-UserAreaId', 'CrmReqUsrAreaNam' + '-UserAreaName', 'CrmReqUsrBlockNam' + '-BlockName', 'CrmReqUsrBlockCd' + '-BlockCode', 'CrmReqUsrLevelCd' + '-LevelCode', 'CrmReqUsrLevelNam' + '-LevelName']//id of element - the model property
    };
    DisplayFetchResult('UserLocFetch', ItemMst, "/api/Fetch/LocationCodeFetch", "Ulfetch4", event, 1);
}

function FetchReqPerson(event) {
    var ItemMst = {
        SearchColumn: 'crmReqReqPer' + '-StaffName',//Id of Fetch field
        ResultColumns: ["StaffMasterId" + "-Primary Key", 'StaffName' + '-crmReqReqPer'],//Columns to be displayed
        //AdditionalConditions: ["UserAreaId-hdnCrmReqUsrAreaCdId"],
        FieldsToBeFilled: ["hdncrmReqReqPeId" + "-StaffMasterId", 'crmReqReqPer' + '-StaffName', ]//id of element - the model property
    };
    DisplayFetchResult('ReqPeFetch', ItemMst, "/api/Fetch/FacilityStaffFetch", "Ulfetch5", event, 1);
}

function FetchAssignee(event) {
    var ItemMst = {
        SearchColumn: 'crmReqAssigne' + '-StaffName',//Id of Fetch field
        ResultColumns: ["StaffMasterId" + "-Primary Key", 'StaffName' + '-crmReqAssigne'],//Columns to be displayed
        //AdditionalConditions: ["UserAreaId-hdnCrmReqUsrAreaCdId"],
        FieldsToBeFilled: ["hdncrmReqAssigneId" + "-StaffMasterId", 'crmReqAssigne' + '-StaffName', 'hdncrmReqAssigneEmail' + '-Email']//id of element - the model property
    };
    DisplayFetchResult('AssigneFetch', ItemMst, "/api/Fetch/CompanyStaffFetch", "Ulfetch6", event, 1);
}

function FetchRequester(event) {
    var ItemMst = {
        SearchColumn: 'crmReqRequester' + '-StaffName',//Id of Fetch field
        ResultColumns: ["StaffMasterId" + "-Primary Key", 'StaffName' + '-crmReqRequester'],//Columns to be displayed
        FieldsToBeFilled: ["hdncrmReqRequesterId" + "-StaffMasterId", 'crmReqRequester' + '-StaffName', 'hdncrmReqRequesterEmail' + '-StaffEmail']//id of element - the model property
    };
    DisplayFetchResult('RequesterFetch', ItemMst, "/api/Fetch/FetchRecords", "Ulfetch8", event, 1);
}

function FetchCompletedby(event) {
    var ItemMst = {
        SearchColumn: 'Completedby' + '-StaffName',//Id of Fetch field
        ResultColumns: ["StaffMasterId" + "-Primary Key", 'StaffName' + '-Completedby'],//Columns to be displayed
        FieldsToBeFilled: ["hdncrmReqCompletedbyId" + "-StaffMasterId", 'Completedby' + '-StaffName', 'hdncrmReqCompletedbyEmail' + '-StaffEmail']//id of element - the model property
    };
    DisplayFetchResult('CompletedbyFetch', ItemMst, "/api/Fetch/FetchRecords", "Ulfetch10", event, 1);
}
function FetchResponseby(event) {
    var ItemMst = {
        SearchColumn: 'Responseby' + '-StaffName',//Id of Fetch field
        ResultColumns: ["StaffMasterId" + "-Primary Key", 'StaffName' + '-Responseby'],//Columns to be displayed
        FieldsToBeFilled: ["hdncrmReqResponsebyId" + "-StaffMasterId", 'Responseby' + '-StaffName', 'hdncrmReqResponsebyEmail' + '-StaffEmail']//id of element - the model property
    };
    DisplayFetchResult('ResponsebyFetch', ItemMst, "/api/Fetch/FetchRecords", "Ulfetch13", event, 1);
}

function FetchWOAssignee(event) {
    var ItemMst = {
        SearchColumn: 'CrmreqReqWOAss-StaffName',//Id of Fetch field
        ResultColumns: ["StaffId" + "-Primary Key", 'StaffName' + '-CrmreqReqWOAss'],//Columns to be displayed
        //AdditionalConditions: ["TypeOfRequest-TypeOfRequest"],
        FieldsToBeFilled: ["hdncrmReqWOAssigneId" + "-StaffId", 'CrmreqReqWOAss' + '-StaffName', 'hdncrmReqWOAssigneEmail' + '-StaffEmail']//id of element - the model property
    };
    // DisplayFetchResult('StaffFetch', ItemMst, "/api/Fetch/CompanyStaffFetch", "Ulfetch3", event, 1);
    DisplayFetchResult('WOAssigneFetch', ItemMst, "/api/Fetch/CRMWorkorderStaffFetch", "Ulfetch9", event, 1);

}

//fetch - Asset No 
var AssetNoFetchObj = {
    SearchColumn: 'txtAssetNo-AssetNo',//Id of Fetch field
    ResultColumns: ["AssetId-Primary Key", 'AssetNo-AssetNo'],
    FieldsToBeFilled: ["hdnAssetId-AssetId", "txtAssetNo-AssetNo", "txtAsset_Name-Asset_Name", "hdnCrmReqUsrLocCdeId-UserLocationId", 'CrmReqUsrLocCde-UserLocationCode', 'CrmReqUsrLocNam-UserLocationName', 'CrmReqUsrAreaCd-UserAreaCode', 'hdnCrmReqUsrAreaCdId-UserAreaId', 'CrmReqUsrAreaNam-UserAreaName', 'CrmReqUsrBlockNam-BlockName', 'CrmReqUsrBlockCd-BlockCode', 'CrmReqUsrLevelCd-LevelCode', 'CrmReqUsrLevelNam-LevelName']
};

$('#txtAssetNo').on('input propertychange paste keyup', function (event) {
    //AssetNoFetchObj.TypeCode = $('#hdnAssetTypeCodeId').val();
    var UserAreaId = $('#TypeOfServiceRequest').val();
    DisplayLocationCodeFetchResult('divAssetNoFetch', AssetNoFetchObj, "/api/Fetch/CrmAssetNoFetch", "UlFetch14", event, 1, UserAreaId);//1 -- pageIndex
 
});


//$("#txtAssetNo").blur(function () {
//    FetchUserLocation(event);
//});

//$("#CrmReqUsrLocCde").change(function () {
//    FetchUserLocation(event);
//});

//$('#CrmReqUsrLocCde').on('input', function () {
//    console.log("Input text changed!");
//});

function FetchAsset(event, index) {
    if (index > 0) {
        if ($('#CRMAssetNoFetch_' + index + ' .not-found').length) {
            $('#CRMAssetNoFetch_' + index).css({
                //'top': 0,
                'width': $('#CrmreqAssetNo_' + index).outerWidth()
            });
        } else {
            $('#CRMAssetNoFetch_' + index).css({
                'top': $('#CrmreqAssetNo_' + index).offset().top - $('#CRMRequestTable').offset().top + $('#CrmreqAssetNo_' + index).innerHeight(),
                'width': $('#CrmreqAssetNo_' + index).outerWidth()
            });
        }
    }
    else {
        $('#CRMAssetNoFetch_' + index).css({
            'width': $('#CrmreqAssetNo_' + index).outerWidth()
        });
    }

    var ItemMst = {
        SearchColumn: 'CrmreqAssetNo_' + index + '-AssetNo',//Id of Fetch field
        ResultColumns: ["AssetId" + "-Primary Key", 'AssetNo' + '-CrmreqAssetNo_' + index],//Columns to be displayed
        AdditionalConditions: ["ModelId-hdncrmReqModId", "ManufacturerId-hdncrmReqManuId"],
        FieldsToBeFilled: ["hdnCrmreqAssetId_" + index + "-AssetId", 'CrmreqAssetNo_' + index + '-AssetNo', 'CrmReqSerNo_' + index + '-SerialNo', 'CrmReqSoftVer_' + index + '-SoftwareVersion']//id of element - the model property
    };
    DisplayFetchResult('CRMAssetNoFetch_' + index, ItemMst, "/api/Fetch/CRMRequestAssetFetch", "Ulfetch7" + index, event, 1);
}


//function ConvertWorkorder() {
//    var reqid = $('#CRMRequestId').val();
//    var reqno = $('#RequestNo').val();
//    var reqtyp = $("#TypeOfRequest").val();

//    window.location.replace("/bems/CRMWorkorder/add?reqid=" + reqid + "&reqno=" + reqno + "&reqtyp=" + reqtyp);

//    // $.get("/api/CRMWorkorder/Add/")
//}




function AddNewRowRemarksHistory() {
    var inputpar = {
        inlineHTML: RemarksHistoryHtml(),
        IdPlaceholderused: "maxindexval",
        TargetId: "#CrmReqRemarksGrid",
        TargetElement: ["tr"]
    }

    AddNewRowToDataGrid(inputpar);

    var rowCount = $('#CRMRequestGrid tr:last').index();
    //$('#CrmreqAssetNo_' + rowCount).focus();
    formInputValidation("Testform");
}

function RemarksHistoryHtml() {

    return ' <tr class="ng-scope" style=""><td width="5%" style="text-align: center;"><div> <input type="text" id="CRMReqRemHisSNo_maxindexval" name="SystemTypeCode" class="form-control" autocomplete="off" disabled></div></td> \
                <td width="35%" style="text-align: center;"><div> <input id="CRMReqRemHisRemarks_maxindexval"type="text" class="form-control" name="SystemTypeDescription" autocomplete="off" disabled></div></td> \
                <td width="20%" style="text-align: center;"><div> <input id="CRMReqRemHisEntby_maxindexval"type="text" class="form-control" name="SystemTypeDescription" autocomplete="off" disabled></div></td> \
                <td width="20%" style="text-align: center;"><div> <input type="text" id="CRMReqRemHisDate_maxindexval" name="SystemTypeCode" class="form-control datatimepicker" autocomplete="off" disabled></div></td> \
                <td width="20%" style="text-align: center;"><div> <input id="CRMReqRemHisStatus_maxindexval" type="text" class="form-control datatimepicker" name="SystemTypeDescription" autocomplete="off" disabled></div></td></tr>'
}

function disableFields() {
    $('#TypeOfRequest').prop("disabled", true);
    $('#RequestDateTime').prop('disabled', true);
    $('#crmReqModel').prop("disabled", true);
    $('#crmReqManu').prop('disabled', true);
    $('#CrmReqUsrAreaCd').prop("disabled", true);
    $('#CrmReqUsrLocCde').prop('disabled', true);
    $('#RequestDescription').prop('disabled', true);
    $('#CrmReqUsrLocNam').prop('disabled', true);

    $('#crmReqReqPer').prop('disabled', true);
    $('#crmReqAssigne').prop('disabled', true);
    $('#crmReqRequester').prop('disabled', true);
}


function disableGridFields(index, value) {
    $('#Isdeleted_' + index).prop('disabled', true);
    $('#CrmreqAssetNo_' + index).prop('disabled', true);
    $('#chk_CrmReq').prop('disabled', true);
}
function ServiceClicked() {

    $('#TypeOfDeduction').empty();
    var ID = $("#TypeOfServiceRequest").val();
    $.get("/api/CRMRequestApi/get_Indicator_by_Serviceid/" + ID)
        .done(function (result) {
            $(result.Indicators).each(function (_index, _data) {
                $('#TypeOfDeduction').append($('<option></option>').val(_data.LovId).html(_data.FieldValue));
            });
        }).fail(function (result) {

        });
}


function LinkClicked(id) {

    EmptyFields(true);
    
    // $('#testAction').css('visibility', 'hidden');
    //  $('#RequestAction').css('visibility', 'hidden');
    $('#RequestActionLLS').prop("disabled", false);
    $('#JustificationLLS').prop("disabled", false);
    $('#selWorkGroupGM').prop("disabled", false);
    $(".content").scrollTop(1);
    $('.nav-tabs a:first').tab('show');
    $("#Testform :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('#TypeOfServiceRequest').prop("disabled", true);
    $('#TypeOfRequest').prop("disabled", false);
    $('#TypeOfServiceRequest').prop("required", false);
    //-----------------
    $('#NonConformanceRequestDescription').prop('required', false);
    $('#TypeOfDeduction').prop('required', false);
    $('#crmReqPriority').prop('required', false);
    $('#txtAssetNo').prop('disabled', false);
    $('#Responseby').prop('required', true);

    //  $("#SummaryResultId").empty();
    //------------------

    var action = "";
    $('#primaryID').val(id);
    var hasEditPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Edit'");
    var hasViewPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='View'");
    var hasDeletePermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Delete'");

    if (hasEditPermission) {
        action = "Edit"

    }
    else if (!hasEditPermission && hasViewPermission) {
        action = "View"
    }
    if (action == "Edit" && hasDeletePermission) {
        $('#btnDelete').show();
    }

    if (action == 'View') {
        $("#Testform:input:not(:button)").prop("disabled", false);
    } else {
        $('#btnEdit').show();
        $('#btnSave').hide();
        //$('#btnSaveandAddNew').hide();
        $('#btnNextScreenSave').show();
        $('#btnDelete').show();
    }

    $('#spnActionType').text(action);
    pageindex = 1;
    var reqid = $("#primaryID").val();
    if (action !== "Add") {
        var jqxhr = $.get("/api/CRMRequestApi/get/" + reqid + "/" + pagesize + "/" + pageindex, function (response) {
            var result = JSON.parse(response);
            var htmlval = ""; $('#tablebody').empty();
            $('#myTable').empty();
            
            BindDatatoHeader(result);
            BindGridData(result);
            if (result.RequestStatus == 139) {
                if (action == "Edit" && hasDeletePermission) {
                    $('#btnDelete').show();
                }

            } else {

                $('#btnDelete').hide();
            }
            $('#txtAssetNo').prop('disabled', false);
            //bindDatatoDatagrid(result.ItemMstFetchEntityList);
            if (result.TypeOfRequest == 10020 && result.RequestStatus == 139) {
                if (action == "View") {
                    $("#Testform:input:not(:button)").prop("disabled", false);
                    $('#NonConformanceRequestDescription').prop('disabled', true);
                    $('#TypeOfServiceRequest').prop('disabled', true);
                    $('#crmReqRequester').prop('disabled', true);
                    $('#test').prop('disabled', true)
                    $('#RequestNo').prop('disabled', true);
                    $('#TypeOfRequest').prop('disabled', true);
                    $('#ServiceIndicator').prop('disabled', true);
                    $('#RequestDateTime').prop('disabled', true)
                    $('#RequestStatus').prop('disabled', true)
                    $('#LlsRemarks').css('visibility', 'hidden');
                    //$('#txtAssetNo').prop('disabled', true);
                    if (getResult.RequestStatus == 140) {
                        $('#RequestAction').prop('disabled', true);
                        $('#ResponceDateTime').prop('disabled', true);
                        $('#Responseby').prop('disabled', true);
                        $('#lblCrmReqRem').show();
                        $("#Remarks").show();
                        $('#LlsRemarks').css('visibility', 'visible');
                        $("#lblcrmAction").html("Action Taken<span class='red'>*</span>");
                        //$('#txtAssetNo').prop('disabled', true);
                    }
                    $("#addnewrowbtn,#savebtn,#uploadbtn,#exportbtn,#addnewbtn").hide();
                }
            }
            else {
                if (action == "View") {
                    $("#Testform:input:not(:button)").prop("disabled", true);
                    $("#addnewrowbtn,#savebtn,#uploadbtn,#exportbtn,#addnewbtn").hide();
                }
            }

            setTimeout(function () {
                $("#top-notifications").modal('hide');
            }, 5000);
            $('#btnSave').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            $('#selWorkGroupGM').prop('disabled', false);
            $('#selWasteCategory').prop('disabled', false);
        })
            .fail(function (response) {
                var errorMessage = "";
                if (response.status == 400) {
                    errorMessage = response.responseJSON;
                }
                else {
                    errorMessage = Messages.COMMON_FAILURE_MESSAGE(response);
                }
                $("div.errormsgcenter").text(errorMessage);
                $('#errorMsg').css('visibility', 'visible');
                $('#btnSave').attr('disabled', false);
                $('#myPleaseWait').modal('hide');
            });

    }
}
///////--validation


$("#btnDelete").click(function () {
    var ID = $('#primaryID').val();
    var RequestStatus = $("#RequestStatus").val();
    var Remarks = $("#Remarks").val();
    var typeofreq = $("#TypeOfRequest").val();
    if (RequestStatus == 139 && Remarks != "") {
        // bootbox.alert("Sorry!. You cannot delete all rows");
        confirmDelete(ID);
    } else {
        if (typeofreq == 10020) {
            confirmDelete(ID);
        } else {
            bootbox.alert("Please Enter Remarks");
        }

        // bootbox.show("Please Enter Remarks");
        //  confirmDelete(ID);
    }


});
function confirmDelete(ID) {
    var message = Messages.SEARCH_GRID_DELETE_CONFIRMATION;
    var pageId = $('.ui-pg-input').val();
    var Remarks = $("#Remarks").val();

    $("#Remarks").prop('required', true);

    bootbox.confirm(message, function (result) {
        if (result) {
            $.get("/api/CRMRequestApi/Cancel/" + ID + "/" + Remarks)
                .done(function (result) {
                    filterGrid();
                    showMessage('CRMRequestApi', CURD_MESSAGE_STATUS.DS);
                    $('#myPleaseWait').modal('hide');
                    EmptyFields();
                })
                .fail(function () {
                    showMessage('CRMRequestApi', CURD_MESSAGE_STATUS.DF);
                    $('#myPleaseWait').modal('hide');
                });
        }

    });
}
function EmptyFieldsService() {
    $("#TypeOfServiceRequest").val('');
}
function EmptyFields(fromLink) {
    $('#RequestedDateTime').val('');
    //
    $('#lblcrmActionLLS').show();
    $('#Popup-RequestMdl').show();
    $('#spnPopup-RequestMdl').show();
    //  $('#lblCrmReqRem').hide();
    $('#CompleteDateTime').hide();
    $('#CompleteDateTimeLLS').hide();
    $('#Responseby').hide();
    $('#ActionLLS').hide();
    $('#ResponceDateTime').prop('required', false);
    $('#CompleteDateTime').prop('required', false);
    $('#Completedby').prop('required', false);
    $('input[type="text"], textarea').val('');
    $('#btnEdit').hide();
    $('#btnSave').show();
    $('#TypeOfServiceRequest').prop("disabled", false);
    $('#btnSaveandAddNew').show();
    $('#TypeOfDeduction').val('Select');
    $('#btnDelete').hide();
    $('#btnNextScreenSave').hide();
    $('#spnActionType').text('Add');
    $("#primaryID").val('');
    $("#TypeOfRequest").val('');
    //$("#RequestDateTime").val('');
    //$("#TypeOfServiceRequest").val('null');
    $("#RequestStatus").val(139);
    if (fromLink == undefined) {
        $("#grid").trigger('reloadGrid');
    }
    $("#Assessment").hide();
    $("#Testform:input:not(:button)").parent().removeClass('has-error');
    $("#Remarks").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('#crmReqModel').prop('disabled', false);
    $('#crmReqModel').prop('required', false);
    $("#lblCrmreqMod").html("Model");
    $('#AreaLocDiv').css('visibility', 'hidden');
    $('#AreaLocDiv').hide();
    $("#CrmReqUsrAreaCd").prop('disabled', true);
    $('#CrmReqUsrLocCde').prop('disabled', false);
    $("#RequestDescription").prop('disabled', false);
    $("#Remarks").prop('disabled', false).prop('required', false);
    $("#crmReqManu").prop('disabled', false);
    $('#crmReqReqPer').prop('disabled', false);
    $('#crmReqAssigne').prop('disabled', false);
    $("#lblCrmReqRem").html("Remarks");
    $('#btnSaveConverttoWO').css('visibility', 'hidden');
    $('#btnSaveConverttoWO').hide();
    $('#ReqTypTCDiv').css('visibility', 'hidden');
    $('#ReqTypTCDiv').hide();
    $('#crmObsoleteSec').css('visibility', 'hidden');
    $('#crmObsoleteSec').hide();
    $('#AreaLocDiv').css('visibility', 'hidden');
    $('#AreaLocDiv').hide();
    $('#ReqTypTCEngDiv').css('visibility', 'hidden');
    $('#ReqTypTCEngDiv').hide();
    $('#crmReqAssigne').prop('required', false);
    $("#lblCrmreqReqAssi").html("Assignee");
    $('#ReqTypTCEngDiv').css('visibility', 'hidden');
    $('#ReqTypTCEngDiv').hide();
    $('#ReqTypTCDiv').css('visibility', 'hidden');
    $('#ReqTypTCDiv').hide();
    $('#CrmAssetGrid').css('visibility', 'hidden');
    $('#CrmAssetGrid').hide();
    $('#CrmReqPlus').hide();
    $('#divWOStatus').text('');
    $('#crmReqRequester').val('').prop('disabled', false);
    $('#crmReqTarDat').prop('disabled', false);
    $('#paginationfooter').hide();
    $('#btnSave').prop('disabled', false);
    $('#btnSaveandAddNew').prop('disabled', false);
    $('#btnVerify').hide();
    $('#btnClarify').hide();
    $('#btnApprove').hide();
    $('#btnReject').hide();
    $("#Testform:input:not(:button)").parent().removeClass('has-error');
    $(".form-control").parent().removeClass('has-error');
    var today = new Date();
    var CurDate = GetCurrentDate();
    var hour = today.getHours();
    var time = today.getMinutes();
    if (time < 10) {
        time = 0 + '' + time;
    }
    var gettime = hour + ":" + time;

    var CurDateTime = CurDate + " " + gettime;
    $('#RequestDateTime').val(CurDateTime);
    $("#RequestDateTime").prop('disabled', false);
    $("#crmReqTarDat").prop('disabled', false);
    $('#crmReqTarDat').css("background-color", "#fff");
    //$('#btnApprove').css('visibility', 'hidden');
    //$('#btnApprove').hide();
    //$('#btnReject').css('visibility', 'hidden');
    //$('#btnReject').hide();
    $('#WorkAssiDiv').css('visibility', 'hidden');
    $('#WorkAssiDiv').hide();
    $("#RequestAction").prop('disabled', false);
    $('#DeductionIndDiv').hide();
    $("#RemarkLls").prop('disabled', false);
    $("#TypeOfRequest").prop('disabled', false);
    $("#RequestDateTime").prop('disabled', true);
    $('#selWorkGroupGM').prop('disabled', false);

}

function BindDatatoHeader(getResult) {

    disableFields();
    var primaryId = $('#primaryID').val();
    $('#crmReqManu').prop('required', false);
    $('#ResponceDateTime').prop('required', false);
    $('#CompleteDateTime').prop('required', false);
    $('#Completedby').prop('required', false);
    $("#indicatorDiv").hide();
    $('#Responseby').prop('required', false);
    $('#Responseby').prop('disabled', false);
    $('#ResponceDateTime').prop('required', false);
    $('#ResponceDateTime').prop('disabled', false);
    //$('#DateTimeDiv').show();
    $('#crmReqPriority').prop('disabled', true);
    $('#Vaidation').prop('disabled', false);
    $('#crmReqTarDat').val(DateFormatter(getResult.TargetDate));
    $('#crmReqPriority').prop('required', false);
    $('#AreaLocDiv').css('visibility', 'hidden');
    $('#AreaLocDiv').hide();
    if (getResult.RequestStatus != 142) {
        $('#AttachRowPlus').show();
        $('#btnEditAttachment').show();
    }
    $("#btnDelete").show();
    $("#chk_CrmReq").prop("checked", false);
    $("#primaryID").val(getResult.CRMRequestId);
    $("#hdnAttachId").val(getResult.HiddenId);
    $("#hdnCrmReqChkstsApp").val(getResult.ChkStsApproveorNot);

    var hasApprovePermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Approve'");

    if (getResult.CRMRequestId > 0) {
        $("#lblCrmReqRem").html("Remarks <span class='red'>*</span>");
        $("#Remarks").prop('required', true);
        $("#Remarks").val(getResult.Remarks);
        $("#TypeOfRequest").prop('disabled', true);
    }

    $("#divWOStatus").text(getResult.WorkOrderStatus);
    $("#RequestNo").val(getResult.RequestNo);
    $("#Designation").val(getResult.Designation);
    $("#MobileNumber").val(getResult.MobileNumber);
    $("#RequestDateTime").val(moment(getResult.RequestDateTime).format("DD-MMM-YYYY HH:mm")).prop("disabled", true);

    if ((moment(getResult.RequestedDate).format("DD-MMM-YYYY HH:mm")) == "01-Jan-0001 00:00") {
        $('#RequestedDateTime').val("").prop("disabled", true);

    }
    else
    {
        $('#RequestedDateTime').val(moment(getResult.RequestedDate).format("DD-MMM-YYYY HH:mm")).prop("disabled", true);

    }
    $("#crmReqRequester").val(getResult.ReqStaff);
    $("#hdncrmReqRequesterId").val(getResult.ReqStaffId);
    $("#hdncrmReqRequesterEmail").val(getResult.RequesterEmail);
    // moment(getResult.AssessmentStartDate).format("DD-MMM-YYYY HH:mm")

    //print form binding///
    $('#txt_RequestDT').text(moment(getResult.RequestDateTime).format("DD-MMM-YYYY HH:mm"));
    $("#txt_SRNO1").text(getResult.RequestNo);
    $("#txt_RequestBys").text(getResult.ReqStaff);
    $("#txt_JobTitle").text(getResult.Designation);
    $("#txt_ContactNo").text(getResult.MobileNumber);
    $('#txt_LocationCode1').text(getResult.UserLocationCode);
    $('#txt_LocationName1').text(getResult.UserLocationName);
    $('#txt_Dep').text(getResult.UserAreaCode);
    $("#txt_RequestDetails1").text(getResult.RequestDescription);
    $("#servicetype").val(getResult.ServiceKey1);
    $("#prioritystatus").val(getResult.CRMRequest_PriorityStatus);
    $("#txt_storetype").text(getResult.ServiceKey1);
    $("#txt_Priority1").text(getResult.CRMRequest_PriorityStatus);

    
    $("#hdnAssetId").val(getResult.AssetId);
    $("#txtAssetNo").val(getResult.AssetNo);

    /// End print form binding ///

    //if (getResult.IsReqTypeReferenced == 1) {
    $("#TypeOfRequest").val(getResult.TypeOfRequest).prop("disabled", false);

    $('#TypeOfServiceRequest option[value="' + getResult.ServiceId + '"]').prop('selected', true);

    var ServiceRequestID = $("#TypeOfServiceRequest").val();

    if (ServiceRequestID == 1) {
        $('#WorkGroupGMCDiv').show();
        $('#WasteCategoryDiv').hide();
        $("#selWorkGroupGM").val(getResult.WorkGroup);
        // $('#selWorkGroupGM').prop('disabled', false);
        $('#selWasteCategory').prop('required', false);
        $("#TypeOfRequest").val(getResult.TypeOfRequest);
    }
    if (ServiceRequestID == 5) {
        $('#WasteCategoryDiv').show();
        $('#WorkGroupGMCDiv').hide();
        $('#btnApprove').show();
        $('#btnReject').show();
        $('#btnClarify').show();
        $('#btnDelete').show();
        $('#btnCancel').show();
        $("#selWasteCategory").val(getResult.WasteCategory);
        $('#selWasteCategory').prop('disabled', false);
        $('#selWorkGroupGM').prop('required', false);
        $('#RequestDescription').prop('disabled', false);
        $("#RequestDescription").val(getResult.RequestDescription);
        $("#TypeOfRequest").val(getResult.TypeOfRequest);

    }
    if (ServiceRequestID == 2 || ServiceRequestID == 3 || ServiceRequestID == 4) {
        $('#WasteCategoryDiv').hide();
        $('#WorkGroupGMCDiv').hide();

        $('#selWorkGroupGM').prop('disabled', false);
        $('#selWasteCategory').prop('disabled', false);
        $("#TypeOfRequest").val(getResult.TypeOfRequest);

    }
    //}
    //else if (getResult.IsReqTypeReferenced == 0) {
    //    $("#TypeOfRequest").val(getResult.TypeOfRequest).prop("disabled", false)
    //}

    $('#crmReqPriority option[value="' + getResult.PriorityList + '"]').prop('selected', true);
    $("#RequestStatus").val(getResult.RequestStatus);
    $('#crmReqModel').val(getResult.Model);
    $('#hdncrmReqModId').val(getResult.ModelId);
    $('#crmReqManu').val(getResult.Manufacturer).prop("disabled", true);
    $('#hdncrmReqManuId').val(getResult.ManufacturerId);
    $("#hdnAssetId").val(getResult.AssetId);
    $("#txtAssetNo").val(getResult.AssetNo);

    $('#txtAssetNo').prop('disabled', false);
    if (getResult.TypeOfRequest == 10020 || getResult.TypeOfRequest == 10022) {
        $('#crmReqPriority').hide();
        $('#lblCrmpriority').hide();
        $('#DeductionIndDiv option:selected').text();
        $('#DeductionIndDiv').show();
        $('#divdeduction').hide();
    }
    if (getResult.TypeOfRequest == 10020) {
        ServiceClicked();
        $('#ServiceInd').show();
        $('#NonConformance').show();
        $("#Remarks").prop('disabled', false);
        $('#Popup-RequestMdl').hide();
        $('spnPopup-RequestMdl').hide();
        $('#NonConformanceRequestDescription').prop('disabled', true);
        $('#TypeOfServiceRequest').prop('disabled', true);
        $('#crmReqRequester').prop('disabled', true);
        $('#test').prop('disabled', true);
        $('#RequestNo').prop('disabled', true);
        $('#TypeOfRequest').prop('disabled', true);
        $('#ServiceIndicator').prop('disabled', true);
        $('#RequestDateTime').prop('disabled', true);
        $('#RequestStatus').prop('disabled', true);
        $('#crmReqPriority').hide();
        $('#lblCrmpriority').hide();
        $('#DeductionIndDiv').show();
        $('#Modelrow').hide();
        $('#RequestDescDiv').hide();
        $('#DateTimeDiv').show();
        $('#ResponceDateTime').show();
        $('#Responseby').show();
        $('#Responseby').prop('required', true);
        $('#Responseby').attr('required', true);
        $('#lblcrmAction').show();
        $("#TypeOfDeduction").hide();
        $('#DateTimeDiv').css('visibility', 'visible');
        $('#Actiontaken').show();
        $('#RequestAction').show();
        $('#RequestAction').css('visibility', 'visible');
        $('#test').show();
        $('#Status').show();
        $("#test").val(getResult.Indicator_Code);
        $("#hdnAssetId").val(getResult.AssetId);
        $("#txtAssetNo").val(getResult.AssetNo);

        $("#TypeOfRequest").val(getResult.TypeOfRequest);
        // $("#TypeOfDeduction").val(getResult.Indicator_ID);
        $("#ServiceIndicator").val(getResult.Indicator_Name);
        $("#NonConformanceRequestDescription").val(getResult.NCRDescription);
        $("#txt_RequestDetails1").text(getResult.NCRDescription);

        $('#printfm').hide();
        if (getResult.RequestStatus == 139) {
            $('#RequestAction').prop('disabled', false);
            $('#ResponceDateTime').prop('disabled', false)
            //   $('#Responseby').prop('disabled', false)
            $('#ResponceDateTime').show();
            $('#lblResponceDateTime').show();
            $('#ResponceDateTime').prop('required', true);
            $("#lblResponceDateTime").html("Response Date / Time <span class='red'>*</span>");
            $('#Responseby').show();
            $('#Responseby').prop('required', true);
            // $('#Responseby').prop('required', true);
            $('#Responseby').attr("required", "required");
            $("#lblResponseby").html("Response By <span class='red'>*</span>");
            $('#ResponceDateTimeAndResponseby').css('visibility', 'visible');
            $("#lblcrmActionLLS").html("Action Taken<span class='red'>*</span>");
            $("#hdnAssetId").val(getResult.AssetId);
            $("#txtAssetNo").val(getResult.AssetNo);
            $('#txtAssetNo').prop('disabled', true);
        }
        if (getResult.RequestStatus == 140) {
            $('#txtAssetNo').prop('disabled', true);
            $('#hdncrmReqResponsebyId').val(getResult.LLSResponse_by_ID);
            $('#Responseby').val(getResult.LLSResponse_by);
            $('#RequestAction').prop('disabled', true);
            $('#RequestAction').val(getResult.LLSAction_Taken);
            //$('#ResponceDateTime').prop('disabled', true);
            $('#ResponceDateTime').val(moment(getResult.Responce_Date).format("DD-MMM-YYYY HH:mm")).prop('disabled', true);
            $('#Responseby').prop('disabled', true);
            $("#Remarks").show();
            $('#lblCrmReqRem').show();
            $('#CompleteDateTimeLLS').show();
            $('#CompleteDateTime').show();
            $('#LlsRemarks').css('visibility', 'visible');
            $("#ServiceIndicator").val(getResult.Indicator_Name);
            $("#hdnAssetId").val(getResult.AssetId);
            $("#txtAssetNo").val(getResult.AssetNo);
            $("#NonConformanceRequestDescription").val(getResult.NCRDescription);
            $('#LlsRemarks').css('visibility', 'visible');
            $('#LlsRemarks').show();
            $('#ResponceDateTime').show();
            $('#ResponceDateTime').prop('required', true);
            $("#lblResponceDateTime").html("Response Date / Time <span class='red'>*</span>");
            $('#Responseby').show();
            $('#Responseby').prop('required', true);
            $('#Responseby').attr("required", "required");
            $("#lblResponseby").html("Response By <span class='red'>*</span>");
            $("#Remarks").prop('required', false);
            $('#RequestDescription').prop('required', false);
            $('#RemarkLls').prop('required', true);
            $("#lblCrmReqLLS").html("Remarks <span class='red'>*</span>");
            $("#LabCompleteDateTime").html("Completed Date / Time <span class='red'>*</span>");
            $("#LabCompletedby").html("Completed By <span class='red'>*</span>");
            $('#ResponceDateTimeAndResponseby').css('visibility', 'visible');
            $("#lblcrmAction").html("Action Taken<span class='red'>*</span>");
            $('#selWasteCategory').prop('required', false);
            $('#selWorkGroupGM').prop('required', false);

        }
        if (getResult.RequestStatus == 142) {
            $('#RequestAction').val(getResult.LLSAction_Taken);
            $('#ResponceDateTime').val(moment(getResult.Responce_Date).format("DD-MMM-YYYY HH:mm"));
            $('#hdncrmReqResponsebyId').val(getResult.LLSResponse_by_ID);
            $('#Responseby').val(getResult.LLSResponse_by);
            //$('#CompleteDateTime').prop('disabled', true);
            $('#RequestAction').prop('disabled', true);
            $('#ResponceDateTime').prop('disabled', true)
            $('#Responseby').prop('disabled', true)
            $('#lblCrmReqRem').show();
            $("#Remarks").show();
            $('#CompleteDateTimeLLS').show();
            $('#CompleteDateTime').show();
            $('#LlsRemarks').css('visibility', 'visible');
            $('#LlsRemarks').show();
            $('#RemarkLls').prop('disabled', true);
            $('#CompleteDateTimeLLS').prop('disabled', true);
            $('#Completedby').prop('disabled', true);
            $('#Completedby').val(getResult.Completed_By_Name);
            $('#CompleteDateTime').val(moment(getResult.Completed_Date).format("DD-MMM-YYYY HH:mm")).prop('disabled', true);;
            $('#RemarkLls').val(getResult.Remarks);
            $("#hdnAssetId").val(getResult.AssetId);
            $("#txtAssetNo").val(getResult.AssetNo);
            $("#ServiceIndicator").val(getResult.Indicator_Name);
            $("#test").val(getResult.Indicator_Code);
            $('#ResponceDateTimeAndResponseby').css('visibility', 'visible');
            $("#lblcrmAction").html("Action Taken<span class='red'>*</span>");
            $("#lblResponceDateTime").html("Response Date / Time <span class='red'>*</span>");
            $("#lblResponseby").html("Response By <span class='red'>*</span>");
            $("#lblCrmReqLLS").html("Remarks <span class='red'>*</span>");
            $("#LabCompletedby").html("Completed By <span class='red'>*</span>");
            $("#LabCompleteDateTime").html("Completed Date / Time <span class='red'>*</span>");
            $('#txtAssetNo').prop('disabled', true);
        }
    }

    $('#txtAssetNo').prop('disabled', false);
    if (getResult.TypeOfRequest == 136 || getResult.TypeOfRequest == 375) {
        $('#DeductionIndDiv').hide();
    }
    else {
        $('#DeductionIndDiv option:selected').text();
        $('#DeductionIndDiv').show();
        $('#divdeduction').hide();
    }

    if (getResult.TypeOfRequest == 134 || getResult.TypeOfRequest == 138) {
        $('#lblCrmReqRem').show();
        $('#AreaLocDiv').css('visibility', 'visible');
        $('#AreaLocDiv').show();
        $('#paginationfooter').hide();
        $('#ReqTypTCEngDiv').css('visibility', 'hidden');
        $('#ReqTypTCEngDiv').hide();
        $('#btnVerify').hide();
        $('#crmReqPriority').hide();
        $('#lblCrmpriority').hide();
        $('#crmReqManu').prop('required', false);
        //new comment on 10/10/19
        //$('#DateTimeDiv').hide();

        $('#DeductionIndDiv option:selected').text();
        $('#DeductionIndDiv').show();
        $('#divdeduction').hide();
        //  $("#labCrmReqAreaCd").html("Area Code <span class='red'>*</span>");
        $("#labCrmReqLocCd").html("Location Code <span class='red'>*</span>");
        // $('#CrmReqUsrAreaCd').prop('required', true);
        $('#CrmReqUsrLocCde').prop('required', true);

        if (hasApprovePermission == true && getResult.ChkStsApproveorNot == "Approve") {
            $('#WorkAssiDiv').css('visibility', 'visible');
            $('#WorkAssiDiv').show();
            $('#CrmreqReqWOAss').prop('disabled', false);
        }
    }
    $('#hdnCrmReqUsrAreaCdId').val(getResult.UserAreaId);
    $('#CrmReqUsrAreaCd').val(getResult.UserAreaCode);
    $('#CrmReqUsrAreaNam').val(getResult.UserAreaName);
    $('#hdnCrmReqUsrLocCdeId').val(getResult.UserLocationId);
    $('#CrmReqUsrLocCde').val(getResult.UserLocationCode);
    $('#CrmReqUsrLocNam').val(getResult.UserLocationName).prop("disabled", true);
    $('#hdnCrmReqUsrBlockCdId').val(getResult.BlockId);
    $('#CrmReqUsrBlockCd').val(getResult.BlockCode);
    $('#CrmReqUsrBlockNam').val(getResult.BlockName);
    $('#CrmReqUsrLevelCd').val(getResult.LevelCode); ''
    $('#CrmReqUsrLevelNam').val(getResult.LevelName);

    $('#hdncrmReqWOAssigneId').val(getResult.WOAssigneeId);
    $('#CrmreqReqWOAss').val(getResult.WOAssignee);
    $('#hdncrmReqWOAssigneEmail').val(getResult.WOAssigneeEmail);


    $("#RequestDescription").val(getResult.RequestDescription);
    // $("#Remarks").val(getResult.Remarks);
    // $("#Remarks").val('');

    //if (value.IsWorkorderGen == true) {
    //    $('#btnConverttoWO').css('visibility', 'hidden');
    //    $('#btnConverttoWO').hide();
    //}
    //else if (value.IsWorkorderGen == false) {
    //    $('#btnConverttoWO').css('visibility', 'visible');
    //    $('#btnConverttoWO').show();
    //}

    $('#btnApprove').show();
    $('#btnReject').show();
    $('#btnClarify').show();

    if (getResult.RequestStatus == 141) {
        $('#btnVerify').show();
        $('#btnClarify').show();
    }
    if (getResult.TypeOfRequest == 375) {

        $('#ReqTypTCDiv').css('visibility', 'visible');
        $('#ReqTypTCDiv').show();
        $('#crmReqTarDat').val(DateFormatter(getResult.TargetDate));
        $('#hdncrmReqTarDatOver').val(getResult.ISTargetDateOver);
        $('#crmReqPriority').hide();
        $('#lblCrmpriority').hide();
        //new comment on 10/10/19
        //$('#DateTimeDiv').hide();
        if (getResult.ISTargetDateOver == "TargetDateOver") {
            disableFields();
            $('#crmReqTarDat').prop('disabled', true);
            $('#crmReqTarDat').css("background-color", "#eee");
        }
        if (hasApprovePermission == true) {
            $('#ReqTypTCEngDiv').css('visibility', 'visible');
            $('#ReqTypTCEngDiv').show();
        }

        $('#AreaLocDiv').css('visibility', 'visible');
        $('#AreaLocDiv').show();
        // $('#crmReqAssigne').prop('required', true);
        // $("#lblCrmreqReqAssi").html("Assignee <span class='red'>*</span>");
        $('#hdncrmReqReqPeId').val(getResult.RequestPersonId);
        $('#crmReqReqPer').val(getResult.RequestPerson);
        $('#hdncrmReqAssigneId').val(getResult.AssigneeId);
        $('#crmReqAssigne').val(getResult.Assignee);
        $('#CrmAssetGrid').css('visibility', 'hidden');
        $('#CrmAssetGrid').hide();
        $('#CrmReqPlus').hide();
        $('#paginationfooter').hide();
        $('#crmReqTarDat').css("background-color", "#fff");
        $("#lblCrmReqTarDat").html("Target Date <span class='red'>*</span>");

        $('#btnVerify').hide();
        //  $('#btnClarify').hide();
        $('#btnClarify').show();
        $('#DeductionIndDiv option:selected').text();
        $('#DeductionIndDiv').hide();
        $('#divdeduction').hide();
    }
    if (getResult.IsWorkorderGen == true) {
        $('#btnSaveConverttoWO').css('visibility', 'hidden');
        $('#btnSaveConverttoWO').hide();
        $("#Remarks").prop("disabled", true);
        $('#chk_CrmReq').prop("disabled", true);
        $('#CrmReqPlus').hide();
        disableFields();
    }
    if (getResult.FMREQProcess == "Reject") {
        $('#btnSaveConverttoWO').css('visibility', 'hidden');
        $('#btnSaveConverttoWO').hide();
        $('#btnsave').hide();
        $('#btnApprove').hide();
        $('#btnReject').hide();
        $('#btnVerify').hide();
        $('#btnClarify').hide();

        $('#btnEdit').hide();
        $('#btnSaveandAddNew').hide();
        $('#btnDelete').hide();
        $("#Remarks").prop('disabled', true);
        $('#chk_CrmReq').prop('disabled', true);
        $('#CrmReqPlus').hide();

        disableFields();

    }

    if (getResult.FMREQProcess == "Approve") {
        $('#btnApprove').hide();
        $('#btnReject').hide();
        $('#btnVerify').hide();
        $('#btnClarify').hide();
        disableFields();

        var hasWOPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Approve'");
        if ((getResult.TypeOfRequest == 136 || getResult.TypeOfRequest == 137 || getResult.TypeOfRequest == 134 || getResult.TypeOfRequest == 138) && hasWOPermission == true) {
            $('#btnSaveConverttoWO').css('visibility', 'visible');
            $('#btnSaveConverttoWO').show();
        }
    }

    if (getResult.FMREQProcess == "Approve" && getResult.TypeOfRequest == 375) {
        $('#btnVerify').hide();
        $('#btnClarify').hide();
    }

    if (getResult.FMREQProcess == "Verify") {
        $('#btnsave').hide();
        $('#btnClarify').hide();
        $('#btnApprove').hide();
        $('#btnReject').hide();
        $('#btnVerify').hide();
        disableFields();
        $('#btnEdit').hide();
        $('#btnSaveandAddNew').hide();
        $('#btnDelete').hide();
        $("#Remarks").prop('disabled', true);
        $('#chk_CrmReq').prop('disabled', true);
        $('#CrmReqPlus').hide();
        $('#crmReqTarDat').prop('disabled', true);
    }

    if (getResult.FMREQProcess == "Clarify") {
        $('#btnApprove').show();
        $('#btnReject').show();
        // disableFields();
        $('#btnClarify').show();
        $('#btnVerify').hide();
    }

    if (getResult.IsWorkorderGen == 1) {
        $('#btnApprove').hide();
        $('#btnReject').hide();
        $('#btnVerify').hide();
        $('#btnClarify').hide();
        $('#btnSave').hide();
        $('#btnSaveConverttoWO').hide();

        $('#btnEdit').hide();
        $('#btnSaveandAddNew').hide();
        $('#btnDelete').hide();
        $('#CrmReqPlus').hide();
    }

    //$("#Remarks").val('');

    $("#CRMRequestGrid").empty();

    if (getResult.TypeOfRequest == 10021 && getResult.RequestStatus == 140) {
        $('#ResponceDateTime').val(moment(getResult.Responce_Date).format("DD-MMM-YYYY HH:mm")).prop("disabled", true);
        $('#lblcrmActionLLS').show();
        $("#Assessment").html("Assessment Details <span class='red'>*</span>");
        $('#crmReqTarDat').val(DateFormatter(getResult.TargetDate));
        $('#ReqTypTCDiv').val(moment(getResult.TargetDate).format("DD-MMM-YYYY HH:mm")).prop("disabled", true);
        $('#ReqTypTCDiv').css('visibility', 'visible');
        $('#ReqTypTCDiv').show();
        $('indicatorDiv').show();
        $('#lblCrmpriority').show();
        $('#crmReqPriority').show();
        $('#crmReqPriority').prop('required', true);
        $('#ResponceDateTime').show();
        $('#CompleteDateTime').show();
        $('#Completedby').show();
        $('#ResponceDateTimeAndResponseby').css('visibility', 'visible');
        $('#crmReqTarDat').prop('disabled', true);
        //$('#ResponceDateTime').css('visibility', 'visible');
        //$('#CompleteDateTime').css('visibility', 'visible');
        //$('#Completedby').css('visibility', 'visible');
        $('#DateTimeDiv').show();
        $('#ResponceDateTime').prop('disabled', false);
        $('#CompleteDateTime').prop('disabled', false);
        $('#Completedby').prop('disabled', false);
        $('#ResponceDateTime').prop('required', true);
        $('#CompleteDateTime').prop('required', true);
        $('#Completedby').prop('required', true);
        $('#CompleteDateTime').prop('required', true);
        $('#Completedby').prop('required', true);
        $('#LabCompleteDateTime').html("Completed Date / Time <span class='red'>*</span>");
        $('#LabCompletedby').html("Completed By <span class='red'>*</span>");
        $('#printfm').show();
        $('#selWasteCategory').prop('required', false);
        $('#selWorkGroupGM').prop('required', false);
        if (getResult.ServiceId == 4) {
            $('#crmReqTarDat').prop('disabled', true);
            $('#DateTimeDivCompleted').show();
            $('#ActionLLS').show();
            $('#DateTimeDiv').show();
            $('#ResponceDateTime').show();
            $('#Responseby').show();
            $('#Responseby').prop('required', true);
            $('#Responseby').attr('required', true);
            $('#Assessment').show();
            $('#lblCrmReqRem').hide();
            $("#Assessment").html("Assessment Details <span class='red'>*</span>");
            $("#Remarks").prop('required', true);
            $('#selWasteCategory').prop('required', false);
            $('#selWorkGroupGM').prop('required', false);

        }

        if (getResult.TypeOfRequest == 10021) {
            $('#crmReqTarDat').prop('disabled', true);
            $('#AreaLocDiv').css('visibility', 'visible');
            $('#AreaLocDiv').show();
            $('#ReqTypTCDiv').css('visibility', 'visible');
            $('#ReqTypTCDiv').show();
            $('#ReqTypTCDiv').val(moment(getResult.TargetDate).format("DD-MMM-YYYY HH:mm")).prop("disabled", true);
            $('#Modelrow').css('visibility', 'hidden');
            $('#Modelrow').hide();
            if (getResult.RequestStatus == 139) {
                $('#lblCrmReqRem').hide();
                $('#Assessment').show();
                $("#Assessment").html("Assessment Details <span class='red'>*</span>");
                $("#Remarks").prop('required', true);
                $('#DateTimeDiv').show();
                //  $('#ResponceDateTime').prop('required', true);
                $('#ResponceDateTime').show();
                $('#ResponceDateTime').prop('required', true);
                $('#ResponceDateTime').html("Response Date / Time <span class='red'>*</span>");
                $('#Responseby').show();
                $('#Responseby').prop('required', true);
                $('#Responseby').attr('required', true);
                $('#DateTimeDivCompleted').hide();
                $('#ActionLLS').hide();
                $('#CompleteDateTime').hide();
                $('#CompleteDateTimeLLS').hide();
                $('#ActionLLS').hide();
                $('#VaidationDiv').hide();
                $('#printfm').show();

            }
            //if (getResult.ServiceId == 4 ) {
            $('#crmReqTarDat').prop('disabled', true);
            $('#DateTimeDivCompleted').show();
            //   $('#ActionLLS').show();
            $('#DateTimeDiv').show();
            $('#ResponceDateTime').show();
            $('#Responseby').show();
            $('#Responseby').prop('required', true);
            $('#Responseby').attr("required", "required");
            $('#lblResponseby').html("Response By <span class='red'>*</span>");
            $('#Assessment').show();
            $('#lblCrmReqRem').hide();
            $("#Remarks").show();
            $("#Assessment").html("Assessment Details <span class='red'>*</span>");
            $("#Remarks").prop('required', true);
            //}

            //if (getResult.ServiceId == 4 && getResult.RequestStatus >= 140)
            if (getResult.RequestStatus >= 140) {
                $('#lblcrmActionLLS').show();

                $('#crmReqTarDat').prop('disabled', true);
                $("#Assessment").html("Assessment Details <span class='red'>*</span>");
                $("#Assessment").show();
                $('#ActionLLS').show();
                $('#CompleteDateTime').show();
                $('#CompleteDateTimeLLS').show();
                $('#VaidationDiv').show();
                if (getResult.RequestStatus = 140) {
                    $('#ResponceDateTime').prop('disabled', false);
                    $('#selWasteCategory').prop('required', false);
                    $('#selWorkGroupGM').prop('required', false);

                } else {
                    $('#ResponceDateTime').text(moment(getResult.Responce_Date).format("DD-MMM-YYYY HH:mm")).prop("disabled", true);

                }
                $('#hdncrmReqResponsebyId').val(getResult.LLSResponse_by_ID);
                $('#Responseby').val(getResult.LLSResponse_by);
                $("#Remarks").val(getResult.Remarks);
                $("#Remarks").prop('disabled', true);
                // $('#ResponceDateTime').prop('disabled', true);
                $('#Responseby').attr("required", "required");
                $('#Vaidation').prop('required', true);
                $('#ResponceDateTimeAndResponseby').css('visibility', 'visible');
                $('#printfm').show();
                $("#lblcrmAction").html("Action Taken<span class='red'>*</span>");
                $("#lblResponceDateTime").html("Response Date / Time <span class='red'>*</span>");
                $("#lblResponseby").html("Response By <span class='red'>*</span>");
                $("#lblCrmReqLLS").html("Remarks <span class='red'>*</span>");
                $("#LabCompletedby").html("Completed By <span class='red'>*</span>");
                $("#LabCompleteDateTime").html("Completed Date / Time <span class='red'>*</span>");
            }
        }
        else {
            $('#AreaLocDiv').css('visibility', 'hidden');
            $('#AreaLocDiv').hide();
        }



    }
    else {
        if (getResult.RequestStatus == 142 && getResult.TypeOfRequest == 10021) {

            $('#lblcrmActionLLS').show();
            $('#crmReqTarDat').prop('disabled', true);
            $('#ReqTypTCDiv').css('visibility', 'visible');
            $('#indicatorDiv').show();
            $('#ReqTypTCDiv').show();
            $('indicatorDiv').show();
            $('#lblCrmpriority').show();
            $('#crmReqPriority').show();
            $('#crmReqPriority').prop('required', true);
            $('#ResponceDateTime').show();
            $('#CompleteDateTime').show();
            $('#Completedby').show();
            //$('#ResponceDateTime').css('visibility', 'visible');
            //$('#CompleteDateTime').css('visibility', 'visible');
            //$('#Completedby').css('visibility', 'visible');
            $('#DateTimeDiv').show();
            $('#ResponceDateTime').prop('disabled', true);
            //$('#CompleteDateTime').prop('disabled', true);
            $('#Completedby').prop('disabled', true);
            $('#ResponceDateTime').val(moment(getResult.Responce_Date).format("DD-MMM-YYYY HH:mm")).prop("disabled", true);
            $('#CompleteDateTime').val(moment(getResult.Completed_Date).format("DD-MMM-YYYY HH:mm")).prop("disabled", true);
            $('#Completedby').val(getResult.Completed_By_Name);
            $('#AreaLocDiv').css('visibility', 'visible');
            $('#AreaLocDiv').show();
            $('#ResponceDateTimeAndResponseby').css('visibility', 'visible');
            $('#printfm').show();
            $("#lblcrmActionLLS").html("Action Taken<span class='red'>*</span>");
            $("#lblResponceDateTime").html("Response Date / Time <span class='red'>*</span>");
            $("#lblResponseby").html("Response By <span class='red'>*</span>");
            $("#lblCrmReqLLS").html("Remarks <span class='red'>*</span>");
            $("#LabCompletedby").html("Completed By <span class='red'>*</span>");
            $("#LabCompleteDateTime").html("Completed Date / Time <span class='red'>*</span>");
            $("#Assessment").html("Assessment Details <span class='red'>*</span>");
            $("#Assessment").show();
            //if (getResult.ServiceId == 4 && getResult.RequestStatus >= 142)
            if (getResult.RequestStatus >= 142) {
                $('#lblCrmReqRem').hide();
                $('#lblcrmActionLLS').show();
                $('#crmReqTarDat').prop('disabled', true);
                $("#Assessment").html("Assessment Details <span class='red'>*</span>");
                $('#ActionLLS').show();
                $('#CompleteDateTime').show();
                $('#CompleteDateTimeLLS').show();
                $('#VaidationDiv').show();
                $('#ResponceDateTime').val(moment(getResult.Responce_Date).format("DD-MMM-YYYY HH:mm")).prop("disabled", true);
                $('#hdncrmReqResponsebyId').val(getResult.LLSResponse_by_ID);
                $('#Responseby').val(getResult.LLSResponse_by);
                $("#Remarks").val(getResult.Remarks);
                $("#Remarks").prop('disabled', true);
                $('#ResponceDateTime').prop('disabled', true);
                $('#Responseby').prop('disabled', true);
                $('#RequestActionLLS').val(getResult.LLSAction_Taken);
                $('#JustificationLLS').val(getResult.LLSJustification);
                $('#Vaidation').val(getResult.LLSValidation);
                $('#RequestActionLLS').prop('disabled', true);
                $('#JustificationLLS').prop('disabled', true);
                $('#Vaidation').prop('disabled', true);
                $('#Modelrow').hide();


            }



        }
        else {
            //if (getResult.TypeOfRequest == 10021 && getResult.ServiceId == 4) {
            if (getResult.TypeOfRequest == 10021) {

                $('#crmReqTarDat').val(DateFormatter(getResult.TargetDate));
                $('#crmReqTarDat').prop('disabled', true);
                $('#AreaLocDiv').css('visibility', 'visible');
                $('#AreaLocDiv').show();
                $('#ReqTypTCDiv').css('visibility', 'visible');
                $('#ReqTypTCDiv').show();
                $('#Modelrow').css('visibility', 'hidden');
                $('#Modelrow').hide();
                $('indicatorDiv').show();
                $('#DateTimeDivCompleted').show();
                //   $('#ActionLLS').show();
                $('#DateTimeDiv').show();
                $('#ResponceDateTime').show();
                //  $('#Responseby').show();
                //   $('#Responseby').prop('required', true);
                $('#Assessment').show();
                $('#lblCrmReqRem').hide();
                $("#Remarks").show();
                $("#Assessment").html("Assessment Details <span class='red'>*</span>");
                $("#Remarks").prop('required', true);


                if (getResult.RequestStatus == 139) {
                    $('#crmReqTarDat').prop('disabled', true);
                    $('#Responseby').show();
                    $('#Responseby').prop('required', true);
                    $('#Responseby').attr("required", "required");
                    $('#lblResponseby').html("Response By <span class='red'>*</span>");
                    $('#lblCrmReqRem').hide();
                    $('#Assessment').show();
                    $("#Assessment").html("Assessment Details <span class='red'>*</span>");
                    $("#Remarks").prop('required', true);
                    $('#DateTimeDiv').show();
                    //  $('#ResponceDateTime').prop('required', true);
                    $('#ResponceDateTime').show();
                    $('#ResponceDateTime').prop('required', true);
                    $("#lblResponceDateTime").html("Response Date / Time <span class='red'>*</span>");
                    $('#Responseby').show();
                    $('#Responseby').prop('required', true);
                    $('#Responseby').attr("required", "required");
                    $("#lblResponseby").html("Response By <span class='red'>*</span>");
                    $('#DateTimeDivCompleted').hide();
                    $('#ActionLLS').hide();
                    $('#CompleteDateTime').hide();
                    $('#CompleteDateTimeLLS').hide();
                    $('#ActionLLS').hide();
                    $('#VaidationDiv').hide();
                    $('#ResponceDateTimeAndResponseby').css('visibility', 'visible');

                }
                //if (getResult.ServiceId == 4 ) {

                //}

                //if (getResult.ServiceId == 4 && getResult.RequestStatus >= 140)
                if (getResult.RequestStatus >= 140) {
                    $('#crmReqTarDat').prop('disabled', true);
                    $("#Assessment").html("Assessment Details <span class='red'>*</span>");
                    $('#ActionLLS').show();
                    $('#CompleteDateTime').show();
                    $('#CompleteDateTimeLLS').show();
                    $('#VaidationDiv').show();
                    $('#ResponceDateTime').val(moment(getResult.Responce_Date).format("DD-MMM-YYYY HH:mm")).prop("disabled", true);
                    $('#hdncrmReqResponsebyId').val(getResult.LLSResponse_by_ID);
                    $('#Responseby').val(getResult.LLSResponse_by);
                    $("#Remarks").val(getResult.Remarks);
                    $("#Remarks").prop('disabled', true);
                    $('#ResponceDateTime').prop('disabled', true);
                    $('#Responseby').prop('disabled', true);
                    $('#Vaidation').prop('required', true);
                    $('#ResponceDateTimeAndResponseby').css('visibility', 'visible');
                }
            }
            else {
                $('#AreaLocDiv').css('visibility', 'hidden');
                $('#AreaLocDiv').hide();
                if (getResult.TypeOfRequest == 134 || getResult.TypeOfRequest == 138) {
                    $('#AreaLocDiv').css('visibility', 'visible');
                    $('#AreaLocDiv').show();
                }
            }

        }
    }


    if (getResult.TypeOfRequest == 136 || getResult.TypeOfRequest == 137 || getResult.TypeOfRequest == 374) {

        $('#CrmAssetGrid').css('visibility', 'visible');
        $('#CrmAssetGrid').show();
        // AddNewRowCRMRequest();
        //$('#CrmReqPlus').show();
        //$('#paginationfooter').show();
        $('#ReqTypTCEngDiv').css('visibility', 'hidden');
        $('#ReqTypTCEngDiv').hide();
        $('#crmReqManu').prop('required', false);
        // $("#lblCrmReqmanu").html("Manufacturer <span class='red'>*</span>");
        $('#crmReqModel').prop('required', true);
        $("#lblCrmreqMod").html("Model <span class='red'>*</span>");
        $('#crmReqPriority').hide();
        $('#lblCrmpriority').hide();
        $("#Remarks").show();
        $('#lblCrmReqRem').show();

        $('#Assessment').hide();
        // $("#Assessment").html("Remarks <span class='red'>*</span>");
        $('#printfm').hide();
        if (hasApprovePermission == true && getResult.ChkStsApproveorNot == "Approve") {
            $('#WorkAssiDiv').css('visibility', 'visible');
            $('#WorkAssiDiv').show();
            $('#CrmreqReqWOAss').prop('disabled', false);
        }

        $.each(getResult.CRMRequestGridData, function (index, value) {
            AddNewRowCRMRequest();
            $("#hdnCrmReqdetId_" + index).val(getResult.CRMRequestGridData[index].CRMRequestDetId);
            $("#CrmreqAssetNo_" + index).val(getResult.CRMRequestGridData[index].AssetNo).prop('disabled', true);
            $("#hdnCrmreqAssetId_" + index).val(getResult.CRMRequestGridData[index].AssetId);
            $("#CrmReqSerNo_" + index).val(getResult.CRMRequestGridData[index].SerialNo);
            $("#CrmReqSoftVer_" + index).val(getResult.CRMRequestGridData[index].SoftwareVersion);

            if (getResult.FMREQProcess == "Reject" || getResult.FMREQProcess == "Approve" || getResult.FMREQProcess == "Verify") {
                disableGridFields(index, null);
            }
            if (getResult.IsWorkorderGen == 1) {
                disableFields();
                disableGridFields(index, null);
            }
            if (getResult.RequestStatus == 142 || getResult.RequestStatus == 143) {
                disableGridFields(index, null);
            }
        });




        if ((getResult.CRMRequestGridData && getResult.CRMRequestGridData.length) > 0) {
            //  if (getResult.TypeOfRequest != 374) {


            var CatSystemId = 0;
            if ((getResult.CRMRequestGridData && getResult.CRMRequestGridData.length) > 0) {
                TrainingScheduleId = getResult.CRMRequestGridData[0].TrainingScheduleId;
                GridtotalRecords = getResult.CRMRequestGridData[0].TotalRecords;
                TotalPages = getResult.CRMRequestGridData[0].TotalPages;
                LastRecord = getResult.CRMRequestGridData[0].LastRecord;
                FirstRecord = getResult.CRMRequestGridData[0].FirstRecord;
                pageindex = getResult.CRMRequestGridData[0].PageIndex;
            }

            var mapIdproperty = ["IsDeleted-Isdeleted_", "CRMRequestDetId-hdnCrmReqdetId_", "AssetNo-CrmreqAssetNo_", "AssetId-hdnCrmreqAssetId_", "SerialNo-CrmReqSerNo_", "SoftwareVersion-CrmReqSoftVer_"];
            var htmltext = AddNewRowCRMRequestHtml();//Inline Html
            var obj = { formId: "#Testform", IsView: ($('#ActionType').val() == "VIEW"), PageNumber: pageindex, flag: "CRMRequest", mapIdproperty: mapIdproperty, htmltext: htmltext, GridtotalRecords: GridtotalRecords, ListName: "CRMRequestGridData", tableid: '#CRMRequestGrid', destionId: "#paginationfooter", TotalPages: TotalPages, FirstRecord: FirstRecord, LastRecord: LastRecord, geturl: "/api/CRMRequestApi/Get/" + primaryId, pageindex: pageindex, pagesize: pagesize };

            CreateFooterPagination(obj)
            //    }
        }

        if (getResult.IsWorkorderGen == 1) {
            $('#CrmReqPlus').hide();
        }
    }
    else if (getResult.TypeOfRequest == 374) {
        $('#CrmAssetGrid').css('visibility', 'visible');
        $('#CrmAssetGrid').show();
        // AddNewRowCRMRequest();
        $('#CrmReqPlus').show();
        $("#lblCrmObsolete").html("Asset No. ");
        $('#ReqTypTCEngDiv').css('visibility', 'hidden');
        $('#ReqTypTCEngDiv').hide();
        $('#CrmReqPlus').hide();
        //$('#paginationfooter').css('visibility', 'hidden');
        $('#paginationfooter').hide();
        $('#crmReqPriority').hide();
        $('#lblCrmpriority').hide();


        $.each(getResult.CRMRequestGridData, function (index, value) {
            AddNewRowCRMRequest();

            $("#Isdeleted_" + index).prop('disabled', true);
            $("#chk_CrmReq").prop('disabled', true);
            $("#hdnCrmReqdetId_" + index).val(getResult.CRMRequestGridData[index].CRMRequestDetId).prop('disabled', true);
            $("#CrmreqAssetNo_" + index).val(getResult.CRMRequestGridData[index].AssetNo).prop('disabled', true);
            $("#hdnCrmreqAssetId_" + index).val(getResult.CRMRequestGridData[index].AssetId).prop('disabled', true);
            $("#CrmReqSerNo_" + index).val(getResult.CRMRequestGridData[index].SerialNo).prop('disabled', true);
            $("#CrmReqSoftVer_" + index).val(getResult.CRMRequestGridData[index].SoftwareVersion).prop('disabled', true);


            if (getResult.FMREQProcess == "Reject" || getResult.FMREQProcess == "Approve" || getResult.FMREQProcess == "Verify" || getResult.FMREQProcess == "Clarify") {
                disableGridFields(index, null);
            }
            if (getResult.IsWorkorderGen == 1) {
                disableFields();
                disableGridFields(index, null);
            }
            if (getResult.RequestStatus == 142 || getResult.RequestStatus == 143) {
                disableGridFields(index, null);
            }
        });

        if (getResult.IsWorkorderGen == 1) {
            $('#CrmReqPlus').hide();
        }

        if (getResult.FMREQProcess == "Approve") {
            $('#btnEdit').hide();
            $('#btnSave').hide();
            $('#btnSaveandAddNew').hide();
        }
    }

    if (getResult.RequestStatus == 142) {
        $('#btnSaveConverttoWO').hide();
        $('#AttachRowPlus').hide();
        $('#btnEditAttachment').hide();
    }
    $("#CrmReqRemarksGrid").empty();
    $.each(getResult.CRMRequestRemHisGridData, function (index, value) {
        AddNewRowRemarksHistory();
        $("#CRMReqRemHisSNo_" + index).val(getResult.CRMRequestRemHisGridData[index].SNo);
        $("#CRMReqRemHisRemarks_" + index).val(getResult.CRMRequestRemHisGridData[index].Remarks);
        $("#CRMReqRemHisRemarks_" + index).attr('title', getResult.CRMRequestRemHisGridData[index].Remarks);
        $("#CRMReqRemHisEntby_" + index).val(getResult.CRMRequestRemHisGridData[index].DoneBy);
        $("#CRMReqRemHisDate_" + index).val(moment(getResult.CRMRequestRemHisGridData[index].Date).format("DD-MMM-YYYY HH:mm"));
        //var a = moment.utc(getResult.CRMRequestRemHisGridData[index].Date).toDate();
        //$("#CRMReqRemHisDate_" + index).val(moment(a).format("DD-MMM-YYYY HH:mm"));
        $("#CRMReqRemHisStatus_" + index).val(getResult.CRMRequestRemHisGridData[index].Status);

    });

    if (getResult.RequestStatus == 142 || getResult.RequestStatus == 143) {
        $('#btnSaveConverttoWO').hide();
        $('#btnEdit').hide();
        $('#btnApprove').hide();
        $('#btnReject').hide();
        $('#btnSaveandAddNew').hide();
        $('#btnDelete').hide();
        $('#btnSave').hide();
        $('#btnVerify').hide();
        $('#btnClarify').hide();
        disableFields();
        $("#Remarks").prop('disabled', true);
        $('#crmReqTarDat').prop('disabled', true);
        $('#crmReqAssigne').prop('disabled', true);
        $('#crmReqReqPer').prop('disabled', true);
        $('#crmReqTarDat').prop('disabled', true);
        $('#crmReqTarDat').css("background-color", "#eee");
    }
    if (getResult.RequestStatus != 139) {
        $('#CrmReqPlus').hide();
    }
    $("#TypeOfRequest").prop('disabled', true);
    if (getResult.ISTargetDateOver == "TargetDateOver") {
        disableFields();
        $('#btnsave').hide();
        $('#btnApprove').hide();
        $('#btnReject').hide();
        $('#btnVerify').hide();
        $('#btnClarify').hide();
        $('#btnEdit').hide();
        $('#btnSaveandAddNew').hide();
        $('#btnDelete').hide();
        $("#Remarks").prop('disabled', true);
        $('#chk_CrmReq').prop('disabled', true);
        $('#crmReqTarDat').css("background-color", "#eee");
        $('#crmReqTarDat').prop('disabled', true);
    }
    if (getResult.TypeOfRequest == 132 || getResult.TypeOfRequest == 135 || getResult.TypeOfRequest == 10022) {
        //if (getResult.TypeOfRequest == 132 || getResult.TypeOfRequest == 135 || getResult.TypeOfRequest == 10022) {
        $('#btnApprove').show();
        $('#btnReject').show();
        //$('#btnVerify').hide();
        $('#btnClarify').show();
        $('#crmReqPriority').hide();
        $('#lblCrmpriority').hide();
        $('#printfm').hide();

        $('#selWorkGroupGM').prop('disabled', false);
        $("#Testform :input:not(:button)").prop("disabled", false);
        var ApprivAcc = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Approve'");
        if (ApprivAcc == true) {
            $("#Testform :input:not(:button)").prop("disabled", true);
            $("#Remarks").prop('disabled', false);
            $('#Popup-RequestMdl').hide();
            $('spnPopup-RequestMdl').hide();
        }
        hdnappsts = $("#hdnCrmReqChkstsApp").val();
        if (hdnappsts == "Approve") {
            $('#btnVerify').show();
        }
        if (hdnappsts == "Clarify" || hdnappsts == "Approve") {
            $('#btnApprove').hide();
            $('#btnReject').hide();
            $('#btnClarify').hide();
        }
        if (hdnappsts == "") {
            $('#btnVerify').hide();
        }

        if (getResult.RequestStatus == 142 || getResult.RequestStatus == 143) {
            $('#btnApprove').hide();
            $('#btnReject').hide();
            //$('#btnVerify').hide();
            $('#btnClarify').hide();

        }

    }

    var ApprAcc = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Approve'");
    if (ApprAcc == true) {
        var enableCheckBoxes = false;
        if (!$('#chk_CrmReq').prop('disabled') && (getResult.TypeOfRequest == 136 || getResult.TypeOfRequest == 137)) {
            enableCheckBoxes = true;
        }
        $('#txtAssetNo').prop('disabled', false);
        if (getResult.TypeOfRequest == 10021) {
            $("#Assessment").html("Assessment Details <span class='red'>*</span>");
        }
        else if (getResult.TypeOfRequest == 10020) {
            $("#Testform :input:not(:button)").prop("disabled", false);
            $('#NonConformanceRequestDescription').prop('disabled', true);
            $('#TypeOfServiceRequest').prop('disabled', true);
            $('#crmReqRequester').prop('disabled', true);
            $('#test').prop('disabled', true);
            $('#ServiceInd').show();
            $('#NonConformance').show();
            $('#RequestNo').prop('disabled', true);
            $('#TypeOfRequest').prop('disabled', true);
            $('#ServiceIndicator').prop('disabled', true);
            $('#RequestDateTime').prop('disabled', true);
            $('#RequestStatus').prop('disabled', true);
            $('#txtAssetNo').prop('disabled', true);
            if (getResult.RequestStatus == 139) {
                $('#RequestAction').prop('disabled', false);
                $('#ResponceDateTime').prop('disabled', false);
                $('#Responseby').prop('disabled', false);
                $('#LlsRemarks').css('visibility', 'hidden');
                $('#ResponceDateTimeAndResponseby').css('visibility', 'visible');
                $("#lblcrmActionLLS").html("Action Taken<span class='red'>*</span>");
                $('#txtAssetNo').prop('disabled', true);
            }
            if (getResult.RequestStatus == 140) {
                $('#hdncrmReqResponsebyId').val(getResult.LLSResponse_by_ID);
                $('#Responseby').val(getResult.LLSResponse_by);
                $('#RequestAction').prop('disabled', true);
                $('#ResponceDateTime').prop('disabled', true)
                $('#Responseby').prop('disabled', true)
                $('#lblCrmReqRem').show();
                $("#Assessment").hide();
                $("#Remarks").show();
                $('#LlsRemarks').css('visibility', 'visible');
                $('#LlsRemarks').show();
                $("#lblcrmAction").html("Action Taken<span class='red'>*</span>");
                $('#ResponceDateTime').text(moment(getResult.Responce_Date).format("DD-MMM-YYYY HH:mm"));
                $('#txtAssetNo').prop('disabled', true);
            }
            if (getResult.RequestStatus == 142) {

                $('#RequestAction').prop('disabled', true);
                $('#CompleteDateTime').prop('disabled', true);
                $('#RequestAction').prop('disabled', true);
                $('#ResponceDateTime').prop('disabled', true)
                $('#Responseby').prop('disabled', true)
                $('#lblCrmReqRem').show();
                $("#Assessment").hide();
                $("#Remarks").show();
                $('#CompleteDateTimeLLS').show();
                $('#CompleteDateTime').show();
                $('#LlsRemarks').css('visibility', 'visible');
                $('#RemarkLls').prop('disabled', true);
                $('#CompleteDateTimeLLS').prop('disabled', true);
                $('#Completedby').prop('disabled', true);
                $('#hdncrmReqResponsebyId').val(getResult.LLSResponse_by_ID);
                $('#Responseby').val(getResult.LLSResponse_by);
                $('#LlsRemarks').show();
                $("#lblcrmAction").html("Action Taken<span class='red'>*</span>");
                $('#txtAssetNo').prop('disabled', true);
            }
        }
        else {
            $("#Testform :input:not(:button)").prop("disabled", true);
        }

        if (enableCheckBoxes) {
            $('#chk_CrmReq').attr('disabled', false)
            var len = $('#CRMRequestTable tr').length - 1;
            for (i = 0; i < len; i++) {
                $('#Isdeleted_' + i).attr('disabled', false);
            }
        }
        $("#Remarks").prop('disabled', false);
        $('#Popup-RequestMdl').hide();
        $('#spnPopup-RequestMdl').hide();
        $('#Popup-ReqUsrLocCde').hide();
        $('#spnPopup-ReqUsrLocCde').hide();
        $('#CrmreqReqWOAss').prop('disabled', false);
        $('#CrmReqPlus').hide();
        $('#crmReqAssigne').prop('disabled', false);
        $('#crmReqTarDat').prop('disabled', false);

        if (getResult.ISTargetDateOver == "TargetDateOver") {
            $('#crmReqAssigne').prop('disabled', true);
            $('#crmReqTarDat').prop('disabled', true);
            $('#crmReqTarDat').css("background-color", "#eee");
            $("#Remarks").prop('disabled', true);
        }
    }

    if (getResult.RequestStatus == 10020) {
        $("#divdeduction").show();
    }


    if (getResult.IsWorkorderGen == true) {
        $("#Remarks").prop('disabled', true);
        $('#CrmreqReqWOAss').prop('disabled', true);
        $('#Popup-RequestMdl').hide();
        $('#spnPopup-RequestMdl').hide();
        $('#Popup-ReqUsrLocCde').hide();
        $('#spnPopup-ReqUsrLocCde').hide();
    }
    if (getResult.RequestStatus == 142 || getResult.RequestStatus == 143) {
        //$("#form :input:not(:button)").prop("disabled", true);
        $("#Remarks").prop('disabled', true);
        $('#crmReqTarDat').prop('disabled', true);
        $('#crmReqAssigne').prop('disabled', true);
        $('#Popup-RequestMdl').hide();
        $('#spnPopup-RequestMdl').hide();
        $('#Popup-ReqUsrLocCde').hide();
        $('#spnPopup-ReqUsrLocCde').hide();
    }
    hdnappsts = $("#hdnCrmReqChkstsApp").val();
    if (hdnappsts == "Approve") {
        $('#Popup-RequestMdl').hide();
        $('#spnPopup-RequestMdl').hide();
        $('#Popup-ReqUsrLocCde').hide();
        $('#spnPopup-ReqUsrLocCde').hide();
    }
    $('#lblcrmActionLLS').show();
    $('#Popup-RequestMdl').show();
    $('#selWorkGroupGM').prop('disabled', false);
    $('#selWasteCategory').prop('disabled', false);
}


///Adding Indicators info
function BindGridData(getResult) {

    var ActionType = $('#ActionType').val();

    $("#SummaryResultId").empty();

    $.each(getResult.Indicators, function (index, value) {
        AddNewRowStkAdjustmentget();

        $("#LicenseCode_" + index).val(getResult.Indicators[index].Indicator_Code);
        $("#LicenseDescription_" + index).val(getResult.Indicators[index].Indicator_Name);

        linkCliked1 = true;
        $(".content").scrollTop(0);
    });

    //************************************************ Grid Pagination *******************************************
    ckNewRowPaginationValidation = false;
    if ((getResult.Indicators && getResult.Indicators.length) > 0) {
        //StockAdjustmentId = result.UserAreaDetailsLocationGridList[0].StockAdjustmentId;
        GridtotalRecords = getResult.Indicators[0].TotalRecords;
        TotalPages = getResult.Indicators[0].TotalPages;
        LastRecord = getResult.Indicators[0].LastRecord;
        FirstRecord = getResult.Indicators[0].FirstRecord;
        pageindex = getResult.Indicators[0].PageIndex;
        linkCliked1 = true;
        $(".content").scrollTop(0);
    }

    //************************************************ End *******************************************************
}
function AddNewRowStkAdjustmentget() {
    var inputpar = {
        inlineHTML: SummaryGridHtmlget(),
        IdPlaceholderused: "maxindexval",
        TargetId: "#SummaryResultId",
        TargetElement: ["tr"]
    }
    AddNewRowToDataGrid(inputpar);
    //ckNewRowPaginationValidation = true;
    //$('#chk_stkadjustmentdet').prop("checked", false);
    if (!linkCliked1) {
        $('#SummaryResultId tr:last td:first input').focus();
    }
    else {
        linkCliked1 = false;
    }
    var rowCount = $('#SummaryResultId tr:last').index();

    $.each(window.ClassGradeListGlobal, function (index, value) {
        //$('#IssuingBody_' + rowCount).append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
    });

    formInputValidation("FrmLicense");




}
var linkCliked1 = false;
function AddNewRowStkAdjustment() {
    var inputpar = {
        inlineHTML: SummaryGridHtml(),
        IdPlaceholderused: "maxindexval",
        TargetId: "#SummaryResultId",
        TargetElement: ["tr"]
    }
    AddNewRowToDataGrid(inputpar);
    //ckNewRowPaginationValidation = true;
    //$('#chk_stkadjustmentdet').prop("checked", false);
    if (!linkCliked1) {
        $('#SummaryResultId tr:last td:first input').focus();
    }
    else {
        linkCliked1 = false;
    }
    var rowCount = $('#SummaryResultId tr:last').index();

    $.each(window.ClassGradeListGlobal, function (index, value) {
        //$('#IssuingBody_' + rowCount).append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
    });

    formInputValidation("FrmLicense");




}

function PushEmptyMessage() {
    $("#SummaryResultId").empty();
    var emptyrow = '<tr><td colspan=57 ><h3>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;No records to display</h3></td></tr>'
    $("#SummaryResultId ").append(emptyrow);
}
function SummaryGridHtmlget() {

    return '<tr>' +
        '<td width="10%" style="text-align:center"> <input type="checkbox" onchange="DeleteContact(maxindexval)" id="chkContactDeleteAll_maxindexval" /></td>' +
        '<td " style="text-align: center;  width:45%;" title=""><div><input disabled="disabled" id="LicenseCode_maxindexval" type="text" class="form-control" name="LicenseDescription" autocomplete="off"></div></td>' +
        '<td " style="text-align: center;  width:45%;" title=""><div><input disabled="disabled"  id="LicenseDescription_maxindexval" type="text" class="form-control" name="LicenseDescription" autocomplete="off"></div></td>'


}
function SummaryGridHtml() {



    return '<tr>' +
        '<td width="10%" style="text-align:center"> <input type="checkbox" onchange="DeleteContact(maxindexval)" id="chkContactDeleteAll_maxindexval" /></td>' +
        '<td " style="text-align: center; width:45%;" title=""><div><select class="form-control"  id="LicenseCode_maxindexval" autocomplete="off" onchange="getindicatorsinfo(maxindexval)"> <option value="null">Select</option></select></div></td>' +
        '<td " style="text-align: center;  width:45%;" title=""><div><input  id="LicenseDescription_maxindexval" type="text" class="form-control" name="LicenseDescription" autocomplete="off"></div></td>'


}

function SummaryNewRow() {

    var inputpar = {
        inlineHTML: SummaryGridHtml(),//Inline Html
        TargetId: "#SummaryResultId",
        TargetElement: ["tr"]
    }
    AddNewRowToDataGrid(inputpar);
    if ($("#Vaidation").val() == 99) {
        $('#LicenseDescription_0').prop('required', true);
        $('#LicenseCode_0').prop('required', true);
    } else {
        $('#LicenseDescription_0').prop('required', false);
    }

}

function LinkClickedS(LicenseTypeDetId) {

    linkCliked1 = true;
    $(".content").scrollTop(1);
    $('.nav-tabs a:first').tab('show');
    $("#FrmLicense :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    var action = "";
    $('#primaryID').val(LicenseTypeDetId);
    var hasEditPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Edit'");
    var hasViewPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='View'");
    var hasDeletePermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Delete'");

    if (hasEditPermission) {
        action = "Edit"

    }
    else if (!hasEditPermission && hasViewPermission) {
        action = "View"
    }
    if (action == "Edit" && hasDeletePermission) {
        $('.btnDelete').show();
    }

    if (action == 'View') {
        $("#FrmLicense :input:not(:button)").prop("disabled", true);
    } else {
        $('#btnSave').show();
        // $('#btnSave').hide();
        //  $('.btnSave').hide();
        //$('#btnSaveandAddNew').hide();
        $('#btnNextScreenSave').show();
    }
    $('#spnActionType').text(action);
    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0")
        $.get("/api/LicenseType/Get/" + primaryId)
            .done(function (result) {
                var getResult = JSON.parse(result);
                $('#txtCentralCleanLinenStore').val(getResult.LicenseTypeId);
                // $('#txtCentralCleanLinenStore').val(getResult.LicenseType);
                $('#LicenseCode_').val(getResult.LicenseCode);
                $('#LicenseDescription_').val(getResult.LicenseDescription);
                $('#IssuingBody_').val(getResult.IssuingBody);
                $('#primaryID').val(getResult.LicenseTypeDetId);
                if (getResult != null && getResult.LicenseTypeModelListData != null && getResult.LicenseTypeModelListData.length > 0) {
                    BindGridData(getResult);
                }
            })
            .fail(function () {
                $('#myPleaseWait').modal('hide');
                $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
                $('#errorMsg').css('visibility', 'visible');
            });
}



//***********************End****************************

// **** Query String to get ID Begin****\\\

//var getUrlParameter = function getUrlParameter(sParam) {
//    var sPageURL = decodeURIComponent(window.location.search.substring(1)),
//        sURLVariables = sPageURL.split('&'),
//        sParameterName,
//        i;

//    for (i = 0; i < sURLVariables.length; i++) {
//        sParameterName = sURLVariables[i].split('=');

//        if (sParameterName[0] === sParam) {
//            return sParameterName[1] === undefined ? true : sParameterName[1];
//        }
//    }
//};
//var ID = getUrlParameter('id');
//if (ID == null || ID == undefined || ID == 0 || ID == '' || ID == "") {
//    $("#jQGridCollapse1").click();
//}
//else {
//    LinkClickedS(ID);
//}
// **** Query String to get ID  End****\\\


////////////////////***********Add rows **************//
$('#contactBtn').click(function () {

    var rowCount = $('#SummaryResultId tr:last').index();
    var LicenseCode = $('#LicenseCode_' + rowCount).val();
    var LicenseDescription = $('#LicenseDescription_' + rowCount).val();
    var IssuingBody = $('#IssuingBody_' + rowCount).val();


    if (rowCount < 0) {
        AddNewRowStkAdjustment();
        appendIndicator_name(Indexs);
    }
    else if (rowCount >= "0" && (LicenseCode == "" || LicenseDescription == "" || IssuingBody == "")) {
        bootbox.alert("Please fill the last record");
    }
    else {
        AddNewRowStkAdjustment();
        var Indexs = $('#SummaryResultId tr:last').index();
        appendIndicator_name(Indexs);
    }
});

function getindicatorsinfo(indexs) {

    // var indicatorDi = 
    // alert($('#LicenseCode_' + indexs).val());//
    var idss = $('#LicenseCode_' + indexs).val();
    var ID = $("#TypeOfServiceRequest").val();

    $.get("/api/CRMRequestApi/get_Indicator_by_Serviceid/" + ID)
        .done(function (result) {

            $(result.Indicators).each(function (_index, _data) {
                if (_data.LovId == idss) {
                    $('#LicenseDescription_' + indexs).val(_data.Indicator_Name);
                } else {
                }

            });
        }).fail(function (result) {

        });

    // appendIndicator_name(indexs, idss);

}
function appendIndicator_name(indexs) {

    var Indexs = $('#SummaryResultId tr:last').index();
    var ID = $("#TypeOfServiceRequest").val();

    $.get("/api/CRMRequestApi/get_Indicator_by_Serviceid/" + ID)
        .done(function (result) {
            // var getResult = JSON.parse(result);
            $('#LicenseCode_' + indexs).prop('disabled', false);
            $('#LicenseDescription_' + indexs).prop('disabled', true);
            $(result.Indicators).each(function (_index, _data) {
                $('#LicenseCode_' + indexs).append($('<option></option>').val(_data.LovId).html(_data.FieldValue));
            });
        }).fail(function (result) {

        });
}

$("#Vaidation").change(function () {
    if ($("#Vaidation").val() == 99) {
        var Indexs = $('#SummaryResultId tr:last').index();
        $("#indicatorDiv").show();
        $('#JustificationLLS').val('');
        $('#LicenseDescription_0').prop('required', true);

        $('#LicenseCode_0').prop('required', true);

        $('#lblcrmJustificationLLS').html("Justification");
        $('#JustificationLLS').prop('required', false);
        $('#just').css('visibility', 'hidden');
        $('#JustificationLLS').prop('disabled', false);
        var ID = $("#TypeOfServiceRequest").val();
        SummaryNewRow();
        $.get("/api/CRMRequestApi/get_Indicator_by_Serviceid/" + ID)
            .done(function (result) {
                $(result.Indicators).each(function (_index, _data) {
                    $('#LicenseCode_0').append($('<option></option>').val(_data.LovId).html(_data.FieldValue));
                });
            }).fail(function (result) {

            });
    } else {

        $('#LicenseDescription_0').prop('required', false);
       // $('#JustificationForReason').prop('required', true);
        //$('#JustificationLLS').prop('required', true);
       // $('#JustificationLLS').prop('disabled', true);
        $('#lblcrmJustificationLLS').html("Justification <span class='red'>*</span>");
       // $('#just').css('visibility', 'visible');
        $("#SummaryResultId").empty();
        $("#indicatorDiv").hide();
    }

});

$("#JustificationForReason").change(function () {
    if ($("#JustificationForReason").val() == 10812) {
        $('#JustificationLLS').val('');
        $('#JustificationLLS').prop('disabled', false);
        $('#JustificationLLS').prop('required', true);
    }
    else {
        $('#JustificationLLS').prop('disabled', true);
        var e = document.getElementById("JustificationForReason");
        var text = e.options[e.selectedIndex].text;
        //var x = $("#JustificationForReason").val();
        $(JustificationLLS).val(text);
    }
});

function printDiv(divName) {
    generatePDF();
    //domtoimage.toPng(document.getElementById('divCommonHistory1'))
    //    .then(function (blob) {
    //        var pdf = new jsPDF('l', 'pt', [$('#divCommonHistory1').width(), $('#divCommonHistory1').height()]);

    //        pdf.addImage(blob, 'PNG', 0, 0, $('#divCommonHistory1').width(), $('#divCommonHistory1').height());
    //        pdf.save("Print.pdf");

    //        that.options.api.optionsChanged();
    //    });

}



$('#cmd2').click(function () {
    var options = {
        //'width': 800,
    };
    var pdf = new jspdf('p', 'pt', 'a4');
    pdf.addhtml($("#content2"), -1, 220, options, function () {
        pdf.save('admit_card.pdf');
    });
});
$('#downloadPDF').click(function () {
    generatePDF();
    //domtoimage.toPng(document.getElementById('content2'))
    //    .then(function (blob) {
    //        var pdf = new jsPDF('l', 'pt', [$('#content2').width(), $('#content2').height()]);

    //        pdf.addImage(blob, 'PNG', 0, 0, $('#content2').width(), $('#content2').height());
    //        pdf.save("test.pdf");

    //        that.options.api.optionsChanged();
    //    });
});

function generatePDF() {
    // Choose the element that our invoice is rendered in.
    const element = document.getElementById("divCommonHistory11");
    // Choose the element and save the PDF for our user.
    html2pdf().from(element).save();
}
