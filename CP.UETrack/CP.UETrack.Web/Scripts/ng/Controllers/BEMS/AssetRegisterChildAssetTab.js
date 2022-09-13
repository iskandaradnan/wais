$(document).ready(function () {
    $("#btnARChildTabCancel").click(function () {
       
        //window.location.href = "/bems/general";
        var message = Messages.Reset_TabAlert_CONFIRMATION;
        bootbox.confirm(message, function (result) {
            if (result) {
                EmptyFieldsChildasset();
            }
            else {
                $('#myPleaseWait').modal('hide');
            }
        });
    });
    function EmptyFieldsChildasset() {
        $(".content").scrollTop(0);
        $('input[type="text"], textarea').val('');
        $('#selARAssetClassification').val("null");
        $('#selARServiceId,.selARServiceId').val(2);
        $('#selARAssetStatus').val(1);
        $('#selARRiskRating').val(113);
        $('#selARPurchaseCategory').val("null");
        $('#selARAppliedPartType').val("null");
        $('#selAREquipmentClass').val("null");
        $('#selARPPM').val("null");
        $('#selAROther').val("null");
        $('#selARRI').val("null");
        $('#selARAssetTransferMode').val("null");

        $('#txtARAssetNo').attr('disabled', false);

        $('#txtARTypeCode').attr('disabled', false);
        $('#txtARAssetPreRegistrationNo').attr('disabled', false);
        $('#spnPopup-assetPreRegistration').unbind("click").attr('disabled', false).css('cursor', 'default');
        $('#spnPopup-typeCode').unbind("click").attr('disabled', false).css('cursor', 'default');
        $('#btnAREdit').hide();
        $('#btnARSave').show();
        $('#btnDelete').hide();
        $('#btnNextScreenSave').hide();
        $('#spnActionType').text('Add');
        $("#hdnARPrimaryID").val('');
        $("#grid").trigger('reloadGrid');
        $("#assetRegister :input:not(:button)").parent().removeClass('has-error');
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
        $('.nav-tabs a:first').tab('show')
    }
});

function loadchildAssetGrid() {
    if ($('#hdnARPrimaryID').val() == 0) {
        return false;
    }
    
    $("div.errormsgcenter").text("");
    $('#errorMsgChildTab').css('visibility', 'hidden');
    $("#gridCA").GridUnload();
    var AssetParentId = $('#hdnARPrimaryID').val();//asset Id
    $('#txtARchildAssetDescription').val($('#txtARTypeDescription').val());
    var grid = $("#gridCA"),
    prmSearch = { multipleSearch: true, overlay: false };
    grid.jqGrid({
        url: "/api/AssetRegister/GetChildAsset/" + AssetParentId,
        datatype: 'json',
        mtype: 'Get',
        ajaxGridOptions: { contentType: 'application/json; charset=utf-8' },
        //data: getResult.AssetRegisterChildAsset,
        //datatype: "local",
        colNames: ['Id', 'Asset No.', 'Asset Description', 'Asset Type Code', 'Asset Type Description', 'Manufacturer', 'Model', 'Asset Status'],
        colModel: [
            { key: true, hidden: true, name: 'AssetId', width: '0%' },
            { key: false, search: true, name: 'AssetNo', width: '10%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
            { key: false, search: true, name: 'AssetDescription', width: '20%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
            { key: false, name: 'AssetTypeCode', width: '10%', searchoptions: { sopt: ['cn', "eq", "ne"] } },
            { key: false, name: 'AssetTypeDescription', width: '20%', searchoptions: { sopt: ['cn', "eq", "ne"] } },
            { key: false, name: 'ManufacturerName', width: '15%', search: false, searchoptions: { sopt: ['cn',"eq", "ne"] } },
            { key: false, name: 'ModelName', width: '15%', searchoptions: { sopt: ['cn', "eq", "ne"] } },
            { key: false, name: 'AssetStatus', width: '10%', searchoptions: { sopt: ["eq", "ne"] } }
        ],
        pager: jQuery('#pagerCA'),
        rowNum: 10,
        rowList: [5, 10, 20, 50],
        height: 'auto',
        width: '100%',
        viewrecords: true,
        caption: '',
        sortname: 'ModifiedDateUTC',
        sortorder: 'desc',
        excel: true,
        subGrid: false,
        subGridOptions: {
            "plusicon": "ui-icon-triangle-1-e", "minusicon": "ui-icon-triangle-1-s", "openicon": "ui-icon-arrowreturn-1-e",
            "reloadOnExpand": false,
            "selectOnExpand": true
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
            }
            //if (!hasAddPermission) {
            //    $("#Add").hide();
            //}
            //setGridPermission(data);
            $('.ui-jqgrid-sortable').css('text-align', 'center');
            $('.ui-jqgrid-sortable').css('padding-bottom', '14px');
            $('.ui-jqgrid-sortable').css('font-size', '12px');
        },
        loadError: function (responce) {
            if (responce.status == 404) {
                $(this).clearGridData();
            }
            $('.ui-jqgrid-sortable').css('text-align', 'center');
            $('.ui-jqgrid-sortable').css('padding-bottom', '14px');
            $('.ui-jqgrid-sortable').css('font-size', '12px');
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

                //$("#ExporttoExcel").addClass('ui-state-disabled');
                //$("#ExporttoPDF").addClass('ui-state-disabled');
                //$("#ExporttoCSV").addClass('ui-state-disabled');
            }
            //if (!hasAddPermission) {
            //    $("#Add").hide();
            //}
            // setGridPermission(responce);
        },
        gridComplete: function () {
            var objRows = $("#gridCA tr");
            //var objHeader = $("#gridCV .jqgfirstrow td");
            var objHeader = $("#gbox_gridCA .ui-jqgrid-labels th");
            $('#t_gridCA').hide();
            if (objRows.length > 1) {
                var objFirstRowColumns = $(objRows[1]).children("td");
                for (i = 0; i < objFirstRowColumns.length; i++) {
                    $(objFirstRowColumns[i]).css("width", $(objHeader[i]).css("width"));
                }
            }
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
        //toppager: true,
        toolbar: [true, "top"]
    })

    $.jgrid.jqModal = $.jgrid.jqModal || {};
    $.extend(true, $.jgrid.jqModal, { toTop: true });

    // create the searching dialog
    //grid.searchGrid(prmSearch);

    // find the div which contain the searching dialog
    //var searchDialog = $("#searchmodfbox_" + grid[0].id);
    // make the searching dialog non-popup
    //searchDialog.css({ position: "relative", "z-index": "auto", float: "left" });

    //var gbox = $("#gbox_" + grid[0].id);
    //gbox.before(searchDialog);
    //gbox.css({ clear: "left" });
    var gbox = $("#gbox_" + grid[0].id);
    //gbox.before(searchDialog);
    gbox.css({ width: "100%" });
    gbox.find('div,table').css({ width: "100%" });
    gbox.find('#pagerCA').css({ height: "auto" });
    $("#searchmodfbox_grid,#refresh_grid").hide();

}