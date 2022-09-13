var ConfigResult = null;

$(document).ready(function () {    
    $('#btnNotificationEdit').hide();
    $('#btnCancel').hide();
    $('#Notificationusertype').attr('disabled', true);
    $('#Notificationrole').attr('disabled', true);
    $('#Notificationcompany').attr('disabled', true);   
    $('#btnNotificationToRemove').hide();
    $('#btnNotificationCcRemove').hide();
    $('#chk_NotificationdeliveryTodet').attr('disabled', true);
    $('#chk_NotificationdeliveryCcdet').attr('disabled', true);
    $('#Notificationdisable').attr('disabled', true);
    $('#NotificationCreator').attr('disabled', true);
    $('#Notificationrecipients').attr('disabled', true);
    $('#myPleaseWait').modal('show');
    var primaryId = $('#primaryID').val();
    var ActionType = $('#ActionType').val();
    formInputValidation("NotificationDeliveryConfigurationform");
    $("#btnNotificationAddTo").prop("disabled", true);
    $("#btnNotificationAddCc").prop("disabled", true);
    
    //******************************** Load DropDown ***************************************

    $.get("/api/NotificationDeliveryConfiguration/Load")
   .done(function (result) {
       var loadResult = JSON.parse(result);
       $("#jQGridCollapse1").click();
       $.each(loadResult.NotificationServiceTypeData, function (index, value) {
           $('#Notficationservice').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
       });
       $.each(loadResult.NotificationUserTypeData, function (index, value) {
           $('#Notificationusertype').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
       });
       //$.each(loadResult.NotificationRoleTypeData, function (index, value) {
       //    $('#Notificationrole').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
       //});          
          
   })
   .fail(function (response) {
       $('#myPleaseWait').modal('hide');
       $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
       $('#errorMsg').css('visibility', 'visible');
   });

    //***************************************** Getby Role ***************************************
    
    $('#Notificationusertype').on('change', function () {
        var Ugettype =$("#Notificationrole option:selected").val();
        var Ugetrole = $("#Notificationusertype option:selected").val();
        var Ugetcompany = $("#Notificationcompany option:selected").val();
        if (Ugettype == "null" || Ugetrole == "null" || Ugetcompany=="null") {
            $("#btnNotificationAddTo").prop("disabled", true);
            $("#btnNotificationAddCc").prop("disabled", true);

        }
        else {
            $("#btnNotificationAddTo").prop("disabled", false);
            $("#btnNotificationAddCc").prop("disabled", false);
        }
        var Utypeval = $("#Notificationusertype").val();
        if (Utypeval != "null") {
            $.get("/api/NotificationDeliveryConfiguration/getRole/" + Utypeval)
           .done(function (result) {
               var loadResult = JSON.parse(result);
               $('#Notificationrole').empty();
               $('#Notificationrole').append('<option value="null">Select</option>');
               $('#Notificationcompany').empty();
               $('#Notificationcompany').append('<option value="null">Select</option>');              
               $.each(loadResult.NotificationRoleTypeData, function (index, value) {
                   $('#Notificationrole').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
               });
           })
            .fail(function (response) {
                $('#myPleaseWait').modal('hide');
                $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
                $('#errorMsg').css('visibility', 'visible');
            });
        }
        $('#Notificationrole').empty();
        $('#Notificationrole').append('<option value="null">Select</option>');       
        $('#Notificationcompany').empty();
        $('#Notificationcompany').append('<option value="null">Select</option>');
        $("#btnNotificationAddTo").prop("disabled", true);
        $("#btnNotificationAddCc").prop("disabled", true);
    });


    $('#Notificationrole').on('change', function () {
        var Rgettype = $("#Notificationrole option:selected").val();
        var Rgetrole = $("#Notificationusertype option:selected").val();
        var Rgetcompany = $("#Notificationcompany option:selected").val();
        if (Rgettype == "null" || Rgetrole == "null" || Rgetcompany == "null") {
            $("#btnNotificationAddTo").prop("disabled", true);
            $("#btnNotificationAddCc").prop("disabled", true);

        }
        else {
            $("#btnNotificationAddTo").prop("disabled", false);
            $("#btnNotificationAddCc").prop("disabled", false);
        }
        var Rtypeval = $("#Notificationrole").val();
        if (Rtypeval != "null") {
            $.get("/api/NotificationDeliveryConfiguration/GetCompany/" + Rtypeval)
           .done(function (result) {
               var loadResult = JSON.parse(result);
               $('#Notificationcompany').empty();
               $('#Notificationcompany').append('<option value="null">Select</option>');              
               $.each(loadResult.NotificationCompanyTypeData, function (index, value) {
                   $('#Notificationcompany').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
               });
           })
            .fail(function (response) {
                $('#myPleaseWait').modal('hide');
                $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
                $('#errorMsg').css('visibility', 'visible');
            });
        }
        $('#Notificationcompany').empty();
        $('#Notificationcompany').append('<option value="null">Select</option>'); 
        $("#btnNotificationAddTo").prop("disabled", true);
        $("#btnNotificationAddCc").prop("disabled", true);
    });       


    $('#Notificationcompany').on('change', function () {
        var gettype = $("#Notificationrole option:selected").val();
        var getrole = $("#Notificationusertype option:selected").val();
        var getcompany = $("#Notificationcompany option:selected").val();
        if (gettype == "null" || getrole == "null" || getcompany == "null") {
            $("#btnNotificationAddTo").prop("disabled", true);
            $("#btnNotificationAddCc").prop("disabled", true);

        }
        else {
            $("#btnNotificationAddTo").prop("disabled", false);
            $("#btnNotificationAddCc").prop("disabled", false);
        }

    });

    //****************************************** Save *********************************************

    $("#btnNotificationSave, #btnNotificationEdit").unbind('click');
    $("#btnNotificationSave, #btnNotificationEdit").click(function () {
        $('#btnNotificationSave').attr('disabled', true);
        $('#btnNotificationEdit').attr('disabled', true);
        $('#myPleaseWait').modal('show');
        
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
        var _DeleteWO = null;
        var resultWO = [];        
        var _TOindex;
        var _CCindex;
        var primaryId = $('#primaryID').val();

        var Timestamp = $("#Timestamp").val();
        if (primaryId != null) {
            NotificationTemplateId = primaryId;
            Timestamp = Timestamp;
        }

        
        $('#NotificationDeliveryToTbl tr').each(function () {
            _TOindex = $(this).index();
        });      
        $('#NotificationDeliveryCcTbl tr').each(function () {
            _CCindex = $(this).index();
        });

        for (var a = 0; a <= _TOindex; a++) {
            var _DeleteTOWO = {
                NotificationTemplateId: NotificationTemplateId,                
                IsDeleted: $("#Isdeleted_" + a).is(":checked"),
                NotificationDeliveryId: $("#hdnDeliveryToId_" + a).val(),
            }
            resultWO.push(_DeleteTOWO);
        }
        for (var b = 0; b <= _CCindex; b++) {
          var _DeletCceWO = {
                NotificationTemplateId: NotificationTemplateId,
                IsDeleted: $("#IsdeletedCc_" + b).is(":checked"),
                NotificationDeliveryId: $("#hdnDeliveryCcId_" + b).val(),
            }
          resultWO.push(_DeletCceWO);
        }
       
        var ccListLength = Enumerable.From(ConfigResult).Where(x=>x.RecepientType == 2).ToArray().length;
        
        $.each(ConfigResult, function (index, data) {
            if (data.RecepientType == 2) {
                for (i = 0; i < ccListLength; i++) {
                    if (data.UserRoleId == $('#hdnRoleCcDetId_' + i).val()) {
                        data.CcEmailId = $("#NotificationCcEmail_" + i).val();
                    }
                }
            }
            //data.CcEmailId = $("#NotificationCcEmail_" + index).val();
            data.NotificationTemplateId = NotificationTemplateId;            
        });

        var NotificationMstobj = {
            NotificationTemplateId: NotificationTemplateId,            
            ServiceId: $('#Notficationservice').val(),
            NotificationType: $('#Notificationtype').val(),
            NotificationName: $('#Notificationname').val(),
            Subject: $("#Notificationsubject").val(),
            DisableNotification: chkDisableNotifyValue(),
            Timestamp: Timestamp,
            NotificationToCcListData: ConfigResult,
            NotificationDeleteListData: resultWO
        }
        var isFormValid = formInputValidation("NotificationDeliveryConfigurationform", 'save');
        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            $('#btnNotificationSave').attr('disabled', false);
            $('#btnNotificationEdit').attr('disabled', false);
            return false;
        }        
            SaveNotificationMST(NotificationMstobj);       

        function SaveNotificationMST(NotificationMstobj) {
            var jqxhr = $.post("/api/NotificationDeliveryConfiguration/Save", NotificationMstobj, function (response) {
                var getResult = JSON.parse(response);
                $("#primaryID").val(getResult.NotificationTemplateId);
                $("#Timestamp").val(getResult.Timestamp);
                ConfigResult = null;
                ConfigResult = getResult.NotificationToCcListData;
                BindGridData(getResult);
                $(".content").scrollTop(0);
                showMessage('Notification Delivery Configuration', CURD_MESSAGE_STATUS.SS);
                $("#grid").trigger('reloadGrid');
                $('#btnNotificationSave').attr('disabled', false);
                $('#btnNotificationEdit').attr('disabled', false);
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
                $("div.errormsgcenter").text(errorMessage).css('visibility', 'visible');
                $('#errorMsg').css('visibility', 'visible');
                $('#btnNotificationSave').attr('disabled', false);
                $('#btnNotificationEdit').attr('disabled', false);
                $('#myPleaseWait').modal('hide');
            });
        }
    });

    //************************* Reset **********************************

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


    //************************** To Delete *************************************

    $("#btnNotificationToRemove").click(function () {
        $('#btnNotificationToRemove').attr('disabled', false);

        var _Toindex;
        $('#NotificationDeliveryToTbl tr').each(function () {
            _Toindex = $(this).index();
        });

        var selectedToIds = '';
        for (var i = 0; i <= _Toindex; i++) {
                var IsTodelete = $("#Isdeleted_" + i).is(":checked");
                if (IsTodelete) {
                    var getToId = $("#hdnDeliveryToId_" + i).val();
                    selectedToIds += getToId + ",";
                }
            }
        var Toresult = selectedToIds.substring(0, selectedToIds.lastIndexOf(','));
        if (IsTodelete == false && Toresult == "")
        {
            bootbox.alert("Please select records to delete");
            return false;
        }
        var message = Messages.SEARCH_GRID_DELETE_CONFIRMATION;
        bootbox.confirm(message, function (delresult) {
            if (delresult) {
                if (IsTodelete == true && Toresult == "")
                {
                    var delToid = 0;
                    confirmDeleteNotification(delToid);
                    $("#chk_NotificationdeliveryTodet").prop("checked", false);
                }
                if (Toresult != null && Toresult != 0 && Toresult != "") {
                    confirmDeleteNotification(Toresult);
                    $("#chk_NotificationdeliveryTodet").prop("checked", false);
                }
                $('#btnNotificationToRemove').attr('disabled', false);
            }
        });
        $('#btnNotificationToRemove').attr('disabled', false);
    });

    //************************** Cc Delete *************************************

    $("#btnNotificationCcRemove").click(function () {
        $('#btnNotificationCcRemove').attr('disabled', false);

        var _Ccindex;
        $('#NotificationDeliveryCcTbl tr').each(function () {
            _Ccindex = $(this).index();
        });

        var selectedCcIds = '';
        for (var j = 0; j <= _Ccindex; j++) {
            var IsCcdelete = $("#IsdeletedCc_" + j).is(":checked");
            if (IsCcdelete) {
                var getCcId = $("#hdnDeliveryCcId_" + j).val();
                selectedCcIds += getCcId + ",";
            }
        }
        var Ccresult = selectedCcIds.substring(0, selectedCcIds.lastIndexOf(','));

        if (IsCcdelete == false && Ccresult == "") {
            bootbox.alert("Please select records to delete");
            return false;
        }
        var message = Messages.SEARCH_GRID_DELETE_CONFIRMATION;
        bootbox.confirm(message, function (delresult) {
            if (delresult) {
                if (IsCcdelete == true && Ccresult == "") {
                    var delCcid = 0;
                    confirmDeleteNotification(delCcid);
                    $("#chk_NotificationdeliveryCcdet").prop("checked", false);
                }
                if (Ccresult != null && Ccresult != 0 && Ccresult != "") {
                    confirmDeleteNotification(Ccresult);
                    $("#chk_NotificationdeliveryCcdet").prop("checked", false);
                }
                $('#btnNotificationCcRemove').attr('disabled', false);
            }
        });
        $('#btnNotificationCcRemove').attr('disabled', false);
    });


    //************************************ Grid Delete To

    $("#chk_NotificationdeliveryTodet").change(function () {
        var Isdeletebool = this.checked;

        if (this.checked) {
            $('#NotificationDeliveryToTbl tr').map(function (i) {
                if ($("#Isdeleted_" + i).prop("disabled")) {
                    $("#Isdeleted_" + i).prop("checked", false);
                }
                else {
                    $("#Isdeleted_" + i).prop("checked", true);
                }
            });
        } else {
            $('#NotificationDeliveryToTbl tr').map(function (i) {
                $("#Isdeleted_" + i).prop("checked", false);
            });
        }
    });

    //************************************ Grid Delete Cc

    $("#chk_NotificationdeliveryCcdet").change(function () {
        var Isdeletebool = this.checked;

        if (this.checked) {
            $('#NotificationDeliveryCcTbl tr').map(function (i) {
                if ($("#IsdeletedCc_" + i).prop("disabled")) {
                    $("#IsdeletedCc_" + i).prop("checked", false);
                }
                else {
                    $("#IsdeletedCc_" + i).prop("checked", true);
                }
            });
        } else {
            $('#NotificationDeliveryCcTbl tr').map(function (i) {
                $("#IsdeletedCc_" + i).prop("checked", false);
            });
        }
    });
   

});

