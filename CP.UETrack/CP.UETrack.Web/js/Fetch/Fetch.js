
function DisplayFetchResult(divFetch, fetchObject, apiUrl, UlFetch, event, pageIndex) {
    
    var divId = divFetch;
    var keyCode = 0;
    var TypeOfServices = 0;
    var hdnUserAreaId = 0;
    if (pageIndex < 100000) {

    } else {
        TypeOfServices = pageIndex - 100000;
        pageIndex = pageIndex - TypeOfServices;
        pageIndex = pageIndex / 100000;
    }
    TypeOfServices = $('#selServices').val();

    
    if (event != null) {
        keyCode = event.keyCode;
    }
    var key = $('#' + fetchObject.SearchColumn.split('-')[0]).val();

    var noRecordString = ' <ul class="dropdown-menu pull-right list-group col-sm-12 UlFetch" id="' + UlFetch + '">'
                     + '<li>'
                     + '<center> <b> <span class="records-start not-found">No Match Found</span></b></center>'
                     + '</li>'
                     + '</ul>';

    var conditionOk = false;
    if (keyCode == 40 || (keyCode == undefined && key.length > 0)) {
        conditionOk = true;
    }
    if (!conditionOk) {
        if (key.length == 0) {
            $.each(fetchObject.FieldsToBeFilled, function (index3, value3) {
                var idValue = value3.split('-')[0];
                var resultValue = value3.split('-')[1];
                if (idValue != fetchObject.SearchColumn.split('-')[0]) {
                    if (idValue.indexOf('sel') == 0) {
                        $('#' + idValue).val("null");
                    }
                    else if (idValue.indexOf('hdn') == 0) {
                        $('#' + idValue).val(null).trigger('change');
                    }
                    else {
                        $('#' + idValue).attr('title', '');
                        $('#' + idValue).val(null);
                    }
                }
            });
        }
        return false;
    }
    else {
        if (keyCode == undefined) {
            $.each(fetchObject.FieldsToBeFilled, function (index3, value3) {
                var idValue = value3.split('-')[0];
                var resultValue = value3.split('-')[1];
                if (idValue != fetchObject.SearchColumn.split('-')[0]) {
                    if (idValue.indexOf('sel') == 0) {
                        $('#' + idValue).val("null");
                    }
                    else if (idValue.indexOf('hdn') == 0) {
                        $('#' + idValue).val(null).trigger('change');
                    }
                    else {
                        $('#' + idValue).attr('title', '');
                        $('#' + idValue).val(null);
                    }
                }
            });
        }
    }
    var fetchObj = {};
    
    fetchObj[fetchObject.SearchColumn.split('-')[1]] = $('#' + fetchObject.SearchColumn.split('-')[0]).val(),
    fetchObj['PageIndex'] = pageIndex;
    fetchObj['TypeOfServices'] = TypeOfServices;
    hdnUserAreaId = $('#LLSUserAreaId').val();
    fetchObj['UserAreaId'] = hdnUserAreaId;

    if (fetchObject.AdditionalConditions != undefined && fetchObject.AdditionalConditions != null) {
        $.each(fetchObject.AdditionalConditions, function (index4, value4) {
            fetchObj[value4.split('-')[0]] = $('#' + value4.split('-')[1]).val();
        });
    }

    if (fetchObject.ScreenName != undefined && fetchObject.ScreenName != null) {
        fetchObj['ScreenName'] = fetchObject.ScreenName;
    }
    if (fetchObject.TypeCode != undefined) {
        fetchObj['TypeCode'] = fetchObject.TypeCode;
    }
    var jqxhr = $.post(apiUrl, fetchObj, function (response) {
        var result = JSON.parse(response);
        var primaryKey = "";
        var TotalRecords = 0;
        var FirstRecord = 0;
        var h = 0;
        var LastPageIndex = 0;
        var typeOfServices = 0;
        var UserAreaId = hdnUserAreaId;
        var firstObject = $.grep(result, function (value0, index0) {
            return index0 == 0;
        });
        TotalRecords = firstObject[0].TotalRecords;
        FirstRecord = firstObject[0].FirstRecord;
        LastRecord = firstObject[0].LastRecord;
        LastPageIndex = firstObject[0].LastPageIndex;
        TypeOfServices = typeOfServices;
        UserAreaId = hdnUserAreaId;
        var prevButtonDisable = "";
        var nextButtonDisable = "";

        if (pageIndex == 1) {
            prevButtonDisable = "disabled";
        }
        if (pageIndex == LastPageIndex) {
            nextButtonDisable = "disabled";
        }

        var fetchResultString = '<ul class="dropdown-menu pull-right list-group col-sm-12 UlFetch" id="' + UlFetch + '">'
                                 + '<li class="table-responsive">';
        $.each(result, function (index, value) {
            fetchResultString += '<div>';
            var displayString = "";
            var len = fetchObject.ResultColumns.length;

            var numberOfColumns = 0;
            $.each(fetchObject.ResultColumns, function (index1, value1) {
                if (value1.split('-')[1] != "Primary Key") {
                    numberOfColumns++;
                    if (numberOfColumns <= 2) {
                        displayString += value[value1.split('-')[0]];
                        if (numberOfColumns != 2 && index1 != len - 1) displayString += " - ";
                    }
                }
                else {
                    primaryKey = value1.split('-')[0];
                }
            });
            fetchResultString += '<a class="list-group-item btn-default" id="aFetchResultItem-' + value[primaryKey] + '">' + displayString + '</a>';
            fetchResultString += '</div>';
        });

        fetchResultString += '</li>'
                                + '<li class="table-responsive fetchpagination">'
                                + 'Showing <span class="records-start">' + FirstRecord + '</span> to <span class="records-end">'
                                + '' + LastRecord + '&nbsp;'
                                + '</span> records of <span class="total-records">' + TotalRecords + '</span>&nbsp;&nbsp;'
                                + '<input type="hidden" id="hdnFetchPageIndex_' + UlFetch +'" value="' + pageIndex + '">'
                                + '<input type="button" class="prev-Page" value="<" id="btnFetchPrevPage" ' + prevButtonDisable + '/>&nbsp;'
                                + '<input type="button" class="next-Page" value=">" id="btnFetchNextPage" ' + nextButtonDisable + '/>'
                                + '</li>'
                                + '</ul>';
        $('#' + divFetch).html(null);
        $('#' + divFetch).html(fetchResultString);
        $('#' + divFetch).addClass("divfetch_dropdown_menu");
        $('#' + UlFetch).show();

        $("a[id^='aFetchResultItem']").click(function () {
            
            var primaryId1 = $(this).attr('id').split('-')[1];
           
            var obj = $.grep(result, function (value2, index2) {
                return value2[primaryKey] == primaryId1;
            });
            var returnObject = obj[0];
            $.each(fetchObject.FieldsToBeFilled, function (index3, value3) {
                var idValue = value3.split('-')[0];
                var resultValue = value3.split('-')[1];
                if (idValue.indexOf("hdn") == 0) {
                    $('#' + idValue).val(returnObject[resultValue]).trigger('change');
                }
                else if (idValue.indexOf("Date") != -1) {
                    $('#' + idValue).val(DateFormatter(returnObject[resultValue]));
                }
                else if (resultValue.indexOf("Cost") != -1) {
                    $('#' + idValue).val(addCommas(returnObject[resultValue]));
                }
                else {
                    $('#' + idValue).val(returnObject[resultValue]);
                    $('#' + idValue).attr('title', returnObject[resultValue]);
                    $('#' + idValue).parent().removeClass('has-error');
                }
            });
        });

        $('#btnFetchPrevPage, #btnFetchNextPage').click(function () {
            var id = $(this).attr('id');
            var currentPageIndex = parseInt($('#hdnFetchPageIndex_' + UlFetch).val());
            if (id == "btnFetchPrevPage") {
                if (currentPageIndex != 1) {
                    currentPageIndex -= 1;
                }
                else {
                    return false;
                }
            }
            else if (id == "btnFetchNextPage") {
                if (currentPageIndex != LastPageIndex) {
                    currentPageIndex += 1;
                }
                else {
                    return false;
                }
            }
            DisplayFetchResult(divFetch, fetchObject, apiUrl, UlFetch, event, currentPageIndex)
        });
    },
   "json")
    .fail(function (response) {
        $('#' + divFetch).html(null);
        $('#' + divFetch).html(noRecordString);
        $('#' + UlFetch).show();
    });
}
//---------------- LLS USERAREACODE  DUPLICATE CHECK START------
function DeptDisplayFetchResult(divFetch, fetchObject, apiUrl, UlFetch, event, pageIndex) {

    var divId = divFetch;
    var keyCode = 0;
    var TypeOfServices = 0;
    var hdnUserAreaId = 0;
    if (pageIndex < 100000) {

    } else {
        TypeOfServices = pageIndex - 100000;
        pageIndex = pageIndex - TypeOfServices;
        pageIndex = pageIndex / 100000;
    }
    TypeOfServices = $('#selServices').val();

    if (event != null) {
        keyCode = event.keyCode;
    }
    var key = $('#' + fetchObject.SearchColumn.split('-')[0]).val();

    var noRecordString = ' <ul class="dropdown-menu pull-right list-group col-sm-12 UlFetch" id="' + UlFetch + '">'
        + '<li>'
        + '<center> <b> <span class="records-start not-found">No Match Found</span></b></center>'
        + '</li>'
        + '</ul>';

    var conditionOk = false;
    if (keyCode == 40 || (keyCode == undefined && key.length > 0)) {
        conditionOk = true;
    }
    if (!conditionOk) {
        if (key.length == 0) {
            $.each(fetchObject.FieldsToBeFilled, function (index3, value3) {
                var idValue = value3.split('-')[0];
                var resultValue = value3.split('-')[1];
                if (idValue != fetchObject.SearchColumn.split('-')[0]) {
                    if (idValue.indexOf('sel') == 0) {
                        $('#' + idValue).val("null");
                    }
                    else if (idValue.indexOf('hdn') == 0) {
                        $('#' + idValue).val(null).trigger('change');
                    }
                    else {
                        $('#' + idValue).attr('title', '');
                        $('#' + idValue).val(null);
                    }
                }
            });
        }
        return false;
    }
    else {
        if (keyCode == undefined) {
            $.each(fetchObject.FieldsToBeFilled, function (index3, value3) {
                var idValue = value3.split('-')[0];
                var resultValue = value3.split('-')[1];
                if (idValue != fetchObject.SearchColumn.split('-')[0]) {
                    if (idValue.indexOf('sel') == 0) {
                        $('#' + idValue).val("null");
                    }
                    else if (idValue.indexOf('hdn') == 0) {
                        $('#' + idValue).val(null).trigger('change');
                    }
                    else {
                        $('#' + idValue).attr('title', '');
                        $('#' + idValue).val(null);
                    }
                }
            });
        }
    }
    var fetchObj = {};

    fetchObj[fetchObject.SearchColumn.split('-')[1]] = $('#' + fetchObject.SearchColumn.split('-')[0]).val(),
        fetchObj['PageIndex'] = pageIndex;
    fetchObj['TypeOfServices'] = TypeOfServices;
    hdnUserAreaId = $('#LLSUserAreaId').val();
    fetchObj['UserAreaId'] = hdnUserAreaId;

    if (fetchObject.AdditionalConditions != undefined && fetchObject.AdditionalConditions != null) {
        $.each(fetchObject.AdditionalConditions, function (index4, value4) {
            fetchObj[value4.split('-')[0]] = $('#' + value4.split('-')[1]).val();
        });
    }

    if (fetchObject.ScreenName != undefined && fetchObject.ScreenName != null) {
        fetchObj['ScreenName'] = fetchObject.ScreenName;
    }
    if (fetchObject.TypeCode != undefined) {
        fetchObj['TypeCode'] = fetchObject.TypeCode;
    }
    var jqxhr = $.post(apiUrl, fetchObj, function (response) {
        var result = JSON.parse(response);
        var primaryKey = "";
        var TotalRecords = 0;
        var FirstRecord = 0;
        var h = 0;
        var LastPageIndex = 0;
        var typeOfServices = 0;
        var UserAreaId = hdnUserAreaId;
        var firstObject = $.grep(result, function (value0, index0) {
            return index0 == 0;
        });
        TotalRecords = firstObject[0].TotalRecords;
        FirstRecord = firstObject[0].FirstRecord;
        LastRecord = firstObject[0].LastRecord;
        LastPageIndex = firstObject[0].LastPageIndex;
        TypeOfServices = typeOfServices;
        UserAreaId = hdnUserAreaId;
        var prevButtonDisable = "";
        var nextButtonDisable = "";

        if (pageIndex == 1) {
            prevButtonDisable = "disabled";
        }
        if (pageIndex == LastPageIndex) {
            nextButtonDisable = "disabled";
        }

        var fetchResultString = '<ul class="dropdown-menu pull-right list-group col-sm-12 UlFetch" id="' + UlFetch + '">'
            + '<li class="table-responsive">';
        $.each(result, function (index, value) {
            fetchResultString += '<div>';
            var displayString = "";
            var len = fetchObject.ResultColumns.length;

            var numberOfColumns = 0;
            $.each(fetchObject.ResultColumns, function (index1, value1) {
                if (value1.split('-')[1] != "Primary Key") {
                    numberOfColumns++;
                    if (numberOfColumns <= 2) {
                        displayString += value[value1.split('-')[0]];
                        if (numberOfColumns != 2 && index1 != len - 1) displayString += " - ";
                    }
                }
                else {
                    primaryKey = value1.split('-')[0];
                }
            });
            fetchResultString += '<a class="list-group-item btn-default" id="aFetchResultItem-' + value[primaryKey] + '">' + displayString + '</a>';
            fetchResultString += '</div>';
        });

        fetchResultString += '</li>'
            + '<li class="table-responsive fetchpagination">'
            + 'Showing <span class="records-start">' + FirstRecord + '</span> to <span class="records-end">'
            + '' + LastRecord + '&nbsp;'
            + '</span> records of <span class="total-records">' + TotalRecords + '</span>&nbsp;&nbsp;'
            + '<input type="hidden" id="hdnFetchPageIndex_' + UlFetch + '" value="' + pageIndex + '">'
            + '<input type="button" class="prev-Page" value="<" id="btnFetchPrevPage" ' + prevButtonDisable + '/>&nbsp;'
            + '<input type="button" class="next-Page" value=">" id="btnFetchNextPage" ' + nextButtonDisable + '/>'
            + '</li>'
            + '</ul>';
        $('#' + divFetch).html(null);
        $('#' + divFetch).html(fetchResultString);
        $('#' + divFetch).addClass("divfetch_dropdown_menu");
        $('#' + UlFetch).show();

        $("a[id^='aFetchResultItem']").click(function () {

            var primaryId1 = $(this).attr('id').split('-')[1];

            var obj = $.grep(result, function (value2, index2) {
                return value2[primaryKey] == primaryId1;
            });
            ///////LLS USERAREA//////
          
            var returnObject = obj[0];
            var UserAreaCode = returnObject['UserAreaCode'];
            var UserAreaId = returnObject['UserAreaId'];
           
            FunctionUserAreaCodeCheck(UserAreaCode, UserAreaId)
            
            $.each(fetchObject.FieldsToBeFilled, function (index3, value3) {
                var idValue = value3.split('-')[0];
                var resultValue = value3.split('-')[1];
                if (idValue.indexOf("hdn") == 0) {
                    $('#' + idValue).val(returnObject[resultValue]).trigger('change');
                }
                else if (idValue.indexOf("Date") != -1) {
                    $('#' + idValue).val(DateFormatter(returnObject[resultValue]));
                }
                else if (resultValue.indexOf("Cost") != -1) {
                    $('#' + idValue).val(addCommas(returnObject[resultValue]));
                }
                else {
                    $('#' + idValue).val(returnObject[resultValue]);
                    $('#' + idValue).attr('title', returnObject[resultValue]);
                    $('#' + idValue).parent().removeClass('has-error');
                }
            });
        });

        $('#btnFetchPrevPage, #btnFetchNextPage').click(function () {
            var id = $(this).attr('id');
            var currentPageIndex = parseInt($('#hdnFetchPageIndex_' + UlFetch).val());
            if (id == "btnFetchPrevPage") {
                if (currentPageIndex != 1) {
                    currentPageIndex -= 1;
                }
                else {
                    return false;
                }
            }
            else if (id == "btnFetchNextPage") {
                if (currentPageIndex != LastPageIndex) {
                    currentPageIndex += 1;
                }
                else {
                    return false;
                }
            }
            DisplayFetchResult(divFetch, fetchObject, apiUrl, UlFetch, event, currentPageIndex)
        });
    },
        "json")
        .fail(function (response) {
            $('#' + divFetch).html(null);
            $('#' + divFetch).html(noRecordString);
            $('#' + UlFetch).show();
        });
}

