var ckNewRowPaginationValidation;
var _pageSize;
var SetPaginationValues;

function AddNewRowToDataGrid(inputpar) {
    var maxindexval = 0;
    var _idwithElement = inputpar.TargetId;
    $.each(inputpar.TargetElement, function (index, data) {
        if (data)
            _idwithElement += ' ' + data
    });
    $(_idwithElement).each(function () {
        maxindexval = $(this).index() + 1;
    });
    var _html = inputpar.inlineHTML.replace(/maxindexval/g, maxindexval.toString());
    $(_html);
    $(inputpar.TargetId).append(_html);
 

}


function CreateFooterPagination(obj) {
    var html = '<div class="row paginationdiv">' +
    '<div class="col-sm-12">' +
       ' <div class="well">' +
           ' <div class="col-sm-3">&nbsp;</div>' +
            '<div class="col-sm-6 text-center pghover">' +
            "<span id='ShowFirstPageid' onclick='ShowFirstPage(" + JSON.stringify(obj) + ")'" +
                    '  class="glyphicon glyphicon-fast-backward" aria-hidden="true">' +
                '</span>' +
               "<span id='ShowPreviousPageid' onclick='ShowPreviousPage(" + JSON.stringify(obj) + ")'" +
                    '   class="glyphicon glyphicon-backward" aria-hidden="true">' +
                '</span>&nbsp;&nbsp;&nbsp;&nbsp;' +

               ' <span>Page&nbsp;</span>' +
               " <input onchange='PageNumberChanged(" + JSON.stringify(obj) + ")' " + 'type="text" size="2"  id="Id_PageNumber"  value="' + obj.PageNumber + '"/>' +

                '<span >&nbsp; of&nbsp; ' + obj.TotalPages + ' </span>&nbsp;&nbsp;&nbsp;&nbsp;' +

                "<span id='ShowNextPageid' onclick='ShowNextPage(" + JSON.stringify(obj) + ")'" +
                     '  class="glyphicon glyphicon-forward" >' +
                '</span>' +
                "<span id='ShowLastPageid' onclick='ShowLasttPage(" + JSON.stringify(obj) + ")'" +
                     '  class="glyphicon glyphicon-fast-forward" >' +
                '</span>&nbsp;&nbsp;&nbsp;&nbsp;' +
                "<select  onchange='pageSizeChanged(" + JSON.stringify(obj) + ")' id='Id_PageSize'  >" + '<option value=5>5</option><option value=10>10</option><option value=20>20</option><option value=50>50</option>' + '</select>' +
           ' </div>' +
            '<div class="col-sm-3 text-right" >View ' + obj.FirstRecord + ' to ' + obj.LastRecord + ' of ' + obj.GridtotalRecords + '</div>' +
            '<div class="clearfix"></div>' + " <input " + 'type="hidden" id="Id_TotPag"  value="' + obj.TotalPages + '"/>' +
       ' </div></div></div>';
    $(obj.destionId).empty();/*Clears the dom elements which were appended previously*/
    $(obj.destionId).append(html);

    if (pageindex >= obj.TotalPages) {
        //pageindex = obj.pageindex = obj.TotalPages;
        // bootbox.alert("There are no more record to display");
        // return false;
        $("#ShowNextPageid").hide();
        $("#ShowLastPageid").hide();

    }
    else {
        $("#ShowNextPageid").show();
        $("#ShowLastPageid").show();
    }
    if (pageindex <= 1) {
        //pageindex = obj.pageindex = 0;
        // bootbox.alert("You are already in first page");
        $("#ShowPreviousPageid").hide();
        $("#ShowFirstPageid").hide();

    }
    else {
        $("#ShowPreviousPageid").show();
        $("#ShowFirstPageid").show();
    }

}

function pageSizeChanged(obj) {
    if (ckNewRowPaginationValidation == true) {
        var message = "The changes you made will be lost! Do you want to continue?";
        bootbox.confirm(message, function (result) {
            if (result) {
                ckNewRowPaginationValidation = false;
                pageSizeChangedgetValue(obj);
            }              

        });
    }
    else {
        pageSizeChangedgetValue(obj);
    }
}



function pageSizeChangedgetValue(obj) {
    obj.pagesize = $("#Id_PageSize").val();
    obj.pageindex = 1;
    var uriarray = obj.geturl.split('/');
    //obj.geturl = '';
    //for (var i = 0; i < uriarray.length; i++)
    //{
    //    if (i < (uriarray.length-1))
    //        obj.geturl += uriarray[i] + '/';

    //}

    if (obj.IsPostType) {
        obj.getobj.pageindex = 1;
        obj.getobj.pagesize = obj.pagesize;
        var jqxhr = $.post(obj.geturl, obj.getobj, function (response) {
            var result = JSON.parse(response);
            $(obj.tableid).empty();
            var list = result[obj.ListName];
            bindValue(list, obj);
            $("#Id_PageSize").val(obj.getobj.pagesize);
            $('#myPleaseWait').modal('hide');
        },
 "json")
 .fail(function (response) {
     var errorMessage = "";
     if (response.status == 400) {
         errorMessage = response.responseJSON;
     }
     else {
         errorMessage = Messages.COMMON_FAILURE_MESSAGE;
     }
     $("div.errormsgcenter").text(errorMessage);
     $('#errorMsg').css('visibility', 'visible');
     $('#myPleaseWait').modal('hide');
 });

    }
    else {
        $.ajax({

            url: obj.geturl + "/" + obj.pagesize + "/" + obj.pageindex,
            type: 'GET',
            // dataType: 'json',
            //data: obj,
            success: function (response) {
                var result = JSON.parse(response);
                $(obj.tableid).empty();
                var list = result[obj.ListName];/*obj.ListName will hold the child list (data grid list's name)*/
                bindValue(list, obj);/*dynamic binding of data done*/
                /* Added for any specific conditions in grid*/
                //bindGridConditions(list, obj);

                $("#Id_PageSize").val(obj.pagesize);
                $('#myPleaseWait').modal('hide');
            },

            error: function (response) {
                var errorMessage = "";
                if (response.status == 400) {
                    errorMessage = response.responseJSON;
                }
                else {
                    errorMessage = Messages.COMMON_FAILURE_MESSAGE;
                }
                $("div.errormsgcenter").text(errorMessage);
                $('#errorMsg').css('visibility', 'visible');
                $('#btnSave').attr('disabled', false);
                $('#myPleaseWait').modal('hide');
            }
        });
    }
}



