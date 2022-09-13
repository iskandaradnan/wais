
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
    $('#lblCrmpriority').hide();


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
    formInputValidation("form");
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
            $('#TypeOfDeduction ').append($('<option></option>').val(_data.LovId).html(_data.FieldValue))
        });
        $(LOVlist.RequestServiceList).each(function (_index, _data) {
            $('#TypeOfServiceRequest').append($('<option></option>').val(_data.LovId).html(_data.FieldValue))
        });
        $(LOVlist.PriorityList).each(function (_index, _data) {
            $('#crmReqPriority').append($('<option></option>').val(_data.LovId).html(_data.FieldValue))
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

        //////////----------Deepak---------------
        function UpdateDBsession()
        {
            //var sid = $('#TypeOfServiceRequest').val();
            //$.get("/api/CRMRequestApi/UpdateDB/" + sid)
            //    .done(function(result) {
            //        filterGrid();
            //       // showMessage('CRMRequestApi', CURD_MESSAGE_STATUS.DS);
            //        $('#myPleaseWait').modal('hide');
            //        $(function() {
            //            var RequestService = "Advisory Services:Advisory Services;Alert:Alert;Feedback:Feedback;Hazard:Hazard;Incident:Incident;Recall:Recall;T&C:T&C;Obsolete:Obsolete;";
            //            var ServiceValues = "Open:Open;Work In Progress:Work In Progress;Completed:Completed;Closed:Closed;Cancelled:Cancelled;Reassigned:Reassigned;";

            //            genarateGrid(ServiceValues, RequestService);
            //        });
            //       // EmptyFields();
            //    })
            //    .fail(function() {
            //      //  showMessage('CRMRequestApi', CURD_MESSAGE_STATUS.DF);
            //        $('#myPleaseWait').modal('hide');
            //    });


        }
        $("#TypeOfRequest").change(function () {
            $("#form :input:not(:button)").parent().removeClass('has-error');
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
            if (this.value == 136 || this.value == 137) {
                //$('#CrmAssetGrid').css('visibility', 'visible');
                //$('#CrmAssetGrid').show();   
                //-----Deepak
               // UpdateDBsession();              
                $("#grid").trigger('reloadGrid');
                $('#TypeOfRequest').focus();
                $('#CrmReqPlus').show();
                $('#crmReqManu').prop('required', true);
                // $("#lblCrmReqmanu").html("Manufacturer <span class='red'>*</span>");
                $('#crmReqModel').prop('required', true);
                $("#lblCrmreqMod").html("Model <span class='red'>*</span>");
                $("#lblCrmReqTarDat").html("Target Date");
                $('#crmReqTarDat').prop('required', false);
                $("#lblCrmreqReqPer").html("Requested Person");
                $('#crmReqReqPer').prop('required', false);

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

            }
            else if (this.value == 132 || this.value == 135) {
                $('#AreaLocDiv').css('visibility', 'hidden');
                $('#AreaLocDiv').hide();
                $('#ReqTypTCDiv').css('visibility', 'hidden');
                $('#ReqTypTCDiv').hide();
                $('#CrmAssetGrid').css('visibility', 'hidden');
                $('#CrmAssetGrid').hide();
                $('#CrmReqPlus').hide();

                $('#DateTimeDiv').hide();
                $('#crmReqManu').prop('disabled', false);
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


            }
            else if (this.value == 134 || this.value == 138) {

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

            }
            else if (this.value == 375) {

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

                //  $("#labCrmReqAreaCd").html("Area Code <span class='red'>*</span>");
                $("#labCrmReqLocCd").html("Location Code <span class='red'>*</span>");
                //$('#CrmReqUsrAreaCd').prop('required', true);
                $('#CrmReqUsrLocCde').prop('required', true);
                $('#crmReqManu').prop('required', false);
                $("#lblCrmReqmanu").html("Manufacturer");
                $('#crmReqModel').prop('required', false);
                $("#lblCrmreqMod").html("Model");
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

                //---------------------------



            }
            else if (this.value == 374) {

                $('#CrmAssetGrid').css('visibility', 'hidden');
                $('#CrmAssetGrid').hide();
                $("#CrmObsoleteFetchSave").css('visibility', 'visible');
                //$("#CRMRequestGrid").empty();
                //AddNewRowCRMRequest();               
                $('#crmReqManu').prop('required', true);
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

            }
            else if (this.value == 10020) {
                ServiceClicked();

                $('#TypeOfRequest').focus();
                $('#CrmReqPlus').show();
                $('#crmReqManu').prop('required', true);
                // $("#lblCrmReqmanu").html("Manufacturer <span class='red'>*</span>");
                $('#crmReqModel').prop('required', true);
                $("#lblCrmreqMod").html("Model <span class='red'>*</span>");
                $("#lblCrmReqTarDat").html("Target Date");
                $('#crmReqTarDat').prop('required', false);
                $("#lblCrmreqReqPer").html("Requested Person");
                $('#crmReqReqPer').prop('required', false);


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
                $('#btnSave').prop('disabled', false);
                $('#btnSaveandAddNew').prop('disabled', false);
                $('#CrmAssetGrid').css('visibility', 'hidden');
                $('#CrmAssetGrid').hide();
                //$('#RequestDescription').prop('required', false);
                //$("#lblcrmReqDesc").html("Request Description");


                $('#crmReqManu').prop('disabled', false);

                $('#DateTimeDiv').show();
                $('#Modelrow').hide();
                $('#RequestDescDiv').hide();
                $('#DeductionIndDiv option:selected').text();
                $('#DeductionIndDiv').show();
                $('#crmReqPriority').hide();
                $('#lblCrmpriority').hide();
                $('#NonConformanceRequestDescription').prop('required', true);
                $('#TypeOfDeduction').prop('required', true);
                $('#crmReqPriority').prop('required', false);


            }
            else if (this.value == 10021) {

                $('#DateTimeDiv').show();
                $('#Modelrow').hide();
                $('#RequestDescDiv').show();
                $('#DeductionIndDiv').hide();
                $('#crmReqPriority').show();
                $('#lblCrmpriority').show();
                $('#NonConformanceRequestDescription').prop('required', false);
                $('#TypeOfDeduction').prop('required', false);
                $('#crmReqPriority').prop('required', true);
            }
            else if (this.value == 10022) {

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
            }
        });


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

    

    $("#TypeOfDeduction").change(function () {
        $('#ServiceIndicator').empty();
        var jqxhr = $.get("/api/CRMRequestApi/Load", function (response) {
            var result = response;

            var serviceid = $("#TypeOfDeduction option:selected").text();

            LOVlist = result;
            $(LOVlist.IndicatorList_Descr).each(function (_index, _data) {
                var test = _data.FieldValue;
                if (test == serviceid) {
                    $('#ServiceIndicator').val(_data.Description);
                }
            });


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

    });

    //$("#btnsave").click(function () {
    //    alert();
    //});


    $("#btnSave,#btnEdit,#btnSaveandAddNew").click(function () {
        $('#btnlogin').attr('disabled', true);
        $('#myPleaseWait').modal('show');
        var CurrentbtnID = $(this).attr("Id");
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
        $('#TypeOfDeduction').prop('disabled', false);
        $('#NonConformance').prop('disabled', false);
        var _index;
        $('#CRMRequestGrid tr').each(function () {
            _index = $(this).index();
        });

        // actionType = $('#ActionType').val();
        var isapproved = $("#hdnCrmReqChkstsApp").val();
        var serviceIndicator = $("#ServiceIndicator").val();
        //var ServiceId = $('#TypeOfServiceRequest option:selected').val();
        var PriorityList = $('#crmReqPriority option:selected').val();
        var CRMRequestId = $("#primaryID").val();
        var ReqNo = $("#RequestNo").val();
        var ReqDateTime = $("#RequestDateTime").val();
        var ReqDateTimeUTC = new Date().toUTCString();
        // var ReqDateTimeUTC = ReqDateTime.toUTCString();
        var requesterName = $("#crmReqRequester").val();
        var requester = $("#hdncrmReqRequesterId").val();
        var TypeReq = $("#TypeOfRequest").val();
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
        var Dedindi = $("#TypeOfDeduction").val();
        var Remarks = $("#Remarks").val();
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
        var responceDateTime = $("#RequestAction").val();
        var completeDateTime = $("#RequestAction").val();
        var completedbyName = $("#Completedby").val();
        var completedby = $("#hdncrmReqCompletedbyId").val();

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
        //if (ReqDeductiontype == "") {
        //    var ReqDeductiontype = null;
        //}
      

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
            

            var isFormValid = formInputValidation("form", 'save');
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
                //var assetId = result[i].AssetId;
                //for (j = i + 1; j < result.length; j++) {
                //    if (assetId == result[j].AssetId ) {
                //        duplicates = true;
                //    }
                //}
            }

            if (duplicates) {
                $("div.errormsgcenter").text("Asset No. should be unique.");
                $('#errorMsg').css('visibility', 'visible');
                $('#myPleaseWait').modal('hide');
                return false;
            }
        }


        //else if (TypeReq == 375) {

        //}
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
        if (hasveracc == true && (TypeReq == 132 || TypeReq == 135)) {
            RequestStatus = 139;
        }

        var Chkentryuser = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Approve'");
        if (Chkentryuser == true && (TypeReq == 132 || TypeReq == 135)) {
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
            reqDeductiontype: ReqDeductiontype,
            Timestamp: Timestamp,
            TargetDate: TarDat,
            RequestPersonId: reqPerId,
            AccessFlag: isapproved,
            AssigneeId: tcassigneId,
            ChkEntUser: entusr,
            CurrentDatetimeLocal: CurDateTime,
            TypeOfDeduction: Dedindi,
            TypeOfServiceRequest: typeOfServiceRequest,
            PriorityList: priorityList,
            ServiceIndicator: serviceIndicator,
            NonConformanceRequestDescription: nonConformanceRequestDescription,
            Completedstaffid:completedby,
            RequestAction:requestAction,
            ResponceDateTime: responceDateTime,
            CompleteDateTime: completeDateTime
            
            
        }

        var isFormValid = formInputValidation("form", 'save');
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
                    $("#grid").trigger('reloadGrid');
                }
            });
        }
        else {
            SaveCrmRequest(obj);
            $("#grid").trigger('reloadGrid');
        }

        
   
        function SaveCrmRequest(obj) {
            var jqxhr = $.post("/api/CRMRequestApi/save", obj, function(response)
            {
                var result = JSON.parse(response);
                $("#primaryID").val(result.CRMRequestId);
                $("#Timestamp").val(result.Timestamp);
               // $("#grid").trigger('reloadGrid');

                //if ((result.TypeOfRequest == 136 || result.TypeOfRequest == 137 || result.TypeOfRequest == 134 || result.TypeOfRequest == 138)) {
                //    $('#btnSaveConverttoWO').css('visibility', 'visible');
                //    $('#btnSaveConverttoWO').show();
                //}

                if (result.CRMRequestId != 0) {
                    // $('#LevelCode').prop('disabled', true);
                    $('#btnNextScreenSave').show();
                    $('#btnEdit').show();
                    $('#btnSave').hide();
                }

                BindDatatoHeader(result);
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

        var isFormValid = formInputValidation("form", 'save');
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

        //---------------------------

        //$('#NonConformance').val();
        //$('#NonConformanceRequestDescription').val();
        //$('#TypeOfDeduction').val();
        //$('#crmReqPriority').val();
        //$('#ResponceDateTime').val();
        //$('#CompleteDateTime').val();
        //$('#Completedby').val();

        //-------------------------
        var ReqType = $("#TypeOfRequest").val();
        //var ReqType = $("#TypeOfRequest").val();
        var serviceId = $('#TypeOfServiceRequest option:selected').val();
        var AppAssigne = $("#crmReqAssigne").val();
        var AssEmail = $("#hdncrmReqAssigneEmail").val();
        var ReqEmail = $("#hdncrmReqRequesterEmail").val();
        //var reqDeductiontype = $("#ReqDeductiontype").val();
        //var priority = $('#crmReqPriority').val();
        //var nonConformance = $('#NonConformance').val();
        //var nonConformanceRequestDescription = $('#NonConformanceRequestDescription').val();
        //var typeOfDeduction = $('#TypeOfDeduction').val();
        //var responceDateTime = $('#ResponceDateTime').val();
        //var completeDateTime = $('#CompleteDateTime').val();
        //var completedby = $('#Completedby').val();
        if (ReqType == 375) {
            if (AppAssigne == "") {
                bootbox.alert("Assignee is mandatory for Approve");
                $('#myPleaseWait').modal('hide');
                return false;

            }
        }
        if (ReqType == 10020) {
            if (reqDeductiontype == "") {
                bootbox.alert("Assignee is mandatory for Approve");
                $('#myPleaseWait').modal('hide');
                return false;

            }
        }


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
            ServiceId: serviceId
            //CurrentDatetimeLocal: CurDateTime,
            //crmReqPriority: priority,
            //NonConformance: nonConformance,
            //NonConformanceRequestDescription: nonConformanceRequestDescription,
            //TypeOfDeduction: typeOfDeduction,
            //ResponceDateTime: responceDateTime,
            //CompleteDateTime: completeDateTime,
            //Completedby: completedby
        }


        var isFormValid = formInputValidation("form", 'save');
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

    });




    $("#btnVerify").click(function () {
        $('#btnlogin').attr('disabled', true);
        $('#myPleaseWait').modal('show');

        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');

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
        var isFormValid = formInputValidation("form", 'save');
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
            CurrentDatetimeLocal: CurDateTime
        }
        var isFormValid = formInputValidation("form", 'save');
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
        var TypeofRequest = $('#TypeOfRequest').val();
        var serviceID = $('#TypeOfServiceRequest').val();
        var ModelN = $('#crmReqModel').val();
        var ManufacturerN = $('#crmReqManu').val();
        var obj = {
            ModelId: mod,
            ManufacturerId: manufac,
            TypeOfServiceRequest: TypeofRequest,
            ServiceId: serviceID,
            Model: ModelN,
            Manufacturer: ManufacturerN
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
       // $("#grid").trigger('reloadGrid');

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

        EmptyFields();
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
            EmptyFields();
        }
        else {
            $('#myPleaseWait').modal('hide');
        }
    });
});

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
    formInputValidation("form");
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
    SearchColumns: ['Model-Model',],//ModelProperty - Space seperated label value
    ResultColumns: ["ModelId-Primary Key", 'Model-Model', 'Manufacturer-Manufacturer',],//Columns to be returned for display
    FieldsToBeFilled: ["hdncrmReqModId-ModelId", 'crmReqModel-Model', "hdncrmReqManuId-ManufacturerId", 'crmReqManu-Manufacturer',]//id of element - the model property--, , 
};
$('#spnPopup-RequestMdl').click(function () {
    var RequestServiceList = 1;
        RequestServiceList=$('#TypeOfServiceRequest').val();
    var FetchModelObjs = {
        Heading: "Model Details",//Heading of the popup
        SearchColumns: ['Model-Model',],//ModelProperty - Space seperated label value
        ResultColumns: ["ModelId-Primary Key", 'Model-Model', 'Manufacturer-Manufacturer',],//Columns to be returned for display
        FieldsToBeFilled: ["hdncrmReqModId-ModelId", 'crmReqModel-Model', "hdncrmReqManuId-ManufacturerId", 'crmReqManu-Manufacturer',],//id of element - the model property--, , 
        TypeOfServices: RequestServiceList
    };
    DisplaySeachPopup('divSearchPopup', FetchModelObjs, "/api/Search/ModelSearch");
    
});

