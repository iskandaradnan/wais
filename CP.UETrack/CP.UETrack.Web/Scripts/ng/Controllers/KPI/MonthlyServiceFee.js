

$(document).ready(function () {
    $('#myPleaseWait').modal('show');
    var ActionType = $('#ActionType').val();
    formInputValidation("MonthlyServiceFeeForm");
   
 //*********************************** Load DropDown ***************************************

        $.get("/api/MonthlyServiceFee/Load")
       .done(function (result) {
           var loadResult = JSON.parse(result);

           //var facilityval = $('#selFacilityLayout option:selected').text();
           //$('#monthlyfacility').val(facilityval);

           $.each(loadResult.Yearss, function (index, value) {
               $('#monthlyyear').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
           });
           $('#monthlyyear').val(loadResult.CurrentYear);
           var getMonthlyYear=$('#monthlyyear').val();

           //$.each(loadResult.MonthlyVersionTypedata, function (index, value) {
           //    $('#revisionversion').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
           //});            
           //$.each(loadResult.Yearss, function (index, value) {
           //    $('#revisionyear').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
           //});             
           //$.each(loadResult.MonthListTypedata, function (index, value) {
           //    AddNewRowMonthlyServiceFee();
           //    $('#month_' + index).val(value.FieldValue).attr('data-LovId', value.LovId);
           //});

           getByYear(getMonthlyYear);                 

       })
       .fail(function (response) {
           $('#myPleaseWait').modal('hide');
           $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
           $('#errorMsg').css('visibility', 'visible');
       });


 ////****************************** MonthlyServiceFee GetById *********************************

        $('#monthlyyear').on('change', function () {
            var year = $('#monthlyyear').val();
           
            if (year != "0" && year != "null" ) {
                getByYear(year);
            }            

        });

 //       function getById(primaryId) {
 //           $.get("/api/MonthlyServiceFee/get/" + primaryId)
 //                   .done(function (result) {
 //                       var result = JSON.parse(result);

 //                       $('#primaryID').val(result.MonthlyFeeId);
 //                       $('#Timestamp').val(result.Timestamp);
 //                       $('#monthlyfacility').val(result.FacilityName);
 //                       $('#monthlyyear option[value="' + result.Year + '"]').prop('selected', true);
 //                       $('#monthlyyear').prop("disabled", "disabled");

 //                       //$("#MonthlyServiceFeeTbl").empty();
 //                       if (result != null && result.MonthlyServiceFeeListData != null && result.MonthlyServiceFeeListData.length > 0) {
 //                           BindGridData(result);
 //                       }

 //                       $('#myPleaseWait').modal('hide');
 //                   })
 //                   .fail(function () {
 //                       $('#myPleaseWait').modal('hide');
 //                       $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
 //                       $('#errorMsg').css('visibility', 'visible');
 //                   });
 //       }


 //******************************* MonthlyServiceFee Save ***********************************

        //$("#btnServiceFeeSave, #btnServiceFeeEdit,#btnSaveandAddNew").click(function () {
        //    $('#btnServiceFeeSave').attr('disabled', true);
        //    $('#btnServiceFeeEdit').attr('disabled', true);
        //    $('#myPleaseWait').modal('show');
        //    var CurrentbtnID = $(this).attr("Id");
        //    $("div.errormsgcenter").text("");
        //    $('#errorMsg').css('visibility', 'hidden');

        //    var isFormValid = formInputValidation("MonthlyServiceFeeForm", 'save');
        //    if (!isFormValid) {                
        //        $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        //        $('#errorMsg').css('visibility', 'visible');
        //        $('#myPleaseWait').modal('hide');
        //        $('#btnServiceFeeSave').attr('disabled', false);
        //        $('#btnServiceFeeEdit').attr('disabled', false);
        //        return false;
        //    }           
        //    var _index;
        //    $('#MonthlyServiceFeeTbl tr').each(function () {
        //        _index = $(this).index();
        //    });          

        //    var result = [];
        //    var primaryId = $('#primaryID').val();
        //    for (var i = 0; i <= _index; i++) {

        //        var _MonthlyServiceFeeWO = {

        //            MonthlyFeeId: primaryId,
        //            MonthlyFeeDetId: $('#hdnMonthlyFeeDetId_' + i).val(),
        //            Month: $('#month_' + i).attr('data-LovId'),
        //            BemsMSF: $('#bemsmsf_' + i).val(),                    
        //            BemsCF: $('#bemsamendment_' + i).val(),
        //            TotalFee: $('#TotalFee_' + i).val(),
        //            ItemId: 1,
        //        }
     
        //        result.push(_MonthlyServiceFeeWO);
        //    }
        //    var ckfalse=0;
        //    for (var j = 0; j <= _index; j++) {
        //        if (result[j].BemsMSF == "0" || result[j].BemsMSF == "00" || result[j].BemsMSF == "000" || result[j].BemsMSF == "0000" || result[j].BemsMSF == "00000" || result[j].BemsMSF == "000000" || result[j].BemsMSF == "0000000" || result[j].BemsMSF == "00000000") {
        //            $("div.errormsgcenter").text("Monthly service fee must be greater than zero");
        //            $('#bemsmsf_' + j).parent().addClass('has-error');
        //            $('#errorMsg').css('visibility', 'visible');
        //            ckfalse +=  1;
        //            $('#myPleaseWait').modal('hide');
        //            $('#btnServiceFeeSave').attr('disabled', false);
        //            $('#btnServiceFeeEdit').attr('disabled', false);
            
        //        }
        //    }
        //    if (ckfalse > 0) {
        //        return false;
        //    }

        //    var Timestamp = $("#Timestamp").val();            
        //    if (primaryId != null) {
        //        MonthlyFeeId = primaryId;
        //        Timestamp = Timestamp;
        //    }
        //    else {
        //        MonthlyFeeId = 0;
        //        Timestamp = "";
        //    }

        //    var obj = {
        //        MonthlyFeeId: MonthlyFeeId,
        //        Timestamp: Timestamp,
        //        FacilityId: $('#monthlyfacility').val(),
        //        Year: $('#monthlyyear').val(),
        //        //VersionNo:$('#hdnVersionno').val(),

        //        MonthlyServiceFeeListData: result
        //    }
            
            
            
        //    var jqxhr = $.post("/api/MonthlyServiceFee/Save", obj, function (response) {
        //        var result = JSON.parse(response);                
        //        $("#primaryID").val(result.MonthlyFeeId);
        //        $("#Timestamp").val(result.Timestamp);

        //        $('#revisionyear').val(result.Year).prop("disabled", "disabled");
        //        var RevisionYear = $('#revisionyear').val();
        //        getByVersion(RevisionYear);
                
        //        if (result != null && result.MonthlyServiceFeeListData != null && result.MonthlyServiceFeeListData.length > 0) {
        //            BindGridData(result);
        //        }
        //        $("#grid").trigger('reloadGrid');
        //        if (result.MonthlyFeeId != 0) {
                   
        //            $('#btnNextScreenSave').show();
        //            $('#btnServiceFeeEdit').show();
        //            $('#btnServiceFeeSave').hide();
        //        }
        //        showMessage('Monthly Service Fee', CURD_MESSAGE_STATUS.SS);
        //        //$("#top-notifications").modal('show');
        //        //setTimeout(function () {
        //        //    $("#top-notifications").modal('hide');
        //        //}, 5000);

        //        $('#btnServiceFeeSave').attr('disabled', false);
        //        $('#btnServiceFeeEdit').attr('disabled', false);
        //        $('#myPleaseWait').modal('hide');
        //        if (CurrentbtnID == "btnSaveandAddNew") {
        //            EmptyFields();
        //        }
        //    },
        //   "json")
        //    .fail(function (response) {
        //        var errorMessage = "";
        //        if (response.status == 400) {
        //            errorMessage = response.responseJSON;
        //        }
        //        else {
        //            errorMessage = Messages.COMMON_FAILURE_MESSAGE;
        //        }
        //        $("div.errormsgcenter").text(errorMessage).css('visibility', 'visible');
        //        $('#errorMsg').css('visibility', 'visible');

        //        $('#btnServiceFeeEdit').attr('disabled', false);
        //        $('#btnServiceFeeSave').attr('disabled', false);
        //        $('#myPleaseWait').modal('hide');
        //    });
        //});


 //********************************* NewPage & Back *****************************************

       
        //$("#RbtnCancel").click(function () {
        //    window.location.href = "/kpi/MonthlyServiceFee";
        //});
        //$("#btnAddNew").click(function () {
        //    window.location.href = window.location.href;
        //});
        //$("#jQGridCollapse1").click(function () {
        //    // $(".jqContainer").toggleClass("hide_container");
        //    var pro = new Promise(function (res, err) {
        //        $(".jqContainer").toggleClass("hide_container");
        //        res(1);
        //    })
        //    pro.then(
        //        function resposes() {
        //            setTimeout(() => $(".content").scrollTop(3000), 1);
        //        })
        //})
});