function bindValue(list, obj) {
    try {
        var _html = '';
        var _list = list;
        $(_list).each(function (index, data) {
            _html = obj.htmltext.replace(/maxindexval/g, index.toString());/*Relaces "maxindexval" with appropriate index value*/

            $(obj.tableid).append(_html);
            bindLovfordropdown(obj, index);/*bind the lov <options> to the dropdown field NOTE: EACH DROPDOWN HAS TO BE DEFINED MANUALLY WITH "flag" separation*/
            $(obj.mapIdproperty).each(function (_index, _data) {/*mapIdproperty is an array for HTMLID - PROPERTY pairs*/

                var htmlid = _data.split('-')[1];
                htmlid = '#' + htmlid + index;
                if (obj.IsView) {
                    $(htmlid).prop("disabled", true);
                    $("#IsDeleted_" + index).prop("disabled", true);
                }
                var property = _data.split('-')[0];
                var IsDatefield;
                var IsCheckbox = false;
                if (_data.split('-')[2]) {
                    var type = _data.split('-')[2] ? _data.split('-')[2] : '';
                    if (type == "date") {
                        IsDatefield = (_data.split('-')[2]).toLowerCase().indexOf('date') > -1 ? true : false;
                    }
                    else if (type == "checkbox") {
                        IsCheckbox = true;
                    }
                }
                if (IsDatefield) {
                    if (data[property])
                        $(htmlid).val(DateFormatter(data[property]));
                    else
                        $(htmlid).val('');
                }
                else if (IsCheckbox) {
                    if (data[property])
                        $(htmlid).prop('checked', data[property]);
                    else
                        $(htmlid).val('');
                }
                else {
                    if (data[property])
                        $(htmlid).val(data[property]);
                    else
                        $(htmlid).val('');
                }
            });

            /* Added for any specific conditions in grid*/
            bindGridConditions(list, obj);

            obj.TotalPages = data.TotalPages;
            obj.FirstRecord = data.FirstRecord;
            obj.LastRecord = data.LastRecord;
            obj.PageNumber = data.PageIndex;
            //obj.getobj.pageindex = obj.pageindex = data.PageIndex;
            //obj.getobj.pagesize = obj.pagesize = data.PageSize;
        });
        CreateFooterPagination(obj);
        if (_pageSize)
            $("#Id_PageSize").val(_pageSize);
        else {
            $("#Id_PageSize").val(5);
        }
        obj.htmltext; obj.mapIdproperty;
    }
    catch (s) {
        
    }
}

function ShowFirstPage(obj) {
    if (ckNewRowPaginationValidation == true) {
        var message = "The changes you made will be lost! Do you want to continue?";
        bootbox.confirm(message, function (result) {
            if (result) {
                ckNewRowPaginationValidation = false;
                ShowFirstPagegetValue(obj);
            }

        });
    }
    else {
        ShowFirstPagegetValue(obj);
    }
   

}


function ShowFirstPagegetValue(obj) {
    _pageSize = $("#Id_PageSize").val();
    pageindex = 1;

    if (obj.IsPostType) {
        obj.getobj.pageindex = pageindex;
        var jqxhr = $.post(obj.geturl, obj.getobj, function (response) {
            var result = JSON.parse(response);
            $(obj.tableid).empty();
            var list = result[obj.ListName];
            bindValue(list, obj);
            $('#myPleaseWait').modal('hide');
        },
 "json")
 .fail(function (response) {
     var errorMessage = "";
     if (response.status == 400) {
         errorMessage = response.responseJSON;
     }
     else {
         errorMessage = Messages.COMMON_FAILURE_MESSAGE;
     }
     $("div.errormsgcenter").text(errorMessage);
     $('#errorMsg').css('visibility', 'visible');



     $('#myPleaseWait').modal('hide');
 });

    }
    else {
        var url = obj.geturl + "/" + _pageSize + "/" + pageindex;
        $.ajax({

            url: url,
            type: 'GET',
            // dataType: 'json',
            //data: obj,
            success: function (response) {
                var result = JSON.parse(response);
                $(obj.tableid).empty();
                var list = result[obj.ListName];
                bindValue(list, obj);
                $('#myPleaseWait').modal('hide');
            },
            error: function (response) {
                var errorMessage = "";
                if (response.status == 400) {
                    errorMessage = response.responseJSON;
                }
                else {
                    errorMessage = Messages.COMMON_FAILURE_MESSAGE;
                }
                $("div.errormsgcenter").text(errorMessage);
                $('#errorMsg').css('visibility', 'visible');
                $('#btnSave').attr('disabled', false);
                $('#myPleaseWait').modal('hide');
            }

        });

    }
}

function ShowPreviousPage(obj) {
    if (ckNewRowPaginationValidation == true) {
        var message = "The changes you made will be lost! Do you want to continue?";
        bootbox.confirm(message, function (result) {
            if (result) {
                ckNewRowPaginationValidation = false;
                ShowPreviousPagegetValue(obj);
            }

        });
    }
    else {
        ShowPreviousPagegetValue(obj);
    }   
}


function ShowPreviousPagegetValue(obj) {
    _pageSize = $("#Id_PageSize").val();
    pageindex = obj.pageindex = pageindex < 0 || pageindex == 0 || !pageindex ? 1 : pageindex - 1;
    if (obj.pageindex <= 0) {
        pageindex = obj.pageindex = 0;
        // bootbox.alert("You are already in first page");
        // $("#ShowPreviousPageid").prop("disabled", true);
        return false;
    }
    if (obj.IsPostType) {
        obj.getobj.pageindex = obj.getobj.pageindex = obj.getobj.pageindex < 0 || obj.getobj.pageindex == 0 || !obj.getobj.pageindex ? 1 : obj.getobj.pageindex - 1;
        var jqxhr = $.post(obj.geturl, obj.getobj, function (response) {
            var result = JSON.parse(response);
            $(obj.tableid).empty();
            var list = result[obj.ListName];
            bindValue(list, obj);
            $('#myPleaseWait').modal('hide');
        },
 "json")
 .fail(function (response) {
     var errorMessage = "";
     if (response.status == 400) {
         errorMessage = response.responseJSON;
     }
     else {
         errorMessage = Messages.COMMON_FAILURE_MESSAGE;
     }
     $("div.errormsgcenter").text(errorMessage);
     $('#errorMsg').css('visibility', 'visible');
     $('#myPleaseWait').modal('hide');
 });

    }
    else {
        var url = obj.geturl + "/" + _pageSize + "/" + obj.pageindex;
        $.ajax({

            url: url,
            type: 'GET',
            // dataType: 'json',
            //data: obj,
            success: function (response) {
                var result = JSON.parse(response);
                $(obj.tableid).empty();
                var list = result[obj.ListName];
                bindValue(list, obj);
                $('#myPleaseWait').modal('hide');
            },
            error: function (response) {
                var errorMessage = "";
                if (response.status == 400) {
                    errorMessage = response.responseJSON;
                }
                else {
                    errorMessage = Messages.COMMON_FAILURE_MESSAGE;
                }
                $("div.errormsgcenter").text(errorMessage);
                $('#errorMsg').css('visibility', 'visible');
                $('#btnSave').attr('disabled', false);
                $('#myPleaseWait').modal('hide');
            }

        });
    }
}

