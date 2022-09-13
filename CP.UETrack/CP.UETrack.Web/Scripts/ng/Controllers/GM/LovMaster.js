
var GetCollection = [];
$(document).ready(function () {
    $('#myPleaseWait').modal('show');
    formInputValidation("LovMasterScreen");
    $.get("/api/LovMaster/Load")
        .done(function (result) {
            AddNewRowLovMaster();
            $("#jQGridCollapse1").click();
            var loadResult = JSON.parse(result);
            $("#LovMasterTbl :input,chk_DefaultValue").attr("disabled", "disabled");
            $("#LovKey").prop("disabled", "disabled");
            $("#btnEdit").hide();
            $("#Lovplus").hide();
            $.each(loadResult.LovType, function (index, value) {
                                  
                $('#LovType').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>').prop("disabled", "disabled");

            });  
            $.each(loadResult.Services, function (index, value) {
                $('#selServices').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
            });
        })
        .fail(function () {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
        });

   

    $("#btnCancel").click(function () {
        var message = Messages.Reset_Alert_CONFIRMATION;
        bootbox.confirm(message, function (result) {
            if (result) {
                ClearFields();
            }
            else {
                $('#myPleaseWait').modal('hide');
            }
        });
    });

    $("#jQGridCollapse1").click(function () {
        //(".jqContainer").toggleClass("hide_container");
        var pro = new Promise(function (res, err) {
            $(".jqContainer").toggleClass("hide_container");
            res(1);
        })

        pro.then(
            function resposes() {
                setTimeout(() => $(".content").scrollTop(3000), 1);

            }

            )

    });

    //****************************************** Save *********************************************

});

