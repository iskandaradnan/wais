$('#liConfigurationTab').click(function loadSNFTab() {

    $('#errorMsg').css('visibility', 'hidden');
    $('#errorMsgCustomer').css('visibility', 'hidden');
    
var primaryId = $('#primaryID').val();
    if (primaryId == 0) {
        bootbox.alert("Customer details must be saved before entering additional information");
        return false;
    }
    else {
        
        
        $('#myPleaseWait').modal('show');
        $('#hdnDateFormat').val(1);
        $('#hdnCurrencyFormat').val(2);
        $('#hdnQAPIndicatorB1').val(3);
        $('#hdnQAPIndicatorB2').val(4);
        $('#hdnKPIIndicatorB1').val(5);
        $('#hdnKPIIndicatorB2').val(6);
        $('#hdnKPIIndicatorB3').val(7);
        $('#hdnKPIIndicatorB4').val(8);
        $('#hdnKPIIndicatorB5').val(9);
        $('#hdnKPIIndicatorB6').val(10);
        $('#hdnCustqapMonth').val(11);
        $('#hdnLayoutThemeId').val(12);

        $('#hdnDateFormatConfigValueId').val(0);
        $('#hdnCurrencyFormatConfigValueId').val(0);
        $('#hdnQAPIndicatorB1ConfigValueId').val(0); 
        $('#hdnQAPIndicatorB2ConfigValueId').val(0); 
        $('#hdnKPIIndicatorB1ConfigValueId').val(0); 
        $('#hdnKPIIndicatorB2ConfigValueId').val(0); 
        $('#hdnKPIIndicatorB3ConfigValueId').val(0); 
        $('#hdnKPIIndicatorB4ConfigValueId').val(0); 
        $('#hdnKPIIndicatorB5ConfigValueId').val(0); 
        $('#hdnKPIIndicatorB6ConfigValueId').val(0);
        $('#hdnCustqapMonthConfigValueId').val(0); 
        $('#hdnLayoutThemeConfigValueId').val(0);

        //$('#selDateFormat').val("null");
        //$('#selDateFormat').val("null");

        $('#chkQAPIndicatorB1').prop('checked', false);
        $('#chkQAPIndicatorB2').prop('checked', false);
        $('#chkKPIIndicatorB1').prop('checked', false);
        $('#chkKPIIndicatorB2').prop('checked', false);
        $('#chkKPIIndicatorB3').prop('checked', false);
        $('#chkKPIIndicatorB4').prop('checked', false);
        $('#chkKPIIndicatorB5').prop('checked', false);
        $('#chkKPIIndicatorB6').prop('checked', false);
        $('#chkKPIIndicatorB7').prop('checked', false);
        $('#chkKPIIndicatorB8').prop('checked', false);

        formInputValidation("frmCustomerConfig");
        
        $.get("/api/customerConfig/Load")
        .done(function (result) {
            var loadResult = JSON.parse(result);
            $('#selDateFormat').children('option').remove();
            $('#selCurrencyFormat').children('option').remove();
            $('#selCustqapMonth').children('option').remove();
            $('#selChangeLayoutTheme').children('option').remove();
            $.each(loadResult.DateFormatValues, function (index, value) {
                $('#selDateFormat').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $.each(loadResult.CurrencyFormatValues, function (index, value) {
                $('#selCurrencyFormat').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $.each(loadResult.FMTimeMonth, function (index, value) {
                $('#selCustqapMonth').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $.each(loadResult.ThemeColorValues, function (index, value) {
                $('#selChangeLayoutTheme').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $('#selDateFormat').val(292);
            $('#selCurrencyFormat').val(294);
            $('#selChangeLayoutTheme').val(376);

            $('#selChangeLayoutTheme').find("option[value='376']").css('background-color', '#477baa');
            $('#selChangeLayoutTheme').find("option[value='377']").css('background-color', '#3ab6b7');
            $('#selChangeLayoutTheme').find("option[value='378']").css('background-color', '#eabfc0');
            $('#selChangeLayoutTheme').find("option[value='379']").css('background-color', '#deb887');                      

            if (primaryId != null && primaryId != "0") {
                $.get("/api/customerConfig/Get/" + primaryId)
                  .done(function (result) {
                      var getResult = JSON.parse(result);
                      if (getResult.ConfigurationValues != null && getResult.ConfigurationValues.length > 0) {
                          $.each(getResult.ConfigurationValues, function (index, value) {
                              switch (value.ConfigKeyId)
                              {
                                  case 1: $('#hdnDateFormatConfigValueId').val(value.ConfigValueId); $('#selDateFormat').val(value.ConfigKeyLovId); break;
                                  case 2: $('#hdnCurrencyFormatConfigValueId').val(value.ConfigValueId); $('#selCurrencyFormat').val(value.ConfigKeyLovId); break;

                                  case 3: $('#hdnQAPIndicatorB1ConfigValueId').val(value.ConfigValueId);
                                          $('#chkQAPIndicatorB1').prop('checked', value.ConfigKeyLovId == 99 ? true: false);
                                          break;
                                  case 4: $('#hdnQAPIndicatorB2ConfigValueId').val(value.ConfigValueId);
                                          $('#chkQAPIndicatorB2').prop('checked', value.ConfigKeyLovId == 99 ? true : false);
                                          break;
                                  case 5: $('#hdnKPIIndicatorB1ConfigValueId').val(value.ConfigValueId);
                                          $('#chkKPIIndicatorB1').prop('checked', value.ConfigKeyLovId == 99 ? true : false);
                                          break;
                                  case 6: $('#hdnKPIIndicatorB2ConfigValueId').val(value.ConfigValueId);
                                          $('#chkKPIIndicatorB2').prop('checked', value.ConfigKeyLovId == 99 ? true : false);
                                          break;
                                  case 7: $('#hdnKPIIndicatorB3ConfigValueId').val(value.ConfigValueId);
                                          $('#chkKPIIndicatorB3').prop('checked', value.ConfigKeyLovId == 99 ? true : false);
                                          break;
                                  case 8: $('#hdnKPIIndicatorB4ConfigValueId').val(value.ConfigValueId);
                                          $('#chkKPIIndicatorB4').prop('checked', value.ConfigKeyLovId == 99 ? true : false);
                                          break;
                                  case 9: $('#hdnKPIIndicatorB5ConfigValueId').val(value.ConfigValueId);
                                          $('#chkKPIIndicatorB5').prop('checked', value.ConfigKeyLovId == 99 ? true : false);
                                          break;
                                  case 10: $('#hdnKPIIndicatorB6ConfigValueId').val(value.ConfigValueId);
                                          $('#chkKPIIndicatorB6').prop('checked', value.ConfigKeyLovId == 99 ? true : false);
                                          break;
                                  case 11: $('#hdnCustqapMonthConfigValueId').val(value.ConfigValueId); $('#selCustqapMonth').val(value.ConfigKeyLovId);
                                      break;
                                  case 12: $('#hdnLayoutThemeConfigValueId').val(value.ConfigValueId); $('#selChangeLayoutTheme').val(value.ConfigKeyLovId);
                                      break;
                              }
                          });
                      }
                      $('#myPleaseWait').modal('hide');
                  })
                 .fail(function (response) {
                     $('#myPleaseWait').modal('hide');
                     $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
                     $('#errorMsgCustomer').css('visibility', 'visible');
                 });
            }
            else {
                $('#myPleaseWait').modal('hide');
            }
        })
    .fail(function (response) {
        $('#myPleaseWait').modal('hide');
        $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
        $('#errorMsgCustomer').css('visibility', 'visible');
    });

        function AddObject(hdnConfigValueId, hdnConfigKeyId, hdnConfigKeyLovId)
        {
            var isChecked = $('#' + hdnConfigKeyLovId).is(":checked");
            var configKeyLovId = isChecked ? 99 : 100;
            return obj = {
                ConfigValueId: $('#' + hdnConfigValueId).val(),
                CustomerId: $('#primaryID').val(),
                ConfigKeyId: $('#' + hdnConfigKeyId).val(),
                ConfigKeyLovId: configKeyLovId,
            };
        }

        $("#btnAddEditConfigurationSave").unbind('click');
        $("#btnAddEditConfigurationSave").click(function () {
            $('#btnAddEditConfigurationSave').attr('disabled', true);


            $("div.errormsgcenter").text("");
            $('#errorMsgCustomer').css('visibility', 'hidden');

            var isFormValid = formInputValidation("frmCustomerConfig", 'save');
            if (!isFormValid) {
                $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
                $('#errorMsgCustomer').css('visibility', 'visible');

                $('#btnAddEditConfigurationSave').attr('disabled', false);
                return false;
            }

            $('#myPleaseWait').modal('show');

            var CustomerConfig = {};
            var ConfigurationValues = [];

            ConfigurationValues.push({
                ConfigValueId: $('#hdnDateFormatConfigValueId').val(),
                CustomerId: $('#primaryID').val(),
                ConfigKeyId: $('#hdnDateFormat').val(),
                ConfigKeyLovId: $('#selDateFormat').val()
            });

            ConfigurationValues.push({
                ConfigValueId: $('#hdnCurrencyFormatConfigValueId').val(),
                CustomerId: $('#primaryID').val(),
                ConfigKeyId: $('#hdnCurrencyFormat').val(),
                ConfigKeyLovId: $('#selCurrencyFormat').val(),              

            });

            ConfigurationValues.push({
                ConfigValueId: $('#hdnLayoutThemeConfigValueId').val(),
                CustomerId: $('#primaryID').val(),
                ConfigKeyId: $('#hdnLayoutThemeId').val(),
                ConfigKeyLovId: $('#selChangeLayoutTheme').val(),          

            });

            ConfigurationValues.push(AddObject("hdnQAPIndicatorB1ConfigValueId", "hdnQAPIndicatorB1", "chkQAPIndicatorB1"));
            ConfigurationValues.push(AddObject("hdnQAPIndicatorB2ConfigValueId", "hdnQAPIndicatorB2", "chkQAPIndicatorB2"));
            ConfigurationValues.push(AddObject("hdnKPIIndicatorB1ConfigValueId", "hdnKPIIndicatorB1", "chkKPIIndicatorB1"));
            ConfigurationValues.push(AddObject("hdnKPIIndicatorB2ConfigValueId", "hdnKPIIndicatorB2", "chkKPIIndicatorB2"));
            ConfigurationValues.push(AddObject("hdnKPIIndicatorB3ConfigValueId", "hdnKPIIndicatorB3", "chkKPIIndicatorB3"));
            ConfigurationValues.push(AddObject("hdnKPIIndicatorB4ConfigValueId", "hdnKPIIndicatorB4", "chkKPIIndicatorB4"));
            ConfigurationValues.push(AddObject("hdnKPIIndicatorB5ConfigValueId", "hdnKPIIndicatorB5", "chkKPIIndicatorB5"));
            ConfigurationValues.push(AddObject("hdnKPIIndicatorB6ConfigValueId", "hdnKPIIndicatorB6", "chkKPIIndicatorB6"));

            ConfigurationValues.push({
                ConfigValueId: $('#hdnCustqapMonthConfigValueId').val(),
                CustomerId: $('#primaryID').val(),
                ConfigKeyId: $('#hdnCustqapMonth').val(),
                ConfigKeyLovId: $('#selCustqapMonth').val()
            });
            
            CustomerConfig.ConfigurationValues = ConfigurationValues;

            var jqxhr = $.post("/api/customerConfig/Save", CustomerConfig, function (response) {
                var result = JSON.parse(response);
                if (result.ConfigurationValues != null && result.ConfigurationValues.length > 0) {
                    $.each(result.ConfigurationValues, function (index, value) {
                        switch (value.ConfigKeyId) {
                            case 1: $('#hdnDateFormatConfigValueId').val(value.ConfigValueId); break;
                            case 2: $('#hdnCurrencyFormatConfigValueId').val(value.ConfigValueId); break;
                            case 3: $('#hdnQAPIndicatorB1ConfigValueId').val(value.ConfigValueId); break;
                            case 4: $('#hdnQAPIndicatorB2ConfigValueId').val(value.ConfigValueId); break;
                            case 5: $('#hdnKPIIndicatorB1ConfigValueId').val(value.ConfigValueId); break;
                            case 6: $('#hdnKPIIndicatorB2ConfigValueId').val(value.ConfigValueId); break;
                            case 7: $('#hdnKPIIndicatorB3ConfigValueId').val(value.ConfigValueId); break;
                            case 8: $('#hdnKPIIndicatorB4ConfigValueId').val(value.ConfigValueId); break;
                            case 9: $('#hdnKPIIndicatorB5ConfigValueId').val(value.ConfigValueId); break;
                            case 10: $('#hdnKPIIndicatorB6ConfigValueId').val(value.ConfigValueId); break;
                            case 11: $('#hdnCustqapMonthConfigValueId').val(value.ConfigValueId); break;
                            case 12: $('#hdnLayoutThemeConfigValueId').val(value.ConfigValueId); break;
                        }
                    });
                }
                $(".content").scrollTop(0);
                showMessage('', CURD_MESSAGE_STATUS.SS);
                window.location.href = "/bems/customerregistration";              
                $('#btnAddEditConfigurationSave').attr('disabled', false);

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
            $('#errorMsgCustomer').css('visibility', 'visible');

            $('#btnAddEditConfigurationSave').attr('disabled', false);

            $('#myPleaseWait').modal('hide');
        });
        });

        $("#btnConfigurationCancel").unbind('click');
        $("#btnConfigurationCancel").click(function () {
            var message = Messages.Reset_TabAlert_CONFIRMATION;
            bootbox.confirm(message, function (result) {
                if (result) {
                    ClearFieldsCustomerConfig();
                }
                else {
                    $('#myPleaseWait').modal('hide');
                }
            });
        });
    }
});

function ClearFieldsCustomerConfig() {
    //$('input[type="text"], textarea').val('');
    //$("#selDateFormat").val('null');
    //$("#selCurrencyFormat").val('null');
    //$('#TypeOfContractLovId').val('null');
    //$("#primaryID").val('');
    //$('#chkQAPIndicatorB1,#chkQAPIndicatorB2,#chkKPIIndicatorB1,#chkKPIIndicatorB2').prop('checked', false);
    //$('#chkKPIIndicatorB3,#chkKPIIndicatorB4,#chkKPIIndicatorB5,#chkKPIIndicatorB6').prop('checked', false);
    //$("#grid").trigger('reloadGrid');
    //$("#Custform :input:not(:button)").parent().removeClass('has-error');
    //$("div.errormsgcenter").text("");
    //$('#errorMsg').css('visibility', 'hidden');
    //$('.nav-tabs a:first').tab('show');
    $(".content").scrollTop(0);
    $('input[type="text"], textarea').val('');
    $('#btnEdit').hide();
    $('#btnSave').show();
    $('#btnDelete').hide();
    $('#btnNextScreenSave').hide();
    $('#spnActionType').text('Add');
    $('#TypeOfContractLovId').val('null');
    $("#primaryID").val('');
    $('#CustomerName').attr("disabled", false);
    $('#ContactGrid').empty();
    AddFirstGridRow();
    //$('#CustomerCode').removeAttr("disabled");
    $("#grid").trigger('reloadGrid');
    $("#Custform :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('#errorMsgCustomer').css('visibility', 'hidden');
    $('#errorMsgConfigAdditionalFields').css('visibility', 'hidden');

    $('#selScreenName').val('null').trigger('change');

    $("#selDateFormat").val(292);
    $("#selCurrencyFormat").val(294);
    $('#selChangeLayoutTheme').val(376);

    $('#TypeOfContractLovId').val('null');
    $('#chkQAPIndicatorB1,#chkQAPIndicatorB2,#chkKPIIndicatorB1,#chkKPIIndicatorB2').prop('checked', false);
    $('#chkKPIIndicatorB3,#chkKPIIndicatorB4,#chkKPIIndicatorB5,#chkKPIIndicatorB6').prop('checked', false);
    $('#showModalImg').hide();
    $('.nav-tabs a:first').tab('show');

    $('#hdnAttachId').val('')
}