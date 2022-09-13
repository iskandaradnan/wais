var action = "";

//function loadWarrantyProviderTab() {
$('#liWarrantyProvider').click(function () {
    $("#assetRegister :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg1').css('visibility', 'hidden');
    var primaryId1 = $('#hdnARPrimaryID').val();
    if (primaryId1 == 0) {
        return false;
    }

    $('#txtWPAssetNo').val($('#txtARAssetNo').val());
    $('#txtWPAssetDescription').val($('#txtARTypeDescription').val());
    $('#txtWPTypeCode').val($('#txtARTypeCode').val());

    var hasEditPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Edit'");
    var hasViewPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='View'");
    var hasDeletePermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Delete'");

    if (hasEditPermission ) {
        action = "Edit"
    }
    else if (!hasEditPermission ) {
        action = "View"
    }
    $("#SNFContractor").val('');

    if (action == "View") {
        $("#btnWPSave").hide();
        $('#addMoreLar').attr('disabled', true).css('cursor', 'default').removeAttr('onclick');
        $('#addMoreThird').attr('disabled', true).css('cursor', 'default').removeAttr('onclick');

    }

    var categoryMain = "";
    var categoryLar = "";
    var categoryThird;
    $.get("/api/AssetRegisterWarrantyProviderTab/Load")
        .done(function (result) {
            var loadResult = JSON.parse(result);

            //AddNewRowLar();
            //AddNewRowThird();

            $.each(loadResult.CategoryLovMain, function (index, value) {
                loadResult.CategoryLovMain[index].LovId
                $('#LoadCategoryMain' + index).val(loadResult.CategoryLovMain[index].LovId);
                categoryMain = $('#LoadCategoryMain' + index).val();
            });

            $.each(loadResult.CategoryLovLar, function (index, value) {
                loadResult.CategoryLovLar[index].LovId
                $('#LoadCategoryLar' + index).val(loadResult.CategoryLovLar[index].LovId);
                categoryLar = $('#LoadCategoryLar' + index).val();
            });

            $.each(loadResult.CategoryLovthirdparty, function (index, value) {
                loadResult.CategoryLovthirdparty[index].LovId
                 $('#LoadCategoryThird' + index).val(loadResult.CategoryLovthirdparty[index].LovId);
                 categoryThird = $('#LoadCategoryThird' + index).val();
            });

            var primaryId = $('#hdnARPrimaryID').val();//asset Id
            //var primaryId=1
    if (primaryId != null && primaryId != "0" && primaryId!="") {
        $.get("/api/AssetRegisterWarrantyProviderTab/Get/" + primaryId)
            .done(function (response) {
                var getResult = JSON.parse(response);
                if (getResult != null && getResult.warrantyDetails != null)
                {
                    var result = getResult.warrantyDetails;
                    $('#txtWCWarrantyStartDate').val(result.WarrantyStartDate == null ? null : moment(result.WarrantyStartDate).format("DD-MMM-YYYY"));
                    $('#txtWCWarrantyEndDate').val(result.WarrantyEndDate == null ? null : moment(result.WarrantyEndDate).format("DD-MMM-YYYY"));
                    $('#txtWCWarrantyDuration').val(result.WarrantyDuration);
                    if (result.PurchaseCostRM != null) {
                        $('#txtWCPurchaseCost').val(addCommas(result.PurchaseCostRM));
                    }
                    else {
                        $('#txtWCPurchaseCost').val(result.PurchaseCostRM);
                    }
                   
                }

                GetWarrantyProviderTab(getResult)
            })
            .fail(function () {
                $('#myPleaseWait').modal('hide');
                $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
                $('#errorMsg1').css('visibility', 'visible');
            });
    }
    else {
        $('#myPleaseWait').modal('hide');
    }
        })
  .fail(function () {
      $('#myPleaseWait').modal('hide');
      $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
      $('#errorMsg1').css('visibility', 'visible');
  });


/**********************Save **********************************/

    $("#btnWPSave, #btnWPEdit").unbind('click');
    $("#btnWPSave, #btnWPEdit").click(function () {

        $('#btnlogin').attr('disabled', true);
        $("div.errormsgcenter").text("");
        $('#errorMsg1').css('visibility', 'hidden');
        
        var primaryId = $('#hdnARPrimaryID').val();//asset Id
        var timestamp = $('#hdnARTimestamp').val()
        
        var _indexLar;
        var _indexThird;
        var result = [];

        var primaryId = $("#hdnARPrimaryID").val();
        if (primaryId != null) {
            AssetId = primaryId;
            Timestamp = timestamp;
        }
        else {
            AssetId = 0;
            Timestamp = "";
        }
        var maincon = $('#ContractorIdMain_').val();
        if (maincon == "") {
                var maincon = null;
        }
    
        var _tempObjMain = {
            AssetId: AssetId,
            SupplierWarrantyId: $('#SupplierWarrantyIdMain_').val(),
            ContractorId: maincon,
            CategoryId: categoryMain,
            Timestamp: Timestamp
        }
        result.push(_tempObjMain);

        $('#ARWarProvLarTableBody tr').each(function () {
            _indexLar = $(this).index();
        });       
        for (var i = 0; i <= _indexLar; i++) {
            var _tempObjLar = {
                AssetId: AssetId,
                SupplierWarrantyId: $('#SupplierWarrantyIdLar_' + i).val(),
                IsDeleted: chkIsDeletedRowLar(i, $('#Isdeleted_' + i).is(":checked")),
                ContractorId: $('#ContractorIdLar_' + i).val(),
                CategoryId: categoryLar,
                Timestamp: Timestamp
            }

            if (_tempObjLar.IsDeleted == false) { 
                var LarConId = $('#ContractorIdLar_' + i).val();
                var LarSsmno = $('#SSMNoLar_' + i).val();
                
                if (LarSsmno == '') {
                    var isFormValid = formInputValidation("assetregWarrantyprovider", 'save');
                    if (!isFormValid) {
                        $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
                        $('#errorMsg1').css('visibility', 'visible');

                        $('#btnlogin').attr('disabled', false);
                        return false;
                    }
                }

                if (LarConId == '') {
                    DisplayErrorMessage("Local Authorised Representative - Valid Contractor / Vendor  Registration No. is required.");
                    return false;
                }
            }

            result.push(_tempObjLar);
        }

        $('#ARWarProvThirdTableBody tr').each(function () {
            _indexThird = $(this).index();
        });
        for (var i = 0; i <= _indexThird; i++) {
            var _tempObjThird = {
                AssetId: AssetId,
                SupplierWarrantyId: $('#SupplierWarrantyIdThird_' + i).val(),
                IsDeleted: chkIsDeletedRowThird(i, $('#WPThirdIsdeleted_' + i).is(":checked")),
                ContractorId: $('#ContractorIdThird_' + i).val(),
                CategoryId: categoryThird,
                Timestamp: Timestamp
            }

            if (_tempObjThird.IsDeleted == false) {
                var thrdConId = $('#ContractorIdThird_' + i).val();
                var thrdSsmno = $('#SSMNoThird_' + i).val();

                if (thrdSsmno == '') {
                    var isFormValid = formInputValidation("assetregWarrantyprovider", 'save');
                    if (!isFormValid) {
                        $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
                        $('#errorMsg1').css('visibility', 'visible');
                        $('#btnlogin').attr('disabled', false);
                        return false;
                    }
                }

                if (thrdConId == '') {
                    DisplayErrorMessage("3rd Party Service Provider - Valid Contractor / Vendor  Registration No. is required.");
                    return false;
                }
            }

            result.push(_tempObjThird);
        }

        function chkIsDeletedRowLar(i, delrec) {
            if (delrec == true) {
                $('#SSMNoLar_' + i).prop("required", false);
                return true;
            }
            else {
                return false;
            }
        }

        function chkIsDeletedRowThird(i, delrec) {
            if (delrec == true) {
                $('#SSMNoThird_' + i).prop("required", false);
                return true;
            }
            else {
                return false;
            }
        }

        function DisplayErrorMessage(errorMessage) {
            $("div.errormsgcenter").text(errorMessage);
            $('#errorMsg1').css('visibility', 'visible');
            $('#btnSave').attr('disabled', false);
            $('#btnEdit').attr('disabled', false);
        }

        var deletedCount = Enumerable.From(result).Where(x=>x.IsDeleted).Count();
        var Isdeleteavailable = deletedCount > 0;

        var isFormValid = formInputValidation("assetregWarrantyprovider", 'save');
        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg1').css('visibility', 'visible');

            $('#btnlogin').attr('disabled', false);
            return false;
        }

        var MstBlock = {
            AssetId:primaryId,
            AssetRegisterWarrantyProviderTabGrid: result,

        };

        var LARGridForDuplicateCheck = Enumerable.From(result).Where(x => x.CategoryId == 14 && !x.IsDeleted).ToArray();
        var duplicates = false;
        for (i = 0; i < LARGridForDuplicateCheck.length; i++) {
            var contractorId = LARGridForDuplicateCheck[i].ContractorId;
            for (j = i + 1; j < LARGridForDuplicateCheck.length; j++) {
                if (contractorId == LARGridForDuplicateCheck[j].ContractorId) {
                    duplicates = true;
                }
            }
        }
        if (duplicates) {
            $("div.errormsgcenter").text('Company Registration No. Should be unique in Local Authorised Representative Grid');
            $('#errorMsg1').css('visibility', 'visible');

            $('#btnlogin').attr('disabled', false);
            return false;
        }
        var ThridGridForDuplicateCheck = Enumerable.From(result).Where(x => x.CategoryId == 15 && !x.IsDeleted).ToArray();
        duplicates = false;
        for (i = 0; i < ThridGridForDuplicateCheck.length; i++) {
            var contractorId = ThridGridForDuplicateCheck[i].ContractorId;
            for (j = i + 1; j < ThridGridForDuplicateCheck.length; j++) {
                if (contractorId == ThridGridForDuplicateCheck[j].ContractorId) {
                    duplicates = true;
                }
            }
        }
        if (duplicates) {
            $("div.errormsgcenter").text('Company Registration No. Should be unique in 3rd Party Service Provider Grid');
            $('#errorMsg1').css('visibility', 'visible');

            $('#btnlogin').attr('disabled', false);
            return false;
        }

        var larAllChecked = true;
        var thirdPartyAllChecked = true;

        if ($('#ARWarProvLarTableBody tr').length == 0) {
            larAllChecked = false;
        }

        if ($('#ARWarProvThirdTableBody tr').length == 0) {
            thirdPartyAllChecked = false;
        }

        $('#ARWarProvLarTableBody tr').each(function (index, value) {
            if (!$('#Isdeleted_' + index).prop('checked')) {
                larAllChecked = false;
            }
        });

        $('#ARWarProvThirdTableBody tr').each(function (index, value) {
            if(!$('#WPThirdIsdeleted_' + index).prop('checked')){
                thirdPartyAllChecked = false;
            }
        });

        if (larAllChecked || thirdPartyAllChecked) {
            bootbox.alert(Messages.CAN_NOT_DELETE_ALL_RECORDS);
            return false;
        }

        if (Isdeleteavailable == true) {
            bootbox.confirm(Messages.MULTIPLE_DELETE_CONFIRMATION, function (result) {
                if (result) {
                    SaveWarpro(MstBlock);
                }
            });
        }
        else {
            SaveWarpro(MstBlock);
        }

        function SaveWarpro(MstBlock) {
            $('#myPleaseWait').modal('show');
            var jqxhr = $.post("/api/AssetRegisterWarrantyProviderTab/Save", MstBlock, function (response) {
                var result = JSON.parse(response);
                //$("#primaryID").val(result.AssetId);
                GetWarrantyProviderTab(result);
                $("#Timestamp").val(result.Timestamp);
                $(".content").scrollTop(0);
                showMessage('AssetRegisterWarrantyProviderTab', CURD_MESSAGE_STATUS.SS);
                $("#top-notifications").modal('show');
                setTimeout(function () {
                    $("#top-notifications").modal('hide');
                }, 5000);

                $('#btnWPSave').attr('disabled', false);
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
            $('#errorMsg1').css('visibility', 'visible');

            $('#btnWPSave').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
        });
        }

        
    });

    //$("#btnCancel").click(function () {
    //    window.location.href = "/bems/general";
    //});

    /*  Grdid Delete for Warranty Provider LAR*/
    $("#chk_WarrantyProviderLar").change(function () {
        var Isdeletebool = this.checked;
        if (this.checked) {
            $('#ARWarProvLarTableBody tr').map(function (i) {
                if ($("#Isdeleted_" + i).prop("disabled")) {
                    $("#Isdeleted_" + i).prop("checked", false);
                }
                else {
                    $("#Isdeleted_" + i).prop("checked", true);
                }
            });
        } else {
            $('#ARWarProvLarTableBody tr').map(function (i) {
                $("#Isdeleted_" + i).prop("checked", false);
            });
        }
    });

    /*  Grdid Delete for Warranty Provider Third Party*/
    $("#chk_WarrantyProviderThird").change(function () {
        var Isdeletebool = this.checked;
        if (this.checked) {
            $('#ARWarProvThirdTableBody tr').map(function (i) {
                if ($("#WPThirdIsdeleted_" + i).prop("disabled")) {
                    $("#WPThirdIsdeleted_" + i).prop("checked", false);
                }
                else {
                    $("#WPThirdIsdeleted_" + i).prop("checked", true);
                }
            });
        } else {
            $('#ARWarProvThirdTableBody tr').map(function (i) {
                $("#WPThirdIsdeleted_" + i).prop("checked", false);
            });
        }
    });
});

