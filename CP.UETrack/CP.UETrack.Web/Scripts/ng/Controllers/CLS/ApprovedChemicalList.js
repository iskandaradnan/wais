
var FileTypeValues = "";
var filePrefix = "ACL_";
var ScreenName = "ApprovedChemicalList";
var rowNum2 = 1;

$(document).ready(function () {

    $.get("/api/ApprovedChemicalList/Load")
        .done(function (result) {
            var loadResult = JSON.parse(result);            
            $("#ddlCategory").append("<option value='0' Selected>" + "Select" + "</option>");
            $("#ddlAreaofApplication").append("<option value='0' Selected>" + "Select" + "</option>");

            for (var i = 0; i < loadResult.StatusLovs.length; i++) {                   
                    $("#ddlStatus").append(
                         "<option value=" + loadResult.StatusLovs[i].LovId  + ">" + loadResult.StatusLovs[i].FieldValue + "</option>"
                    );                                                    
                }       
            for (var i = 0; i < loadResult.CategoryLovs.length; i++) {               
                    $("#ddlCategory").append(
                        "<option value=" + loadResult.CategoryLovs[i].LovId + ">" + loadResult.CategoryLovs[i].FieldValue + "</option>"
                    );
                }  
            for (var i = 0; i < loadResult.AreaOfApplicationLovs.length; i++) {
                
                    $("#ddlAreaofApplication").append(
                        "<option value=" + loadResult.AreaOfApplicationLovs[i].LovId + ">" + loadResult.AreaOfApplicationLovs[i].FieldValue + "</option>"
                    );
            }  

            FileTypeValues = "<option value='' Selected>" + "Select" + "</option>";
            FileTypeValues += "<option value='1'>" + "ACL form" + "</option>";
            $("#ddlFileType1").append(FileTypeValues);

            $('#myPleaseWait').modal('hide');
        })
        .fail(function (response) {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
            $('#errorMsgConfigAdditionalFields').css('visibility', 'visible');
        });

    //clicking on 2nd tab restrict
    $(".nav-tabs").click(function () {
        var primaryId = $('#primaryID').val();
        if (primaryId == 0 || primaryId == null || primaryId == undefined || primaryId == "" || primaryId == "0") {
            bootbox.alert(Messages.SAVE_FIRST_TABALERT);
            return false;
        }
    });

    $("#btnSave, #btnSaveandAddNew").click(function () {

        $("div.errormsgcenter").text("");
        var CurrentbtnID = $(this).attr("Id");
        $('#errorMsg').css('visibility', 'hidden');

        var isFormValid = formInputValidation("formApprovedChemical", 'save');

        if (!isFormValid) {

            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
            return false;
        }

        var ApprovedChemicalList = {

            CustomerId: $('#selCustomerLayout').val(),
            FacilityId: $('#selFacilityLayout').val(),
            Category : $('#ddlCategory').val(),
            AreaofApplication: $('#ddlAreaofApplication').val(),
            ChemicalName: $('#txtChemicalName').val(),
            KKMNumber: $('#txtKKMNumber').val(),
            Properties: $('#txtProperties').val(),
            EffectiveFromDate: $('#txtEffectiveFromDate').val(),
            EffectiveToDate: $('#txtEffectiveToDate').val(),
            Status: $("#ddlStatus option:selected").val()
        };

        var primaryId = $("#primaryID").val();
        if (primaryId != null) {
            ApprovedChemicalList.ApprovedChemicalId = primaryId;
            //MstBlock.Timestamp = timeStamp;
        }
        else {
            ApprovedChemicalList.ApprovedChemicalId = 0;
            MstBlock.Timestamp = "";
        }

       

        var jqxhr = $.post("/Api/ApprovedChemicalList/Save", ApprovedChemicalList, function (response) {
            var result = JSON.parse(response);

            $("#primaryID").val(result.ApprovedChemicalId);
            var StatusId = $("#primaryID").val();   
           showMessage('Approved ChemicalList', CURD_MESSAGE_STATUS.SS);
                                                  
            $("#grid").trigger('reloadGrid');
           

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

            });



    });

    //Reset Functionality...

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
    
    $("#ddlStatus").change(function () {

        var StateValue = $('#ddlStatus option:selected').text();
        if (StateValue == 'Active') {
            $('#txtEffectiveToDate').val("");
            $("#txtEffectiveToDate").prop('disabled', true);            
        }
        else {
            var val = "";
            var date = new Date();
            var months = ["Jan", "Feb", "Mar", "Apr",
                "May", "Jun", "Jul", "Aug",
                "Sep", "Oct", "Nov", "Dec"];
            var val = date.getDate() + "-" + months[date.getMonth()] + "-" + date.getFullYear();
            $("#txtEffectiveToDate").val(val);
            $("#txtEffectiveToDate").prop('disabled', false);
        }       
    });

    $('#ddlCategory').on('change', function () {

        $('#category').removeClass('has-error');
    });

    $('#ddlAreaofApplication').on('change', function () {

        $('#Area').removeClass('has-error');
    });

    $('#txtChemicalName').keypress(function () {

        $('#Chemicalname').removeClass('has-error');
    });

    $('#txtKKMNumber').keypress(function () {

        $('#Kmmno').removeClass('has-error');
    });

    $('#txtProperties').keypress(function () {

        $('#property').removeClass('has-error');
    });

    $('#txtEffectiveFromDate').change(function () {

        $('#EffectiveFromDate').removeClass('has-error');
        $('#errorMsg').css('visibility', 'hidden');
    });

    $('#ddlCategory').change(function () {

        var Category = $('#ddlCategory').val();
        if (Category == 'AirFreshener') {
            $('#ddlAreaofApplication').val('Kitchen/Engineering');
        }
        else if (Category == 'Degreaser') {
            $('#ddlAreaofApplication').val('WorkShop');
        }
        else if (Category == 'Disinfectant') {
            $('#ddlAreaofApplication').val('EngineeringDepartment');
        }
        else if (Category == 'FloorCare') {
            $('#ddlAreaofApplication').val('HardFloors');
        }
        else if (Category == 'HandWashing') {
            $('#ddlAreaofApplication').val('KitchenUtensils');
        }
        //else if (Category == 'Polisher') {
        //    $('#ddlAreaofApplication').val('FoodContactSurfaces');
        //}
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
        //$('#btnSave').hide();
        //$('#btnSaveandAddNew').hide();
        $('#btnNextScreenSave').show();
    }
    $('#spnActionType').text(action);

    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/ApprovedChemicalList/Get/" + primaryId)
            .done(function (result) {

                var getResult = JSON.parse(result);
                $('#ddlCategory').val(getResult.Category);
                $('#ddlAreaofApplication').val(getResult.AreaofApplication);                
                $('#txtChemicalName').val(getResult.ChemicalName);
                $('#txtKKMNumber').val(getResult.KKMNumber);
                $('#txtProperties').val(getResult.Properties);
                $('#ddlStatus').val(getResult.Status);

                var effectiveFromDate = getCustomDate(getResult.EffectiveFromDate);
                $('#txtEffectiveFromDate').val(effectiveFromDate);

                if (getResult.EffectiveToDate != null) {
                    var effectiveToDate = getCustomDate(getResult.EffectiveToDate);
                    $('#txtEffectiveToDate').val(effectiveToDate);
                    $("#txtEffectiveToDate").prop('disabled', false);
                }
                else {
                    $('#txtEffectiveToDate').val('');
                    $("#txtEffectiveToDate").prop('disabled', true);
                }

               
                fillAttachment(getResult.AttachmentList);
                
                               
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

function EmptyFields() {

    $('#formApprovedChemical')[0].reset();
    $('#primaryID').val(0);
    $("#grid").trigger('reloadGrid');
    $('#category').removeClass('has-error');
    $('#Area').removeClass('has-error');
    $('#Chemicalname').removeClass('has-error');
    $('#Kmmno').removeClass('has-error');
    $('#property').removeClass('has-error');
    $('#status').removeClass('has-error');
    $('#EffectiveFromDate').removeClass('has-error');
    $("#txtEffectiveToDate").prop('disabled', true);   
    $('#errorMsg').css('visibility', 'hidden');

    $('#InsertStatus').html('');
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


