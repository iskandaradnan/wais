var pageindex = 1, pagesize = 5;
var TotalPages = 1
var HKeepingDetails = [];

$(document).ready(function () {
    $('#myPleaseWait').modal('show');
    formInputValidation("FrmHouse");
    $('.btnDelete').hide();
    $('.btnEdit').show();
    $('#btnNextScreenSave').hide();
    $('#txtDateTimeStamp_').prop('disabled', true);

    //var DateTime = getDate();

    window.ClassGradeListGlobal = []
    $.get("/api/CentralLinenStoreHKeeping/Load")
        .done(function (result) {
            var loadResult = JSON.parse(result);
            var date = new Date();
            var month = date.getMonth();
            var currentMonth = month + 1;
            var hidemonth = currentMonth - 1;
            $.each(loadResult.StoreType, function (index, value) {
                $('#txtStoreType').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            //$.each(loadResult.Year, function (index, value) {
            //    $('#txtYear').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            //});
            //$.each(loadResult.MonthName, function (index, value) {
            //    $('#txtMonth').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            //});
            $.each(loadResult.HousekeepingDone, function (index, value) {
                $('#txtHousekeepingDone_').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $.each(loadResult.Year, function (index, value) {
                $('#txtYear').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $('#txtYear').val(loadResult.CurrentYear);

            $.each(loadResult.MonthName, function (index, value) {
                $('#txtMonth').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            //$('#txtMonth option[value="' + currentMonth + '"]').prop('selected', true);
            //$('#txtMonth option:gt(' + hidemonth + ')').prop('disabled', true);


            window.ClassGradeListGlobal = loadResult.HousekeepingDone;
            AddNewRowStkAdjustment();
            $('#txtDate_').prop('required', true);
        })

        .fail(function () {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
        });
});
$(".btnSave,.btnEdit").click(function () {
    $('#btnlogin').attr('disabled', true);
    $('#myPleaseWait').modal('show');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('#txtStoreType').attr('required', true);
    $('#txtYear').attr('required', true);
    $('#txtMonth').attr('required', true);
    $('#txtDate_').attr('required', true);
    $('.btnEdit').show();
    $('.btnSave').show();
    $('.btnDelete').hide();
    var _index;
    var result = [];
    $('#HKeepingResultId tr').each(function () {
        _index = $(this).index();
    });

    for (var i = 0; i <= _index; i++) {
        var active = true;
        var _tempObj = {
            // HouseKeepingId = $('#LicenseTypeId_' + i).val(),,
            HouseKeepingDetId: $('#HouseKeepingDetId_' + i).val(),
            Date: $('#txtDate_' + i).val(),
            HousekeepingDone: $('#txtHousekeepingDone_' + i).val(),
            DateTimeStamp: Date.now(),// $('#txtDateTimeStamp_' + i).val(),
            IsDeleted: chkIsDeletedRow(i, $('#Isdeleted_' + i).is(":checked"))
        }
        result.push(_tempObj);
    }
    var CurrentbtnID = $(this).attr("value");
    var timeStamp = $("#Timestamp").val();
    var isFormValid = formInputValidation("FrmHouse", 'save');
    if (!isFormValid) {
        $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        $('#errorMsg').css('visibility', 'visible');
        $('#btnlogin').attr('disabled', false);
        $('#myPleaseWait').modal('hide');
        return false;
    }

    var MstHousekeeping = {
        StoreType: $('#txtStoreType').val(),
        Year: $('#txtYear').val(),
        Month: $('#txtMonth').val(),
        LCentralHouseItemGridList: result,
        // CurrentbtnID: CurrentbtnID,
    };
    function chkIsDeletedRow(i, delrec) {
        if (delrec == true) {
            $('#txtDate_' + i).prop("required", false);
            $('#txtHousekeepingDone_' + i).prop("required", false);
            $('#txtDateTimeStamp_' + i).prop("required", false);
            return true;
        }
        else {
            return false;
        }
    }
    var deletedCount = Enumerable.From(result).Where(x => x.IsDeleted).Count();
    var Isdeleteavailable = deletedCount > 0;
    if (deletedCount == result.length && TotalPages == 1) {
        bootbox.alert("Sorry!. You cannot delete all rows");
        $('#myPleaseWait').modal('hide');
        return false;
    }
    var primaryId = $("#primaryID").val();
    if (primaryId != null) {
        MstHousekeeping.HousekeepingId = primaryId;
        MstHousekeeping.Timestamp = timeStamp;
    }
    else {
        MstHousekeeping.HousekeepingId = 0;
        MstHousekeeping.Timestamp = "";
    }

    var jqxhr = $.post("/api/CentralLinenStoreHKeeping/Save", MstHousekeeping, function (response) {
        var result = JSON.parse(response);
        $("#primaryID").val(result.HousekeepingId);
        $('#hdnAttachId').val(result.HiddenId);
        if (result != null && result.LCentralHouseItemGridList != null && result.LCentralHouseItemGridList.length > 0) {
            BindGridData(result);
        }
        $("#Timestamp").val(result.Timestamp);
        // $("#txtStoreType").val(result.StoreType);
        $("#grid").trigger('reloadGrid');
        if (result.HousekeepingId != 0) {
            $('#hdnAttachId').val(result.HiddenId);
            $('#txtStoreType').attr('disabled', true);
            $('#txtYear').attr('disabled', true);
            $('#txtMonth').attr('disabled', true);
            $('#btnNextScreenSave').show();
            $('.btnEdit').show();
            $('.btnSave').show();
            $('.btnDelete').hide();
        }
        $(".content").scrollTop(0);
        showMessage('Housekeeping', CURD_MESSAGE_STATUS.SS);
        $("#top-notifications").modal('show');
        setTimeout(function () {
            $("#top-notifications").modal('hide');
        }, 5000);

        $('.btnSave').attr('disabled', false);
        if (CurrentbtnID == "1") {
            EmptyFields();
        }
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
            $('#errorMsg').css('visibility', 'visible');

            $('.btnSave').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
        });
});
//************************************ Grid Delete 

//$("#chk_stkadjustmentdet").change(function () {
//    var Isdeletebool = this.checked;

//    if (this.checked) {
//        $('#HKeepingResultId tr').map(function (i) {
//            if ($("#Isdeleted_" + i).prop("disabled")) {
//                $("#Isdeleted_" + i).prop("checked", false);
//            }
//            else {
//                $("#Isdeleted_" + i).prop("checked", true);
//            }
//        });
//    } else {
//        $('#HKeepingResultId tr').map(function (i) {
//            $("#Isdeleted_" + i).prop("checked", false);
//        });
//    }
//});
$("#chk_FacWorkIsDelete").change(function () {
    var Isdeletebool = this.checked;

    if (this.checked) {
        $('#HKeepingResultId tr').map(function (i) {
            if ($("#Isdeleted_" + i).prop("disabled")) {
                $("#Isdeleted_" + i).prop("checked", false);
            }
            else {
                $("#Isdeleted_" + i).prop("checked", true);
            }
        });
    } else {
        $('#HKeepingResultId tr').map(function (i) {
            $("#Isdeleted_" + i).prop("checked", false);
        });
    }
});
$(".btnCancel").click(function () {
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
    LinkClicked(ID);
}
// **** Query String to get ID  End****\\\


//************************************************************************
//function HKeepingData() {
//    debugger;
//    $('#myPleaseWait').modal('show');
//    var StoreType = $('#txtStoreType').val();
//    var Year = $("#txtYear option:selected").text();
//    var Month = $("#txtMonth option:selected").text();
//    $.get("/api/CentralLinenStoreHKeeping/Get/" + )
//        .done(function (result) {
//            var getResult = JSON.parse(result);
//            HKeepingDetails = getResult.LCentralHouseItemGridList;
//            if (HKeepingDetails == null) {
//                PushEmptyMessage();
//                $("#paginationfooter").hide();
//            }
//            else {
//                $("#paginationfooter").show();
//                $("#HKeepingResultId").empty();
//                $.each(HKeepingDetails, function (index, value) {
//                    HKeepingNewRow();
//                    BindGridData(getResult);
//                    //$("#txtDate_" + index).val(value.Date).prop("disabled", False);
//                    //$("#txtHousekeepingDone_" + index).val(value.HousekeepingDone).prop("disabled", False);
//                    //$("#txtDateTimeStamp_" + index).val(value.DateTimeStamp).prop("disabled", true);
//                });
//            }
//            if ((HKeepingDetails && HKeepingDetails.length) > 0) {
//                GridtotalRecords = HKeepingDetails[0].TotalRecords;
//                TotalPages = HKeepingDetails[0].TotalPages;
//                LastRecord = HKeepingDetails[0].LastRecord;
//                FirstRecord = HKeepingDetails[0].FirstRecord;
//                pageindex = HKeepingDetails[0].PageIndex;
//            }

//            var mapIdproperty = ["Date-txtDate_", "HousekeepingDone-txtHousekeepingDone_", "DateTimeStamp-txtDateTimeStamp_"];
//            var htmltext = HKeepingGridHtml();//Inline Html
//            var obj = { formId: "#form", IsView: ($('#ActionType').val() == "VIEW"), PageNumber: pageindex, flag: "", mapIdproperty: mapIdproperty, htmltext: htmltext, GridtotalRecords: GridtotalRecords, ListName: "LCentralHouseItemGridList", tableid: '#HKeepingResultId', destionId: "#paginationfooter", TotalPages: TotalPages, FirstRecord: FirstRecord, LastRecord: LastRecord, geturl: "/api/CentralLinenStoreHKeeping/HKeeping/" + StoreType + "/" + Year + "/" + Month + "/" + "/" + pagesize + "/" + pageindex };

//            CreateFooterPagination(obj);

//            $('#myPleaseWait').modal('hide');
//        })
//        .fail(function (response) {
//            $('#myPleaseWait').modal('hide');
//            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
//            $('#errorMsg').css('visibility', 'visible');
//        });
//}
//************************************************ Getbyid bind data *************************
$(".btnDepCancel").click(function () {
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
function BindGridData(getResult) {
    var ActionType = $('#ActionType').val();
    $("#HKeepingResultId").empty();
    $.each(getResult.LCentralHouseItemGridList, function (index, value) {
        AddNewRowStkAdjustment();
        $("#HouseKeepingDetId_" + index).val(getResult.LCentralHouseItemGridList[index].HouseKeepingDetId);
        // $("#txtDate_" + index).val(value.Date).prop("disabled", true);
        var ar = value.Date.split('T');
        var datefeed = new Date();
        datefeed = ar[0];
        $("#txtDate_" + index).val(datefeed);
        $("#txtHousekeepingDone_" + index).val(value.HousekeepingDone).prop("disabled", false);
        $("#txtDateTimeStamp_" + index).val(value.DateTimeStamp).prop("disabled", true);
        //$("#txtDate_" + index).val(moment(getResult.LCentralHouseItemGridList[index].Date).format("DD-MMM-YYYY"));
        $("#txtHousekeepingDone_" + index).val(getResult.LCentralHouseItemGridList[index].HousekeepingDone);
        $("#txtDateTimeStamp_" + index).val(moment(getResult.LCentralHouseItemGridList[index].DateTimeStamp).format("DD-MMM-YYYY HH:MM"));
        //$("#txtStoreType" + index).val(getResult.StoreType);
        //$("#txtYear" + index).val(getResult.Year);
        //$("#txtMonth" + index).val(getResult.Month);
        linkCliked1 = true;
        $("#chkContactDeleteAll").prop("checked", false);
        $(".content").scrollTop(0);
    });

    //************************************************ Grid Pagination *******************************************
    ckNewRowPaginationValidation = false;
    if ((getResult.LCentralHouseItemGridList && getResult.LCentralHouseItemGridList.length) > 0) {
        GridtotalRecords = getResult.LCentralHouseItemGridList[0].TotalRecords;
        TotalPages = getResult.LCentralHouseItemGridList[0].TotalPages;
        LastRecord = getResult.LCentralHouseItemGridList[0].LastRecord;
        FirstRecord = getResult.LCentralHouseItemGridList[0].FirstRecord;
        pageindex = getResult.LCentralHouseItemGridList[0].PageIndex;
        linkCliked1 = true;
        $(".content").scrollTop(0);
    }
    $('#paginationfooter').show();


    //************************************************ End *******************************************************
}
//**************************************************************************************


var linkCliked1 = false;
function AddNewRowStkAdjustment() {
    $('#chkContactDeleteAll').prop('checked', false);
    var inputpar = {
        inlineHTML: HKeepingGridHtml(),
        IdPlaceholderused: "maxindexval",
        TargetId: "#HKeepingResultId",
        TargetElement: ["tr"]
    }
    $("#chkContactDeleteAll").prop("checked", false);
    AddNewRowToDataGrid(inputpar);
    //ckNewRowPaginationValidation = true;
    //$('#chk_stkadjustmentdet').prop("checked", false);
    if (!linkCliked1) {
        $('#HKeepingResultId tr:last td:first input').focus();
    }
    else {
        linkCliked1 = false;
    }
    var rowCount = $('#HKeepingResultId tr:last').index();

    $.each(window.ClassGradeListGlobal, function (index, value) {
        $('#txtHousekeepingDone_' + rowCount).append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
    });

    formInputValidation("FrmHouse");


}

function PushEmptyMessage() {
    $("#HKeepingResultId").empty();
    var emptyrow = '<tr><td colspan=57 ><h3>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;No records to display</h3></td></tr>'
    $("#HKeepingResultId ").append(emptyrow);
}

function HKeepingGridHtml() {
    var month = $('#txtMonth').val();
    if (month % 2 == 0) {
        if (month <= 9) {
            month = "0" + month;
        }
        if (month >= 09) {
            var year = $('#txtYear').val();
            var start = new Date();
            var End = new Date();
            start = year + '-' + month + '-01';
            End = year + '-' + month + '-31';

        } else {
            var year = $('#txtYear').val();
            var start = new Date();
            var End = new Date();
            start = year + '-' + month + '-01';
            End = year + '-' + month + '-30';
        }
        if (month == 02) {
            if ((0 == year % 4) && (0 != year % 100) || (0 == year % 400)) {
                // alert(year + " is a leap year");
                var year = $('#txtYear').val();
                var start = new Date();
                var End = new Date();
                start = year + '-' + month + '-01';
                End = year + '-' + month + '-29';
            }
            else {
                //alert(year + " is a non leap year");
                var year = $('#txtYear').val();
                var start = new Date();
                var End = new Date();
                start = year + '-' + month + '-01';
                End = year + '-' + month + '-28';
            }
        }

    }
    else {
        if (month <= 9) {
            month = "0" + month;
        }
        if (month >= 09) {
            var year = $('#txtYear').val();
            var start = new Date();
            var End = new Date();
            start = year + '-' + month + '-01';
            End = year + '-' + month + '-30';
        } else {
            var year = $('#txtYear').val();
            var start = new Date();
            var End = new Date();
            start = year + '-' + month + '-01';
            End = year + '-' + month + '-31';
        }

    }
    $('#HKeepingResultId tr').each(function () {
        var _index = $(this).index();
        if (_index = 0) {

        } else {
            $('#txtYear').prop("disabled", true);
            $('#txtMonth').prop("disabled", true);
            //for (var i = 0; i <= _index; i++) {
            //    document.getElementById("txtDate_" + i).setAttribute("value", start);
            //    document.getElementById("txtDate_" + i).setAttribute("max", End);
            //    document.getElementById("txtDate_" + i).setAttribute("min", start);
            //    document.getElementById("txtDate_" + i).setAttribute("value", start);
            //    $("#txtDate_" + i).val() = start;
            //}
        }

    });
    return '<tr>' +
        '<td width="10%" style="text-align:center"> <input type="checkbox" value="false" id="Isdeleted_maxindexval" onchange="IsDeleteCheckAll(HKeepingResultId,chkContactDeleteAll)" tabindex="0"></td>' +
        '<td " style="text-align: center; width:30%;" title=""><div><input type="date" id="txtDate_maxindexval" class="form-control "  name="Date" required autocomplete="off" value=' + start + ' min=' + start + ' max=' + End + '><input type="hidden" id="HouseKeepingDetId_maxindexval"/></div></td>' +
        '<td " style="text-align: center;  width:30%;" title=""><div><select   id="txtHousekeepingDone_maxindexval" type="text" class="form-control " name="HousekeepingDone" autocomplete="off"><option value="null">Select</option> </select></div></td>' +
        '<td " style="text-align: center;  width:30%;" title=""><div><input id="txtDateTimeStamp_maxindexval"maxindex="150" type="text" class="form-control" name="DateTimeStamp" disabled autocomplete="off"></div></td>'


}
function HKeepingNewRow() {

    var inputpar = {
        inlineHTML: HKeepingGridHtml(),//Inline Html
        TargetId: "#HKeepingResultId",
        TargetElement: ["tr"]
    }

    AddNewRowToDataGrid(inputpar);


}


function LinkClicked(Id) {
    linkCliked1 = true;
    $(".content").scrollTop(1);
    $('.nav-tabs a:first').tab('show');
    $("#FrmLicense :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    var action = "";
    $('#primaryID').val(Id);
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
        $('.btnDelete').show();
    }

    if (action == 'View') {
        $("#FrmHouse :input:not(:button)").prop("disabled", true);
    } else {
        $('#btnSave').show();
        // $('#btnSave').hide();
        //  $('.btnSave').hide();
        //$('#btnSaveandAddNew').hide();
        $('#btnNextScreenSave').show();
    }
    $('#spnActionType').text(action);
    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0")
        $.get("/api/CentralLinenStoreHKeeping/Get/" + primaryId)
            .done(function (result) {
                var getResult = JSON.parse(result);
                $('#txtStoreType').val(getResult.StoreType);
                // $('#txtCentralCleanLinenStore').val(getResult.LicenseType);
                $('#txtYear').val(getResult.Year);
                $('#txtMonth').val(getResult.Month);
                $('#txtDate_').val(getResult.Date);
                $('#txtHousekeepingDone_').val(getResult.HousekeepingDone);
                $('#txtDateTimeStamp_').val(moment(getResult.DateTimeStamp).format("DD-MMM-YYYY HH:MM"));
                $('#HouseKeepingDetId_').val(getResult.HouseKeepingDetId);
                $('#primaryID').val(getResult.HouseKeepingId);
                if (getResult != null && getResult.LCentralHouseItemGridList != null && getResult.LCentralHouseItemGridList.length > 0) {
                    BindGridData(getResult);
                }

                $('.btnDelete').hide();
                $('.btnEdit').hide();
            })
            .fail(function () {
                $('#myPleaseWait').modal('hide');
                $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
                $('#errorMsg').css('visibility', 'visible');
            });
    $('#txtStoreType').val('').prop('disabled', true);
    $('#txtYear').val('').prop('disabled', true);
    $('#txtMonth').val('').prop('disabled', true);
}



$(".btnDelete").click(function () {
    var ID = $('#primaryID').val();
    confirmDelete(ID);

});
function confirmDelete(ID) {
    var message = Messages.SEARCH_GRID_DELETE_CONFIRMATION;
    var pageId = $('.ui-pg-input').val();
    bootbox.confirm(message, function (result) {
        if (result) {
            $.get("/api/CentralLinenStoreHKeeping/Delete/" + ID)
                .done(function (result) {
                    filterGrid();
                    EmptyFields();
                    $(".content").scrollTop(0);
                    showMessage('LicenseType', CURD_MESSAGE_STATUS.DS);
                    $('#myPleaseWait').modal('hide');
                    EmptyFields();
                })
                .fail(function () {
                    showMessage('LicenseType', CURD_MESSAGE_STATUS.DF);
                    $('#myPleaseWait').modal('hide');
                });
        }

    });
}


function EmptyFields() {
    $(".content").scrollTop(0);
    $('#hdnAttachId').val('');
    $('.btnDelete').hide();
    $("#chkContactDeleteAll").prop("checked", false);
    $('#HKeepingResultId').empty();
    $('#txtStoreType').val('null');
    $('#txtYear').val('null');
    $('#txtMonth').val('null');
    $('#txtStoreType').prop('disabled', false);
    $('#txtYear').prop('disabled', false);
    $('#txtMonth').prop('disabled', false);
    $('#spnActionType').text('Add');
    $('#btnEdit').hide();
    $('#btnNextScreenSave').hide();
    $('#btnSave').show();
    $('#primaryID').val('');
    $("#grid").trigger('reloadGrid');
    $("#FrmHouse :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('#SelStatus').val(1);
    $('#txtCentralCleanLinenStore').val('');
    $('#txtDate_').val('');
    $('#txtHousekeepingDone_').val('');
    $('#txtDateTimeStamp_').val('');
    AddNewRowStkAdjustment();
}

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
////////////////////***********Add rows **************//
$("#chkContactDeleteAll").change(function () {
    var Isdeletebool = this.checked;

    if (this.checked) {
        $('#HKeepingResultId tr').map(function (i) {
            if ($("#Isdeleted_" + i).prop("disabled")) {
                $("#Isdeleted_" + i).prop("checked", false);
            }
            else {
                $("#Isdeleted_" + i).prop("checked", true);
            }
        });
    } else {
        $('#HKeepingResultId tr').map(function (i) {
            $("#Isdeleted_" + i).prop("checked", false);
        });
    }
});
$('#chkContactDeleteAll').on('click', function () {
    var isChecked = $(this).prop("checked");
    $('#HKeepingResultId tr').each(function (index, value) {
        if (isChecked) {
            $('#chkContactDelete_' + index).prop('checked', true);
            $('#chkContactDelete_' + index).parent().addClass('bgDelete');
            $('#txtUserAreaCode_' + index).removeAttr('required');
            $('#txtUserAreaCode_' + index).parent().removeClass('has-error');
        }
        else {
            $('#txtUserAreaCode_' + index).attr('required', true);
            $('#chkContactDelete_' + index).prop('checked', false);
            $('#chkContactDelete_' + index).parent().removeClass('bgDelete');
        }
    });

});
$('#contactBtn').click(function () {

    var rowCount = $('#HKeepingResultId tr:last').index();
    var Date = $('#txtDate_' + rowCount).val();
    var HousekeepingDone = $('#txtHousekeepingDone_' + rowCount).val();
    var DateTimeStamp = $('#txtDateTimeStamp_' + rowCount).val();
    if (DateTimeStamp == '' || DateTimeStamp == null) {
        var today1 = getDate();
        var today = moment();;
        DateTimeStamp = 'test';
        //////var test=today1.getDate();
        //  alert(test);
        $('#txtDateTimeStamp_' + rowCount).val(today1)
    }

    if (rowCount < 0)
        AddNewRowStkAdjustment();
    else if (rowCount >= "0" && (Date == "" || HousekeepingDone == "" || DateTimeStamp == "")) {
        bootbox.alert("Please fill the last record");
    }
    else {
        AddNewRowStkAdjustment();
    }
});

function daysInMonth(month, year) { returnnewDate(year, month, 0).getDate(); }
$('#byear, #bmonth').change(function () {
    if ($('#byear').val().length > 0 && $('#bmonth').val().length > 0) {
        $('#bday').prop('disabled', false);
        $('#bday').find('option').remove();
        var daysInSelectedMonth = daysInMonth($('#bmonth').val(), $('#byear').val());
        for (var i = 1; i <= daysInSelectedMonth; i++) {
            $('#bday').append($("<option></option>").attr("value", i).text(i));
        }
    } else {
        $('#bday').prop('disabled', true);
    }
});


$('#txtMonth').change(function () {
    var month = $('#txtMonth').val();
    if (month % 2 == 0) {
                if (month <= 9) {
                    month = "0" + month;
        }
        if (month >= 09) {
            var year = $('#txtYear').val();
            var start = new Date();
            var End = new Date();
            start = year + '-' + month + '-01';
            End = year + '-' + month + '-31';

        } else {
            var year = $('#txtYear').val();
            var start = new Date();
            var End = new Date();
            start = year + '-' + month + '-01';
            End = year + '-' + month + '-30';
        }
            if (month == 02) {
                if ((0 == year % 4) && (0 != year % 100) || (0 == year % 400)) {
                    // alert(year + " is a leap year");
                    var year = $('#txtYear').val();
                    var start = new Date();
                    var End = new Date();
                    start = year + '-' + month + '-01';
                    End = year + '-' + month + '-29';
                }
                else {
                    //alert(year + " is a non leap year");
                    var year = $('#txtYear').val();
                    var start = new Date();
                    var End = new Date();
                    start = year + '-' + month + '-01';
                    End = year + '-' + month + '-28';
                }
            }
       
    }
    else {
    if (month <= 9) {
        month = "0" + month;
        }
        if (month >= 09) {
            var year = $('#txtYear').val();
            var start = new Date();
            var End = new Date();
            start = year + '-' + month + '-01';
            End = year + '-' + month + '-30';
        } else {
            var year = $('#txtYear').val();
            var start = new Date();
            var End = new Date();
            start = year + '-' + month + '-01';
            End = year + '-' + month + '-31';
        }
    
}

var _index;
$('#HKeepingResultId tr').each(function () {
    _index = $(this).index();
});

for (var i = 0; i <= _index; i++) {
    document.getElementById("txtDate_" + i).setAttribute("value", start);
    document.getElementById("txtDate_" + i).setAttribute("min", start);
    document.getElementById("txtDate_" + i).setAttribute("max", End);
    document.getElementById("txtDate_" + i).setAttribute("value", start);
    $("#txtDate_" + i).val(start);
}
});


//////////////////
