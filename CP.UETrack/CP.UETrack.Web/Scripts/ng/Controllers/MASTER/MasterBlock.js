$(document).ready(function () {
    
    $('#myPleaseWait').modal('show');
    formInputValidation("formMasterBlock");
    $('#MasterbtnDelete').hide();
    $('#MasterbtnEdit').hide();
    $('#MasterbtnNextScreenSave').hide();
    $.get("/api/MasterBlock/Load")
        .done(function (result) {

            //if (2 == "2") {
            //    alert('true');
            //}
            //else {
            //    alert('false ');
            //}
            //voi(0);
            var loadResult = JSON.parse(result);

            $.each(loadResult.FacilityData, function (index, value) {
                $('#MasterblockFacilityId').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $('#MasterblockFacilityId').val(loadResult.FacilityId);

        })
        .fail(function (err) {
          
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
            $('#MastererrorMsg').css('visibility', 'visible');
        });

    $("#MasterbtnSave, #MasterbtnEdit,#MasterbtnSaveandAddNew").click(function () {
     
        $('#btnlogin').attr('disabled', true);
        $('#myPleaseWait').modal('show');

        $("div.errormsgcenter").text("");
        $('#MastererrorMsg').css('visibility', 'hidden');
        var CurrentbtnID = $(this).attr("Id");
        var timeStamp = $("#MasterTimestamp").val();

        var isFormValid = formInputValidation("formMasterBlock", 'save');
        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#MastererrorMsg').css('visibility', 'visible');

            $('#Masterbtnlogin').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            return false;
        }
        var MasterFEMSId = 0;
        var MasterBEMSId = 0;
        var MasterCLSId = 0;
        var MasterLLSId = 0;
        var MasterHWMSId = 0;
        if ($('#MasterBEMSId').prop('checked') == true) {
            MasterBEMSId = 1;
        }
        if ($('#MasterFEMSId').prop('checked') == true) {
            MasterFEMSId = 1;
        }
        if ($('#MasterCLSId').prop('checked') == true) {
            MasterCLSId = 1;
        }
        if ($('#MasterLLSId').prop('checked') == true) {
            MasterLLSId = 1;
        }
        if ($('#MasterHWMSId').prop('checked') == true) {
            MasterHWMSId = 1;
        }
        var MstBlock = {
            BlockName: $('#MasterblockName').val(),
            FacilityId: $('#MasterblockFacilityId').val(),
            ShortName: $('#MasterblockShortName').val(),
            BlockCode: $('#MasterblockCode').val(),
            Active: $("#MasterSelStatus option:selected").val(),
            BEMS: MasterBEMSId,
            FEMS: MasterFEMSId,
            CLS: MasterCLSId,
            LLS: MasterLLSId,
            HWMS: MasterHWMSId
        };
        
        var primaryId = $("#primaryID").val();
        if (primaryId != null) {
            MstBlock.BlockId = primaryId;
            MstBlock.Timestamp = timeStamp;
        }
        else {
            MstBlock.BlockId = 0;
            MstBlock.Timestamp = "";
        }

        var jqxhr = $.post("/api/MasterBlock/Save", MstBlock, function (response) {
          
            var result = JSON.parse(response);
            $("#primaryID").val(result.BlockId);
            $("#MasterTimestamp").val(result.Timestamp);
            // $('#blockName').val(result.BlockName);
            //$('#blockFacilityId').val(result.FacilityId);
            $('#MasterSelStatus option[value="' + result.Active + '"]').prop('selected', true);
            $('#MasterhdnStatus').val(result.Active);

            $("#grid").trigger('reloadGrid');
            if (result.BlockId != 0) {
                $('#MasterhdnAttachId').val(result.HiddenId);
                $('#MasterblockCode').prop('disabled', true);
                $('#MasterbtnNextScreenSave').show();
                $('#MasterbtnEdit').show();
                $('#MasterbtnSave').hide();
                $('#MasterbtnDelete').show();
            }
            $(".content").scrollTop(0);
            showMessage('Block', CURD_MESSAGE_STATUS.SS);
            $("#top-notifications").modal('show');
            setTimeout(function () {
                $("#top-notifications").modal('hide');
            }, 5000);

            $('#MasterbtnSave').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            if (CurrentbtnID == "MasterbtnSaveandAddNew") {
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
                $('#MastererrorMsg').css('visibility', 'visible');

                $('#MasterbtnSave').attr('disabled', false);
                $('#myPleaseWait').modal('hide');
            });
    });

    $("#MasterbtnCancel").click(function () {
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
        MasterLinkClicked(ID);
    }
    // **** Query String to get ID  End****\\\
});


function MasterLinkClicked(id) {
  
    $(".content").scrollTop(1);
    $('.nav-tabs a:first').tab('show');
    $("#formMasterBlock :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#MastererrorMsg').css('visibility', 'hidden');
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
        $("#formMasterBlock :input:not(:button)").prop("disabled", true);
    } else {
        $('#MasterbtnEdit').show();
        $('#MasterbtnSave').hide();
        //$('#btnSaveandAddNew').hide();
        $('#MasterbtnNextScreenSave').show();
    }
    $('#MasterspnActionType').text(action);

    var primaryId = $('#primaryID').val();
    //window.alert("primaryId")
    if (primaryId != null && primaryId != "0") {
        
        $.get("/api/MasterBlock/Get/" + primaryId)
            .done(function (result) {
                var getResult = JSON.parse(result);
                $('#MasterblockName').val(getResult.BlockName);
                $('#MasterblockFacilityId').val(getResult.FacilityId);
                $('#MasterSelStatus option[value="' + getResult.Active + '"]').prop('selected', true);
                $('#MasterblockShortName').val(getResult.ShortName);
                $('#MasterblockCode').val(getResult.BlockCode).prop('disabled', true);
                $('#primaryID').val(getResult.BlockId);
                $('#MasterhdnStatus').val(getResult.Active);
                $('#MasterhdnAttachId').val(getResult.HiddenId);
                $('#myPleaseWait').modal('hide');
            })
            .fail(function () {
                $('#myPleaseWait').modal('hide');
                $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
                $('#MastererrorMsg').css('visibility', 'visible');
            });
    }
    else {
        $('#myPleaseWait').modal('hide');
    }
}

$("#MasterbtnDelete").click(function () {
    var ID = $('#primaryID').val();
    confirmDelete(ID);

});
function confirmDelete(ID) {
    var message = Messages.SEARCH_GRID_DELETE_CONFIRMATION;
    var pageId = $('.ui-pg-input').val();
    bootbox.confirm(message, function (result) {
        if (result) {
            $.get("/api/Masterblock/Delete/" + ID)
                .done(function (result) {
                    filterGrid();
                    $(".content").scrollTop(0);
                    showMessage('Block', CURD_MESSAGE_STATUS.DS);
                    $('#myPleaseWait').modal('hide');
                    EmptyFields();
                })
                .fail(function () {
                    showMessage('Block', CURD_MESSAGE_STATUS.DF);
                    $('#myPleaseWait').modal('hide');
                });
        }

    });
}
$("#MasterbtnNextScreenSave").click(function () {
    
    var primaryId = $("#primaryID").val();

    var hdnStatus = $("#MasterhdnStatus").val();

    if (hdnStatus == 0 || hdnStatus == '0') {
        bootbox.alert('Only Active Block can be navigated to Level Screen');

    }
    else if (primaryId != null && primaryId != 0 && primaryId != "0" && primaryId != '') {
        var msg = 'Do you want to proceed to Level screen?'
        bootbox.confirm(msg, function (Conform) {
            if (Conform) {
                window.location.href = "/master/MasterLevel/Add/" + primaryId;
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
    $('#MasterhdnAttachId').val('');
    $('#MasterbtnDelete').hide();
    $('#MasterblockName').val('');
    $('#MasterSelStatus').val(1);
    $('#MasterblockShortName').val('');
    $('#MasterblockCode').val('');
    $('#MasterblockCode').removeAttr("disabled")
    $('#MasterspnActionType').text('Add');
    $('#MasterbtnEdit').hide();
    $('#MasterbtnNextScreenSave').hide();
    $('#MasterbtnSave').show();
    $('#primaryID').val('');
    $("#grid").trigger('reloadGrid');
    $("#formMasterBlock :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#MastererrorMsg').css('visibility', 'hidden');
    $('#MasterSelStatus').val(1);
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