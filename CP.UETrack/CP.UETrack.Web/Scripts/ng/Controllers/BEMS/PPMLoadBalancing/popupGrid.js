var divSearch1 = '';
var popupObject1 = null;
var apiUrl1 = '';

function DisplayEditablePopup(divSearch, popupObject, apiUrl) {
    divSearch1 = divSearch;
    popupObject1 = popupObject;
    apiUrl1 = apiUrl;

    var popupForm = '<form class="form-horizontal-popup" name="frmLoadBalancingPopup" id="frmLoadBalancingPopup" novalidate>'
        + '<div class="modal-dialog modal-lg">'
            + '<div class="modal-content" style="width:1000px">'
                + '<div class="modal-header">'
                    + '<button type="button" class="close" id="btnClosePopup">&times;</button>'
                    + '<h4 class="modal-title" id="h4TitleLoadBalancing"></h4>'
                + '</div>'
                + '<div class="modal-body">'
                    + '<div class="container-fluid" style="padding-left: 0px;">'
                        + '<div class="content-area">'
                            + '<div class="new-row new-row-tablet new-row-mobile twelve-columns twelve-columns-tablet">'
                               //+ '<div id="SeachFields">'
                               //+ '</div>'
                                + '<div ng-view class="row">'
                                    + '<div class="col-sm-12" style="margin-left:15px">'
                                        + '<div class="table-responsive  popupTableFixedHeight" id="divLoadBalancingPopupTable">'
                                            + '</div>'
                                        + '</div>'
                                    + '</div>'
                                + '</div>'
                                + '<div class="row">'
                                    + '<div class="col-sm-12" style="color:red; visibility:hidden" id="divErrorMsgLoadBalancing">'
                                        + '<div class="errormsgcenter" style="margin-top:0px; margin-bottom:10px;">'
                                        + '</div>'
                                    + '</div>'
                                + '</div>'
                                + '<div class="row"><div class="col-sm-4">&nbsp;</div>'
                                + '<div class="col-sm-4 text-center"><button type="button" id="btnSaveWorkOrder" class="btn btn-primary">Save</button></div>'
                                + '<div class="col-sm-4 text-right" id="divLoadBalancingPagination" style="visibility:hidden">'
                                + 'Showing <span class="records-start" id="spnLoadBalancingFirstRecord"></span>&nbsp;to&nbsp;'
                                + '<span class="records-end" id="spnLoadBalancingLastRecord">'
                                + '</span>&nbsp;records of&nbsp;'
                                + '<span class="total-records" id="spnLoadBalancingTotaltRecords"></span>&nbsp;&nbsp;'
                                + '<input type="hidden" id="hdnLoadBalancingPageIndex" value="1"/>'
                                + '<input type="button" class="prev-Page" value="<" id="btnLoadBalancingPrevPage"/>&nbsp;'
                                + '<input type="button" class="next-Page" value=">" id="btnLoadBalancingNextPage"/>'
                                + '</div>'
                                + '</div></div></div></div></div></div>'

                                +'<div class="modal fade bs-example-modal-sm alertBox" id="top-notificationsPopup" tabindex="-1"'
                                +'role="dialog" aria-hidden="true" data-backdrop="false" hidden>'
                                +'<div class="modal-dialog modal-sm">'
                                +'<div class="modal-content">'
                                +'<button type="button" class="close" data-dismiss="modal">&times;</button>'
                                +'<div class="notify mt20">'
                                +'<span class="icon"><i id="msgPopup"></i></span>'
                                +'<h4 id="hdrPopup"></h4>'
                                +'<p id="data1"></p>'
                                +'</div>'
                                +'</div>'
                                +'</div>'
                                + '</div>'

                                +'</form>';
    $('#' + divSearch).html(null);
    $('#' + divSearch).html(popupForm);

    $('#btnClosePopup').click(function () {
        $('#' + divSearch).html(null);
        $('#' + divSearch).modal('hide');
    });

    $('#btnSaveWorkOrder').click(function () {
        SaveWorkOrderDetals();
    });

    $('#btnLoadBalancingPrevPage, #btnLoadBalancingNextPage').click(function () {
        var id = $(this).attr('id');
        var currentPageIndex = parseInt($('#hdnLoadBalancingPageIndex').val());
        if (id == "btnLoadBalancingPrevPage") {
            if (currentPageIndex != 1) {
                currentPageIndex -= 1;
            }
            else {
                return false;
            }
        }
        else if (id == "btnLoadBalancingNextPage") {
                currentPageIndex += 1;
        }
        PopulatePopupDataLoadBalancing(popupObject, currentPageIndex, apiUrl);
    });

            $('#h4TitleLoadBalancing').text(popupObject.Heading);
          
            var tableString = '<table id="dataTableLoadBalancing" class="table table-bordered">'
                               + '<thead class="tableHeading">'
                               + '<tr>';
            $.each(popupObject.ResultColumns, function (index, value) {
                var specialCaseField = value.split('-')[1];
                if (specialCaseField == "Primary Key" || specialCaseField == "Timestamp") {
                    tableString += '<th style="display:none">' + value.split('-')[1] + '</th>'
                }
                else {
                    var thWidth;
                    var columnName = value.split('-')[0];
                    switch (columnName)
                    {
                        case "MaintenanceWorkNo": thWidth = 11; break;
                        case "AssetNo": thWidth = 11; break;
                        case "AssetDescription": thWidth = 11; break;
                        case "TargetDateTime": thWidth = 11; break;
                        case "Assignee": thWidth = 15; break;
                        case "WorkOrderStatusValue": tdWidth = 11; break;
                    }
                    tableString += '<th style="width:'+thWidth+'%">' + value.split('-')[1] + '</th>'
                }
            });
            tableString += '<th style="widht:15%">Proposed Date</th>';
            tableString += '<th style="widht:15%">New Assignee</th>';
            tableString += '</tr></thead><tbody></tbody></table>';
            $('#divLoadBalancingPopupTable').append(tableString);

            $('#' + divSearch).modal('show');

        PopulatePopupDataLoadBalancing(popupObject, 1, apiUrl);
}

