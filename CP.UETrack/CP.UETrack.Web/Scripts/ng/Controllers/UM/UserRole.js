$(document).ready(function () {
    $('#myPleaseWait').modal('show');
    formInputValidation("frmUserRole");
    $('#btnDelete').hide();
    $('#btnEdit').hide();
    //$('#btnNextScreenSave').hide();
  
    $.get("/api/userRole/Load")
        .done(function (result) {
            $('#jQGridCollapse1').click();
            var loadResult = JSON.parse(result);
            $.each(loadResult.UserTypeIds, function (index, value) {
                $('#selUserTypeId').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $.each(loadResult.Statuses, function (index, value) {
                $('#selStatus').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $('#selStatus').val(1);
            //var primaryId = $('#primaryID').val();
            //if (primaryId != null && primaryId != "0") {
            //    $.get("/api/userRole/Get/" + primaryId)
            //      .done(function (result) {
            //          var getResult = JSON.parse(result);
            //          $('#txtName').val(getResult.Name);
            //          $('#selUserTypeId').val(getResult.UserTypeId);
            //          $('#selStatus').val(getResult.Status);
            //          $('#txtRemarks').val(getResult.Remarks);
            //          $('#Timestamp').val(getResult.Timestamp);

            //          $('#myPleaseWait').modal('hide');
            //      })
            //     .fail(function (response) {
            //         $('#myPleaseWait').modal('hide');
            //         var errorMessage = '';
            //         $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
            //         $('#errorMsg').css('visibility', 'visible');
            //     });
            //}
            //else {
            //    $('#myPleaseWait').modal('hide');
            //}
        })
  .fail(function (response) {
      $('#myPleaseWait').modal('hide');
      $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
      $('#errorMsg').css('visibility', 'visible');
  });

    $("#btnSave, #btnEdit,#btnSaveandAddNew").click(function () {
        $('#btnSave').attr('disabled', true);
        $('#btnEdit').attr('disabled', true);
        $('#btnSaveandAddNew').attr('disabled', true);
        
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
        var CurrentbtnID = $(this).attr("Id");
        var name = $('#txtName').val();
        var userTypeId = $('#selUserTypeId').val();
        var status = $('#selStatus').val();
        var remarks = $('#txtRemarks').val();
        var timeStamp = $("#Timestamp").val();

        var isFormValid = formInputValidation("frmUserRole", 'save');
        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');

            $('#btnSave').attr('disabled', false);
            $('#btnEdit').attr('disabled', false);
            $('#btnSaveandAddNew').attr('disabled', false);
            return false;
        }
        $('#myPleaseWait').modal('show');
       

        var UMUserRole = {};
        UMUserRole.Name = name;
        UMUserRole.UserTypeId = userTypeId;
        UMUserRole.Status = status;
        UMUserRole.Remarks = remarks;

        var primaryId = $("#primaryID").val();
        if (primaryId != null) {
            UMUserRole.UMUserRoleId = primaryId;
            UMUserRole.Timestamp = timeStamp;
        }
        else {
            UMUserRole.UMUserRoleId = 0;
            UMUserRole.Timestamp = "";
        }

        var jqxhr = $.post("/api/userRole/Save", UMUserRole, function (response) {
            var result = JSON.parse(response);
            $("#primaryID").val(result.UMUserRoleId);
            $("#Timestamp").val(result.Timestamp);
            $('#txtName').attr('disabled', true);
            $("#grid").trigger('reloadGrid');
            if (result.UMUserRoleId != null)
            {
                $('#btnEdit').show();
                $('#btnSave').hide();
            }
            $('#btnDelete').show();
            $(".content").scrollTop(0);
            showMessage('User Role', CURD_MESSAGE_STATUS.SS);
            
            $('#btnSave').attr('disabled', false);
            $('#btnEdit').attr('disabled', false);
            $('#btnSaveandAddNew').attr('disabled', false);
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
                errorMessage = Messages.COMMON_FAILURE_MESSAGE(response);
            }
            $("div.errormsgcenter").text(errorMessage);
            $('#errorMsg').css('visibility', 'visible');

            $('#btnSave').attr('disabled', false);
            $('#btnEdit').attr('disabled', false);
            $('#btnSaveandAddNew').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
        });
    });

    $('#btnAddNew').click(function () {
        window.location.reload();
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
function LinkClicked(id) {
    $(".content").scrollTop(1);
    $("#frmUserRole :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('#txtName').attr('disabled', true);
    var action = "";
    $('#primaryID').val(id);
    var hasEditPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Edit'");
    var hasViewPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='View'");
    var hasDeletePermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Delete'");

    if (hasEditPermission)
    {
        action = "Edit"

    }
    else if (!hasEditPermission && hasViewPermission)
    {
        action = "View"
    }
    if (action == "Edit" && hasDeletePermission)
    {
        $('#btnDelete').show();
    }
   
    if (action == 'View') {
        $("#frmUserRole :input:not(:button)").prop("disabled", true);
       
    } else 
    {
        $('#btnEdit').show();
        $('#btnSave').hide();
        //$('#btnSaveandAddNew').hide();
        $('#btnNextScreenSave').show();
    }
    $('#spnActionType').text(action);

    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/userRole/Get/" + primaryId)
          .done(function (result) {
              var getResult = JSON.parse(result);
              $('#txtName').val(getResult.Name);
              $('#selUserTypeId').val(getResult.UserTypeId);
              $('#selStatus').val(getResult.Status);
              $('#txtRemarks').val(getResult.Remarks);
              $('#Timestamp').val(getResult.Timestamp);

              $('#myPleaseWait').modal('hide');
          })
         .fail(function (response) {
             $('#myPleaseWait').modal('hide');
             var errorMessage = '';
             $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
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
    bootbox.confirm(message, function (result) {
        if (result) {
            $.get("/api/userRole/Delete/" + ID)
             .done(function (result) {
                 filterGrid();
                 $(".content").scrollTop(0);
                 showMessage('User Role', CURD_MESSAGE_STATUS.DS);
                 $('#myPleaseWait').modal('hide');
                 EmptyFields();
             })
             .fail(function () {
                 showMessage('User Role', CURD_MESSAGE_STATUS.DF);
                 $('#myPleaseWait').modal('hide');
             });
        }
      
    });
}
$("#btnNextScreenSave").click(function () {
    window.location.href = "/bems/userlocation";
});

function EmptyFields()
{
    $(".content").scrollTop(0);
    $('input[type="text"], textarea').val('');
    $('#selUserTypeId').val('null');
    $('#selStatus').val(1);
    $('#btnEdit').hide();
    $('#btnSave').show();
    $('#btnDelete').hide();
    //$('#btnNextScreenSave').hide();
    $('#spnActionType').text('Add');
    $("#primaryID").val('');
    $("#UMUserRoleId").val('');
    $("#grid").trigger('reloadGrid');
    $("#frmUserRole :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
      $('#txtName').attr('disabled', false);
}