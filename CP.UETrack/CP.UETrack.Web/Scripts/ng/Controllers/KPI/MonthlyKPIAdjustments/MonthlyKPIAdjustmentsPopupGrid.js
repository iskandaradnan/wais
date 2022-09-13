var divSearch1 = '';
var popupObject1 = null;
var apiUrl1 = '';
var indicatorNo1 = '';
var isDemeritPoint1 = false;
var isPostDemeritPoint1 = false;
var KPIExportType = '';

function DisplayEditablePopup(divSearch, popupObject, apiUrl, indicatorNo, isDemeritPoint, isPostDemeritPoint) {
    divSearch1 = divSearch;
    popupObject1 = popupObject;
    apiUrl1 = apiUrl;
    indicatorNo1 = indicatorNo;
    isDemeritPoint1 = isDemeritPoint;
    isPostDemeritPoint1 = isPostDemeritPoint;
    if (isDemeritPoint) KPIExportType = 'Demerit';
    if (isPostDemeritPoint) {
        $('#btnKPIExport').hide();
        KPIExportType = '';
    }
    //if (isPostDemeritPoint) KPIExportType = 'PostDemerit';

    var popupForm = '<form class="form-horizontal-popup" name="frmKPIGenerationPopup" id="frmKPIGenerationPopup" novalidate>'
        + '<div class="modal-dialog modal-lg">'
            + '<div class="modal-content">'
                + '<div class="modal-header">'
                    + '<button type="button" class="close" id="btnClosePopup">&times;</button>'
                    + '<h4 class="modal-title" id="h4TitleKPIGeneration"></h4>'
                + '</div>'
                + '<div class="modal-body">'
                    + '<div class="container-fluid" style="padding-left: 0px;">'
                        + '<div class="content-area">'
                            + '<div class="new-row new-row-tablet new-row-mobile twelve-columns twelve-columns-tablet">'
                                + '<div ng-view class="row">'
                                    + '<div class="col-sm-12" style="margin-left:15px">'
                                        + '<div class="table-responsive  popupTableFixedHeight" id="divKPIGenerationPopupTable">'
                                            + '</div>'
                                        + '</div>'
                                    + '</div>'
                                + '</div>'
                                + '<div class="row">'
                                    + '<div class="col-sm-12" style="color:red; visibility:hidden" id="divErrorMsgKPIGeneration">'
                                        + '<div class="errormsgcenter" style="margin-top:0px; margin-bottom:10px;">'
                                        + '</div>'
                                    + '</div>'
                                + '</div>'
                                + '<div class="row"><div class="col-sm-4">&nbsp;</div>'
                                + '<div class="col-sm-4 text-center"><button type="button" id="btnKPIExport" class="btn btn-primary customButton"><i class="fa fa-file-excel-o" aria-hidden="true"></i>Export</button>'
                                + '<button type="button" class="btn btn-primary customButton" id="btnCancel">Close</button>'
                                +'</div>'
                                + '<div class="col-sm-4 text-right" id="divKPIGenerationPagination" style="visibility:hidden">'
                                + 'Showing <span class="records-start" id="spnKPIGenerationFirstRecord"></span>&nbsp;to&nbsp;'
                                + '<span class="records-end" id="spnKPIGenerationLastRecord">'
                                + '</span>&nbsp;records of&nbsp;'
                                + '<span class="total-records" id="spnKPIGenerationTotaltRecords"></span>&nbsp;&nbsp;'
                                + '<input type="hidden" id="hdnKPIGenerationPageIndex" value="1"/>'
                                + '<input type="button" class="prev-Page" value="<" id="btnKPIGenerationPrevPage"/>&nbsp;'
                                + '<input type="button" class="next-Page" value=">" id="btnKPIGenerationNextPage"/>'
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

    if(isPostDemeritPoint1) {
        $('#btnKPIExport').hide();
    }


    $('#btnClosePopup, #btnCancel').click(function () {
        $('#' + divSearch).html(null);
        $('#' + divSearch).modal('hide');
    });

    $('#btnKPIExport').click(function () {
        SaveWorkOrderDetals();
    });

    $('#btnKPIGenerationPrevPage, #btnKPIGenerationNextPage').click(function () {
        var id = $(this).attr('id');
        var currentPageIndex = parseInt($('#hdnKPIGenerationPageIndex').val());
        if (id == "btnKPIGenerationPrevPage") {
            if (currentPageIndex != 1) {
                currentPageIndex -= 1;
            }
            else {
                return false;
            }
        }
        else if (id == "btnKPIGenerationNextPage") {
                currentPageIndex += 1;
        }
        PopulatePopupDataKPIGeneration(popupObject, currentPageIndex, apiUrl);
    });

            $('#h4TitleKPIGeneration').text(popupObject.Heading);
            
            var tableString = '<table id="dataTableKPIGeneration" class="table table-bordered">'
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
                    if (isDemeritPoint) {
                        switch (columnName) {
                            case "SerialNo": thWidth = 5; break;
                            case "ServiceWorkNo": thWidth = 7.5; break;
                            case "AssetNo": thWidth = 7.5; break;
                            case "AssetDescription": thWidth = 10; break;

                            case "AssetTypeCode": thWidth = 7.5; break;
                            case "UnderWarranty": thWidth = 7.5; break;
                            case "ResponseDateTime": thWidth = 7.5; break;
                            case "RepsonseDurationHrs": thWidth = 5; break;

                            case "StartDateTime": thWidth = 7.5; break;
                            case "EndDateTime": thWidth = 7.5; break;
                            case "WorkOrderStatus": thWidth = 7.5; break;
                            case "DowntimeHrs": thWidth = 10; break;
                            case "DemeritPoint": thWidth = 10; break;
                        }
                    }
                    else if (isPostDemeritPoint) {
                        switch (columnName) {
                            case "DocumentNo": thWidth = 50; break;
                            case "FinalDemeritPoint": thWidth = 50; break;
                        }
                    }
                       tableString += '<th style="width:' +thWidth + '%">' +value.split('-')[1]+ '</th>'
                }
            });
            
            tableString += '</tr></thead><tbody></tbody></table>';
            $('#divKPIGenerationPopupTable').append(tableString);

            $('#' + divSearch).modal('show');

        PopulatePopupDataKPIGeneration(popupObject, 1, apiUrl);
}

