//********************************************* Pagination Grid ********************************************
var LOVlist = {};
var pageindex = 1, pagesize = 5;
var GridtotalRecords;
var TotalPages = 1, FirstRecord = 0, LastRecord = 0;
var ckNewRowPaginationValidation = false;


//********************************************************************************

$(document).ready(function () {
    $('#myPleaseWait').modal('show');
    var primaryId = $('#primaryID').val();
    var ActionType = $('#ActionType').val();
    formInputValidation("QAPQualityCauseMasterForm");    
    $('#btnDelete').hide();
    $('#btnQualityCauseEdit').hide();
    $('#btnNextScreenSave').hide();
       

    //******************************** Load DropDown ***************************************

    $.get("/api/QualityCauseMaster/Load")
   .done(function (result) {
       var loadResult = JSON.parse(result);
       $("#jQGridCollapse1").click();
       LOVlist = loadResult
       $.each(loadResult.QualityServiceTypeData, function (index, value) {
           $('#QualityService').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
       });       
       window.QualityStatusLoadData = loadResult.QualityStatusTypeData
       window.QualityProblemLoadData = loadResult.QualityProblemTypeData
       AddNewRowQualityCauseMst();       

       //var primaryId = $('#primaryID').val();
       //if (primaryId != null && primaryId != "0") {
       //    getById(primaryId, pagesize, pageindex)
       //}
       //else {
       //    $('#myPleaseWait').modal('hide');

       //}
   })
   .fail(function (response) {
       $('#myPleaseWait').modal('hide');
       $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
       $('#errorMsg').css('visibility', 'visible');
   });


    ////************************************** GetById ****************************************

    //function getById(primaryId, pagesize, pageindex) {
    //    $.get("/api/QualityCauseMaster/get/" + primaryId + "/" + pagesize + "/" + pageindex)
    //            .done(function (result) {
    //                var result = JSON.parse(result);

    //                $('#primaryID').val(result.QualityCauseId);
    //                $('#QualityService' + ' option[value="' + result.ServiceId + '"]').prop('selected', true);
    //                $('#QualityService').prop("disabled", "disabled");
    //                $('#QualityCauseCode').val(result.CauseCode);
    //                $('#QualityCauseCode').prop("disabled", "disabled");
    //                $('#QualityDescription').val(result.Description);
    //                $('#Timestamp').val(result.Timestamp);

    //                $("#QualityCauseMstTbl").empty();

    //                if (result != null && result.QualityCauseListData != null && result.QualityCauseListData.length > 0)
    //                {
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

    $("#QualityDescription,#QualityCauseCode").hover(function () {
        var TipDesc = $("#QualityDescription").val();
        var TipCauseCode = $("#QualityCauseCode").val();
        $('#QualityDescription').css('cursor', 'auto').attr('title', TipDesc);
        $('#QualityCauseCode').css('cursor', 'auto').attr('title', TipCauseCode);   
    });   
    
       
    //****************************************** Save *********************************************

    $("#btnQualityCauseSave, #btnQualityCauseEdit,#btnSaveandAddNew").click(function () {
        $('#btnQualityCauseSave').attr('disabled', true);
        $('#btnQualityCauseEdit').attr('disabled', true);
        $('#myPleaseWait').modal('show');
        var CurrentbtnID = $(this).attr("Id");
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');

        var _index;
        $('#QualityCauseMstTbl tr').each(function () {
            _index = $(this).index();
        });

        var result = [];
        var primaryId = $('#primaryID').val();
        for (var i = 0; i <= _index; i++) {

            $('#ProblemCode_' + i).prop("required", true);
            $('#QCcode_' + i).prop("required", true);
            $('#QualityStatus_' + i).prop("required", true);

            var _QualityCauseWO = {

                QualityCauseId: primaryId,
                QualityCauseDetId: $('#hdnQualityCauseDetId_' + i).val(),
                ProblemCode: $('#ProblemCode_' + i).val(),
                QcCode: $('#QCcode_' + i).val(),
                Details: $('#QualityDetails_' + i).val(),
                Status: $('#QualityStatus_' + i).val(),
                IsDeleted: chkIsDeletedRow(i, $('#Isdeleted_' + i).is(":checked")),
                ItemId: 1,
            }
            result.push(_QualityCauseWO);
        }

        var deletedCount = Enumerable.From(result).Where(x=>x.IsDeleted).Count();
        var Isdeleteavailable = deletedCount > 0;
        if (deletedCount == result.length) {
            bootbox.alert("Sorry!. You cannot delete all rows");
            $('#btnQualityCauseSave').attr('disabled', false);
            $('#btnQualityCauseEdit').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            return false;
        }

        var Timestamp = $("#Timestamp").val();          
        if (primaryId != null) {
            QualityCauseId = primaryId;
            Timestamp = Timestamp;
        }
        else {
            QualityCauseId = 0;
            Timestamp = "";
        }

        var QualityCauseMstobj = {

            QualityCauseId: QualityCauseId,
            ServiceId: $('#QualityService').val(),
            CauseCode: $('#QualityCauseCode').val(),
            Description: $("#QualityDescription").val(),
            Timestamp: Timestamp,
            QualityCauseListData: result
        }

        var isFormValid = formInputValidation("QAPQualityCauseMasterForm", 'save');
        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
            $('#myPleaseWait').modal('hide');
            $('#btnQualityCauseSave').attr('disabled', false);
            $('#btnQualityCauseEdit').attr('disabled', false);
            return false;
        }

        if (Isdeleteavailable == true) {
            $('#myPleaseWait').modal('hide');
            bootbox.confirm(Messages.MULTIPLE_DELETE_CONFIRMATION, function (result) {
                if (result) {
                    SaveQualityCauseMST(QualityCauseMstobj);
                }
                else {
                    $('#myPleaseWait').modal('hide');
                    $('#btnQualityCauseSave').attr('disabled', false);
                    $('#btnQualityCauseEdit').attr('disabled', false);
                }
            });
        }
        else {
            SaveQualityCauseMST(QualityCauseMstobj);
        }

        function SaveQualityCauseMST(QualityCauseMstobj) {
            var jqxhr = $.post("/api/QualityCauseMaster/Save", QualityCauseMstobj, function (response) {
                var result = JSON.parse(response);
                $("#primaryID").val(result.QualityCauseId);
                $("#Timestamp").val(result.Timestamp);
                if (result != null && result.QualityCauseListData != null && result.QualityCauseListData.length > 0) {
                    BindGridData(result);
                }
                $("#grid").trigger('reloadGrid');
                if (result.QualityCauseId != 0) {                   
                    $('#btnNextScreenSave').show();
                    $('#btnQualityCauseEdit').show();
                    $('#btnQualityCauseSave').hide();
                    $('#btnDelete').show();                    
                }
                $(".content").scrollTop(0);
                showMessage('Quality Cause Master', CURD_MESSAGE_STATUS.SS);
                //$("#top-notifications").modal('show');
                //setTimeout(function () {
                //    $("#top-notifications").modal('hide');
                //}, 5000);

                $('#btnQualityCauseSave').attr('disabled', false);
                $('#btnQualityCauseEdit').attr('disabled', false);
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
                $("div.errormsgcenter").text(errorMessage).css('visibility', 'visible');
                $('#errorMsg').css('visibility', 'visible');

                $('#btnQualityCauseSave').attr('disabled', false);
                $('#btnQualityCauseEdit').attr('disabled', false);
                $('#myPleaseWait').modal('hide');
            });
        }
    });


    //************************************ Grid Delete 

    $("#chk_QualityCauseMasterdet").change(function () {
        var Isdeletebool = this.checked;

        if (this.checked) {
            $('#QualityCauseMstTbl tr').map(function (i) {
                if ($("#Isdeleted_" + i).prop("disabled")) {
                    $("#Isdeleted_" + i).prop("checked", false);
                }
                else {
                    $("#Isdeleted_" + i).prop("checked", true);
                }
            });
        } else {
            $('#QualityCauseMstTbl tr').map(function (i) {
                $("#Isdeleted_" + i).prop("checked", false);
            });
        }
    });



    //******************** Back****************

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
});


