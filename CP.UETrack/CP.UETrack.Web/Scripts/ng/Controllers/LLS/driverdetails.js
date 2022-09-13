$(document).ready(function () {
    window.IssuedByListGlobal = [];
    window.ClassGradeListGlobal = [];
    $('#myPleaseWait').modal('show');
    formInputValidation("FrmDriver");
    $('#btnEdit').hide();
    $('.Submit').show();
    $('.btnDelete').hide();
    $('#btnNextScreenSave').hide();
    //dont erase//
    // $('#txtSerialNo').val('').prop('disabled', true); 
    //
    $('#txtEffectiveTo').val('').prop('disabled', true);

    $.get("/api/DriverDetails/Load")
        .done(function (result) {
            var loadResult = JSON.parse(result);

            $.each(loadResult.LaundryPlant, function (index, value) {
                $('#txtLaundryPlant').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            window.ClassGradeListGlobal = loadResult.ClassGrade;
            window.IssuedByListGlobal = loadResult.IssuedBy;
            AddFirstGridRow();
        })
        .fail(function () {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
        });

});

$(".Submit,.Edit").click(function () {
    $('#btnlogin').attr('disabled', true);
    $('#myPleaseWait').modal('show');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    //$('#txtSerialNo').attr('required', true);
    $('#txtLaundryPlant').attr('required', true);
    $('#txtstatus').attr('required', true);
    $('#txtEffectiveFrom').attr('required', true);
    $('#txtDriverName').attr('required', true);
    $('#txtLocationCode_').attr('required', true);
    $('#txtClassGrade_').attr('required', true);
    $('#txtIssuedDate_').attr('required', true);
    $('#txtExpiryDate_').attr('required', true);

    //first grid 

    var _index;        // var _indexThird;
    var result = [];
    $('#ContactGrid tr').each(function () {
        _index = $(this).index();
    });
    for (var i = 0; i <= _index; i++) {
        var active = true;

        var _tempObj = {
            DriverDetId: $('#DriverDetId_' + i).val(),
            LicenseTypeDetId: $('#LocationCodeId_' + i).val(),
            LicenseCode: $('#txtLocationCode_' + i).val(),
            LicenseDescription: $('#txtLicenseDescription_' + i).val(),
            LicenseNo: $('#txtLicenseNo_' + i).val(),
            ClassGrades: $('#txtClassGrade_' + i).val(),
            IsssuedBy: $('#txtIssuedBy_' + i).val(),
            IssuedDate: $('#txtIssuedDate_' + i).val(),
            ExpiryDate: $('#txtExpiryDate_' + i).val(),
            IsDeleted: chkIsDeletedRow(i, $('#Isdeleted_' + i).is(":checked")),
        };
        if (_tempObj.ExpiryDate == " " || _tempObj.ExpiryDate == "") {
            _tempObj.ExpiryDate = null;
        }
        var CurrDate = new Date();

        var stDt = _tempObj.IssuedDate;
        var endDt = _tempObj.ExpiryDate;

        stDt = Date.parse(stDt);
        if (endDt != "") {
            endDt = Date.parse(endDt);
        }

        if (endDt != null) {
            if (endDt != "" && endDt < stDt) {
                $("div.errormsgcenter").text("Expiry Date should be greater than Issued Date");
                $('#errorMsg').css('visibility', 'visible');
                $('#myPleaseWait').modal('hide');
                return false;
            }
        }


        result.push(_tempObj);
    }

    var CurrentbtnID = $(this).attr("value");
    var timeStamp = $("#Timestamp").val();

    var isFormValid = formInputValidation("FrmDriver", 'save');
    if (!isFormValid) {
        $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        $('#errorMsg').css('visibility', 'visible');
        $('#btnlogin').attr('disabled', false);
        $('#myPleaseWait').modal('hide');
        return false;
    }

    var MstDriver = {
        DriverCode: $('#txtSerialNo').val(),
        LaundryPlantId: $('#txtLaundryPlant').val(),
        DriverName: $('#txtDriverName').val(),
        Status: $("#txtstatus option:selected").val(),
        EffectiveFrom: $('#txtEffectiveFrom').val(),
        EffectiveTo: $('#txtEffectiveTo').val(),
        ContactNo: $('#txtContactNo').val(),
        ICNo: $('#txticNo').val(),
        LDriverDetailsLinenItemGridList: result,
    };

    function chkIsDeletedRow(i, delrec) {
        if (delrec == true) {
            $('#txtLocationCode_' + i).prop("required", false);
            $('#FWDescription_' + i).prop("required", false);
            $('#txtLicenseNo_' + i).prop("required", false);
            $('#txtClassGrade_' + i).prop("required", false);
            $('#txtIssuedBy_' + i).prop("required", false);
            $('#txtIssuedDate_' + i).prop("required", false);
            $('#txtExpiryDate_' + i).prop("required", false);
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
        MstDriver.DriverId = primaryId;
        MstDriver.Timestamp = timeStamp;
    }
    else {
        MstDriver.DriverId = 0;
        MstDriver.Timestamp = "";
    }
  
    var jqxhr = $.post("/api/DriverDetails/Save", MstDriver, function (response) {
        var result = JSON.parse(response);
        $("#primaryID").val(result.DriverId);
        if (result != null && result.LDriverDetailsLinenItemGridList != null && result.LDriverDetailsLinenItemGridList.length > 0) {
            BindSecondGridData(result);
        }
        $("#Timestamp").val(result.Timestamp);
        $("#grid").trigger('reloadGrid');
        if (result.DriverId != 0) {
            $('#txtSerialNo').prop('disabled', true);
            $('#txtLaundryPlant').prop('disabled', true);
            $('#txtEffectiveFrom').prop('disabled', true);
            $('#txtDriverName').prop('disabled', true);
            $('#hdnAttachId').val(result.HiddenId);
            $('#btnEdit').show();
            $('.Submit').show();
            $('.btnDelete').hide();
        }
        $(".content").scrollTop(0);
        showMessage('DriverDetails', CURD_MESSAGE_STATUS.SS);
        $("#top-notifications").modal('show');
        setTimeout(function () {
            $("#top-notifications").modal('hide');
        }, 5000);

        $('.Submit').attr('disabled', false);
        if (CurrentbtnID == "1") {
            EmptyFields();
        }
        $('.btnDelete').hide();
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

            $('.Submit').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
        });
    //}
});
//************************************************ Getbyid bind data *************************

function BindSecondGridData(getResult) {
    var ActionType = $('#ActionType').val();
    $("#ContactGrid").empty();
    $.each(getResult.LDriverDetailsLinenItemGridList, function (index, value) {
        AddFirstGridRow();
        $("#DriverDetId_" + index).val(getResult.LDriverDetailsLinenItemGridList[index].DriverDetId);
        $("#LocationCodeId_" + index).val(getResult.LDriverDetailsLinenItemGridList[index].LicenseTypeDetId);
        $("#hdnLinenItemID" + index).val(getResult.LDriverDetailsLinenItemGridList[index].LinenItemId);
        $("#txtLocationCode_" + index).val(getResult.LDriverDetailsLinenItemGridList[index].LicenseCode);
        $("#txtLicenseDescription_" + index).val(getResult.LDriverDetailsLinenItemGridList[index].LicenseDescription);
        $("#txtLicenseNo_" + index).val(getResult.LDriverDetailsLinenItemGridList[index].LicenseNo);
        $("#txtClassGrade_" + index).val(getResult.LDriverDetailsLinenItemGridList[index].ClassGrades);
        $("#txtIssuedBy_" + index).val(getResult.LDriverDetailsLinenItemGridList[index].IsssuedBy);
        $("#txtIssuedDate_" + index).val(moment(getResult.LDriverDetailsLinenItemGridList[index].IssuedDate).format("DD-MMM-YYYY"));
        $("#txtExpiryDate_" + index).val(moment(getResult.LDriverDetailsLinenItemGridList[index].ExpiryDate).format("DD-MMM-YYYY"));

        linkCliked2 = true;
        $("#chk_FacWorkIsDelete").prop("checked", false);
        $(".content").scrollTop(0);
    });

    //************************************************ Grid Pagination *******************************************

    if ((getResult.LDriverDetailsLinenItemGridList && getResult.LDriverDetailsLinenItemGridList.length) > 0) {
        GridtotalRecords = getResult.LDriverDetailsLinenItemGridList[0].TotalRecords;
        TotalPages = getResult.LDriverDetailsLinenItemGridList[0].TotalPages;
        LastRecord = getResult.LDriverDetailsLinenItemGridList[0].LastRecord;
        FirstRecord = getResult.LDriverDetailsLinenItemGridList[0].FirstRecord;
        pageindex = getResult.LDriverDetailsLinenItemGridList[0].PageIndex;
        linkCliked2 = true;
        $(".content").scrollTop(0);
    }
    $('#paginationfooter').show();


    //************************************************ End *******************************************************
}

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
function FetchLocationCode(event, index) {
    $('#divLocationCodeFetch_' + index).css({
        'top': $('#txtLocationCode_' + index).offset().top - $('#DriverdetailList').offset().top + $('#txtLocationCode_' + index).innerHeight(),
    });
    var LinenFetchObj = {
        SearchColumn: 'txtLocationCode_' + index + '-LicenseCode',//Id of Fetch field
        ResultColumns: ["LicenseTypeDetId-Primary Key", 'LicenseCode-License Code', 'LicenseDescription-License Description'],
        FieldsToBeFilled: ["LocationCodeId_" + index + "-LicenseTypeDetId", 'txtLocationCode_' + index + '-LicenseCode', 'txtLicenseDescription_' + index + '-LicenseDescription']
    };
    var UserAreaCode = $('#hdnUserAreaId').val();
    DisplayLocationCodeFetchResult('divLocationCodeFetch_' + index, LinenFetchObj, "/api/Fetch/DriverDetailsMstDet_FetchLicenseCode", "UlFetch1" + index + "", event, 1, UserAreaCode);//1 -- pageIndex
}


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


function LinkClicked(DriverId) {
    linkCliked1 = true;
    $(".content").scrollTop(1);
    $('.nav-tabs a:first').tab('show');
    $("#FrmDriver :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    var action = "";
    $('#primaryID').val(DriverId);
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
        $('.btnDelete').hide();
    }

    if (action == 'View') {
        $("#FrmDriver :input:not(:button)").prop("disabled", true);
    } else {
        $('#btnEdit').show();
        $('.Submit').hide();
        $('#btnNextScreenSave').show();
    }
    $('#spnActionType').text(action);
    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/DriverDetails/Get/" + primaryId)
            .done(function (result) {
                var getResult = JSON.parse(result);
                $('#txtSerialNo').val(getResult.DriverCode).attr('disabled', true);
                $('#txtLaundryPlant').val(getResult.LaundryPlantName);
                $('#txtstatus').val(getResult.Status);
                $('#txtDriverName').val(getResult.DriverName);
                $('#txtEffectiveFrom').val(moment(getResult.EffectiveFrom).format("DD-MMM-YYYY"));
                if (getResult.Status != 1) {
                    $('#txtEffectiveTo').val(moment(getResult.EffectiveTo).format("DD-MMM-YYYY")).prop("disabled", true);
                }
                else {
                    $('#txtEffectiveTo').prop("disabled", true);
                }
                $('#txtContactNo').val(getResult.ContactNo);
                $('#txticNo').val(getResult.ICNo);
                $('#primaryID').val(getResult.DriverId);
                $('#hdnStatus').val(getResult.Active);
                $('#txtLicenseCode').val(getResult.LicenseCode);
                $('#txtLicenseDescription').val(getResult.LicenseDescription);
                $('#txtLicenseNo').val(getResult.LicenseNo);
                $('#txtClassGrade').val(getResult.ClassGrade);
                $('#txtIssuedBy').val(getResult.IssuedBy);
                $('#txtIssuedDate').val(getResult.IssuedDate);
                $('#txtExpiryDate').val(getResult.ExpiryDate);
                $('#hdnAttachId').val(getResult.HiddenId);
                $('.btnDelete').hide();
                $('.Submit').show();
                $('.Edit').hide();
                $('#myPleaseWait').modal('hide');

                if (getResult != null && getResult.LDriverDetailsLinenItemGridList != null && getResult.LDriverDetailsLinenItemGridList.length > 0) {
                    BindSecondGridData(getResult);
                }
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


$(".btnDelete").click(function () {
    var ID = $('#primaryID').val();
    confirmDelete(ID);

});
function confirmDelete(ID) {
    var message = Messages.SEARCH_GRID_DELETE_CONFIRMATION;
    var pageId = $('.ui-pg-input').val();
    bootbox.confirm(message, function (result) {
        if (result) {
            $.get("/api/DriverDetails/Delete/" + ID)
                .done(function (result) {
                    debugger;
                    filterGrid();
                    $(".content").scrollTop(0);
                    showMessage('Driver Details', CURD_MESSAGE_STATUS.DS);
                    $('#myPleaseWait').modal('hide');
                    EmptyFields();
                })
                .fail(function () {
                    showMessage('Driver Details', CURD_MESSAGE_STATUS.DF);
                    $('#myPleaseWait').modal('hide');
                });
        }

    });
}
$("#btnNextScreenSave").click(function () {
    var primaryId = $("#primaryID").val();

    var hdnStatus = $("#hdnStatus").val();

    if (hdnStatus == 0 || hdnStatus == '0') {
        bootbox.alert('Only Active Driverdetails can be navigated to Level Screen');

    }
    else if (primaryId != null && primaryId != 0 && primaryId != "0" && primaryId != '') {
        var msg = 'Do you want to proceed to Level screen?'
        bootbox.confirm(msg, function (Conform) {
            if (Conform) {
                window.location.href = "/bems/Level/Add/" + primaryId;
            }
            else {
                bootbox.hideAll();
                return false;
            }
        });
    }

});

function EmptyFields() {
    $('#ContactGrid').empty();
    $(".content").scrollTop(0);
    $('#hdnAttachId').val('');
    $('.btnDelete').hide();
    $("#chk_FacWorkIsDelete").prop("checked", false);
    $('#txtSerialNo').val('').prop('disabled', false);
    $('#txtLaundryPlant').val('null').prop('disabled', false);
    $('#txtStatus').val('1').prop('disabled', false);
    $('#txtDriverName').val('').prop('disabled', false);
    $('#txtEffectiveFrom').val('').prop('disabled', false);
    $('txtContactNo').val('').prop('disabled', false);
    $('#txtEffectiveTo').val('').prop('disabled', false);
    $('#txtContactNo').val('').prop('disabled', false);
    $('#txticNo').val('').prop('disabled', false);
    $('#txtLocationCode_').val('');
    $('#spnActionType').text('Add');
    $('#btnEdit').hide();
    $('#btnNextScreenSave').hide();
    $('.Submit').show();
    $('#primaryID').val('');
    $("#grid").trigger('reloadGrid');
    $("#FrmDriver :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('#SelStatus').val(1);
    AddFirstGridRow();
}

$("#jQGridCollapse1").click(function () {
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
$('#contactBtn').click(function () {

    var rowCount = $('#ContactGrid tr:last').index();
    var LicenseCode = $('#txtLicenseCode_' + rowCount).val();
    var LicenseNo = $('#txtLicenseNo_' + rowCount).val();
    var ClassGrade = $('#txtClassGrade_' + rowCount).val();
    var IssuedDate = $('#txtIssuedDate_' + rowCount).val();
    var ExpiryDate = $('#txtExpiryDate_' + rowCount).val();

    if (rowCount < 0)
        AddFirstGridRow();
    else if (rowCount >= "0" && (LicenseCode == "" || LicenseNo == "" || ClassGrade == "" || IssuedDate == "" || ExpiryDate == "")) {
        bootbox.alert("Please fill the last record");
    }
    else {
        AddFirstGridRow();
    }
});


$("#chkContactDeleteAll").change(function () {
    var Isdeletebool = this.checked;

    if (this.checked) {
        $('#ContactGrid tr').map(function (i) {
            if ($("#Isdeleted_" + i).prop("disabled")) {
                $("#Isdeleted_" + i).prop("checked", false);
            }
            else {
                $("#Isdeleted_" + i).prop("checked", true);
            }
        });
    } else {
        $('#ContactGrid tr').map(function (i) {
            $("#Isdeleted_" + i).prop("checked", false);
        });
    }
});
var linkCliked1 = false;
window.AddFirstGridRow = function () {
    $('#chkContactDeleteAll').prop('checked', false);
    var inputpar = {
        inlineHTML: '<tr class="ng-scope" style=""> ' +
            '<td width="5%" style="text-align:center"> <input type="checkbox" value="false" id="Isdeleted_maxindexval" onchange="IsDeleteCheckAll(ContactGrid,chkContactDeleteAll)" tabindex="0"></td>' +
            //'<td width="15%" style="text-align: center;"><div><input type="text" id="txtLicenseCode_maxindexval" name="LicenseCode" maxlength="50" onkeyup="FetchLocationCode(event,maxindexval)" onpaste="FetchLocationCode(event,maxindexval)" change="FetchLocationCode(event,maxindexval)"oninput="FetchLocationCode(event,maxindexval)" class="form-control" autocomplete="off" tabindex="0" required placeholder="Please Select"><input type="hidden" id="LocationCodeId_maxindexval"/><input type="hidden" id="LocationCodeUpdateDetId_maxindexval"/> <input type="hidden" id="hdnLinenItemID_maxindexval" value=0><div class="col-sm-12" id="divLocationCodeFetch_maxindexval"></div > </div></td>< td width="15%" style="text-align: center;" > <div> ' +
            '<td width="15%" style="text-align: center;"><div><input type="text" id="txtLocationCode_maxindexval" required name="LocationCode" maxlength="50" onkeyup="FetchLocationCode(event,maxindexval)" onpaste="FetchLocationCode(event,maxindexval)" change="FetchLocationCode(event,maxindexval)" oninput="FetchLocationCode(event,maxindexval)" class="form-control" autocomplete="off" tabindex="0" required placeholder="Please Select"><input type="hidden" id="LicenseTypeDetId_maxindexval"/><input type="hidden" required id="LocationCodeId_maxindexval"/><input type="hidden" id="LocationCodeUpdateDetId_maxindexval"/><input type="hidden" id="DriverDetId_maxindexval" vaule=0> <input type="hidden" id="hdnLinenItemID_maxindexval" value=0><div class="col-sm-12" id="divLocationCodeFetch_maxindexval"></div > </div></td>< td width="15%" style="text-align: center;" > <div> ' +
            '<td width="15%" style="text-align: center;"><div><input type="text" id="txtLicenseDescription_maxindexval" name="LicenseDescription" maxlength="50"  class="form-control" autocomplete="off" tabindex="0" disabled ></div></td><div> ' +
            '<td width="15%" style="text-align: center;"><div><input type="text" id="txtLicenseNo_maxindexval" name="LicenseNo" maxlength="50"  class="form-control" autocomplete="off" tabindex="0" required ></div></td><div> ' +
            '<td width="15%" style="text-align: center;"><div><select id="txtClassGrade_maxindexval"  class="form-control" required><option value="null">Select</option></select><div> </td><div>' +
            '<td width="15%" style="text-align: center;"><div><select id="txtIssuedBy_maxindexval"  class="form-control"><option value=null class="active">Select</option></select><div> </td><div>' +
            '<td width="10%" style="text-align: center;"><div><input type="text" id="txtIssuedDate_maxindexval" name="IssuedDate" maxlength="50"  class="form-control datetimePastOnly"  autocomplete="off" tabindex="0" required ></div></td><div> ' +
            '<td width="10%" style="text-align: center;"><div><input type="text" id="txtExpiryDate_maxindexval"  name="ExpiryDate" maxlength="50"  class="form-control datetime"  autocomplete="off" tabindex="0" required ></div></td><div> ',
        IdPlaceholderused: "maxindexval",
        TargetId: "#ContactGrid",
        TargetElement: ["tr"]
    }
    AddNewRowToDataGrid(inputpar);
    $("select[id^='txtLicenseCode_']").attr('pattern', '^[a-zA-Z0-9./\\(\\),\\-\\s]+$');
    $("input[id^='txtLicenseDescription_']").attr('pattern', '^[a-zA-Z0-9./\\(\\),\\-\\s]+$');
    $("input[id^='txtLicenseNo_']").attr('pattern', '^[0-9\\(\\)\\-\\+]+$');
    $("input[id^='txtClassGrade_']").attr('pattern', '^[a-zA-Z0-9./\\(\\),\\-\\s]+$');
    $("input[id^='txtIssuedBy_']").attr('pattern', '^[a-zA-Z./\\(\\),\\-\\s]+$');
    $("select[id^='txtIssuedDate_']").attr('pattern', '^[a-zA-Z0-9./\\(\\),\\-\\s]+$');
    $("select[id^='txtExpiryDate_']").attr('pattern', '^[a-zA-Z0-9./\\(\\),\\-\\s]+$');

    if (!linkCliked1) {
        $('#ContactGrid tr:last td:first input').focus();
    }
    else {
        linkCliked1 = false;
    }

    var rowCount = $('#ContactGrid tr:last').index();
    $.each(window.ClassGradeListGlobal, function (index, value) {
        $('#txtClassGrade_' + rowCount).append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
    });
    $.each(window.IssuedByListGlobal, function (index, value) {
        $('#txtIssuedBy_' + rowCount).append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
    });
    formInputValidation("FrmDriver");

}
////////////////////*********** End Add rows **************//