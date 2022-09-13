$(document).ready(function () {
    
    $('#myPleaseWait').modal('show');
    formInputValidation("formBemsBlock");
    $('#btnDelete').hide();
    $('#btnEdit').hide();
    $('#btnNextScreenSave').hide();   
    $.get("/api/Block/Load")
        .done(function (result) {
                     
          
            var loadResult = JSON.parse(result);
              
            $.each(loadResult.FacilityData, function (index, value) {
                $('#blockFacilityId').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $('#blockFacilityId').val(loadResult.FacilityId);
           
        })
  .fail(function () {
      $('#myPleaseWait').modal('hide');
      $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
      $('#errorMsg').css('visibility', 'visible');
  });

    $("#btnSave, #btnEdit,#btnSaveandAddNew").click(function () {
        $('#btnlogin').attr('disabled', true);
        $('#myPleaseWait').modal('show');

        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
        var CurrentbtnID = $(this).attr("Id");
        var timeStamp = $("#Timestamp").val();
        
        var isFormValid = formInputValidation("formBemsBlock", 'save');
        if (!isFormValid)
        {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');

            $('#btnlogin').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            return false;
        }

        var MstBlock = {
            BlockName : $('#blockName').val(),
            FacilityId : $('#blockFacilityId').val(),
            ShortName : $('#blockShortName').val(),
            BlockCode : $('#blockCode').val(),
            Active : $("#SelStatus option:selected").val()
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

        var jqxhr = $.post("/api/Block/Save", MstBlock, function (response) {
            var result = JSON.parse(response);
            $("#primaryID").val(result.BlockId);
            $("#Timestamp").val(result.Timestamp);
           // $('#blockName').val(result.BlockName);
            //$('#blockFacilityId').val(result.FacilityId);
            $('#SelStatus option[value="' + result.Active + '"]').prop('selected', true);
            $('#hdnStatus').val(result.Active);
        
            $("#grid").trigger('reloadGrid');
            if (result.BlockId != 0) {
                $('#hdnAttachId').val(result.HiddenId);
                $('#blockCode').prop('disabled', true);
                $('#btnNextScreenSave').show();
                $('#btnEdit').show();
                $('#btnSave').hide();
                $('#btnDelete').show();
            }
            $(".content").scrollTop(0);
            showMessage('Block', CURD_MESSAGE_STATUS.SS);
            $("#top-notifications").modal('show');
            setTimeout(function () {
                $("#top-notifications").modal('hide');
            }, 5000);

            $('#btnSave').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            if (CurrentbtnID == "btnSaveandAddNew") {
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

            $('#btnSave').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
        });
    });

    $("#btnCancel").click(function () {
        //debugger;
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
});


function LinkClicked(id) {
    $(".content").scrollTop(1);
    $('.nav-tabs a:first').tab('show');
    $("#formBemsBlock :input:not(:button)").parent().removeClass('has-error');
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
        $('#btnSave').hide();
        //$('#btnSaveandAddNew').hide();
        $('#btnNextScreenSave').show();
    }
    $('#spnActionType').text(action);

    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/Block/Get/" + primaryId)
            .done(function (result) {
              var getResult = JSON.parse(result);
              $('#blockName').val(getResult.BlockName);
              $('#blockFacilityId').val(getResult.FacilityId);
              $('#SelStatus option[value="' + getResult.Active + '"]').prop('selected', true);
              $('#blockShortName').val(getResult.ShortName);
              $('#blockCode').val(getResult.BlockCode).prop('disabled', true);
              $('#primaryID').val(getResult.BlockId);
              $('#hdnStatus').val(getResult.Active);
              $('#hdnAttachId').val(getResult.HiddenId);
              $('#myPleaseWait').modal('hide');
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

$("#btnDelete").click(function () {
    var ID = $('#primaryID').val();
    confirmDelete(ID);

});
function confirmDelete(ID) {
    var message = Messages.SEARCH_GRID_DELETE_CONFIRMATION;
    var pageId = $('.ui-pg-input').val();
    bootbox.confirm(message, function (result) {
        if (result) {
            $.get("/api/block/Delete/" + ID)
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
$("#btnNextScreenSave").click(function () {
    var primaryId = $("#primaryID").val();
  
    var hdnStatus = $("#hdnStatus").val();

    if (hdnStatus == 0 || hdnStatus == '0')
    {
        bootbox.alert('Only Active Block can be navigated to Level Screen');

    }
    else if (primaryId != null && primaryId != 0 && primaryId != "0" && primaryId != '')
    {
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
    //debugger;
    $(".content").scrollTop(0);
    $('#hdnAttachId').val('');
    $('#btnDelete').hide();
    $('#blockName').val('');
    $('#SelStatus').val(1);
    $('#blockShortName').val('');
    $('#blockCode').val('');
    $('#blockCode').removeAttr("disabled")
    $('#spnActionType').text('Add');
    $('#btnEdit').hide();
    $('#btnNextScreenSave').hide();    
    $('#btnSave').show();
    $('#primaryID').val('');
    $("#grid").trigger('reloadGrid');
    $("#formBemsBlock :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('#txtStatus').val(1);
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