BindFetchEventsForAssignee = function () {
    $("input[id^='txtNewAssignee_']").unbind('input propertychange paste keyup');
    $("input[id^='txtNewAssignee_']").on('input propertychange paste keyup', function (event) {
        var index = $(this).attr('id').split('_')[1];
        if (index > 0) {
            if ($('#divNewAssigneeFetch_' + index + ' .not-found').length && index == 0) {
                $('#divNewAssigneeFetch_' + index).css({
                    'top': 0,
                    'width': $('#txtNewAssignee_' + index).outerWidth()
                });
            } else {
                $('#divNewAssigneeFetch_' + index).css({
                    'top': $('#txtNewAssignee_' + index).offset().top - $('#dataTableLoadBalancing').offset().top +$('#txtNewAssignee_' +index).innerHeight(),
                    'width': $('#txtNewAssignee_' + index).outerWidth()
                });
            }
        }
        else {
            $('#divNewAssigneeFetch_' + index).css({
                'width': $('#txtNewAssignee_' + index).outerWidth()
            });
        }

        var personFetchObj = {
            SearchColumn: 'txtNewAssignee_' + index + '-StaffName',
            ResultColumns: ['StaffMasterId-Primary Key', 'StaffName-Staff Name'],
            FieldsToBeFilled: ['hdnNewAssigneeId_' +index + '-StaffMasterId', 'txtNewAssignee_' +index + '-StaffName']
        };
        //var responsibilityId1 = $('#selResponsibilityId_' + index).val();
        //if (responsibilityId1 == 333) {
            DisplayFetchResult('divNewAssigneeFetch_' + index, personFetchObj, "/api/Fetch/CompanyStaffFetch", "UlNewAssigneeFetch_" + index + "", event, 1);
        //} else if (responsibilityId1 == 334) {
        //    DisplayFetchResult('divNewAssigneeFetch_' + index, personFetchObj, "/api/Fetch/FacilityStaffFetch", "UlPersonFetch_" + index + "", event, 1);
        //}
    });
}