/************************************** Binds Warranty provider Data in Grid*********************************************/
function GetWarrantyProviderTab(getResult) {
    var warrantyProvider = getResult.AssetRegisterWarrantyProviderTabGrid;
    var warrantyProviderLar = getResult.AssetRegisterWarrantyProviderTabGrid1;
    var warrantyProviderThird = getResult.AssetRegisterWarrantyProviderTabGrid2;

    //$('#ARWarrantyProviderMainTableBody').empty();
    $('#ARWarProvLarTableBody').empty();
    $('#ARWarProvThirdTableBody').empty();

    $('#chk_WarrantyProviderLar').prop('checked', false);
    $('#chk_WarrantyProviderThird').prop('checked', false);

    

    //if (warrantyProvider != null) {

        //if (warrantyProviderLar != null && warrantyProviderLar.length == 0) {
        //    $("#LARSSMlabl").html("Contractor/Vendor SSM No.");
        //}
        //if (warrantyProviderThird != null && warrantyProviderThird.length == 0) {
        //    $("#ThirdPartySSMlabl").html("Contractor/Vendor SSM No.");
        //}

        if (warrantyProvider != null) {// && warrantyProvider.CategoryId == 13
        $('#SNFContractor').val('');
        $('#SupplierWarrantyIdMain_').val(warrantyProvider[0].SupplierWarrantyId);
        $('#ContractorIdMain_').val(warrantyProvider[0].ContractorId);
        $('#SSMNo_').val(warrantyProvider[0].SSMNo);
        $('#ContractorName_').val(warrantyProvider[0].ContractorName);
        $('#ContactPerson_').val(warrantyProvider[0].ContactPerson);
        $('#TelephoneNo_').val(warrantyProvider[0].ContactNo);
        $('#Email_').val(warrantyProvider[0].Email);
        $('#FaxNo_').val(warrantyProvider[0].FaxNo);
        $('#Address_').val(warrantyProvider[0].Address);
        $('#myPleaseWait').modal('hide');
    }

        if (warrantyProviderLar != null) {// && warrantyProviderLar.CategoryId == 14
        $.each(warrantyProviderLar, function (index, value) {
            AddNewRowLar();

            //$("#ContractorIdLar_" + index).val(warrantyProviderLar[index].SSMNo);
            $("#SSMNoLar_" + index).val(warrantyProviderLar[index].SSMNo);
            $("#ContractorIdLar_" + index).val(warrantyProviderLar[index].ContractorId);
            $("#SupplierWarrantyIdLar_" + index).val(warrantyProviderLar[index].SupplierWarrantyId);
            $("#ContractorNameLar_" + index).val(warrantyProviderLar[index].ContractorName);
            $("#ContactPersonLar_" + index).val(warrantyProviderLar[index].ContactPerson);
            $('#TelephoneNoLar_' + index).val(warrantyProviderLar[index].ContactNo);
            $("#EmailLar_" + index).val(warrantyProviderLar[index].Email);
            $("#FaxNoLar_" + index).val(warrantyProviderLar[index].FaxNo);
            $('#AddressLar_' + index).val(warrantyProviderLar[index].Address);
        });
    }

        if (warrantyProviderThird != null) {// && warrantyProviderThird.CategoryId == 15
        $.each(warrantyProviderThird, function (index, value) {
            AddNewRowThird();
            $("#SSMNoThird_" + index).val(warrantyProviderThird[index].SSMNo);
            $("#ContractorIdThird_" + index).val(warrantyProviderThird[index].ContractorId);
            $("#SupplierWarrantyIdThird_" + index).val(warrantyProviderThird[index].SupplierWarrantyId);
            $("#ContractorNameThird_" + index).val(warrantyProviderThird[index].ContractorName);
            $("#ContactPersonThird_" + index).val(warrantyProviderThird[index].ContactPerson);
            $('#TelephoneNoThird_' + index).val(warrantyProviderThird[index].ContactNo);
            $("#EmailThird_" + index).val(warrantyProviderThird[index].Email);
            $("#FaxNoThird_" + index).val(warrantyProviderThird[index].FaxNo);
            $('#AddressThird_' + index).val(warrantyProviderThird[index].Address);
        });
    }

    if (action == "View") {
        $("#assetregWarrantyprovider :input:not(:button)").prop("disabled", true);
    }
    //}
}
$("#btntab3Cancel").click(function () {
    // window.location.href = "/bems/general";
    var message = Messages.Reset_TabAlert_CONFIRMATION;
    bootbox.confirm(message, function (result) {
        if (result) {
            EmptyFieldswarrantycoverage();
        }
        else {
            $('#myPleaseWait').modal('hide');
        }
    });
});
//function bttab3Cancel() {
//    window.location.href = "/bems/general";
//}