//****************************** MonthlyServiceFee AddNewRow ********************************


function AddNewRowMonthlyServiceFee() {

    var inputpar = {
        inlineHTML: ' <tr> <td width="40%" style="text-align: center;" title=""> <div> <input type="text" class="form-control" data-LovId="LovId_maxindexval" id="month_maxindexval" disabled readonly="readonly"> <input type="hidden" id="hdnMonthlyFeeDetId_maxindexval"> </div></td><td width="15%" style="text-align: center;" title=""> <div> <input type="text" class="text-right form-control" required id="bemsmsf_maxindexval" disabled readonly> </div></td><td width="15%" style="text-align: center;" title=""> <div> <input type="text" class="text-right form-control" id="bemsamendment_maxindexval" disabled readonly> </div></td><td width="15%" style="text-align: center;" title=""> <div> <input type="text" class="text-right form-control" id="DeductionMSF_maxindexval" disabled readonly> </div></td><td width="15%" style="text-align: center;" title=""> <div> <input type="text" class="text-right form-control" id="TotalFee_maxindexval" disabled readonly> </div></td></tr> ',

        IdPlaceholderused: "maxindexval",
        TargetId: "#MonthlyServiceFeeTbl",
        TargetElement: ["tr"]

    }
    AddNewRowToDataGrid(inputpar);
    formInputValidation("MonthlyServiceFeeForm");

    //$('.digOnly').keypress(function (e) {
    //    var regex = new RegExp("^[0-9]*$");
    //    var str = String.fromCharCode(!e.charCode ? e.which : e.charCode);
    //    if (regex.test(str)) {
    //        return true;
    //    }
    //    e.preventDefault();
    //    return false;
    //});
    //$('.digOnly').on('paste', function (e) {
    //    var $this = $(this);
    //    setTimeout(function () {
    //        $this.val($this.val().replace(/[a-zA-Z0-9~`!@#$%^&*_+|\\:{}\[\];-?<>\^\"\']/g, ''));
    //    }, 5);
    //});
    
    //$('.decimalPnt').keypress(function (e) {
    //    var regex1 = new RegExp("^[0-9]*\.[0-9][0-9]$");   //   ^[0-9]*\.[0-9][0-9]$
    //    var str1 = String.fromCharCode(!e.charCode ? e.which : e.charCode);
    //    if (regex1.test(str1)) {
    //        return true;
    //    }
    //    e.preventDefault();
    //    return false;
    //});

    //$('.decimalPointValidation').each(function (index) {
    //    $(this).attr('id', 'bemsmsf_' + index);
    //    var vrate = document.getElementById(this.id);
    //    vrate.addEventListener('input', function (prev) {
    //        return function (evt) {
    //            if (!/^\d{0,8}(?:\.\d{0,2})?$/.test(this.value)) {
    //                this.value = prev;
    //            }
    //            else {
    //                prev = this.value;
    //            }
    //        };
    //    }(vrate.value), false);
    //});

    //var MonthList = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];    
    //for (var i = 0; i <= MonthList.length-1; i++) {         
    //    AddNewRowToDataGrid(inputpar);
    //    $('#month_' + i).val(MonthList[i]);
    //}
  
}