function SaveWorkOrderDetals() {
     $("div.errormsgcenter").text(null);
     $('#divErrorMsgLoadBalancing').css('visibility', 'hidden');

    var pPMLoadBalancingWorkOrders = { };

    var saveObj = [];
    var assingneeInvalid = false;

    $('#divLoadBalancingPopupTable tr').each(function (index, value) {
        var targetDateTime = $('#txtProposedDate' + index.toString()).val();
        var newAssigneeId = $('#hdnNewAssigneeId_' + index.toString()).val();
        var assigneeName = $('#txtNewAssignee_' + index.toString()).val();

        if ((newAssigneeId == null || newAssigneeId == '') && assigneeName != null && assigneeName != '') {
            assingneeInvalid = true;
        }

        if ((targetDateTime != null && targetDateTime != '') || (newAssigneeId != null && newAssigneeId != '')) {
                var innerObj = {
                    WorkOrderId: $('#tdWorkOrderId' + index.toString()).text(),
                    TargetDateTime: $('#txtProposedDate' + index.toString()).val(),
                    NewAssigneeId: $('#hdnNewAssigneeId_' + index.toString()).val(),
                    Timestamp: $('#tdTimestamp' + index.toString()).text()
                }
                saveObj.push(innerObj);
        }
    });
  
    if (assingneeInvalid) {
        $("div.errormsgcenter").text("Please enter valid New Assignee");
        $('#divErrorMsgLoadBalancing').css('visibility', 'visible');
        return false;
    }

    if (saveObj.length == 0)
    {
        $("div.errormsgcenter").text("No records to save as Agreed Date/Assignee not changed for any of the records");
        $('#divErrorMsgLoadBalancing').css('visibility', 'visible');
        return false;
    }
    $('#myPleaseWait').modal('show');
    pPMLoadBalancingWorkOrders.WorkOrders = saveObj;

    $('#btnSaveWorkOrder').attr('disabled', true);
    var jqxhr = $.post("/api/pPMLoadBalancing/Save", pPMLoadBalancingWorkOrders, function (response) {
        var result = JSON.parse(response);
        //showMessage('PPM Load Balancing', CURD_MESSAGE_STATUS.SS);

        $("#top-notificationsPopup").modal('show');
        $('#msgPopup').addClass("fa fa-check");
        $('#hdrPopup').html("Data saved successfully");
        setTimeout(function () {
            $("#top-notificationsPopup").modal('hide');
        }, 5000);
        $("#btnAddFetch").click();
        PopulatePopupDataLoadBalancing(popupObject1, 1, apiUrl1);

        $('#btnSaveWorkOrder').attr('disabled', false);
        $('#myPleaseWait').modal('hide');
    },
    "json")
     .fail(function (response) {
         var errorMessage = "";
         if (response.status == 400) {
            errorMessage = response.responseJSON;
         }
        else {
            errorMessage = Messages.COMMON_FAILURE_MESSAGE;
         }
         $("div.errormsgcenter").text(errorMessage);
         $('#divErrorMsgLoadBalancing').css('visibility', 'visible');

         $('#btnSaveWorkOrder').attr('disabled', false);
         $('#myPleaseWait').modal('hide');
     });
}