//var addMoreFlag;
//$('#addMoreLar').click(function () {
//    addMoreFlag = true;
//});


function AddNewLar() {
    $("div.errormsgcenter").text("");
    $('#errorMsg1').css('visibility', 'hidden');
    var rowCount = $('#ARWarProvLarTableBody tr:last').index();
    var ParticiName = $('#SSMNoLar_' + rowCount).val();

    if (rowCount < 0)
        AddNewRowLar();
    else if (rowCount >= "0" && (ParticiName == "")) {
        bootbox.alert("Please enter values in existing row");
         // $("div.errormsgcenter1").text();
         //$('#errorMsg1').css('visibility', 'visible');
    }
    else {
        AddNewRowLar();
    }
}


// Adding child rows for LAR grid
function AddNewRowLar()
{
    $("#LARSSMlabl").html("Contractor / Vendor Registration No. <span class='red'>*</span>");
    var inputpar = {
        inlineHTML: '<tr class="ng-scope" style=""> <div> <input type="hidden" id="larCat"> </div>  \
            <td width="5%" id="WarrantyProviderDel" data-original-title="" title=""> <div class="checkbox text-center"> <label for="checkboxes-0"> <input type="checkbox" name="WarrantyProviderCheckboxes" id="Isdeleted_maxindexval" onchange="IsDeleteCheckAll(ARWarProvLarTableBody,chk_WarrantyProviderLar)"> </label> </div></td> \
            <td width="20%" style="text-align: center;" data-original-title="" title=""> <div> <input id="SSMNoLar_maxindexval" type="text" class="form-control fetch" name="SSMNo" autocomplete="off" placeholder="Please Select" onkeyup="FetchdataLAR(event,maxindexval)" onpaste="FetchdataLAR(event,maxindexval)" change="FetchdataLAR(event,maxindexval)" oninput="FetchdataLAR(SSMNoLar_maxindexval,maxindexval)" required> </div> \
                        <input type="hidden" id="ContractorIdLar_maxindexval"/> <div class="col-sm-12" id="LarDivFetch_maxindexval"></div> \
                        <input type="hidden" id="SupplierWarrantyIdLar_maxindexval"/></td> \
            <td width="15%" style="text-align: center;" data-original-title="" title=""> <div> <input id="ContractorNameLar_maxindexval" type="text" class="form-control fetchField " name="ContractorName" readonly="readonly"> </div></td> \
            <td width="15%" style="text-align: center;" data-original-title="" title=""> <div> <input id="ContactPersonLar_maxindexval" type="text" class="form-control fetchField " name="ContactPerson" readonly="readonly"> </div></td> \
            <td width="10%" style="text-align: center;" data-original-title="" title=""> <div> <input id="TelephoneNoLar_maxindexval" type="text" class="form-control fetchField " name="TelephoneNo" readonly="readonly"> </div></td> \
            <td width="10%" style="text-align: center;" data-original-title="" title=""> <div> <input id="EmailLar_maxindexval" type="text" class="form-control fetchField " name="Email" readonly="readonly"> </div></td> \
            <td width="10%" style="text-align: center;" data-original-title="" title=""> <div> <input id="FaxNoLar_maxindexval" type="text" class="form-control fetchField " name="FaxNo" autocomplete="off" readonly="readonly"> </div></td> \
            <td width="15%" style="text-align: center;" data-original-title="" title=""> <div> <input id="AddressLar_maxindexval" type="text" class="form-control fetchField " name="Address" autocomplete="off" readonly="readonly"> </div></td></tr>',
        IdPlaceholderused: "maxindexval",
        TargetId: "#ARWarProvLarTableBody",
        TargetElement: ["tr"]
    }
    AddNewRowToDataGrid(inputpar);

    //var lastTdVal;
    //if (!addMoreFlag) {
    //    lastTdVal = true;      
    //} else if (addMoreFlag) {        
    //    lastTdVal = $('#ARWarProvLarTableBody tr:last-child .fetch').val();
    //}
    //if (lastTdVal) {
    //    $("#errorMsg1").text("");
    //    AddNewRowToDataGrid(inputpar);
    //}
    //else {
    //    $("#errorMsg1").text("Please Fill First Row");
    //    bootbox.alert("Please enter values in existing row");
    //}
}


