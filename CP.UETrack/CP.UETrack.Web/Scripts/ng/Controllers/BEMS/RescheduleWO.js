//********************************************* Pagination Grid ********************************************

var pageindex = 1, pagesize = 5;
var TotalPages = 1

//var pageindex = 1, pagesize = 5;
//var GridtotalRecords = 0;
//var TotalPages = 0, FirstRecord = 0, LastRecord = 0;
formInputValidation("formBemsRescheduleWO");
$(document).ready(function () {
    $('#btnDelete').hide();
    $('#btnEdit').hide();
    $('#fetchgrid').hide();
    $('#myPleaseWait').modal('show');

    $.get("/api/reschedulewo/Load")
        .done(function (result) {
            var loadResult = JSON.parse(result);
            $("#jQGridCollapse1").click();
            window.ReasonLoadData = loadResult.ReasonData

            $.each(loadResult.PlannerLovs, function (index, value) {
                $('#RescheduleTypeofPlanner').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $.each(loadResult.Reason, function (index, value) {
                $('#RescheduleDetailsid').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });

            $('#RescheduleFetchSave').show();
            AddNewRow();
            $("#RescAddNew").show();
            $("#btnSave").prop('disabled', true);
            $("#btnSaveandAddNew").prop('disabled', true);


            $("#NewAssigneFetch").on('click', function () {
                var newstaffid = $("#HdnRescheduleNewAssigneId").val();
                var newstaff = $("#RescheduleNewAssignee").val();

                if (newstaffid > 0) {
                    var _index;
                    $('#rescheduleWOGrid tr').each(function () {
                        _index = $(this).index();
                        $('#ReschNewAssigne_' + _index).val(newstaff);
                        $('#hdnNewAssigneid_' + _index).val(newstaffid);
                    });
                }

            });
            $("#RescheduleDetailsid").on('change input', function () {

                var testing = $('#RescheduleDetailsid option:selected').text();
                var ssss = $("#RescheduleDetails").val(testing);


            });

            $("#RescheduleAssignee").on('change input', function () {
                $('#rescheduletbl').css('visibility', 'hidden');
                $('#rescheduletbl').hide();
                $("#rescheduleWOGrid").empty();
                $('#divPagination').hide();
                $("#RescheduleNewAssignee").prop('disabled', true);
                $("#RescheduleDetails").prop('disabled', true);
                $("div.errormsgcenter").text("");
                $('#errorMsg').css('visibility', 'hidden');
            });
            $("#RescheduleAreaName").on('change input', function () {
                $('#rescheduletbl').css('visibility', 'hidden');
                $('#rescheduletbl').hide();
                $("#rescheduleWOGrid").empty();
                $('#divPagination').hide();
                $("div.errormsgcenter").text("");
                $('#errorMsg').css('visibility', 'hidden');
            });
            $("#RescheduleLocationName").on('change input', function () {
                $('#rescheduletbl').css('visibility', 'hidden');
                $('#rescheduletbl').hide();
                $("#rescheduleWOGrid").empty();
                $('#divPagination').hide();
                $("div.errormsgcenter").text("");
                $('#errorMsg').css('visibility', 'hidden');
            });
            $("#RescheduleTypeofPlanner").on('change', function () {
                $('#rescheduletbl').css('visibility', 'hidden');
                $('#rescheduletbl').hide();
                $("#rescheduleWOGrid").empty();
                $('#divPagination').hide();
                $("div.errormsgcenter").text("");
                $('#errorMsg').css('visibility', 'hidden');
            });







            //formInputValidation("formBemsRescheduleWO");

            //var primaryId = $('#primaryID').val();
            //if (primaryId != null && primaryId != "0") {
            //    //getById(primaryId)
            //    $.get("/api/reschedulewo/get/" + primaryId)
            //    .done(function (result) {
            //        result = JSON.parse(result);

            //        GetSaveRescheduleResultBind(result)

            //        $('#myPleaseWait').modal('hide');
            //    })
            //    .fail(function () {
            //        $('#myPleaseWait').modal('hide');
            //        $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
            //        $('#errorMsg').css('visibility', 'visible');
            //    });
            //}
            //else {       
            //    $('#myPleaseWait').modal('hide');
            //}
        })
        .fail(function () {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
        });




    $('#RescheduleFetchSave').click(function () {

        var areaname = $('#RescheduleAreaName').val();
        //var Locname = $('#RescheduleLocationName').val();
        var areaid = $('#HdnRescheduleAreaId').val();
        var locationid = $('#HdnRescheduleLocId').val();
        var staffid = $('#HdnRescheduleAssigneId').val();
        var planner = $('#RescheduleTypeofPlanner').val();
        var result = $('#RescheduleDetailsid').val();
        var assitId = 0;
        assitId = $('#hdnAssetId').val();

        if (areaid == "" && areaname == "") {
            var areaid = null;
        }
        else if (areaid == "" && areaname != "") {
            bootbox.alert("Valid Area Name required");
            return false;
        }
        if (locationid == "" && Locname == "") {
            var locationid = null;
        }
        else if (locationid == "" && Locname != "") {
            bootbox.alert("Valid Location Name required");
            return false;
        }

        var objs = {
            UserAreaId: areaid,
            UserLocationId: locationid,
            StaffMasterId: staffid,
            PlannerId: planner,
            AssetId: assitId,
            PageSize: $('#selPageSize').val(),
            PageIndex: pageindex,
            PageSize: pagesize
        }

        var staffval = $('#RescheduleAssignee').val();
        var staff = $('#HdnRescheduleAssigneId').val();

        if (staff != "" && staffval != "") {
            FetchWorkorderDetails(objs);
        }
        else if (staff == "" && staffval == "") {
            //bootbox.alert("Please fill all mandatory fields");
            FetchWorkorderDetails(objs);
        }
        else if (staff == "" && staffval != "") {
            bootbox.alert("Valid Assignee required");
        }
    });


    $("#btnSave, #btnEdit,#btnSaveandAddNew").click(function () {
        $('#btnlogin').attr('disabled', true);
        $('#myPleaseWait').modal('show');
        $('#RescheduleDetailsid').attr('required', true);
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
        var CurrentbtnID = $(this).attr("Id");
        var primaryId = $('#primaryID').val();

        var oldassignee = $('#HdnRescheduleAssigneId').val(),
            //GridIndexVal;

            //$('#rescheduleWOGrid tr').each(function (index,value) {
            //    var workOrder = $("#hdnWorkOrderReschedulingId_" + index).val();
            //    if (workOrder == 0)
            //        GridIndexVal = index;
            //});

            GridIndexVal;
        $('#rescheduleWOGrid tr').each(function () {
            GridIndexVal = $(this).index();
        });

        //var TrainingScheduleId = $('#primaryID').val();
        var plannerTyp = $('#RescheduleTypeofPlanner option:selected').val();
        var results = $('#RescheduleDetailsid option:selected').val();
        var details = $('#RescheduleDetails').val();

        var result = [];

        for (var i = 0; i <= GridIndexVal; i++) {
            var _EODCapFetchGrid = {
                WorkOrderReschedulingId: $('hdnReschGrid_' + i).val(),
                AssetId: $('#hdnAssetid_' + i).val(),
                WorkOrderId: $('#hdnWorkOrdid_' + i).val(),
                WorkOrderNo: $('#ReschWorkOrdNo_' + i).val(),
                RescheduleDate: $('#ReschRescheduleDate_' + i).val(),
                ReschschedDate_R: $('#ReschschedDate_' + i).val(),
                NewStaffMasterId: $('#hdnNewAssigneid_' + i).val(),
                Reason: details,
                IsDeleted: chkIsDeletedRow(i, $('#Isdeleted_' + i).is(":checked")),
            }
            if (_EODCapFetchGrid.NewStaffMasterId == "") {
                _EODCapFetchGrid.NewStaffMasterId = oldassignee;
            }

            var CompareReschDat = $('#ReschRescheduleDate_' + i).val(); //Date.parse($('#ReschRescheduleDate_' + i).val());
            var curdate = new Date();
            var curdateFormatd = DateFormatter(curdate);

            //if (CompareReschDat != "") {
            //    if (CompareReschDat < curdateFormatd) {
            //        $("div.errormsgcenter").text("Reschedule Date must be greater than or equal to current date");
            //        $('#errorMsg').css('visibility', 'visible');
            //        $('#myPleaseWait').modal('hide');
            //        return false;
            //    }
            //}


            result.push(_EODCapFetchGrid);
        }

        function chkIsDeletedRow(i, delrec) {
            if (delrec == true) {
                // $('#ReschRescheduleDate_' + i).prop("required", true);
                return true;
            }
            else {
                $('#ReschRescheduleDate_' + i).prop("required", false);
                return false;
            }
        }

        var obj = {
            RescheduleWOListData: result,
            //PlannerId: CatSystemId,
            //Reason: CategorySystem,
        }

        var isFormValid = formInputValidation("formBemsRescheduleWO", 'save');
        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            $('#btnSave').attr('disabled', false);
            //errorMsg("INVALID_INPUT_MESSAGE");
            return false;
        }

        var _index;
        $('#rescheduleWOGrid tr').each(function () {
            _index = $(this).index();
        });

        var ischked = 0;
        for (var i = 0; i <= _index; i++) {
            var curdate = new Date();
            var curdateFormatd = DateFormatter(curdate);
            curdateFormatd = Date.parse(curdateFormatd);
            var curdateFormatdTAR = new Date();
            curdateFormatdTAR = new Date(obj.RescheduleWOListData[i].ReschschedDate_R).getMonth();
            var curdateFormatdPre = new Date();
            curdateFormatdPre = new Date(obj.RescheduleWOListData[i].RescheduleDate).getMonth();
            var targetYear = new Date(obj.RescheduleWOListData[i].ReschschedDate_R).getFullYear();
            var RescheduleYear = new Date(obj.RescheduleWOListData[i].RescheduleDate).getFullYear();
            // curdateFormatdTAR = Date.parse(curdateFormatdTAR);
            //Date.parse($('#crmReqTarDat').val());
            if (obj.RescheduleWOListData[i].IsDeleted == 0) {
            }
            else {

                //if (curdateFormatdTAR != curdateFormatdPre || targetYear != RescheduleYear) {
                //    $("div.errormsgcenter").text("Reschedule Date must be with in the target Month of the Year");

                //    $('#errorMsg').css('visibility', 'visible');
                //    $('#myPleaseWait').modal('hide');
                //    return false;
                //}
            }
            if (obj.RescheduleWOListData[i].IsDeleted == true && obj.RescheduleWOListData[i].Reason == "") {

                $("div.errormsgcenter").text("Reason is mandatory for rescheduling a Work Order");
                $('#errorMsg').css('visibility', 'visible');
                $('#RescheduleDetailsid').parent().addClass('has-error');

                $('#myPleaseWait').modal('hide');
                $('#btnSave').attr('disabled', false);
                return false;
            }
            if (obj.RescheduleWOListData[i].RescheduleDate != "") {
                if (Date.parse(obj.RescheduleWOListData[i].RescheduleDate) < curdateFormatd) {
                    $("div.errormsgcenter").text("Reschedule Date must be greater than or equal to current date");
                    $('#ReschRescheduleDate_' + _index).
                        $('#errorMsg').css('visibility', 'visible');
                    $('#myPleaseWait').modal('hide');
                    return false;
                }
            }

            if (obj.RescheduleWOListData[i].IsDeleted == true && obj.RescheduleWOListData[i].RescheduleDate == "") {

                $("div.errormsgcenter").text("Reschedule Date is mandatory for rescheduling a Work Order");
                $('#errorMsg').css('visibility', 'visible');
                $('#ReschRescheduleDate_' + i).parent().addClass('has-error');

                $('#myPleaseWait').modal('hide');
                $('#btnSave').attr('disabled', false);
                return false;
            }


            if (obj.RescheduleWOListData[i].IsDeleted == true) {
                ischked += 1;

            }
        }
        //if (CompareReschDat != "") {
        //    if (CompareReschDat < curdateFormatd) {
        //        $("div.errormsgcenter").text("Reschedule Date must be greater than or equal to current date");
        //        $('#errorMsg').css('visibility', 'visible');
        //        $('#myPleaseWait').modal('hide');
        //        return false;
        //    }
        //}

        if (ischked == 0) {
            $('#myPleaseWait').modal('hide');
            $('#btnSave').attr('disabled', false);
            bootbox.alert("Please select atleast one Work Order to Reschedule");
            return false;
        }


        var stf = $('#HdnRescheduleNewAssigneId').val();
        var stnamef = $('#RescheduleNewAssignee').val();

        if (stnamef != "" && stf == "") {
            $("div.errormsgcenter").text("Valid New Assignee is Required.");
            $('#errorMsg').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            $('#btnSave').attr('disabled', false);
            //errorMsg("INVALID_INPUT_MESSAGE");
            return false;
        }

        //var TargetDate = new Date($("#TargetDate").val()),
        //NextScheduleDate = new Date($("#NextScheduleDate").val()),
        //RescheduleDate = new Date(rescheduleWO.RescheduleDate),
        //ConditionforReschedule = NextScheduleDate.setDate(NextScheduleDate.getDate() - 7);

        //if (RescheduleDate < TargetDate) {
        //    errorMsg("Reschedule Date must be greater than Target Date.");
        //    return false;
        //} else if (RescheduleDate > ConditionforReschedule) {
        //    errorMsg("Reschedule Date must be less than 1 week from Next Schedule Date");
        //    return false;
        //}




        var jqxhr = $.post("/api/rescheduleWO/Save", obj, function (response) {
            var result = JSON.parse(response);

            //GetSaveRescheduleResultBind(result)
            //$("#Timestamp").val(result.Timestamp);
            $("#grid").trigger('reloadGrid');
            $(".content").scrollTop(0);
            showMessage('Reschedule', CURD_MESSAGE_STATUS.SS);
            $("#top-notifications").modal('show');
            setTimeout(function () {
                $("#top-notifications").modal('hide');
            }, 5000);

            $('#btnSave').attr('disabled', false);
            $("#btnSave").prop('disabled', true);
            $("#btnSaveandAddNew").prop('disabled', true);
            $("#btnEdit").prop('disabled', true);

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
                $("div.errormsgcenter").text(errorMessage).css('visibility', 'visible');
                $('#errorMsg').css('visibility', 'visible');

                $('#btnSave').attr('disabled', false);
                $('#myPleaseWait').modal('hide');
            });
    });

    $("#chk_Reschdule").change(function () {
        var Isdeletebool = this.checked;

        if (this.checked) {
            $('#rescheduleWOGrid tr').map(function (i) {
                if ($("#Isdeleted_" + i).prop("disabled")) {
                    $("#Isdeleted_" + i).prop("checked", false);
                }
                else {
                    $("#Isdeleted_" + i).prop("checked", true);
                }
            });
        } else {
            $('#rescheduleWOGrid tr').map(function (i) {
                $("#Isdeleted_" + i).prop("checked", false);
            });
        }
    });

    //--------------- Fetch for Work Order -----------------
    var rescheduleWOFetchObj = {
        SearchColumn: 'WorkOrderNo-WorkOrderNo',//Id of Fetch field
        ResultColumns: ["WorkOrderId-Primary Key", 'WorkOrderNo-Work Order No'],//Columns to be displayed
        FieldsToBeFilled: ["hdnWorkOrderNo-WorkOrderId", "WorkOrderNo-WorkOrderNo", "WorkOrderDate-WorkOrderDate", "AssetNo-AssetNo",
            "AssetDescription-AssetDescription", "TypeofPlanner-TypeOfWorkOrderName", "Details-MaintenanceDetails", "TargetDate-TargetDate", "NextScheduleDate-NextScheduleDate"]//id of element - the model property
    };

    var apiUrlForFetch = "/api/Fetch/FetchRescheduleWOdetails";

    $('#WorkOrderNo').on('input propertychange paste keyup', function (event) {
        $('#divFetch').css({
            'width': $('#WorkOrderNo').outerWidth()
        });
        DisplayFetchResult('divFetch', rescheduleWOFetchObj, apiUrlForFetch, "UlFetch", event, 1);//1 -- pageIndex
    });

    //----------------------------------------

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
});

function errorMsg(errMsg) {
    $("div.errormsgcenter").text((!Messages[errMsg]) ? errMsg : Messages[errMsg]).css('visibility', 'visible');

    $('#btnlogin').attr('disabled', false);
    $('#myPleaseWait').modal('hide');
    // InvalidFn();
    return false;
}


function FetchWorkorderDetails(obj) {
    var jqxhr = $.post("/api/RescheduleWO/FetchWorkorder", obj, function (response) {
        var result = JSON.parse(response);

        $("#fetchgrid").css('visibility', 'visible');
        $('#fetchgrid').show();

        var RescheduleWOList = result.RescheduleWOListData;
        if (RescheduleWOList == null || RescheduleWOList == 0) {

            $("#rescheduletbl").hide();
            $("#rescheduleWOGrid").empty();
            $("div.errormsgcenter").text("No Work Order assigned for specified staff.");
            $('#errorMsg').css('visibility', 'visible');

            $('#btnlogin').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            // PushEmptyMessage();          
        }
        else {
            $('#divPagination').show();
            $("#btnSave").prop('disabled', false);
            $("#btnSaveandAddNew").prop('disabled', false);
            $('#rescheduletbl').css('visibility', 'visible');
            $('#rescheduletbl').show();
            $("#rescheduleWOGrid").empty();

            $('#RescheduleNewAssignee').prop('disabled', false);
            // $("#NewAssignee").html("New Assignee <span class='red'>*</span>");
            // $('#RescheduleNewAssignee').prop('required', true);
            $("#RescheduleDetails").prop('disabled', false);
            $("#RescheduleDetailsid").prop('disabled', false);

            $.each(result.RescheduleWOListData, function (index, value) {

                AddNewRowReschedule();
                $('#hdnReschGrid_' + index).val(result.RescheduleWOListData[index].WorkOrderReschedulingId);
                $("#ReschAssetNo_" + index).val(result.RescheduleWOListData[index].AssetNo).prop("disabled", "disabled");
                $("#hdnAssetid_" + index).val(result.RescheduleWOListData[index].AssetId).prop("disabled", "disabled");
                $("#ReschWorkOrdNo_" + index).val(result.RescheduleWOListData[index].WorkOrderNo).prop("disabled", "disabled");
                $("#hdnWorkOrdid_" + index).val(result.RescheduleWOListData[index].WorkOrderId).prop("disabled", "disabled");
                $("#ReschschedDate_" + index).val(DateFormatter(result.RescheduleWOListData[index].scheduleDate)).prop("disabled", "disabled");

                var newstaff = $("#RescheduleNewAssignee").val();
                var newstaffid = $("#HdnRescheduleNewAssigneId").val();
                $('#ReschNewAssigne_' + index).val(newstaff);
                $('#hdnNewAssigneid_' + index).val(newstaffid);

            });

            $('#divPagination').show();
            $('#divPagination').html(null);
            $('#divPagination').html(paginationString);
            RescheduleWOSetPaginationValues(result);

            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text("");
            $('#errorMsg').css('visibility', 'hidden');

        }

    })
        .fail(function () {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
        });
}

function PushEmptyMessage() {
    $("#rescheduleWOGrid").empty();
    var emptyrow = '<tr><td width="100%"><h5 class="text-center">No records to display</h5></td></tr>'
    $("#rescheduleWOGrid ").append(emptyrow);
}



function AddNewRow() {
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    var rowCount = $('#UserTrainingGrid tr:last').index();

    //if (rowCount < 0)
    //    AddNewRowUserTraining();
    //else if (rowCount >= "0" && (ParticiName == "" || UsrArea == "")) {
    //    bootbox.alert("Please enter values in existing row");
    //    //  $("div.errormsgcenter1").text();
    //    // $('#errorMsg1').css('visibility', 'visible');
    //}
    //else {
    //    AddNewRowUserTraining();
    //}
    AddNewRowReschedule();
}

var AssetNoFetchObj = {
    SearchColumn: 'txtAssetNo-AssetNo',//Id of Fetch field
    ResultColumns: ["AssetId-Primary Key", 'AssetNo-AssetNo'],
    AdditionalConditions: ["TypeOfPlanner-TypeOfPlanner", "Year-Year"],
    FieldsToBeFilled: ["hdnAssetId-AssetId", "txtAssetNo-AssetNo", "txtModel-Model", "txtManufacturer-Manufacturer",
        "txtSerialNumber-SerialNumber", "txtWarrentyEndDate-WarrentyEndDate", "txtSupplierName-SupplierName",
        "txtContractEndDate-ContractEndDate", "txtContractorName-ContractorName", "txtContactNumber-ContactNumber", 'WarrentyType-WarrentyType',
        'AssetClarification-AssetClarification', 'txtAssetTypeCode-TypeCode', 'hdnAssetTypeCodeId-TypeCodeID', 'txtTypeCodeDetails-TypeCodeDescription',
        'WorkOrderType-WorkOrderType', 'hdnStandardTaskDetId-TaskCodeId', 'txtTaskCode-TaskCode', 'PPMFrequencyValue-PPMFrequencyValue']
};

$('#txtAssetNo').on('input propertychange paste keyup', function (event) {
    AssetNoFetchObj.TypeCode = $('#hdnAssetTypeCodeId').val();
    DisplayFetchResult('divAssetNoFetch', AssetNoFetchObj, "/api/Fetch/ParentAssetNoFetch", "UlFetch5", event, 1);//1 -- pageIndex
});


function AddNewRowReschedule() {

    var inputpar = {
        inlineHTML: AddNewRowReschedulegHtml(),
        IdPlaceholderused: "maxindexval",
        TargetId: "#rescheduleWOGrid",
        TargetElement: ["tr"]
    }

    AddNewRowToDataGrid(inputpar);

    formInputValidation("formBemsRescheduleWO");
}

function AddNewRowReschedulegHtml() {

    return ' <tr class="ng-scope" style=""><td width="5%" data-original-title="" title=""><div class="checkbox text-center"> <label for="checkboxes-0"> <input type="checkbox" id="Isdeleted_maxindexval" autocomplete="off" class="ng-pristine ng-untouched ng-valid" onchange="IsDeleteCheckAll(rescheduleWOGrid, chk_Reschdule)"> </label></div> \
                        <input type="hidden" width="0%" id="hdnReschGrid_maxindexval"></td> \</td> \
                <td width="20%" style="text-align: center;" data-original-title="" title=""><div> <input id="ReschAssetNo_maxindexval" type="text" class="form-control" name="AssetNo" autocomplete="off"></div></td> \
                        <input type="hidden" width="0%" id="hdnAssetid_maxindexval"></td> \</td> \
                <td width="20%" style="text-align: center;" data-original-title="" title=""><div> <input id="ReschWorkOrdNo_maxindexval" type="text" class="form-control" name="WorkOrderNo" autocomplete="off"></div></td> \
                        <input type="hidden" width="0%" id="hdnWorkOrdid_maxindexval"></td> \</td> \
                <td width="15%" style="text-align: center;" data-original-title="" title=""><div> <input id="ReschschedDate_maxindexval" type="text" class="form-control fetchField datetimepicker" name="scheduleDate" autocomplete="off"></div></td> \
                <td width="15%" style="text-align: center;" data-original-title="" title=""><div> <input id="ReschRescheduleDate_maxindexval" type="text" class="form-control fetchField datetimeNoFuture" name="RescheduleDate" autocomplete="off" ></div></td> \
                <td width="25%" style="text-align: center;" data-original-title="" title=""><div> <input id="ReschNewAssigne_maxindexval" type="text" class="form-control" autocomplete="off" disabled></div> \
                        <input type="hidden" width="0%" id="hdnNewAssigneid_maxindexval"></td> \</td> \</td></tr>'
}



//--------------- Fetch for Reschedule Approved by -----------------
//function FetchStaffdata(event, index) {

//    var staffFetchObj = {
//        SearchColumn: 'RescheduleApprovedBy_' + index +'-StaffName',//Id of Fetch field
//        ResultColumns: ["StaffMasterId-Primary Key", 'StaffName-Staff Name', 'StaffEmployeeId-Staff Employee Id'],//Columns to be displayed
//        FieldsToBeFilled: ["hdnRescheduleApprovedById_" + index + "-StaffMasterId", "RescheduleApprovedBy_" + index + "-StaffName"]//id of element - the model property
//    };

//    DisplayFetchResult('divFetch_' + index, staffFetchObj, "/api/Fetch/FacilityStaffFetch", "UlFetch_" + index, event, 1);//1 -- pageIndex
//}

function FetchArea(event) {    // Commonly using CompanyStaffFetch

    $('#Areaetch').css({
        'width': $('#RescheduleAreaName').outerWidth()
    });

    var ItemMst = {
        SearchColumn: 'RescheduleAreaName' + '-UserAreaName',//Id of Fetch field
        ResultColumns: ["UserAreaId" + "-Primary Key", 'UserAreaName' + '-RescheduleAreaName'],//Columns to be displayed
        // AdditionalConditions: ["TrainingScheduleId-primaryID"],
        FieldsToBeFilled: ["HdnRescheduleAreaId" + "-UserAreaId", 'RescheduleAreaName' + '-UserAreaName']//id of element - the model property
    };
    DisplayFetchResult('Areaetch', ItemMst, "/api/Fetch/UserAreaFetch", "Ulfetch", event, 1);
}

function FetchLocation(event) {    // Commonly using CompanyStaffFetch

    var locanm = $('#RescheduleAreaName').val();
    var locid = $('#HdnRescheduleAreaId').val();

    if (locanm != "" && locid == "") {
        bootbox.alert("Valid Area Name required");
        return false;
    }

    $('#LocFetch').css({
        'width': $('#RescheduleLocationName').outerWidth()
    });

    var ItemMst = {
        SearchColumn: 'RescheduleLocationName' + '-UserLocationName',//Id of Fetch field
        ResultColumns: ["UserLocationId" + "-Primary Key", 'UserLocationName' + '-RescheduleLocationName'],//Columns to be displayed
        AdditionalConditions: ["UserAreaId-HdnRescheduleAreaId"],
        FieldsToBeFilled: ["HdnRescheduleLocId" + "-UserLocationId", 'RescheduleLocationName' + '-UserLocationName']//id of element - the model property
    };
    DisplayFetchResult('LocFetch', ItemMst, "/api/Fetch/LocationCodeFetch", "Ulfetch1", event, 1);
}

function FetchAssigne(event) {    // Commonly using CompanyStaffFetch

    $('#AssigneFetch').css({
        'width': $('#RescheduleAssignee').outerWidth()
    });
    var ItemMst = {
        SearchColumn: 'RescheduleAssignee' + '-StaffName',//Id of Fetch field
        ResultColumns: ["StaffMasterId" + "-Primary Key", 'StaffName' + '-RescheduleAssignee'],//Columns to be displayed
        // AdditionalConditions: ["TrainingScheduleId-primaryID"],
        FieldsToBeFilled: ["HdnRescheduleAssigneId" + "-StaffMasterId", 'RescheduleAssignee' + '-StaffName']//id of element - the model property
    };
    DisplayFetchResult('AssigneFetch', ItemMst, "/api/Fetch/CompanyStaffFetch", "Ulfetch2", event, 1);
}

function FetchNewAssignee(event) {    // Commonly using CompanyStaffFetch
    var _index;
    $('#UserTrainingGrid tr').each(function () {
        _index = $(this).index();
    });

    $('#NewAssigneFetch').css({
        'width': $('#RescheduleNewAssignee').outerWidth()
    });
    var ItemMst = {
        SearchColumn: 'RescheduleNewAssignee' + '-StaffName',//Id of Fetch field
        ResultColumns: ["StaffMasterId" + "-Primary Key", 'StaffName' + '-RescheduleNewAssignee'],//Columns to be displayed
        // AdditionalConditions: ["TrainingScheduleId-primaryID"],
        FieldsToBeFilled: ["HdnRescheduleNewAssigneId" + "-StaffMasterId", 'RescheduleNewAssignee' + '-StaffName']//id of element - the model property
    };

    DisplayFetchResult('NewAssigneFetch', ItemMst, "/api/Fetch/CompanyStaffFetch", "Ulfetch3", event, 1);
}

function LinkClicked(id) {
    $(".content").scrollTop(1);
    $('.nav-tabs a:first').tab('show');
    $("#formBemsRescheduleWO :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#divPagination').hide();
    $('#RescheduleNewAssignee').val('');
    $('#HdnRescheduleNewAssigneId').val('');
    $('#errorMsg').css('visibility', 'hidden');
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
        $("#formBemsRescheduleWO :input:not(:button)").prop("disabled", true);
    } else {
        $('#btnEdit').show();
        $('#btnSave').hide();
        $('#btnNextScreenSave').show();
    }
    $('#spnActionType').text(action);
    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/reschedulewo/get/" + primaryId)
            .done(function (result) {
                result = JSON.parse(result);

                GetSaveRescheduleResultBind(result)
                ///--Added for stopping after month target date entering
                var GridIndexVal;
                $('#rescheduleWOGrid tr').each(function () {
                    GridIndexVal = $(this).index();
                });
                for (var i = 0; i <= GridIndexVal; i++) {
                    var Reschdate = $('#ReschschedDate_' + i).val();

                    var curdateFormatdPre = new Date(Reschdate);
                    var cdate = new Date();
                    //  alert(curdateFormatdPre);
                    var rmonth = new Date(curdateFormatdPre).getMonth();
                    var ryear = new Date(curdateFormatdPre).getFullYear();
                    var cmonth = new Date(cdate).getMonth();
                    var cyear = new Date(cdate).getFullYear();
                    if (rmonth >= cmonth && ryear >= cyear) {

                    } else {
                        $('#ReschRescheduleDate_' + i).attr('disabled', true);
                    }



                }

                ///---------END

                $('#chk_Reschdule').prop('checked', false);
                $('#myPleaseWait').modal('hide');
            })
            .fail(function () {
                $('#myPleaseWait').modal('hide');
                $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
                $('#errorMsg').css('visibility', 'visible');
            });
    }
    else {
        $('#myPleaseWait').modal('hide');
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
            $.get("/api/reschedulewo/Delete/" + ID)
                .done(function (result) {
                    filterGrid();
                    $(".content").scrollTop(0);
                    showMessage('reschedulewo', CURD_MESSAGE_STATUS.DS);
                    $('#myPleaseWait').modal('hide');
                    EmptyFields();
                })
                .fail(function () {
                    showMessage('reschedulewo', CURD_MESSAGE_STATUS.DF);
                    $('#myPleaseWait').modal('hide');
                });
        }

    });
}

