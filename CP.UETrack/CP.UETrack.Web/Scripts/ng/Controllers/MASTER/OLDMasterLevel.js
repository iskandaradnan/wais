$(document).ready(function () {
    
    $('#myPleaseWait').modal('show');
    formInputValidation("formMasterLevel");
    $('#MasterLevelbtnDelete').hide();
    $('#MasterLevelbtnEdit').hide();
    $('#MasterLevelbtnNextScreenSave').hide();

    $.get("/api/MasterBlock/Load")
        .done(function (result) {
            var loadResult = JSON.parse(result);
            var blockId = $('#MasterLevelblockId').val();
            window.alert("blockId")
            //document.write(blockId);
            if (blockId != null && blockId != 0 && blockId != '') {

            }
            else {
                $("#jQGridCollapse1").click();
            }
            $.each(loadResult.FacilityData, function (index, value) {
                $('#MasterLevelFacility').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $('#MasterLevelFacility').val(loadResult.FacilityId);
            getBlockList(loadResult.FacilityId);
            var primaryId = $('#primaryID').val();

        })
        .fail(function (err) {
           
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
            $('#MasterLevelerrorMsg').css('visibility', 'visible');
        });

    function getBlockList(levelFacilityId) {
      
        var blockId = $("#MasterLevelblockId").val();
        //window.alert("blockId")

        if (levelFacilityId !== "null") {
            $.get("/api/MasterLevel/GetBlockData/" + levelFacilityId)
                .done(function (result) {
                    var loadResult = JSON.parse(result);
                    var LevelBlockId = $('#MasterLevelBlock');

                    LevelBlockId.empty();
                    LevelBlockId.append('<option value="null">Select</option>');
                    if (loadResult.BlockData.length) {
                        $.each(loadResult.BlockData, function (index, value) {
                            LevelBlockId.append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
                        });
                    }

                    if (blockId != null && blockId != '') {
                        $('#MasterLevelBlock').val(blockId);
                        $('#MasterLevelBlock').attr('disabled', true);
                    }
                    else {
                        $('#MasterLevelBlock').attr('disabled', false);
                    }
                }).fail(function () {
                    $('#myPleaseWait').modal('hide');
                    $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
                    $('#MasterLevelerrorMsg').css('visibility', 'visible');
                });
        }
    };

    $("#MasterLevelbtnSave, #MasterLevelbtnEdit,#MasterLevelbtnSaveandAddNew").click(function () {
     
        $('#MasterLevelbtnlogin').attr('disabled', true);
        $('#myPleaseWait').modal('show');
        var CurrentbtnID = $(this).attr("Id");
        $("div.errormsgcenter").text("");
        $('#MasterLevelerrorMsg').css('visibility', 'hidden');

        var timeStamp = $("#MasterLevelTimestamp").val();

        var isFormValid = formInputValidation("formMasterLevel", 'save');
        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#MasterLevelerrorMsg').css('visibility', 'visible');

            $('#MasterLevelbtnlogin').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            return false;
        }

        var MstLevel = {
            LevelName: $('#MasterLevelName').val(),
            FacilityId: $('#MasterLevelFacility').val(),
            ShortName: $('#MasterShortName').val(),
            LevelCode: $('#MasterLevelCode').val(),
            BlockId: $('#MasterLevelBlock').val(),
            Active: $("#MasterLevelSelStatus option:selected").val()
        }

        var primaryId = $("#primaryID").val();
        if (primaryId != null) {
            MstLevel.LevelId = primaryId;
            MstLevel.Timestamp = timeStamp;
        }
        else {
            MstLevel.LevelId = 0;
            MstLevel.Timestamp = "";
        }

        var jqxhr = $.post("/api/Level/MasterSave", MstLevel, function (response) {
            var result = JSON.parse(response);
            $("#primaryID").val(result.LevelId);
            $("#MasterLevelTimestamp").val(result.Timestamp);
            $('#MasterLevelhdnStatus').val(result.Active);
            $("#grid").trigger('reloadGrid');
            if (result.LevelId != 0) {
                $('#MasterLevelhdnAttachId').val(result.HiddenId);
                $('#MasterLevelCode').prop('disabled', true);
                $('#MasterLevelbtnNextScreenSave').show();
                $('#MasterLevelBlock').attr('disabled', true);
                $('#MasterLevelbtnEdit').show();

                $('#MasterLevelbtnSave').hide();
                $('#MasterLevelbtnDelete').show();
            }
            $(".content").scrollTop(0);
            showMessage('Level', CURD_MESSAGE_STATUS.SS);
            $("#top-notifications").modal('show');
            setTimeout(function () {
                $("#top-notifications").modal('hide');
            }, 5000);

            $('#MasterLevelbtnSave').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            if (CurrentbtnID == "MasterLevelbtnSaveandAddNew") {
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
                    errorMessage = Messages.COMMON_FAILURE_MESSAGE(response);
                }
                $("div.errormsgcenter").text(errorMessage);
                $('#MasterLevelerrorMsg').css('visibility', 'visible');

                $('#MasterLevelbtnSave').attr('disabled', false);
                $('#myPleaseWait').modal('hide');
            });
    });

    $("#MasterLevelbtnCancel").click(function () {
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
});

function MasterLevelLinkClicked(id) {
  
    $(".content").scrollTop(1);
    $('.nav-tabs a:first').tab('show');
    $("#formMasterLevel :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#MasterLevelerrorMsg').css('visibility', 'hidden');
    $('.nav-tabs a:first').tab('show');
    var action = "";
    $('#primaryID').val(id);
    var hasEditPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Edit'");
    var hasViewPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='View'");
    var hasDeletePermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Delete'");

    if (hasEditPermission) {
        action = "Edit";

    }
    else if (!hasEditPermission && hasViewPermission) {
        action = "View";
    }
    if (action == "Edit" && hasDeletePermission) {
        $('#MasterLevelbtnDelete').show();
    }

    if (action == 'View') {
        $("#formMasterLevel :input:not(:button)").prop("disabled", true);
    } else {
        $('#MasterLevelbtnEdit').show();
        $('#MasterLevelbtnSave').hide();
        //$('#btnSaveandAddNew').hide();
        $('#MasterLevelbtnNextScreenSave').show();
    }
    $('#MasterLevelspnActionType').text(action);

    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
      
        $.get("/api/MasterLevel/MasterGet/" + primaryId)
            .done(function (result) {
                var getResult = JSON.parse(result);
                $('#MasterLevelBlock').attr('disabled', true);
                $('#primaryID').val(getResult.LevelId);
                $('#MasterLevelName').val(getResult.LevelName);
                $('#MasterLevelFacility').val(getResult.FacilityId);
                $('#MasterLevelhdnStatus').val(getResult.Active);
                $("#MasterLevelFacility").trigger('change');
                $('#MasterLevelSelStatus option[value="' + getResult.Active + '"]').prop('selected', true);
                $('#MasterLevelShortName').val(getResult.ShortName);
                $('#MasterLevelCode').val(getResult.LevelCode).prop('disabled', true);
                $('#MasterLevelhdnAttachId').val(getResult.HiddenId);
                setTimeout(function () {
                    $('#MasterLevelBlock option[value="' + getResult.BlockId + '"]').prop('selected', true);
                }, 200)
                $('#myPleaseWait').modal('hide');
            })
            .fail(function () {
                $('#myPleaseWait').modal('hide');
                $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
                $('#MasterLevelerrorMsg').css('visibility', 'visible');
            });
    }
    else {
        $('#myPleaseWait').modal('hide');
    }
}

$("#MasterLevelbtnDelete").click(function () {
    var ID = $('#primaryID').val();
    confirmDelete(ID);

});
function confirmDelete(ID) {
    var message = Messages.SEARCH_GRID_DELETE_CONFIRMATION;
    var pageId = $('.ui-pg-input').val();
    bootbox.confirm(message, function (result) {
        if (result) {
            $.get("/api/Level/MasterDelete/" + ID)
                .done(function (result) {
                    filterGrid();
                    $(".content").scrollTop(0);
                    showMessage('Level', CURD_MESSAGE_STATUS.DS);
                    $('#myPleaseWait').modal('hide');
                    EmptyFields();
                })
                .fail(function () {
                    showMessage('Level', CURD_MESSAGE_STATUS.DF);
                    $('#myPleaseWait').modal('hide');
                });
        }

    });
}
$("#MasterLevelbtnNextScreenSave").click(function () {

    var msg = 'Do you want to proceed to Area screen?';
    var primaryId = $("#primaryID").val();
    var hdnStatus = $("#MasterLevelhdnStatus").val();

    if (hdnStatus == 0 || hdnStatus == '0') {
        bootbox.alert('Only Active Level can be navigated to Area Screen');

    }
    else if (primaryId != null && primaryId != 0 && primaryId != "0" && primaryId != '') {
        bootbox.confirm(msg, function (Conform) {
            if (Conform) {
                window.location.href = "/master/userarea/Add/" + primaryId;
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
    $('#MasterLevelhdnAttachId').val('');
    $('input[type="text"], textarea').val('');
    //  $('#LevelFacility').val("null");
    // window.location.replace("/bems/Level/");
    //var blockId = $('#blockId').val();

    //if (blockId != null && blockId != 0 && blockId != '') {
    //    $('#LevelBlock').val(blockId);
    //    $('#LevelBlock').attr('disabled', true);
    //}
    //else {
    $('#MasterLevelBlock').val("null");
    $('#MasterLevelBlock').attr('disabled', false);
    //  }

    $('#MasterLevelCode').prop('disabled', false);
    $('#MasterLevelbtnEdit').hide();
    $('#MasterLevelbtnSave').show();
    $('#MasterLevelbtnDelete').hide();
    $('#MasterLevelSelStatus').val(1);
    $('#MasterLevelbtnNextScreenSave').hide();
    $('#MasterLevelspnActionType').text('Add');
    $("primaryID").val('');
    $("#grid").trigger('reloadGrid');
    $("#formMasterLevel :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#MasterLevelerrorMsg').css('visibility', 'hidden');
    $('#MasterLeveldivCommonPagination').html(null);
    $('.nav-tabs a:first').tab('show');
}