function AddNewThird() {
    $("div.errormsgcenter").text("");
    $('#errorMsg1').css('visibility', 'hidden');
    var rowCount = $('#ARWarProvThirdTableBody tr:last').index();
    var ParticiName = $('#SSMNoThird_' + rowCount).val();

    if (rowCount < 0)
        AddNewRowThird();
    else if (rowCount >= "0" && (ParticiName == "")) {
        bootbox.alert("Please enter values in existing row");
        //$("div.errormsgcenter1").text();
        //$('#errorMsg1').css('visibility', 'visible');
    }
    else {
        AddNewRowThird();
    }
}

// Adding child rows for Third party  grid
function AddNewRowThird() {
    $("#ThirdPartySSMlabl").html("Contractor / Vendor Registration No. <span class='red'>*</span>");
    var inputpar = {
        inlineHTML: ' <tr class="ng-scope" style=""> <div> <input type="hidden" id="thirdparty0"> </div> \
                      <td width="5%" id="WarrantyProviderDel" data-original-title="" title=""> <div class="checkbox text-center"> <label for="checkboxes-0"> <input type="checkbox" name="WarrantyProviderCheckboxes" id="WPThirdIsdeleted_maxindexval" onchange="IsDeleteCheckAll1(ARWarProvThirdTableBody,chk_WarrantyProviderThird)"> </label> </div></td>\
                    <td width="20%" style="text-align: center;" data-original-title="" title=""> <div> <input id="SSMNoThird_maxindexval" type="text" class="form-control fetch" name="SSMNo" autocomplete="off" placeholder="Please Select" onkeyup="FetchdataThird(event,maxindexval)" onpaste="FetchdataThird(event,maxindexval)" change="FetchdataThird(event,maxindexval)" oninput="FetchdataThird(SSMNoThird_maxindexval,maxindexval)" required> \
                                </div><input type="hidden" id="ContractorIdThird_maxindexval"/> <div class="col-sm-12" id="ThirdDivFetch_maxindexval"></div></td> \
                                <input type="hidden" id="SupplierWarrantyIdThird_maxindexval"/></td> \
                    <td width="15%" style="text-align: center;" data-original-title="" title=""> <div> <input id="ContractorNameThird_maxindexval" type="text" class="form-control fetchField " name="ContractorName" autocomplete="off" readonly="readonly"> </div></td> \
                    <td width="15%" style="text-align: center;" data-original-title="" title=""> <div> <input id="ContactPersonThird_maxindexval" type="text" class="form-control fetchField " name="ContactPerson" autocomplete="off" readonly="readonly"> </div></td> \
                    <td width="10%" style="text-align: center;" data-original-title="" title=""> <div> <input id="TelephoneNoThird_maxindexval" type="text" class="form-control fetchField " name="TelephoneNo" autocomplete="off" readonly="readonly"> </div></td> \
                    <td width="10%" style="text-align: center;" data-original-title="" title=""> <div> <input id="EmailThird_maxindexval" type="text" class="form-control fetchField " name="Email" autocomplete="off"  readonly="readonly"> </div></td> \
                    <td width="10%" style="text-align: center;" data-original-title="" title=""> <div> <input id="FaxNoThird_maxindexval" type="text" class="form-control fetchField " name="FaxNo" autocomplete="off" readonly="readonly"> </div></td> \
                    <td width="15%" style="text-align: center;" data-original-title="" title=""> <div> <input id="AddressThird_maxindexval" type="text" class="form-control fetchField " name="Address" autocomplete="off" readonly="readonly"> </div></td></tr>',
        IdPlaceholderused: "maxindexval",

       /* inlineHTML: ' <tr class="ng-scope" style=""> <td> <div> <input type="hidden" id="thirdparty"> </div></td>  \
            <td width="3%" id="WarrantyProviderDel" data-original-title="" title=""> <div class="checkbox text-center"> <label for="checkboxes-0"> <input type="checkbox" name="WarrantyProviderCheckboxes" id="WPIsdeleted_maxindexval"> </label> </div></td> \
            <td width="10%" style="text-align: center;" data-original-title="" title=""> <div> <input id="SSMNoLar_maxindexval" type="text" class="form-control" name="SSMNo" placeholder="Please Select" onkeyup="Fetchdata(null,null,1)" onpaste="Fetchdata(null,null,1)" change="Fetchdata(null,null,1)" oninput="Fetchdata(SSMNoLar_maxindexval,maxindexval,1)"> </div> \
                        <input type="hidden" id="ContractorIdLar_maxindexval"/> <div class="col-sm-12" id="LarDivFetch1_maxindexval"></div></td> \
                        <input type="hidden" id="SupplierWarrantyId_maxindexval"/> <div class="col-sm-12" id="LarDivFetch_maxindexval"></div></td> \
            <td width="10%" style="text-align: center;" data-original-title="" title=""> <div> <input id="ContractorNameLar_maxindexval" type="text" class="form-control fetchField " name="ContractorName"> </div></td> \
            <td width="10%" style="text-align: center;" data-original-title="" title=""> <div> <input id="ContactPersonLar_maxindexval" type="text" class="form-control fetchField " name="ContactPerson"> </div></td> \
            <td width="10%" style="text-align: center;" data-original-title="" title=""> <div> <input id="TelephoneNoLar_maxindexval" type="text" class="form-control fetchField " name="TelephoneNo"> </div></td> \
            <td width="10%" style="text-align: center;" data-original-title="" title=""> <div> <input id="EmailLar_maxindexval" type="text" class="form-control fetchField " name="Email"> </div></td> \
            <td width="10%" style="text-align: center;" data-original-title="" title=""> <div> <input id="FaxNoLar_maxindexval" type="text" class="form-control fetchField " name="FaxNo" autocomplete="off"> </div></td> \
            <td width="10%" style="text-align: center;" data-original-title="" title=""> <div> <input id="AddressLar_maxindexval" type="text" class="form-control fetchField " name="Address" autocomplete="off" no-special-char=""> </div></td></tr>',
        IdPlaceholderused: "maxindexval",   */

        TargetId: "#ARWarProvThirdTableBody",
        TargetElement: ["tr"]
    }
    //var lastTdVal1;
    //if (!addMoreFlag1) {
    //    lastTdVal1 = true;
    //} else if (addMoreFlag1) {
    //    lastTdVal1 = $('#ARWarProvThirdTableBody tr:last-child .fetch').val();
    //}
    //if (lastTdVal1) {
    //    $("#errorMsg1").text("");
    //    AddNewRowToDataGrid(inputpar);
    //}
    //else {
    //    //$("#errorMsg1").text("Please Fill First Row");
    //    bootbox.alert("Please enter values in existing row");
    //}


    AddNewRowToDataGrid(inputpar);
}