//--------------------------------------------------------------search--------------------------------------------------------------------------------------------------//

var FetchUserLocationObj = {
    Heading: "Location Details",//Heading of the popup
    SearchColumns: ['UserLocationName-Location Name',],//Id of Fetch field
    ResultColumns: ["UserLocationId-Primary Key", 'UserLocationName-Location Name', 'UserAreaName-Area Name', 'BlockName-Block Name', 'LevelName-Level Name',],//Columns to be displayed
    AdditionalConditions: ["UserAreaId-hdnCrmReqUsrAreaCdId",],
    FieldsToBeFilled: ["hdnCrmReqUsrLocCdeId-UserLocationId", 'CrmReqUsrLocCde-UserLocationCode', 'CrmReqUsrLocNam-UserLocationName', 'CrmReqUsrAreaCd-UserAreaCode', 'hdnCrmReqUsrAreaCdId-UserAreaId', 'CrmReqUsrAreaNam-UserAreaName', 'CrmReqUsrBlockNam-BlockName', 'CrmReqUsrBlockCd-BlockCode', 'CrmReqUsrLevelCd-LevelCode', 'CrmReqUsrLevelNam-LevelName',]//id of element - the model property
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
        FieldsToBeFilled: ["hdncrmReqReqPeId" + "-StaffMasterId", 'crmReqReqPer' + '-StaffName',]//id of element - the model property
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
    formInputValidation("form");
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
    EmptyFields();
    //$('#TypeOfRequest').val('');
    $('#TypeOfDeduction').empty();


    var jqxhr = $.get("/api/CRMRequestApi/Load", function (response) {
        var result = response;
        var serviceid = $("#TypeOfServiceRequest").val();
        LOVlist = result;
        if (serviceid == 1) {
            $(LOVlist.IndicatorList).each(function (_index, _data) {
                var test = _data.FieldValue;
                if (test.includes('F')) {
                    $('#TypeOfDeduction').append($('<option></option>').val(_data.LovId).html(_data.FieldValue))
                }
            });
        }
        else {
            $(LOVlist.IndicatorList).each(function (_index, _data) {
                var test = _data.FieldValue;
                if (test.includes('B')) {
                    $('#TypeOfDeduction').append($("<option>Selected</option>").val(_data.LovId).html(_data.FieldValue))
                }
            });
        }

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

}


function LinkClicked(id) {
    EmptyFields(true);
    $(".content").scrollTop(1);
    $('.nav-tabs a:first').tab('show');
    $("#form :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('#TypeOfServiceRequest').prop("required", false);
    //-----------------
    $('#NonConformanceRequestDescription').prop('required', false);
    $('#TypeOfDeduction').prop('required', false);
    $('#crmReqPriority').prop('required', false);
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
        $("#form:input:not(:button)").prop("disabled", true);
    } else {
        $('#btnEdit').show();
        $('#btnSave').hide();
        //$('#btnSaveandAddNew').hide();
        $('#btnNextScreenSave').show();
        $('#btnDelete').show();
    }
    $('#spnActionType').text(action);

    var reqid = $("#primaryID").val();
    if (action !== "Add") {
        var jqxhr = $.get("/api/CRMRequestApi/get/" + reqid + "/" + pagesize + "/" + pageindex, function (response) {
            var result = JSON.parse(response);
            var htmlval = ""; $('#tablebody').empty();
            $('#myTable').empty();
            BindDatatoHeader(result);
            
            //bindDatatoDatagrid(result.ItemMstFetchEntityList);
            if (action == "View") {
                $("#form:input:not(:button)").prop("disabled", true);
                $("#addnewrowbtn,#savebtn,#uploadbtn,#exportbtn,#addnewbtn").hide();
            }

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
                    errorMessage = Messages.COMMON_FAILURE_MESSAGE(response);
                }
                $("div.errormsgcenter").text(errorMessage);
                $('#errorMsg').css('visibility', 'visible');
                $('#btnSave').attr('disabled', false);
                $('#myPleaseWait').modal('hide');
            });

    }
}

$("#btnDelete").click(function () {
    var ID = $('#primaryID').val();
    confirmDelete(ID);

});
function confirmDelete(ID) {
    var message = Messages.SEARCH_GRID_DELETE_CONFIRMATION;
    var pageId = $('.ui-pg-input').val();
    bootbox.confirm(message, function (result) {
        if (result) {
            $.get("/api/CRMRequestApi/Cancel/" + ID)
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

function EmptyFields(fromLink) {
    $('input[type="text"], textarea').val('');
    $('#btnEdit').hide();
    $('#btnSave').show();
    $('#btnSaveandAddNew').show();
    $('#TypeOfDeduction').val('Select');
    $('#btnDelete').hide();
    $('#btnNextScreenSave').hide();
    $('#spnActionType').text('Add');
    $("#primaryID").val('');
    $("#TypeOfRequest").val('');
    $("#TypeOfServiceRequest").val('');
    $("#RequestStatus").val(139);
    if (fromLink == undefined) {
        $("#grid").trigger('reloadGrid');
    }
    $("#form:input:not(:button)").parent().removeClass('has-error');
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
    $("#form:input:not(:button)").parent().removeClass('has-error');
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
    $("#RequestDateTime").prop('disabled', true);
    $("#crmReqTarDat").prop('disabled', false);
    $('#crmReqTarDat').css("background-color", "#fff");
    //$('#btnApprove').css('visibility', 'hidden');
    //$('#btnApprove').hide();
    //$('#btnReject').css('visibility', 'hidden');
    //$('#btnReject').hide();
    $('#WorkAssiDiv').css('visibility', 'hidden');
    $('#WorkAssiDiv').hide();



}

function BindDatatoHeader(getResult) {
    var primaryId = $('#primaryID').val();
    //$('#DateTimeDiv').show();
    //$('#crmReqManu').prop('disabled', false);
    //$('#Modelrow').show();
    //$('#RequestDescDiv').show();
    //$('#crmReqPriority').show();
    //$('#lblCrmpriority').show();
    //$('#TypeOfDeduction').prop('disabled', false);
    //$('#NonConformance').prop('disabled', false);
    //$('#NonConformanceRequestDescription').prop('required', false);
    //$('#TypeOfDeduction').prop('required', false);
    //$('#crmReqPriority').prop('required', false);

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
        $('#Remarks').prop('required', true);
        $("#TypeOfRequest").prop('disabled', true);
    }

    $("#divWOStatus").text(getResult.WorkOrderStatus);
    $("#RequestNo").val(getResult.RequestNo);
    $("#RequestDateTime").val(moment(getResult.RequestDateTime).format("DD-MMM-YYYY HH:mm")).prop("disabled", true);
    $("#crmReqRequester").val(getResult.ReqStaff);
    $("#hdncrmReqRequesterId").val(getResult.ReqStaffId);
    $("#hdncrmReqRequesterEmail").val(getResult.RequesterEmail);
    // moment(getResult.AssessmentStartDate).format("DD-MMM-YYYY HH:mm")

    //if (getResult.IsReqTypeReferenced == 1) {
    $("#TypeOfRequest").val(getResult.TypeOfRequest).prop("disabled", false);
    $('#TypeOfServiceRequest option[value="' + getResult.ServiceId + '"]').prop('selected', true);
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

    if (getResult.TypeOfRequest == 10020 || getResult.TypeOfRequest == 10022  ) {
        $('#crmReqPriority').hide();
        $('#lblCrmpriority').hide();
    }
    if (getResult.TypeOfRequest == 134 || getResult.TypeOfRequest == 138) {
        $('#AreaLocDiv').css('visibility', 'visible');
        $('#AreaLocDiv').show();
        $('#paginationfooter').hide();
        $('#ReqTypTCEngDiv').css('visibility', 'hidden');
        $('#ReqTypTCEngDiv').hide();
        $('#btnVerify').hide();
        $('#crmReqPriority').hide();
        $('#lblCrmpriority').hide();
         //new comment on 10/10/19
        //$('#DateTimeDiv').hide();


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
    $('#CrmReqUsrLevelCd').val(getResult.LevelCode);
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
    }

    //if ((getResult.TypeOfRequest == 136 || getResult.TypeOfRequest == 137 || getResult.TypeOfRequest == 134 || getResult.TypeOfRequest == 138 )) {
    //    $('#btnSaveConverttoWO').css('visibility', 'visible');
    //    $('#btnSaveConverttoWO').show();
    //}

    if (getResult.IsWorkorderGen == true) {
        $('#btnSaveConverttoWO').css('visibility', 'hidden');
        $('#btnSaveConverttoWO').hide();
        $('#Remarks').prop("disabled", true);
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
        $('#Remarks').prop('disabled', true);
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
        $('#Remarks').prop('disabled', true);
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

    $("#Remarks").val('');

    $("#CRMRequestGrid").empty();
    if (getResult.TypeOfRequest == 10021) {
        $('#lblCrmpriority').show();
        $('#crmReqPriority').show();
        $('#crmReqPriority').prop('required', true);

    }

    if (getResult.TypeOfRequest == 136 || getResult.TypeOfRequest == 137) {

        $('#CrmAssetGrid').css('visibility', 'visible');
        $('#CrmAssetGrid').show();
        // AddNewRowCRMRequest();
        //$('#CrmReqPlus').show();
        //$('#paginationfooter').show();
        $('#ReqTypTCEngDiv').css('visibility', 'hidden');
        $('#ReqTypTCEngDiv').hide();
        $('#crmReqManu').prop('required', true);
        // $("#lblCrmReqmanu").html("Manufacturer <span class='red'>*</span>");
        $('#crmReqModel').prop('required', true);
        $("#lblCrmreqMod").html("Model <span class='red'>*</span>");
        $('#crmReqPriority').hide();
        $('#lblCrmpriority').hide();


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
            var obj = { formId: "#form", IsView: ($('#ActionType').val() == "VIEW"), PageNumber: pageindex, flag: "CRMRequest", mapIdproperty: mapIdproperty, htmltext: htmltext, GridtotalRecords: GridtotalRecords, ListName: "CRMRequestGridData", tableid: '#CRMRequestGrid', destionId: "#paginationfooter", TotalPages: TotalPages, FirstRecord: FirstRecord, LastRecord: LastRecord, geturl: "/api/CRMRequestApi/Get/" + primaryId, pageindex: pageindex, pagesize: pagesize };

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
        $('#Remarks').prop('disabled', true);
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
        $('#Remarks').prop('disabled', true);
        $('#chk_CrmReq').prop('disabled', true);
        $('#crmReqTarDat').css("background-color", "#eee");
        $('#crmReqTarDat').prop('disabled', true);
    }
    if (getResult.TypeOfRequest == 132 || getResult.TypeOfRequest == 135) {
    //if (getResult.TypeOfRequest == 132 || getResult.TypeOfRequest == 135 || getResult.TypeOfRequest == 10022) {
        $('#btnApprove').show();
        $('#btnReject').show();
        //$('#btnVerify').hide();
        $('#btnClarify').show();
        $('#crmReqPriority').hide();
        $('#lblCrmpriority').hide();

        var ApprivAcc = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Approve'");
        if (ApprivAcc == true) {
            $("#form :input:not(:button)").prop("disabled", true);
            $('#Remarks').prop('disabled', false);
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
        $("#form :input:not(:button)").prop("disabled", true);
        if (enableCheckBoxes) {
            $('#chk_CrmReq').attr('disabled', false)
            var len = $('#CRMRequestTable tr').length - 1;
            for (i = 0; i < len; i++) {
                $('#Isdeleted_' + i).attr('disabled', false);
            }
        }
        $('#Remarks').prop('disabled', false);
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
            $('#Remarks').prop('disabled', true);
        }
    }

    if (getResult.IsWorkorderGen == true) {
        $('#Remarks').prop('disabled', true);
        $('#CrmreqReqWOAss').prop('disabled', true);
        $('#Popup-RequestMdl').hide();
        $('#spnPopup-RequestMdl').hide();
        $('#Popup-ReqUsrLocCde').hide();
        $('#spnPopup-ReqUsrLocCde').hide();
    }
    if (getResult.RequestStatus == 142 || getResult.RequestStatus == 143) {
        //$("#form :input:not(:button)").prop("disabled", true);
        $('#Remarks').prop('disabled', true);
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
   
   

}