//-----------------LLS USERAREACODE DUPLICATE CHECK END---------------- 
function LLSDisplayLocationCodeFetchResult(divFetch, fetchObject, apiUrl, UlFetch, event, pageIndex, UserAreaCode) {
    var divId = divFetch;
    var keyCode = 0;
    var TypeOfServices = 0;
    var hdnUserAreaId = UserAreaCode;
    if (pageIndex < 100000) {

    } else {
        TypeOfServices = pageIndex - 100000;
        pageIndex = pageIndex - TypeOfServices;
        pageIndex = pageIndex / 100000;
    }
    TypeOfServices = $('#selServices').val();

    if (event != null) {
        keyCode = event.keyCode;
    }
    var key = $('#' + fetchObject.SearchColumn.split('-')[0]).val();

    var noRecordString = ' <ul class="dropdown-menu pull-right list-group col-sm-12 UlFetch" id="' + UlFetch + '">'
        + '<li>'
        + '<center> <b> <span class="records-start not-found">No Match Found</span></b></center>'
        + '</li>'
        + '</ul>';

    var conditionOk = false;
    if (keyCode == 40 || (keyCode == undefined && key.length > 0)) {
        conditionOk = true;
    }
    if (!conditionOk) {
        if (key.length == 0) {
            $.each(fetchObject.FieldsToBeFilled, function (index3, value3) {
                var idValue = value3.split('-')[0];
                var resultValue = value3.split('-')[1];
                if (idValue != fetchObject.SearchColumn.split('-')[0]) {
                    if (idValue.indexOf('sel') == 0) {
                        $('#' + idValue).val("null");
                    }
                    else if (idValue.indexOf('hdn') == 0) {
                        $('#' + idValue).val(null).trigger('change');
                    }
                    else {
                        $('#' + idValue).attr('title', '');
                        $('#' + idValue).val(null);
                    }
                }
            });
        }
        return false;
    }
    else {
        if (keyCode == undefined) {
            $.each(fetchObject.FieldsToBeFilled, function (index3, value3) {
                var idValue = value3.split('-')[0];
                var resultValue = value3.split('-')[1];
                if (idValue != fetchObject.SearchColumn.split('-')[0]) {
                    if (idValue.indexOf('sel') == 0) {
                        $('#' + idValue).val("null");
                    }
                    else if (idValue.indexOf('hdn') == 0) {
                        $('#' + idValue).val(null).trigger('change');
                    }
                    else {
                        $('#' + idValue).attr('title', '');
                        $('#' + idValue).val(null);
                    }
                }
            });
        }
    }
    var fetchObj = {};
    fetchObj[fetchObject.SearchColumn.split('-')[1]] = $('#' + fetchObject.SearchColumn.split('-')[0]).val(),
        fetchObj['PageIndex'] = pageIndex;
    fetchObj['TypeOfServices'] = TypeOfServices;
    fetchObj['UserAreaCode'] = hdnUserAreaId;

    if (fetchObject.AdditionalConditions != undefined && fetchObject.AdditionalConditions != null) {
        $.each(fetchObject.AdditionalConditions, function (index4, value4) {
            fetchObj[value4.split('-')[0]] = $('#' + value4.split('-')[1]).val();
        });
    }

    if (fetchObject.ScreenName != undefined && fetchObject.ScreenName != null) {
        fetchObj['ScreenName'] = fetchObject.ScreenName;
    }
    if (fetchObject.TypeCode != undefined) {
        fetchObj['TypeCode'] = fetchObject.TypeCode;
    }
    var jqxhr = $.post(apiUrl, fetchObj, function (response) {
        var result = JSON.parse(response);
        var primaryKey = "";
        var TotalRecords = 0;
        var FirstRecord = 0;
        var h = 0;
        var LastPageIndex = 0;
        var typeOfServices = 0;
        var UserAreaId = hdnUserAreaId;
        var firstObject = $.grep(result, function (value0, index0) {
            return index0 == 0;
        });
        TotalRecords = firstObject[0].TotalRecords;
        FirstRecord = firstObject[0].FirstRecord;
        LastRecord = firstObject[0].LastRecord;
        LastPageIndex = firstObject[0].LastPageIndex;
        TypeOfServices = typeOfServices;
        UserAreaId = hdnUserAreaId;
        var prevButtonDisable = "";
        var nextButtonDisable = "";

        if (pageIndex == 1) {
            prevButtonDisable = "disabled";
        }
        if (pageIndex == LastPageIndex) {
            nextButtonDisable = "disabled";
        }

        var fetchResultString = '<ul class="dropdown-menu pull-right list-group col-sm-12 UlFetch" id="' + UlFetch + '">'
            + '<li class="table-responsive">';
        $.each(result, function (index, value) {
            fetchResultString += '<div>';
            var displayString = "";
            var len = fetchObject.ResultColumns.length;

            var numberOfColumns = 0;
            $.each(fetchObject.ResultColumns, function (index1, value1) {
                if (value1.split('-')[1] != "Primary Key") {
                    numberOfColumns++;
                    if (numberOfColumns <= 2) {
                        displayString += value[value1.split('-')[0]];
                        if (numberOfColumns != 2 && index1 != len - 1) displayString += " - ";
                    }
                }
                else {
                    primaryKey = value1.split('-')[0];
                }
            });
            fetchResultString += '<a class="list-group-item btn-default" id="aFetchResultItem-' + value[primaryKey] + '">' + displayString + '</a>';
            fetchResultString += '</div>';
        });

        fetchResultString += '</li>'
            + '<li class="table-responsive fetchpagination">'
            + 'Showing <span class="records-start">' + FirstRecord + '</span> to <span class="records-end">'
            + '' + LastRecord + '&nbsp;'
            + '</span> records of <span class="total-records">' + TotalRecords + '</span>&nbsp;&nbsp;'
            + '<input type="hidden" id="hdnFetchPageIndex_' + UlFetch + '" value="' + pageIndex + '">'
            + '<input type="button" class="prev-Page" value="<" id="btnFetchPrevPage" ' + prevButtonDisable + '/>&nbsp;'
            + '<input type="button" class="next-Page" value=">" id="btnFetchNextPage" ' + nextButtonDisable + '/>'
            + '</li>'
            + '</ul>';
        $('#' + divFetch).html(null);
        $('#' + divFetch).html(fetchResultString);
        $('#' + divFetch).addClass("divfetch_dropdown_menu");
        $('#' + UlFetch).show();

        $("a[id^='aFetchResultItem']").click(function () {
            var primaryId1 = $(this).attr('id').split('-')[1];
            var obj = $.grep(result, function (value2, index2) {
                return value2[primaryKey] == primaryId1;
            });
            var returnObject = obj[0];
            $.each(fetchObject.FieldsToBeFilled, function (index3, value3) {
                var idValue = value3.split('-')[0];
                var resultValue = value3.split('-')[1];
                if (idValue.indexOf("hdn") == 0) {
                    $('#' + idValue).val(returnObject[resultValue]).trigger('change');
                }
                else if (idValue.indexOf("Date") != -1) {
                    $('#' + idValue).val(DateFormatter(returnObject[resultValue]));
                }
                else if (resultValue.indexOf("Cost") != -1) {
                    $('#' + idValue).val(addCommas(returnObject[resultValue]));
                }
                else {
                    $('#' + idValue).val(returnObject[resultValue]);
                    $('#' + idValue).attr('title', returnObject[resultValue]);
                    $('#' + idValue).parent().removeClass('has-error');
                }
            });
        });

        $('#btnFetchPrevPage, #btnFetchNextPage').click(function () {
            var id = $(this).attr('id');
            var currentPageIndex = parseInt($('#hdnFetchPageIndex_' + UlFetch).val());
            if (id == "btnFetchPrevPage") {
                if (currentPageIndex != 1) {
                    currentPageIndex -= 1;
                }
                else {
                    return false;
                }
            }
            else if (id == "btnFetchNextPage") {
                if (currentPageIndex != LastPageIndex) {
                    currentPageIndex += 1;
                }
                else {
                    return false;
                }
            }
            DisplayFetchResult(divFetch, fetchObject, apiUrl, UlFetch, event, currentPageIndex)
        });

        $('#btnFetchPrevPage, #btnFetchNextPage').click(function (UserAreaCode) {
            var id = $(this).attr('id');
            var hdnUserAreaId = UserAreaCode;
            var currentPageIndex = parseInt($('#hdnFetchPageIndex_' + UlFetch).val());
            if (id == "btnFetchPrevPage") {
                if (currentPageIndex != 1) {
                    currentPageIndex -= 1;
                }
                else {
                    return false;
                }
            }
            else if (id == "btnFetchNextPage") {
                if (currentPageIndex != LastPageIndex) {
                    currentPageIndex += 1;
                }
                else {
                    return false;
                }
            }
            DisplayFetchResult(divFetch, fetchObject, apiUrl, UlFetch, event, currentPageIndex, hdnUserAreaId)
        });
    },
        "json")
        .fail(function (response) {
            $('#' + divFetch).html(null);
            $('#' + divFetch).html(noRecordString);
            $('#' + UlFetch).show();
        });
}
//-------------------------------------------
function DisplayLocationCodeFetchResult(divFetch, fetchObject, apiUrl, UlFetch, event, pageIndex,UserAreaCode) {
    var divId = divFetch;
    var keyCode = 0;
    var TypeOfServices = 0;
    var hdnUserAreaId = UserAreaCode;
    if (pageIndex < 100000) {

    } else {
        TypeOfServices = pageIndex - 100000;
        pageIndex = pageIndex - TypeOfServices;
        pageIndex = pageIndex / 100000;
    }
    TypeOfServices = $('#selServices').val();

    if (event != null) {
        keyCode = event.keyCode;
    }
    var key = $('#' + fetchObject.SearchColumn.split('-')[0]).val();

    var noRecordString = ' <ul class="dropdown-menu pull-right list-group col-sm-12 UlFetch" id="' + UlFetch + '">'
        + '<li>'
        + '<center> <b> <span class="records-start not-found">No Match Found</span></b></center>'
        + '</li>'
        + '</ul>';

    var conditionOk = false;
    if (keyCode == 40 || (keyCode == undefined && key.length > 0)) {
        conditionOk = true;
    }
    if (!conditionOk) {
        if (key.length == 0) {
            $.each(fetchObject.FieldsToBeFilled, function (index3, value3) {
                var idValue = value3.split('-')[0];
                var resultValue = value3.split('-')[1];
                if (idValue != fetchObject.SearchColumn.split('-')[0]) {
                    if (idValue.indexOf('sel') == 0) {
                        $('#' + idValue).val("null");
                    }
                    else if (idValue.indexOf('hdn') == 0) {
                        $('#' + idValue).val(null).trigger('change');
                    }
                    else {
                        $('#' + idValue).attr('title', '');
                        $('#' + idValue).val(null);
                    }
                }
            });
        }
        return false;
    }
    else {
        if (keyCode == undefined) {
            $.each(fetchObject.FieldsToBeFilled, function (index3, value3) {
                var idValue = value3.split('-')[0];
                var resultValue = value3.split('-')[1];
                if (idValue != fetchObject.SearchColumn.split('-')[0]) {
                    if (idValue.indexOf('sel') == 0) {
                        $('#' + idValue).val("null");
                    }
                    else if (idValue.indexOf('hdn') == 0) {
                        $('#' + idValue).val(null).trigger('change');
                    }
                    else {
                        $('#' + idValue).attr('title', '');
                        $('#' + idValue).val(null);
                    }
                }
            });
        }
    }
    var fetchObj = {};
    fetchObj[fetchObject.SearchColumn.split('-')[1]] = $('#' + fetchObject.SearchColumn.split('-')[0]).val(),
        fetchObj['PageIndex'] = pageIndex;
    fetchObj['TypeOfServices'] = TypeOfServices;
    fetchObj['UserAreaCode'] = hdnUserAreaId;

    if (fetchObject.AdditionalConditions != undefined && fetchObject.AdditionalConditions != null) {
        $.each(fetchObject.AdditionalConditions, function (index4, value4) {
            fetchObj[value4.split('-')[0]] = $('#' + value4.split('-')[1]).val();
        });
    }

    if (fetchObject.ScreenName != undefined && fetchObject.ScreenName != null) {
        fetchObj['ScreenName'] = fetchObject.ScreenName;
    }
    if (fetchObject.TypeCode != undefined) {
        fetchObj['TypeCode'] = fetchObject.TypeCode;
    }
    var jqxhr = $.post(apiUrl, fetchObj, function (response) {
        var result = JSON.parse(response);
        var primaryKey = "";
        var TotalRecords = 0;
        var FirstRecord = 0;
        var h = 0;
        var LastPageIndex = 0;
        var typeOfServices = 0;
        var UserAreaId = hdnUserAreaId;
        var firstObject = $.grep(result, function (value0, index0) {
            return index0 == 0;
        });
        TotalRecords = firstObject[0].TotalRecords;
        FirstRecord = firstObject[0].FirstRecord;
        LastRecord = firstObject[0].LastRecord;
        LastPageIndex = firstObject[0].LastPageIndex;
        TypeOfServices = typeOfServices;
        UserAreaId = hdnUserAreaId;
        var prevButtonDisable = "";
        var nextButtonDisable = "";

        if (pageIndex == 1) {
            prevButtonDisable = "disabled";
        }
        if (pageIndex == LastPageIndex) {
            nextButtonDisable = "disabled";
        }

        var fetchResultString = '<ul class="dropdown-menu pull-right list-group col-sm-12 UlFetch" id="' + UlFetch + '">'
            + '<li class="table-responsive">';
        $.each(result, function (index, value) {
            fetchResultString += '<div>';
            var displayString = "";
            var len = fetchObject.ResultColumns.length;

            var numberOfColumns = 0;
            $.each(fetchObject.ResultColumns, function (index1, value1) {
                if (value1.split('-')[1] != "Primary Key") {
                    numberOfColumns++;
                    if (numberOfColumns <= 2) {
                        displayString += value[value1.split('-')[0]];
                        if (numberOfColumns != 2 && index1 != len - 1) displayString += " - ";
                    }
                }
                else {
                    primaryKey = value1.split('-')[0];
                }
            });
            fetchResultString += '<a class="list-group-item btn-default" id="aFetchResultItem-' + value[primaryKey] + '">' + displayString + '</a>';
            fetchResultString += '</div>';
        });

        fetchResultString += '</li>'
            + '<li class="table-responsive fetchpagination">'
            + 'Showing <span class="records-start">' + FirstRecord + '</span> to <span class="records-end">'
            + '' + LastRecord + '&nbsp;'
            + '</span> records of <span class="total-records">' + TotalRecords + '</span>&nbsp;&nbsp;'
            + '<input type="hidden" id="hdnFetchPageIndex_' + UlFetch + '" value="' + pageIndex + '">'
            + '<input type="button" class="prev-Page" value="<" id="btnFetchPrevPage" ' + prevButtonDisable + '/>&nbsp;'
            + '<input type="button" class="next-Page" value=">" id="btnFetchNextPage" ' + nextButtonDisable + '/>'
            + '</li>'
            + '</ul>';
        $('#' + divFetch).html(null);
        $('#' + divFetch).html(fetchResultString);
        $('#' + divFetch).addClass("divfetch_dropdown_menu");
        $('#' + UlFetch).show();

        $("a[id^='aFetchResultItem']").click(function () {
            var primaryId1 = $(this).attr('id').split('-')[1];
            var obj = $.grep(result, function (value2, index2) {
                return value2[primaryKey] == primaryId1;
            });
            var returnObject = obj[0];
            $.each(fetchObject.FieldsToBeFilled, function (index3, value3) {
                var idValue = value3.split('-')[0];
                var resultValue = value3.split('-')[1];
                if (idValue.indexOf("hdn") == 0) {
                    $('#' + idValue).val(returnObject[resultValue]).trigger('change');
                }
                else if (idValue.indexOf("Date") != -1) {
                    $('#' + idValue).val(DateFormatter(returnObject[resultValue]));
                }
                else if (resultValue.indexOf("Cost") != -1) {
                    $('#' + idValue).val(addCommas(returnObject[resultValue]));
                }
                else {
                    $('#' + idValue).val(returnObject[resultValue]);
                    $('#' + idValue).attr('title', returnObject[resultValue]);
                    $('#' + idValue).parent().removeClass('has-error');
                }
            });
        });

        $('#btnFetchPrevPage, #btnFetchNextPage').click(function () {
            var id = $(this).attr('id');
            var UserAreaCode = UserAreaId;
            var currentPageIndex = parseInt($('#hdnFetchPageIndex_' + UlFetch).val());
            if (id == "btnFetchPrevPage") {
                if (currentPageIndex != 1) {
                    currentPageIndex -= 1;
                }
                else {
                    return false;
                }
            }
            else if (id == "btnFetchNextPage") {
                if (currentPageIndex != LastPageIndex) {
                    currentPageIndex += 1;
                }
                else {
                    return false;
                }
            }
            DisplayLocationCodeFetchResult(divFetch, fetchObject, apiUrl, UlFetch, event, currentPageIndex, UserAreaCode)
        });
    },
        "json")
        .fail(function (response) {
            $('#' + divFetch).html(null);
            $('#' + divFetch).html(noRecordString);
            $('#' + UlFetch).show();
        });
}