function ShowNextPage(obj) {
    if (ckNewRowPaginationValidation == true) {
        var message = "The changes you made will be lost! Do you want to continue?";
        bootbox.confirm(message, function (result) {
            if (result) {
                ckNewRowPaginationValidation = false;
                ShowNextPagegetValue(obj);
            }

        });
    }
    else {
        ShowNextPagegetValue(obj);
    }
}


function ShowNextPagegetValue(obj) {
    _pageSize = $("#Id_PageSize").val();
    pageindex = obj.pageindex = pageindex + 1;

    if (obj.pageindex > obj.TotalPages) {
        pageindex = obj.pageindex = obj.TotalPages;
        bootbox.alert("There are no more record to display");
        return false;
    }

    if (obj.IsPostType) {
        obj.getobj.pageindex = pageindex;
        var jqxhr = $.post(obj.geturl, obj.getobj, function (response) {
            var result = JSON.parse(response);
            $(obj.tableid).empty();
            var list = result[obj.ListName];
            bindValue(list, obj);
            $('#myPleaseWait').modal('hide');
        },
 "json")
 .fail(function (response) {
     var errorMessage = "";
     if (response.status == 400) {
         errorMessage = response.responseJSON;
     }
     else {
         errorMessage = Messages.COMMON_FAILURE_MESSAGE;
     }
     $("div.errormsgcenter").text(errorMessage);
     $('#errorMsg').css('visibility', 'visible');
     $('#myPleaseWait').modal('hide');
 });

    }
    else {
        var url = obj.geturl + "/" + _pageSize + "/" + obj.pageindex;
        $.ajax({

            url: url,
            type: 'GET',
            //dataType: 'json',
            // data: obj,
            success: function (response) {
                var result = JSON.parse(response);
                console.log(result);
                //result["ItemMstFetchEntityList"]
                console.log(result[obj.ListName]);
                $(obj.tableid).empty();
                //bindDatatoDatagrid(result[obj.ListName])

                var list = result[obj.ListName];
                bindValue(list, obj);
                $('#myPleaseWait').modal('hide');
                //setTimeout(function () {
                //    $("#top-notifications").modal('hide');
                //}, 5000);
                //$('#btnSave').attr('disabled', false);
                //$('#myPleaseWait').modal('hide');
            },

            error: function (response) {
                var errorMessage = "";
                if (response.status == 400) {
                    errorMessage = response.responseJSON;
                }
                else {
                    errorMessage = Messages.COMMON_FAILURE_MESSAGE;
                }
                $("div.errormsgcenter").text(errorMessage);
                $('#errorMsg').css('visibility', 'visible');
                $('#btnSave').attr('disabled', false);
                $('#myPleaseWait').modal('hide');
            }

        });
    }
}

function ShowLasttPage(obj) {
    if (ckNewRowPaginationValidation == true) {
        var message = "The changes you made will be lost! Do you want to continue?";
        bootbox.confirm(message, function (result) {
            if (result) {
                ckNewRowPaginationValidation = false;
                ShowLastPagegetValue(obj);
            }

        });
    }
    else {
        ShowLastPagegetValue(obj);
    }

}


function ShowLastPagegetValue(obj) {
    _pageSize = $("#Id_PageSize").val();
    pageindex = obj.TotalPages;

    if (obj.IsPostType) {
        obj.getobj.pageindex = pageindex;
        var jqxhr = $.post(obj.geturl, obj.getobj, function (response) {
            var result = JSON.parse(response);

            $(obj.tableid).empty();

            var list = result[obj.ListName];

            bindValue(list, obj);

            $('#myPleaseWait').modal('hide');
        },
 "json")
 .fail(function (response) {
     var errorMessage = "";
     if (response.status == 400) {
         errorMessage = response.responseJSON;
     }
     else {
         errorMessage = Messages.COMMON_FAILURE_MESSAGE;
     }
     $("div.errormsgcenter").text(errorMessage);
     $('#errorMsg').css('visibility', 'visible');



     $('#myPleaseWait').modal('hide');
 });


    }
    else {
        var url = obj.geturl + "/" + _pageSize + "/" + pageindex;
        $.ajax({

            url: url,

            type: 'GET',

            //dataType: 'json',

            // data: obj,

            success: function (response) {
                var result = JSON.parse(response);
                console.log(result);
                //result["ItemMstFetchEntityList"]
                console.log(result[obj.ListName]);
                $(obj.tableid).empty();
                //bindDatatoDatagrid(result[obj.ListName])

                var list = result[obj.ListName];

                bindValue(list, obj);
                $('#myPleaseWait').modal('hide');
                //setTimeout(function () {
                //    $("#top-notifications").modal('hide');
                //}, 5000);
                //$('#btnSave').attr('disabled', false);
                //$('#myPleaseWait').modal('hide');
            },

            error: function (response) {
                var errorMessage = "";
                if (response.status == 400) {
                    errorMessage = response.responseJSON;
                }
                else {
                    errorMessage = Messages.COMMON_FAILURE_MESSAGE;
                }
                $("div.errormsgcenter").text(errorMessage);
                $('#errorMsg').css('visibility', 'visible');
                $('#btnSave').attr('disabled', false);
                $('#myPleaseWait').modal('hide');
            }

        });
    }
}