//************************************* Delete ***********************************

function confirmDeleteNotification(getId) {
    $.get("/api/NotificationDeliveryConfiguration/Delete/" + getId)
        .done(function (delresult) {

            var primaryId = $('#primaryID').val();
            if (primaryId != null && primaryId != "0" && primaryId != "" && primaryId != 0) {
                GetbyId(primaryId);
            }
            else {
                $('#myPleaseWait').modal('hide');

            }
            $(".content").scrollTop(0);
            showMessage('Notification Delivery Congiguration', CURD_MESSAGE_STATUS.DS);
            $('#myPleaseWait').modal('hide');
        })
         .fail(function () {
             showMessage('Notification Delivery Congiguration', CURD_MESSAGE_STATUS.DF);
             $('#myPleaseWait').modal('hide');
         });
}

//***************************** Bind dropdown Values ********************************

function GetNotifyValues(type) {
    var _NotificationWO = null;    

    var rowcount1 = $("#NotificationDeliveryToTbl tr:last").index();
    if (rowcount1 == -1) {
        rowcount1 = 0;
    }
    else {
        rowcount1 = rowcount1 + 1;
    }

    var rowcount2 = $("#NotificationDeliveryCcTbl tr:last").index();
    if (rowcount2 == -1) {
        rowcount2 = 0;
    }
    else {
        rowcount2 = rowcount2 + 1;
    }
    var ToCompanyTxt = $('#Notificationcompany option:selected').text();
   
    var ToRoleTxt = $('#Notificationrole option:selected').text();
    var ToUserTxt = $('#Notificationusertype option:selected').text();
    var userroleId = parseInt($("#Notificationrole option:selected").val());
    var usertypeId = parseInt($("#Notificationusertype option:selected").val());
    var usercompanyId = parseInt($("#Notificationcompany option:selected").val()); 
    var CompanyVal = $('#Notificationcompany option:selected').val();  
    

    if (type == 1) {
        _NotificationWO = {
            UserRoleId: userroleId,
            UserRegistrationId: usertypeId,
            CompanyId: usercompanyId,         
            ToRole: ToRoleTxt,
            ToUser: ToUserTxt,
            ToCompany: ToCompanyTxt,        
            IsDeleted: $('#Isdeleted_' + rowcount1).is(":checked"),
            NotificationDeliveryId: $("#hdnDeliveryToId_" + rowcount1).val(),
            RecepientType: type
        }
    }
    else if (type == 2) {
        _NotificationWO = {
            UserRoleId: userroleId,
            UserRegistrationId: usertypeId,
            CompanyId: usercompanyId,         
            CcRole: ToRoleTxt,
            CcUser: ToUserTxt,
            CcCompany: ToCompanyTxt,          
            NotificationDeliveryId: $("#hdnDeliveryCcId_" + rowcount2).val(),
            IsDeleted: $('#IsdeletedCc_' + rowcount2).is(":checked"),
            CcEmailId: $("#NotificationCcEmail_" + rowcount2).val(),
            RecepientType: type
        }
    }    
    ConfigResult.push(_NotificationWO);

    var Getresult = Enumerable.From(ConfigResult).Select(res=>res.UserRoleId).ToArray();
    var Getresultval = Enumerable.From(ConfigResult).Select(res=>res.UserRoleId).Distinct().ToArray();
    if (Getresult.length == Getresultval.length) {
        if (type == 1) {
            $('#chk_NotificationdeliveryTodet').attr('disabled', false);
            $('#btnNotificationToRemove').attr('disabled', false);
            AddNewRowToMst();
            $("#NotificationToRole_" + rowcount1).val(ToRoleTxt);
            $("#NotificationToUser_" + rowcount1).val(ToUserTxt);
            $("#NotificationToCompany_" + rowcount1).val(ToCompanyTxt);          
        }
        else if (type == 2) {
            $('#chk_NotificationdeliveryCcdet').attr('disabled', false);
            $('#btnNotificationCcRemove').attr('disabled', false);
            AddNewRowCcMst();
            $("#NotificationCcRole_" + rowcount2).val(ToRoleTxt);
            $("#NotificationCcUser_" + rowcount2).val(ToUserTxt);
            $("#NotificationCcCompany_" + rowcount2).val(ToCompanyTxt);           
        }
    }
    else {
        ConfigResult.pop();
        bootbox.alert("Role already added To/Cc List");
    }

}

   //****************************** AddNewRow To **********************************************