function DisplayUserLocationCodeFetchResult(divFetch, fetchObject, apiUrl, UlFetch, event, pageIndex, UserAreaCode) {
    var divId = divFetch;
    var keyCode = 0;
    var TypeOfServices = 0;
    var hdnUserAreaId = UserAreaCode;
    if (pageIndex < 100000) {

    } else {
        TypeOfServices = pageIndex - 100000;
        pageIndex = pageIndex - TypeOfServices;
        pageIndex = pageIndex / 100000;
    }
    TypeOfServices = $('#selServices').val();

    if (event != null) {
        keyCode = event.keyCode;
    }
    var key = $('#' + fetchObject.SearchColumn.split('-')[0]).val();

    var noRecordString = ' <ul class="dropdown-menu pull-right list-group col-sm-12 UlFetch" id="' + UlFetch + '">'
        + '<li>'
        + '<center> <b> <span class="records-start not-found">No Match Found</span></b></center>'
        + '</li>'
        + '</ul>';

    var conditionOk = false;
    if (keyCode == 40 || (keyCode == undefined && key.length > 0)) {
        conditionOk = true;
    }
    if (!conditionOk) {
        if (key.length == 0) {
            $.each(fetchObject.FieldsToBeFilled, function (index3, value3) {
                var idValue = value3.split('-')[0];
                var resultValue = value3.split('-')[1];
                if (idValue != fetchObject.SearchColumn.split('-')[0]) {
                    if (idValue.indexOf('sel') == 0) {
                        $('#' + idValue).val("null");
                    }
                    else if (idValue.indexOf('hdn') == 0) {
                        $('#' + idValue).val(null).trigger('change');
                    }
                    else {
                        $('#' + idValue).attr('title', '');
                        $('#' + idValue).val(null);
                    }
                }
            });
        }
        return false;
    }
    else {
        if (keyCode == undefined) {
            $.each(fetchObject.FieldsToBeFilled, function (index3, value3) {
                var idValue = value3.split('-')[0];
                var resultValue = value3.split('-')[1];
                if (idValue != fetchObject.SearchColumn.split('-')[0]) {
                    if (idValue.indexOf('sel') == 0) {
                        $('#' + idValue).val("null");
                    }
                    else if (idValue.indexOf('hdn') == 0) {
                        $('#' + idValue).val(null).trigger('change');
                    }
                    else {
                        $('#' + idValue).attr('title', '');
                        $('#' + idValue).val(null);
                    }
                }
            });
        }
    }
    var fetchObj = {};
    fetchObj[fetchObject.SearchColumn.split('-')[1]] = $('#' + fetchObject.SearchColumn.split('-')[0]).val(),
        fetchObj['PageIndex'] = pageIndex;
    fetchObj['TypeOfServices'] = TypeOfServices;
    fetchObj['UserAreaCode'] = hdnUserAreaId;

    if (fetchObject.AdditionalConditions != undefined && fetchObject.AdditionalConditions != null) {
        $.each(fetchObject.AdditionalConditions, function (index4, value4) {
            fetchObj[value4.split('-')[0]] = $('#' + value4.split('-')[1]).val();
        });
    }

    if (fetchObject.ScreenName != undefined && fetchObject.ScreenName != null) {
        fetchObj['ScreenName'] = fetchObject.ScreenName;
    }
    if (fetchObject.TypeCode != undefined) {
        fetchObj['TypeCode'] = fetchObject.TypeCode;
    }
    var jqxhr = $.post(apiUrl, fetchObj, function (response) {
        var result = JSON.parse(response);
        var primaryKey = "";
        var TotalRecords = 0;
        var FirstRecord = 0;
        var h = 0;
        var LastPageIndex = 0;
        var typeOfServices = 0;
        var UserAreaId = hdnUserAreaId;
        var firstObject = $.grep(result, function (value0, index0) {
            return index0 == 0;
        });
        TotalRecords = firstObject[0].TotalRecords;
        FirstRecord = firstObject[0].FirstRecord;
        LastRecord = firstObject[0].LastRecord;
        LastPageIndex = firstObject[0].LastPageIndex;
        TypeOfServices = typeOfServices;
        UserAreaId = hdnUserAreaId;
        var prevButtonDisable = "";
        var nextButtonDisable = "";

        if (pageIndex == 1) {
            prevButtonDisable = "disabled";
        }
        if (pageIndex == LastPageIndex) {
            nextButtonDisable = "disabled";
        }

        var fetchResultString = '<ul class="dropdown-menu pull-right list-group col-sm-12 UlFetch" id="' + UlFetch + '">'
            + '<li class="table-responsive">';
        $.each(result, function (index, value) {
            fetchResultString += '<div>';
            var displayString = "";
            var len = fetchObject.ResultColumns.length;

            var numberOfColumns = 0;
            $.each(fetchObject.ResultColumns, function (index1, value1) {
                if (value1.split('-')[1] != "Primary Key") {
                    numberOfColumns++;
                    if (numberOfColumns <= 2) {
                        displayString += value[value1.split('-')[0]];
                        if (numberOfColumns != 2 && index1 != len - 1) displayString += " - ";
                    }
                }
                else {
                    primaryKey = value1.split('-')[0];
                }
            });
            fetchResultString += '<a class="list-group-item btn-default" id="aFetchResultItem-' + value[primaryKey] + '">' + displayString + '</a>';
            fetchResultString += '</div>';
        });

        fetchResultString += '</li>'
            + '<li class="table-responsive fetchpagination">'
            + 'Showing <span class="records-start">' + FirstRecord + '</span> to <span class="records-end">'
            + '' + LastRecord + '&nbsp;'
            + '</span> records of <span class="total-records">' + TotalRecords + '</span>&nbsp;&nbsp;'
            + '<input type="hidden" id="hdnFetchPageIndex_' + UlFetch + '" value="' + pageIndex + '">'
            + '<input type="button" class="prev-Page" value="<" id="btnFetchPrevPage" ' + prevButtonDisable + '/>&nbsp;'
            + '<input type="button" class="next-Page" value=">" id="btnFetchNextPage" ' + nextButtonDisable + '/>'
            + '</li>'
            + '</ul>';
        $('#' + divFetch).html(null);
        $('#' + divFetch).html(fetchResultString);
        $('#' + divFetch).addClass("divfetch_dropdown_menu");
        $('#' + UlFetch).show();

        $("a[id^='aFetchResultItem']").click(function () {
            var primaryId1 = $(this).attr('id').split('-')[1];
            var obj = $.grep(result, function (value2, index2) {
                return value2[primaryKey] == primaryId1;
            });
            var returnObject = obj[0];
            $.each(fetchObject.FieldsToBeFilled, function (index3, value3) {
                var idValue = value3.split('-')[0];
                var resultValue = value3.split('-')[1];
                if (idValue.indexOf("hdn") == 0) {
                    $('#' + idValue).val(returnObject[resultValue]).trigger('change');
                }
                else if (idValue.indexOf("Date") != -1) {
                    $('#' + idValue).val(DateFormatter(returnObject[resultValue]));
                }
                else if (resultValue.indexOf("Cost") != -1) {
                    $('#' + idValue).val(addCommas(returnObject[resultValue]));
                }
                else {
                    $('#' + idValue).val(returnObject[resultValue]);
                    $('#' + idValue).attr('title', returnObject[resultValue]);
                    $('#' + idValue).parent().removeClass('has-error');
                }
            });
        });

        $('#btnFetchPrevPage, #btnFetchNextPage').click(function () {
            var id = $(this).attr('id');
            var currentPageIndex = parseInt($('#hdnFetchPageIndex_' + UlFetch).val());
            if (id == "btnFetchPrevPage") {
                if (currentPageIndex != 1) {
                    currentPageIndex -= 1;
                }
                else {
                    return false;
                }
            }
            else if (id == "btnFetchNextPage") {
                if (currentPageIndex != LastPageIndex) {
                    currentPageIndex += 1;
                }
                else {
                    return false;
                }
            }
            DisplayFetchResult(divFetch, fetchObject, apiUrl, UlFetch, event, currentPageIndex)
        });
    },
        "json")
        .fail(function (response) {
            $('#' + divFetch).html(null);
            $('#' + divFetch).html(noRecordString);
            $('#' + UlFetch).show();
        });
}