function bindLovfordropdown(obj, index) {
    if (obj.flag == "StockUpdateregBEMS") {
        $(LOVlist.SparepartTypeList).each(function (_index, _data) {
            $('#SaprePartType_' + index + '').append($('<option></option>').val(_data.LovId).html(_data.FieldValue))
        });
        AffectBasedonApproveAccess();
        $(LOVlist.SparepartLocationList).each(function (_index, _data) {
            $('#SPLocation_' + index + '').append($('<option></option>').val(_data.LovId).html(_data.FieldValue))
        });
        
    }

    else if (obj.flag == "ParMapBEMS") {

        LoadLoV(LOVData.UOM, 'ParamMapUom_' + index, true);
        LoadLoV(LOVData.DataType, 'ParamMapDataType_' + index, true);
        LoadLoV(LOVData.Frequency, 'ParamMapFreq_' + index, true);
        //LoadLoV(LOVData.Status, 'ParamMapEffTo_' + index, true);

        $.each(LOVData.Status, function (i, value) {
            $('#ParamMapEffTo_' + index).append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
        });
        //$.each(LOVData.Frequency, function (i, value) {
        //    $('#ParamMapFreq_' + index).append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
        //});
    }

    else if (obj.flag == "FacilityWorkshop") {

        //$('#FWLocation').empty().append('<option value="">Select</option>');
        $.each(LOVlist.LocationLovs, function (i, value) {
            // $('#FWLocation_' + rowCount).empty().append('<option value="">Select</option>');
            $('#FWLocation_' + index).append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
        });
    }

    else if (obj.flag == "CORAssetList") {
        $(LOVlist.ContractTypeValueList).each(function (_index, _data) {
            $('#ContractType_' + index + '').append($('<option></option>').val(_data.LovId).html(_data.FieldValue))

        });
    }

    else if (obj.flag == "QualityCauseflag") {
        $('#chk_QualityCauseMasterdet').prop("checked", false);
        $(LOVlist.QualityProblemTypeData).each(function (_index, _data) {
            $('#ProblemCode_' + index + '').append($('<option></option>').val(_data.LovId).html(_data.FieldValue));
        });

        $(LOVlist.QualityStatusTypeData).each(function (_index, _data) {
            $('#QualityStatus_' + index + '').append($('<option></option>').val(_data.LovId).html(_data.FieldValue));
        });      
    }
    else if (obj.flag == "VVFflag") {
           $(LOVlist.ActionList).each(function (_index, _data) {
               $('#Action_' + index + '').append($('<option></option>').val(_data.LovId).html(_data.FieldValue));
        });        
    }

}

/************************** Generating Conditions in Grid for Each Screen ************************************/