//****************************** 2nd Tab RevisionTab GetByRevisionId *********************************

//$('#RevisionHistoryTab').click(function () {        
//    var Ryear = $('#monthlyyear').val();    
//    $('#revisionyear').val(Ryear).prop("disabled", "disabled");
//    getByVersion(Ryear);

//    $('#revisionversion').on('change', function () {
//        var Ryear = $('#revisionyear').val();
//        var Rversion = $('#revisionversion').val();
//        if (Ryear != "0" && Rversion != "0" && Ryear != "null" && Rversion != "null")
//        {
//            getByRevisionId(Rversion, Ryear);
//        }
//        else {
//            $("#RevisionTbl").empty();
//            PushEmptyMessage();
//            $('#myPleaseWait').modal('hide');
//            }   
        
//    });

//function getByRevisionId(Rversion, Ryear) {
//    $.get("/api/MonthlyServiceFee/GetRevision/" + Rversion + "/" + Ryear)
//                .done(function (result) {
//                    var result = JSON.parse(result);
//                    var MonthlyServiceList = result.MonthlyServiceFeeListData;
                  
//                        $('#primaryID').val(result.MonthlyFeeId);
//                        $('#Timestamp').val(result.Timestamp);
//                        //$('#monthlyfacility').val(result.FacilityName);                    
//                        $('#revisionyear option[value="' + result.Year + '"]').prop('selected', true);
//                        //$('#revisionyear').prop("disabled", "disabled");
//                        $('#revisionversion option[value="' + result.VersionNo + '"]').prop('selected', true);
//                        //$('#revisionversion').prop("disabled", "disabled");