function DisplayPPMFetchResult(divFetch, fetchObject, apiUrl, UlFetch, event, pageIndex) {

    var divId = divFetch;
    var keyCode = 0;
    var TypeOfServices = 0;
    var hdnUserAreaId = 0;
    if (pageIndex < 100000) {

    } else {
        TypeOfServices = pageIndex - 100000;
        pageIndex = pageIndex - TypeOfServices;
        pageIndex = pageIndex / 100000;
    }
   
    TypeOfServices = $('#selServices').val();

    if (event != null) {
        keyCode = event.keyCode;
    }
    var key = $('#' + fetchObject.SearchColumn.split('-')[0]).val();

    var noRecordString = ' <ul class="dropdown-menu pull-right list-group col-sm-12 UlFetch" id="' + UlFetch + '">'
        + '<li>'
        + '<center> <b> <span class="records-start not-found">No Match Found</span></b></center>'
        + '</li>'
        + '</ul>';

    var conditionOk = false;
    if (keyCode == 40 || (keyCode == undefined && key.length > 0)) {
        conditionOk = true;
    }
    if (!conditionOk) {
        if (key.length == 0) {
            $.each(fetchObject.FieldsToBeFilled, function (index3, value3) {
                var idValue = value3.split('-')[0];
                var resultValue = value3.split('-')[1];
                if (idValue != fetchObject.SearchColumn.split('-')[0]) {
                    if (idValue.indexOf('sel') == 0) {
                        $('#' + idValue).val("null");
                    }
                    else if (idValue.indexOf('hdn') == 0) {
                        $('#' + idValue).val(null).trigger('change');
                    }
                    else {
                        $('#' + idValue).attr('title', '');
                        $('#' + idValue).val(null);
                    }
                }
            });
        }
        return false;
    }
    else {
        if (keyCode == undefined) {
            $.each(fetchObject.FieldsToBeFilled, function (index3, value3) {
                var idValue = value3.split('-')[0];
                var resultValue = value3.split('-')[1];
                if (idValue != fetchObject.SearchColumn.split('-')[0]) {
                    if (idValue.indexOf('sel') == 0) {
                        $('#' + idValue).val("null");
                    }
                    else if (idValue.indexOf('hdn') == 0) {
                        $('#' + idValue).val(null).trigger('change');
                    }
                    else {
                        $('#' + idValue).attr('title', '');
                        $('#' + idValue).val(null);
                    }
                }
            });
        }
    }
    var fetchObj = {};

    fetchObj[fetchObject.SearchColumn.split('-')[1]] = $('#' + fetchObject.SearchColumn.split('-')[0]).val(),
        fetchObj['PageIndex'] = pageIndex;
    
    fetchObj['TypeOfServices'] = TypeOfServices;
    hdnUserAreaId = $('#LLSUserAreaId').val();
    fetchObj['UserAreaId'] = hdnUserAreaId;

    if (fetchObject.AdditionalConditions != undefined && fetchObject.AdditionalConditions != null) {
        $.each(fetchObject.AdditionalConditions, function (index4, value4) {
            fetchObj[value4.split('-')[0]] = $('#' + value4.split('-')[1]).val();
        });
    }

    if (fetchObject.ScreenName != undefined && fetchObject.ScreenName != null) {
        fetchObj['ScreenName'] = fetchObject.ScreenName;
    }
    if (fetchObject.TypeCode != undefined) {
        fetchObj['TypeCode'] = fetchObject.TypeCode;
    }
    var jqxhr = $.post(apiUrl, fetchObj, function (response) {
        var result = JSON.parse(response);
        var primaryKey = "";
        var TotalRecords = 0;
        var FirstRecord = 0;
        var h = 0;
        var LastPageIndex = 0;
        var typeOfServices = 0;
        var UserAreaId = hdnUserAreaId;
        var firstObject = $.grep(result, function (value0, index0) {
            return index0 == 0;
        });
        TotalRecords = firstObject[0].TotalRecords;
        FirstRecord = firstObject[0].FirstRecord;
        LastRecord = firstObject[0].LastRecord;
        LastPageIndex = firstObject[0].LastPageIndex;
        TypeOfServices = typeOfServices;
        UserAreaId = hdnUserAreaId;
        var prevButtonDisable = "";
        var nextButtonDisable = "";

        if (pageIndex == 1) {
            prevButtonDisable = "disabled";
        }
        if (pageIndex == LastPageIndex) {
            nextButtonDisable = "disabled";
        }

        var fetchResultString = '<ul class="dropdown-menu pull-right list-group col-sm-12 UlFetch" id="' + UlFetch + '">'
            + '<li class="table-responsive">';
        $.each(result, function (index, value) {
            fetchResultString += '<div>';
            var displayString = "";
            var len = fetchObject.ResultColumns.length;

            var numberOfColumns = 0;
            $.each(fetchObject.ResultColumns, function (index1, value1) {
                if (value1.split('-')[1] != "Primary Key") {
                    numberOfColumns++;
                    if (numberOfColumns <= 2) {
                        displayString += value[value1.split('-')[0]];
                        if (numberOfColumns != 2 && index1 != len - 1) displayString += " - ";
                    }
                }
                else {
                    primaryKey = value1.split('-')[0];
                }
            });
            fetchResultString += '<a class="list-group-item btn-default" id="aFetchResultItem-' + value[primaryKey] + '">' + displayString + '</a>';
            fetchResultString += '</div>';
        });

        fetchResultString += '</li>'
            + '<li class="table-responsive fetchpagination">'
            + 'Showing <span class="records-start">' + FirstRecord + '</span> to <span class="records-end">'
            + '' + LastRecord + '&nbsp;'
            + '</span> records of <span class="total-records">' + TotalRecords + '</span>&nbsp;&nbsp;'
            + '<input type="hidden" id="hdnFetchPageIndex_' + UlFetch + '" value="' + pageIndex + '">'
            + '<input type="button" class="prev-Page" value="<" id="btnFetchPrevPage" ' + prevButtonDisable + '/>&nbsp;'
            + '<input type="button" class="next-Page" value=">" id="btnFetchNextPage" ' + nextButtonDisable + '/>'
            + '</li>'
            + '</ul>';
        $('#' + divFetch).html(null);
        $('#' + divFetch).html(fetchResultString);
        $('#' + divFetch).addClass("divfetch_dropdown_menu");
        $('#' + UlFetch).show();

        $("a[id^='aFetchResultItem']").click(function () {

            var primaryId1 = $(this).attr('id').split('-')[1];

            var obj = $.grep(result, function (value2, index2) {
                return value2[primaryKey] == primaryId1;
            });
            ///////LLS USERAREA//////
            var returnObject = obj[0];
            var AssetNo = returnObject['AssetNo'];
            var AssetId = returnObject['AssetId'];
          //Added for Click on AssetNo..
            FunctionUserAssetFrequencyTaskCode(AssetNo, AssetId)
            //End Here

            $.each(fetchObject.FieldsToBeFilled, function (index3, value3) {
                var idValue = value3.split('-')[0];
                var resultValue = value3.split('-')[1];
                if (idValue.indexOf("hdn") == 0) {
                    $('#' + idValue).val(returnObject[resultValue]).trigger('change');
                }
                else if (idValue.indexOf("Date") != -1) {
                    $('#' + idValue).val(DateFormatter(returnObject[resultValue]));
                }
                else if (resultValue.indexOf("Cost") != -1) {
                    $('#' + idValue).val(addCommas(returnObject[resultValue]));
                }
                else {
                    $('#' + idValue).val(returnObject[resultValue]);
                    $('#' + idValue).attr('title', returnObject[resultValue]);
                    $('#' + idValue).parent().removeClass('has-error');
                }
            });
        });

        $('#btnFetchPrevPage, #btnFetchNextPage').click(function () {
            var id = $(this).attr('id');
            var currentPageIndex = parseInt($('#hdnFetchPageIndex_' + UlFetch).val());
            if (id == "btnFetchPrevPage") {
                if (currentPageIndex != 1) {
                    currentPageIndex -= 1;
                }
                else {
                    return false;
                }
            }
            else if (id == "btnFetchNextPage") {
                if (currentPageIndex != LastPageIndex) {
                    currentPageIndex += 1;
                }
                else {
                    return false;
                }
            }
            DisplayFetchResult(divFetch, fetchObject, apiUrl, UlFetch, event, currentPageIndex)
        });
    },
        "json")
        .fail(function (response) {
            $('#' + divFetch).html(null);
            $('#' + divFetch).html(noRecordString);
            $('#' + UlFetch).show();
        });
}