function bindGridConditions(list, obj) {

    if (obj.flag == "StockUpdateregBEMS") {
        $('#chk_stkUpdateregdet').prop("checked", false);
        var _html = '';
        var _list = list;
        $(_list).each(function (index, data) {
            _html = obj.htmltext.replace(/maxindexval/g, index.toString());/*Relaces "maxindexval" with appropriate index value*/
           
            if (data.IsDeleteReference == true) {
                $("#Isdeleted_" + index).prop("disabled", "disabled");
            } 

            var Eslife = $('#EstimatedLifeSpan_' + index).val();
            var Esstkexpdate = $("#StockExpiry_" + index).val();
            if ((Eslife == "" && Esstkexpdate == "") || (Eslife == "null" && Esstkexpdate == "null") || (Eslife == null && Esstkexpdate == null)) {
                $("#EstimatedLifeSpan_" + index).prop("disabled", "disabled");
                $("#StockExpiry_" + index).prop("disabled", "disabled");
            }
            else if (Eslife == "" || Eslife == null || Eslife == "null") {
                $("#EstimatedLifeSpan_" + index).prop("disabled", "disabled");
                $("#StockExpiry_" + index).prop("disabled", false);
            }
            else if (Esstkexpdate == "" || Esstkexpdate == null || Esstkexpdate == "null") {
                $("#EstimatedLifeSpan_" + index).prop("disabled", false);
                $("#StockExpiry_" + index).prop("disabled", "disabled");
            }

            $("#partno_" + index).prop("disabled", "disabled");
            $("#SaprePartType_" + index).prop("disabled", "disabled");
            $("#SPLocation_" + index).prop("disabled", "disabled");
            $("#EstimatedLifeSpan_" + index).prop("disabled", "disabled");
            $("#StockExpiry_" + index).prop("disabled", "disabled");
            $("#Quantity_" + index).prop("disabled", "disabled");
            $("#Cost_" + index).prop("disabled", "disabled");
            $("#PurchaseCost_" + index).prop("disabled", "disabled");
            $("#InvoiceNo_" + index).prop("disabled", "disabled");
            $("#VendorName_" + index).prop("disabled", "disabled");
            $("#BinNo_" + index).prop("disabled", "disabled");
            $("#Remarks_" + index).prop("disabled", "disabled");

        });
    }


    if (obj.flag == "ParMapBEMS") {
        var _html = '';
        var _list = list;
        $(_list).each(function (index, data) {
            _html = obj.htmltext.replace(/maxindexval/g, index.toString());/*Relaces "maxindexval" with appropriate index value*/

            //var EffDat = list[index].IsEffectiveDateNull ? "" : list[index].EffectiveTo;
            //$('#ParamMapEffTo_' + index).val(EffDat).format("YYYY-MMM-DD");

            if (list[index].DatatypeId == 176) {
                $('#ParamMapAlphaNum_' + index).prop("disabled", true)
                $('#ParamMapMin_' + index).prop("disabled", false);
                $('#ParamMapMax_' + index).prop("disabled", false);
            }
            else if (list[index].DatatypeId == 178) {
                $('#ParamMapAlphaNum_' + index).prop("disabled", false)
                $('#ParamMapMin_' + index).prop("disabled", true);
                $('#ParamMapMax_' + index).prop("disabled", true);
            }
            else if (list[index].DatatypeId == 177) {
                $('#ParamMapAlphaNum_' + index).prop("disabled", true)
                $('#ParamMapMin_' + index).prop("disabled", true);
                $('#ParamMapMax_' + index).prop("disabled", true);
            }

            $('#EODParamMappingBody tr').each(function (index, value) {
                $('#ParamMapDataType_' + index).change(function () {
                    if ($('#ParamMapDataType_' + index).val() == 177 || $('#ParamMapDataType_' + index).val() == 178) {
                        $('#ParamMapAlphaNum_' + index).prop("disabled", false)
                        $('#ParamMapMin_' + index).prop("disabled", true);
                        $('#ParamMapMax_' + index).prop("disabled", true);
                        $('#ParamMapMin_' + index).val('');
                        $('#ParamMapMax_' + index).val('');
                    }
                    else if ($('#ParamMapDataType_' + index).val() == 176) {
                        $('#ParamMapAlphaNum_' + index).prop("disabled", true)
                        $('#ParamMapMin_' + index).prop("disabled", false);
                        $('#ParamMapMax_' + index).prop("disabled", false);
                        $('#ParamMapAlphaNum_' + index).val('');
                    }

                });
            });

            if (list[index].Isreferenced == true) {
                if (list[index].DatatypeId == 176) {
                    IsChkReferencedNum(index, null);
                }
                else if (list[index].DatatypeId == 177 || list[index].DatatypeId == 178) {
                    IsChkReferencedAlpDrp(index, null);
                }
            }

            $('#ParamMapEffTo_' + index).val(list[index].StatusId);

           // $('#ParamMapEffTo_' + index).val(list[index].StatusId);

            //if (list[index].IsEffectiveDateFilled == false) {
            //    $('#hdnIsEffToDateFilled_' + index).val('0');
            //    $('#ParamMapEffTo_' + index).prop('disabled', true);
            //}
            //else {
            //    $('#hdnIsEffToDateFilled_' + index).val('1');
            //}

            $('#ParamMapDataType_' + index).prop("disabled", true);

        });
        if (ActionType == "VIEW") {
            $("#EODParamMappingScreen :input:not(:button)").prop("disabled", true);
            //$("#addnewrowbtn,#savebtn,#uploadbtn,#exportbtn,#addnewbtn").hide();
        }



    }

    else if (obj.flag == "FacilityWorkshop") {
        var rowCount = $('#FacilityWorkshopTbl tr:last').index();
        var FacilityType = $('#FacilityworkFacilityType').val();
        var category = $('#FacilityworkCategory').val()

        if (FacilityType == 101) {
            FacTypeResCen(rowCount, null)
        }
        else if (FacilityType == 102) {
            FacTypeStorage(rowCount, null);
        }
        else if (FacilityType == 103) {
            FacTypeWorkshop(rowCount, null);
        }

        if (category == 104) {
            CatEquipRepair(rowCount, null);
        }
        else if (category == 107) {
            CatLoaner(rowCount, null)
        }
        else if (category == 108) {
            CatMachinery(rowCount, null);
        }
        else if (category == 109) {
            CatTestEquip(rowCount, null);
        }
        else if (category == 110) {
            CatTools(rowCount, null);
        }
        else {
            CatRest(rowCount, null);
        }

        var _list = list;
        $(_list).each(function (index, data) {
            _html = obj.htmltext.replace(/maxindexval/g, index.toString());/*Relaces "maxindexval" with appropriate index value*/
 
        $('#FWLocation_' + rowCount + ' option[value="' + list[index].LocationId + '"]').prop('selected', true);
        });

        if (ActionType == "VIEW") {
            $("#FacilityWorkshopForm :input:not(:button)").prop("disabled", true);
        }

        $("#chk_FacWorkIsDelete").prop("checked", false);
    }

    else if (obj.flag == "Stockadjustmentflag") {
        $('#chk_stkadjustmentdet').prop("checked", false);
        var _html = '';
        var _list = list;
        $(_list).each(function (index, data) {
            _html = obj.htmltext.replace(/maxindexval/g, index.toString());/*Relaces "maxindexval" with appropriate index value*/

            if ((list[index].ApprovalStatus == 75) || (list[index].ApprovalStatus == 76) || (list[index].ApprovalStatus == 77)) {
                $("#chk_stkadjustmentdet").prop("disabled", "disabled");
                $("#Isdeleted_" + index).prop("disabled", "disabled");
                $("#physicalqty_" + index).prop("disabled", "disabled");
               // $("#remarks_" + index).prop("disabled", "disabled");
            }
            if ((list[index].ApprovalStatus == 76) || (list[index].ApprovalStatus == 77)) {
                $("#remarks_" + index).prop("disabled", "disabled");
            }

            $('#StkAdjustmentTbl tr').each(function (index, value) {
                $("#partno_" + index).prop("disabled", "disabled");
            });
        });
        if (ActionType == "View") {
            $("#StockAdjustmentFrom :input:not(:button)").prop("disabled", true);
        }
    }

    if (obj.flag == "ScheduleResultId") {
        var _html = '';
        var _list = list;
        var TOP = obj.TOP;
        var _index;        // var _indexThird;
        var result = [];
        $('#ScheduleResultId tr').each(function () {
            _index = $(this).index();
        });

        for (var i = 0; i <= _index; i++) {
            if (TOP == "PPM" || TOP == "PDM" || TOP == "Calibration" || TOP == "Radiology QC") {
                $('#RIHeadHide').hide();
                $("#RIBodyHide_" + i).hide();
                $('#PPMHeadHide').show();
                $("#PPMBodyHide_" + i).show();
                $('#PPMHeadHide1').show();
                $("#PPMBodyHide1_" + i).show();

                $("#PPMHeadHide").attr('width', "28%");
                $("#PPMBodyHide_" + i).attr('width', "28%");
                //$("#WorkOrderDate_" + i).val(moment($("#WorkOrderDate_" + i).val()).format("DD-MMM-YYYY")).prop("disabled", true);
               // $("#TargetDate_" + i).val(moment($("#TargetDate_" + i).val()).format("DD-MMM-YYYY")).prop("disabled", true);
            }
            else if (TOP == "RI") {
                $('#PPMHeadHide').hide();
                $("#PPMBodyHide_" + i).hide();
                $('#PPMHeadHide1').hide();
                $("#PPMBodyHide1_" + i).hide();

                $('#RIHeadHide').show();
                $("#RIBodyHide_" + i).show();

                $('#RIHeadHide').attr('width', "42%");
                $("#RIBodyHide_" + i).attr('width', "42%");
               // $("#WorkOrderDate_" + i).val(moment($("#WorkOrderDate_" + i).val()).format("DD-MMM-YYYY")).prop("disabled", true);
               // $("#TargetDate_" + i).val(moment($("#TargetDate_" + i).val()).format("DD-MMM-YYYY")).prop("disabled", true);
            }
        }
        $(_list).each(function (index, data) {
            $("#WorkOrderDate_" + index).val(moment(data.WorkOrderDate).format("DD-MMM-YYYY")).prop("disabled", true);
            $("#TargetDate_" + index).val(moment(data.TargetDate).format("DD-MMM-YYYY")).prop("disabled", true);
        });

    }

    if (obj.flag == "Usertrainingdetails") {
        var _html = '';
        var _list = list;
        $(_list).each(function (index, data) {
            _html = obj.htmltext.replace(/maxindexval/g, index.toString());/*Relaces "maxindexval" with appropriate index value*/

            //var EffDat = list[index].IsEffectiveDateNull ? "" : list[index].EffectiveTo;
            //$('#ParamMapEffTo_' + index).val(EffDat).format("YYYY-MMM-DD");



            if (list[index].IsConfirmed == true) {

                $("#UserTraiCopmPage :input:not(:button)").prop("disabled", true);
                $('#btnConfirmVerify').hide();
                $('#btnEdit').hide();
                $('#btnSave').hide();
                $('#btnSaveandAddNew').hide();
                $('#UserTrainAddrow').hide();

                $('#Isdeleted_' + index).prop('disabled', true);
                $('#UserTrainCompParName_' + index).prop('disabled', true);

            }

        });
    }

    if (obj.flag == "CRMRequest") {
        var _html = '';
        var _list = list;
        $(_list).each(function (index, data) {
            _html = obj.htmltext.replace(/maxindexval/g, index.toString());/*Relaces "maxindexval" with appropriate index value*/

            //if (list[index].IsConfirmed == true) {
            //    $('#Isdeleted_' + index).prop('disabled', true);
            //    $('#UserTrainCompParName_' + index).prop('disabled', true);

            //}
            sts = $('#hdnCrmReqChkstsApp').val();
            if (sts == "Approve") {
                disableGridFields(index, null);
                $('#chk_CrmReq').prop('disabled', true);                
            }
            reqsts = $('#RequestStatus').val();
            if (reqsts != 139) {
                disableGridFields(index, null);
                $('#chk_CrmReq').prop('disabled', true);

            }

        });
    }

    if (obj.flag == "BulkAuthorization") {
        var _html = '';
        var _list = list;
        $(_list).each(function (index, data) {
            _html = obj.htmltext.replace(/maxindexval/g, index.toString());/*Relaces "maxindexval" with appropriate index value*/
            $("#AssetNo_" + index).val(data.AssetNo).prop('title', data.AssetNo);
            $("#AssetDescription_" + index).val(data.AssetDescription).prop('title', data.AssetDescription);
            $("#UserLocationName_" + index).val(data.UserLocationName).prop('title', data.UserLocationName);
            $("#SNFDocumentNo_" + index).val(data.SNFDocumentNo).prop('title', data.SNFDocumentNo);
            $("#VariationStatus_" + index).val(data.VariationStatus).prop('title', data.VariationStatus);
            $("#CommissioningDate_" + index).val(data.CommissioningDate).prop('title', DateFormatter(data.CommissioningDate));
            $("#CommissioningDate_" + index).val(DateFormatter(data.CommissioningDate));            
            $("#StartServiceDate_" + index).val(data.StartServiceDate).prop('title', DateFormatter(data.StartServiceDate));
            $("#StartServiceDate_" + index).val(DateFormatter(data.StartServiceDate));
            $("#WarrantyEndDate_" + index).val(data.WarrantyEndDate).prop('title', DateFormatter(data.WarrantyEndDate));
            $("#WarrantyEndDate_" + index).val(DateFormatter(data.WarrantyEndDate));
            $("#VariationDate_" + index).val(data.VariationDate).prop('title', DateFormatter(data.VariationDate));
            $("#VariationDate_" + index).val(DateFormatter(data.VariationDate));
            $("#ServiceStopDate_" + index).val(data.ServiceStopDate).prop('title', DateFormatter(data.ServiceStopDate));
            $("#ServiceStopDate_" + index).val(DateFormatter(data.ServiceStopDate));
        });
    }
    if (obj.flag == "VVFflag") {
        var _html = '';
        var _list = list;
        $(_list).each(function (index, data) {
            _html = obj.htmltext.replace(/maxindexval/g, index.toString());/*Relaces "maxindexval" with appropriate index value*/
            $("#UserAreaName_" + index).val(data.UserAreaName).prop('title', data.UserAreaName);
            $("#AssetNo_" + index).val(data.AssetNo).prop('title', data.AssetNo);
            $("#Manufacturer_" + index).val(data.Manufacturer).prop('title', data.Manufacturer);
            $("#Model_" + index).val(data.Model).prop('title', data.Model);
            $("#PurchaseCost_" + index).val(data.PurchaseCost).prop('title', data.PurchaseCost);
            $("#VariationStatus_" + index).val(data.VariationStatus).prop('title', data.VariationStatus);
            $("#StartServiceDate_" + index).val(DateFormatter(data.StartServiceDate)).prop('title', DateFormatter(data.StartServiceDate));
            $("#WarrantyExpiryDate_" + index).val(DateFormatter(data.WarrantyExpiryDate)).prop('title', DateFormatter(data.WarrantyExpiryDate));
            $("#StopServiceDate_" + index).val(DateFormatter(data.StopServiceDate)).prop('title', DateFormatter(data.StopServiceDate));
            $("#MaintenanceRateDW_" + index).val(data.MaintenanceRateDW).prop('title', data.MaintenanceRateDW);
            $("#MaintenanceRatePW_" + index).val(data.MaintenanceRatePW).prop('title', data.MaintenanceRatePW);
            $("#MonthlyProposedFeeDW_" + index).val(data.MonthlyProposedFeeDW).prop('title', data.MonthlyProposedFeeDW);
            $("#MonthlyProposedFeePW_" + index).val(data.MonthlyProposedFeePW).prop('title', data.MonthlyProposedFeePW);
            $("#CountingDays_" + index).val(data.CountingDays).prop('title', data.CountingDays);
               $(LOVlist.ActionList).each(function (_index, _data) {
               $('#Action_' + index + '').append($('<option></option>').val(_data.LovId).html(_data.FieldValue));
        });  
        });
    }
    if (obj.flag == "Notificationlayout") {
        var _html = '';
        var _list = list;
        $(_list).each(function (index, data) {
            _html = obj.htmltext.replace(/maxindexval/g, index.toString());/*Relaces "maxindexval" with appropriate index value*/

            var a = moment.utc(data.NotificationDateTime).toDate();
            $("#DashboardNotificationDate_" + index).val(moment(a).format("DD-MMM-YYYY HH:mm"));

            //$("#DashboardNotificationDate_" + index).val(moment(data.NotificationDateTime).format("DD-MMM-YYYY HH:mm"));
        });
    }


    if (obj.flag == "ScheduleCompInfo") {
        var _html = '';
        var _list = list;
        $(_list).each(function (index, data) {
            _html = obj.htmltext.replace(/maxindexval/g, index.toString());/*Relaces "maxindexval" with appropriate index value*/

            var stdate = moment.utc(data.StartDate);
            var Eddate = moment.utc(data.EndDate);

            if (obj.WorkOrderStatusString == "Closed") {
                $('#EmployeeName_' + index).prop('disabled', true);
                $('#TaskCode_' + index).prop('disabled', true);
                $('#StartDate_' + index).val(moment(stdate).format("DD-MMM-YYYY HH:mm")).prop('disabled', true);
                $('#EndDate_' + index).val(moment(Eddate).format("DD-MMM-YYYY HH:mm")).prop('disabled', true);
                $('#PPMHours_' + index).val(data.PPMHoursTiming);
            }           
        });
    }

    if (obj.flag == "UnScheduleCompInfo") {
        var _html = '';
        var _list = list;
        $(_list).each(function (index, data) {
            _html = obj.htmltext.replace(/maxindexval/g, index.toString());/*Relaces "maxindexval" with appropriate index value*/

            var Unstdate = moment.utc(data.StartDate);
            var UnEddate = moment.utc(data.EndDate);

            if (obj.WorkOrderStatusString == "Closed") {
                $('#EmployeeName_' + index).prop('disabled', true);              
                $('#StartDate_' + index).val(moment(Unstdate).format("DD-MMM-YYYY HH:mm")).prop('disabled', true);
                $('#EndDate_' + index).val(moment(UnEddate).format("DD-MMM-YYYY HH:mm")).prop('disabled', true);
                $('#PPMHours_' + index).val(data.PPMHoursTiming);
            }
        });
    }

}

