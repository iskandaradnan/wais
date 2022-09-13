errorMessaage = "An error occurred while processing your request";
confirmMessage = "You already have an active session. Do you want to terminate the previous session?";

$(document).ready(function () {
    var str = getUrlVars();
    var urlValue = $.urlParam('r'); // name
    var errorMessage = "";
    if(urlValue == 'sto')
    {
        errorMessage = "Your session has expired. Please re-login.";
    }
    else if (urlValue == 'urlt')
    {
        errorMessage = "The URL was tampered. Please re-login.";
    }
    
    if(errorMessage != "")
    displayError(errorMessage);
});

$.urlParam = function (name) {
    var results = new RegExp('[\?&]' + name + '=([^&#]*)').exec(window.location.href);
    if (results != null)
        return results[1] || 0
    else return null;
}

function DisableLoginButton()
{
    $('#btnlogin').attr('disabled', true);
    $('#btnlogin').css('cursor', 'default');
}
function EnableLoginButton() {
    $('#btnlogin').attr('disabled', false);
    $('#btnlogin').css('cursor', 'pointer');
    $('#btnlogin').blur();
}

function LoginAction() {
  DisableLoginButton();
$("#errMsg").hide();
    var login = $.trim($('#username').val()),
pass = $.trim($('#password').val());

    var rem = false;
    rem = jQuery("#RememberMe").input_val();
    var language = $("#selLanguage option:selected").val();
    // Check inputs
    if (login.length === 0) {
        displayError('Please fill in your Username');
        EnableLoginButton();
        return false;
    }
    else if (pass.length === 0) {

        // Display message
        displayError('Please fill in your Password');
		 EnableLoginButton();
        return false;
    }
    else {

        var account = { };

        account.LoginName = login;
        account.Password = pass;
        account.RememberMe = rem;
        account.Language = language;

        var AccessLevel = $('#AccessLevel').val();
        if (AccessLevel == undefined || AccessLevel == null)
        {
            account.AccessLevel = 0;
        }
        else
        {
            account.AccessLevel = AccessLevel;
        }
        var jqxhr = $.post("/api/account/LoginAccount", account, function (response) {
            LoginCustomerCompleted(response, account);
        },
        "json")
         .fail(function (response) {
             RequestFailed(response);
             EnableLoginButton()
         });

    }
    return false;
}
function getUrlVars() {
    var vars = [], hash;
    var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
    for (var i = 0; i < hashes.length; i++) {
        hash = hashes[i].split('=');
        vars.push(hash[0]);
        vars[hash[0]] = hash[1];
    }
    return vars;

}

function LoginCustomerCompleted(response, account) {
    
    var result = JSON.parse(response);
    if (!result.IsAuthenticated || (result.ErrorMessage != '' && result.ErrorMessage != null)) {
        EnableLoginButton();
        displayError(result.ErrorMessage);
        return false;
    }
    

    account.UserId = result.UserId;
    account.StaffName = result.StaffName;
    account.CustomerId = result.CustomerId;
    account.FacilityId = result.FacilityId;
    account.UserTypeId = result.UserTypeId;

    var jqxhr = $.post("/api/account/SetSessionDetails", account, function (response1) {

        if (result.IsMultipleFacility == true) {
            var loginURL = "/";
            window.location.href = loginURL;
        }
        else {
            var loginURL = "/Home/DashboardYtd";
            window.location.href = loginURL;
        }

        //var loginURL = "/";
        //window.location.href = loginURL;
    },
       "json")
        .fail(function (response1) {
            //Display Error Message
            EnableLoginButton()
        });


//request.success(function (result) {
//    var companyHospitalDetails = result;
//    if (companyHospitalDetails != null && companyHospitalDetails.userDetails.IsPasswordExpired) {
//        var loginURL = "/UM/UmChangePassword";
//        window.location.href = loginURL;
//    }
//    else {
//        var loginURL = "/";
//        window.location.href = loginURL;
//    }
//});

//request.error(function(jqXHR, textStatus, errorThrown) {
//    displayError(errorMessaage);
//});
      
}

function RequestFailed(response) {
    EnableLoginButton();
    var errorMessage = '';
    if (response.responseText != undefined) {
        errorMessage = JSON.parse(response.responseText).ReturnMessage[0]
    }
    else {
        errorMessage = 'An error occurred while processing your request';
    }
    displayError(errorMessage);
}

function RequestFailed1(response) {

    var jsonResponse = jsonParse(response.responseText);
    if (jsonResponse.ReturnMessage == "Already logged in") {
           bootbox.confirm({
               message: confirmMessage,
                    buttons: {
                        confirm: {
                            label: "Yes",
                            className: "btn-primary add-space",
                        },
                        cancel: {
                            label: "No",
                            className: "btn-grey pull-right",

                        }
                    },
                    callback: function (result) {
        if (result) {
            account.IsAlreadyLoggedIn = true;
            var jqxhr = $.post("/api/account/SignIn", account, function (response) {
                LoginCustomerCompleted(response);
            },
           "json")
            .fail(function (response) {
			 EnableLoginButton();
                displayError(errorMessaage);
            });
        }
        else {
            EnableLoginButton();
        }
                    }
        });
       
    }
    else {
    
        if (response.status == "404" || jsonResponse == "" || response.status == "404") {
		    EnableLoginButton();
            displayError(errorMessaage);
        }
        else
        {
            if(jsonResponse.ReturnMessage == undefined || jsonResponse.ReturnMessage == '')
            {
			    EnableLoginButton();
                displayError(errorMessaage);
            }
            else
            {
			    EnableLoginButton();
                displayError(jsonResponse.ReturnMessage);
        }
    }
}
}

function displayError(message) {
    $("#errMsg").show();
    $("#errMsgContent").text(message);
};

$("#errMsg").hide();
$("#username").focus();

$("#alert").click(function (event) {
    event.preventDefault();
    $("#errMsg").hide();
});

jQuery.fn.input_val = function () {

    if (jQuery(this).is("input[type=checkbox]")) {
        if (jQuery(this).is(":checked")) {
            return true;
        } else {
            return false;
        }
    } else {
        return jQuery(this).val();
    }
};

$('#username').keypress(function (e) {
    // Allow Tab, Backspace, Delete, Left and Right Arrow keys
    if (e.keyCode != 9 && e.keyCode != 8 && e.keyCode != 46 && e.keyCode != 35 && e.keyCode != 36 && e.keyCode != 37 && e.keyCode != 39) {
    var regex = new RegExp("^[a-zA-Z0-9-.@_]+$");
        var str = String.fromCharCode(!e.charCode ? e.which : e.charCode);
        if (regex.test(str)) {
            return true;
        }
        e.preventDefault();
        return false;
    }
});
$('#eye').click(function (e) {
    var pwd = document.getElementById("password");
    if (pwd.getAttribute("type") == "password") {
        pwd.setAttribute("type", "text");
    } else {
        pwd.setAttribute("type", "password");
    }
});
$('#eyeHover').hover(function (e) {
    var pwd = document.getElementById("password");
    if (pwd.getAttribute("type") == "password") {
        pwd.setAttribute("type", "text");
    } else {
        pwd.setAttribute("type", "password");
    }
});

