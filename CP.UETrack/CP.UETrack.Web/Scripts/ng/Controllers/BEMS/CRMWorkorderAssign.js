
//var pageindex = 1, pagesize = 5;
//var TotalPages = 1;

var pageindex = 1, pagesize = 5;
var GridtotalRecords = 0;
var TotalPages = 0, FirstRecord = 0, LastRecord = 0;

$(document).ready(function () {
    $('#btnDelete').hide();
    $('#btnEdit').hide();
    $('#fetchgrid').hide();

    $('#myPleaseWait').modal('show');

    $.get("/api/CRMWorkorderAssign/Load")
    .done(function (result) {
        var loadResult = JSON.parse(result);
        $("#jQGridCollapse1").click();
        //window.ReasonLoadData = loadResult.ReasonData

        $.each(loadResult.TypeofRequestLov, function (index, value) {
            if (value.LovId == 134 || value.LovId == 136 || value.LovId == 137 || value.LovId == 138) {
                $('#CrmworkOrdAssReqTyp').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            }            
        });

        $('#CrmworkOrdAssFetchSave').show();
        AddNewRow();
        //$("#RescAddNew").show();
        $("#btnSave").prop('disabled', true);
        $("#btnSaveandAddNew").prop('disabled', true);


        $("#NewAssigneFetch").on('click', function () {
            var newstaffid = $("#HdnCrmworkOrdAssAssigneId").val();
            var newstaff = $("#CrmworkOrdAss").val();

            if (newstaffid > 0) {
                var _index;
                $('#crmWrkOrdAsstblGrid tr').each(function () {
                    _index = $(this).index();
                    $('#CRMWrkOrdNewAssigne_' + _index).val(newstaff);
                    $('#hdnNewAssigneid_' + _index).val(newstaffid);
                });
            }

        });

        $("#CrmworkOrdAssReqTyp").on('change', function () {
            $('#crmWrkOrdAsstbl').css('visibility', 'hidden');
           // $('#crmWrkOrdAsstbl').hide();
            $("#crmWrkOrdAsstblGrid").empty();
            $('#divPagination').hide();

            $("#crmWrkOrdAsstblGrid").empty();
            $('#CrmworkOrdAss').prop('disabled', true);
            $("#NewAssignee").html("Assignee");
            $('#CrmworkOrdAss').prop('required', true);
            $("#CrmworkOrdAssFetchSave").show();
        });







        //formInputValidation("formBemsRescheduleWO");

        //var primaryId = $('#primaryID').val();
        //if (primaryId != null && primaryId != "0") {
        //    //getById(primaryId)
        //    $.get("/api/reschedulewo/get/" + primaryId)
        //    .done(function (result) {
        //        result = JSON.parse(result);

        //        GetWorkorderDetailsBind(result)

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




    $('#CrmworkOrdAssFetchSave').click(function () {

        var ReqTyp = $('#CrmworkOrdAssReqTyp').val();

        var objs = {
            TypeOfRequestId: ReqTyp

            //PageIndex: pageindex,
            //PageSize: pagesize
        }

        if (ReqTyp > 0) {
            FetchWorkorderDetails(objs);
        }
        else {
            bootbox.alert("Please select  Request Type");
        }
    });




    $("#btnSave, #btnEdit,#btnSaveandAddNew").click(function () {
        $('#btnlogin').attr('disabled', true);
        $('#myPleaseWait').modal('show');

        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
        var CurrentbtnID = $(this).attr("Id");
        var primaryId = $('#primaryID').val(),
        //GridIndexVal;

        //$('#rescheduleWOGrid tr').each(function (index,value) {
        //    var workOrder = $("#hdnWorkOrderReschedulingId_" + index).val();
        //    if (workOrder == 0)
        //        GridIndexVal = index;
        //});

         GridIndexVal;
        $('#crmWrkOrdAsstblGrid tr').each(function () {
            GridIndexVal = $(this).index();
        });

        //var TrainingScheduleId = $('#primaryID').val();
        var reqTyp = $('#CrmworkOrdAssReqTyp').val();

        var result = [];

        for (var i = 0; i <= GridIndexVal; i++) {
            var _EODCapFetchGrid = {
                CRMRequestWOId: $('#hdnWorkOrdId_' + i).val(),
                StaffId: $('#hdnNewAssigneid_' + i).val(),               
                IsDeleted: chkIsDeletedRow(i, $('#Isdeleted_' + i).is(":checked")),
            }

            result.push(_EODCapFetchGrid);
        }

        function chkIsDeletedRow(i, delrec) {
            if (delrec == true) {
                $('#CRMWrkOrdDate_' + i).prop("required", false);
                return true;
            }
            else {
                return false;
            }
        }

        var obj = {
            CRMWorkorderAssignGridData: result
        }

        var isFormValid = formInputValidation("formCrmWrkOrdAss", 'save');
        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            $('#btnSave').attr('disabled', false);
            //errorMsg("INVALID_INPUT_MESSAGE");
            return false;
        }

        var stf = $('#HdnCrmworkOrdAssAssigneId').val();
        if (stf == "") {
            $("div.errormsgcenter").text("Valid New Assign is Required.");
            $('#errorMsg').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            $('#btnSave').attr('disabled', false);
            return false;
        }


        var jqxhr = $.post("/api/CRMWorkorderAssign/Save", obj, function (response) {
            var result = JSON.parse(response);

            //GetWorkorderDetailsBind(result)
            //$("#Timestamp").val(result.Timestamp);
            $("#grid").trigger('reloadGrid');
            $(".content").scrollTop(0);
            showMessage('CRMWorkorderAssign', CURD_MESSAGE_STATUS.SS);
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
            $("div.errormsgcenter").text(errorMessage).css('visibility', 'visible');
            $('#errorMsg').css('visibility', 'visible');

            $('#btnSave').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
        });
    });

    $("#chk_crmWrkOrdAss").change(function () {
        var Isdeletebool = this.checked;

        if (this.checked) {
            $('#crmWrkOrdAsstblGrid tr').map(function (i) {
                if ($("#Isdeleted_" + i).prop("disabled")) {
                    $("#Isdeleted_" + i).prop("checked", false);
                }
                else {
                    $("#Isdeleted_" + i).prop("checked", true);
                }
            });
        } else {
            $('#crmWrkOrdAsstblGrid tr').map(function (i) {
                $("#Isdeleted_" + i).prop("checked", false);
            });
        }
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
    var jqxhr = $.post("/api/CRMWorkorderAssign/FetchWorkorder", obj, function (response) {
        var result = JSON.parse(response);

        //$("#fetchgrid").css('visibility', 'visible');
        //$('#fetchgrid').show();


        if (result.CRMWorkorderAssignGridData.length > 0) {
            $("#btnSave").prop('disabled', false);
            $("#btnSaveandAddNew").prop('disabled', false);
            $("#fetchgrid").css('visibility', 'visible');
            $('#fetchgrid').show();
            $('#crmWrkOrdAsstbl').show();
            $('#crmWrkOrdAsstbl').css('visibility', 'visible');         
            $("#crmWrkOrdAsstblGrid").empty();
            $('#CrmworkOrdAss').prop('disabled', false);
            $("#NewAssignee").html("New Assignee <span class='red'>*</span>");
            $('#CrmworkOrdAss').prop('required', true);
            $('#CrmworkOrdAssReqTyp').prop('disabled', true);

            $.each(result.CRMWorkorderAssignGridData, function (index, value) {

                AddNewRowWorAssign();
                $("#hdnWorkOrdId_" + index).val(result.CRMWorkorderAssignGridData[index].CRMRequestWOId).prop("disabled", "disabled");
                $("#CRMWrkOrdNo_" + index).val(result.CRMWorkorderAssignGridData[index].CRMRequestWONo).prop("disabled", "disabled");
                $("#CRMWrkOrdDate_" + index).val(moment(result.CRMWorkorderAssignGridData[index].CRMWorkOrderDateTime).format("DD-MMM-YYYY HH:mm")).prop("disabled", "disabled");
                var newstaff = $("#CrmworkOrdAss").val();
                var newstaffid = $("#HdnCrmworkOrdAssAssigneId").val();
                $('#CRMWrkOrdNewAssigne_' + index).val(newstaff);
                $('#hdnNewAssigneid_' + index).val(newstaffid);

            });



            //$('#divPagination').html(null);
            //$('#divPagination').html(paginationString);
            //SetPaginationValues(result);

            //if ((result.RescheduleWOListData && result.RescheduleWOListData.length) > 0) {
            //    //ParameterMappingId = getResult.ParameterMappingId;
            //    GridtotalRecords = result.RescheduleWOListData[0].TotalRecords;
            //    TotalPages = result.RescheduleWOListData[0].TotalPages;
            //    LastRecord = result.RescheduleWOListData[0].LastRecord;
            //    FirstRecord = result.RescheduleWOListData[0].FirstRecord;
            //    pageindex = result.RescheduleWOListData[0].PageIndex;
            //}

            //var mapIdproperty = ["IsDeleted-Isdeleted_", "WorkOrderReschedulingId-hdnReschGrid_", "AssetNo-ReschAssetNo_", "AssetId-hdnAssetid_", "WorkOrderNo-ReschWorkOrdNo_", "WorkOrderId-hdnWorkOrdid_", "scheduleDate-ReschschedDate_", "RescheduleDate-ReschRescheduleDate_", "NewStaffName-ReschNewAssigne_", "NewStaffMasterId-hdnNewAssigneid_"];
            //var htmltext = AddNewRowReschedulegHtml();//Inline Html
            //var obj = { formId: "#formBemsRescheduleWO", IsView: ($('#ActionType').val() == "VIEW"), PageNumber: pageindex, flag: "RescheduleWorkorder", mapIdproperty: mapIdproperty, htmltext: htmltext, GridtotalRecords: GridtotalRecords, ListName: "RescheduleWOListData", tableid: '#rescheduleWOGrid', destionId: "#paginationfooter", TotalPages: TotalPages, FirstRecord: FirstRecord, LastRecord: LastRecord, geturl: "/api/RescheduleWO/FetchWorkorder/" + result };

            //CreateFooterPagination(obj)

            $('#myPleaseWait').modal('hide');
            //$("div.errormsgcenter").css('dispaly', 'none');
            //$('#errorMsg').hide();

            $("div.errormsgcenter").text("");
            $('#errorMsg').css('visibility', 'hidden');


            //PushEmptyMessage();



            //var ind;
            //$('#rescheduleWOGrid tr').each(function () {
            //    ind = $(this).index();
            //});

            //for (var i = 0; i <= ind; i++) {

            //    $('#ReschRescheduleDate_' + i).focusout(function () {
            //        var chkresdat = $('#ReschRescheduleDate_' + i).val();
            //        if (chkresdat != "") {
            //            $('#RescheduleNewAssignee').prop("required", false);
            //            $("#NewAssignee").html("New Assignee");
            //        }
            //        else if (chkresdat == "") {

            //            $('#RescheduleNewAssignee').prop("required", true);
            //            $("#NewAssignee").html("New Assignee <span class='red'>*</span>");
            //        }

            //    });
            //}


            $('#CrmworkOrdAssFetchSave').hide();
        }
        else {

            $("#fetchgrid").css('visibility', 'visible');
            $('#fetchgrid').show();
            $('#CrmworkOrdAssFetchSave').show();

            $("#crmWrkOrdAsstbl").hide();
            $("#crmWrkOrdAsstblGrid").empty();
            $("div.errormsgcenter").text("No Unassigned Work Order for specified Request Type");
            $('#errorMsg').css('visibility', 'visible');

            $('#btnlogin').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            // PushEmptyMessage();
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

function SetPaginationValues(result) {
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
        $('#btnPreviousPage').removeClass('pagerEnabled');
        $('#btnPreviousPage').addClass('pagerDisabled');
        $('#btnFirstPage').removeClass('pagerEnabled');
        $('#btnFirstPage').addClass('pagerDisabled');
    }
    else {
        $('#btnPreviousPage').removeClass('pagerDisabled');
        $('#btnPreviousPage').addClass('pagerEnabled');
        $('#btnFirstPage').removeClass('pagerDisabled');
        $('#btnFirstPage').addClass('pagerEnabled');
    }
    if (PageIndex == LastPageIndex) {
        $('#btnNextPage').removeClass('pagerEnabled');
        $('#btnNextPage').addClass('pagerDisabled');
        $('#btnLastPage').removeClass('pagerEnabled');
        $('#btnLastPage').addClass('pagerDisabled');
    }
    else {
        $('#btnNextPage').removeClass('pagerDisabled');
        $('#btnNextPage').addClass('pagerEnabled');
        $('#btnLastPage').removeClass('pagerDisabled');
        $('#btnLastPage').addClass('pagerEnabled');
    }

    $('#spnTotalRecords').text(TotalRecords);
    $('#spnFirstRecord').text(FirstRecord);
    $('#spnLastRecord').text(LastRecord);
    $('#txtPageIndex').val(PageIndex);
    $('#hdnPageIndex').val(PageIndex);
    $('#selPageSize').val(PageSize);
    AttachPaginationEvents(LastPageIndex);
}

function AttachPaginationEvents(LastPageIndex) {
    $('#btnPreviousPage').unbind("click");
    $('#btnNextPage').unbind("click");
    $('#btnFirstPage').unbind("click");
    $('#btnLastPage').unbind("click");

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
        // PopulatePopupData(currentPageIndex);
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
                    //  PopulatePopupData(pageindex1);
                }
            }
        }
    });

    $('#selPageSize').on('change', function () {
        //    PopulatePopupData(1);
    });
}


function AddNewRow() {
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    var rowCount = $('#UserTrainingGrid tr:last').index();

    AddNewRowWorAssign();
}

function AddNewRowWorAssign() {

    var inputpar = {
        inlineHTML: AddNewRowWorAssigngHtml(),
        IdPlaceholderused: "maxindexval",
        TargetId: "#crmWrkOrdAsstblGrid",
        TargetElement: ["tr"]
    }

    AddNewRowToDataGrid(inputpar);

    formInputValidation("formBemsRescheduleWO");
}

function AddNewRowWorAssigngHtml() {

    return ' <tr class="ng-scope" style=""><td width="5%" data-original-title="" title=""><div class="checkbox text-center"> <label for="checkboxes-0"> <input type="checkbox" id="Isdeleted_maxindexval" autocomplete="off" class="ng-pristine ng-untouched ng-valid" onchange="IsDeleteCheckAll(crmWrkOrdAsstblGrid, chk_crmWrkOrdAss)"> </label></div> \
                        <input type="hidden" width="0%" id="hdnWorkOrdId_maxindexval"></td> \
                <td width="35%" style="text-align: center;" data-original-title="" title=""><div> <input id="CRMWrkOrdNo_maxindexval" type="text" class="form-control"  autocomplete="off"></div></td> \
                <td width="30%" style="text-align: center;" data-original-title="" title=""><div> <input id="CRMWrkOrdDate_maxindexval" type="text" class="form-control"  autocomplete="off"></div></td> \
                <td width="30%" style="text-align: center;" data-original-title="" title=""><div> <input id="CRMWrkOrdNewAssigne_maxindexval" type="text" class="form-control" autocomplete="off" disabled></div> \
                        <input type="hidden" width="0%" id="hdnNewAssigneid_maxindexval"></td> \</td> \</td></tr>'
}




function FetchNewAssignee(event) {
    var ItemMst = {
        SearchColumn: 'CrmworkOrdAss' + '-StaffName',//Id of Fetch field
        ResultColumns: ["StaffId" + "-Primary Key", 'StaffName' + '-CrmworkOrdAss'],//Columns to be displayed
        AdditionalConditions: ["TypeOfRequest-CrmworkOrdAssReqTyp"],
        FieldsToBeFilled: ["HdnCrmworkOrdAssAssigneId" + "-StaffId", 'CrmworkOrdAss' + '-StaffName']//id of element - the model property
    };
    // DisplayFetchResult('StaffFetch', ItemMst, "/api/Fetch/CompanyStaffFetch", "Ulfetch3", event, 1);
    DisplayFetchResult('NewAssigneFetch', ItemMst, "/api/Fetch/CRMWorkorderStaffFetch", "Ulfetch1", event, 1);

}



function LinkClicked(id) {
    $(".content").scrollTop(1);
    $('.nav-tabs a:first').tab('show');
    $("#formCrmWrkOrdAss :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    var action = "";
    $('#primaryID').val(id);
    var hasEditPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Edit'");
    var hasViewPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='View'");
    var hasDeletePermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Delete'");

    if (hasEditPermission ) {
        action = "Edit"

    }
    else if (!hasEditPermission) {
        action = "View"
    }
    if (action == "Edit" && hasDeletePermission) {
       // $('#btnDelete').show();
    }

    if (action == 'View') {
        $("#formCrmWrkOrdAss :input:not(:button)").prop("disabled", true);
    } else {
        $('#btnEdit').show();
        $('#btnSave').hide();
        $('#btnNextScreenSave').show();
    }
    $('#spnActionType').text(action);
    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/CRMWorkorderAssign/get/" + primaryId)
        .done(function (result) {
            result = JSON.parse(result);

            GetWorkorderDetailsBind(result)

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
    $("#formCrmWrkOrdAss :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('input[type="text"]').val('');
    $('#WorkOrderNo').removeAttr("disabled");
  //  $('#crmWrkOrdAsstblGrid').empty();
   // $('#crmWrkOrdAsstbl').empty();
    // $('#paginationfooter').hide();
    // AddNewRow();

    $('#crmWrkOrdAsstbl').css('visibility', 'hidden');
   // $('#crmWrkOrdAsstbl').hide();
   // $("#crmWrkOrdAsstblGrid").empty();

    $('#CrmworkOrdAss').val('');
    $('#HdnCrmworkOrdAssAssigneId').val('');
    $('#CrmworkOrdAssReqTyp').val(0).prop('disabled', false);
    $('#CrmworkOrdAss').prop('disabled', true);   
    $('#CrmworkOrdAss').prop('required', false);
    $('#CrmworkOrdAssFetchSave').show();
    $("#NewAssignee").html("Assignee");
    $("#fetchgrid").css('visibility', 'hidden');
    $('#fetchgrid').hide();
    $('#CrmworkOrdAssReqTyp').prop('disabled', false);
    $("#btnSave").prop('disabled', true);
    $("#btnSaveandAddNew").prop('disabled', true);
}

function GetWorkorderDetailsBind(result) {
    $("#chk_crmWrkOrdAss").prop("checked",false)
    $("#fetchgrid").css('visibility', 'visible');
    $('#fetchgrid').show();

    $('#CrmworkOrdAssFetchSave').hide();
    $("#CrmworkOrdAss").prop('disabled', false);

    $("#btnSave").prop('disabled', false);
    $("#btnSaveandAddNew").prop('disabled', false);

    $("#CrmworkOrdAss").prop('required', true);
    $("#NewAssignee").html("Assignee <span class='red'>*</span>");

    $('#CrmworkOrdAssReqTyp option[value="' + result.TypeOfRequestId + '"]').prop('selected', true);
    $("#CrmworkOrdAssReqTyp").prop("disabled", "disabled");
    $('#CrmworkOrdAss').val('');
    $('#HdnCrmworkOrdAssAssigneId').val('');



    $('#crmWrkOrdAsstbl').css('visibility', 'visible');
    $('#crmWrkOrdAsstbl').show();
    $("#crmWrkOrdAsstblGrid").empty();
    $.each(result.CRMWorkorderAssignGridData, function (index, value) {
        AddNewRowWorAssign();
        $("#hdnWorkOrdId_" + index).val(result.CRMWorkorderAssignGridData[index].CRMRequestWOId);
        $("#CRMWrkOrdNo_" + index).val(result.CRMWorkorderAssignGridData[index].CRMRequestWONo).prop("disabled", "disabled");
        $("#CRMWrkOrdDate_" + index).val(moment(result.CRMWorkorderAssignGridData[index].CRMWorkOrderDateTime).format("DD-MMM-YYYY HH:mm")).prop('disabled',true);

       // $("#RequestDateTime").val(moment(getResult.RequestDateTime).format("DD-MMM-YYYY HH:mm"));
       // $('#RequestDateTime').prop("disabled", true);
    });
}