function LoadLoV(collection, id, IsselectReq) {
    if (IsselectReq == true) {
        $('#' + id).append('<option value="">' + "Select" + '</option>');
    }
    $.each(collection, function (index, value) {
        $('#' + id).append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');
    });

}

function PageNumberChanged(obj) {
    if (ckNewRowPaginationValidation == true) {
        var message = "The changes you made will be lost! Do you want to continue?";
        bootbox.confirm(message, function (result) {
            if (result) {
                ckNewRowPaginationValidation = false;
                PageNumberChangedgetValue(obj);
            }

        });
    }
    else {
        PageNumberChangedgetValue(obj);
    }
    

}

function PageNumberChangedgetValue(obj) {
    obj.pagesize = $("#Id_PageSize").val();
    var temppageindex = parseInt($("#Id_PageNumber").val());
    if (Number.isInteger(temppageindex)) {
        if (temppageindex <= obj.TotalPages && temppageindex > 0) {
            $("#Id_PageNumber").val(temppageindex);
        }
        else {
            $("#Id_PageNumber").val(1);
        }

    }
    else {
        $("#Id_PageNumber").val(1);
    }
    obj.pageindex = $("#Id_PageNumber").val();
    var uriarray = obj.geturl.split('/');
    //obj.geturl = '';
    //for (var i = 0; i < uriarray.length; i++)
    //{
    //    if (i < (uriarray.length-1))
    //        obj.geturl += uriarray[i] + '/';

    //}

    if (obj.IsPostType) {
        var jqxhr = $.post(obj.geturl, obj.getobj, function (response) {
            var result = JSON.parse(response);
            obj.getobj.pagesize = obj.pagesize;
           // obj.getobj.pageindex = $("#Id_PageNumber").val();
            $(obj.tableid).empty();

            var list = result[obj.ListName];

            bindValue(list, obj);
            $("#Id_PageSize").val(obj.getobj.pagesize);
            $('#myPleaseWait').modal('hide');
        },
 "json")
 .fail(function (response) {
     var errorMessage = "";
     if (response.status == 400) {
         errorMessage = response.responseJSON;
     }
     else {
         errorMessage = Messages.COMMON_FAILURE_MESSAGE;
     }
     $("div.errormsgcenter").text(errorMessage);
     $('#errorMsg').css('visibility', 'visible');
     $('#myPleaseWait').modal('hide');
 });

    }
    else {
        $.ajax({

            url: obj.geturl + "/" + obj.pagesize + "/" + obj.pageindex,
            type: 'GET',
            // dataType: 'json',
            //data: obj,
            success: function (response) {
                var result = JSON.parse(response);
                $(obj.tableid).empty();
                var list = result[obj.ListName];/*obj.ListName will hold the child list (data grid list's name)*/

                bindValue(list, obj);/*dynamic binding of data done*/

                /* Added for any specific conditions in grid*/
                //bindGridConditions(list, obj);

                $("#Id_PageSize").val(obj.pagesize);
                $('#myPleaseWait').modal('hide');
            },

            error: function (response) {
                var errorMessage = "";
                if (response.status == 400) {
                    errorMessage = response.responseJSON;
                }
                else {
                    errorMessage = Messages.COMMON_FAILURE_MESSAGE;
                }
                $("div.errormsgcenter").text(errorMessage);
                $('#errorMsg').css('visibility', 'visible');
                $('#btnSave').attr('disabled', false);
                $('#myPleaseWait').modal('hide');
            }
        });
    }
}