function SaveWorkOrderDetals() {
        var exportType = "Excel";
        var sortOrder = "asc";
        var screenTitle = $("#menu").find("li.active:last").text();

        var $downloadForm = $("<form method='POST'>")
          .attr("action", "/api/common/Export")
           .append($("<input name='filters' type='text'>").val(""))
           .append($("<input name='sortOrder' type='text'>").val(""))
            .append($("<input name='sortColumnName' type='text'>").val(""))
           .append($("<input name='screenName' type='text'>").val("Monthly_KPI_Adjustments"))
           .append($("<input name='exportType' type='text'>").val(exportType))
           .append($("<input name='Year' type='text'>").val($('#selYear').val()))
           .append($("<input name='Month' type='text'>").val($('#selMonth').val()))
           .append($("<input name='ServiceId' type='text'>").val($('#selService').val()))
           .append($("<input name='IndicatorNo' type='text'>").val(indicatorNo1))
           .append($("<input name='KPIExportType' type='text'>").val(KPIExportType))
           .append($("<input name='spName' type='text'>").val(""))

        $("body").append($downloadForm);
        var status = $downloadForm.submit();
        $downloadForm.remove();
}

function PopulatePopupDataKPIGeneration(popupObject, pageIndex, apiUrl) {
    $('#divErrorMsgKPIGeneration').css('visibility', 'hidden');
   
    var searchObj = {
        Year: popupObject.Year,
        Month: popupObject.Month,
        ServiceId: popupObject.ServiceId,
        IndicatorNo: popupObject.IndicatorNo,
        PageIndex: pageIndex
    };
   
    $('#myPleaseWait').modal('show');
    var jqxhr = $.post(apiUrl, searchObj, function (response) {
        var result = JSON.parse(response);
        var primaryKeyName;

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
            $('#btnKPIGenerationPrevPage').attr('disabled', true);
        }
        else {
            $('#btnKPIGenerationPrevPage').attr('disabled', false);
        }
        if (pageIndex == LastPageIndex) {
            $('#btnKPIGenerationNextPage').attr('disabled', true);
        }
        else {
            $('#btnKPIGenerationNextPage').attr('disabled', false);
        }

        $('#spnKPIGenerationTotaltRecords').text(TotalRecords);
        $('#spnKPIGenerationFirstRecord').text(FirstRecord);
        $('#spnKPIGenerationLastRecord').text(LastRecord);
        $('#hdnKPIGenerationPageIndex').val(pageIndex);
        $('#divKPIGenerationPagination').css('visibility', 'visible');

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
                    var textAlign = 'text-align:left;';
                    if (isDemeritPoint1) {
                        switch (columnName) {
                            case "SerialNo": tdWidth = 5; break;
                            case "ServiceWorkNo": tdWidth = 7.5; break;
                            case "AssetNo": tdWidth = 7.5; break;
                            case "AssetDescription": tdWidth = 10; break;

                            case "AssetTypeCode": tdWidth = 7.5; break;
                            case "UnderWarranty": tdWidth = 7.5; break;
                            case "ResponseDateTime": tdWidth = 7.5; break;
                            case "RepsonseDurationHrs": tdWidth = 5; break;

                            case "StartDateTime": tdWidth = 7.5; break;
                            case "EndDateTime": tdWidth = 7.5; break;
                            case "WorkOrderStatus": tdWidth = 7.5; break;
                            case "DowntimeHrs": tdWidth = 10; break;
                            case "DemeritPoint": tdWidth = 10; break;
                        }
                    } else if (isPostDemeritPoint1) {
                        switch (columnName) {
                            case "DocumentNo": tdWidth = 50; break;
                            case "FinalDemeritPoint": tdWidth = 50; break;
                    }
                    }
                    if (columnName == 'SerialNo')
                    {
                        textAlign = 'text-align:center;';
                    }
                    if (columnName == 'DowntimeHrs' || columnName == 'PurchaseCostRM' || columnName == 'DemeritValue1' || columnName == 'DemeritPoint'
                        || columnName == 'DeductionValue' || columnName == 'FinalDemeritPoint')
                    {
                        textAlign = 'text-align:right;';
                    }

                    if (columnName == 'ResponseDateTime' || columnName == 'StartDateTime' || columnName == 'EndDateTime') {
                        var dateTimeString = value[value1.split('-')[0]] == null ? '' : moment(value[value1.split('-')[0]]).format("DD-MMM-YYYY HH:mm");
                        tableString += '<td style="width:' + tdWidth + '%;' + textAlign + '">' + dateTimeString + '</td>';

                    }
                    else if (columnName == 'RequiredDateTime' || columnName == 'TCCompletedDate' || columnName == 'TCDate') {
                            var dateString = value[value1.split('-')[0]] == null ? '' : moment(value[value1.split('-')[0]]).format("DD-MMM-YYYY");
                            tableString += '<td style="width:' + tdWidth + '%;' + textAlign + '">' + dateString + '</td>';
                        }
                    else {
                        var result = value[value1.split('-')[0]] == null ? '' : value[value1.split('-')[0]];
                        tableString += '<td style="width:' + tdWidth + '%;' + textAlign + '">' + result + '</td>';
                    }
                    
                }
            });
           
            tableString += '</tr>';
        });
        $('#dataTableKPIGeneration > tbody').empty();
        $('#dataTableKPIGeneration > tbody').append(tableString);

         $('.datatimeFuture').datetimepicker({
             minDate: Date(),
                 format : 'd-M-Y',
                 timepicker: false,
             step: 15,
             scrollInput: false
         });


        $('#dataTableKPIGeneration td a').click(function () {
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
        $('#dataTableKPIGeneration > tbody').empty();
        var colspan = popupObject.ResultColumns.length;
        $('#dataTableKPIGeneration > tbody').append('<tr><td class="text-center" colspan="' + colspan + '">No Records To Display</tr>');
    });
}