//                        $("#RevisionTbl").empty();
//                        $.each(result.MonthlyServiceFeeListData, function (index, value) {
//                            AddNewRowRevisionFee();
//                            $("#hdnRevisionDetId_" + index).val(result.MonthlyServiceFeeListData[index].MonthlyFeeDetId);
//                            $("#Rmonth_" + index).val(result.MonthlyServiceFeeListData[index].MonthlyFeeMonth).prop("disabled", "disabled");
//                            $("#Rbemsmsf_" + index).val(result.MonthlyServiceFeeListData[index].BemsMSF).prop("disabled", "disabled");
//                            $("#Rbemsamendment_" + index).val(result.MonthlyServiceFeeListData[index].BemsCF).prop("disabled", "disabled");
//                            $("#RTotalFee_" + index).val(result.MonthlyServiceFeeListData[index].TotalFee).prop("disabled", "disabled");

//                        });                                   

//                    $('#myPleaseWait').modal('hide');
//                })
//                .fail(function () {
//                    $('#myPleaseWait').modal('hide');
//                    $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
//                    $('#errorMsg').css('visibility', 'visible');
//                });
//    }

//});
  
//function getByVersion(Year) {
//    $.get("/api/MonthlyServiceFee/GetVersion/" + Year)
//            .done(function (result) {
//                var loadResult = JSON.parse(result);
//                var emptyrow = loadResult.VersionListData;
//                $("#RevisionTbl").empty();
//                $('#revisionversion').empty();
//                $('#revisionversion').append('<option value="null">Select</option>');
//                var getversion=$('#revisionversion').val();

//                if (getversion == "null") {
//                    PushEmptyMessage();
//                }

//                $.each(loadResult.VersionListData, function (index, value) {
//                    $('#revisionversion').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
//                });

//                $('#myPleaseWait').modal('hide');
//            })
//            .fail(function () {
//                $('#myPleaseWait').modal('hide');
//                $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
//                $('#errorMsg').css('visibility', 'visible');
//            });
//}

//******************************************* Validation **************************************************

//function TotalfeeCalc() {
//    var _index;
//    $('#MonthlyServiceFeeTbl tr').each(function () {
//        _index = $(this).index();
//    });
//    for (var i = 0; i <= _index; i++) {
//        var msf = $('#bemsmsf_' + i).val();
//        var amendment = $('#bemsamendment_' + i).val();
//        var totaldet = $('#TotalFee_' + i).val();
        
//        if (amendment == "" || amendment==null)
//        {
//            amendment = 0;                
//        }
//        else if (msf == "" || msf == null) {
//            msf = 0;
//        }
//        var totalfee = document.getElementById('#TotalFee_' + i);
//        totalfee = parseFloat(msf) + parseFloat(amendment);
//        if (!isNaN(totalfee)) {
//            $('#TotalFee_' + i).val(totalfee);
//        }
//        else if ((msf == "" || msf == null || msf == 0) && (amendment == "" || amendment == null || amendment == 0)) {
//            totaldet = 0;
//            $('#TotalFee_' + i).val(totaldet);
//        }        
//        }
//}

//function MSFfeeCalc() {
//    var _index1;
//    $('#MonthlyServiceFeeTbl tr').each(function () {
//        _index1 = $(this).index();
//    });
//    for (var i = 0; i <= _index1; i++) {
//        var msf = $('#bemsmsf_' + i).val();
//        msf = parseInt(msf)
//        if (msf == 0) {
//            $("div.errormsgcenter").text("Monthly service fee must be greater than zero");
//            // $('#bemsmsf_' + i).parent().addClass('has-error');
//            $('#errorMsg').css('visibility', 'visible');
//            $('#myPleaseWait').modal('hide');
//            $('#btnServiceFeeSave').attr('disabled', false);
//            $('#btnServiceFeeEdit').attr('disabled', false);
//            return false;
//        }
//    }
//}




