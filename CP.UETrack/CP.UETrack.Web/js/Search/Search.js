
function DisplaySeachPopup(divSearch, popupObject, apiUrl) {
    
    var popupForm = '<form class="form-horizontal-popup" name="frmearchPopup" id="frmearchPopup" novalidate autocomplete="off">'
        + '<div class="modal-dialog modal-lg">'
            + '<div class="modal-content">'
                + '<div class="modal-header">'
                    + '<button type="button" class="close" id="btnClose">&times;</button>'
                    + '<h4 class="modal-title"><b id="h4Title"></b></h4>'
                + '</div>'
                + '<div class="modal-body">'
                    + '<div class="container-fluid" style="padding-left: 0px;">'
                        + '<div class="content-area">'
                            + '<div class="new-row new-row-tablet new-row-mobile twelve-columns twelve-columns-tablet">'
                               + '<div id="SeachFields">'
                               + '</div>'
                                + '<div ng-view class="row">'
                                    + '<div class="col-sm-12" style="margin-left:15px">'
                                        + '<div class="table-responsive  popupTableFixedHeight" id="divSearchPopupTable">'
                                            + '</div>'
                                        + '</div>'
                                    + '</div>'
                                + '</div>'
                                + '<div class="row">'
                                    + '<div class="col-sm-12" style="color:red; visibility:hidden" id="divErrorMsgPopup">'
                                        + '<div class="errorMsgCenterPopup">'
                                        + '</div>'
                                    + '</div>'
                                + '</div>'
                                + '<div class="row"><div class="col-sm-4">&nbsp;</div>'
                                + '<div class="col-sm-4 text-center"><button type="button" id="btnClose1" class="btn btn-primary customButton"><i class="fa fa-times" aria-hidden="true"></i>Close</button></div>'
                                + '<div class="col-sm-4 text-right" id="divPopupPagination" style="visibility:hidden">'
                                + 'Showing <span class="records-start" id="spnSearchFirstRecord"></span>&nbsp;to&nbsp;'
                                + '<span class="records-end" id="spnSearchLastRecord">'
                                + '</span>&nbsp;records of&nbsp;'
                                + '<span class="total-records" id="spnSearchTotaltRecords"></span>&nbsp;&nbsp;'
                                + '<input type="hidden" id="hdnSearchPageIndex" value="1"/>'
                                + '<input type="button" class="prev-Page" value="<" id="btnSearchPrevPage"/>&nbsp;'
                                + '<input type="button" class="next-Page" value=">" id="btnSearchNextPage"/>'
                                + '</div>'
                                + '</div></div></div></div></div></div></form>';
    $('#' + divSearch).html(null);
    $('#' + divSearch).html(popupForm);

    $('#btnClose, #btnClose1').click(function () {
        $('#' + divSearch).html(null);
        $('#' + divSearch).modal('hide');
    });

    $('#btnSearchPrevPage, #btnSearchNextPage').click(function () {
        var id = $(this).attr('id');
        var currentPageIndex = parseInt($('#hdnSearchPageIndex').val());
        if (id == "btnSearchPrevPage") {
            if (currentPageIndex != 1) {
                currentPageIndex -= 1;
            }
            else {
                return false;
            }
        }
        else if (id == "btnSearchNextPage") {
                currentPageIndex += 1;
        }
        PopulatePopupData(popupObject, currentPageIndex, apiUrl);
    });
  
            $('#h4Title').text(popupObject.Heading);
    var searchFields = '';


    var TypeOfServices = $("#selServices").val();
    //var searchObj = {};
    if (TypeOfServices != null) {
        searchFields['TypeOfServices'] = TypeOfServices;
    } else {
        TypeOfServices = $("#TypeOfServiceRequest").val();
        searchFields['TypeOfServices'] = TypeOfServices;
    }

            $.each(popupObject.SearchColumns, function (index, value) {
                searchFields += '<div class="row">'
                                + '<div class="col-xs-6 col-sm-3">'
                                + '<label class="pull-right">' + value.split('-')[1] + '</label>'
                                + '</div>'
                                + '<div class="col-xs-6 col-sm-3">'
                                + '<div class="form-group">'
                                + '<input type="text" class="form-control" id="' + value.split('-')[0] + '" name="' + value.split('-')[0] + '" />'
                                + '</div> </div></div>';
            });
            searchFields += '<div class="row"><div class="col-xs-6"><button type="button" id="btnSearchResult" style="visibility:hidden">&nbsp;</button></div><div class="col-xs-6 text-right">'
                + '<button type="button" id="btnPopupApply" class="btn btn-primary">Apply</button></div></div><br/>';
            $('#divSearchPopupTable').html(null);
            $('#divSearchPopupTable').html(searchFields);
            var tableString = '<table id="dataTableSearchPopup456" class="table table-bordered">'
                               + '<thead class="tableHeading">'
                               + '<tr>';
            $.each(popupObject.ResultColumns, function (index, value) {
                if (value.split('-')[1] == "Primary Key") {
                    tableString += '<th style="display:none">' + value.split('-')[1] + '</th>'
                }
                else {
                    tableString += '<th>' + value.split('-')[1] + '</th>'
                }

            });
            tableString += '</tr></thead><tbody></tbody></table>';
            $('#divSearchPopupTable').append(tableString);

            $('#' + divSearch).modal('show');

        $('#btnPopupApply').click(function () {
            PopulatePopupData(popupObject, 1, apiUrl);
        });
        PopulatePopupData(popupObject, 1, apiUrl);
}

