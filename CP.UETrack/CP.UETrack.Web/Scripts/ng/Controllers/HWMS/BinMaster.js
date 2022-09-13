var statusdrodown = "";
var rowNum = 1;

$(document).ready(function () {
    //****************************************** Changing dropdown values *********************************************
    $.get("/api/BinMaster/Load")
        .done(function (result) {
            var loadResult = JSON.parse(result);
            $("#CCode").append("<option value='' Selected>" + "Select" + "</option>");
            $("#WType").append("<option value='' Selected>" + "Select" + "</option>");

            for (var i = 0; i < loadResult.StatusLovs.length; i++) {
                statusdrodown += "<option value=" + loadResult.StatusLovs[i].LovId + ">" + loadResult.StatusLovs[i].FieldValue + "</option>";
            }
            for (var i = 0; i < loadResult.CapacityCodeLovs.length; i++) {
                $("#CCode").append(
                    "<option value=" + loadResult.CapacityCodeLovs[i].LovId + ">" + loadResult.CapacityCodeLovs[i].FieldValue + "</option>"
                );
            }
            for (var i = 0; i < loadResult.WasteTypeLovs.length; i++) {
                $("#WType").append( "<option value=" + loadResult.WasteTypeLovs[i].LovId + ">" + loadResult.WasteTypeLovs[i].FieldValue + "</option>"
                );
            }
            $("#txtStatus1").append(statusdrodown);
            $('#myPleaseWait').modal('hide');
        })
        .fail(function () {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
        });

    //*****************************If Capacity Code is Wheel Bin 660L the WEIGHT Field is Disbled *****************************
    $("#CCode").change(function () {   
        DisableWeight('txtWeight');
    });

   

    // ****************** If the Status is selected as Inactive,in the Disposed Date field ,the current date is displayed *******************

    $('body').on('change', '.statusvalue', function (e) {
        var controlId = event.target.id;
        var StateValue = $('#' + controlId + ' option:selected').text();
        var id = controlId.slice(9, 11);
        if (StateValue == 'Active') {
            $('#txtDisposedDate' + id).val("");
        }
        else {
            var val = "";
            var date = new Date();
            var months = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL",
                "AUG", "SEP", "OCT", "NOV", "DEC"];
            var val = date.getDate() + "-" + months[date.getMonth()] + "-" + date.getFullYear();

            $("#txtDisposedDate" + id).val(val);
        }
    });
    
    //********************************************* Save **********************************************************
    $("#btnSave, #btnSaveandAddNew").click(function () {

        var SelCus = $("#selCustomerLayout").val();
        var SelFacility = $("#selFacilityLayout").val();
        $("div.errormsgcenter").text("");
        var CurrentbtnID = $(this).attr("Id");
        $('#errorMsg').css('visibility', 'hidden');

       
      
        var isFormValid = formInputValidation("formBinMaster", 'save');

        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
            return false;
        }

        var arr = [];
        var isDuplicate = 0;
        $("[id^=txtBinNo]").each(function () {
            var value = $(this).val();
            if (arr.indexOf(value) == -1)
                arr.push(value);
            else {
                isDuplicate += 1;
            }
        });

        if (isDuplicate > 0) {
            $("div.errormsgcenter").text('Duplicate bin numbers');
            $('#errorMsg').css('visibility', 'visible');
            return false;
        }

        var primaryId = 0;
        if ($("#primaryID").val() != null) {
            primaryId = $("#primaryID").val();            
        }

        var isOperationDateGreater = 0;
        $("#tbodyBinNo tr").each(function () {
            if ($(this).find("[id^=txtStatus] option:selected").text() == 'InActive') {
                if (Date.parse($(this).find("[id^=txtOperationDate]").val()) > Date.parse($(this).find("[id^=txtDisposedDate]").val())) {
                    isOperationDateGreater += 1;
                }
            }
        });

        if (isOperationDateGreater > 0) {
            $("div.errormsgcenter").text("Disposed date should be grether than the operation date");
            $('#errorMsg').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            return false;
        }

       
        var obj = {            
            BinMasterId: primaryId,
            CustomerId: SelCus,
            FacilityId: SelFacility,
            CapacityCode: $('#CCode').val(),
            Description: $('#txtDescription').val(),
            WasteType: $('#WType').val(),
            NoofBins: $('#txtNoofBins').val(),            
            binDetailslist: []
        }

        $("#tbodyBinNo tr").each(function () {

            var binDetailsObj = {};
            binDetailsObj.BinNoId = $(this).find("[id^=hdnBinNoId]")[0].value;
            binDetailsObj.BinNo = $(this).find("[id^=txtBinNo]")[0].value;
            binDetailsObj.Manufacturer = $(this).find("[id^=txtManufacturer]")[0].value;
            binDetailsObj.Weight = $(this).find("[id^=txtWeight]")[0].value;
            binDetailsObj.OperationDate = $(this).find("[id^=txtOperationDate]")[0].value;
            binDetailsObj.Status = $(this).find("[id^=txtStatus]")[0].value;
            binDetailsObj.DisposedDate = $(this).find("[id^=txtDisposedDate]")[0].value;
            binDetailsObj.isDeleted = $(this).find('input:checkbox[id^=isDelete]').prop("checked");

            obj.binDetailslist.push(binDetailsObj);

        });


        $.post("/Api/BinMaster/Save", obj, function (response) {

            var result = JSON.parse(response);
            showMessage('BinMaster', CURD_MESSAGE_STATUS.SS);
            $("#primaryID").val(result.BinMasterId);
            $("#grid").trigger('reloadGrid');
            if (CurrentbtnID == "btnSaveandAddNew") {
                EmptyFields();
                $('#BinLabel').hide();
            }
            else {
                fillDetails(result);
            }
        },
            "json")
            .fail(function (response) {

                var errorMessage = "";
                if (response.status == 400) {
                    errorMessage = response.responseJSON;
                }
                else {
                    errorMessage = Messages.COMMON_FAILURE_MESSAGE(response);
                }
                $("div.errormsgcenter").text(errorMessage);
                $('#errorMsg').css('visibility', 'visible');

                $('#btnSave').attr('disabled', false);
            });


    });

    //****************************************** Cancel *********************************************
    $("#btnCancel").click(function () {
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

    //********************************************* adding Bin Numbers While Adding Rows **********************************************************
    var n = $("#tbodyBinNo tr").length;
    $('#txtNoofBins').val(n);

    //********************************************* Add Multiple Values **********************************************************
    
    $("#addBins").click(function () {

        addBins(rowNum);

        var n1 = $("#tblBinDeails").find("tbody tr").length;
        $('#txtNoofBins').val(n1);

        DisableWeight('txtWeight' + rowNum);
        rowNum = rowNum + 1;
        
       
    });

    //********************************************* Rows delete functionalities ********************************************
    $("#deleteBinNo").click(function () {

        bootbox.confirm({
            message: 'Do you want to delete a row?',
            buttons: {
                confirm: {
                    label: 'Yes',
                    className: 'btn-primary'
                },
                cancel: {
                    label: 'No',
                    className: 'btn-default'
                }
            },
            callback: function (result) {
                if (result) {
                    if ($("input[type='checkbox']:checked").length > 0) {

                        $("#tbodyBinNo tr").find('input[name="isDelete"]').each(function () {
                            if ($(this).is(":checked")) {
                                if ($(this).closest("tr").find("[id^=hdnBinNoId]").val() == 0) {
                                    $(this).closest("tr").remove();
                                }
                            }
                        });                       
                        $('#txtNoofBins').val($("#tblBinDeails").find("tbody tr").length);
                    }
                    else
                        bootbox.alert("Please select atleast one row !");                   
                }
                else {
                    $('#myPleaseWait').modal('hide');
                }
            }
        });

    });


    var n2 = $("#tblBinDeails").find("tbody tr").length;
    $('#txtNoofBins').val(n2);
 


    //********************************************* validation red border removal while giving value *********************************************
    $(body).on('input propertychange', '.form-control', function (event) {
        $(this).parent().removeClass('has-error');
    });

    //********************************* Get By ID ************************************

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
});