function EmptyFields() {
    $(".content").scrollTop(0);
    $('#btnDelete').hide();
    $('#spnActionType').text('Add');
    $('#btnEdit').hide();
    $('#btnSave').show();
    $('#primaryID').val('');
    $("#grid").trigger('reloadGrid');
    $("#formBemsRescheduleWO :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('input[type="text"]').val('');
    $('#WorkOrderNo').removeAttr("disabled");
    $('#rescheduleWOGrid').empty();
    $('#tablebody').empty();
    // $('#paginationfooter').hide();
    // AddNewRow();

    $('#rescheduletbl').css('visibility', 'hidden');
    $('#rescheduletbl').hide();
    $("#rescheduleWOGrid").empty();
    $('#RescheduleNewAssignee').prop('disabled', true);
    $("#NewAssignee").html("New Assignee");
    $('#RescheduleNewAssignee').prop('required', false);
    $("#RescheduleDetails").prop('disabled', true);
    $('#RescheduleFetchSave').show();

    $('#RescheduleAreaName').prop('disabled', false);
    $('#RescheduleLocationName').prop('disabled', false);
    $('#RescheduleAssignee').prop('disabled', false);
    $('#RescheduleTypeofPlanner').prop('disabled', false);
    $('#RescheduleDetails').val('');
    $('#RescheduleTypeofPlanner').val(0);
    $('#RescheduleDetailsid').val(0);
    $('#HdnRescheduleAssigneId').val('');

    $('#btnSave').prop('disabled', true);
    $('#btnSaveandAddNew').prop('disabled', true);
    $('#divPagination').hide();

}

function GetSaveRescheduleResultBind(result) {

    $("#fetchgrid").css('visibility', 'visible');
    $('#fetchgrid').show();

    $('#RescheduleFetchSave').hide();
    $("#RescheduleNewAssignee").prop('disabled', false);

    $("#btnSave").prop('disabled', false);
    $("#btnSaveandAddNew").prop('disabled', false);

    // $("#RescheduleNewAssignee").prop('required', true);
    // $("#NewAssignee").html("New Assignee <span class='red'>*</span>");

    $("#RescheduleAreaName").val(result.UserAreaName).prop("disabled", "disabled");
    $("#HdnRescheduleAreaId").val(result.UserAreaId).prop("disabled", "disabled");
    $("#RescheduleLocationName").val(result.UserLocationName).prop("disabled", "disabled");
    $("#HdnRescheduleLocId").val(result.UserLocationId);
    $("#RescheduleAssignee").val(result.StaffName).prop("disabled", "disabled");
    $("#HdnRescheduleAssigneId").val(result.StaffMasterId);
    //$("#RescheduleNewAssignee").val(getResult.UserAreaId);
    //$("#HdnRescheduleNewAssigneId").val(getResult.UserAreaCode).prop("disabled", "disabled");
    $('#RescheduleTypeofPlanner option[value="' + result.PlannerId + '"]').prop('selected', true);
    $("#RescheduleTypeofPlanner").prop("disabled", "disabled");
    $('#RescheduleDetailsid option[value="' + result.PlannerId + '"]').prop('selected', true);
    $("#RescheduleDetailsid").prop("disabled", "disabled");
    $("#RescheduleDetails").prop('disabled', false);
    $("#RescheduleDetailsid").prop('disabled', false);


    if (result && result.RescheduleWOListData && result.RescheduleWOListData.length) {
        $('#primaryID,#hdnWorkOrderNo').val(result.RescheduleWOListData[0].WorkOrderId);
        $('#WorkOrderNo').val(result.RescheduleWOListData[0].WorkOrderNo).prop("disabled", "disabled");
        $('#WorkOrderDate').val(DateFormatter(result.RescheduleWOListData[0].WorkOrderDate));
        $('#AssetNo').val(result.RescheduleWOListData[0].AssetNo);
        $('#AssetDescription').val(result.RescheduleWOListData[0].AssetDescription);
        $('#TypeofPlanner').val(result.RescheduleWOListData[0].TypeOfWorkOrderName);
        $('#Details').val(result.RescheduleWOListData[0].MaintenanceDetails);
        $('#TargetDate').val(DateFormatter(result.RescheduleWOListData[0].TargetDate));
        $('#NextScheduleDate').val(DateFormatter(result.RescheduleWOListData[0].NextScheduleDate));
    }
    ///--Added for stopping after month target date entering


    ///---------END
    $('#rescheduletbl').css('visibility', 'visible');
    $('#rescheduletbl').show();
    $("#rescheduleWOGrid").empty();
    $.each(result.RescheduleWOListData, function (index, value) {
        AddNewRow();
        $("#hdnReschGrid_" + index).val(result.WorkOrderReschedulingId);
        //$("#hdnAssetid_" + index).val(getResult.RescheduleWOListData[index].AssetId);
        $("#ReschAssetNo_" + index).val(result.RescheduleWOListData[index].AssetNo).prop("disabled", "disabled");
        $("#ReschWorkOrdNo_" + index).val(result.RescheduleWOListData[index].WorkOrderNo).prop("disabled", "disabled");
        $("#hdnWorkOrdid_" + index).val(result.RescheduleWOListData[index].WorkOrderId);
        $("#ReschschedDate_" + index).val(DateFormatter(result.RescheduleWOListData[index].scheduleDate)).prop("disabled", "disabled");
        // $("#ReschRescheduleDate_" + index).val(DateFormatter(result.RescheduleWOListData[index].RescheduleDate));
        // $("#ReschNewAssigne_" + index).val(value.NewStaffName).prop("disabled", "disabled");
        // $("#hdnNewAssigneid_" + index).val(value.NewStaffMasterId);
    });
}



//*************************************** Pagination *******************************************

function RescheduleWOSetPaginationValues(result) {
    var PageIndex = 0;
    var TotalRecords = 0;
    var FirstRecord = 0;
    var LastRecord = 0;
    var LastPageIndex = 0;

    var firstObject = $.grep(result.RescheduleWOListData, function (value0, index0) {
        return index0 == 0;
    });
    PageIndex = firstObject[0].PageIndex;
    PageSize = firstObject[0].PageSize;
    TotalRecords = firstObject[0].TotalRecords;
    FirstRecord = firstObject[0].FirstRecord;
    LastRecord = firstObject[0].LastRecord;
    LastPageIndex = firstObject[0].LastPageIndex;

    if (PageIndex == 1) {

        $('#btnPreviousPage').show();
        $('#btnPreviousPage').hide();
        $('#btnFirstPage').show();
        $('#btnFirstPage').hide();
    }
    else {

        $('#btnPreviousPage').hide();
        $('#btnPreviousPage').show();
        $('#btnFirstPage').hide();
        $('#btnFirstPage').show();
    }
    if (PageIndex == LastPageIndex) {

        $('#btnNextPage').show();
        $('#btnNextPage').hide();
        $('#btnLastPage').show();
        $('#btnLastPage').hide();
    }
    else {

        $('#btnNextPage').hide();
        $('#btnNextPage').show();
        $('#btnLastPage').hide();
        $('#btnLastPage').show();
    }

    $('#spnTotalRecords').text(TotalRecords);
    $('#spnFirstRecord').text(FirstRecord);
    $('#spnLastRecord').text(LastRecord);
    $('#spnTotalPages').text(LastPageIndex);
    $('#txtPageIndex').val(PageIndex);
    $('#hdnPageIndex').val(PageIndex);
    $('#selPageSize').val(PageSize);
    RescheduleWOAttachPaginationEvents(LastPageIndex);
}

function RescheduleWOAttachPaginationEvents(LastPageIndex) {
    //$('#btnPreviousPage').unbind("click");
    //$('#btnNextPage').unbind("click");
    //$('#btnFirstPage').unbind("click");
    //$('#btnLastPage').unbind("click");

    $('#btnPreviousPage, #btnNextPage, #btnFirstPage, #btnLastPage').click(function () {
        var id = $(this).attr('id');

        var currentPageIndex = parseInt($('#hdnPageIndex').val());
        if (id == "btnPreviousPage") {
            currentPageIndex -= 1;
        }
        else if (id == "btnNextPage") {
            currentPageIndex += 1;
        }
        else if (id == "btnFirstPage") {
            currentPageIndex = 1;
        }
        else if (id == "btnLastPage") {
            currentPageIndex = LastPageIndex;
        }
        RescheduleWOPopulatePopupData(currentPageIndex);
    });

    $('#txtPageIndex').on("keypress", function (e) {
        if (e.keyCode == 13) {
            var pageindex1 = $('#txtPageIndex').val();
            if (pageindex1 == null || pageindex1 == '' || isNaN(pageindex1)) {
                bootbox.alert('Please enter valid page number.');
                $('#txtPageIndex').val($('#hdnPageIndex').val());
                return false;
            } else {
                pageindex1 = parseInt(pageindex1);
                if (pageindex1 > LastPageIndex) {
                    bootbox.alert('Please enter valid page number.');
                    $('#txtPageIndex').val($('#hdnPageIndex').val());
                    return false;
                } else {
                    RescheduleWOPopulatePopupData(pageindex1);
                }
            }
        }
    });

    $('#selPageSize').on('change', function () {
        RescheduleWOPopulatePopupData(1);
    });
}

function RescheduleWOPopulatePopupData(pageIndex) {

    var areaid = $('#HdnRescheduleAreaId').val();
    var locationid = $('#HdnRescheduleLocId').val();
    var staffid = $('#HdnRescheduleAssigneId').val();
    var planner = $('#RescheduleTypeofPlanner').val();
    var results = $("#RescheduleDetailsid").val();


    if (areaid == "") {
        var areaid = null;
    }
    if (locationid == "") {
        var locationid = null;
    }

    var objs = {
        UserAreaId: areaid,
        UserLocationId: locationid,
        StaffMasterId: staffid,
        PlannerId: planner,

        PageSize: $('#selPageSize').val(),
        PageIndex: pageIndex

    }

    var staff = $('#HdnRescheduleAssigneId').val();
    if (staff != "") {
        FetchWorkorderDetails(objs);
    }
    else {
        bootbox.alert("Please fill all mandatory fields");
    }
}

