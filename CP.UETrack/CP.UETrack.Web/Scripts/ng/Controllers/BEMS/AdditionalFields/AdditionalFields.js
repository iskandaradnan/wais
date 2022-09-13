$('#liConfigAdditionalFields').click(function loadSNFTab() {

    var FieldTypeValues = null;
    var YesNoValues = null;
    var ConfigPatternValues = null;

var primaryId = $('#primaryID').val();
    if (primaryId == 0) {
        bootbox.alert("Customer details must be saved before entering additional information");
        return false;
    }
    else {
        $('#selScreenName').val('null');
       $('#tblAdditionalFields > tbody').children('tr:not(:first)').remove();
        $('#chkAdditionalFieldsDeleteAll').prop('checked', false).attr('disabled', true);
        $('#chkAdditionalFieldsDelete_0').prop('checked', false).attr('disabled', true);
        $('#chkAdditionalFieldsDelete_0').parent().removeClass('bgDelete');
        $('#selAddFieldFieldType_0').val('null').attr('disabled', true);
        $('#txtAddFieldName_0').val(null).attr('disabled', true);
        $('#txtAddFieldDropdownValues_0').val(null).attr('disabled', true);
        $('#selAddFieldRequired_0').val('null').attr('disabled', true);
        $('#selAddFieldPattern_0').val('null').attr('disabled', true);
        $('#txtAddFieldMaxLength_0').val(null).attr('disabled', true);

        $('#selAddFieldFieldType_0').parent().removeClass('has-error');
        $('#txtAddFieldName_0').parent().removeClass('has-error');
        $('#txtAddFieldDropdownValues_0').parent().removeClass('has-error');
        $('#selAddFieldRequired_0').parent().removeClass('has-error');
        $('#selAddFieldPattern_0').parent().removeClass('has-error');
        $('#txtAddFieldMaxLength_0').parent().removeClass('has-error');

        RemoveRequired();
        $('#anchorAddFieldAddNew').hide();

        $('#errorMsgConfigAdditionalFields').css('visibility', 'hidden');
        $('#errorMsg').css('visibility', 'hidden');

        formInputValidation("frmConfigAdditionalTabs");
        
        $.get("/api/additionalFields/Load")
        .done(function (result) {
            var loadResult = JSON.parse(result);
        
            $('#selScreenName').children('option:not(:first)').remove();
            $.each(loadResult.ConfigScreenNameValues, function (index, value) {
                $('#selScreenName').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });

            $('#selAddFieldFieldType_0').children('option:not(:first)').remove();
            $.each(loadResult.FieldTypeValues, function (index, value) {
                $('#selAddFieldFieldType_0').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });

            $('#selAddFieldRequired_0').children('option:not(:first)').remove();
            $.each(loadResult.YesNoValues, function (index, value) {
                $('#selAddFieldRequired_0').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });

            $('#selAddFieldPattern_0').children('option:not(:first)').remove();
            $.each(loadResult.ConfigPatternValues, function (index, value) {
                $('#selAddFieldPattern_0').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });

            //BindEvensForCheckBox();
            //BindEvnetForFieldType()

            FieldTypeValues = loadResult.FieldTypeValues;
            YesNoValues = loadResult.YesNoValues;
            ConfigPatternValues = loadResult.ConfigPatternValues;
           
            $('#myPleaseWait').modal('hide');
        })
    .fail(function (response) {
        $('#myPleaseWait').modal('hide');
        $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
        $('#errorMsgConfigAdditionalFields').css('visibility', 'visible');
    });

        function BindDefaultRow() {
            $('#tblAdditionalFields > tbody').children('tr').remove();
            var tableRow = ' <tr><td width="5%" style="text-align:center"><input type="checkbox" id="chkAdditionalFieldsDelete_0" /></td>' +
                            '<td width="16%"><div><input type="hidden" id="hdnAddFieldConfigId_0" value="" />' +
                            '<input type="hidden" id="hdnAddFieldFieldName_0" value="" /><select id="selAddFieldFieldType_0" class="form-control" required><option value="null">Select</option></select></div></td>' +
                            '<td width="15%"><div><input type="text" id="txtAddFieldName_0" maxlength="100" pattern="^[a-zA-Z0-9\\-\\(\\)\\/\\s]+$" class="form-control" style="max-width:100%" required/></div></td>' +
                            '<td width="25%"><div><input type="text" id="txtAddFieldDropdownValues_0" maxlength="1000" class="form-control" style="max-width:100%" required /></div></td>' +
                            '<td width="12%"><div><select id="selAddFieldRequired_0" class="form-control" required><option value="null">Select</option></select></div></td>' +
                            '<td width="19%"><div><select id="selAddFieldPattern_0" class="form-control" required><option value="null">Select</option></select></div></td>' +
                            '<td width="8%"><div><input type="text" pattern="^[0-9]+$" class="form-control text-right" style="max-width:100%" id="txtAddFieldMaxLength_0" maxlength="3" required /></div></td>' +
                                '</tr>';
            $('#tblAdditionalFields > tbody').append(tableRow);

            $('#txtAddFieldDropdownValues_0').attr('pattern', '^[a-zA-Z0-9\'.\'\",:;/\\(\\),\\+\\-\\s!@#$%*"&]+$');

            $.each(FieldTypeValues, function (index, value) {
                $('#selAddFieldFieldType_0').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $.each(YesNoValues, function (index, value) {
                $('#selAddFieldRequired_0').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $.each(ConfigPatternValues, function (index, value) {
                $('#selAddFieldPattern_0').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            BindEvensForCheckBox();
            BindEvnetForFieldType();
            formInputValidation('tblAdditionalFields');

            if ($('#selScreenName').val() == 'null') {
                $('#chkAdditionalFieldsDeleteAll').attr('disabled', true);
                $('#chkAdditionalFieldsDelete_0').attr('disabled', true);
                $('#selAddFieldFieldType_0').attr('disabled', true);
                $('#txtAddFieldName_0').attr('disabled', true);
                $('#txtAddFieldDropdownValues_0').attr('disabled', true);
                $('#selAddFieldRequired_0').attr('disabled', true);
                $('#selAddFieldPattern_0').attr('disabled', true);
                $('#txtAddFieldMaxLength_0').attr('disabled', true);

                RemoveRequired();
            }
        }
        $('#selScreenName').unbind('change');
        $('#selScreenName').change(function () {
            $("div.errormsgcenter").text("");
            $('#errorMsgConfigAdditionalFields').css('visibility', 'hidden');
            $('#chkAdditionalFieldsDeleteAll').prop('checked', false);
            var screenId = $('#selScreenName').val();
            if (screenId == "null") {
                $('#anchorAddFieldAddNew').hide();
                BindDefaultRow();
            }
            else {
                $('#myPleaseWait').modal('show');
                var primaryId1 = $('#primaryID').val();
                $.get("/api/additionalFields/Get/" +primaryId1 + "/" +screenId)
                  .done(function (result) {
                      var getResult = JSON.parse(result);
                      if (getResult.additionalFields != null && getResult.additionalFields.length > 0) {
                          $('#tblAdditionalFields > tbody').children('tr').remove();
                          $.each(getResult.additionalFields, function (index1, value1) {

                              var tableRow = ' <tr><td width="5%" style="text-align:center"><input type="checkbox" id="chkAdditionalFieldsDelete_' + index1 + '" /></td>' +
                                  '<td width="16%"><div><input type="hidden" id="hdnAddFieldConfigId_' + index1 + '" value="" />' +
                                  '<input type="hidden" id="hdnAddFieldFieldName_' + index1 + '" value="" /><select id="selAddFieldFieldType_' + index1 + '" class="form-control" required><option value="null">Select</option></select></div></td>' +
                                  '<td width="15%"><div><input type="text" id="txtAddFieldName_' + index1 + '" maxlength="100" pattern="^[a-zA-Z0-9\\-\\(\\)\\/\\s]+$" class="form-control" style="max-width:100%" required/></div></td>' +
                                  '<td width="25%"><div><input type="text" id="txtAddFieldDropdownValues_' + index1 + '" maxlength="1000" class="form-control" style="max-width:100%" required /></div></td>' +
                                  '<td width="12%"><div><select id="selAddFieldRequired_' + index1 + '" class="form-control" required><option value="null">Select</option></select></div></td>' +
                                  '<td width="19%"><div><select id="selAddFieldPattern_' + index1 + '" class="form-control" required><option value="null">Select</option></select></div></td>' +
                                  '<td width="8%"><div><input type="text" pattern="^[0-9]+$" class="form-control text-right" style="max-width:100%" id="txtAddFieldMaxLength_' + index1 + '" maxlength="3" required /></div></td>' +
                                  '</tr>';
                              $('#tblAdditionalFields > tbody').append(tableRow);

                              $('#txtAddFieldDropdownValues_' + index1).attr('pattern', '^[a-zA-Z0-9\'.\'\",:;/\\(\\),\\+\\-\\s!@#$%*"&]+$');

                              $.each(FieldTypeValues, function (index, value) {
                                  $('#selAddFieldFieldType_' + index1).append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
                              });
                              $.each(YesNoValues, function (index, value) {
                                  $('#selAddFieldRequired_' + index1).append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
                              });
                              $.each(ConfigPatternValues, function (index, value) {
                                  $('#selAddFieldPattern_' + index1).append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
                              });

                              $('#hdnAddFieldConfigId_' + index1).val(value1.AddFieldConfigId);
                              if (value1.IsUsed) {
                                  $('#selAddFieldFieldType_' + index1).attr('disabled', true).val(value1.FieldTypeLovId);
                                  $('#txtAddFieldName_' + index1).attr('disabled', true).val(value1.Name);
                                  $('#txtAddFieldDropdownValues_' + index1).attr('disabled', true).val(value1.DropDownValues);
                                  $('#selAddFieldRequired_' + index1).attr('disabled', true).val(value1.RequiredLovId);
                                  $('#selAddFieldPattern_' + index1).attr('disabled', true).val(value1.PatternLovId == null || value1.PatternLovId == 0 ? "null" : value1.PatternLovId);
                                  $('#txtAddFieldMaxLength_' + index1).attr('disabled', true).val(value1.MaxLength == null || value1.MaxLength == 0 ? null : value1.MaxLength);
                                  $('#chkAdditionalFieldsDelete_' + index1).attr('disabled', true);

                                  $('#selAddFieldFieldType_' + index1).removeAttr('required');
                                  $('#txtAddFieldName_' + index1).removeAttr('required');
                                  $('#txtAddFieldDropdownValues_' + index1).removeAttr('required');
                                  $('#selAddFieldRequired_' + index1).removeAttr('required');
                                  $('#selAddFieldPattern_' + index1).removeAttr('required');
                                  $('#txtAddFieldMaxLength_' + index1).removeAttr('required');
                              }
                              else {
                                  $('#selAddFieldFieldType_' +index1).val(value1.FieldTypeLovId);
                                  $('#txtAddFieldName_' + index1).val(value1.Name);
                                  $('#txtAddFieldDropdownValues_' +index1).val(value1.DropDownValues);
                                  $('#selAddFieldRequired_' +index1).val(value1.RequiredLovId);
                                  $('#selAddFieldPattern_' +index1).val(value1.PatternLovId == null || value1.PatternLovId == 0 ? "null" : value1.PatternLovId);
                                  $('#txtAddFieldMaxLength_' +index1).val(value1.MaxLength == null || value1.MaxLength == 0 ? null: value1.MaxLength);
                                  $('#chkAdditionalFieldsDelete_' + index1);

                                  var fieldTypeLovId = value1.FieldTypeLovId;
                                  if (fieldTypeLovId == 324) {
                                       $('#txtAddFieldDropdownValues_' +index1).attr('required', true);
                                        $('#selAddFieldPattern_' +index1).removeAttr('required');
                                        $('#txtAddFieldMaxLength_' +index1).removeAttr('required');

                                        $('#txtAddFieldDropdownValues_' +index1).attr('disabled', false);

                                        //$('#selAddFieldPattern_' +index1).val("null");
                                        $('#selAddFieldPattern_' +index1).attr('disabled', true);
                                        //$('#txtAddFieldMaxLength_' +index1).val(null);
                                        $('#txtAddFieldMaxLength_' +index1).attr('disabled', true);

                                        //$('#selAddFieldPattern_' +index1).parent().removeClass('has-error');
                                        //$('#txtAddFieldMaxLength_' +index1).parent().removeClass('has-error');
                                  } else if (fieldTypeLovId == 325) {
                                     $('#selAddFieldPattern_' +index1).attr('required', true);
                                    $('#txtAddFieldMaxLength_' +index1).attr('required', true);
                                    $('#txtAddFieldDropdownValues_' +index1).removeAttr('required');
                                    //$('#txtAddFieldDropdownValues_' +index1).val(null);
                                    $('#txtAddFieldDropdownValues_' +index1).attr('disabled', true);
                                    //$('#txtAddFieldDropdownValues_' +index1).parent().removeClass('has-error');

                                    $('#selAddFieldPattern_' +index1).attr('disabled', false);
                                    $('#txtAddFieldMaxLength_' +index1).attr('disabled', false);
                                  }

                                      //$('#selAddFieldFieldType_' +index1).removeAttr('required');
                                      //$('#txtAddFieldName_' +index1).removeAttr('required');
                                      //$('#txtAddFieldDropdownValues_' +index1).removeAttr('required');
                                      //$('#selAddFieldRequired_' +index1).removeAttr('required');
                                      //$('#selAddFieldPattern_' +index1).removeAttr('required');
                                      //$('#txtAddFieldMaxLength_' +index1).removeAttr('required');
                              }
                          });
                            BindEvensForCheckBox();
                            BindEvnetForFieldType();
                            formInputValidation('tblAdditionalFields');
                      } else
                          {
                            BindDefaultRow();
                      }
                      
                      $('#anchorAddFieldAddNew').show();
                      $("#selScreenName").parent().removeClass('has-error');
                      $('#chkAdditionalFieldsDeleteAll').attr('disabled', false);
                      $('#myPleaseWait').modal('hide');
                 })
                .fail(function (response) {
                        $('#myPleaseWait').modal('hide');
                        $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
                        $('#errorMsgConfigAdditionalFields').css('visibility', 'visible');
                });
            }
            });

function RemoveRequired()
{ 
        $('#selAddFieldFieldType_0').removeAttr('required');
        $('#txtAddFieldName_0').removeAttr('required');
        $('#txtAddFieldDropdownValues_0').removeAttr('required');
        $('#selAddFieldRequired_0').removeAttr('required');
        $('#selAddFieldPattern_0').removeAttr('required');
        $('#txtAddFieldMaxLength_0').removeAttr('required');
}

$("#btnAddEditConfigAdditionalFieldsSave").unbind('click');
$("#btnAddEditConfigAdditionalFieldsSave").click(function () {
$('#btnAddEditConfigAdditionalFieldsSave').attr('disabled', true);


    $("div.errormsgcenter").text("");
    $('#errorMsgConfigAdditionalFields').css('visibility', 'hidden');

    //if ($('#selScreenName').val() == 'null') {

    //    $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
    //        $('#errorMsgConfigAdditionalFields').css('visibility', 'visible');
    //        $('#btnAddEditConfigAdditionalFieldsSave').attr('disabled', false);
    //        return false;
    //}

    var isFormValid = tableInputValidation('frmConfigAdditionalTabs', 'save', 'chkAdditionalFieldsDelete');
    if (!isFormValid) {
        $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        $('#errorMsgConfigAdditionalFields').css('visibility', 'visible');

        $('#btnAddEditConfigAdditionalFieldsSave').attr('disabled', false);
        return false;
        }

        var allChecked = true
        $("#tblAdditionalFields tr").each(function (index, value) {
            if (index == 0) return;
            var index1 = index -1;
            if (!$('#chkAdditionalFieldsDelete_' +index1).prop('checked')) {
                allChecked = false;
        }
        });
             if (allChecked) {
                bootbox.alert(Messages.CAN_NOT_DELETE_ALL_RECORDS);
                $('#btnAddEditConfigAdditionalFieldsSave').attr('disabled', false);
                return false;
                }

            var AdditionalFieldsConfig = { 
        };
            var additionalFieldsList = [];

            var totalRecords = 0;
            var recordsSelectedForDeletion = false;
            var deletedRowNumber = '';
            var maxlengthZero = false;

            $("#tblAdditionalFields tr").each(function (index, value) {
            if (index == 0) return;
            var index1 = index - 1;

            var isDeleted = $('#chkAdditionalFieldsDelete_' + index1).prop('checked')
            var isDisabled = $('#chkAdditionalFieldsDelete_' + index1).prop('disabled')

            if (isDeleted) {
                deletedRowNumber += index + ',';
            }
            
             
            var addFieldConfigId = $('#hdnAddFieldConfigId_' + index1).val();
            if (!isDeleted || (isDeleted && (addFieldConfigId != null && addFieldConfigId != '' && addFieldConfigId != 0))) {//if (!isDeleted && !isDisabled) 
            var additionalFieldsObj = {
                AddFieldConfigId: addFieldConfigId,
                CustomerId: $('#primaryID').val(),
                ScreenNameLovId: $('#selScreenName').val(),
                FieldTypeLovId: $('#selAddFieldFieldType_' + index1).val(),
                Name : $('#txtAddFieldName_' + index1).val(),
                DropDownValues: $('#txtAddFieldDropdownValues_' +index1).val(),
                RequiredLovId: $('#selAddFieldRequired_' + index1).val(),
                PatternLovId : $('#selAddFieldPattern_' + index1).val(),
                MaxLength : $('#txtAddFieldMaxLength_' +index1).val(),
                IsDeleted: isDeleted

            }

            if (additionalFieldsObj.FieldTypeLovId == 325) {
                if (additionalFieldsObj.MaxLength == 0) {
                    maxlengthZero = true;
                }
            }

            //Chckval = $("#selAddFieldFieldType_" + index1).val();

          
            //if (Chckval == 325) {
            //    if ($('#txtAddFieldMaxLength_' + index1 == 0)) {
            //        $("div.errormsgcenter").text("Max Length Value should be Greater than Zero.");
            //        $('#errorMsgConfigAdditionalFields').css('visibility', 'visible');
            //        $('#btnAddEditConfigAdditionalFieldsSave').attr('disabled', false);
            //        return false;
            //    }
            //}
            if (!isDeleted) {
                totalRecords++;
            }
                additionalFieldsList.push(additionalFieldsObj);
            }
            if (isDeleted) {
                recordsSelectedForDeletion = true;
            }
                AdditionalFieldsConfig.additionalFields = additionalFieldsList;
            });

            if (maxlengthZero) {
                $("div.errormsgcenter").text("Max Length Value should be Greater than Zero");
                $('#errorMsgConfigAdditionalFields').css('visibility', 'visible');
                $('#btnAddEditConfigAdditionalFieldsSave').attr('disabled', false);
                return false;
            }

            if (totalRecords > 10) {
                bootbox.alert('Cannot add more than 10 rows');
                $('#btnAddEditConfigAdditionalFieldsSave').attr('disabled', false);
                return false;
                }

            if (AdditionalFieldsConfig.additionalFields.length == 0) {

                $("div.errormsgcenter").text("There are no records to save");
                $('#errorMsgConfigAdditionalFields').css('visibility', 'visible');

                if (deletedRowNumber != '') {
                    var deletedIndexes = deletedRowNumber.split(',');
                    $.each(deletedIndexes, function (index4, value4) {
                        if (value4 != '') {
                            $('#tblAdditionalFields tr:nth-child(' + value4 + ')').remove();
                        }
                    });
                }

                $('#btnAddEditConfigAdditionalFieldsSave').attr('disabled', false);
                return false;
            }

            if (recordsSelectedForDeletion) {
                bootbox.confirm(Messages.MULTIPLE_DELETE_CONFIRMATION, function (result) {
                    if (result) {
                        SaveAdditionalFields(AdditionalFieldsConfig)
                    }
                    else {
                        $('#btnAddEditConfigAdditionalFieldsSave').attr('disabled', false);
                    }
                });
            }
            else {
                SaveAdditionalFields(AdditionalFieldsConfig);
            }
});

function SaveAdditionalFields(AdditionalFieldsConfig)
{
    $('#myPleaseWait').modal('show');
    var jqxhr = $.post("/api/additionalFields/Save", AdditionalFieldsConfig, function (response) {
        var result = JSON.parse(response);

        //$('#tblAdditionalFields > tbody').children('tr:not(:first)').remove();
        $('#tblAdditionalFields > tbody').children('tr').remove();
        $('#chkAdditionalFieldsDeleteAll').prop('checked', false);

        if (result != null && result.additionalFields.length > 0) {
            $.each(result.additionalFields, function (index1, value1) {
                var tableRow = ' <tr><td width="5%" style="text-align:center"><input type="checkbox" id="chkAdditionalFieldsDelete_' + index1 + '" /></td>' +
                        '<td width="16%"><div><input type="hidden" id="hdnAddFieldConfigId_' + index1 + '" value="" />' +
                        '<input type="hidden" id="hdnAddFieldFieldName_' + index1 + '" value="" /><select id="selAddFieldFieldType_' + index1 + '" class="form-control" required><option value="null">Select</option></select></div></td>' +
                        '<td width="15%"><div><input type="text" id="txtAddFieldName_' + index1 + '" maxlength="100" pattern="^[a-zA-Z0-9\\-\\(\\)\\/\\s]+$" class="form-control" style="max-width:100%" required/></div></td>' +
                        '<td width="25%"><div><input type="text" id="txtAddFieldDropdownValues_' + index1 + '" maxlength="1000" class="form-control" style="max-width:100%" required /></div></td>' +
                        '<td width="12%"><div><select id="selAddFieldRequired_' + index1 + '" class="form-control" required><option value="null">Select</option></select></div></td>' +
                        '<td width="19%"><div><select id="selAddFieldPattern_' + index1 + '" class="form-control" required><option value="null">Select</option></select></div></td>' +
                        '<td width="8%"><div><input type="text" pattern="^[0-9]+$" class="form-control text-right" style="max-width:100%" id="txtAddFieldMaxLength_' + index1 + '" maxlength="3" required /></div></td>' +
                        '</tr>';
                $('#tblAdditionalFields > tbody').append(tableRow);

                $('#txtAddFieldDropdownValues_' + index1).attr('pattern', '^[a-zA-Z0-9\'.\'\",:;/\\(\\),\\+\\-\\s!@#$%*"&]+$');

                $.each(FieldTypeValues, function (index, value) {
                    $('#selAddFieldFieldType_' + index1).append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
                });
                $.each(YesNoValues, function (index, value) {
                    $('#selAddFieldRequired_' + index1).append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
                });
                $.each(ConfigPatternValues, function (index, value) {
                    $('#selAddFieldPattern_' + index1).append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
                });
               
                $('#hdnAddFieldConfigId_' + index1).val(value1.AddFieldConfigId);
                if (value1.IsUsed) {
                    $('#selAddFieldFieldType_' + index1).attr('disabled', true).val(value1.FieldTypeLovId);
                    $('#txtAddFieldName_' + index1).attr('disabled', true).val(value1.Name);
                    $('#txtAddFieldDropdownValues_' + index1).attr('disabled', true).val(value1.DropDownValues);
                    $('#selAddFieldRequired_' + index1).attr('disabled', true).val(value1.RequiredLovId);
                    $('#selAddFieldPattern_' + index1).attr('disabled', true).val(value1.PatternLovId == null || value1.PatternLovId == 0 ? "null" : value1.PatternLovId);
                    $('#txtAddFieldMaxLength_' + index1).attr('disabled', true).val(value1.MaxLength == null || value1.MaxLength == 0 ? null : value1.MaxLength);
                    $('#chkAdditionalFieldsDelete_' + index1).attr('disabled', true);

                    $('#selAddFieldFieldType_' + index1).removeAttr('required');
                    $('#txtAddFieldName_' + index1).removeAttr('required');
                    $('#txtAddFieldDropdownValues_' + index1).removeAttr('required');
                    $('#selAddFieldRequired_' + index1).removeAttr('required');
                    $('#selAddFieldPattern_' + index1).removeAttr('required');
                    $('#txtAddFieldMaxLength_' + index1).removeAttr('required');
                }
                else {
                    $('#selAddFieldFieldType_' + index1).val(value1.FieldTypeLovId);
                    $('#txtAddFieldName_' + index1).val(value1.Name);
                    $('#txtAddFieldDropdownValues_' + index1).val(value1.DropDownValues);
                    $('#selAddFieldRequired_' + index1).val(value1.RequiredLovId);
                    $('#selAddFieldPattern_' + index1).val(value1.PatternLovId == null || value1.PatternLovId == 0 ? "null" : value1.PatternLovId);
                    $('#txtAddFieldMaxLength_' + index1).val(value1.MaxLength == null || value1.MaxLength == 0 ? null : value1.MaxLength);
                    $('#chkAdditionalFieldsDelete_' + index1);

                    var fieldTypeLovId = value1.FieldTypeLovId;
                    if (fieldTypeLovId == 324) {
                        $('#txtAddFieldDropdownValues_' + index1).attr('required', true);
                        $('#selAddFieldPattern_' + index1).removeAttr('required');
                        $('#txtAddFieldMaxLength_' + index1).removeAttr('required');

                        $('#txtAddFieldDropdownValues_' + index1).attr('disabled', false);

                        //$('#selAddFieldPattern_' +index1).val("null");
                        $('#selAddFieldPattern_' + index1).attr('disabled', true);
                        //$('#txtAddFieldMaxLength_' +index1).val(null);
                        $('#txtAddFieldMaxLength_' + index1).attr('disabled', true);

                        //$('#selAddFieldPattern_' +index1).parent().removeClass('has-error');
                        //$('#txtAddFieldMaxLength_' +index1).parent().removeClass('has-error');
                    } else if (fieldTypeLovId == 325) {
                        $('#selAddFieldPattern_' + index1).attr('required', true);
                        $('#txtAddFieldMaxLength_' + index1).attr('required', true);
                        $('#txtAddFieldDropdownValues_' + index1).removeAttr('required');
                        //$('#txtAddFieldDropdownValues_' +index1).val(null);
                        $('#txtAddFieldDropdownValues_' + index1).attr('disabled', true);
                        //$('#txtAddFieldDropdownValues_' +index1).parent().removeClass('has-error');

                        $('#selAddFieldPattern_' + index1).attr('disabled', false);
                        $('#txtAddFieldMaxLength_' + index1).attr('disabled', false);
                    }
                }

            });

            BindEvensForCheckBox();
            BindEvnetForFieldType();
            formInputValidation('tblAdditionalFields');
            //BindEvensForCheckBox();
            //BindEvnetForFieldType();
            //formInputValidation('tblAdditionalFields');
        }
        $(".content").scrollTop(0);
        showMessage('', CURD_MESSAGE_STATUS.SS);
        $('#btnAddEditConfigAdditionalFieldsSave').attr('disabled', false);
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
    $('#errorMsgConfigAdditionalFields').css('visibility', 'visible');

    $('#btnAddEditConfigAdditionalFieldsSave').attr('disabled', false);

    $('#myPleaseWait').modal('hide');
});
}

   $("#btnConfigurationCancel").click(function () {
                    window.location.href = "/bems/customer";
        });
    }

    $('#anchorAddFieldAddNew').unbind('click');
    $('#anchorAddFieldAddNew').click(function () {
        $('#errorMsgConfigAdditionalFields').css('visibility', 'hidden');

        var fieldType = '';
        var name = '';
        var dropdownValues = '';
        var required = '';
        var pattern = '';
        var errorMessage = '';

        var fieldTypeId = '';
        var nameId = '';
        var dropdownValuesId = '';
        var requiredId = '';
        var patternId = '';

        var dropdownRequired = false;
        var patternRequired = false;

        $('#tblAdditionalFields tr').each(function (index, value) {
            if (index == 0) return;
            var index1 = index - 1;

            $('#selScreenName').removeAttr('required');

            if (!tableInputValidation('frmConfigAdditionalTabs', 'save', 'chkAdditionalFieldsDelete'))
            {
                errorMessage = Messages.ENTER_VALUES_EXISTING_ROW;
            }
            $('#selScreenName').attr('required', true);
        });
        if (errorMessage != '') {
            bootbox.alert(errorMessage);
            return false;
        }
        else {
            var totalRecords = 0;
            $.each($("input[id^='chkAdditionalFieldsDelete_']"), function (index, value) {
                if (!$('#' +value.id).prop('checked')) {
                    totalRecords++;
                }
            });
            if(totalRecords >= 10) {
                bootbox.alert('Cannot add more than 10 rows');
                return false;
            }

            var index1 = $('#tblAdditionalFields tr').length -1;
            var tableRow = ' <tr><td width="5%" style="text-align:center"><input type="checkbox" id="chkAdditionalFieldsDelete_' +index1 + '" /></td>' +
                           '<td width="16%"><div><input type="hidden" id="hdnAddFieldConfigId_' + index1 + '" value="" />' +
                           '<input type="hidden" id="hdnAddFieldFieldName_' +index1 + '" value="" /><select id="selAddFieldFieldType_' + index1 + '" class="form-control" required><option value="null">Select</option></select></div></td>' +
                           '<td width="15%"><div><input type="text" id="txtAddFieldName_' + index1 + '" maxlength="100" pattern="^[a-zA-Z0-9\\-\\(\\)\\/\\s]+$" class="form-control" style="max-width:100%" required/></div></td>' +
                           '<td width="25%"><div><input type="text" id="txtAddFieldDropdownValues_' + index1 + '" maxlength="1000" class="form-control" style="max-width:100%" required /></div></td>' +
                           '<td width="12%"><div><select id="selAddFieldRequired_' + index1 + '" class="form-control" required><option value="null">Select</option></select></div></td>' +
                           '<td width="19%"><div><select id="selAddFieldPattern_' + index1 + '" class="form-control" required><option value="null">Select</option></select></div></td>' +
                           '<td width="8%"><div><input type="text" pattern="^[0-9]+$" class="form-control text-right" style="max-width:100%" id="txtAddFieldMaxLength_' + index1 + '" maxlength="3" required /></div></td>' +
                           '</tr>';
            $('#tblAdditionalFields > tbody').append(tableRow);

            $('#txtAddFieldDropdownValues_' + index1).attr('pattern', '^[a-zA-Z0-9\'.\'\",:;/\\(\\),\\+\\-\\s!@#$%*"&]+$');

            $.each(FieldTypeValues, function (index, value) {
                $('#selAddFieldFieldType_' +index1).append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $.each(YesNoValues, function (index, value) {
                $('#selAddFieldRequired_' +index1).append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $.each(ConfigPatternValues, function (index, value) {
                $('#selAddFieldPattern_' +index1).append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });

            BindEvensForCheckBox();
            BindEvnetForFieldType();
            formInputValidation('tblAdditionalFields');
            $('#selAddFieldFieldType_' + index1).focus();
        }
    });

    function BindEvensForCheckBox() {
        $("input[id^='chkAdditionalFieldsDelete_']").unbind('click');
        $("input[id^='chkAdditionalFieldsDelete_']").on('click', function () {
            var allChecked = true;
            var isChecked = $(this).prop('checked');
            if (isChecked) {
                $(this).parent().addClass('bgDelete');
            }
            else {
                $(this).parent().removeClass('bgDelete');
            }
            var id = $(this).attr('id');
            var index1;
            $('#tblAdditionalFields tr').each(function (index, value) {
                if (index == 0) return;
                index1 = index - 1;
                if (!$('#chkAdditionalFieldsDelete_' + index1).prop('checked') && !$('#chkAdditionalFieldsDelete_' + index1).attr('disabled')) {
                    allChecked = false;
                }
            });
            if (allChecked) {
                $('#chkAdditionalFieldsDeleteAll').prop('checked', true);
            }
            else {
                $('#chkAdditionalFieldsDeleteAll').prop('checked', false);
            }
        });
    }

    function BindEvnetForFieldType() {
        $("[id^='selAddFieldFieldType_']").unbind('change');
        $("[id^='selAddFieldFieldType_']").on('change', function () {
            var id = $(this).attr('id');
            var index = id.substring(id.indexOf('_') + 1);
            if ($(this).val() == 325 || $(this).val() == 326) {//Textbox
                $('#selAddFieldPattern_' +index).attr('required', true);
                $('#txtAddFieldMaxLength_' +index).attr('required', true);
                $('#txtAddFieldDropdownValues_' +index).removeAttr('required');
                $('#txtAddFieldDropdownValues_' + index).val(null);
                $('#txtAddFieldDropdownValues_' +index).attr('disabled', true);
                $('#txtAddFieldDropdownValues_' + index).parent().removeClass('has-error');

                $('#selAddFieldPattern_' + index).attr('disabled', false);
                $('#txtAddFieldMaxLength_' + index).attr('disabled', false);
            }
            else if ($(this).val() == 324) {
                $('#txtAddFieldDropdownValues_' +index).attr('required', true);
                $('#selAddFieldPattern_' +index).removeAttr('required');
                $('#txtAddFieldMaxLength_' +index).removeAttr('required');

                $('#txtAddFieldDropdownValues_' +index).attr('disabled', false);

                $('#selAddFieldPattern_' + index).val("null");
                $('#selAddFieldPattern_' + index).attr('disabled', true);
                $('#txtAddFieldMaxLength_' +index).val(null);
                $('#txtAddFieldMaxLength_' +index).attr('disabled', true);

                $('#selAddFieldPattern_' +index).parent().removeClass('has-error');
                $('#txtAddFieldMaxLength_' + index).parent().removeClass('has-error');
            }
            else if($(this).val() == 'null') {
                $('#selAddFieldPattern_' +index).attr('required', true);
                $('#txtAddFieldDropdownValues_' + index).attr('required', true);
                $('#txtAddFieldMaxLength_' +index).attr('required', true);

                 $('#selAddFieldPattern_' +index).attr('disabled', false);
                $('#txtAddFieldMaxLength_' + index).attr('disabled', false);
                $('#txtAddFieldDropdownValues_' +index).attr('disabled', false);
            }
        });
    }

    $('#chkAdditionalFieldsDeleteAll').on('click', function () {
        var isChecked = $(this).prop("checked");
        var index1;
        var count = 0;
        $('#tblAdditionalFields tr').each(function (index, value) {
            if (index == 0) return;
            index1 = index - 1;
            if (isChecked) {
                if(!$('#chkAdditionalFieldsDelete_' +index1).prop('disabled'))
            {
                    $('#chkAdditionalFieldsDelete_' +index1).prop('checked', true);
                    $('#chkAdditionalFieldsDelete_' +index1).parent().addClass('bgDelete');
                    count++;
                }
            }
            else {
                    if(!$('#chkAdditionalFieldsDelete_' +index1).prop('disabled'))
                    {
                        $('#chkAdditionalFieldsDelete_' + index1).prop('checked', false);
                        $('#chkAdditionalFieldsDelete_' + index1).parent().removeClass('bgDelete');
                    }
            }
        });
            if(count == 0){
                $(this).prop("checked", false);
            }
    });

    //$("#btnConfigurationCancel").click(function () {
    //    window.location.href = "/bems/customer";
    //});
    $("#btnConfigAdditionalFieldsCancel").unbind('click');
    $("#btnConfigAdditionalFieldsCancel").click(function () {
        var message = Messages.Reset_Alert_CONFIRMATION;
        bootbox.confirm(message, function (result) {
            if (result) {
                ClearFieldsAdditionalFields();
            }
            else {
                $('#myPleaseWait').modal('hide');
            }
        });
    });

    function ClearFieldsAdditionalFields() {
        $(".content").scrollTop(0);
        $('input[type="text"], textarea').val('');
        $('#btnEdit').hide();
        $('#btnSave').show();
        $('#btnDelete').hide();
        $('#btnNextScreenSave').hide();
        $('#ContactGrid').empty();
        AddFirstGridRow();
        $('#spnActionType').text('Add');
        $('#TypeOfContractLovId').val('null');
        $("#primaryID").val('');
        $('#CustomerName').attr("disabled", false);
        //$('#CustomerCode').removeAttr("disabled");
        $("#grid").trigger('reloadGrid');
        $("#Custform :input:not(:button)").parent().removeClass('has-error');
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
        $('#errorMsgCustomer').css('visibility', 'hidden');
        $('#errorMsgConfigAdditionalFields').css('visibility', 'hidden');

        $('#selScreenName').val('null').trigger('change');

        $("#selDateFormat").val('null');
        $("#selCurrencyFormat").val('null');
        $('#TypeOfContractLovId').val('null');
        $('#chkQAPIndicatorB1,#chkQAPIndicatorB2,#chkKPIIndicatorB1,#chkKPIIndicatorB2').prop('checked', false);
        $('#chkKPIIndicatorB3,#chkKPIIndicatorB4,#chkKPIIndicatorB5,#chkKPIIndicatorB6').prop('checked', false);
        //$("#grid").trigger('reloadGrid');
        $('#showModalImg').hide();
        $('.nav-tabs a:first').tab('show');

        $('#hdnAttachId').val('')
    }
});