function EmptyFields() {

    $("#primaryID").val('0');
    $('[id^=hdnBinNoId]').val(0);

    $('#formBinMaster #CCode').val('');
    $('#formBinMaster #txtDescription').val('');
    $('#BinLabel').hide();
    $('#formBinMaster #WType').val('');
    $('#formBinMaster #txtNoofBins').val(1);
    $('#formBinMaster #txtBinNo1').val('');
    $('#formBinMaster #txtManufacturer1').val('');
    $('#formBinMaster #txtWeight1').val('');
    $('#formBinMaster #txtOperationDate1').val('');
    $('#formBinMaster #txtStatus1').val('10359');
    $('#formBinMaster #txtDisposedDate1').val('');
       
    $('#capacity').removeClass('has-error');
    $('#desc').removeClass('has-error');
    $('#wtype').removeClass('has-error');
    $('#binno').removeClass('has-error');
    $('#manuf').removeClass('has-error');
    $('#opdate').removeClass('has-error');
    $('#stat').removeClass('has-error');
    $('#formBinMaster #BinError').removeClass('has-error');
    $('#formBinMaster #ManuError').removeClass('has-error');
    $('#formBinMaster #operationError').removeClass('has-error');
    $('#formBinMaster #ErrorStatus').removeClass('has-error');

    $('#errorMsg').css('visibility', 'hidden');
   
    var i = 1;
    $("#tbodyBinNo").find('tr').each(function () {
        if (i > 1) {
            $(this).remove();
        }
        i += 1;
    });
    

}

