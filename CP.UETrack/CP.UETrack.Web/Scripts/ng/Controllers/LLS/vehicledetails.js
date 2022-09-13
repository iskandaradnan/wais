$(document).ready(function () {
    window.IssuedByListGlobal = [];
    window.ClassGradeListGlobal = [];
    formInputValidation("FrmVec");
    $('#btnEdit').hide(); 
    $('.btnDelete').hide();
    $('#btnNextScreenSave').hide();
    $('#txtEffectiveTo').val('').prop('disabled', true);
    $.get("/api/VechileDetails/Load")
        .done(function (result) {
            var loadResult = JSON.parse(result);
            $.each(loadResult.Manufacturer, function (index, value) {
                $('#txtManufacturer').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $.each(loadResult.LaundryPlantName, function (index, value) {
                $('#txtLaundryPlant').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $.each(loadResult.Status, function (index, value) {
                $('#txtStatus').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
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
    $(".Save,.Edit").click(function () {       
        $('#btnlogin').attr('disabled', true);
        $('#myPleaseWait').modal('show');
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
        $('#txtVehicleNo').attr('required', true);
        $('#txtManufacturer').attr('required', true);
        $('#txtLaundryPlant').attr('required', true);
        $('#SelStatus').attr('required', true);
        $('#txtEffectiveFrom').attr('required', true);
        $('#txtDriverName').attr('required', true);
        $('#txtLinenCode_').attr('required', true);
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
                VehicleDetId: $('#VehicleDetId_' + i).val(),
                LicenseTypeDetId: $('#LocationCodeId_' + i).val(),
                LicenseCode: $('#txtLicenseCode_' + i).val(),
                //LicenseTypeDetId: $('#LicenseTypeDetId_' + i).val(),
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

        var isFormValid = formInputValidation("FrmVec", 'save');
        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
            $('#btnlogin').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            return false;
        }


        var MstVechile = {
            VehicleNo: $('#txtVehicleNo').val(),
            LaundryPlantId: $('#txtLaundryPlant').val(),
            Model: $('#txtModel').val(),
            Manufacturer: $('#txtManufacturer').val(),
            Status: $("#SelStatus option:selected").val(),
            EffectiveFrom: $('#txtEffectiveFrom').val(),
            EffectiveTo: $('#txtEffectiveTo').val(),
            LoadWeight: $('#txtLoadWeightBDM').val(),
            LVehicleDetailsLinenItemGridList: result
        };
        function chkIsDeletedRow(i, delrec) {
            if (delrec == true) {
                $('#txtLinenCode_' + i).prop("required", false);
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
            MstVechile.VehicleId = primaryId;
            MstVechile.Timestamp = timeStamp;
        }
        else {
            MstVechile.VehicleId = 0;
            MstVechile.Timestamp = "";
        }
       
        var jqxhr = $.post("/api/VechileDetails/Save", MstVechile, function (response) {
            var result = JSON.parse(response);
            $("#primaryID").val(result.VehicleId);
            $('#SelStatus option[value="' + result.Active + '"]').prop('selected', true);
            if (result != null && result.LVehicleDetailsLinenItemGridList != null && result.LVehicleDetailsLinenItemGridList.length > 0) {
                BindSecondGridData(result);
            }
            $("#Timestamp").val(result.Timestamp);
            $("#grid").trigger('reloadGrid');
            if (result.VehicleId != 0) {
                $('#hdnAttachId').val(result.HiddenId);
                $('#txtVehicleNo').prop('disabled', true); 
                $('#txtManufacturer').prop('disabled', true); 
                $('#txtLaundryPlant').prop('disabled', true); 
                $('#ContactGrid').prop('disabled',true);
                $('#txtEffectiveFrom').prop('disabled', true); 
                $('#txtDriverName').attr('required', true);
                
                $('#btnNextScreenSave').show();
                $('#btnEdit').show();
                $('.Save').show();
                $('.btnDelete').show();
            }
            $(".content").scrollTop(0);
            showMessage('DriverDetails', CURD_MESSAGE_STATUS.SS);
            $("#top-notifications").modal('show');
            setTimeout(function () {
                $("#top-notifications").modal('hide');
            }, 5000);

            $('.Save').attr('disabled', false);
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
                $('.Save').attr('disabled', false);
                $('#myPleaseWait').modal('hide');
            });
    });
$("#chk_FacWorkIsDelete").change(function () {
    var Isdeletebool = this.checked;

    if (this.checked) {
        $('#FacilityWorkshopTbl tr').map(function (i) {
            if ($("#Isdeleted_" + i).prop("disabled")) {
                $("#Isdeleted_" + i).prop("checked", false);
            }
            else {
                $("#Isdeleted_" + i).prop("checked", true);
            }
        });
    } else {
        $('#FacilityWorkshopTbl tr').map(function (i) {
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

     $("#jQGridCollapse1").click(function () {
        var pro = new Promise(function (res, err) {
        $(".jqContainer").toggleClass("hide_container");
        res(1);
    })
    pro.then(
        function resposes() {
            setTimeout(() => $(".content").scrollTop(3000), 1);

        })
});

function FetchLinenCode(event, index) {
    $('#divLinenCodeFetch_' + index).css({
        'top': $('#txtLinenCode_' + index).offset().top - $('#VehicleList').offset().top + $('#txtLinenCode_' + index).innerHeight(),
    });
    var LinenFetchObj = {
        SearchColumn: 'txtLinenCode_' + index + '-LicenseCode',//Id of Fetch field
        ResultColumns: ["LicenseTypeDetId-Primary Key", 'LicenseCode-License Code', 'LicenseDescription-LicenseDescription'],
        FieldsToBeFilled: ["LocationCodeId_" + index + "-LicenseTypeDetId", 'txtLinenCode_' + index + '-LicenseCode', 'txtLicenseDescription_' + index + '-LicenseDescription']
    };

    DisplayFetchResult('divLinenCodeFetch_' + index, LinenFetchObj, "/api/Fetch/VehicleDetailsMstDet_FetchLicenseCode", "UlFetch1" + index + "", event, 1);//1 -- pageIndex
}
    //************************************************ Getbyid bind data *************************

function BindSecondGridData(getResult) {
        var ActionType = $('#ActionType').val();
        $("#ContactGrid").empty();
        $.each(getResult.LVehicleDetailsLinenItemGridList, function (index, value) {
            AddFirstGridRow();
            $("#VehicleDetId_" + index).val(getResult.LVehicleDetailsLinenItemGridList[index].VehicleDetId);
            $("#LocationCodeId_" + index).val(getResult.LVehicleDetailsLinenItemGridList[index].LicenseTypeDetId);
            //$("#hdnLinenItemID" + index).val(getResult.LVehicleDetailsLinenItemGridList[index].LinenItemId);
            $("#txtLinenCode_" + index).val(getResult.LVehicleDetailsLinenItemGridList[index].LicenseCode);
            $("#txtLicenseDescription_" + index).val(getResult.LVehicleDetailsLinenItemGridList[index].LicenseDescription);
            $("#txtLicenseNo_" + index).val(getResult.LVehicleDetailsLinenItemGridList[index].LicenseNo);
            $("#txtClassGrade_" + index).val(getResult.LVehicleDetailsLinenItemGridList[index].ClassGrades);
            $("#txtIssuedBy_" + index).val(getResult.LVehicleDetailsLinenItemGridList[index].IsssuedBy);
            $("#txtIssuedDate_" + index).val(moment(getResult.LVehicleDetailsLinenItemGridList[index].IssuedDate).format("DD-MMM-YYYY"));
            $("#txtExpiryDate_" + index).val(moment(getResult.LVehicleDetailsLinenItemGridList[index].ExpiryDate).format("DD-MMM-YYYY"));
            linkCliked2 = true;
            $("#chkContactDeleteAll").prop("checked", false);
            $(".content").scrollTop(0);
        });

        //************************************************ Grid Pagination *******************************************

        if ((getResult.LVehicleDetailsLinenItemGridList && getResult.LVehicleDetailsLinenItemGridList.length) > 0) {
            GridtotalRecords = getResult.LVehicleDetailsLinenItemGridList[0].TotalRecords;
            TotalPages = getResult.LVehicleDetailsLinenItemGridList[0].TotalPages;
            LastRecord = getResult.LVehicleDetailsLinenItemGridList[0].LastRecord;
            FirstRecord = getResult.LVehicleDetailsLinenItemGridList[0].FirstRecord;
            pageindex = getResult.LVehicleDetailsLinenItemGridList[0].PageIndex;
            linkCliked2 = true;
            $(".content").scrollTop(0);
        }
        $('#paginationfooter').show();
        //************************************************ End *******************************************************
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
function LinkClicked(VehicleId) {
    linkCliked1 = true;
    $(".content").scrollTop(1);
    $('.nav-tabs a:first').tab('show');
    $("#FrmVec :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    var action = "";
    $('#primaryID').val(VehicleId);
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
        $("#FrmVec :input:not(:button)").prop("disabled", true);
    } else {
        $('#btnEdit').show();
        $('.Save').hide();
        //$('.SaveandAddNew').hide();
        $('#btnNextScreenSave').show();
    }
    $('#spnActionType').text(action);

    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/VechileDetails/Get/" + primaryId)
            .done(function (result) {
                var getResult = JSON.parse(result);
                $('#txtVehicleNo').val(getResult.VehicleNo).attr('disabled', true);
                $('#txtModel').val(getResult.Model);
                $('#txtManufacturer').val(getResult.Manufacturer);
                //$('#txtLaundryPlant').val(getResult.LaundryPlantId);
                $('#SelStatus').val(getResult.Status);
                $('#txtLaundryPlant').val(getResult.LaundryPlantName);
                //$('#SelStatus option[value="' + getResult.Active + '"]').prop('selected', true);
                //$('#txtStoreType').val(getResult.Manufacturer);
                $('#txtEffectiveFrom').val(moment(getResult.EffectiveFrom).format("DD-MMM-YYYY"));
                if (getResult.Status != 1) {
                    $('#txtEffectiveTo').val(moment(getResult.EffectiveTo).format("DD-MMM-YYYY")).prop("disabled", true);
                }
                else {
                    $('#txtEffectiveTo').prop("disabled", true);
                }
                $('#txtLoadWeightBDM').val(getResult.LoadWeight);
                //$('#txtLoadWeightBDM').val(getResult.Model);
                $('#primaryID').val(getResult.VehicleId);
                $('#hdnStatus').val(getResult.Active);
                $('#hdnAttachId').val(getResult.HiddenId);
                $('.btnDelete').show();
                $('.Save').show();
                $('.Edit').hide();
                $('.btnDelete').hide();
                $('#myPleaseWait').modal('hide');

             
                if (getResult != null && getResult.LVehicleDetailsLinenItemGridList != null && getResult.LVehicleDetailsLinenItemGridList.length > 0) {
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
            $.get("/api/VechileDetails/Delete/" + ID)
                .done(function (result) {
                    filterGrid();
                    $(".content").scrollTop(0);
                    showMessage('VechileDetails', CURD_MESSAGE_STATUS.DS);
                    $('#myPleaseWait').modal('hide');
                    EmptyFields();
                })
                .fail(function () {
                    showMessage('VechileDetails', CURD_MESSAGE_STATUS.DF);
                    $('#myPleaseWait').modal('hide');
                });
        }

    });
}
$("#btnNextScreenSave").click(function () {
    var primaryId = $("#primaryID").val();

    var hdnStatus = $("#hdnStatus").val();

    if (hdnStatus == 0 || hdnStatus == '0') {
        bootbox.alert('Only Active VechileDetails can be navigated to Level Screen');

    }
    else if (primaryId != null && primaryId != 0 && primaryId != "0" && primaryId != '') {
        var msg = 'Do you want to proceed to Level screen?'
        bootbox.confirm(msg, function (Conform) {
            if (Conform) {
                window.location.href = "/LLS/Level/Add/" + primaryId;
            }
            else {
                bootbox.hideAll();
                return false;
            }
        });
    }

});

function EmptyFields() {
    $(".content").scrollTop(0);
    $('#hdnAttachId').val('');
    $('.btnDelete').hide();
    $('#ContactGrid').empty();
    $("#chkContactDeleteAll").prop("checked", false);
    $('#txtVehicleNo').val('').prop('disabled', false);
    $('#txtModel').val('').prop('disabled', false);
    $('#txtLaundryPlant').val('null').prop('disabled', false);
    $('#txtStatus').val('1').prop('disabled', false);
    $('#txtManufacturer').val('null').prop('disabled', false);
    $('#txtEffectiveFrom').val('').prop('disabled', false);
    $('#txtEffectiveTo').val('').prop('disabled', false);
    $('#txtLoadWeightBDM').val('').prop('disabled', false);
    $('#spnActionType').text('Add');
    $('#btnEdit').hide();
    $('#btnNextScreenSave').hide();
    $('.Save').show();
    $('#primaryID').val('');
    $("#grid").trigger('reloadGrid');
    $("#FrmVec :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('#SelStatus').val(1);
    $('#txtVehicleNo').prop('disabled', false); 
    $('#txtEffectiveTo').prop('disabled', false);
    AddFirstGridRow();
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
$('#contactBtn').click(function () {

    var rowCount = $('#ContactGrid tr:last').index();
    var LicenseCode_ = $('#txtLicenseCode_' + rowCount).val();
    var LicenseNo = $('#txtLicenseNo_' + rowCount).val();
    var ClassGrade = $('#txtClassGrade_' + rowCount).val();
    var IssuedDate = $('#txtIssuedDate_' + rowCount).val();
    var ExpiryDate = $('#txtExpiryDate_' + rowCount).val();


    if (rowCount < 0)
        AddFirstGridRow();
    else if (rowCount >= "0" && (LicenseCode_ == "" || LicenseNo == "" || ClassGrade == "" || IssuedDate == "" || ExpiryDate == "")) {
        bootbox.alert("Please fill the last record");
    }
    else {
        AddFirstGridRow();
    }
});
$('#chkContactDeleteAll').on('click', function () {
    var isChecked = $(this).prop("checked");
    //var index1; $('#chkContactDeleteAll').prop('checked', true);
    // var count = 0;
    $('#ContactGrid tr').each(function (index, value) {
        // if (index == 0) return;
        // index1 = index - 1;
        if (isChecked) {
            // if(!$('#chkContactDelete_' +index1).prop('disabled'))
            // {
            $('#chkContactDelete_' + index).prop('checked', true);
            $('#chkContactDelete_' + index).parent().addClass('bgDelete');
            $('#txtLicenseCode_' + index).removeAttr('required');
            $('#txtLicenseCode_' + index).parent().removeClass('has-error');
            // count++;
            //  }
        }
        else {
            //if(!$('#chkContactDelete_' +index1).prop('disabled'))
            //{
            $('#txtLicenseCode_' + index).attr('required', true);
            $('#chkContactDelete_' + index).prop('checked', false);
            $('#chkContactDelete_' + index).parent().removeClass('bgDelete');
            // }
        }
    });
    //if(count == 0){
    //    $(this).prop("checked", false);
    //}
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
            '<td width="5%" style="text-align:center"><input type="checkbox" value="false" id="Isdeleted_maxindexval" onchange="IsDeleteCheckAll(ContactGrid,chkContactDeleteAll)" tabindex="0"></td>' +
            //'<td width="15%" style="text-align: center;"><div><input type="text" id="txtLicenseCode_maxindexval" name="LicenseCode" maxlength="50"  class="form-control" autocomplete="off" tabindex="0" placeholder="please select" ></div></td><div> ' +
            '<td width="15%" style="text-align: center;"><div><input type="text" id="txtLinenCode_maxindexval" required name="LinenCode" maxlength="50" onkeyup="FetchLinenCode(event,maxindexval)" onpaste="FetchLinenCode(event,maxindexval)" change="FetchLinenCode(event,maxindexval)" oninput="FetchLinenCode(event,maxindexval)"  class="form-control" autocomplete="off" tabindex="0" required  placeholder="Please Select"><input type="hidden" id="LicenseTypeDetId_maxindexval"/><input type="hidden" id="LocationCodeId_maxindexval" required/><input type="hidden" id="VehicleDetId_maxindexval"/><input type="hidden" id="LinenCodeId_maxindexval"/><input type="hidden" id="LinenCodeUpdateDetId_maxindexval"/><div class="col-sm-12" id="divLinenCodeFetch_maxindexval"></div > </div></td>< td width="15%" style="text-align: center;" > <div> ' +
            '<td width="15%" style="text-align: center;"><div><input type="text" id="txtLicenseDescription_maxindexval" name="LicenseDescription" maxlength="50"  class="form-control" autocomplete="off" tabindex="0" disabled ></div></td><div> ' +
            '<td width="15%" style="text-align: center;"><div><input type="text" id="txtLicenseNo_maxindexval" name="LicenseNo" maxlength="50"  class="form-control" autocomplete="off" tabindex="0" required ></div></td><div> ' +
            '<td width="15%" style="text-align: center;"><div><select id="txtClassGrade_maxindexval"  class="form-control" required><option value="null" required>Select</option></select><div> </td><div>' +
            '<td width="15%" style="text-align: center;"><div><select id="txtIssuedBy_maxindexval"  class="form-control" ><option value="null">Select</option></select><div> </td><div>' +
            '<td width="10%" style="text-align: center;"><div><input type="text" id="txtIssuedDate_maxindexval" name="IssuedDate" maxlength="50"  class="form-control datetimePastOnly" autocomplete="off" tabindex="0" required ></div></td><div> ' +
            '<td width="10%" style="text-align: center;"><div><input type="text" id="txtExpiryDate_maxindexval" name="ExpiryDate" maxlength="50"  class="form-control datetime" autocomplete="off" tabindex="0" required ></div></td><div> ',
        IdPlaceholderused: "maxindexval",
        TargetId: "#ContactGrid",
        TargetElement: ["tr"]
    }
    $("#chkContactDeleteAll").prop("checked", false);
    AddNewRowToDataGrid(inputpar);
    //$("input[id^='txtGeneratedDemerit_'], input[id^='txtFinalDemerit_']").attr('pattern', '^[0-9]+$');
    $("select[id^='txtLicenseCode_']").attr('pattern', '^[a-zA-Z0-9./\\(\\),\\-\\s]+$');
    $("input[id^='txtLicenseDescription_']").attr('pattern', '^[a-zA-Z0-9./\\(\\),\\-\\s]+$');
    $("input[id^='txtLicenseNo_']").attr('pattern', '^[a-zA-Z0-9./\\(\\)\\-\\+]+$');
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
    formInputValidation("FrmVec");

}
////////////////////*********** End Add rows **************//