function PopulatePopupData(popupObject, pageIndex, apiUrl) {
    $('#divErrorMsgPopup').css('visibility', 'hidden');
    var TypeOfServices= $("#selServices").val();
    var searchObj = {};
    if (TypeOfServices != null) {
        searchObj['TypeOfServices'] = TypeOfServices;
    } else {
        TypeOfServices = $("#TypeOfServiceRequest").val();
        searchObj['TypeOfServices'] = TypeOfServices;
    }
   
    $.each(popupObject.SearchColumns, function (index0, value0) {
        searchObj[value0.split('-')[0]] = $('#' + value0.split('-')[0]).val();
    });
    searchObj['PageIndex'] = pageIndex;

    if (popupObject.AdditionalConditions != undefined && popupObject.AdditionalConditions != null) {
        $.each(popupObject.AdditionalConditions, function (index4, value4) {
            searchObj[value4.split('-')[0]] = $('#' + value4.split('-')[1]).val();
        });
    }

    if (popupObject.ScreenName != undefined && popupObject.ScreenName != null) {
        searchObj['SceenName'] = popupObject.ScreenName;
    }

    var jqxhr = $.post(apiUrl, searchObj, function (response) {
        var result = JSON.parse(response);
        var primaryKeyName;

        var TotalRecords = 0;
        var FirstRecord = 0;
        var LastRecord = 0;
        var LastPageIndex = 0;
        var TypeOfServices = searchObj.TypeOfServices;
        var firstObject = $.grep(result, function (value0, index0) {
            return index0 == 0;
        });
        TotalRecords = firstObject[0].TotalRecords;
        FirstRecord = firstObject[0].FirstRecord;
        LastRecord = firstObject[0].LastRecord;
        LastPageIndex = firstObject[0].LastPageIndex;

        if (pageIndex == 1) {
            $('#btnSearchPrevPage').attr('disabled', true);
        }
        else {
            $('#btnSearchPrevPage').attr('disabled', false);
    }
        if (pageIndex == LastPageIndex) {
            $('#btnSearchNextPage').attr('disabled', true);
        }
        else {
            $('#btnSearchNextPage').attr('disabled', false);
    }

        $('#spnSearchTotaltRecords').text(TotalRecords);
        $('#spnSearchFirstRecord').text(FirstRecord);
        $('#spnSearchLastRecord').text(LastRecord);
        $('#hdnSearchPageIndex').val(pageIndex);
        $('#divPopupPagination').css('visibility', 'visible');

        var tableString = "";
        $.each(result, function (index, value) {
            tableString += '<tr>';
            $.each(popupObject.ResultColumns, function (index1, value1) {
                if (value1.split('-')[1] == "Primary Key") {
                    tableString += '<td style="display:none">' + value[value1.split('-')[0]] + '</td>';
                    primaryKeyName = value1.split('-')[0];
                }
                else {
                    if (value1.split('-')[0].indexOf("Date") != -1) {
                        tableString += '<td>' + DateFormatter( value[value1.split('-')[0]]) + '</td>';
                    }
                    else {
                        tableString += '<td>' + value[value1.split('-')[0]] + '</td>';
                    }            }
            });
            tableString += '</tr>';
        });
        $('#dataTableSearchPopup456 > tbody').empty();
        $('#dataTableSearchPopup456 > tbody').append(tableString);

        $('#dataTableSearchPopup456 tr').hover(function () {
            $(this).addClass('SearchPopupHover');
        }, function () {
            $(this).removeClass('SearchPopupHover');
        });

        $('#dataTableSearchPopup456 td').click(function () {
            var primaryKey = $(this).siblings(":first").text();
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
                    $('#' + idValue).attr('title', returnObject[resultValue]);
                    $('#' + idValue).parent().removeClass('has-error');
                }
            });
            $('#btnClose').click();
        });
    },
   "json")
    .fail(function (response) {
        $('#dataTableSearchPopup456 > tbody').empty();
        var colspan = popupObject.ResultColumns.length;
        $('#dataTableSearchPopup456 > tbody').append('<tr><td class="text-center" colspan="' + colspan + '">No Records To Display</tr>');
        $('#divPopupPagination').css('visibility', 'hidden');
    });
}