//******************************* 2nd Tab Revision AddNewRow *********************************

//function AddNewRowRevisionFee() {

//    var inputpar = {
//        inlineHTML: '<tr> <td width="40%" style="text-align: center;" title="Month"> <div> <input type="text" class="form-control" data-LovId="LovId_maxindexval" id="Rmonth_maxindexval" readonly="readonly"> <input type="hidden" id="hdnRevisionDetId_maxindexval"> </div></td><td width="20%" style="text-align: center;" title="MonthlyServiceFee"> <div> <input type="text" class="text-right form-control" id="Rbemsmsf_maxindexval" readonly> </div></td><td width="20%" style="text-align: center;" title=""> <div> <input type="text" class="text-right form-control" id="Rbemsamendment_maxindexval" readonly> </div></td><td width="20%" style="text-align: center;" title="TotalFee"> <div> <input type="text" class="text-right form-control" id="RTotalFee_maxindexval" readonly> </div></td></tr> ',

//        IdPlaceholderused: "maxindexval",
//        TargetId: "#RevisionTbl",
//        TargetElement: ["tr"]

//    }
//    AddNewRowToDataGrid(inputpar);
//}




//function LinkClicked(id) {
//    $(".content").scrollTop(1);
//    $('.nav-tabs a:first').tab('show')
//    $("#MonthlyServiceFeeForm :input:not(:button)").parent().removeClass('has-error');
//    $("div.errormsgcenter").text("");
//    $('#errorMsg').css('visibility', 'hidden');
//    var action = "";
//    $('#primaryID').val(id);
//    var hasEditPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Edit'");
//    var hasViewPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='View'");
//    var hasDeletePermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Delete'");

//    if (hasEditPermission && hasViewPermission) {
//        action = "Edit"

//    }
//    else if (!hasEditPermission && hasViewPermission) {
//        action = "View"
//    }
//    if (action == "Edit" && hasDeletePermission) {
//        $('#btnDelete').show();
//    }

//    if (action == 'View') {
//        $("#MonthlyServiceFeeForm :input:not(:button)").prop("disabled", true);
//    } else {
//        $('#btnServiceFeeEdit').show();
//        $('#btnServiceFeeSave').hide();
//        //$('#btnSaveandAddNew').hide();
//        $('#btnNextScreenSave').show();
//    }
//    $('#spnActionType').text(action);

//    var primaryId = $('#primaryID').val();
//    if (primaryId != null && primaryId != "0") {
//        getById(primaryId);

//    }
//    else {
//        $('#myPleaseWait').modal('hide');

//    }

//}

//$("#btnDelete").click(function () {
//    var ID = $('#primaryID').val();
//    confirmDelete(ID);

//});
//function confirmDelete(ID) {
//    var message = Messages.SEARCH_GRID_DELETE_CONFIRMATION;
//    var pageId = $('.ui-pg-input').val();
//    bootbox.confirm(message, function (result) {
//        if (result) {
//            $.get("/api/MonthlyServiceFee/Delete/" + ID)
//             .done(function (result) {
//                 filterGrid();
//                 showMessage('MonthlyServiceFee', CURD_MESSAGE_STATUS.DS);
//                 $('#myPleaseWait').modal('hide');
//                 EmptyFields();
//             })
//             .fail(function () {
//                 showMessage('MonthlyServiceFee', CURD_MESSAGE_STATUS.DF);
//                 $('#myPleaseWait').modal('hide');
//             });
//        }

//    });
//}
//function EmptyFields() {
//    $('input[type="text"], textarea').val('');
//    $('#LevelFacility').val("null");
//    $('#LevelBlock').val("null");
//    $('#monthlyyear').prop("disabled", false);
//    $('#LevelCode').prop('disabled', false);
//    $('#btnServiceFeeEdit').hide();
//    $('#btnServiceFeeSave').show();
//    $('#btnDelete').hide();
//    $('#btnNextScreenSave').hide();
//    $('#spnActionType').text('Add');
//    $("#primaryID").val('');
//    $("#grid").trigger('reloadGrid');
//    $("#MonthlyServiceFeeForm :input:not(:button)").parent().removeClass('has-error');
//    $("div.errormsgcenter").text("");
//    $('#errorMsg').css('visibility', 'hidden');
//    $('#MonthlyServiceFeeTbl').empty();
//    $.get("/api/MonthlyServiceFee/Load")
//      .done(function (result) {
//          var loadResult = JSON.parse(result);
//          var facilityval = $('#selFacilityLayout option:selected').text();
//          $('#monthlyfacility').val(facilityval);

