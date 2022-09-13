$(document).ready(function () {
    $("#btntab5Cancel").click(function () {
        //window.location.href = "/bems/general";
        var message = Messages.Reset_TabAlert_CONFIRMATION;
        bootbox.confirm(message, function (result) {
            if (result) {
                EmptyFieldsContractorvendor();
            }
            else {
                $('#myPleaseWait').modal('hide');
            }
        });

    });
    function EmptyFieldsContractorvendor() {
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
        $('#selARTypeofasset').val("null");
        $('.nav-tabs a:first').tab('show')
    }
});

function loadContractorVendorTab() {
    if ($('#hdnARPrimaryID').val() == 0) {
        return false;
    }
    $("div.errormsgcenter").text("");
    $('#errorMsgCNVTab').css('visibility', 'hidden');
    $('#txtContractAssetDescription').val($('#txtARTypeDescription').val());
    var AssetParentId = $('#hdnARPrimaryID').val();//asset Id
    var currency = $('#hdnCurrency').val();
    var grid = $("#gridCV"),
    prmSearch = { multipleSearch: true, overlay: false };
    grid.jqGrid({
        url: "/api/AssetRegister/GetContractorVendor/" + AssetParentId,
        datatype: 'json',
        mtype: 'Get',
        ajaxGridOptions: { contentType: 'application/json; charset=utf-8' },
        //data: getResult.AssetRegisterChildAsset,
        //datatype: "local",
        colNames: ['ContractId', 'Contract No.', 'Contractor Type', 'Contractor Name', 'Contract Start Date', 'Contract End Date', 'Status', 'Contract Value (' + currency + ')'],
        colModel: [
            { key: true, hidden: true, name: 'ContractId', width: '0%' },
            { key: false, name: 'ContractNo', width: '10%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
            { key: false, name: 'ContractorType', width: '10%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
            { key: false, name: 'ContractorName', width: '20%', searchoptions: { sopt: ['cn', 'eq', 'ne', 'bw', 'bn', 'ew', 'en', 'nc', 'nu', 'nn'] } },
            { key: false, name: 'ContractStartDate', width: '15%', formatter: "date", formatoptions: { srcformat: "d-M-Y H:i", newformat: Messages.DATE_FORMAT } },
            { key: false, name: 'ContractEndDate', width: '15%', formatter: "date", formatoptions: { srcformat: "d-M-Y H:i", newformat: Messages.DATE_FORMAT } },
            { key: false, name: 'Status', width: '10%', searchoptions: { sopt: ["eq", "ne"] } },
            { key: false, name: 'ContractValue', width: '10%', align:'right', formatter: 'currency', formatoptions: { thousandsSeparator: ',' }, searchoptions: { sopt: ["eq", "ne"] } }
        ],
        pager: jQuery('#pagerCV'),
        rowNum: 10,
        rowList: [5, 10, 20, 50],
        height: 'auto',
        width: '100%',
        viewrecords: true,
        //caption: '',
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
            var contractId = rowData.ContractId;
            var message = 'You will be redirected to the Out Sourced Service Register screen. Are you sure you want to proceed?';
             bootbox.confirm(message, function (result) {
                 if (result) {
                     url = "/bems/outsourcedserviceregister/Index/" + contractId;
                     window.location.href = url;
                 }
             });
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
            //$("#ExporttoExcel").removeClass('ui-state-disabled');
            //$("#ExporttoPDF").removeClass('ui-state-disabled');
            //$("#ExporttoCSV").removeClass('ui-state-disabled');

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
                $('.ui-jqgrid-sortable').css('text-align', 'center');
                $('.ui-jqgrid-sortable').css('padding-bottom', '14px');
                $('.ui-jqgrid-sortable').css('font-size', '12px');
            }
            //if (!hasAddPermission) {
            //    $("#Add").hide();
            //}
            // setGridPermission(responce);
        },
        gridComplete: function() { 
            var objRows = $("#gridCV tr");
            //var objHeader = $("#gridCV .jqgfirstrow td");
            var objHeader = $("#gbox_gridCV .ui-jqgrid-labels th");
            $('#t_gridCV').hide();
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

    var gbox = $("#gbox_" + grid[0].id);
    //gbox.before(searchDialog);
    gbox.css({ width: "100%" });
    gbox.find('div,table').css({ width: "100%" });
    gbox.find('#pagerCV').css({ height: "auto" });
    $("#searchmodfbox_grid,#refresh_grid").hide();

}