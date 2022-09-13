$(document).ready(function () {
    $('#myPleaseWait').modal('show');
    formInputValidation("frmRoleScreenPermission");

    var UserRoleType = [];
    var fetchResult = [];
    $("input[id$='All']").attr('disabled', true);
    $('#txtSearch').attr('disabled', true);
    $('#selModule').attr('disabled', true);

    $.get("/api/roleScreenPermission/GetUserRoles")
        .done(function (result) {
            var userRoleResult = JSON.parse(result);
            UserRoleType = userRoleResult;
            $.each(userRoleResult, function (index, value) {
                $('#selUserRole').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $('#myPleaseWait').modal('hide');
        })
  .fail(function (response) {
      $('#myPleaseWait').modal('hide');
      $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
      $('#errorMsg').css('visibility', 'visible');
  });

    $('#btnAddFetch').click(function () {
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');

        var roleId = $('#selUserRole').val();
        var moduleId = $('#selModule').val();

        if (roleId == "null" || moduleId == "null") { return false; }

        $('#myPleaseWait').modal('show');

        $('#tblDataTable > tbody').empty();
        fetchResult = [];
        $("input[id$='All']").prop("checked", false);
        
        $.get("/api/roleScreenPermission/Fetch/" +  roleId + "/" + moduleId)
       .done(function (result) {
           fetchResult = JSON.parse(result);
           if (fetchResult != null) {
               DisplayRows(fetchResult);
               $('#txtSearch').val('');
               $('#txtSearch').attr('disabled', false);
           }
           $('#myPleaseWait').modal('hide');
       })
     .fail(function (response) {
         $('#myPleaseWait').modal('hide');
         $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
         $('#errorMsg').css('visibility', 'visible');
     });
    });

    function DisplayRows(fetchResult)
    {
        var markup = '';
        $.each(fetchResult, function (index, value) {
            var screenPermissionArr = value.ScreenPermissions.split('');
            var disableEnableArr = [];
            var backgroundColorArr = [];
            var backgroundGreen = "";
            $.each(screenPermissionArr, function (index1, value1) {
                disableEnableArr[index1] = value1 == "0" ? "disabled" : "";
                backgroundColorArr[index1] = value1 == "0" ? "" : "; background-color:#dbfccf";
                if (value1 != "0") {
                    backgroundGreen = " background-color:#dbfccf";
                }
            });
           
            markup += '<tr style="font-size: 10px;" class="trItem">'
                       + '<td style="padding-left:5px; padding-top:14px; width:16%; height:50px;">' + value.ScreenDescription + '</td>'

                       + '<td style="padding-left:5px; padding-top:10px; text-align:center;width:4.4%; height:50px;' + backgroundGreen + '">'
                       + '<input type="checkbox" class="checkAllRow" name="chkRowCheckAll' + value.ScreenId + '" id="chkRowCheckAll' + value.ScreenId + '" title="Check All Row Items" />'
                       + '</td>'

                       + '<td style="padding-left:5px; padding-top:10px; text-align:center; height:50px; width:4.4%'+backgroundColorArr[0]+'">'
                       + '<input type="checkbox" class="chkInside" ' + disableEnableArr[0] + ' name="Add-' + value.ScreenId + '" id="chkAdd' + value.ScreenId + '" title="Add" />'
                       + '</td>'

                       + '<td style="padding-left:5px; padding-top:10px; text-align:center; height:50px; width:4.25%' + backgroundColorArr[1] + '">'
                       + '<input type="checkbox" class="chkInside" ' + disableEnableArr[1] + ' name="Edit-' + value.ScreenId + '" id="chkEdit' + value.ScreenId + '" title="Edit" />'
                       + '</td>'

                       //+ '<td style="padding-left:5px; padding-top:10px; text-align:center; height:50px; width:4.05%">'
                       //+ '<input type="checkbox" class="chkInside" ' + disableEnableArr[2] + ' name="View-' + value.ScreenId + '" id="chkView' + value.ScreenId + '" title="View" />'
                       //+ '</td>'

                       + '<td style="padding-left:5px; padding-top:10px; text-align:center; height:50px; width:6.08%' + backgroundColorArr[3] + '">'
                       + '<input type="checkbox" class="chkInside" ' + disableEnableArr[3] + ' name="Delete-' + value.ScreenId + '" id="chkDelete' + value.ScreenId + '" title="Delete" />'
                       + '</td>'

                       + '<td style="padding-left:5px; padding-top:10px; text-align:center; height:50px; width:6.06%' + backgroundColorArr[4] + '">'
                       + '<input type="checkbox" class="chkInside" ' + disableEnableArr[4] + ' name="Print-' + value.ScreenId + '" id="chkPrint' + value.ScreenId + '" title="Print" />'
                       + '</td>'

                       + '<td style="padding-left:5px; padding-top:10px; text-align:center; height:50px; width:6.08%' + backgroundColorArr[5] + '">'
                       + '<input type="checkbox" class="chkInside" ' + disableEnableArr[5] + ' name="Export-' + value.ScreenId + '" id="chkExport' + value.ScreenId + '" title="Export" />'
                       + '</td>'

                       + '<td style="padding-left:5px; padding-top:10px; text-align:center; height:50px; width:7.09%' + backgroundColorArr[6] + '">'
                       + '<input type="checkbox" class="chkInside" ' + disableEnableArr[6] + ' name="Approve-' + value.ScreenId + '" id="chkApprove' + value.ScreenId + '" title="Approve" />'
                       + '</td>'

                       + '<td style="padding-left:5px; padding-top:10px; text-align:center; height:50px; width:6.08%' + backgroundColorArr[7] + '">'
                       + '<input type="checkbox" class="chkInside" ' + disableEnableArr[7] + ' name="Reject-' + value.ScreenId + '" id="chkReject' + value.ScreenId + '" title="Reject" />'
                       + '</td>'

                       + '<td style="padding-left:5px; padding-top:10px; text-align:center; height:50px; width:6.08%' + backgroundColorArr[8] + '">'
                       + '<input type="checkbox" class="chkInside" ' + disableEnableArr[8] + ' name="Verify-' + value.ScreenId + '" id="chkVerify' + value.ScreenId + '" title="Verify" />'
                       + '</td>'

                       + '<td style="padding-left:5px; padding-top:10px; text-align:center; height:50px; width:7.09%' + backgroundColorArr[9] + '">'
                       + '<input type="checkbox" class="chkInside" ' + disableEnableArr[9] + ' name="Clarify-' + value.ScreenId + '" id="chkClarify' + value.ScreenId + '" title="Clarify" />'
                       + '</td>'

                       + '<td style="padding-left:5px; padding-top:10px; text-align:center; height:50px; width:6.06%' + backgroundColorArr[10] + '">'
                       + '<input type="checkbox" class="chkInside" ' + disableEnableArr[10] + ' name="Renew-' + value.ScreenId + '" id="chkRenew' + value.ScreenId + '" title="Renew" />'
                       + '</td>'

                       + '<td style="padding-left:5px; padding-top:10px; text-align:center; height:50px; width:11.14%' + backgroundColorArr[11] + '">'
                       + '<input type="checkbox" class="chkInside" ' + disableEnableArr[11] + ' name="Acknowledge-' + value.ScreenId + '" id="chkAcknowledge' + value.ScreenId + '" title="Acknowledge" />'
                       + '</td>'

                       + '<td style="padding-left:5px; padding-top:10px; text-align:center; height:50px; width:9.1%' + backgroundColorArr[12] + '">'
                       + '<input type="checkbox" class="chkInside" ' + disableEnableArr[12] + ' name="Recommend-' + value.ScreenId + '" id="chkRecommend' + value.ScreenId + '" title="Recommend" />'
                       + '</td>';
        });
        $('#tblDataTable > tbody').append(markup);
        $("input[id$='All']").attr('disabled', false);
        DisableCheckAllColumn(fetchResult);
        UpdateValues(fetchResult);

        $(':checkbox.checkAllRow').on('click', function () {
            var id = $(this).attr('id');
            var str = 'chkRowCheckAll';
            var screenId = id.substring(str.length);
            $('[name$=-' + screenId + ']:not(:disabled)').prop("checked", $(this).prop("checked")).trigger("change");

            $.each($('[name$=-' + screenId + ']:not(:disabled)'), function (index, value) {
                var id1 = value.id.replace(screenId, '');
                if (id1 != 'chkRowCheckAll') {
                    var checkAllColumnId = id1 + 'All';
                    var allChecked = true;
                    $.each($('[id^=' + id1 + ']:not(:disabled)'), function (index, value) {
                        if (value.id != checkAllColumnId && !value.checked) allChecked = false;
                    });
                    if (allChecked) $('#' + checkAllColumnId).prop("checked", true).trigger("change");
                    else $('#' + checkAllColumnId + '').prop("checked", false).trigger("change");
                }
            });
            ModifyCheckAll();
            CopyVauesToFetchResult();
        });

        $(':checkbox.chkInside').on('click', function () {
            var id = $(this).attr('id');
            var name = $(this).attr('name');
            var action = name.substr(0, name.indexOf('-'));
            var screenId = name.substring(name.indexOf('-') + 1);
            var checkAllRowId = 'chkRowCheckAll' + screenId;
            var allChecked = true;
            $.each($('[name$=-' + screenId + ']'), function (index, value) {
                if (value.id != checkAllRowId && !value.disabled && !value.checked) allChecked = false;
            });
            if (allChecked) $('#' + checkAllRowId + '').prop("checked", true).trigger("change");
            else $('#' + checkAllRowId + '').prop("checked", false).trigger("change");

            var checkAllColumnId = 'chk' + action + 'All';
            allChecked = true;
            $.each($('[id^=chk' + action + ']'), function (index, value) {
                if (value.id != checkAllColumnId && !value.disabled && !value.checked) allChecked = false;
            });
            if (allChecked) $('#' + checkAllColumnId + '').prop("checked", true).trigger("change");
            else $('#' + checkAllColumnId + '').prop("checked", false).trigger("change");
            
            ModifyCheckAll();
            CopyVauesToFetchResult();
        });
    }

    function UpdateValues(fetchResult) {
        $.each(fetchResult, function (index, value) {
            var screenId = value.ScreenId;
            var checkUncheckArr = [];
            var permissionArr = value.Permissions.split('');
            $.each(permissionArr, function (index1, value1) {
                var checkdUnchecked = value1 == "0" ? false : true;
                switch (index1) {
                    case 0: $('#chkAdd' + screenId).prop('checked', checkdUnchecked).trigger("change"); break;
                    case 1: $('#chkEdit' + screenId).prop('checked', checkdUnchecked).trigger("change"); break;
                    case 2: $('#chkView' + screenId).prop('checked', checkdUnchecked).trigger("change"); break;
                    case 3: $('#chkDelete' + screenId).prop('checked', checkdUnchecked).trigger("change"); break;
                    case 4: $('#chkPrint' + screenId).prop('checked', checkdUnchecked).trigger("change"); break;
                    case 5: $('#chkExport' + screenId).prop('checked', checkdUnchecked).trigger("change"); break;
                    case 6: $('#chkApprove' + screenId).prop('checked', checkdUnchecked).trigger("change"); break;
                    case 7: $('#chkReject' + screenId).prop('checked', checkdUnchecked).trigger("change"); break;
                    case 8: $('#chkVerify' + screenId).prop('checked', checkdUnchecked).trigger("change"); break;
                    case 9: $('#chkClarify' + screenId).prop('checked', checkdUnchecked).trigger("change"); break;
                    case 10: $('#chkRenew' + screenId).prop('checked', checkdUnchecked).trigger("change"); break;
                    case 11: $('#chkAcknowledge' + screenId).prop('checked', checkdUnchecked).trigger("change"); break;
                    case 12: $('#chkRecommend' + screenId).prop('checked', checkdUnchecked).trigger("change"); break;
                }
            });
        });

        ModifyCheckAllHeader();
        ModifyCheckAllRows(fetchResult);
        ModifyCheckAll();
        if (fetchResult == null || fetchResult.length == 0) {
            $('#chkCheckAll').prop('checked', false).trigger("change");
            $('#chkCheckAll').attr('disabled', true).trigger("change");
        }
    }

    function ModifyCheckAllHeader() {
        var actions = ['chkAdd', 'chkEdit', 'chkView', 'chkDelete', 'chkPrint', 'chkExport', 'chkApprove', 'chkReject', 'chkVerify', 'chkClarify', 'chkRenew', 'chkAcknowledge', 'chkRecommend'];
        $.each(actions, function (index1, value1) {
            var action = value1;
            var checkAllChecked = true;
            var checkAllId = action + "All";
            var allDisabled = true;
            $.each($('[id^=' + action + ']'), function (index, value) {
                if (value.id != checkAllId && !value.disabled) allDisabled = false;
                if (value.id != checkAllId && !value.disabled && !value.checked)
                    checkAllChecked = false;
            });
            if (checkAllChecked && !allDisabled) $('#' + checkAllId).prop('checked', true).trigger("change");
            else $('#' + checkAllId).prop('checked', false).trigger("change");
        });
    }

    function ModifyCheckAllRows(fetchResult)
    {
        var screenIds = [];
        $.each(fetchResult, function (index, value) {
            screenIds.push(value.ScreenId);
        });
        $.each(screenIds, function (index1, value1) {
            var screenId = value1;
            var checkAllChecked = true;
            var checkAllId = "chkRowCheckAll" + screenId;
            var allDisabled = true;
            $.each($('[name$=-' + screenId + ']'), function (index3, value3) {
                if (value3.id != checkAllId && !value3.disabled) allDisabled = false;
                if (value3.id != checkAllId && !value3.disabled && !value3.checked)
                    checkAllChecked = false;
            });
            if (checkAllChecked && !allDisabled) $('#' + checkAllId).prop('checked', true).trigger("change");
        });
    }

        function ModifyCheckAll() {
        var allChecked = true;
        $.each($('[id$=All]'), function (index, value) {
            if (value.id != 'chkCheckAll' && !value.disabled && !value.checked) allChecked = false;
        });
        $.each($('[id^=chkRowCheckAll]'), function (index, value) {
            if (!value.checked) allChecked = false;
        });

        if (allChecked) $('#chkCheckAll').prop("checked", true).trigger("change");
        else $('#chkCheckAll').prop("checked", false).trigger("change");
    }
    $(':checkbox.selectAll').on('click', function () {
        $(':checkbox[class=checkAllColum]:not(:disabled)').prop("checked", $(this).prop("checked")).trigger("change");
        $(':checkbox[class=checkAllRow]:not(:disabled)').prop("checked", $(this).prop("checked")).trigger("change");
        $(':checkbox[class=chkInside]:not(:disabled)').prop("checked", $(this).prop("checked")).trigger("change");
        CopyVauesToFetchResult();
    });

    $(':checkbox.checkAllColum').on('click', function () {
        var id = $(this).attr('id');
        var action = id.substr(0, id.indexOf('All'));
        $('[id^=' + action + ']:not(:disabled)').prop("checked", $(this).prop("checked")).trigger("change");


        $.each($('[id^=' + action + ']:not(:disabled)'), function (index, value) {
            var id1 = value.id.substring(action.length);
            if (id1 != 'All') {
                var checkAllColumnId = "chkRowCheckAll" +id1;
                var allChecked = true;
                $.each($('[name$=-' + id1 + ']:not(:disabled)'), function (index, value) {
                    if (value.id != checkAllColumnId && !value.checked) allChecked = false;
            });
                if (allChecked) $('#' +checkAllColumnId).prop("checked", true).trigger("change");
                else $('#' +checkAllColumnId + '').prop("checked", false).trigger("change");
        }
    });

        ModifyCheckAll();
        CopyVauesToFetchResult();
    });
        function DisableCheckAllColumn(fetchResult) {
        var addDisabled = true;
        var editDisabled = true;
        var viewDisabled = true;
        var deleteDisabled = true;
        var printDisabled = true;
        var exportDisabled = true;
        var approveDisabled = true;
        var rejectDisabled = true;
        var verifyDisabled = true;
        var clarifyDisabled = true;
        var renewDisabled = true;
        var acknowledgeDisabled = true;
        var recommendDisabled = true;

        $.each(fetchResult, function (index, value) {
            if (value.ScreenPermissions[0]== "1") addDisabled = false;
            if (value.ScreenPermissions[1]== "1") editDisabled = false;
            if (value.ScreenPermissions[2]== "1") viewDisabled = false;
            if (value.ScreenPermissions[3]== "1") deleteDisabled = false;
            if (value.ScreenPermissions[4]== "1") printDisabled = false;
            if (value.ScreenPermissions[5]== "1") exportDisabled = false;
            if (value.ScreenPermissions[6]== "1") approveDisabled = false;
            if (value.ScreenPermissions[7]== "1") rejectDisabled = false;
            if (value.ScreenPermissions[8]== "1") verifyDisabled = false;
            if (value.ScreenPermissions[9]== "1") clarifyDisabled = false;
            if (value.ScreenPermissions[10]== "1") renewDisabled = false;
            if (value.ScreenPermissions[11]== "1") acknowledgeDisabled = false;
            if (value.ScreenPermissions[12]== "1") recommendDisabled = false;
        });

        if (addDisabled) $('#chkAddAll').attr('disabled', true);
        if (editDisabled) $('#chkEditAll').attr('disabled', true);
        if (viewDisabled) $('#chkViewAll').attr('disabled', true);
        if (deleteDisabled) $('#chkDeleteAll').attr('disabled', true);
        if (printDisabled) $('#chkPrintAll').attr('disabled', true);
        if (exportDisabled) $('#chkExportAll').attr('disabled', true);
        if (approveDisabled) $('#chkApproveAll').attr('disabled', true);
        if (rejectDisabled) $('#chkRejectAll').attr('disabled', true);
        if (verifyDisabled) $('#chkVerifyAll').attr('disabled', true);
        if (clarifyDisabled) $('#chkClarifyAll').attr('disabled', true);
        if (renewDisabled) $('#chkRenewAll').attr('disabled', true);
        if (acknowledgeDisabled) $('#chkAcknowledgeAll').attr('disabled', true);
        if (recommendDisabled) $('#chkRecommendAll').attr('disabled', true);
    }

    $('#txtSearch').on('input propertychange paste', function (event) {
        var key = $('#txtSearch').val();
        var tempFetchResult =[];
        tempFetchResult = $.grep(fetchResult, function (value, index) {
            return value.ScreenDescription.toLowerCase().includes(key.toLowerCase());
    });
        $('#tblDataTable > tbody').empty();
        DisplayRows(tempFetchResult)
    });

    $('#selUserRole').change(function () {
        $("div.errormsgcenter").text('');
        $('#errorMsg').css('visibility', 'hidden');

        $('#tblDataTable > tbody').empty();
        fetchResult = [];
        $("input[id$='All']").prop("checked", false);
        $("input[id$='All']").attr('disabled', true);

        $('#txtSearch').val('');
        $('#txtSearch').attr('disabled', true);
        $('#selModule').children('option:not(:first)').remove();

        var selectedValue = $('#selUserRole').val();
        if(selectedValue == "null") {
            $('#txtUserType').val('');
            $('#selModule').attr('disabled', true);
            $('#btnAddFetch').attr('disabled', true);
            return false;
        }
        else {
            var obj = $.grep(UserRoleType, function (value, index) {
                return value.LovId == selectedValue;
            });
            $('#txtUserType').val(obj[0].UserType);
            if ($('#selModule').val() != "null") {
                $('#btnAddFetch').attr('disabled', false);
            }

            $('#myPleaseWait').modal('show');
            $.get("/api/roleScreenPermission/GetModules/" + obj[0].UserTypeId)
                  .done(function (result) {
                      var getResult = JSON.parse(result);
                      $.each(getResult, function (index, value) {
                          $('#selModule').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
                      });
                      $('#selModule').attr('disabled', false);
                      $('#myPleaseWait').modal('hide');
                  })
                 .fail(function (response) {
                     $('#myPleaseWait').modal('hide');
                     $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
                     $('#errorMsg').css('visibility', 'visible');
                 });
        }
    });

$('#selModule').change(function () {
    $('#tblDataTable > tbody').empty();
    $('#txtSearch').val('').attr('disabled', true);
    fetchResult = [];
    $("input[id$='All']").prop("checked", false);
    $("input[id$='All']").attr('disabled', true);

    var selectedValue = $('#selModule').val();
    if(selectedValue == "null") {
        $('#btnAddFetch').attr('disabled', true);
            return false;
    }
    else {
        $('#btnAddFetch').attr('disabled', false);
    }
});

$("#btnSave, #btnAddNew").click(function () {
    
    var btnId = $(this).attr('id');
    $('#' + btnId).attr('disabled', true);

        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');

        var rowCount = $('#tblRolePermission tr').length;

        if (rowCount == 2) {
            DisplayErrorMessage(Messages.NO_RECORDS_TO_SAVE);
            $('#' + btnId).attr('disabled', false);
            return false;
    }
        var RoleScreenPermissions = {
    };
        var Permissions =[];
        $.each(fetchResult, function (index, value) {
            var obj = {
                UMUserRoleId: value.UMUserRoleId,
                ScreenId: value.ScreenId,
                Permissions: value.Permissions
            };
            Permissions.push(obj);
        });

        RoleScreenPermissions.roleScreenPermissions = Permissions;

        $('#myPleaseWait').modal('show');

        var jqxhr = $.post("/api/roleScreenPermission/Save", RoleScreenPermissions, function (response) {
            var result = JSON.parse(response);
            $(".content").scrollTop(0);
            showMessage('Permissions', CURD_MESSAGE_STATUS.SS);
            $("#top-notifications").modal('show');
            setTimeout(function () {
                $("#top-notifications").modal('hide');
            }, 5000);

            $('#' + btnId).attr('disabled', false);
            if (btnId == 'btnAddNew') {
                EmptyFileds();
            }
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

            $('#' + btnId).attr('disabled', false);
            $('#myPleaseWait').modal('hide');
        });
    });

    function CopyVauesToFetchResult()
    {
        var Permissions = [];
        $("tr.trItem").each(function () {
            var str = 'chkRowCheckAll';
            var id = $(this).find("[id^=chkRowCheckAll]").attr('id');
            var screenId = id.substring(str.length);
            var permissions = '';
            permissions += $(this).find("[id=chkAdd" + screenId + "]").prop('checked') ? "1" : "0";
            permissions += $(this).find("[id=chkEdit" + screenId + "]").prop('checked') ? "1" : "0";
            permissions += $(this).find("[id=chkView" + screenId + "]").prop('checked') ? "1" : "0";
            permissions += $(this).find("[id=chkDelete" + screenId + "]").prop('checked') ? "1" : "0";
            permissions += $(this).find("[id=chkPrint" + screenId + "]").prop('checked') ? "1" : "0";
            permissions += $(this).find("[id=chkExport" + screenId + "]").prop('checked') ? "1" : "0";
            permissions += $(this).find("[id=chkApprove" + screenId + "]").prop('checked') ? "1" : "0";
            permissions += $(this).find("[id=chkReject" + screenId + "]").prop('checked') ? "1" : "0";
            permissions += $(this).find("[id=chkVerify" + screenId + "]").prop('checked') ? "1" : "0";
            permissions += $(this).find("[id=chkClarify" + screenId + "]").prop('checked') ? "1" : "0";
            permissions += $(this).find("[id=chkRenew" + screenId + "]").prop('checked') ? "1" : "0";
            permissions += $(this).find("[id=chkAcknowledge" + screenId + "]").prop('checked') ? "1" : "0";
            permissions += $(this).find("[id=chkRecommend" + screenId + "]").prop('checked') ? "1" : "0";
            var roleId = $('#selUserRole').val();
            
            var obj = $.grep(fetchResult, function (value, index) {
                return value.ScreenId == screenId;
            });
            obj[0].Permissions = permissions;
        });
    }

    function DisplayErrorMessage(msg) {
        $("div.errormsgcenter").text(msg);
        $('#errorMsg').css('visibility', 'visible');

        $('#btnSave').attr('disabled', false);
    }

    //$('#btnAddNew').click(function () {
    //    window.location.reload();
    //});

    //$("#btnCancel").click(function () {
    //    window.location.href = "/um/rolescreenpermission";
    //});
    function EmptyFileds() {
        $(".content").scrollTop(0);
        $('#tblDataTable > tbody').empty();
        $('#txtSearch').val('').attr('disabled', true);
        fetchResult = [];
        $("input[id$='All']").prop("checked", false);
        $("input[id$='All']").attr('disabled', true);

        $('#selUserRole').val('null');
        $('#selModule').val('null').attr('disabled', true);
        $('#txtUserType').val('');
        $('#btnAddFetch').attr('disabled', true);

        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
    }

    $("#btnCancel").click(function () {
        var message = Messages.Reset_Alert_CONFIRMATION;
        bootbox.confirm(message, function (result) {
            if (result) {
                EmptyFileds();
            }
            else {
                $('#myPleaseWait').modal('hide');
            }
        });
    });
});