function IsDeleteCheckAll() {
    var Isdeleted_ = [];
    $('#ARWarProvLarTableBody tr').map(function (index, value) {
        var Isdelete = $("#Isdeleted_" + index).is(":checked");
        if (Isdelete)
            Isdeleted_.push(Isdelete);
    });

    if ($('#ARWarProvLarTableBody tr').length == Isdeleted_.length)
        $("#chk_WarrantyProvider").prop("checked", true);
    else
        $("#chk_WarrantyProvider").prop("checked", false);
    
}

function IsDeleteCheckAll1() {
    var Isdeleted_ = [];
    $('#ARWarProvThirdTableBody tr').map(function (index, value) {
        var Isdelete = $("#WPThirdIsdeleted_" + index).is(":checked");
        if (Isdelete)
            Isdeleted_.push(Isdelete);
    });

    if ($('#ARWarProvThirdTableBody tr').length == Isdeleted_.length)
        $("#chk_WarrantyProviderThird").prop("checked", true);
    else
        $("#chk_WarrantyProviderThird").prop("checked", false);

}

// Fetch control for LAR and ThirdParty Commonly
//function Fetchdata(event, index, div) {
//    div = (div == undefined ? '' : div);
//    // var index = arrayforIndex[temp - 1] ? arrayforIndex[temp - 1] : undefined;
//    var ItemMst = {
//        SearchColumn: 'SSMNoLar_' + index + '-SSMNo',//Id of Fetch field
//        ResultColumns: ["ContractorId" + "-Primary Key", 'SSMNo' + '-SSMNoLar_' + index],//Columns to be displayed
//        FieldsToBeFilled: ["ContractorIdLar_" + index + "-ContractorId", 'SSMNoLar_' + index + '-SSMNo', 'ContractorNameLar_' + index + '-ContractorName', 'ContactPersonLar_' + index + '-ContactPerson', 'TelephoneNoLar_' + index + '-ContactNo', 'EmailLar_' + index + '-Email', 'FaxNoLar_' + index + '-FaxNo', 'AddressLar_' + index + '-Address', ]//id of element - the model property
//    };
//    DisplayFetchResult("ItemMst", 'LarDivFetch' + div +'_' + index, ItemMst, "/api/Fetch/FetchWarrantyProvider", "Ulfetch" + index, event, 1);
//}

