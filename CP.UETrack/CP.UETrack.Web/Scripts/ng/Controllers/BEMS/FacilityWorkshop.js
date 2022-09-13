//*Golbal variables decration section starts*//
var pageindex = 1; var pagesize = 5;
var LOVlist = {};
var GridtotalRecords;
var TotalPages =1, FirstRecord, LastRecord = 0;
var ActionType = $('#ActionType').val();
$('#btnDelete').hide();
$('#btnEdit').hide();
$('#btnNextScreenSave').hide();
//*Golbal variables decration section ends*//

$(document).ready(function () {

    //$("#workshoptablehead").hide();
      formInputValidation("FacilityWorkshopForm");

    $.get("/api/FacilityWorkshop/Load")
        .done(function (result) {
            var loadResult = JSON.parse(result);
            $("#jQGridCollapse1").click();
            LOVlist = loadResult

            window.LocationLovs = loadResult.LocationLovs

            AddNewRowFacilityWorkshop();
            $.each(loadResult.ServiceLovs, function (index, value) {
                if (value.LovId == 2)
                    $('#FacilityworkService').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            $.each(loadResult.YearLovs, function (index, value) {               
                    $('#FacilityworkYear').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });

            $('#FacilityworkYear').val(2); 
            $.each(loadResult.FacilityTypeLovs, function (index, value) {
                $('#FacilityworkFacilityType').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
            //$.each(loadResult.CategoryLovs, function (index, value) {
            //    $('#FacilityworkCategory').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>').prop("disabled", "disabled");
            //});

//****************************************** Changing dropdown values *********************************************

            $("#FacilityworkFacilityType").change(function () {
                $("#FacilityWorkshopTbl").empty();
                AddNewRowFacilityWorkshop();

                $('#FacilityWorkshopTbl tr').each(function (index, value) {
                    ClearAll(index, value);
                    });
                   

                if (this.value == 101 || this.value == '') {
                    $('#lblFWCategory').html("Category")
                    $('#FacilityworkCategory').prop('required', false);
                    $('#FacilityWorkshopTbl tr').each(function (index, value) {
                        FacTypeResCen(index, value);
                    });
                    $("#FacilityworkCategory").val('').empty().append('<option value="">Select</option>').prop("disabled", "disabled");
                    //formInputValidation("FacilityWorkshopForm");
                }

                else if (this.value == 102) {
                    $('#lblFWCategory').html("Category <span class='red'>*</span>")
                    $('#FacilityworkCategory').prop('required', true);
                    
                    $('#FacilityWorkshopTbl tr').each(function (index, value) {
                        FacTypeStorage(index, value);
                    });

                    $("#FacilityworkCategory").empty().append('<option value="">Select</option>');
                    $.each(loadResult.CategoryLovs, function (index, value) {
                        if (value.LovId == 104 || value.LovId == 105 || value.LovId == 106)
                            $('#FacilityworkCategory').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>').prop("disabled", false);                        
                    });
                }

                else if (this.value == 103) {
                    $('#lblFWCategory').html("Category <span class='red'>*</span>")
                    $('#FacilityworkCategory').prop('required', true);
                    $('#FacilityWorkshopTbl tr').each(function (index, value) {
                        FacTypeWorkshop(index, value)
                    });

                    $("#FacilityworkCategory").empty().append('<option value="">Select</option>');
                    $.each(loadResult.CategoryLovs, function (index, value) {
                        if (value.LovId == 107 || value.LovId == 108 || value.LovId == 109 || value.LovId == 110)                            
                        $('#FacilityworkCategory').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>').prop("disabled", false);
                    });
                }

                $("#FacilityWorkshopTbl tr").find('div').removeClass('has-error');
                //$("div.errormsgcenter").css('dispaly', 'none');
                //$('#errorMsg').hide();
            });

            $("#FacilityworkCategory").change(function () {

                $("#FacilityWorkshopTbl").empty();
                AddNewRowFacilityWorkshop();

                $('#FacilityWorkshopTbl tr').each(function (index, value) {
                    ClearAll(index, value);
                });

                if ($('#FacilityworkCategory').val() == 107 /*|| $('#FacilityworkCategory').val() == 109 */) {
                $('#FacilityWorkshopTbl tr').each(function (index, value) {
                    CatLoaner(index, value);
                });
                }
                else if ($('#FacilityworkCategory').val() == 109)
                {
                    $('#FacilityWorkshopTbl tr').each(function (index, value) {
                        CatTestEquip(index, value);
                    });
                }
                else if ($('#FacilityworkCategory').val() == 104)
                {
                    $('#FacilityWorkshopTbl tr').each(function (index, value) {
                        CatEquipRepair(index, value);
                            });
                }
                    else if ($('#FacilityworkCategory').val() == 108)
                {
                        $('#FacilityWorkshopTbl tr').each(function (index, value) {
                            CatMachinery(index, value);
                            });
                }
                else if ($('#FacilityworkCategory').val() == 110) {
                    $('#FacilityWorkshopTbl tr').each(function (index, value) {
                        CatTools(index, value);
                    });
                }
                else {
                    $('#FacilityWorkshopTbl tr').each(function (index, value) {
                        CatRest(index, value);
                    });
                }
                $("#FacilityWorkshopTbl tr").find('div').removeClass('has-error');
                //$("div.errormsgcenter").text('');
                //$('#errorMsg').css('dispaly', 'none');
            });

            ////******************************************** Getby ID ****************************************************
            //var primaryId = $('#primaryID').val();
            //if (primaryId != null && primaryId != "0") {
            //    $.get("/api/FacilityWorkshop/Get/" + primaryId + "/" + pagesize + "/" + pageindex)
            //      .done(function (result) {
            //          var getResult = JSON.parse(result);

            //          GetFaciltyWorkShopData(getResult)

            //                  $('#myPleaseWait').modal('hide');

            //      })
            //     .fail(function () {
            //         $('#myPleaseWait').modal('hide');
            //         $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
            //         $('#errorMsg').css('visibility', 'visible');
            //     });
            //}
            //else {
            //    $('#myPleaseWait').modal('hide');
            //}


        })
  .fail(function () {
      $('#myPleaseWait').modal('hide');
      $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
      $('#errorMsg').css('visibility', 'visible');
  });


    //****************************************** Save *********************************************

    $('#btnSave,#btnEdit,#btnSaveandAddNew').click(function () {
        $('#myPleaseWait').modal('show');
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
          var CurrentbtnID = $(this).attr("Id");
        //var isFormValid = formInputValidation("FacilityWorkshopForm", 'save');
        //if (!isFormValid) {
        //    $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        //    $('#errorMsg').css('visibility', 'visible');

        //    $('#btnlogin').attr('disabled', false);
        //    $('#myPleaseWait').modal('hide');
        //    return false;
        //}

        var _index;
        $('#FacilityWorkshopTbl tr').each(function () {
            _index = $(this).index();
        });

        var FacilityWorkshopId = $('#primaryID').val();
       // var ServiceId = $('#FacilityworkService').val();
        var year = $('#FacilityworkYear option:selected').text();
        var facilityType = $("#FacilityworkFacilityType").val();
        var category = $("#FacilityworkCategory").val();
        var timeStamp = $("#Timestamp").val();       

            $('body').on('click', ".numb", function () {
                var a = [];
                var k = e.which;

                for (key = 48; key < 58; key++)
                    a.push(key);

                if (!(a.indexOf(k) >= 0))
                    e.preventDefault();
            });

        var result = [];
        for (var i = 0; i <= _index; i++) {
            if($('#HdnFacilityWorkshopAssetId_' + i).val() == 0){
                AssetId = null;
            }
            else if($('#HdnFacilityWorkshopAssetId_' + i).val() > 0){
                AssetId = $('#HdnFacilityWorkshopAssetId_' + i).val();
            }

            var _FacilityWorkshopGrid = {
                FacilityWorkshopId: $('#primaryID').val(),
                FacilityWorkshopDetId: $('#HdnFacilityWorkshopDetId_' + i).val(),
                //AssetId: $('#HdnFacilityWorkshopAssetId_' + i).val(),
                AssetId: AssetId,
                AssetNo: $('#FWAssetNo_' + i).val(),
                Description: $.trim($('#FWDescription_' + i).val()),
                Manufacturer: $('#FWManufacturer_' + i).val(),
                Model: $('#FWModel_' + i).val(),
                SerialNo: $('#FWSerialNo_' + i).val(),
                CalibrationDueDate: $('#FWCalibDueDate_' + i).val(),
                LocationId: $("#FWLocation_" + i).val(),
                Quantity: $("#FWQuantity_" + i).val(),
                SizeArea: $("#FWArea_" + i).val(),
                //IsDeleted: $('#Isdeleted_' + i).is(":checked"),
                IsDeleted: chkIsDeletedRow(i, $('#Isdeleted_' + i).is(":checked")),
            }
            result.push(_FacilityWorkshopGrid);
            
            
        }

        //var validAssetNo = false;
        //for (i = 0; i < result.length; i++) {
        //    if (result[i].Description == "" || result[i].Description == null || result[i].Manufacturer == "" || result[i].Manufacturer == null
        //        || result[i].Model == "" || result[i].Model == null)
        //    {
        //        validAssetNo = true;
        //    }
        //}
        //if (validAssetNo)
        //{
        //    $("div.errormsgcenter").text("Valid Asset No. is Required.");
        //    $('#errorMsg').css('visibility', 'visible');
        //    $('#myPleaseWait').modal('hide');
        //    return false;
        //}

        function chkIsDeletedRow(i, delrec) {
            if (delrec == true) {
                $('#FWAssetNo_' + i).prop("required", false);
                $('#FWDescription_' + i).prop("required", false);
                $('#FWManufacturer_' + i).prop("required", false);
                $('#FWModel_' + i).prop("required", false);
                $('#FWSerialNo_' + i).prop("required", false);
                $('#FWCalibDueDate_' + i).prop("required", false);
                $('#FWLocation_' + i).prop("required", false);
                $('#FWQuantity_' + i).prop("required", false);
                $('#FWArea_' + i).prop("required", false);
                return true;
            }
            else {
                return false;
            }
        }
        var deletedCount = Enumerable.From(result).Where(x=>x.IsDeleted).Count();
        var Isdeleteavailable = deletedCount > 0;
        if (deletedCount == result.length && TotalPages == 1) {
            bootbox.alert("Sorry!. You cannot delete all rows");
            $('#myPleaseWait').modal('hide');
            return false;
        }
        var primaryId = $("#primaryID").val();
        if (primaryId != null) {
            FacilityWorkshopId = primaryId;
            Timestamp = timeStamp;
        }
        else {
            FacilityWorkshopId = 0;
            Timestamp = "";
        }

        var isFormValid = formInputValidation("FacilityWorkshopForm", 'save');
        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');

            $('#btnlogin').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            return false;
        }

        for (var i = 0; i <= _index; i++) {
            if (result[i].IsDeleted == false) {

                if (category == 107 || category == 109) {
                    if (result[i].AssetId == null || result[i].AssetId == "" || result[i].AssetId == 0) {
                        // if (AstId == "" || AstId == 0) {
                        $("div.errormsgcenter").text("Valid Asset No. is Required.");
                        $('#errorMsg').css('visibility', 'visible');
                        $('#myPleaseWait').modal('hide');
                        return false;
                    }
                }
            }
        }
        if ($('#FWQuantity_'=='')){
        for (var i = 0; i <= _index; i++) {
            if (result[i].IsDeleted == false) {

                if (facilityType == 102 || facilityType == 103) {
                    if (result[i].Quantity == 0) {
                        // if (AstId == "" || AstId == 0) {
                        $("div.errormsgcenter").text("Quantity should be greater than zero.");
                        $('#errorMsg').css('visibility', 'visible');
                        $('#myPleaseWait').modal('hide');
                        return false;
                    }
                }
            }
        }
}

        var obj = {

            FacilityWorkshopId: FacilityWorkshopId,
           // ServiceId: ServiceId,
            Year: year,
            FacilityTypeId: facilityType,
            CategoryId: category,
            FacilityWorkshopGridData: result,
            Timestamp: timeStamp
        }

        //if (obj.FacilityWorkshopGridData[_index].IsDeleted == true) {
        //    alert("true");
        //}

        var Isdeleteavailable = Enumerable.From(result).Where(x=>x.IsDeleted).Count() > 0;
        if (Isdeleteavailable) {
            //alert("true");
            bootbox.confirm(Messages.MULTIPLE_DELETE_CONFIRMATION, function (result) {
                if (result) {
                        var jqxhr = $.post("/api/FacilityWorkshop/Save", obj, function (response) {
                            var result = JSON.parse(response);
                            GetFaciltyWorkShopData(result);
                            $("#primaryID").val(result.FacilityWorkshopId);
                            $("#Timestamp").val(result.Timestamp);
                            $("#grid").trigger('reloadGrid');
                            if (result.FacilityWorkshopId != 0) {                                                   
                                $('#btnEdit').show();
                                $('#btnSave').hide();
                                $('#btnDelete').show();
                            }
                            $(".content").scrollTop(0);
                            showMessage('Facility Workshop Details', CURD_MESSAGE_STATUS.SS);
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
                                errorMessage = Messages.COMMON_FAILURE_MESSAGE(response);
                            }
                            $("div.errormsgcenter").text(errorMessage);
                            $('#errorMsg').css('visibility', 'visible');

                            $('#btnSave').attr('disabled', false);
                            $('#myPleaseWait').modal('hide');
                        });
                    }
                else {
                    $("#top-notifications").modal('show');
                    setTimeout(function () {
                        $("#top-notifications").modal('hide');
                    }, 5);

                    $('#btnSave').attr('disabled', false);
                    $('#myPleaseWait').modal('hide');
                }

            });
        }
        else {
            var jqxhr = $.post("/api/FacilityWorkshop/Save", obj, function (response) {
                var result = JSON.parse(response);
                GetFaciltyWorkShopData(result);
                $("#primaryID").val(result.FacilityWorkshopId);
                $("#Timestamp").val(result.Timestamp);
                $("#grid").trigger('reloadGrid');
                if (result.FacilityWorkshopId != 0) {
                    $('#btnEdit').show();
                    $('#btnSave').hide();
                    $('#btnDelete').show();
                }
                $(".content").scrollTop(0);
                showMessage('Facility Workshop Details', CURD_MESSAGE_STATUS.SS);
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
                 errorMessage = Messages.COMMON_FAILURE_MESSAGE(response);
             }
             $("div.errormsgcenter").text(errorMessage);
             $('#errorMsg').css('visibility', 'visible');

             $('#btnSave').attr('disabled', false);
             $('#myPleaseWait').modal('hide');
         });
    }

        //var isFormValid = formInputValidation("WarrantyManagementForm", 'save');
        //if (!isFormValid) {
        //    $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        //    $('#errorMsg').css('visibility', 'visible');
        //    $('#myPleaseWait').modal('hide');
        //    $('#btnSave').attr('disabled', false);
        //    //$('#btnEdit').attr('disabled', false);
        //    return false;
        //}

       // var jqxhr = $.post("/api/FacilityWorkshop/Save", obj, function (response) {
       //     var result = JSON.parse(response);
       //     GetFaciltyWorkShopData(result);
       //     $("#primaryID").val(result.FacilityWorkshopId);
       //     $("#Timestamp").val(result.Timestamp);

       //     showMessage('Facility Workshop Details', CURD_MESSAGE_STATUS.SS);
       //     $("#top-notifications").modal('show');
       //     setTimeout(function () {
       //         $("#top-notifications").modal('hide');
       //     }, 5000);

       //     $('#btnSave').attr('disabled', false);
       //     $('#myPleaseWait').modal('hide');
       // },

       //"json")
       // .fail(function (response) {
       //     var errorMessage = "";
       //     if (response.status == 400) {
       //         errorMessage = response.responseJSON;
       //     }
       //     else {
       //         errorMessage = Messages.COMMON_FAILURE_MESSAGE;
       //     }
       //     $("div.errormsgcenter").text(errorMessage);
       //     $('#errorMsg').css('visibility', 'visible');

       //     $('#btnSave').attr('disabled', false);
       //     $('#myPleaseWait').modal('hide');
       // });

        //$("#chk_FacWorkIsDelete").change(function () {
        //    var Isdeletebool = this.checked;
        //    $('#FacilityWorkshopTbl tr').map(function (i) {
        //        if (Isdeletebool)   
        //            $("#Isdeleted_" + i).prop("checked", true);
        //        else
        //            $("#Isdeleted_" + i).prop("checked", false);
        //    });
        //});

    });

    $("#chk_FacWorkIsDelete").change(function () {
        var Isdeletebool = this.checked;

        if (this.checked) {
            $('#FacilityWorkshopTbl tr').map(function (i) {
                if ($("#Isdeleted_" + i).prop("disabled")) {
                    $("#Isdeleted_" + i).prop("checked", false);
                }
                else {
                    $("#Isdeleted_" + i).prop("checked", true);
                }
            });
        } else {
            $('#FacilityWorkshopTbl tr').map(function (i) {
                $("#Isdeleted_" + i).prop("checked", false);
            });
        }
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
        var pro = new Promise(function (res, err) {
            $(".jqContainer").toggleClass("hide_container");
            res(1);
        })       
        pro.then(
            function resposes()
            {
                setTimeout(() => $(".content").scrollTop(3000), 1);
                
            })        
    })
});

function GetFaciltyWorkShopData(getResult) { 
    var primaryId = $('#primaryID').val();
    $('#paginationfooterWorkorder').show();
    $('#primaryID').val(getResult.FacilityWorkshopId);
   // $('#FacilityworkService option[value="' + getResult.ServiceId + '"]').prop('selected', true);
   
    if (getResult.Year == 2018)
    {
        getResult.Year = 1;
    }
    else
    {
        getResult.Year = 2;
    }

    $('#FacilityworkYear option[value="' + getResult.Year + '"]').prop('selected', true);
    $("#FacilityworkYear").prop("disabled", "disabled");
    $("#FacilityworkFacilityType").prop("disabled", "disabled");
    $('#FacilityworkFacilityType option[value="' + getResult.FacilityTypeId + '"]').prop('selected', true);

    //$("#FacilityworkCategory").prop("disabled", "disabled");

    if (getResult.FacilityTypeId == 101) {
       // $('#FacilityworkCategory option[value="' + 0 + '"]').prop('selected', true);
        $('#FacilityworkCategory').val(getResult.CategoryId);
       // $('#FacilityworkCategory option[value="' + 0 + '"]').prop('selected', true);
    }

    if (getResult.FacilityTypeId == 102) {
        $("#FacilityworkCategory").prop("disabled", "disabled");
        $('#FacilityworkCategory').empty().append('<option value="">Select</option>');
        $.each(LOVlist.CategoryLovs, function (index, value) {
            if (value.LovId == 104 || value.LovId == 105 || value.LovId == 106)
                $('#FacilityworkCategory').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>').prop("disabled", false);
        });
        $('#FacilityworkCategory option[value="' + getResult.CategoryId + '"]').prop('selected', true);
    }
    if (getResult.FacilityTypeId == 103) {
        $("#FacilityworkCategory").prop("disabled", "disabled");
        $('#FacilityworkCategory').empty().append('<option value="">Select</option>');
        $.each(LOVlist.CategoryLovs, function (index, value) {
            if (value.LovId == 107 || value.LovId == 108 || value.LovId == 109 || value.LovId == 110)
                $('#FacilityworkCategory').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>').prop("disabled", false);
        });
        $('#FacilityworkCategory option[value="' + getResult.CategoryId + '"]').prop('selected', true);
    }

    $("#FacilityworkCategory").prop("disabled", "disabled");
    $('#FacilityworkCategory option[value="' + getResult.CategoryId + '"]').prop('selected', true);
    $("#FacilityWorkshopTbl").empty();

    $("#chk_FacWorkIsDelete").prop("checked", false);

    $.each(getResult.FacilityWorkshopGridData, function (index, value) {
        AddNewRowFacilityWorkshop();
        if (getResult.FacilityTypeId == 102) {
            FacTypeStorage(index, value);
        }
        else if (getResult.FacilityTypeId == 103) {
            FacTypeWorkshop(index, value)
        }

        if (getResult.CategoryId == 107) {
            CatLoaner(index, value);
        }
        else if (getResult.CategoryId == 108) {
            CatMachinery(index, value);
        }
        else if (getResult.CategoryId == 109) {
            CatTestEquip(index, value);
        }
        else if (getResult.CategoryId == 110) {
            CatTools(index, value);
        }
        else if (getResult.CategoryId == 104) {
            CatEquipRepair(index, value);
        }
        else {
            CatRest(index, value);
        }

        $("#HdnFacilityWorkshopDetId_" + index).val(getResult.FacilityWorkshopGridData[index].FacilityWorkshopDetId);
        $("#HdnFacilityWorkshopAssetId_" + index).val(getResult.FacilityWorkshopGridData[index].AssetId);
        $("#FWAssetNo_" + index).val(getResult.FacilityWorkshopGridData[index].AssetNo);
        $("#FWDescription_" + index).val(getResult.FacilityWorkshopGridData[index].Description);
        $("#FWManufacturer_" + index).val(getResult.FacilityWorkshopGridData[index].Manufacturer);
        $('#FWModel_' + index).val(getResult.FacilityWorkshopGridData[index].Model);
        $('#FWSerialNo_' + index).val(getResult.FacilityWorkshopGridData[index].SerialNo);
        var CalibDate = getResult.FacilityWorkshopGridData[index].IsCalibrationDueDateNull ? "" : DateFormatter(getResult.FacilityWorkshopGridData[index].CalibrationDueDate);
        $('#FWCalibDueDate_' + index).val(CalibDate);
        //$('#FWCalibDueDate_' + index).val(DateFormatter(getResult.FacilityWorkshopGridData[index].CalibrationDueDate));
        // $('#FWLocation_').empty().append('<option value="">Select</option>');
        $('#FWLocation_' + index + ' option[value="' + getResult.FacilityWorkshopGridData[index].LocationId + '"]').prop('selected', true);
        $("#FWQuantity_" + index).val(getResult.FacilityWorkshopGridData[index].Quantity);
        var sizearea = (getResult.FacilityWorkshopGridData[index].SizeArea == 0) ? null : (getResult.FacilityWorkshopGridData[index].SizeArea);
        $("#FWArea_" + index).val(sizearea);
        linkCliked1 = true;
        $(".content").scrollTop(0);
    });

    if (ActionType == "VIEW") {
        $("#FacilityWorkshopForm :input:not(:button)").prop("disabled", true);
        //$("#addnewrowbtn,#savebtn,#uploadbtn,#exportbtn,#addnewbtn").hide();
    }

    if (getResult.FacilityWorkshopGridData.length > 0) {

        //AssetId = result.AssetId;
        GridtotalRecords = getResult.FacilityWorkshopGridData[0].TotalRecords;
        TotalPages = getResult.FacilityWorkshopGridData[0].TotalPages;
        LastRecord = getResult.FacilityWorkshopGridData[0].LastRecord;
        FirstRecord = getResult.FacilityWorkshopGridData[0].FirstRecord;
        pageindex = getResult.FacilityWorkshopGridData[0].PageIndex;
    }



    // Added for pagination purpose to select html
    var mapIdproperty = ["IsDeleted-delchk_", "FacilityWorkshopDetId-HdnFacilityWorkshopDetId_", "AssetNo-FWAssetNo_", "AssetId-HdnFacilityWorkshopAssetId_", "Description-FWDescription_", "Manufacturer-FWManufacturer_", "Model-FWModel_", "SerialNo-FWSerialNo_", "CalibrationDueDate-FWCalibDueDate_-date", "LocationId-FWLocation_", "Quantity-FWQuantity_", "SizeArea-FWArea_", ];
    var inlineHTML = '<tr class="ng-scope" style=""><td width="5%" data-original-title="" title=""><div class="checkbox text-center"> <label for="checkboxes-0"> <input type="checkbox" value="false" id="Isdeleted_maxindexval"> </label></div></td> \
                        <td width="10%" style="text-align: center;" data-original-title="" title=""><div> <input type="text" id="FWAssetNo_maxindexval" class="form-control" placeholder="Please Select" onkeyup="FetchAsset(event,maxindexval)" onpaste="FetchAsset(event,maxindexval)" change="FetchAsset(event,maxindexval)" oninput="FetchAsset(FWAssetNo_maxindexval,maxindexval)" disabled></div> \
                                        <input type="hidden" id="HdnFacilityWorkshopAssetId_maxindexval"/> <div class="col-sm-12" id="AssetFetch_maxindexval"></div> </td> \
                        <td width="11%" style="text-align: center;" data-original-title="" title=""><div> <input type="text" id="FWDescription_maxindexval" class="form-control desc" required="required" ></div> \
                                        <input type="hidden" id="HdnFacilityWorkshopDetId_maxindexval"/> </td> \
                        <td width="12%" style="text-align: center;" data-original-title="" title=""><div> <input type="text" id="FWManufacturer_maxindexval" class="form-control desc" required="required"></div></td> \
                        <td width="9%" style="text-align: center;" data-original-title="" title=""><div> <input type="text" id="FWModel_maxindexval" class="form-control desc"></div></td> \
                        <td width="13%" style="text-align: center;" data-original-title="" title=""><div> <input type="text" id="FWSerialNo_maxindexval" pattern="^[a-zA-Z0-9\s/\/-]+$" class="form-control" pattern="^[a-zA-Z0-9\s-/]+$"maxlength="50"  ></div></td> \
                        <td width="10%" style="text-align: center;" data-original-title="" title=""><div> <input type="text" id="FWCalibDueDate_maxindexval" class="form-control datetime" ></div></td> \
                        <td width="10%" style="text-align: center;" data-original-title="" title=""><div> <select id="FWLocation_maxindexval" class="form-control"><option value="null">Select</option></select></div></td> \
                        <td width="10%" style="text-align: center;" data-original-title="" title=""><div> <input type="text" id="FWQuantity_maxindexval" style="text-align:right" class="form-control digOnly" maxlength="6" required></div></td> \
                        <td width="10%" style="text-align: center;" data-original-title="" title=""><div> <input type="text" id="FWArea_maxindexval" style="text-align:right" class="form-control decimalPointonly" pattern="^[0-9]+(\.[0-9]{1,2})?$"></div></td></tr>';
    var obj = { formId: "#FacilityWorkshopForm", IsView: ($('#ActionType').val() == "VIEW"), PageNumber: pageindex, flag: "FacilityWorkshop", mapIdproperty: mapIdproperty, htmltext: inlineHTML, GridtotalRecords: GridtotalRecords, ListName: "FacilityWorkshopGridData", tableid: '#FacilityWorkshopTbl', destionId: "#paginationfooterWorkorder", TotalPages: TotalPages, FirstRecord: FirstRecord, LastRecord: LastRecord, geturl: "/api/FacilityWorkshop/Get/" + primaryId, pageindex: pageindex, pagesize: pagesize };
    CreateFooterPagination(obj);

}

function FetchAsset(event, index) {

    if (index > 0) {
        $('#AssetFetch_' + index).css({
            'top': $('#FWAssetNo_' + index).offset().top - $('#FacilityWorkshopTable').offset().top + $('#FWAssetNo_' + index).innerHeight(),
            // 'width': $('#FWAssetNo_0').outerWidth()
        });
    }

    else {
        $('#AssetFetch_' + index).css({
          //  'width': $('#FWAssetNo_0').outerWidth()
        });
    }


    var ItemMst = {
        SearchColumn: 'FWAssetNo_' + index + '-AssetNo',//Id of Fetch field
        ResultColumns: ["AssetId" + "-Primary Key", 'AssetNo' + '-FWAssetNo_' + index],//Columns to be displayed
        AdditionalConditions: ["CategoryId-FacilityworkCategory", ],
        FieldsToBeFilled: ["HdnFacilityWorkshopAssetId_" + index + "-AssetId", 'FWAssetNo_' + index + '-AssetNo', 'FWDescription_' + index + '-AssetDescription', 'FWManufacturer_' + index + '-Manufacturer', 'FWModel_' + index + '-Model', 'FWSerialNo_' + index + '-SerialNumber']//id of element - the model property
    };
    DisplayFetchResult('AssetFetch_' + index, ItemMst, "/api/Fetch/FacilityWorkAssetNoFetch", "Ulfetch", event, 1);
}


var linkCliked1 = false;
function AddNewRowFacilityWorkshop() {
   
    var inputpar = {
        inlineHTML: ' <tr class="ng-scope" style=""><td width="5%" data-original-title="" title=""><div class="checkbox text-center"> <label for="checkboxes-0"> <input type="checkbox" value="false" id="Isdeleted_maxindexval" onchange="IsDeleteCheckAll(FacilityWorkshopTbl,chk_FacWorkIsDelete)" tabindex="0"> </label></div></td> \
                            <td width="10%" style="text-align: center;" data-original-title="" title=""><div> <input type="text" id="FWAssetNo_maxindexval" class="form-control fetch" maxlength="25" placeholder="Please Select" onkeyup="FetchAsset(event,maxindexval)" onpaste="FetchAsset(event,maxindexval)" change="FetchAsset(event,maxindexval)" oninput="FetchAsset(FWAssetNo_maxindexval,maxindexval)" disabled></div> \
                                            <input type="hidden" id="HdnFacilityWorkshopAssetId_maxindexval"/> <div class="col-sm-12" id="AssetFetch_maxindexval"></div> </td> \
                            <td width="11%" style="text-align: center;" data-original-title="" title=""><div> <input type="text" id="FWDescription_maxindexval" class="form-control desc" maxlength="100"  required ></div> \
                                            <input type="hidden" id="HdnFacilityWorkshopDetId_maxindexval"/> </td> \
                            <td width="12%" style="text-align: center;" data-original-title="" title=""><div> <input type="text" id="FWManufacturer_maxindexval" class="form-control desc" maxlength="100"></div></td> \
                            <td width="9%" style="text-align: center;" data-original-title="" title=""><div> <input type="text" id="FWModel_maxindexval" class="form-control desc" maxlength="100"></div></td> \
                            <td width="13%" style="text-align: center;" data-original-title="" title=""><div> <input type="text" id="FWSerialNo_maxindexval" class="form-control Serialno" disabled maxlength="50"></div></td> \
                            <td width="10%" style="text-align: center;" data-original-title="" title=""><div> <input type="text" id="FWCalibDueDate_maxindexval" maxlength="11" class="form-control datetimeNoFuture" disabled></div></td> \
                            <td width="10%" style="text-align: center;" data-original-title="" title=""><div> <select id="FWLocation_maxindexval" class="form-control"><option value="null">Select</option></select> </div></td> \
                            <td width="10%" style="text-align: center;" data-original-title="" title=""><div> <input type="text" id="FWQuantity_maxindexval" style="text-align:right" class="form-control digOnly" maxlength="6" disabled></div></td> \
                            <td width="10%" style="text-align: center;" data-original-title="" title=""><div> <input type="text" id="FWArea_maxindexval" style="text-align:right" class="form-control decimalPointonly" maxlength="7" pattern="^[0-9]+(\.[0-9]{1,2})?$" disabled></div></td></tr>',
        IdPlaceholderused: "maxindexval",
        TargetId: "#FacilityWorkshopTbl",
        TargetElement: ["tr"]
    }
    //var lastTdVal = true;
    //if ($('#FacilityWorkshopTbl tr').length > 0) {

    //    //var a = $('#FacilityWorkshopTbl tr:last-child').prop("required").length;
    //    var a = $('#FacilityWorkshopTbl tr:last-child [required]').length;

    //    lastTdVal = $('#FacilityWorkshopTbl tr:last-child [required]').val();
    //}

    //if (lastTdVal) {        
    //    $("#errorMsg").text("");
    //    AddNewRowToDataGrid(inputpar);
    //}
    //else {
    //    //$("#errorMsg").text("Please Fill First Row");
    //    bootbox.alert("Please enter values in existing row");
    //}
    $("#chk_FacWorkIsDelete").prop("checked",false);    
    var facilityType = $("#FacilityworkFacilityType").val();
    var category = $("#FacilityworkCategory").val();
    var rowCount = $('#FacilityWorkshopTbl tr:last').index();
    var astno = $('#FWAssetNo_' + rowCount).val();
    var desc = $('#FWDescription_' + rowCount).val();
    var manu = $('#FWManufacturer_' + rowCount).val();
    var mod = $('#FWModel_' + rowCount).val();
    var serno = $('#FWSerialNo_' + rowCount).val();
    var caldt = $('#FWCalibDueDate_' + rowCount).val();
    var qty = $('#FWQuantity_' + rowCount).val();
    var area = $('#FWArea_' + rowCount).val();



    if (rowCount < 0) {
        AddNewRowToDataGrid(inputpar);
     //   $('#FWDescription_' + rowCount).focus();
    }
    else if (rowCount >= 0) {
        if (category == 107) {
            if (astno == "" || serno == "" || qty == "") {
                bootbox.alert("Please enter values in existing row");
            }
            else {
                AddNewRowToDataGrid(inputpar);
                //var rowCountnew = $('#FacilityWorkshopTbl tr:last').index();
                //$('#FWAssetNo_' + rowCountnew).focus();
                if (!linkCliked1) {
                    $('#FacilityWorkshopTbl tr:last td:first input').focus();
                }
                else {
                    linkCliked1 = false;
                }
            }
        }
        else if (category == 109) {
            if (astno == "" || serno == "" || qty == "" || caldt == "") {
                bootbox.alert("Please enter values in existing row");
            }
            else {
                AddNewRowToDataGrid(inputpar);
                //var rowCountnew = $('#FacilityWorkshopTbl tr:last').index();
                //$('#FWAssetNo_' + rowCountnew).focus();
            }
        }
        else if (category == 108) {
            if (desc == "" || manu == "" || mod == "" || serno == "" || qty == "") {
                bootbox.alert("Please enter values in existing row");
            }
            else {
                AddNewRowToDataGrid(inputpar);
                var rowCountnew = $('#FacilityWorkshopTbl tr:last').index();
               // $('#FWDescription_' + rowCountnew).focus();
              //  $('#FacilityWorkshopTbl tr:last td:first input').focus();
            }
        }
        else if (category == 110) {
            if (desc == "" || manu == "" || mod == "" || serno == "" || qty == "" || caldt == "") {
                bootbox.alert("Please enter values in existing row");
            }
            else {
                AddNewRowToDataGrid(inputpar);
                //var rowCountnew = $('#FacilityWorkshopTbl tr:last').index();
                //$('#FWDescription_' + rowCountnew).focus();
            }
        }
        else if (category == 104) {
            if (desc == "" || serno == "" || qty == "" ) {
                bootbox.alert("Please enter values in existing row");
            }
            else {
                AddNewRowToDataGrid(inputpar);
                //var rowCountnew = $('#FacilityWorkshopTbl tr:last').index();
                //$('#FWDescription_' + rowCountnew).focus();
            }
        }
        else if (category == 105 || category == 106) {
            if (desc == "" ||  qty == "") {
                bootbox.alert("Please enter values in existing row");
            }
            else {
                AddNewRowToDataGrid(inputpar);
                //var rowCountnew = $('#FacilityWorkshopTbl tr:last').index();
                //$('#FWDescription_' + rowCountnew).focus();
            }
        }
        else if (facilityType == 101) {
            if (desc == "" || area == "") {
                bootbox.alert("Please enter values in existing row");
            }
            else {
                AddNewRowToDataGrid(inputpar);
                //var rowCountnew = $('#FacilityWorkshopTbl tr:last').index();
                //$('#FWDescription_' + rowCountnew).focus();
            }
        }


        else if ((rowCount >= 0) && (facilityType == "" || facilityType == 0 || facilityType == null || facilityType == "null")) {
            bootbox.alert("Please select Type of Facility");
        }

        else if ((rowCount >= 0) && (facilityType == 102 || facilityType == 103)) {
            if (category == "" || category == 0 || category == null || category == "null") {
                bootbox.alert("Please select Category");
            }
            
        }
        $('#FacilityWorkshopTbl tr:last td:first input').focus();
    }
   

    

    //AddNewRowToDataGrid(inputpar);
    var rowCount = $('#FacilityWorkshopTbl tr:last').index();
    var FaciTyp = $('#FacilityworkFacilityType').val();
    var cat = $('#FacilityworkCategory').val();

    if (FaciTyp == 101) {
        FacTypeResCen(rowCount, null);
    }
    else if (FaciTyp == 102) {
        FacTypeStorage(rowCount, null);
    }
    else if (FaciTyp == 103) {
        FacTypeWorkshop(rowCount, null);
       
    }

    if (cat == 107) {
        CatLoaner(rowCount, null);
    }
    else if (cat == 108) {
        CatMachinery(rowCount, null);
    }
    else if (cat == 109) {
        CatTestEquip(rowCount, null);
    }
    else if (cat == 110) {
        CatTools(rowCount, null);
    }
    else if (cat == 104) {
        CatEquipRepair(rowCount, null);
    }
    
    $('#FWLocation').empty().append('<option value="">Select</option>');
    $.each(window.LocationLovs, function (index, value) {
       // $('#FWLocation_' + rowCount).empty().append('<option value="">Select</option>');
        $('#FWLocation_' + rowCount).append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
    });

    formInputValidation("FacilityWorkshopForm");

    /* validation for Description field*/
    //$('.desc').keypress(function (e) {
    //    var regex = new RegExp("^[a-zA-Z0-9(),'\",.-\\s]+$");
    //    var str = String.fromCharCode(!e.charCode ? e.which : e.charCode);
    //    if (regex.test(str)) {
    //        return true;
    //    }
    //    e.preventDefault();
    //    return false;
    //});

    $('.desc').on('keypress', function (e) {
        var regex = new RegExp("^[a-zA-Z0-9(),'\",.-\\s]+$");
        var key = String.fromCharCode(!e.charCode ? e.which : e.charCode);
        var keystobepassedout = "ArrowLeftArrowRightDeleteBackspaceTab";
        if (keystobepassedout.indexOf(e.key) != -1) {
            return true;
        }
        if (!regex.test(key)) {
            e.preventDefault();
            return false;
        }

    });

    $('.desc').on('paste', function (e) {
        var $this = $(this);
        setTimeout(function () {
            $this.val($this.val().replace(/[~`!@#$%^&*_+|\\:{}\[\];?<>/\^]/g, ''));
        },5);
    });
    $('.Serialno').on('paste', function (e) {
        var $this = $(this);
        setTimeout(function () {
            $this.val($this.val().replace(/[~`!@#$%^&*_+|\\:{}\[\];?<>\^\"\']/g, ''));
        }, 5);
    });
    $('.Serialno').on('keypress', function (e) {
        var $this = $(this);
        setTimeout(function () {
            $this.val($this.val().replace(/[~`!@#$%^&*_+|\\:{}\[\];?<>\^\"\']/g, ''));
        }, 5);
    });

    $('.digOnly').keypress(function (e) {
        var regex = new RegExp(/[^a-zA-Z]/, '');
        var str = String.fromCharCode(!e.charCode ? e.which : e.charCode);
        if (regex.test(str)) {
            return true;
        }
        e.preventDefault();
        return false;
    });
    $('.digOnly').on('paste',function (e) {
        var $this = $(this);
        setTimeout(function () {
            $this.val($this.val().replace(/[a-zA-Z~`!@#$%^&*_+\-|\\:{}\[\];?<>\^\"\']/g, ''));
        }, 5);
    });



    //$('.decimalPointonly').keypress(function (e) {
    //    var regex = new RegExp("^[0-9.]*$");
    //    var str = String.fromCharCode(!e.charCode ? e.which : e.charCode);
    //    if (regex.test(str)) {
    //        return true;
    //    }
    //    e.preventDefault();
    //    return false;
    //});
    $('.decimalPointonly').each(function (index) {
        //$(this).attr('id', 'ParamMapMin_' + index);
        var vrate = document.getElementById(this.id);
        vrate.addEventListener('input', function (prev) {
            return function (evt) {
                if ((!/^\d{0,4}(?:\.\d{0,2})?$/.test(this.value))) {
                    this.value = prev;
                }
                else {
                    prev = this.value
                }
            };
        }(vrate.value), false);
    });
    //$('.decimalPointonly').on('paste', function (e) {
    //    var $this = $(this);
    //    setTimeout(function () {
    //        $this.val($this.val().replace(/[a-zA-Z0-9~`!@#$%^&*_+|\\:{}\[\];-?<>\^\"\']/g, ''));
    //    }, 5);
    //});

}


function CatLoaner(index, value) {
    $('#FWAssetNo_' + index).prop("disabled", false);
    $('#FWDescription_' + index).prop('required', false);
    $('#FWDescription_' + index).prop("disabled", true);
    $('#FWManufacturer_' + index).prop("disabled", true);
    $('#FWManufacturer_' + index).prop('required', false);
    $('#FWModel_' + index).prop("disabled", true);
    $('#FWModel_' + index).prop('required', false);
    $("#FWGriddesc").html("Description");
    $("#FWGridMAnufacturer").html("Manufacturer");
    $("#FWGridmodel").html("Model");
    $('#FWAssetNo_' + index).prop('required', true);
    $("#FWGridAssetNo").html("Asset No. <span class='red'>*</span>");
    $('#FWSerialNo_' + index).prop("disabled", true);
    $('#FWSerialNo_' + index).prop('required', false);
    $("#FWGridSerialno").html("Serial No.");
    $('#FWCalibDueDate_' + index).prop("disabled", true);
    $('#FWCalibDueDate_' + index).prop('required', false);
    $("#FWGridCalibration").html("Calibration Due Date");
    $('#FWQuantity_' + index).prop("disabled", false);
    $('#FWQuantity_' + index).prop('required', true);
    $("#FWGridQuantity").html("Quantity <span class='red'>*</span>");
    //ClearAll(index, value);

}
function CatMachinery(index, value) {
    $('#FWAssetNo_' + index).prop("disabled", true);
    $('#FWAssetNo_' +index).prop("required", false);
    $('#FWGridAssetNo').html("Asset No.");
    $('#FWSerialNo_' + index).prop("disabled", false);
    $('#FWSerialNo_' + index).prop('required', true);

    $("#FWGridSerialno").html("Serial No. <span class='red'>*</span>");
    $('#FWCalibDueDate_' + index).prop("disabled", true);
    $('#FWCalibDueDate_' + index).prop('required', false);
    $("#FWGridCalibration").html("Calibration Due Date");
    $("#FWGriddesc").html("Description <span class='red'>*</span>");
    $("#FWGridMAnufacturer").html("Manufacturer <span class='red'>*</span>");
    $("#FWGridmodel").html("Model <span class='red'>*</span>");
    $('#FWDescription_' + index).prop('required', true);
    $('#FWManufacturer_' + index).prop('required', true);
    $('#FWModel_' + index).prop('required', true);
    $('#FWDescription_' + index).prop("disabled", false);
    $('#FWManufacturer_' + index).prop("disabled", false);
    $('#FWModel_' + index).prop("disabled", false);
    $('#FWQuantity_' + index).prop("disabled", false);
    $('#FWQuantity_' + index).prop('required', true);
    $("#FWGridQuantity").html("Quantity <span class='red'>*</span>");
    //ClearAll(index, value);
}
function CatTestEquip(index, value) {
    $('#FWAssetNo_' + index).prop("disabled", false);
    $('#FWDescription_' + index).prop("disabled", true);
    $("#FWGriddesc").html("Description");
    $('#FWManufacturer_' + index).prop("disabled", true);
    $("#FWGridMAnufacturer").html("Manufacturer");
    $('#FWModel_' + index).prop("disabled", true);
    $("#FWGridmodel").html("Model");
    $('#FWDescription_' + index).prop('required', false);
    $('#FWManufacturer_' + index).prop('required', false);
    $('#FWModel_' + index).prop('required', false);

    $('#FWAssetNo_' + index).prop('required', true);
    $("#FWGridAssetNo").html("Asset No. <span class='red'>*</span>");
    $('#FWSerialNo_' + index).prop("disabled", true);
    $('#FWSerialNo_' + index).prop('required', false);
    $("#FWGridSerialno").html("Serial No.");

    $('#FWCalibDueDate_' + index).prop("disabled", false);
    $('#FWCalibDueDate_' + index).prop('required', true);
    $("#FWGridCalibration").html("Calibration Due Date <span class='red'>*</span>");
    $('#FWQuantity_' + index).prop("disabled", false);
    $('#FWQuantity_' + index).prop('required', true);
    $("#FWGridQuantity").html("Quantity <span class='red'>*</span>");
    //ClearAll(index, value);
}
function CatTools(index, value) {
    $('#FWAssetNo_' + index).prop("disabled", true);
    $('#FWAssetNo_' + index).prop("required", false);
    $('#FWGridAssetNo').html("Asset No.");

    $('#FWDescription_' +index).prop("disabled", false);
    $('#FWManufacturer_' + index).prop("disabled", false);
    $('#FWModel_' + index).prop("disabled", false);
    $('#FWCalibDueDate_' + index).prop("disabled", false);
    $('#FWCalibDueDate_' + index).prop('required', true);
    $('#FWDescription_' + index).prop('required', true);
    $('#FWManufacturer_' + index).prop('required', true);
    $('#FWModel_' + index).prop('required', true);
    $("#FWGridCalibration").html("Calibration Due Date");
    $('#FWSerialNo_' + index).prop("disabled", false);
    $('#FWSerialNo_' + index).prop('required', true);
    $("#FWGridSerialno").html("Serial No. <span class='red'>*</span>");

    $("#FWGriddesc").html("Description <span class='red'>*</span>");
    $("#FWGridMAnufacturer").html("Manufacturer <span class='red'>*</span>");
    $("#FWGridmodel").html("Model <span class='red'>*</span>");
    $('#FWQuantity_' + index).prop("disabled", false);
    $('#FWQuantity_' + index).prop('required', true);
    $("#FWGridQuantity").html("Quantity <span class='red'>*</span>");
    //ClearAll(index, value);
}
function CatEquipRepair(index, value) {
    $('#FWSerialNo_' + index).prop("disabled", false);
    $('#FWSerialNo_' + index).prop('required', true);
    $("#FWGridSerialno").html("Serial No. <span class='red'>*</span>");

    $('#FWCalibDueDate_' + index).prop("disabled", true);
    $('#FWCalibDueDate_' + index).prop('required', false);
    $("#FWGridCalibration").html("Calibration Due Date");
    $('#FWQuantity_' + index).prop("disabled", false);
    //ClearAll(index, value);
}

function CatRest(index, value) {
    $('#FWAssetNo_' + index).prop("disabled", true);
    $('#FWDescription_' + index).prop("disabled", false);
    $('#FWManufacturer_' + index).prop("disabled", false);
    $('#FWModel_' + index).prop("disabled", false);
    $('#FWAssetNo_' + index).prop('required', false);
    $("#FWGridAssetNo").html("Asset No.");
    $('#FWSerialNo_' + index).prop("disabled", true);
    $('#FWSerialNo_' + index).prop('required', false);
    $("#FWGridSerialno").html("Serial No.");

    $('#FWCalibDueDate_' + index).prop("disabled", true);
    $('#FWCalibDueDate_' + index).prop('required', false);
    $("#FWGridCalibration").html("Calibration Due Date");
    //ClearAll(index, value);
}

function FacTypeResCen(index, value) {
    $('#FWManufacturer_' + index).prop('required', false);
    $("#FWGridMAnufacturer").html("Manufacturer");
    $('#FWModel_' + index).prop('required', false);
    $("#FWGridmodel").html("Model");

    $('#FWSerialNo_' + index).prop('required', false);
    $('#FWSerialNo_' + index).prop("disabled", true);
    $("#FWGridSerialno").html("Serial No.");
    //$('#FWQuantity_' + index).val('');
    $('#FWQuantity_' + index).prop("disabled", true);
    $('#FWQuantity_' + index).prop('required', false);
    $("#FWGridQuantity").html("Quantity");

    $('#FWArea_' + index).prop("disabled", false);
    $('#FWArea_' + index).prop('required', true);
    $("#FWGridSize").html("Size/Area (Sq m)  <span class='red'>*</span>");
    $('#FWAssetNo_' + index).prop("disabled", true);
    $('#FWAssetNo_' + index).prop("required", false);
    $('#FWGridAssetNo').html("Asset No.");
    $('#FWDescription_' + index).prop("disabled", false);
    $('#FWCalibDueDate_' + index).prop("disabled", true);
    $('#FWCalibDueDate_' + index).prop('required', false);
    $("#FWGridCalibration").html("Calibration Due Date");
    $("#FWGriddesc").html("Description <span class='red'>*</span>");
    //ClearAll(index, value);

    }

function FacTypeStorage(index, value) {
    $('#FWManufacturer_' + index).prop('required', false);
    $("#FWGridMAnufacturer").html("Manufacturer");
    $('#FWModel_' + index).prop('required', false);
    $("#FWGridmodel").html("Model");
    //$('#FWSerialNo_' + index).val('');
    $('#FWSerialNo_' + index).prop('required', false);
    $('#FWSerialNo_' + index).prop("disabled", true);
    $("#FWGridSerialno").html("Serial No.");
    $('#FWQuantity_' + index).prop("disabled", false);
    $('#FWQuantity_' + index).prop('required', true);
    $("#FWGridQuantity").html("Quantity <span class='red'>*</span>");
    //$('#FWArea_' + index).val('');
    $('#FWArea_' + index).prop("disabled", true);
    $('#FWArea_' + index).prop('required', false);
    $("#FWGridSize").html("Size/Area (Sq m)");
    //ClearAll(index, value);
}

function FacTypeWorkshop(index, value) {
    //$('#FWManufacturer_' + index).prop('required', true);
    //$("#FWGridMAnufacturer").html("Manufacturer <span class='red'>*</span>");
    //$('#FWModel_' + index).prop('required', true);
    //$("#FWGridmodel").html("Model <span class='red'>*</span>");
    $('#FWSerialNo_' + index).prop("disabled", false);
    //$('#FWSerialNo_' + index).prop('required', true);
    //$("#FWGridSerialno").html("Serial No. <span class='red'>*</span>");
    //$('#FWQuantity_' + index).val('');
    $('#FWQuantity_' + index).prop("disabled", false);
    //$('#FWQuantity_' + index).prop('required', true);
    //$("#FWGridQuantity").html("Quantity <span class='red'>*</span>");
    //$('#FWArea_' + index).val('');
    $('#FWArea_' + index).prop("disabled", true);
    $('#FWArea_' + index).prop('required', false);
    $("#FWGridSize").html("Size/Area (Sq m)");
    //ClearAll(index, value);
}

function ClearAll(index, value) {
    $('#FWDescription_' + index).val('');
    $('#FWManufacturer_' +index).val('');
    $('#FWModel_' +index).val('');
    $('#FWSerialNo_' +index).val('');
    $('#FWCalibDueDate_' +index).val('');
    $('#FWQuantity_' +index).val('');
    $('#FWArea_' +index).val('');
}


function LinkClicked(id) {
    linkCliked1 = true;
    $(".content").scrollTop(0);
    $("#FacilityWorkshopForm :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    var action = "";
    $('#primaryID').val(id);
    var hasEditPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Edit'");
    var hasViewPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='View'");
    var hasDeletePermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Delete'");

    if (hasEditPermission ) {
        action = "Edit"

    }
    else if (!hasEditPermission ) {
        action = "View"
    }
    if (action == "Edit" && hasDeletePermission) {
        $('#btnDelete').show();
    }

    if (action == 'View') {
        $("#FacilityWorkshopForm :input:not(:button)").prop("disabled", true);
    } else {
        $('#btnEdit').show();
        $('#btnSave').hide();
        //$('#btnSaveandAddNew').hide();
        $('#btnNextScreenSave').show();
    }
    $('#spnActionType').text(action);

    //******************************************** Getby ID ****************************************************
    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        $.get("/api/FacilityWorkshop/Get/" + primaryId + "/" + pagesize + "/" + pageindex)
          .done(function (result) {
              var getResult = JSON.parse(result);

              GetFaciltyWorkShopData(getResult)

              $('#myPleaseWait').modal('hide');

          })
         .fail(function (response) {
             $('#myPleaseWait').modal('hide');
             $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
             $('#errorMsg').css('visibility', 'visible');
         });
    }
    else {
        $('#myPleaseWait').modal('hide');
    }
    $(".content").scrollTop(1);
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
            $.get("/api/FacilityWorkshop/Delete/" + ID)
             .done(function (result) {
                 filterGrid();
                 $(".content").scrollTop(0);
                 showMessage('Facility & Workshop', CURD_MESSAGE_STATUS.DS);
                 $('#myPleaseWait').modal('hide');
                 EmptyFields();
             })
             .fail(function () {
                 showMessage('Facility & Workshop', CURD_MESSAGE_STATUS.DF);
                 $('#myPleaseWait').modal('hide');
             });
        }

    });
}

function EmptyFields() {
    $(".content").scrollTop(0);
    $('input[type="text"], textarea').val('');
    $('#FacilityworkFacilityType').val("null");
    $('#FacilityworkCategory').val("").prop('disabled', true);
    $('#FacilityworkFacilityType').prop('disabled', false);
    $('#FacilityworkYear').prop('disabled', false);    
    $('#btnEdit').hide();
    $('#btnSave').show();
    $('#btnDelete').hide();
    $('#btnNextScreenSave').hide();
    $('#spnActionType').text('Add');
    $("#primaryID").val('');
    $("#grid").trigger('reloadGrid');
    $("#FacilityWorkshopForm :input:not(:button)").parent().removeClass('has-error');
    $('#FacilityworkYear option[value="' + 1 + '"]').prop('selected', true);
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('#FacilityWorkshopTbl').empty();
    AddNewRowFacilityWorkshop();
    $('#paginationfooterWorkorder').hide();
    $("#chk_FacWorkIsDelete").prop("checked", false);
    $('#FacilityworkYear').val(2);
    //chk_FacWorkIsDelete
}