$("#History").click(function () {
    var Message = "No Records Found";
    $('#divCommonPagination').html(null);
    $('#showData').text(Message);
    $('#showData').css("text-align", "center");
    var pageIndex = 1;
    var pageSize = 5;
    var GuId = $('#hdnAttachId').val();
    
    $.get("/api/Common/History/" + GuId + "/" + pageIndex + "/" + pageSize)
        .done(function (response) {
            $('#myPleaseWait').modal('show');
            var result = response;
            var HistoryData=[];
            for (var i = 0; i < result.length; i++) {
                var TableRowData=JSON.parse(result[i].TableRowData);
                HistoryData = (HistoryData == null || HistoryData.length == 0) ? TableRowData : HistoryData.concat(TableRowData);
            }
            History(result,HistoryData);
            $('#myPleaseWait').modal('hide');
        }, "json")

});


SetPaginationValues = function (result) {
    var PageIndex = 0;
    var TotalRecords = 0;
    var FirstRecord = 0;
    var LastRecord = 0;
    var LastPageIndex = 0;
    var PageSize = 5;

    var firstObject = $.grep(result, function (value0, index0) {
        return index0 == 0;
    });
 
    console.log(firstObject);
    if (firstObject.length > 0) {
        PageIndex = firstObject[0].PageIndex;
        PageSize = firstObject[0].PageSize;
        TotalRecords = firstObject[0].TotalRecords;
        FirstRecord = firstObject[0].FirstRecord;
        LastRecord = firstObject[0].LastRecord;
        LastPageIndex = firstObject[0].LastPageIndex;
    }
    if (PageIndex == 1) {
        $('#btnPreviousPage').removeClass('pagerEnabled');
        $('#btnPreviousPage').addClass('pagerDisabled');
        $('#btnFirstPage').removeClass('pagerEnabled');
        $('#btnFirstPage').addClass('pagerDisabled');
    }
    else {
        $('#btnPreviousPage').removeClass('pagerDisabled');
        $('#btnPreviousPage').addClass('pagerEnabled');
        $('#btnFirstPage').removeClass('pagerDisabled');
        $('#btnFirstPage').addClass('pagerEnabled');
    }
    if (PageIndex == LastPageIndex) {
        $('#btnNextPage').removeClass('pagerEnabled');
        $('#btnNextPage').addClass('pagerDisabled');
        $('#btnLastPage').removeClass('pagerEnabled');
        $('#btnLastPage').addClass('pagerDisabled');
    }
    else {
        $('#btnNextPage').removeClass('pagerDisabled');
        $('#btnNextPage').addClass('pagerEnabled');
        $('#btnLastPage').removeClass('pagerDisabled');
        $('#btnLastPage').addClass('pagerEnabled');
    }

    $('#spnTotalRecords').text(TotalRecords);
    $('#spnFirstRecord').text(FirstRecord);
    $('#spnLastRecord').text(LastRecord);
    $('#spnTotalPages').text(LastPageIndex);
    $('#txtPageIndex').val(PageIndex);
    $('#hdnPageIndex').val(PageIndex);
    $('#selPageSize').val(PageSize);
    AttachPaginationEvents(LastPageIndex);
}