//Fetch control for Main Supplier
function FetchdataMain(event) {
    // var index = arrayforIndex[temp - 1] ? arrayforIndex[temp - 1] : undefined;
    var ItemMst = {
        SearchColumn: 'SSMNo_' + '-SSMNo',//Id of Fetch field
        ResultColumns: ["ContractorId" + "-Primary Key", 'SSMNo' + '-SSMNo_' ],//Columns to be displayed
        FieldsToBeFilled: ["ContractorIdMain_"  + "-ContractorId", 'SSMNo_'  + '-SSMNo', 'ContractorName_'  + '-ContractorName', 'ContactPerson_'  + '-ContactPerson', 'TelephoneNo_'  + '-ContactNo', 'Email_'  + '-Email', 'FaxNo_'  + '-FaxNo', 'Address_'  + '-Address', ]//id of element - the model property
    };
    DisplayFetchResult( 'MainDivFetch_', ItemMst, "/api/Fetch/FetchWarrantyProvider", "Ulfetch", event, 1);
}

 //Fetch control for LAR
function FetchdataLAR(event, index) {
    var ItemMst = {
        SearchColumn: 'SSMNoLar_' + index + '-SSMNo',//Id of Fetch field
        ResultColumns: ["ContractorId" + "-Primary Key", 'SSMNo' + '-SSMNoLar_' + index],//Columns to be displayed
        FieldsToBeFilled: ["ContractorIdLar_" + index + "-ContractorId", 'SSMNoLar_' + index + '-SSMNo', 'ContractorNameLar_' + index + '-ContractorName', 'ContactPersonLar_' + index + '-ContactPerson', 'TelephoneNoLar_' + index + '-ContactNo', 'EmailLar_' + index + '-Email', 'FaxNoLar_' + index + '-FaxNo', 'AddressLar_' + index + '-Address', ]//id of element - the model property
    };
    DisplayFetchResult( 'LarDivFetch_' + index, ItemMst, "/api/Fetch/FetchWarrantyProvider", "Ulfetch" + index, event, 1);
}