var linkCliked1 = false;
function AddNewRowToMst() {

    var inputpar = {
        inlineHTML: BindNewRowToHTML(),
        IdPlaceholderused: "maxindexval",
        TargetId: "#NotificationDeliveryToTbl",
        TargetElement: ["tr"]

    }
    AddNewRowToDataGrid(inputpar);
    $('#chk_NotificationdeliveryTodet').prop("checked", false);
    if (!linkCliked1) {
        $('#NotificationDeliveryToTbl tr:last td:first input').focus();
    }
    else {
        linkCliked1 = false;
    }
    formInputValidation("NotificationDeliveryConfigurationform");
   
}

function BindNewRowToHTML() {
    return ' <tr> <td width="3%" title="Select"> <div class="checkbox text-center"> <label for="checkboxes-0"> <input type="checkbox" name="NotificationCheckboxes" id="Isdeleted_maxindexval" onchange="IsDeleteCheckAll(NotificationDeliveryToTbl, chk_NotificationdeliveryTodet)"> </label> </div></td><td width="30%" style="text-align: center;"> <div> <input type="hidden" id="hdnRoleToDetId_maxindexval" class="form-control"> <input type="hidden" id="RecepientTypeTo_maxindexval" name="RecepientType" value="null"/> <input type="hidden" id="hdnDeliveryToId_maxindexval" class="form-control"> <input type="hidden" id="hdnRegistrationToId_maxindexval" class="form-control"> <input type="hidden" id="hdnCompanyToId_maxindexval" class="form-control"> <input type="text" id="NotificationToRole_maxindexval" maxlength="25" class="form-control" name="Role" disabled> </div></td><td width="30%" style="text-align: center;"> <div> <input type="text" id="NotificationToUser_maxindexval" maxlength="25" class="form-control" name="User" disabled> </div></td><td width="37%" style="text-align: center;"> <div> <input type="text" id="NotificationToCompany_maxindexval" maxlength="25" class="form-control" name="Company" disabled> </div></td></tr> ';
    }

  //****************************** AddNewRow Cc **********************************************