//****************************** AddNewRow **********************************************


function AddNewRowQualityCauseMst() {

    var inputpar = {
        inlineHTML: BindNewRowHTML(),

        IdPlaceholderused: "maxindexval",
        TargetId: "#QualityCauseMstTbl",
        TargetElement: ["tr"]

    }
    AddNewRowToDataGrid(inputpar);
    $('#chk_QualityCauseMasterdet').prop("checked", false);
    $('#QualityCauseMstTbl tr:last td:first input').focus();
    formInputValidation("QAPQualityCauseMasterForm");
    ckNewRowPaginationValidation = true;
    var rowCount = $('#QualityCauseMstTbl tr:last').index();
    $.each(window.QualityStatusLoadData, function (index, value) {
        $('#QualityStatus_' + rowCount).append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
    });
    $.each(window.QualityProblemLoadData, function (index, value) {
        $('#ProblemCode_' + rowCount).append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
    });

    //******************** Validation ********************

    $('.alphaNospl').keypress(function (e) {
        var regex = new RegExp("^[a-zA-Z0-9-//s]+$");
        var str = String.fromCharCode(!e.charCode ? e.which : e.charCode);
        if (regex.test(str)) {
            return true;
        }
        e.preventDefault();
        return false;
    });
    $('.desc').keypress(function (e) {
        var regex = new RegExp("^[a-zA-Z0-9(),'\",.-\\s]+$");
        var str = String.fromCharCode(!e.charCode ? e.which : e.charCode);
        if (regex.test(str)) {
            return true;
        }
        e.preventDefault();
        return false;
    });
    $('.desc').on('paste', function (e) {
        var $this = $(this);
        setTimeout(function () {
            $this.val($this.val().replace(/[~`!@#$%^&*_+|\\:{}\[\];?<>/\^]/g, ''));
        }, 5);
    });
    $('.detRemark').keypress(function (e) {
        var regex = new RegExp("^[a-zA-Z0-9(),'\",:.;-\\s]+$");
        var str = String.fromCharCode(!e.charCode ? e.which : e.charCode);        
        if (regex.test(str)) {
            return true;
        }
        e.preventDefault();
        return false;
    });
    $('.detRemark').on('paste', function (e) {
        var $this = $(this);
        setTimeout(function () {
            $this.val($this.val().replace(/[~`!@#$%^&*_+|\\{}\[\]?<>/\^]/g, ''));
        }, 5);
    });
    $('.entervalid').keypress(function (e) {
        var keycode = (e.keyCode ? e.keyCode : e.which);
        if (keycode == '13') {
            e.preventDefault();
            return false;
        }
    });      


    

    $("textarea").keypress(function (e) {
        if (e.which === 32 && !this.value.length)
            e.preventDefault();        
    });

}

function BindNewRowHTML() {
    return ' <tr> <td width="3%" title="Select"> <div class="checkbox text-center"> <label for="checkboxes-0"> <input type="checkbox" name="QualityCauseCheckboxes" id="Isdeleted_maxindexval" onchange="IsDeleteCheckAll(QualityCauseMstTbl,chk_QualityCauseMasterdet)"> </label> </div></td><td width="20%" style="text-align: center;" title=""> <div> <input type="hidden" id="hdnQualityCauseDetId_maxindexval" class="form-control"> <select class="form-control" id="ProblemCode_maxindexval" required name="ProblemCode"> <option value="null">Select</option> </select> </div></td><td width="25%" style="text-align: center;" title=""> <div> <input type="text" id="QCcode_maxindexval" maxlength="25" pattern="^[a-zA-Z0-9-/\\s]{3,}$" class="form-control documentno" required name="QCCode"> </div></td><td width="32%" style="text-align: center;" title=""> <div> <textarea type="text" id="QualityDetails_maxindexval" name="Details" title="" class="form-control wt-resize Description entervalid" maxlength="255" style="max-width:initial; width:100%;"></textarea> </div></td><td width="20%" style="text-align: center;" title=""> <div> <select class="form-control" id="QualityStatus_maxindexval" required name="Status">  </select> </div></td></tr> ';
}

//*********************** Empty Row Validation **************************************

function AddNewRow() {
    $("div.errormsgcenter1").text("");
    $('#errorMsg1').css('visibility', 'hidden');
    var rowCount = $('#QualityCauseMstTbl tr:last').index();
    var ProblemCode = $('#ProblemCode_' + rowCount).val();
    var RootcauseCode = $('#QCcode_' + rowCount).val();
    if (rowCount < 0)
        AddNewRowQualityCauseMst();
    else if (rowCount >= "0" && (ProblemCode == "null" || RootcauseCode == "")) {
        bootbox.alert("All fields are mandatory. Please enter details in existing row");        
    }
    else {
        AddNewRowQualityCauseMst();
    }
}


function BindGridData(result) {
    var ActionType = $('#ActionType').val();
    $('#QualityDescription').val(result.Description);
    $('#QualityCauseCode').val(result.CauseCode);
    $('#QualityCauseCode').prop("disabled", "disabled");
    $("#QualityCauseMstTbl").empty();
    $.each(result.QualityCauseListData, function (index, value) {
        AddNewRowQualityCauseMst();
        $("#hdnQualityCauseDetId_" + index).val(result.QualityCauseListData[index].QualityCauseDetId);
        $('#ProblemCode_' + index + ' option[value="' + result.QualityCauseListData[index].ProblemCode + '"]').prop('selected', true);
        $("#QCcode_" + index).val(result.QualityCauseListData[index].QcCode)
        $("#QualityDetails_" + index).val(result.QualityCauseListData[index].Details).attr('title', result.QualityCauseListData[index].Details);
        $('#QualityStatus_' + index + ' option[value="' + result.QualityCauseListData[index].Status + '"]').prop('selected', true);

        if (ActionType == "View") {
            $("#QAPQualityCauseMasterForm :input:not(:button)").prop("disabled", true);
            $('#Isdeleted_' + index).prop("disabled", "disabled");
            $('#ProblemCode_' + index + ' option[value="' + result.QualityCauseListData[index].ProblemCode + '"]').prop('selected', true)
            $('#ProblemCode_' + index).prop("disabled", "disabled");
            $('#QualityStatus_' + index + ' option[value="' + result.QualityCauseListData[index].Status + '"]').prop('selected', true)
            $('#QualityStatus_' + index).prop("disabled", "disabled");
            $("#chkQualityCauseDetails_" + index).val(result.QualityCauseListData[index].IsDeleted).prop("disabled", "disabled");
            $('#QCcode_' + index).prop("disabled", "disabled");
            $('#QualityDetails_' + index).prop("disabled", "disabled").attr('title', result.QualityCauseListData[index].Details);
            $('#QualityCauseCode').val(result.CauseCode).prop("disabled", "disabled");
            $('#QualityDescription').val(result.Description).prop("disabled", "disabled");
            $("#chk_QualityCauseMasterdet").prop("disabled", "disabled");
        }    
    });
   
    //************************************************ Grid Pagination *******************************************
    ckNewRowPaginationValidation = false;
    if ((result.QualityCauseListData && result.QualityCauseListData.length) > 0) {
        QualityCauseId = result.QualityCauseListData[0].QualityCauseId;
        GridtotalRecords = result.QualityCauseListData[0].TotalRecords;
        TotalPages = result.QualityCauseListData[0].TotalPages;
        LastRecord = result.QualityCauseListData[0].LastRecord;
        FirstRecord = result.QualityCauseListData[0].FirstRecord;
        pageindex = result.QualityCauseListData[0].PageIndex;
    }
    $('#paginationfooter').show();
    var mapIdproperty = ["IsDeleted-Isdeleted_", "QualityCauseDetId-hdnQualityCauseDetId_", "ProblemCode-ProblemCode_", "QcCode-QCcode_", "Details-QualityDetails_", "Status-QualityStatus_"];

    var htmltext = BindNewRowHTML();//Inline Html
    var primaryId = $('#primaryID').val();
    var obj = {
        formId: "#QAPQualityCauseMasterForm", IsView: ($('#ActionType').val() == ""), PageNumber: pageindex, flag: "QualityCauseflag", mapIdproperty: mapIdproperty, htmltext: htmltext, GridtotalRecords: GridtotalRecords, ListName: "QualityCauseListData", tableid: '#QualityCauseMstTbl', destionId: "#paginationfooter", TotalPages: TotalPages, FirstRecord: FirstRecord, LastRecord: LastRecord, geturl: "/api/QualityCauseMaster/get/" + primaryId, pageindex: pageindex, pagesize: pagesize
    };    
    CreateFooterPagination(obj);

    //************************************************ End *******************************************************

    
}

//***************************************** Delete Valid ****************************************************

function chkIsDeletedRow(i, delrec) {
    if (delrec == true) {
        $('#ProblemCode_' + i).prop("required", false);
        $('#QCcode_' + i).prop("required", false);
        $('#QualityStatus_' + i).prop("required", false);        
        return true;
    }
    else {
        return false;
    }
}

//**** Grid merging**********\\

function LinkClicked(id) {
    $(".content").scrollTop(1);
    $("#QAPQualityCauseMasterForm :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('#paginationfooter').show();
    var action = "";
    $('#primaryID').val(id);
    var hasEditPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Edit'");
    var hasViewPermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='View'");
    var hasDeletePermission = Enumerable.From(JSON.parse($('#ActionPermissionValues').val())).Any("$.ActionPermissionName=='Delete'");

    if (hasEditPermission ) {
        action = "Edit"

    }
    else if (!hasEditPermission && hasViewPermission) {
        action = "View"
    }
    if (action == "Edit" && hasDeletePermission) {
        $('#btnDelete').show();
    }

    if (action == 'View') {
        $("#QAPQualityCauseMasterForm :input:not(:button)").prop("disabled", true);
    } else {
        $('#btnQualityCauseEdit').show();
        $('#btnQualityCauseSave').hide();
        //$('#btnSaveandAddNew').hide();
        $('#btnNextScreenSave').show();
    }
    $('#spnActionType').text(action);

    var primaryId = $('#primaryID').val();
    if (primaryId != null && primaryId != "0") {
        getById(primaryId, pagesize, pageindex)
    }
    else {
        $('#myPleaseWait').modal('hide');

    }

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
            $.get("/api/QualityCauseMaster/Delete/" + ID)
             .done(function (result) {
                 filterGrid();
                 $(".content").scrollTop(0);
                 showMessage('Quality Cause Master', CURD_MESSAGE_STATUS.DS);
                 $('#myPleaseWait').modal('hide');
                 EmptyFields();
             })
             .fail(function (response) {
                 showMessage('Quality Cause Master', CURD_MESSAGE_STATUS.DF(response));
                 $('#myPleaseWait').modal('hide');
             });
        }

    });
}

function EmptyFields() {
    $(".content").scrollTop(0);
    $('input[type="text"], textarea').val('');
    $('#LevelFacility').val("null");   
    $('#QualityCauseCode').prop('disabled', false);
    $('#btnQualityCauseEdit').hide();
    $('#btnQualityCauseSave').show();
    $('#btnDelete').hide();
    $('#btnNextScreenSave').hide();
    $('#spnActionType').text('Add');
    $("#primaryID").val('');
    $("#grid").trigger('reloadGrid');
    $("#QAPQualityCauseMasterForm :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('#QualityCauseMstTbl').empty();
    $('#tablebody').empty();
    $('#paginationfooter').hide();
    AddNewRowQualityCauseMst();
   
    
}





//************************************** GetById ****************************************

function getById(primaryId, pagesize, pageindex) {
    $.get("/api/QualityCauseMaster/get/" + primaryId + "/" + pagesize + "/" + pageindex)
            .done(function (result) {
                var result = JSON.parse(result);

                $('#primaryID').val(result.QualityCauseId);
                $('#QualityService' + ' option[value="' + result.ServiceId + '"]').prop('selected', true);
                $('#QualityService').prop("disabled", "disabled");
                $('#QualityCauseCode').val(result.CauseCode);
                $('#QualityCauseCode').prop("disabled", "disabled");
                $('#QualityDescription').val(result.Description);
                $('#Timestamp').val(result.Timestamp);

                $("#QualityCauseMstTbl").empty();

                if (result != null && result.QualityCauseListData != null && result.QualityCauseListData.length > 0) {
                    BindGridData(result);
                }
                $('#myPleaseWait').modal('hide');
            })
            .fail(function (response) {
                $('#myPleaseWait').modal('hide');
                $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
                $('#errorMsg').css('visibility', 'visible');
            });
}


// get database based on service 
function ChangeService() {
    var ServiceId = $('#QualityService').val();
    $.get("/api/QualityCauseMaster/ChangeService/" + ServiceId)
 .done(function (result) {
     debugger;
     $("#grid").trigger('reloadGrid');
     var getResult = JSON.parse(result);

 })
 .fail(function (response) {
     $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
     $('#errorMsg').css('visibility', 'visible');
 });
}