//Fetch control for Third Party
function FetchdataThird(event, index) {
    var ItemMst = {
        SearchColumn: 'SSMNoThird_' + index + '-SSMNo',//Id of Fetch field
        ResultColumns: ["ContractorId" + "-Primary Key", 'SSMNo' + '-SSMNoThird_' + index],//Columns to be displayed
        FieldsToBeFilled: ["ContractorIdThird_" + index + "-ContractorId", 'SSMNoThird_' + index + '-SSMNo', 'ContractorNameThird_' + index + '-ContractorName', 'ContactPersonThird_' + index + '-ContactPerson', 'TelephoneNoThird_' + index + '-ContactNo', 'EmailThird_' + index + '-Email', 'FaxNoThird_' + index + '-FaxNo', 'AddressThird_' + index + '-Address', ]//id of element - the model property
    };
    DisplayFetchResult( 'ThirdDivFetch_' + index, ItemMst, "/api/Fetch/FetchWarrantyProvider", "Ulfetch2" + index, event, 1);
}
function EmptyFieldswarrantycoverage() {
   
    $('input[type="text"], textarea').val('');
    $('#selARAssetClassification').val("null");
    $('#selARServiceId,.selARServiceId').val(2);
    $('#selARAssetStatus').val(1);
    $('#selARRiskRating').val(113);
    $('#selARPurchaseCategory').val("null");
    $('#selARAppliedPartType').val("null");
    $('#selAREquipmentClass').val("null");
    $('#selARPPM').val("null");
    $('#selAROther').val("null");
    $('#selARRI').val("null");
    $('#selARAssetTransferMode').val("null");

    $('#txtARAssetNo').attr('disabled', false);

    $('#txtARTypeCode').attr('disabled', false);
    $('#txtARAssetPreRegistrationNo').attr('disabled', false);
    $('#spnPopup-assetPreRegistration').unbind("click").attr('disabled', false).css('cursor', 'default');
    $('#spnPopup-typeCode').unbind("click").attr('disabled', false).css('cursor', 'default');
    $('#btnAREdit').hide();
    $('#btnARSave').show();
    $('#btnDelete').hide();
    $('#btnNextScreenSave').hide();
    $('#spnActionType').text('Add');
    $("#hdnARPrimaryID").val('');
    $("#grid").trigger('reloadGrid');
    $("#assetRegister :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');    
    $('#ARWarProvLarTableBody').empty();
    $('#ARWarProvThirdTableBody').empty();
    $('.nav-tabs a:first').tab('show')
    $('#selARTypeofasset').val("null");
}