var linkCliked2 = false;
function AddNewRowCcMst() {

        var inputpar = {
            inlineHTML: BindNewRowCcHTML(),
            IdPlaceholderused: "maxindexval",
            TargetId: "#NotificationDeliveryCcTbl",
            TargetElement: ["tr"]

        }
        AddNewRowToDataGrid(inputpar);
        $('#chk_NotificationdeliveryCcdet').prop("checked", false);
        if (!linkCliked2) {
            $('#NotificationDeliveryCcTbl tr:last td:first input').focus();
        }
        else {
            linkCliked1 = true;
        }
        formInputValidation("NotificationDeliveryConfigurationform");

    }

function BindNewRowCcHTML() {
    return ' <tr> <td width="3%" title="Select"> <div class="checkbox text-center"> <label for="checkboxes-0"> <input type="checkbox" name="NotificationCheckboxes" id="IsdeletedCc_maxindexval" onchange="IsDeleteCheckAllCc(NotificationDeliveryCcTbl, NotificationdeliveryCcdet)"> </label> </div></td><td width="30%" style="text-align: center;"> <div> <input type="hidden" id="hdnRoleCcDetId_maxindexval" class="form-control"> <input type="hidden" id="RecepientTypeCc_maxindexval" name="RecepientType" value="null"/> <input type="hidden" id="hdnDeliveryCcId_maxindexval" class="form-control"> <input type="hidden" id="hdnRegistrationCcId_maxindexval" class="form-control"> <input type="hidden" id="hdnCompanyCcId_maxindexval" class="form-control"> <input type="text" id="NotificationCcRole_maxindexval" maxlength="25" class="form-control" name="Role" disabled> </div></td><td width="20%" style="text-align: center;"> <div> <input type="text" id="NotificationCcUser_maxindexval" maxlength="25" class="form-control" name="User" disabled> </div></td><td width="20%" style="text-align: center;"> <div> <input type="text" id="NotificationCcCompany_maxindexval" maxlength="25" class="form-control" name="Company" disabled> </div></td><td width="27%" style="text-align: center;"> <div> <input type="text" id="NotificationCcEmail_maxindexval" maxlength="50" pattern="^([a-zA-Z0-9_.+-])+@(([a-zA-Z0-9-])+.)+([a-zA-Z0-9]{2,4})+$" class="form-control" name="Email"> </div></td></tr> ';
    }