$("#btnSave, #btnEdit").click(function () {
    $('#btnlogin').attr('disabled', true);
    $('#myPleaseWait').modal('show');

    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');

    var isFormValid = formInputValidation("LovMasterScreen", 'save');
    if (!isFormValid) {
        $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
        $('#errorMsg').css('visibility', 'visible');

        $('#btnlogin').attr('disabled', false);
        $('#myPleaseWait').modal('hide');
        return false;
    }

    var _index;
    $('#LovMasterTbl tr').each(function () {
        _index = $(this).index();
    });



    var LovKey = $('#LovKey').val();
    var ModuleName = $('#hdnLovMasterModuleName').val();
    var ScreenName = $('#hdnLovMasterScreenName').val();
    var timeStamp = $("#Timestamp").val();
    var LovType = $("#LovType").val();
    var result = [];

    for (var i = 0; i <= _index; i++) {
        var _LovMasterGrid = {
            Fieldcode: $('#FieldCode_' + i).val(),
            FieldValue: $('#FieldValue_' + i).val(),
            LovId: $('#hdnLovMasterLovId_' + i).val(),
            Remarks: $('#RemarksValue_' + i).val(),
            SortNo: $('#SortValue_' + i).val(),
            ModuleName: ModuleName,
            ScreenName: ScreenName,
            LovKey: LovKey,
            LovType:LovType,
            IsDefault: chkActualValue(i)
        }

        if (_LovMasterGrid.Fieldcode == 0) {
            //LovFcVal = $("#FieldCode_").val();
            $("div.errormsgcenter").text(' Please Enter a  Valid Field Code. ' + _LovMasterGrid.Fieldcode  + " is not Acceptable");
            $('#errorMsg').css('visibility', 'visible');

            $('#btnSave').attr('disabled', false);
            $('#myPleaseWait').modal('hide');
            return false;
        }

        // if (Duplicatecount == 0 || !Duplicatecount)
        result.push(_LovMasterGrid);
    }
    var Actualcount = result.length;//.Where(x=>x.Fieldcode == ($('#FieldCode_' + i).val())).count();
    ////if (_LovMasterGrid.Fieldcode == 0) {
    ////    //LovFcVal = $("#FieldCode_").val();
    ////    $("div.errormsgcenter").text(' Please Enter a  Valid Field Code.' + Fieldcode +"is not acceptable");
    ////    $('#errorMsg').css('visibility', 'visible');

    ////    $('#btnSave').attr('disabled', false);
    ////    $('#myPleaseWait').modal('hide');
    ////    return false;
    ////}
    var DuplicateFieldcodecount = Enumerable.From(result).Distinct(x=>x.Fieldcode).ToArray().length;
    var DuplicateFieldValuecount = Enumerable.From(result).Distinct(x=>x.FieldValue).ToArray().length;
    if (DuplicateFieldcodecount == Actualcount) {

    }
    else {
        $("div.errormsgcenter").text('Entered Field Code Already Exist');
        $('#errorMsg').css('visibility', 'visible');

        $('#btnSave').attr('disabled', false);
        $('#myPleaseWait').modal('hide');
        return false;
    }
    
    if (DuplicateFieldValuecount == Actualcount) {
    }
    else {
        $("div.errormsgcenter").text('Entered Field Value Already Exist');
        $('#errorMsg').css('visibility', 'visible');

        $('#btnSave').attr('disabled', false);
        $('#myPleaseWait').modal('hide');
        return false;
    }
    function chkActualValue(DataTypeId) {

        if ($('#chk_DefaultValue_' + i).prop("checked") == true) {
            var val = true;
        }
        else if ($('#chk_DefaultValue_' + i).prop("checked") == false) {
            var val = false;
        }
        return val;
    }
    var obj = {
        LovMasterGridData: result,
        LovKey: LovKey,
        ModuleName: ModuleName,
        ScreenName: ScreenName,
        Timestamp: timeStamp,
        LovType:LovType
    }


    var jqxhr = $.post("/api/LovMaster/Save", obj, function (response) {
        var result = JSON.parse(response);
        GetLovMasterBind(result);

        $("#primaryID").val(result.LovId);
        $("#Timestamp").val(result.Timestamp);
        $(".content").scrollTop(0);
        showMessage('LovMaster', CURD_MESSAGE_STATUS.SS);
        $("#top-notifications").modal('show');
        setTimeout(function () {
            $("#top-notifications").modal('hide');
        }, 5000);


        $('#btnSave').attr('disabled', false);
        $('#myPleaseWait').modal('hide');
        $("#grid").trigger('reloadGrid');
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
});

function GetLovMasterBind(getResult) {
    var FalseCount = 0;
    var primaryId = $('#primaryID').val();
    $("#LovKey").val(getResult.LovKey).prop("disabled", "disabled");
    $("#hdnLovMasterLovId").val(getResult.LovId);
    $("#hdnLovMasterModuleName").val(getResult.ModuleName);
    $("#hdnLovMasterScreenName").val(getResult.ScreenName);
    $("#LovMasterTbl").empty();
   
    
    if (getResult.IsDefault == "True") {
        $("#DefaultValue").val(getResult.IsDefault).prop("disabled", "disabled");

    }
    else {
        $("#DefaultValue").val("No Default Value").prop("disabled", "disabled");
    }
  
    $.each(getResult.LovMasterGridData, function (index, value) {
        AddNewRowLovMaster();
        $("#hdnLovMasterLovKey_" + index).val(getResult.LovMasterGridData[index].LovKey);
        $("#hdnLovMasterModuleName_" + index).val(getResult.LovMasterGridData[index].ModuleName);
        $("#hdnLovMasterScreenName_" + index).val(getResult.LovMasterGridData[index].ScreenName);
        $("#hdnLovMasterLovId_" + index).val(getResult.LovMasterGridData[index].LovId);
        $("#FieldCode_" + index).val(getResult.LovMasterGridData[index].Fieldcode).prop("disabled", "disabled");
        $("#FieldValue_" + index).val(getResult.LovMasterGridData[index].FieldValue);
        $("#RemarksValue_" + index).val(getResult.LovMasterGridData[index].Remarks);
        $("#SortValue_" + index).val(getResult.LovMasterGridData[index].SortNo);
        $("#hdnbuiltin_" + index).val(getResult.LovMasterGridData[index].BuiltIn);
        if (getResult.LovMasterGridData[index].IsDefault == true) {


            $("#chk_DefaultValue_" + index).prop('checked', true);

            $("#DefaultValue").val(getResult.LovMasterGridData[index].FieldValue).prop("disabled", "disabled");
        }

        if (getResult.LovMasterGridData[index].IsDefault == false && getResult.LovMasterGridData[index].BuiltIn == true) {
            $("#chk_DefaultValue_" + index).prop('disabled', true);
            FalseCount = FalseCount + 1;
        }

        if (getResult.LovMasterGridData[index].BuiltIn == true) {
            $("#chk_BuildinValue_" + index).prop('checked', true);
            $("#FieldCode_" + index).prop('disabled', true);
            $("#FieldValue_" + index).prop('disabled', true);
            $("#RemarksValue_" + index).prop('disabled', true);
            $("#SortValue_" + index).prop('disabled', true);
            $("#chk_DefaultValue_" + index).prop('disabled', true);
            
        }
        var BuiltinCount = Enumerable.From(getResult.LovMasterGridData).Where("$.BuiltIn == true").Count();
        //alert(BuiltinCount)
       
        if (BuiltinCount > 0) {
            if (getResult.LovKey == "IssuingBodyValue") {
                $("#LovType").val(303).prop("disabled", "disabled");
                $("#btnEdit").show();
                $("#Lovplus").show();
                $("#FieldValue_" + index).prop("disabled", false);
                $("#RemarksValue_" + index).prop("disabled", false);
                $("#SortValue_" + index).prop("disabled", false);
                $("#LovType").prop("disabled", "disabled");
                $("#chk_DefaultValue_" + index).prop("disabled", "disabled");
            }
            else {
                $("#LovMasterTbl :input,chk_DefaultValue").attr("disabled", "disabled");
                $("#chk_DefaultValue_" + index).prop('disabled', true);
                $("#LovType").val(302).prop("disabled", "disabled");
                $("#Lovplus").hide();
                $("#btnEdit").hide();
            }
        }
        else {

            $("#LovType").val(303).prop("disabled", "disabled");
            $("#btnEdit").show();
            $("#Lovplus").show();
        }

        var ViewId = $("#ActionType").val();
        if (ViewId == "VIEW") {
            $("#FieldCode_" + index).prop("disabled", "disabled");
            $("#FieldValue_" + index).prop("disabled", "disabled");
            $("#RemarksValue_" + index).prop("disabled", "disabled");
            $("#SortValue_" + index).prop("disabled", "disabled");
            $("#LovType").prop("disabled", "disabled");
            $("#chk_DefaultValue_" + index).prop("disabled", "disabled");
        }
        $("#chk_DefaultValue_" + index).click(function () {
            $("#DefaultValue").val(getResult.LovMasterGridData[index].FieldValue);
        });
        
    });
   
    if (getResult.LovMasterGridData.length == FalseCount) {
        $.each(getResult.LovMasterGridData, function (index, value) {
            $("#chk_DefaultValue_" + index).prop('disabled', true);
        });
    }
    GetCollection = getResult.LovMasterGridData;
}

function AddNewRow() {
    var _index;
    $('#LovMasterTbl tr').each(function () {
        _index = $(this).index();

    });
    var flagAllow = 0;
    var SortNoRowFil = 0;
    var FieldCodeRowFill = 0;
    for (var i = 0; i <= _index; i++) {
        var FieldCodeRowFill = $("#FieldCode_" + i).val();
        var FieldCodeRowFill = parseInt(FieldCodeRowFill)
        var FieldValueRowFill = $("#FieldValue_" + i).val();
        var SortNoRowFill = $("#SortValue_" + i).val();
        var SortNoRowFill = parseInt(SortNoRowFill)

        if (parseInt(SortNoRowFil) <= SortNoRowFill) {
            SortNoRowFil = (SortNoRowFill);
        }
        else {
            SortNoRowFil = SortNoRowFil + 1;
        }

       // if (!isNaN(FieldCodeRowFill)) {
            if (parseInt(FieldCodeRowFill) <= FieldCodeRowFill) {
                FieldCodeRowFill = (FieldCodeRowFill);
            }
            else {
                FieldCodeRowFill = FieldCodeRowFill + 1;
            }
       // }
      

        if (FieldCodeRowFill && FieldValueRowFill && SortNoRowFill)
        { }
        else
            flagAllow++;
    }
    if (flagAllow != 0) {
        bootbox.alert("Please enter data for existing rows");
        return;

    }
    AddNewRowLovMaster();


    var SortVal = (SortNoRowFil)
    var SortValue = parseInt(SortVal)

    var FieldCodeRow = (FieldCodeRowFill)
    var FieldCodeRowval = parseInt(FieldCodeRow)

    $("#SortValue_" + i).val(SortValue + 1);
    $("#FieldCode_" + i).val(FieldCodeRowval + 1);
    formInputValidation("form");


}
function AddNew() {
    var _index;
    $('#LovMasterTbl tr').each(function () {
        _index = $(this).index();

    });
   
    AddNewRowLovMaster();
    formInputValidation("form");
}


function AddNewRowLovMaster() {
    var inputpar = {
        inlineHTML: AddNewLovMasterHtml(),
        IdPlaceholderused: "maxindexval",
        TargetId: "#LovMasterTbl",
        TargetElement: ["tr"]
    }

    AddNewRowToDataGrid(inputpar);

    var TabVal = $('#LovMasterTbl tr:last').index();
    //$("#FieldValue_" + TabVal).focus();
    formInputValidation("LovMasterScreen");
    $('.digOnly').keypress(function (e) {
        if ((e.charCode < 48 || e.charCode > 57) &&  (e.charCode != 32) && (e.charCode != 0)) return false;
    });
    $('.digOnly').on('paste', function (e) {
            var $this = $(this);
            setTimeout(function () {
                $this.val($this.val().replace(/[~`!@#$%^&*A-za-z\s_+|\\:{}\[\];-?<>\^\"\']/g, ''));
            }, 5);
    });

    $('.digalpha').keypress(function (e) {
        if ((e.charCode < 97 || e.charCode > 122) && (e.charCode < 48 || e.charCode > 57) && (e.charCode < 65 || e.charCode > 90)  && (e.charCode != 0))
        return false;
    });
    $('.digalpha').on('paste', function (e) {
        var $this = $(this);
        setTimeout(function () {
            $this.val($this.val().replace(/[~`!@#$%^&*\s_+|\\:{}\[\];-?<>\^\"\']/g, ''));
        }, 5);
    });

    $('.digalphaspace').keypress(function (e) {
        if ((e.charCode < 97 || e.charCode > 122) && (e.charCode < 48 || e.charCode > 57) && (e.charCode < 65 || e.charCode > 90)  && (e.charCode != 32) && (e.charCode != 0))
            return false;
    });
    $('.digalphaspace').on('paste', function (e) {
        var $this = $(this);
        setTimeout(function () {
            $this.val($this.val().replace(/[~`!@#$%^&*_+|\\:{}\[\];-?<>\^\"\']/g, ''));
        }, 5);
    });
}

function AddNewLovMasterHtml() {

    return ' <tr class="ng-scope" style=""> <td width="23%"> <div> <input type="text" id="FieldCode_maxindexval" disabled name="FieldCode"  style="max-width:100%" class="form-control digOnly"  maxlength="10" autocomplete="off" required> <input type="hidden" id="hdnLovMasterLovKey" /><input type="hidden" id="hdnLovMasterModuleName" /><input type="hidden" id="hdnLovMasterScreenName" /> </div><input type="hidden" id="hdnLovMasterLovId_maxindexval" /></td> \
                    <td width="30%"> <div> <input type="text" id="FieldValue_maxindexval" name="FieldValue"  style="max-width:100%" class="form-control "maxlength="100" autocomplete="off" required ></div></td>\
                    <td width="20%"> <div> <input type="text" id="RemarksValue_maxindexval" maxlength="500" name="Remarks" class="form-control" autocomplete="off" > </div></td>\
                    <td width="20%"> <div> <input type="text" id="SortValue_maxindexval" style="text-align:right"  name="Sort" class="form-control digOnly"maxlength="3" autocomplete="off" required> </div></td>\
                    <td width="7%" id="Default"> <div class="checkbox text-center"> <label for="checkboxes-0"> <input type="checkbox"class="form-controls" onchange="Calculate(maxindexval)" name="DefaultValueCheckboxes" id="chk_DefaultValue_maxindexval" value="false" autocomplete="off"  > </label> </div></td><input type="hidden" id="hdnbuiltin" />\</tr>'
}


function Calculate(element) {
    var _index;
    $('#LovMasterTbl tr').each(function () {
        _index = $(this).index();

    });

    if ($("#chk_DefaultValue_" + element).prop('checked') == true) {
        for (var i = 0; i <= _index ; i++) {

            $("#chk_DefaultValue_" + i).prop('checked', false);
            $("#chk_DefaultValue_" + i).prop('disabled', true);
        }
        $("#chk_DefaultValue_" + element).prop('checked', true);
        $("#chk_DefaultValue_" + element).prop('disabled', false);
        var value = $("#FieldValue_" + element).val();
        $("#DefaultValue").val(value).prop("disabled", "disabled");
    }
    if ($("#chk_DefaultValue_" + element).prop('checked') == false) {
        for (var i = 0; i <= _index ; i++) {
            $("#chk_DefaultValue_" + i).prop('checked', false);
            if (GetCollection[i].BuiltIn == false)
                $("#chk_DefaultValue_" + i).prop('disabled', false);
        }
        $("#DefaultValue").val("No Default Value").prop("disabled", "disabled");
    }

}
function ClearFields() {
    $(".content").scrollTop(0);
    $("#LovKey").val("");
    $("#LovType").val("");
    $("#LovMasterTbl").empty();
    AddNewRowLovMaster();
    $("#btnEdit").hide();
    $("#Lovplus").hide();
    $("#FieldCode_0").prop("disabled", true)
    $("#FieldValue_0").prop("disabled", true)
    $("#RemarksValue_0").prop("disabled", true)
    $("#SortValue_0").prop("disabled", true)
    $("#chk_DefaultValue_0").prop("disabled", true)
}
function LinkClicked(id, rowData) {
    $("#formBemsBlock :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('#primaryID').val(id);
    var id = $('#primaryID').val();
    var key = rowData.LovKey;
    $.get("/api/LovMaster/Get/" + key)

                          .done(function (result) {
                              var getResult = JSON.parse(result);
                              GetLovMasterBind(getResult)
                              $('#myPleaseWait').modal('hide');
                          })
                         .fail(function () {
                             $('#myPleaseWait').modal('hide');
                             $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
                             $('#errorMsg').css('visibility', 'visible');
                         });
    $(".content").scrollTop(1);
}

 //***********Adde by Sree for Master **********
function MasterLinkClicked(id, rowData) {
    $("#formMasterBlock :input:not(:button)").parent().removeClass('has-error');
    $("div.errormsgcenter").text("");
    $('#errorMsg').css('visibility', 'hidden');
    $('#primaryID').val(id);
    var id = $('#primaryID').val();
    var key = rowData.LovKey;
    $.get("/api/LovMaster/Get/" + key)

        .done(function (result) {
            var getResult = JSON.parse(result);
            GetLovMasterBind(getResult)
            $('#myPleaseWait').modal('hide');
        })
        .fail(function () {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
        });
    $(".content").scrollTop(1);
}

//function MasterLevelLinkClicked(id, rowData) {
//    $("#formMasterLevel :input:not(:button)").parent().removeClass('has-error');
//    $("div.errormsgcenter").text("");
//    $('#errorMsg').css('visibility', 'hidden');
//    $('#primaryID').val(id);
//    var id = $('#primaryID').val();
//    var key = rowData.LovKey;
//    $.get("/api/LovMaster/Get/" + key)

//        .done(function (result) {
//            var getResult = JSON.parse(result);
//            GetLovMasterBind(getResult)
//            $('#myPleaseWait').modal('hide');
//        })
//        .fail(function () {
//            $('#myPleaseWait').modal('hide');
//            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
//            $('#errorMsg').css('visibility', 'visible');
//        });
//    $(".content").scrollTop(1);
//}