function AttachPaginationEvents(LastPageIndex) {
    $('#btnPreviousPage').unbind("click");
    $('#btnNextPage').unbind("click");
    $('#btnFirstPage').unbind("click");
    $('#btnLastPage').unbind("click");

    $('#btnPreviousPage, #btnNextPage, #btnFirstPage, #btnLastPage').click(function () {
        var id = $(this).attr('id');

        var currentPageIndex = parseInt($('#hdnPageIndex').val());
        if (id == "btnPreviousPage") {
            currentPageIndex -= 1;
        }
        else if (id == "btnNextPage") {
            currentPageIndex += 1;
        }
        else if (id == "btnFirstPage") {
            currentPageIndex = 1;
        }
        else if (id == "btnLastPage") {
            currentPageIndex = LastPageIndex;
        }
        PopulatePagination(currentPageIndex);
    });

    $('#txtPageIndex').on("keypress", function (e) {
        if (e.keyCode == 13) {
            var pageindex1 = $('#txtPageIndex').val();
            if (pageindex1 == null || pageindex1 == '' || isNaN(pageindex1)) {
                bootbox.alert('Please Enter Valid Page Number.');
                $('#txtPageIndex').val($('#hdnPageIndex').val());
                return false;
            } else {
                pageindex1 = parseInt(pageindex1);
                if (pageindex1 > LastPageIndex) {
                    bootbox.alert('Please Enter Valid Page Number.');
                    $('#txtPageIndex').val($('#hdnPageIndex').val());
                    return false;
                } else {
                    PopulatePagination(pageindex1);
                }
            }
        }
    });
   // var currentPageIndex = parseInt($('#hdnPageIndex').val());
    $('#selPageSize').on('change', function () {
        PopulatePagination(1);
    });
}

function PopulatePagination(pageIndex) {
    var pageSize = $('#selPageSize').val();
    var GuId = $('#hdnAttachId').val();
    $('#myPleaseWait').modal('show');
    $.get("/api/Common/History/" + GuId + "/" + pageIndex + "/" + pageSize)
       .done(function (response) {
           $('#myPleaseWait').modal('show');
           var result = response;
           var HistoryData = [];
           for (var i = 0; i < result.length; i++) {
               var TableRowData = JSON.parse(result[i].TableRowData);
               HistoryData = (HistoryData == null || HistoryData.length == 0) ? TableRowData : HistoryData.concat(TableRowData);
           }
           History(result,HistoryData);
           $('#myPleaseWait').modal('hide');
    })
  .fail(function (response) {
      $('#myPleaseWait').modal('hide');
      $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
      $('#errorMsg2').css('visibility', 'visible');
  });
}

function History(result,Values) {
 
    var col = [];
    for (var i = 0; i < Values.length; i++) {
        for (var key in Values[i]) {
            if (col.indexOf(key) === -1) {
                col.push(key);
            }
        }
    }

    var table = document.createElement("table");
    table.setAttribute("class", "table table-bordered");
    table.setAttribute("id", "historyId");
    table.setAttribute("style", "border: 1px solid rgb(222, 218, 218);");

    var thead = document.createElement("thead");
    thead.setAttribute("class", "tableHeading");
    table.appendChild(thead);

    var ths = thead.insertRow(-1);
    for (var i = 0; i < col.length; i++) {
        var th = document.createElement("th");
        th.setAttribute("style", "text-align: center;");
        th.innerHTML = col[i].match(/[A-Z][a-z]+|[0-9]+/g).join(" ");
        ths.appendChild(th);
    }

    for (var i = 0; i < Values.length; i++) {
        tr = table.insertRow(-1);
        for (var j = 0; j < col.length; j++) {
            var tabCell = tr.insertCell(-1);
            tabCell.setAttribute("style", "text-align: center;");
            var ifdatefield = [col[j]];
            if (ifdatefield[0].includes("ActiveFrom") || ifdatefield[0].includes("ActiveTo") || ifdatefield[0].includes("LastUpdateOn") || ifdatefield[0].includes("Date") ||
                ifdatefield[0].includes("Active From") || ifdatefield[0].includes("Active To") || ifdatefield[0].includes("Last Update On")) {
                tabCell.innerHTML = DateFormatter(Values[i][col[j]]);
            }
            else {
                if (Values[i][col[j]] == undefined) {
                    Values[i][col[j]]="";
                }
                tabCell.innerHTML = Values[i][col[j]];
            }
        }
    }

    var divContainer = document.getElementById("showData");
    divContainer.innerHTML = "";
    console.log(table);
    divContainer.appendChild(table);
    $('#divCommonPagination').html(null);
    $('#divCommonPagination').html(paginationString);
   SetPaginationValues(result);
}