//************************************** BindData ****************************************

function BindGridData(result) {
    var ActionType = $('#ActionType').val();    
    $('#primaryID').val(result.NotificationTemplateId);
    $('#Notficationservice' + ' option[value="' + result.ServiceId + '"]').prop('selected', true);
    $('#Notificationtype').val(result.NotificationType);
    $('#Notificationname').val(result.NotificationName);
    $('#Notificationsubject').val(result.Subject);

    $("#Notificationdisable").attr('disabled', false);
    $("#NotificationCreator").attr('disabled', false);
    $("#Notificationrecipients").attr('disabled', false);

    
    if (result.DisableNotification == true) {
        $("#Notificationdisable").prop('checked', true);
    }
    else {
        $("#Notificationdisable").prop('checked', false);
    }
   

    $('#Notificationrole').empty();
    $('#Notificationrole').append('<option value="null">Select</option>');
    $('#Notificationcompany').empty();
    $('#Notificationcompany').append('<option value="null">Select</option>');
   
    $('#Notificationusertype option:contains("Select")').prop('selected', true);
    btnpermission();

    $("#NotificationDeliveryToTbl").empty();
    $("#NotificationDeliveryCcTbl").empty();

    if (result != null && result.NotificationToCcListData != null && result.NotificationToCcListData.length > 0) {
        var ToList = Enumerable.From(result.NotificationToCcListData).Where(x=>x.RecepientType == 1).ToArray();
        var CcList = Enumerable.From(result.NotificationToCcListData).Where(x=>x.RecepientType == 2).ToArray();
       
        if (ToList != null && ToList.length > 0) {

            $.each(ToList, function (index, value) {
                $('#chk_NotificationdeliveryTodet').attr('disabled', false);
                $('#btnNotificationToRemove').attr('disabled', false);
                AddNewRowToMst();
                $("#RecepientTypeTo_" + index).val(1);
                $("#hdnRoleToDetId_" + index).val(value.UserRoleId);
                $("#hdnDeliveryToId_" + index).val(value.NotificationDeliveryId);
                $("#hdnRegistrationToId_" + index).val(value.UserRegistrationId);
                $("#hdnCompanyToId_" + index).val(value.CompanyId);             

                $('#NotificationToRole_' + index).val(value.ToRole).attr('title', value.ToRole);
                $("#NotificationToUser_" + index).val(value.ToUser).attr('title', value.ToUser);
                $("#NotificationToCompany_" + index).val(value.ToCompany).attr('title', value.ToCompany);
                linkCliked1 = true;
                if (ActionType == "View") {
                    $('#btnNotificationToRemove').attr('disabled', true);
                    $('#btnNotificationCcRemove').attr('disabled', true);
                    $("#NotificationDeliveryConfigurationform :input:not(:button)").prop("disabled", true);
                    $('#Isdeleted_' + index).prop("disabled", "disabled");
                    $('#IsdeletedCc_' + index).prop("disabled", "disabled");
                    $('#chk_NotificationdeliveryTodet').prop("disabled", "disabled");
                    $('#chk_NotificationdeliveryCcdet').prop("disabled", "disabled");
                }

            });
        }
        else {
            $('#chk_NotificationdeliveryTodet').attr('disabled', true);            
            $('#btnNotificationToRemove').attr('disabled', true);            
            $("#NotificationDeliveryToTbl").empty();            
        }

        if (CcList != null && CcList.length > 0) {


            $.each(CcList, function (index, value) {
                $('#chk_NotificationdeliveryCcdet').attr('disabled', false);
                $('#btnNotificationCcRemove').attr('disabled', false);
                AddNewRowCcMst();
                $("#RecepientTypeCc_" + index).val(2);
                $("#hdnRoleCcDetId_" + index).val(value.UserRoleId);
                $("#hdnDeliveryCcId_" + index).val(value.NotificationDeliveryId);
                $("#hdnRegistrationCcId_" + index).val(value.UserRegistrationId);
                $("#hdnCompanyCcId_" + index).val(value.CompanyId);              

                $('#NotificationCcRole_' + index).val(value.CcRole).attr('title', value.CcRole);
                $("#NotificationCcUser_" + index).val(value.CcUser).attr('title', value.CcUser);
                $("#NotificationCcCompany_" + index).val(value.CcCompany).attr('title', value.CcCompany);
                $("#NotificationCcEmail_" + index).val(value.CcEmailId).attr('title', value.CcEmailId);
                linkCliked2 = true;
                if (ActionType == "View") {
                    $('#btnNotificationToRemove').attr('disabled', true);
                    $('#btnNotificationCcRemove').attr('disabled', true);
                    $("#NotificationDeliveryConfigurationform :input:not(:button)").prop("disabled", true);
                    $('#Isdeleted_' + index).prop("disabled", "disabled");
                    $('#chk_NotificationdeliveryTodet').prop("disabled", "disabled");
                    $('#chk_NotificationdeliveryCcdet').prop("disabled", "disabled");
                }

            });
        }
        else {            
            $('#chk_NotificationdeliveryCcdet').attr('disabled', true);            
            $('#btnNotificationCcRemove').attr('disabled', true);            
            $("#NotificationDeliveryCcTbl").empty();
        }

    }
    else {
        $('#chk_NotificationdeliveryTodet').attr('disabled', true);
        $('#chk_NotificationdeliveryCcdet').attr('disabled', true);
        $('#btnNotificationToRemove').attr('disabled', true);
        $('#btnNotificationCcRemove').attr('disabled', true);
        $("#NotificationDeliveryToTbl").empty();
        $("#NotificationDeliveryCcTbl").empty();
    }

}