function PopulatePopupDataLoadBalancing(popupObject, pageIndex, apiUrl) {
    $('#divErrorMsgLoadBalancing').css('visibility', 'hidden');
   
    var searchObj = {
        Year: $('#selYear').val(),
        AssetClassificationId: $('#hdnAssetClassificationId').val(),
        StaffMasterId: $('#hdnStaffMasterId').val(),
        UserAreaId: $('#hdnUserAreaId').val(),
        UserLocationId: $('#hdnUserLocationId').val(),
        Month: popupObject.Month,
        Week: popupObject.Week,
        PageIndex: pageIndex
    };
   
    $('#myPleaseWait').modal('show');
    var jqxhr = $.post(apiUrl, searchObj, function (response) {
        var result = JSON.parse(response);
        var primaryKeyName;

        var allCompleted = true;
        $.each(result, function (index, value) {
            if (value.WorkOrderStatus == 192 || value.WorkOrderStatus == 193) {
                allCompleted = false;
            }
        });
        if (allCompleted) {
            $('#btnSaveWorkOrder').hide();
        } else {
            $('#btnSaveWorkOrder').show();
        }

        var TotalRecords = 0;
        var FirstRecord = 0;
        var LastRecord = 0;
        var LastPageIndex = 0;

        var firstObject = $.grep(result, function (value0, index0) {
            return index0 == 0;
        });
        TotalRecords = firstObject[0].TotalRecords;
        FirstRecord = firstObject[0].FirstRecord;
        LastRecord = firstObject[0].LastRecord;
        LastPageIndex = firstObject[0].LastPageIndex;

        if (pageIndex == 1) {
            $('#btnLoadBalancingPrevPage').attr('disabled', true);
        }
        else {
            $('#btnLoadBalancingPrevPage').attr('disabled', false);
        }
        if (pageIndex == LastPageIndex) {
            $('#btnLoadBalancingNextPage').attr('disabled', true);
        }
        else {
            $('#btnLoadBalancingNextPage').attr('disabled', false);
        }

        $('#spnLoadBalancingTotaltRecords').text(TotalRecords);
        $('#spnLoadBalancingFirstRecord').text(FirstRecord);
        $('#spnLoadBalancingLastRecord').text(LastRecord);
        $('#hdnLoadBalancingPageIndex').val(pageIndex);
        $('#divLoadBalancingPagination').css('visibility', 'visible');

        var tableString = "";
        $.each(result, function (index, value) {
            var workOrderStatus = value.WorkOrderStatus;
            tableString += '<tr>';
            $.each(popupObject.ResultColumns, function (index1, value1) {
                var specialCaseField = value1.split('-')[1];
                if (specialCaseField == "Primary Key" || specialCaseField == "Timestamp") {
                    var idString = '';
                    if (specialCaseField == "Primary Key") idString = 'id="tdWorkOrderId' + index + '"';
                    if (specialCaseField == "Timestamp") idString = 'id="tdTimestamp' + index + '"';
                    tableString += '<td '+idString+' style="display:none">' + value[value1.split('-')[0]] + '</td>';
                    primaryKeyName = value1.split('-')[0];
                }
                else {
                    var tdWidth;
                    var columnName = value1.split('-')[0];
                    switch (columnName) {
                        case "MaintenanceWorkNo": tdWidth = 11; break;
                        case "AssetNo": tdWidth = 11; break;
                        case "AssetDescription": tdWidth = 11; break;
                        case "TargetDateTime": tdWidth = 11; break;
                        case "Assignee": thWidth = 15; break;
                        case "WorkOrderStatusValue": tdWidth = 11; break;
                    }
                    if (columnName == 'TargetDateTime') {
                        tableString += '<td style="width:' + tdWidth + '%">' + moment(value[value1.split('-')[0]]).format("DD-MMM-YYYY") + '</td>';
                    }
                    else {
                        tableString += '<td style="width:' + tdWidth + '%">' + value[value1.split('-')[0]] + '</td>';
                    }
                }
            });
            if (workOrderStatus == 192 || workOrderStatus == 193) {
                tableString += '<td id="tdProposedDate' + index + '" style="width:15%"><input type="text" id="txtProposedDate' + index + '" class="form-control datatimeFuture" maxlength="11" /></td>';
                tableString += '<td id="tdNewAssignee_' + index + '" style="width:15%"><input type="text" id="txtNewAssignee_' + index + '" class="form-control" placeholder="Please Select" maxlength="75" />' 
                               + '<input type="hidden" id="hdnNewAssigneeId_' +index + '" /><div class="col-sm-12" id="divNewAssigneeFetch_' +index + '"></div>' 
                               + '</td>';
            }
            else {
                tableString += '<td id="tdProposedDate' + index + '" style="width:15%"><input type="text" id="txtProposedDate' + index + '" class="form-control" maxlength="11" disabled /></td>';
                tableString += '<td id="tdNewAssignee' + index + '" style="width:15%"><input type="text" id="txtNewAssignee_' + index + '" class="form-control" disabled/></td>';
            }
            tableString += '</tr>';
        });
        $('#dataTableLoadBalancing > tbody').empty();
        $('#dataTableLoadBalancing > tbody').append(tableString);

        BindFetchEventsForAssignee();

         $('.datatimeFuture').datetimepicker({
             minDate: Date(),
                 format : 'd-M-Y',
                 timepicker: false,
             step: 15,
             scrollInput: false
         });


        $('#dataTableLoadBalancing td a').click(function () {
            var primaryKey = $(this).parent().siblings(":first").text();
            var obj = $.grep(result, function (value2, index2) {
                return value2[primaryKeyName].toString() == primaryKey;
            });
            var returnObject = obj[0];
            $.each(popupObject.FieldsToBeFilled, function (index3, value3) {
                var idValue = value3.split('-')[0];
                var resultValue = value3.split('-')[1];
                if (idValue.indexOf("hdn") == 0) {
                    $('#' + idValue).val(returnObject[resultValue]).trigger('change');
                }
                else if (idValue.indexOf("Date") != -1) {
                    $('#' + idValue).val(DateFormatter(returnObject[resultValue]));
                }
                else {
                    $('#' + idValue).val(returnObject[resultValue]);
                    $('#' + idValue).parent().removeClass('has-error');
                }
            });
            $('#btnClosePopup').click();
        });
        $('#myPleaseWait').modal('hide');
    },
   "json")
    .fail(function (response) {
        $('#myPleaseWait').modal('hide');
        $('#dataTableLoadBalancing > tbody').empty();
        var colspan = popupObject.ResultColumns.length;
        $('#dataTableLoadBalancing > tbody').append('<tr><td class="text-center" colspan="' + colspan + '">No Records To Display</tr>');
    });
}