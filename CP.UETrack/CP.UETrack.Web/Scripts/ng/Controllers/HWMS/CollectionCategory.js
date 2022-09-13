var rowNum = 1;

$(document).ready(function () {

    $.get("/api/CollectionCategory/Load")
        .done(function (result) {
            var loadResult = JSON.parse(result);

            for (var i = 0; i < loadResult.StatusLovs.length; i++) {
                $("#ddlStatus").append(
                    "<option value=" + loadResult.StatusLovs[i].LovId + ">" + loadResult.StatusLovs[i].FieldValue + "</option>"
                );
            }
            $('#myPleaseWait').modal('hide');
        })
        .fail(function () {
            $('#myPleaseWait').modal('hide');
            $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
        });

    //AutoDisplay  
    $(body).on('input propertychange paste keyup', '.clsUserAreaCode', function (event) {

        var controlId = event.target.id;
        var id = controlId.slice(15, 17);
                
        var UserAreaFetchObj = {
            SearchColumn: 'txtUserAreaCode' + id + '-UserAreaCode',//Id of Fetch field
            ResultColumns: ['DeptAreaId-Primary Key', 'UserAreaCode-UserAreaCode'],
            FieldsToBeFilled: ['hdnUserAreaId' + id + '-DeptAreaId', 'txtUserAreaCode' + id + '-UserAreaCode', 'txtUserAreaName' + id +'-UserAreaName']            
        };        

        DisplayFetchResult('divUserAreaFetch' + id , UserAreaFetchObj, "/Api/CollectionCategory/UserAreaCodeFetch", 'UlFetch1' + id , event, 1); //1 -- pageIndex
    });

    $("#btnSave, #btnSaveandAddNew").click(function () {

        $("div.errormsgcenter").text("");
        var CurrentbtnID = $(this).attr("Id");
        $('#errorMsg').css('visibility', 'hidden');
        var CustomerId = $('#selCustomerLayout').val();
        var FacilityId = $('#selFacilityLayout').val();
        
        var isFormValid = formInputValidation("formCollectionCategory", 'save');
        if (!isFormValid) {
            $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            $('#errorMsg').css('visibility', 'visible');
            return false;
        }

        var arr = [];
        var isDuplicateAreaCode = 0;
        $("[id^=txtUserAreaCode]").each(function () {
            var value = $(this).val();
            if (arr.indexOf(value) == -1)
                arr.push(value);
            else {
                isDuplicateAreaCode += 1;
            }
        });

        if (isDuplicateAreaCode > 0) {
            $("div.errormsgcenter").text('Duplicate Area Codes');
            $('#errorMsg').css('visibility', 'visible');
            return false;
        }

               
        var obj = {
            RouteCollectionId: $("#primaryID").val(),
            CustomerId: CustomerId,
            FacilityId: FacilityId,
            RouteCode: $('#txtRouteCode').val(),
            RouteDescription: $('#txtRouteDescription').val(),
            RouteCategory: $('#ddlRouteCategory').val(),
            Status: $('#ddlStatus').val(),          
            CollectionCategoryList: []
        }

        $("#tbodyUserArea tr").each(function () {
            var tbl = {};
            tbl.RouteCollectionUserAreaId = $(this).find("[id^=hdnCollectionUserAreaId]")[0].value;
            tbl.UserAreaCode = $(this).find("[id^=txtUserAreaCode]")[0].value;
            tbl.UserAreaName = $(this).find("[id^=txtUserAreaName]")[0].value;
            tbl.Remarks = $(this).find("[id^=txtRemarks]")[0].value;
            tbl.isDeleted = $(this).find('input:checkbox[id^=isDelete]').prop("checked");
            obj.CollectionCategoryList.push(tbl);
        });
       

     
        var jqxhr = $.post("/api/CollectionCategory/Save", obj, function (response) {            
            var result = JSON.parse(response);
            $("#primaryID").val(result.RouteCollectionId);
            showMessage('CollectionCategory', CURD_MESSAGE_STATUS.SS);             
            $("#grid").trigger('reloadGrid');           
            if (CurrentbtnID == "btnSaveandAddNew") {
                EmptyFields();
                $('#InsertStatus').hide();
            }
            else {
                fillDetails(result);
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

    //Reset Button Code....
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

    $(body).on('input propertychange', '.form-control', function (event) {
        $(this).parent().removeClass('has-error');
    });
   
    $("#addUserArea").click(function () {
        rowNum = rowNum + 1;
        addUserArea(rowNum);
    });

    //Mutliple rows delete button code....
    $("#deleteUserArea").click(function () {
        bootbox.confirm({
            message: 'Do you want to delete a row?',
            buttons: {
                confirm: {
                    label: 'Yes',
                    className: 'btn-primary'
                },
                cancel: {
                    label: 'No',
                    className: 'btn-default'
                }
            },
            callback: function (result) {
                if (result) {
                    if ($("input[type='checkbox']:checked").length > 0) {
                        $("#tbodyUserArea tr").find('input[name="isDelete"]').each(function () {
                            if ($(this).is(":checked")) {
                                if ($(this).closest("tr").find("[id^=hdnCollectionUserAreaId]").val() == 0) {
                                    $(this).closest("tr").remove();
                                }
                            }
                        });
                    }
                    else
                        alert("Please select atleast one row !");
                }
                else {
                    $('#myPleaseWait').modal('hide');
                }
            }
        });

    });

 
    //********************************* Get By ID ************************************
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

function EmptyFields() {

    $("#primaryID").val('0');
    $('[id^=hdnCollectionUserAreaId]').val(0);

    $('#formCollectionCategory #txtRouteCode').val('');
    $('#formCollectionCategory #txtRouteDescription').val('');   
    $('#formCollectionCategory #ddlStatus').val('10563');
    $('#formCollectionCategory #txtUserAreaCode1').val('');
    $('#formCollectionCategory #txtUserAreaName1').val('');
    $('#formCollectionCategory #txtRemarks1').val('');       

    $('#RouteCode').removeClass('has-error');
    $('#RouteDescription').removeClass('has-error');
    $('#RouteCategory').removeClass('has-error');
    $('#Status').removeClass('has-error');
    $('#UserareaCode').removeClass('has-error');
    $('#UserAreaCode').removeClass('has-error');

    $('#errorMsg').css('visibility', 'hidden');
   
    var i = 1;
    $("#tbodyUserArea").find('tr').each(function () {
        if (i > 1) {
            $(this).remove();
        }
        i += 1;
    });

}

function LinkClicked(id) {
    $(".content").scrollTop(1);
    $('.nav-tabs a:first').tab('show');
    $("#formCollectionCategory :input:not(:button)").parent().removeClass('has-error');
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
        $('#btnNextScreenSave').show();
    }
    $('#spnActionType').text(action);
    var primaryId = $('#primaryID').val();

    if (primaryId != null && primaryId != "0") {
        $.get("/api/CollectionCategory/Get/" + primaryId)
            .done(function (result) {
                var getResult = JSON.parse(result);
                fillDetails(getResult);
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

$("#jQGridCollapse1").click(function () {
    var pro = new Promise(function (res, err) {
        $(".jqContainer").toggleClass("hide_container");
        res(1);
    })
    pro.then(
        function resposes() {
            setTimeout(() => $(".content").scrollTop(3000), 1);
        })
});

function addUserArea(num)
{
    var checkbox = '<td style="text-align:center"><input type="checkbox" id="isDelete' + num + '" name="isDelete" /><input type="hidden" value="0" id="hdnCollectionUserAreaId' + num + '"  /></td>';
    var UserAreaCode = '<td id="UserAreaCode"> <input type="text" required class="form-control clsUserAreaCode" placeholder="Please Select" id="txtUserAreaCode' + num + '" autocomplete="off" name="User Area Code" maxlength="25"  /> <input type = "hidden" id="hdnUserAreaId' + num + '" />' + '<div class="col-sm-12" id="divUserAreaFetch' + num + '">   </div> </td>';
    var UserAreaName = '<td> <input type="text"  class="form-control" disabled="disabled" id="txtUserAreaName' + num + '" autocomplete="off" name="User Area Name" maxlength="25"  /></td>';
    var Remarks = '<td> <input type="text"  class="form-control" id="txtRemarks' + num + '" autocomplete="off" name="Remarks" maxlength="25"  /></td>';

    $("#tbodyUserArea").append('<tr>' + checkbox + UserAreaCode + UserAreaName + Remarks + '</tr>');
}

function fillDetails(result) {

    if (result != undefined) {

        $("#primaryID").val(result.RouteCollectionId);
        $('#txtRouteCode').val(result.RouteCode);
        $('#txtRouteDescription').val(result.RouteDescription);
        $('#ddlRouteCategory').val(result.RouteCategory);
        $('#ddlStatus').val(result.Status);

        rowNum = 1;
        $('#tbodyUserArea').html('');
        if (result.CollectionCategoryList != null) {
            for (var i = 0; i < result.CollectionCategoryList.length; i++) {

                addUserArea(rowNum);

                $('#hdnCollectionUserAreaId' + rowNum).val(result.CollectionCategoryList[i].RouteCollectionUserAreaId);
                $('#txtUserAreaCode' + rowNum).val(result.CollectionCategoryList[i].UserAreaCode);
                $('#txtUserAreaName' + rowNum).val(result.CollectionCategoryList[i].UserAreaName);
                $('#txtRemarks' + rowNum).val(result.CollectionCategoryList[i].Remarks);
                rowNum += 1;
            }
        }
        else {
            addUserArea(rowNum);
        }
    }
}