function btnpermission() {
    var role = $('#Notificationrole').val();
    var user = $('#Notificationusertype').val();
    var company = $('#Notificationcompany').val();
    if (role == "null" || user == "null" || company == "null") {
        $("#btnNotificationAddTo").prop("disabled", "disabled");
        $("#btnNotificationAddCc").prop("disabled", "disabled");
    }
    else {
        $("#btnNotificationAddTo").prop("disabled", false);
        $("#btnNotificationAddCc").prop("disabled", false);
    }
    
}


function IsDeleteCheckAllCc() {
    var Isdeleted_ = [];
    $('#NotificationDeliveryCcTbl tr').map(function (index, value) {
        var Isdelete = $("#IsdeletedCc_" + index).is(":checked");
        if (Isdelete)
            Isdeleted_.push(Isdelete);
    });

    if ($('#NotificationDeliveryCcTbl tr').length == Isdeleted_.length)
        $("#chk_NotificationdeliveryCcdet").prop("checked", true);
    else
        $("#chk_NotificationdeliveryCcdet").prop("checked", false);

}

function chkDisableNotifyValue() {
    if ($('#Notificationdisable').prop("checked") == true) {
        var val = true;
    }
    else if ($('#Notificationdisable').prop("checked") == false) {
        var val = false;
    }
    return val;
}