//          //$.each(loadResult.MonthlyVersionTypedata, function (index, value) {
//          //    $('#revisionversion').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
//          //});

//          //$.each(loadResult.Yearss, function (index, value) {
//          //    $('#revisionyear').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
//          //});
//          $.each(loadResult.MonthListTypedata, function (index, value) {
//              AddNewRowMonthlyServiceFee();
//              $('#month_' + index).val(value.FieldValue).attr('data-LovId', value.LovId);
//          });

//         // TotalfeeCalc();
//      })
//      .fail(function () {
//          $('#myPleaseWait').modal('hide');
//          $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
//          $('#errorMsg').css('visibility', 'visible');
//      });
//}
//****************************** MonthlyServiceFee GetById *********************************


//function getById(primaryId) {
//    $.get("/api/MonthlyServiceFee/get/" + primaryId)
//            .done(function (result) {
//                var result = JSON.parse(result);

//                $('#primaryID').val(result.MonthlyFeeId);
//                $('#Timestamp').val(result.Timestamp);
//                $('#monthlyfacility').val(result.FacilityName);
//                $('#monthlyyear option[value="' + result.Year + '"]').prop('selected', true);
//                $('#monthlyyear').prop("disabled", "disabled");

//                //$("#MonthlyServiceFeeTbl").empty();
//                if (result != null && result.MonthlyServiceFeeListData != null && result.MonthlyServiceFeeListData.length > 0) {
//                    BindGridData(result);
//                }

//                $('#myPleaseWait').modal('hide');
//            })
//            .fail(function () {
//                $('#myPleaseWait').modal('hide');
//                $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
//                $('#errorMsg').css('visibility', 'visible');
//            });
//}


//***************** New Changes


function getByYear(Year) {
    $.get("/api/MonthlyServiceFee/get/" + Year)
            .done(function (result) {
                var result = JSON.parse(result);

                $('#primaryID').val(result.MonthlyFeeId);
                $('#Timestamp').val(result.Timestamp);               
                $('#monthlyyear option[value="' + result.Year + '"]').prop('selected', true);
                  
                //var facilityval = $('#selFacilityLayout option:selected').text();
                //$('#monthlyfacility').val(facilityval);
                
                if (result.MonthlyServiceFeeListData != null && result.MonthlyServiceFeeListData.length > 0) {                  
                    BindGridData(result);
                }
                else {
                    $("#MonthlyServiceFeeTbl").empty();
                    PushEmptyMessage();
                }

                $('#myPleaseWait').modal('hide');
            })
            .fail(function (response) {
                $('#myPleaseWait').modal('hide');
                $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
                $('#errorMsg').css('visibility', 'visible');
            });
}

function BindGridData(result) {     
    
    $("#MonthlyServiceFeeTbl").empty();
    $.each(result.MonthlyServiceFeeListData, function (index, value) {
        AddNewRowMonthlyServiceFee();
        $("#hdnMonthlyFeeDetId_" + index).val(result.MonthlyServiceFeeListData[index].MonthlyFeeDetId);
        $("#month_" + index).val(result.MonthlyServiceFeeListData[index].MonthlyFeeMonth).attr('title', result.MonthlyServiceFeeListData[index].MonthlyFeeMonth);
        $("#bemsmsf_" + index).val(addCommas(result.MonthlyServiceFeeListData[index].BemsMSF)).attr('title', result.MonthlyServiceFeeListData[index].BemsMSF);
        $("#bemsamendment_" + index).val(addCommas(result.MonthlyServiceFeeListData[index].BemsCF)).attr('title', result.MonthlyServiceFeeListData[index].BemsCF);
        $("#DeductionMSF_" + index).val(addCommas(result.MonthlyServiceFeeListData[index].DeductionMSF)).attr('title', result.MonthlyServiceFeeListData[index].DeductionMSF);
        $("#TotalFee_" + index).val(addCommas(result.MonthlyServiceFeeListData[index].TotalFee)).attr('title', result.MonthlyServiceFeeListData[index].TotalFee);

    });
}

function PushEmptyMessage() {
    $("#MonthlyServiceFeeTbl").empty();
    var emptyrow = '<tr><td colspan="5"><h5 class="text-center">No records to display</h5></td></tr>'
    $("#MonthlyServiceFeeTbl").append(emptyrow);
}