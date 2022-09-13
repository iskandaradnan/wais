$(document).ready(function () {
    $('#myPleaseWait').modal('show');
    formInputValidation("frmChangePassword");

    $.get("/api/changePassword/Load")
    .done(function (result) {
        var loadResult = JSON.parse(result);
        $('#txtUserName').val(loadResult.UserName);
        $('#myPleaseWait').modal('hide');
    })
.fail(function (response) {
    $('#myPleaseWait').modal('hide');
    $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
    $('#errorMsg').css('visibility', 'visible');
});

    $('#txtNewPassword, #txtConfirmPassword').on('input propertychange paste keyup', function (event) {
        var id = $(this).attr('id');
        var password = $('#' + id).val();
        if (password == null || password == '' || password.length < 8) {
            $('#' + id).parent().addClass('has-error');
        } else {
            $('#' + id).parent().removeClass('has-error');
        }
    });

    $("#btnSave").click(function () {
        $('#btnSave').attr('disabled', true);
        
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');

        var isFormValid = formInputValidation("frmChangePassword", 'save');
        if (!isFormValid) {
            //$("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            //$('#errorMsg').css('visibility', 'visible');

            //$('#btnSave').attr('disabled', false);
            DisplayErrorMessage(Messages.INVALID_INPUT_MESSAGE);
            return false;
        }

        if ($('#txtNewPassword').val() == $('#txtOldPassword').val()) {
            DisplayErrorMessage("New Password should not be the same as Old Password");
            return false;
        }
        if ($('#txtNewPassword').val() != $('#txtConfirmPassword').val()) {
            DisplayErrorMessage("New Password and Confirm New Password do not match");
            return false;
        }

        var RegExVal = /^(?=.*\d)(?=.*[_~!@./#&%^*$\\\\+-])(?=.*[a-z])(?=.*[A-Z])[a-zA-Z\d_~!@./#&%^$*\\\\+-]{8,14}$/;
        if (!RegExVal.test($('#txtNewPassword').val())) {
            DisplayErrorMessage("Password length should be 8 to 14 characters, should include upper case letters,lower case letters, digits and special characters");
            return false;
        }

        $('#myPleaseWait').modal('show');

        var saveObj = {
            OldPassword: $('#txtOldPassword').val(),
            NewPassword: $('#txtNewPassword').val()
        };

        var primaryId = $("#hdnPrimaryID").val();
        if (primaryId != null) {
            saveObj.Timestamp = $('#hdnTimestamp').val();
        }
        else {
            saveObj.Timestamp = "";
        }

        var jqxhr = $.post("/api/changePassword/Save", saveObj, function (response) {
            var result = JSON.parse(response);
            $('#btnSave').hide();
            showMessage('', CURD_MESSAGE_STATUS.PC);
            setTimeout(function () {
                window.location.href = "/account/Logoff";
            }, 2000);

            $('#btnSave').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
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
        $('#myPleaseWait').modal('hide');
    });
    });

    function DisplayErrorMessage(message)
    {
        $("div.errormsgcenter").text(message);
        $('#errorMsg').css('visibility', 'visible');
        $('#btnSave').attr('disabled', false);
    }

    $('#txtOldPassword, #txtNewPassword, #txtConfirmPassword').on("cut copy paste", function (e) {
        e.preventDefault();
    });

    $('#btnAddNew').click(function () {
        window.location.reload();
    });

    $("#btnCancel").click(function () {
        window.location.href = "/um/changepassword";
    });
});