function GetbyId(primaryId) {
    $.get("/api/NotificationDeliveryConfiguration/get/" + primaryId)
           .done(function (result) {
               var result = JSON.parse(result);
               ConfigResult = result.NotificationToCcListData;
               BindGridData(result);
           })
            .fail(function (response) {
                $('#myPleaseWait').modal('hide');
                $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
                $('#errorMsg').css('visibility', 'visible');
            });
}

function LinkClicked(id) {
    linkCliked1 = true;
    linkCliked2 = true;
    $(".content").scrollTop(1);
    $('#Notificationusertype').attr('disabled', false);
    $('#Notificationrole').attr('disabled', false);
    $('#Notificationcompany').attr('disabled', false);   

    $('#btnNotificationToRemove').show();
    $('#btnNotificationCcRemove').show();
    $("#NotificationDeliveryConfigurationform :input:not(:button)").parent().removeClass('has-error');
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
        $("#frmUserRole :input:not(:button)").prop("disabled", true);

    } else {
        $('#btnNotificationEdit').show();
        $('#btnCancel').show();
        //$('#btnSaveandAddNew').hide();
        $('#btnNextScreenSave').show();
    }
    $('#spnActionType').text(action);
    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0" && primaryId != "" && primaryId != 0) {
        GetbyId(primaryId);
    }
    else {
        $('#myPleaseWait').modal('hide');

    }
}