function LinkClicked(id) {

    $(".content").scrollTop(1);
    $('.nav-tabs a:first').tab('show');
    $("#formBinMaster :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    var action = "";
    $('#primaryID').val(id);
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
        $('#btnDelete').show();
    }

    if (action == 'View') {
        $("#formBemsBlock :input:not(:button)").prop("disabled", true);
    } else {
        $('#btnEdit').show();
        //$('#btnSave').hide();
        //$('#btnSaveandAddNew').hide();
        $('#btnNextScreenSave').show();
    }
    $('#spnActionType').text(action);

    var primaryId = $('#primaryID').val();

    if (primaryId != null && primaryId != "0") {
        $.get("/api/BinMaster/Get/" + primaryId)
            .done(function (result) {
                var getResult = JSON.parse(result);
                fillDetails(getResult);               
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

function addBins(num) {

    var CheckBox = '<td style="text-align:center"><input type="checkbox" id="isDelete' + num + '" name="isDelete">  <input type="hidden" id="hdnBinNoId' + num + '" value="0" /></td>';
    var BinNo = '<td id="BinError"><input type="text" required class="form-control" id="txtBinNo' + num + '" autocomplete="off" name="BinNo" maxlength="25"  /></td>';
    var Manufacturer = '<td id="ManuError"><input type="text" required class="form-control" id="txtManufacturer' + num + '" autocomplete="off" name="Manufacturer" maxlength="25"  /></td>';
    var Weight = '<td id="weightddl"><input type="text" class="form-control clsWeight" id="txtWeight' + num + '" autocomplete="offWeight" name="Weight" maxlength="25"  /></td>';
    var OperationDate = '<td id="operationError"><input type="text" required class="form-control datetime" id="txtOperationDate' + num + '" autocomplete="off" name="OperationDate" maxlength="25"  /></td>';
    var Status = '<td id="ErrorStatus"><select type="text" required class="form-control statusvalue" id="txtStatus' + num + '" autocomplete="off" name="statusvalue" maxlength="25" >' + statusdrodown + '</td>';
    var DisposedDate = '<td><input type="text" class="form-control datetime" id="txtDisposedDate' + num + '"  autocomplete="off" name="DisposedDate" maxlength="25"  /></td>';

    $("#tbodyBinNo").append('<tr>' + CheckBox + BinNo + Manufacturer + Weight + OperationDate + Status + DisposedDate + '</tr>');

}

function fillDetails(result) {

    if (result != undefined) {

        $("#primaryID").val(result.BinMasterId)
        $('#CCode').val(result.CapacityCode);
        $('#CCode').val(result.CapacityCode);
        $('#txtDescription').val(result.Description);
        $('#WType').val(result.WasteType);
        $('#txtNoofBins').val(result.NoofBins);
        $('#BinLabel').html(" ");

        rowNum = 1;
        $("#tbodyBinNo").html('');

        if (result.binDetailslist != null) {
            for (var i = 0; i < result.binDetailslist.length; i++) {

                addBins(rowNum);

                $('#hdnBinNoId' + rowNum).val(result.binDetailslist[i].BinNoId);
                $('#txtBinNo' + + rowNum).val(result.binDetailslist[i].BinNo);
                $('#txtManufacturer' + rowNum).val(result.binDetailslist[i].Manufacturer);
                $('#txtWeight' + rowNum).val(result.binDetailslist[i].Weight);

                var operationDate = getCustomDate(result.binDetailslist[i].OperationDate);
                var disposedDate = getCustomDate(result.binDetailslist[i].DisposedDate);
                $('#txtOperationDate' + rowNum).val(operationDate);
                $('#txtDisposedDate' + rowNum).val(disposedDate);
                $('#txtStatus' + rowNum).val(result.binDetailslist[i].Status);

                rowNum += 1;
            }

        }
        else {
            addBins(rowNum);
        }
    }
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
});



function getCustomDate(date) {

    if (date == '' || date == null) {
        return '';
    }
    else {
        let monthNames = ["Zero", "Jan", "Feb", "Mar", "Apr",
            "May", "Jun", "Jul", "Aug",
            "Sep", "Oct", "Nov", "Dec"];

        var day = date.slice(8, 10);
        var monthindex = date.slice(5, 7);        if (monthindex >= 10) {            var month = monthNames[date.slice(5, 7)];        }        else {            var month = monthNames[date.slice(6, 7)];        }
        var year = date.slice(0, 4);
        return day + "-" + month + "-" + year;
    }
}

function DisableWeight(Weight) {

    var CCode = $("#CCode")[0];

    if (CCode.options[CCode.options.selectedIndex].text == 'Wheel bin 660L') {
        $('.clsWeight').val('');
        $('.clsWeight').prop('disabled', true);
    }
    else {
        $('.clsWeight').prop("disabled", false);
    }
}