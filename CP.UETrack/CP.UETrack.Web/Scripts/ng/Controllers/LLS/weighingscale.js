$(document).ready(function () {
    window.IssuedByListGlobal = [];
    window.StatusListGlobal = [];
    formInputValidation("FrmWeigh");
    $('#myPleaseWait').modal('show');
    $('.btnDelete').hide();
    $('#btnNextScreenSave').hide();
    $.get("/api/WeighingScale/Load")
        .done(function (result) {
            var loadResult = JSON.parse(result);
            $.each(loadResult.Status, function (index, value) {
                $('#txtIssuedBy_').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
           
        })
        .fail(function () {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
        });
});
$("#btnWeiSave, #btnEdit,#btnWeiSaveandAddNew").click(function () {
    $('#btnlogin').attr('disabled', true);
    $('#myPleaseWait').modal('show');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('#myPleaseWait').modal('hide');
        $('#txtIssuedBy_').attr('required', true);
        $('#txtItemDescription_').attr('required', true);
        $('#txtSerialNo_').attr('required', true);
        $('#txtIssuedDate_').attr('required', true);
   
    var CurrentbtnID = $(this).attr("Id");
    var timeStamp = $("#Timestamp").val();

    var isFormValid = formInputValidation("FrmWeigh", 'save');
    if (!isFormValid) {
        $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        $('#errorMsg').css('visibility', 'visible');
        $('#btnlogin').attr('disabled', false);
        $('#myPleaseWait').modal('hide');
        return false;
    }
    
        var MstWeighingScale = {
            WeighingScaleId: $('#WeighingScaleId_').val(),
            IssuedBy: $('#txtIssuedBy_').val(),
            ItemDescription: $('#txtItemDescription_').val(),
            SerialNo: $('#txtSerialNo_').val(),
            IssuedDate: $('#txtIssuedDate_').val(),
            ExpiryDate: $('#txtExpiryDate_').val(),
            Status: $('#SelStatus_').val(),
            GuId: $('#hdnAttachId').val(),
        };

        var primaryId = $("#primaryID").val();
        if (primaryId != null) {
            MstWeighingScale.WeighingScaleId = primaryId;
            MstWeighingScale.Timestamp = timeStamp;
        }
        else {
            MstWeighingScale.WeighingScaleId = 0;
            MstWeighingScale.Timestamp = "";
        }
   
    var jqxhr = $.post("/api/WeighingScale/Save", MstWeighingScale, function (response) {
            var result = JSON.parse(response);
            $("#primaryID").val(result.WeighingScaleId);
            $("#Timestamp").val(result.Timestamp);
            $('#hdnStatus').val(result.Active);
            $('#SelStatus_ option[value="' + result.Active + '"]').prop('selected', true);
            $("#grid").trigger('reloadGrid');
            if (result.WeighingScaleId != 0) {
                $('#txtIssuedBy_').prop('disabled', true);
                $('#txtItemDescription_').prop('disabled', true);
                $('#txtSerialNo_').prop('disabled', true);
                $('#txtIssuedDate_').prop('disabled', true);
                $('#btnNextScreenSave').show();
                $('#btnEdit').show();
                $('#btnWeiSave').hide();
                $('.btnDelete').hide();
            }
            $(".content").scrollTop(0);
            showMessage('WeighingScale', CURD_MESSAGE_STATUS.SS);
            $("#top-notifications").modal('show');
            setTimeout(function () {
                $("#top-notifications").modal('hide');
            }, 5000);

            $('#btnWeiSave').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
        if (CurrentbtnID == "btnEdit") {
                EmptyFields();
            }
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

                $('#btnWeiSave').attr('disabled', false);
                $('#myPleaseWait').modal('hide');
            });
    });

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


function LinkClicked(WeighingScaleId) {
    linkCliked1 = true;
    $(".content").scrollTop(1);
    $('.nav-tabs a:first').tab('show');
    $("#FrmWeigh :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    var action = "";
    $('#primaryID').val(WeighingScaleId);
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
        $("#FrmWeigh :input:not(:button)").prop("disabled", true);
    } else {
        $('#btnEdit').show();
        $('#btnWeiSave').hide();
        $('#btnNextScreenSave').show();
    }
    $('#spnActionType').text(action);

    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/WeighingScale/Get/" + primaryId)
            .done(function (result) {
                var getResult = JSON.parse(result);
                $('#hdnStatus').val(getResult.Active);
                $('#hdnAttachId').val(getResult.GuId);
                $('#primaryID').val(getResult.WeighingScaleId);
                $('#SelStatus_ option[value="' + getResult.Status + '"]').prop('selected', true);
                $('#txtIssuedBy_').val(getResult.IssuedBy).attr('disabled', true);
                $('#txtItemDescription_').val(getResult.ItemDescription).attr('disabled', true);
                $('#txtSerialNo_').val(getResult.SerialNo).attr('disabled', true);
                $('#txtIssuedDate_').val(moment(getResult.IssuedDate).format("DD-MMM-YYYY")).attr('disabled', true);
                $('#txtExpiryDate_').val(moment(getResult.ExpiryDate).format("DD-MMM-YYYY")).attr('disabled', true);
                $('#SelStatus_').val(getResult.Status);
                $('#myPleaseWait').modal('hide')
                $('#btnEdit').hide();
                $('#btnWeiSave').show();
                $('.btnDelete').hide();
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
            $.get("/api/WeighingScale/Delete/" + ID)
                .done(function (result) {
                    filterGrid();
                    $(".content").scrollTop(0);
                    showMessage('WeighingScale', CURD_MESSAGE_STATUS.DS);
                    $('#myPleaseWait').modal('hide');
                    EmptyFields();
                })
                .fail(function () {
                    showMessage('WeighingScale', CURD_MESSAGE_STATUS.DF);
                    $('#myPleaseWait').modal('hide');
                });
        }

    });
}
$("#btnNextScreenSave").click(function () {
    var primaryId = $("#primaryID").val();

    var hdnStatus = $("#hdnStatus").val();

    if (hdnStatus == 0 || hdnStatus == '0') {
        bootbox.alert('Only Active WeighingScale can be navigated to Level Screen');

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
    //$('#ContactGrid').empty();
    $('#spnActionType').text('Add');
    $('#btnEdit').hide();
    $('#btnNextScreenSave').hide();
    $('#btnWeiSave').show();
    $('#primaryID').val('');
    $('#txtItemDescription_').val('').prop('disabled', false);
    $('#txtSerialNo_').val('').prop('disabled', false);
    $('#txtIssuedBy_').val('null').prop('disabled', false);
    $('#txtIssuedDate_').val('').prop('disabled', false);
    $('#txtExpiryDate_').val('').prop('disabled', false);
    $("#grid").trigger('reloadGrid');
    $("#FrmWeigh :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('#SelStatus_').val(1).prop('disabled', false);
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
    var IssuedBy = $('#txtIssuedBy_' + rowCount).val();
    var ItemDescription = $('#txtItemDescription_' + rowCount).val();
    var SerialNo = $('#txtSerialNo_' + rowCount).val();
    var IssuedDate = $('#txtIssuedDate_' + rowCount).val();
    var Status = $('#SelStatus_' + rowCount).val();

    if (rowCount < 0)
        AddFirstGridRow();
    else if (rowCount >= "0" && (IssuedBy == "" || ItemDescription == "" || SerialNo == "" || IssuedDate == "")) {
        bootbox.alert("Please fill the last record");
    }
    else {
        AddFirstGridRow();
    }
});
$('#chkContactDeleteAll').on('click', function () {
    var isChecked = $(this).prop("checked");
    
    $('#ContactGrid tr').each(function (index, value) {
        if (isChecked) {
            $('#chkContactDelete_' + index).prop('checked', true);
            $('#chkContactDelete_' + index).parent().addClass('bgDelete');
            $('#IssuedBy_' + index).removeAttr('required');
            $('#IssuedBy_' + index).parent().removeClass('has-error');
          
        }
        else {
           
            $('#IssuedBy_' + index).attr('required', true);
            $('#chkContactDelete_' + index).prop('checked', false);
            $('#chkContactDelete_' + index).parent().removeClass('bgDelete');
        }
    });
   
});