function EmptyFields() {
    $(".content").scrollTop(0);
    $('input[type="text"], textarea').val('');
    $('#selStatus').val(1);
    $('#btnNotificationEdit').hide();
    $('#btnNotificationSave').hide();
    $('#btnDelete').hide();  
    $('#spnActionType').text('Add');
    $("#primaryID").val('');
    $("#Notificationusertype").val('null');
    $("#Notificationrole").val('null');
    $("#Notificationcompany").val('null');
    $("#grid").trigger('reloadGrid');
    $("#NotificationDeliveryConfigurationform :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('#txtName').attr('disabled', false);
    btnpermission();
    $('#Notificationusertype').attr('disabled', true);
    $('#Notificationrole').attr('disabled', true);
    $('#Notificationcompany').attr('disabled', true);
    $('#btnNotificationToRemove').hide();
    $('#btnNotificationCcRemove').hide();
    $('#chk_NotificationdeliveryTodet').attr('disabled', true);
    $('#chk_NotificationdeliveryCcdet').attr('disabled', true);
    $('#Notificationdisable').attr('disabled', true);
    $('#NotificationCreator').attr('disabled', true);
    $('#Notificationrecipients').attr('disabled', true);
    $("#NotificationDeliveryToTbl").empty();
    $("#NotificationDeliveryCcTbl").empty();
}