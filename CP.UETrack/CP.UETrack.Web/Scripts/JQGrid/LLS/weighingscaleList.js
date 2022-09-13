$(document).ready(function () {
    var StatusValue = "Active:Active;Inactive:Inactive;";
    var IssuingBodyValues = "";
    $.get("/api/WeighingScale/Load").done(function (result) {
        var loadResult = JSON.parse(result);
        $.each(loadResult.Status, function (index, value) {
            IssuingBodyValues = IssuingBodyValues + (value.FieldValue + ':' + value.FieldValue + ';');
        });
        genarateGrid(StatusValue, IssuingBodyValues);
    })
        .fail(function () {
            // $('#myPleaseWait').modal('hide');
            // $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
            //  $('#errorMsg').css('visibility', 'visible');
        });
});

$(function () {
   
   // var StatusValue = "Active:Active;Inactive:Inactive;";
   // var IssuingBodyValue = "Jabatan Pengangkutan Jalan:Jabatan Pengangkutan Jalan;Jabatan Alam Sekitar:Jabatan Alam Sekitar;PUSPAKOM:PUSPAKOM;LPKP:LPKP;";
   // var IssuingBodyValue = GetIssuingBodyValue();
   
    //genarateGrid(StatusValue, IssuingBodyValue);
});
function GetIssuingBodyValue() {
    var IssuingBodyValues = "";
    $.get("/api/WeighingScale/Load").done(function (result) {
        var loadResult = JSON.parse(result);
        $.each(loadResult.Status, function (index, value) {
            IssuingBodyValues = IssuingBodyValues + (value.FieldValue + ':' + value.FieldValue + ';');
        });

    })
        .fail(function () {
            // $('#myPleaseWait').modal('hide');
            // $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
            //  $('#errorMsg').css('visibility', 'visible');
        });

    return IssuingBodyValues;
}
function genarateGrid(statusValue, issuingBodyValue) {
    var isFromSave = false;
    var gridClicked = false;
    var hasAddPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Add'");
   // var IssuingBodyValues = GetIssuingBodyValue();
    var StatusValue = statusValue.replace(/[,;]$/, '').toString();
    var IssuingBodyValue = issuingBodyValue.replace(/[,;]$/, '').toString();
    var grid = $("#grid"),
        prmSearch = { multipleSearch: true, overlay: false };
    grid.jqGrid({
        url: "/api/WeighingScale/GetAll",
        datatype: 'json',
        mtype: 'Get',
        ajaxGridOptions: { contentType: 'application/json; charset=utf-8' },
        colNames: ['Id', 'IssuedBy', 'ItemDescription', 'SerialNo', 'IssuedDate', 'ExpiryDate ', 'Status'],
        colModel: [
            { key: true, hidden: true, name: 'WeighingScaleId', width: '0%' },
            { key: true, search: true, name: 'IssuedBy', width: '20%', stype: "select", searchoptions: { sopt: ["eq", "ne"], value: IssuingBodyValue, defaultValue: "Jabatan Pengangkutan Jalan" } },
            { key: false, search: true, name: 'ItemDescription', width: '20%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
            { key: false, search: true, name: 'SerialNo', width: '20%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
            { key: false, search: true, name: 'IssuedDate', width: '20%', formatoptions: { srcformat: "d-M-Y H:i", newformat: "d-M-Y" }, formatter: "date", resizable: false, searchoptions: { dataInit: function (elem) { $(elem).datetimepicker({ timepicker: false, format: 'd-M-Y', step: 15, scrollInput: false }) }, sopt: ['eq', 'ne', 'lt', 'gt', 'le', 'ge'] } },
            { key: false, search: true, name: 'ExpiryDate', width: '10%', formatoptions: { srcformat: "d-M-Y H:i", newformat: "d-M-Y" }, formatter: "date", resizable: false, searchoptions: { dataInit: function (elem) { $(elem).datetimepicker({ timepicker: false, format: 'd-M-Y', step: 15, scrollInput: false }) }, sopt: ['eq', 'ne', 'lt', 'gt', 'le', 'ge'] } },
            { key: false, search: true, name: 'Status', width: '10%', stype: "select", searchoptions: { sopt: ["eq", "ne"], value: StatusValue, defaultValue: "Active" } },
        ],
        pager: jQuery('#pager'),
        rowNum: 5,
        rowList: [5, 10, 20, 50],
        height: 'auto',
        width: '100%',
        viewrecords: true,
        // caption: 'Block',
        sortname: 'ModifiedDateUTC',
        sortorder: 'desc',
        excel: true,
        subGrid: false,
        subGridOptions: {
            "plusicon": "ui-icon-triangle-1-e", "minusicon": "ui-icon-triangle-1-s", "openicon": "ui-icon-arrowreturn-1-e",
            "reloadOnExpand": false,
            "selectOnExpand": true,
        },
        onCellSelect: function (LaundryPlantId, iCol, content, event) {
            var rowData = $(this).jqGrid("getRowData", LaundryPlantId);
            //console.log(rowData);
            LinkClicked(LaundryPlantId);
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
            totalPage = $("#sp_1_pager").text();// total pages
            curPage = $(".ui-pg-input").val();// current page
            $("#ExporttoExcel").removeClass('ui-state-disabled');
            $("#ExporttoPDF").removeClass('ui-state-disabled');
            $("#ExporttoCSV").removeClass('ui-state-disabled');

            if ($('#sp_1_pager').text() == "0") {
                $("#sp_1_pager").text("1");
                $("#next_pager").addClass('ui-state-disabled');
                $("#last_pager").addClass('ui-state-disabled');
            } $("tr.jqgrow:odd").css("background", "#F0F8FF");
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
            if (!hasAddPermission) {
                $("#Add").hide();
            }
            setGridPermission(data);
            if (!isFromSave && !FromNotification) {
                $(".content").scrollTop(3000);
                isFromSave = true;
                FromNotification = false;
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
            if (!hasAddPermission) {
                $("#Add").hide();
            }
             setGridPermission(responce);
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
        }
    )
        //.navButtonAdd('#grid_toppager', {
        //    id:"Add",
        //    caption: "",
        //    buttonicon: "ui-icon-add",
        //    onClickButton: function () {
        //        window.location.href = "/bems/Block/add";
        //    }
        //}
        //)
        .navButtonAdd('#pager_left', {
            id: "refresh_grid_top",
            caption: "",
            buttonicon: "ui-icon-refresh1",
            onClickButton: function () {
                // $("#grid").trigger('reloadGrid');
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
        //.navButtonAdd('#grid_toppager', {
        //    id:"ExporttoPDF",
        //    caption: "Export to Pdf",
        //    buttonicon: "ui-icon-disk",
        //    onClickButton: function () {
        //        Export("Pdf");
        //    }
        //})
        .navButtonAdd('#pager_left', {
            id: "ExporttoCSV",
            caption: "",
            buttonicon: "ui-icon-csv",
            onClickButton: function () {
                Export("CSV");
            }
        });



    $.jgrid.jqModal = $.jgrid.jqModal || {};
    $.extend(true, $.jgrid.jqModal, { toTop: true });

    // create the searching dialog
    grid.searchGrid(prmSearch);

    // find the div which contain the searching dialog
    var searchDialog = $("#searchmodfbox_" + grid[0].id);
    // make the searching dialog non-popup
    searchDialog.css({ position: "relative", "z-index": "auto", float: "left" });

    var gbox = $("#gbox_" + grid[0].id);
    gbox.before(searchDialog);
    gbox.css({ clear: "left" });
    $("#searchmodfbox_grid,#refresh_grid").hide();

}

function activeText(cellValue, options, rowObject, action) {

    return rowObject.Active == 1 ? "Active" : "Inactive";
}
function escapeShowTitle(title) {

    title = title.replace(/\\([\s\S])|(")/g, "\\$1$2");
    title = escape(title)
    return title
}
function Export(exportType) {

    var grid = $('#grid');
    var filters = grid.getGridParam('postData').filters;
    var sortColumnName = $("#grid").jqGrid('getGridParam', 'sortname');
    var sortOrder = $("#grid").jqGrid('getGridParam', 'sortorder');
    var mymodel = $("#grid").getGridParam('colModel')

    var screenTitle = $("#menu").find("li.active:last").text();
    var $downloadForm = $("<form method='POST'>")
        .attr("action", "/api/common/Export")
        .append($("<input name='filters' type='text'>").val(filters))
        .append($("<input name='sortOrder' type='text'>").val(sortOrder))
        .append($("<input name='sortColumnName' type='text'>").val(sortColumnName))
        //.append($("<input name='screenName' type='text'>").val("Block"))
        .append($("<input name='screenName' type='text'>").val("weighingscale"))
        .append($("<input name='spName' type='text'>").val("LLSWeighingScaleMst_Export"))
        .append($("<input name='exportType' type='text'>").val(exportType));

    $("body").append($downloadForm);
    var status = $downloadForm.submit();
    $downloadForm.remove();

}

//function filterGrid() {
//    var postDataValues = $("#grid").jqGrid('getGridParam', 'postData');
//    // grab all the filter ids and values and add to the post object
//    $('.filterItem').each(function (index, item) {
//        postDataValues[$(item).attr('id')] = $(item).val();
//    });
//    $('#grid').jqGrid().setGridParam({ postData: postDataValues, page: 1 }).trigger('reloadGrid');
//}

function filterGrid() {
    var postDataValues = $("#grid").jqGrid('getGridParam', 'postData');
    var totalrecords = $("#grid").getGridParam("reccount");
    var Curentpage = $('#grid').getGridParam('page');
    $('.filterItem').each(function (index, item) {
        postDataValues[$(item).attr('id')] = $(item).val();
    });
    if (totalrecords <= 1) {
        Curentpage = Curentpage - 1;
    }
    $('#grid').jqGrid().setGridParam({ postData: postDataValues, page: Curentpage }).trigger('reloadGrid');
}