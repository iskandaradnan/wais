
var Result = {};


$(document).ready(function () {
    $(function () {
        $.get("/api/Customer/Load")
            .done(function (result) {
                Result = result;
                var loadResult = JSON.parse(Result);
                $.each(loadResult.Services, function (index, value) {
                    $('#customertype').append('<option value="' + value.LovId + '">' + value.FieldValue + '</option>');

                });
            })
    });

});
    //-------------------------

    var ListModel = "";     //image Logo
    $(function () {
        //$('.nav-search').tooltip();
        $('#btnDelete').hide();
        $('#btnEdit').hide();
        $("#jQGridCollapse1").click();
        var formCount = document.forms.length;
        $('#myPleaseWait').modal('show');
        formInputValidation("Custform");
        var Id = $('#primaryID').val();
        if (Id == null || Id == "0") {
            AddFirstGridRow();
        }

        function CheckDuplicateRecords(list) {
            var isValid = true;
            list = Enumerable.From(list).Where(function (x) { return x.Active == true }).ToArray();

            var isNameDuplicate = false;
            var isEmailDuplicate = false;
            var iscontactNoDuplicate = false;
            for (i = 0; i < list.length; i++) {
                //   var name = list[i].Name;
                var email = list[i].Email;
                var contactNo = list[i].ContactNo;
                for (j = i + 1; j < list.length; j++) {


                    if (email != null && email != "" && list[j].Email != null && list[j].Email != "") {
                        if (email.toLowerCase() == list[j].Email.toLowerCase()) {
                            isEmailDuplicate = true;
                        }
                    }
                    //if (contactNo != null && contactNo != "" && list[j].ContactNo != null && list[j].ContactNo != "") {
                    //    if (contactNo == list[j].ContactNo) {
                    //        iscontactNoDuplicate = true;
                    //    }
                    //}

                }
            }
            if (isEmailDuplicate) {
                isValid = false;
            }
            return isValid;
        }


        //Save function
        $('#btnEdit,#btnSave,#btnSaveandAddNew').click(function () {
            var CurrentbtnID = $(this).attr("Id");
            $("div.errormsgcenter").text("");
            $('#errorMsg').css('visibility', 'hidden');
            var service = $("#customertype").val();

            var _index;        // 
            var result = [];
            $('#ContactGrid tr').each(function () {
           
                _index = $(this).index();
            });

            for (var i = 0; i <= _index; i++) {
                var active = true;
                var isDeleted = $('#chkContactDelete_' + i).prop('checked');
                var _tempObj = {
                    CustomerContactInfoId: $('#CustomerContactInfoId_' + i).val(),
                    Name: $('#Name_' + i).val(),
                    Designation: $('#Designation_' + i).val(),
                    ContactNo: $('#ContactNo_' + i).val(),
                    Email: $('#Email_' + i).val(),
                    Active: isDeleted ? false : true,
                    Services: service,
                }

                result.push(_tempObj);
            }


            var deleteCount = 0;
            if (result != null && result != '') {

                deleteCount = Enumerable.From(result).Where(function (x) { return x.Active == false }).Count();
            }

            if (deleteCount > 0) {
                var message = "Record(s) selected for deletion. Do you want to proceed?";
                bootbox.confirm(message, function (result) {
                    if (result) {

                        SubmitData(CurrentbtnID);

                    }
                    else {
                        bootbox.hideAll();
                        return false;
                    }

                });
            }
            else {
          
                SubmitData(CurrentbtnID);
            }

        });


        function SubmitData(CurrentbtnID) {
            $('#myPleaseWait').modal('show');
            var service = $('#customertype').val();
            var customerId = $('#CustomerId').val();
            var customerName = $('#CustomerName').val();
            var contractPeriod = $('#ContractPeriodInYears').val()
            //customerName = customerName.replace(/[_\W]+/g, "")
            var customerCode = $('#CustomerCode').val();
            //var ContactNo = $('#ContactNo').val();
            var address = $('#Address').val();
            var latitude = $('#Latitude').val();
            var longitude = $('#Longitude').val();
            var timeStamp = $("#Timestamp").val();
            var Active = $('#Active').val();
            var status = true;
            if (Active == 1) {
                status = true;
            }
            else {
                status = false;
            }

            var _index;        // 
            var result = [];
            $('#ContactGrid tr').each(function () {
                _index = $(this).index();
            });

            for (var i = 0; i <= _index; i++) {
                var active = true;
                var isDeleted = $('#chkContactDelete_' + i).prop('checked');
                var _tempObj = {
                    CustomerContactInfoId: $('#CustomerContactInfoId_' + i).val(),
                    Name: $('#Name_' + i).val(),
                    Designation: $('#Designation_' + i).val(),
                    ContactNo: $('#ContactNo_' + i).val(),
                    Email: $('#Email_' + i).val(),
                    Active: isDeleted ? false : true,
                    //Services: service,
                }

                result.push(_tempObj);
            }
            var count = 0;
            if (result != null && result != '') {
                count = Enumerable.From(result).Where(function (x) { return x.Active == true && x.Name != null && x.Name != '' }).Count();
            }
            var isFormValid = formInputValidation("Custform", 'save');
            if (!isFormValid || latitude == 0 || latitude == "0" || longitude == 0 || longitude == "0" || result == '' || result == null) {
                $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
                if (latitude == 0 || latitude == "0") {
                    $('#Latitude').parent().addClass('has-error');
                }
                if (longitude == 0 || longitude == "0") {
                    $('#Longitude').parent().addClass('has-error');
                }
                $('#errorMsg').css('visibility', 'visible');
                $('#myPleaseWait').modal('hide');
                $('#btnSave').attr('disabled', false);
                //$('#btnEdit').attr('disabled', false);
                return false;
            }
            else if (count == 0) {

                bootbox.alert("Contact Info grid should contain atleast one record");
                $('#chkContactDeleteAll').prop('checked', false);
                //  $("div.errormsgcenter").text("Contact Info grid should contain atleast one record");
                //  $('#errorMsg').css('visibility', 'visible');
                $('#myPleaseWait').modal('hide');
                $('#btnSave').attr('disabled', false);
                //$('#btnEdit').attr('disabled', false);
                return false;
            }
            else if (parseInt(contractPeriod) <= 0) {

                $('#ContractPeriodInYears').parent().addClass('has-error');

                $("div.errormsgcenter").text("Contract Period In Years should be greater than 0");
                $('#errorMsg').css('visibility', 'visible');
                $('#myPleaseWait').modal('hide');
                $('#btnSave').attr('disabled', false);
                //$('#btnEdit').attr('disabled', false);
                return false;
            }
            else if (!CheckDuplicateRecords(result)) {
                $("div.errormsgcenter").text("Contact Person email already exists");
                $('#errorMsg').css('visibility', 'visible');
                $('#myPleaseWait').modal('hide');
                $('#btnSave').attr('disabled', false);
                //$('#btnEdit').attr('disabled', false);
                return false;
            }
            //else if (status == false && ($('#Remarks').val() == null || $('#Remarks').val().trim() == "")) {
            //    // $("div.errormsgcenter").text("Stop Service Date is Mandatory");
            //    $("div.errormsgcenter").text(Messages.INVALID_INPUT_MESSAGE);
            //    $('#Remarks').parent().addClass('has-error');
            //    $('#errorMsg').css('visibility', 'visible');
            //    $('#myPleaseWait').modal('hide');
            //    return false;
            //}

            var primaryId = $("#primaryID").val();
            if (primaryId != null) {
                customerId = primaryId;
                timeStamp = timeStamp;
            }
            else {
                customerId = 0;
                timeStamp = "";
            }

            var CustomerData = {
                CustomerId: customerId,
                CustomerName: customerName,
                CustomerCode: customerCode,
                CustomerType: service,
                Address: address,
                ContactNo: $('#ContactNo').val(),
                FaxNo: $('#FaxNo').val(),
                Remarks: $('#Remarks').val(),
                Latitude: latitude,
                Longitude: longitude,
                Active: status,
                Timestamp: timeStamp,
                Address2: $('#Address2').val(),
                Postcode: $('#Postcode').val(),
                State: $('#State').val(),
                Country: $('#Country').val(),
                ContractPeriodInYears: contractPeriod,
                ContactInfoList: result,
                Base64StringLogo: ListModel,     // image Logo
            }

            var jqxhr = $.post("/api/Customer/Add", CustomerData, function (response) {
               
                var result = JSON.parse(response);
                $("#primaryID").val(result.CustomerId);
                $("#Timestamp").val(result.Timestamp);
                $("#grid").trigger('reloadGrid');
                BindData(result);
                $('#hdnAttachId').val(result.HiddenId);
                $('#ActiveToDate').parent().removeClass('has-error');
                if (result.CustomerId != 0) {
                    $("#CustomerName,#CustomerCode").attr("disabled", "disabled");
                    $('#btnEdit').show();
                    $('#btnSave').hide();
                    $('#btnDelete').show();
                }
                $(".content").scrollTop(0);
                showMessage('Customer', CURD_MESSAGE_STATUS.SS);
                $("#top-notifications").modal('show');
                setTimeout(function () {
                    $("#top-notifications").modal('hide');
                }, 5000);

                //if (formCount > 0) {
                //    for (var i = 0; i < formCount; i++) {
                //        var formid = document.forms[i].id;

                //        $('#' + formid + ' :input:not(:button)').each(function () {
                //            $(this).data('initialValue_' + formid, $(this).val());
                //        });
                //    }
                //}
                $('#btnSave').attr('disabled', false);
                $('#myPleaseWait').modal('hide');

                if (CurrentbtnID == "btnSaveandAddNew") {
                    ClearFields();
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
                    $('#btnEdit').attr('disabled', false);
                    $('#myPleaseWait').modal('hide');
                });
        }


    });




    $('#Active').change(function () {
        var value = $('#Active').val();
        if (value == 1) {
            $("#Reemarkslabel").html('Remarks');
            $('#Remarks').removeAttr('required');
            $('#Remarks').parent().removeClass('has-error');
        }
        else {
            $("#Reemarkslabel").html('Remarks <span class="red">&nbsp;*</span>');
            $('#Remarks').attr('required', true);
        }
    });


    $('#chkContactDeleteAll').on('click', function () {
        var isChecked = $(this).prop("checked");
        //var index1; $('#chkContactDeleteAll').prop('checked', true);
        // var count = 0;
        $('#ContactGrid tr').each(function (index, value) {
            if (isChecked) {
                $('#chkContactDelete_' + index).prop('checked', true);
                $('#chkContactDelete_' + index).parent().addClass('bgDelete');
                $('#Name_' + index).removeAttr('required');
                $('#Name_' + index).parent().removeClass('has-error');
            }
            else {
                $('#Name_' + index).attr('required', true);
                $('#chkContactDelete_' + index).prop('checked', false);
                $('#chkContactDelete_' + index).parent().removeClass('bgDelete');
            }
        });
    });

    function DeleteContact(currentindex) {


        var rowCount = $('#ContactGrid tr:last').index() + 1;
        var _index;        // var _indexThird;
        var result = [];
        $('#ContactGrid tr').each(function () {
            _index = $(this).index();
        });


        for (var i = 0; i <= _index; i++) {
            var active = true;
            var isDeleted = $('#chkContactDelete_' + i).prop('checked');
            var _tempObj = {
                CustomerContactInfoId: $('#CustomerContactInfoId_' + i).val(),
                Name: $('#Name_' + i).val(),
                Designation: $('#Designation_' + i).val(),
                ContactNo: $('#ContactNo_' + i).val(),
                Email: $('#Email_' + i).val(),
                Active: isDeleted ? false : true,
            }
            result.push(_tempObj);
        }

        var count = Enumerable.From(result).Where(function (x) { return x.Active == false }).Count();
        //alert(rowCount);
        //alert(count);
        if (count == rowCount) {
            $('#chkContactDeleteAll').prop('checked', true);
        }
        else {
            $('#chkContactDeleteAll').prop('checked', false);
        }
        //else {
        if ($('#chkContactDelete_' + currentindex).is(":checked")) {
            $('#Name_' + currentindex).removeAttr('required');
            $('#Name_' + currentindex).parent().removeClass('has-error');
            $('#chkContactDelete_' + currentindex).parent().addClass('bgDelete');
        }
        else {
            $('#Name_' + currentindex).attr('required', true);
            $('#chkContactDelete_' + currentindex).parent().addClass('bgDelete');
            //$('#Name_' + currentindex).attr('required', true);
            $('#chkContactDelete_' + currentindex).parent().removeClass('bgDelete');
        }
        // }
    }
    var linkCliked1 = false;
    function AddFirstGridRow() {
        $('#chkContactDeleteAll').prop('checked', false);
        var inputpar = {
            inlineHTML: '<tr class="ng-scope" style="">' +
                '<td width="5%" style="text-align:center"> <input type="checkbox" onchange="DeleteContact(maxindexval)" id="chkContactDelete_maxindexval" /></td>' +
                '<td width="25%" style="text-align: center;" ><div><input type="hidden" id= "CustomerContactInfoId_maxindexval">  ' +
                ' <input type="text" id="Name_maxindexval" name="Name" maxlength="50"  class="form-control" autocomplete="off" tabindex="0" required ></div></td>' +
                '<td width="20%" style="text-align: center;" ><div> ' +
                '<input id="Designation_maxindexval" type="text" class="form-control " maxlength="100"  name="Designation" autocomplete="off" tabindex="0" ></div></td><td width="20%" style="text-align: center;" ><div>' +
                ' <input id="ContactNo_maxindexval" type="text" class="form-control " maxlength="15"  name="ContactNo" autocomplete="off" tabindex="0" ></div></td><td width="30%" style="text-align: center;" ><div>' +
                ' <input id="Email_maxindexval" type="text" class="form-control " maxlength="50"  name="Email" autocomplete="off" ></div></td></tr>',
            IdPlaceholderused: "maxindexval",
            TargetId: "#ContactGrid",
            TargetElement: ["tr"]
        }
        AddNewRowToDataGrid(inputpar);

        $("input[id^='Name_']").attr('pattern', '^[a-zA-Z0-9./\\(\\),\\-\\s]+$');
        $("input[id^='Designation_']").attr('pattern', '^[a-zA-Z./\\(\\),\\-\\s]+$');
        $("input[id^='ContactNo_']").attr('pattern', '^[0-9\\(\\)\\-\\+]+$');
        $("input[id^='Email_']").attr('pattern', '^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$');
        if (!linkCliked1) {
            $('#ContactGrid tr:last td:first input').focus();
        } else {
            linkCliked1 = false;
        }
        formInputValidation("Custform");
    }

function LinkClicked(id) {
        linkCliked1 = true;
        var action = "";
        $('.nav-tabs a:first').tab('show');
        $(".content").scrollTop(0);
        $("#Custform :input:not(:button)").parent().removeClass('has-error');
        $("#frmCustomerConfig :input:not(:button)").parent().removeClass('has-error');
        $("#frmConfigAdditionalTabs :input:not(:button)").parent().removeClass('has-error');
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
        $("div.errormsgcenter1").text("");
        $('#errorMsg1').css('visibility', 'hidden');
        $("div.errormsgcenter").text("");
        $('#errorMsgCustomer').css('visibility', 'hidden');
        $("div.errormsgcenter").text("");
        $('#errorMsgConfigAdditionalFields').css('visibility', 'hidden');
        $('#customertype').val();

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
            $("#UAform :input:not(:button)").prop("disabled", true);
            $('#levlcodepopup,#hospStaffpopup,#companypopup').hide();
        } else {
            $('#btnEdit').show();
            $('#btnSave').hide();

            $("#UAform :input:not(:button)").prop("disabled", false);
        }
        $('#spnActionType').text(action);
        var primaryId = $('#primaryID').val();
        if (primaryId != null && primaryId != "0") {
            $.get("/api/Customer/get/" + primaryId)
                .done(function (result) {
                    $('#myPleaseWait').modal('hide');
                    var result = JSON.parse(result);

                    BindData(result);
                    $('#hdnAttachId').val(result.HiddenId);
                    $('#myPleaseWait').modal('hide');
                }).fail(function (response) {
                    $('#myPleaseWait').modal('hide');
                    $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE(response));
                    $('#errorMsg').css('visibility', 'visible');
                });
        }
        else {
            $("#CustomerName,#CustomerCode").removeAttr("disabled");
            $('#myPleaseWait').modal('hide');
        }
    }
    $("#btnDelete").click(function () {
        var ID = $('#primaryID').val();
        confirmDelete(ID);

    });


    $('#contactBtn').click(function () {

        var rowCount = $('#ContactGrid tr:last').index();
        var name = $('#Name_' + rowCount).val();

        if (rowCount < 0)
            AddFirstGridRow();
        else if (rowCount >= "0" && name.trim() == "") {
            bootbox.alert("Please fill the last record");
        }
        else {
            AddFirstGridRow();
        }
    });
    function confirmDelete(ID) {
        var message = Messages.SEARCH_GRID_DELETE_CONFIRMATION;
        bootbox.confirm(message, function (result) {
            if (result) {
                $.get("/api/Customer/Delete/" + ID)
                    .done(function (result) {
                        filterGrid();
                        $(".content").scrollTop(0);
                        showMessage('Customer', CURD_MESSAGE_STATUS.DS);
                        $('#myPleaseWait').modal('hide');
                        $('#btnDelete').hide();
                        ClearFields();
                    })
                    .fail(function () {
                        showMessage('Customer', CURD_MESSAGE_STATUS.DF);
                        $('#myPleaseWait').modal('hide');
                    });

            }
        });
    }
    function ClearFields() {
        $(".content").scrollTop(0);
        $('#chkContactDeleteAll').prop('checked', false);
        $('#hdnAttachId').val('');
        $("#Reemarkslabel").html('Remarks');
        $('#Active').val(1);
        $('input[type="text"], textarea').val('');
        $('#btnEdit').hide();
        $('#btnSave').show();
        $('#btnDelete').hide();
        $('#btnNextScreenSave').hide();
        //$("#PreviousActiveFromDate").val('');
        $('#spnActionType').text('Add');
        //  $('#TypeOfContractLovId').val('null');
        $("#primaryID").val('');
        $('#CustomerName').attr("disabled", false);
        //$('#customertype').val();
        //$('#CustomerCode').removeAttr("disabled"); 
        $("#Custform :input:not(:button)").parent().removeClass('has-error');
        $("div.errormsgcenter").text("");
        $('#errorMsg').css('visibility', 'hidden');
        $('#errorMsgCustomer').css('visibility', 'hidden');
        $('#errorMsgConfigAdditionalFields').css('visibility', 'hidden');
        $('#ContactGrid').empty();
        $('#ContactNo').val(''),
            $('#FaxNo').val(''),
            $('#Remarks').val(''),
            $('#Remarks').removeAttr('required');
        AddFirstGridRow();
        $('#selScreenName').val('null').trigger('change');

        $("#selDateFormat").val('null');
        $("#selCurrencyFormat").val('null');
        //$('#TypeOfContractLovId').val('null');
        $('#chkQAPIndicatorB1,#chkQAPIndicatorB2,#chkKPIIndicatorB1,#chkKPIIndicatorB2').prop('checked', false);
        $('#chkKPIIndicatorB3,#chkKPIIndicatorB4,#chkKPIIndicatorB5,#chkKPIIndicatorB6').prop('checked', false);
        //$("#grid").trigger('reloadGrid');

        //$('.nav-tabs a:first').tab('show');

        $("#sparePartImageUpload").val("");
        $('#imgvid1').attr('src', '');
        $('#showModalImg').hide();
        $('#divCommonPagination').html(null);

        $('#hdnAttachId').val('')
    }

function BindData(result) {
        $('#CustomerId,#primaryID').val(result.CustomerId);
        $('#CustomerName').val(result.CustomerName);
        $('#CustomerCode').val(result.CustomerCode);
        //$('#ContactNo').val(result.ContactNo);
    $('#customertype').val(result.CustomerType);
        $('#Address').val(result.Address);
        $('#Latitude').val(result.Latitude);
        $('#Longitude').val(result.Longitude);
        $('#chkContactDeleteAll').prop('checked', false);
        $('#Active').val(result.Active);
        if (result.Active) {
            $('#Active').val(1);
            $("#Reemarkslabel").html('Remarks');
        }
        else {
            $('#Active').val(0);

            $("#Reemarkslabel").html('Remarks <span class="red">&nbsp;*</span>');
        }
        $('#Timestamp').val(result.Timestamp);
        $('#Address2').val(result.Address2);
        $('#State').val(result.State);
        $('#Postcode').val(result.Postcode);
        $('#Country').val(result.Country);
        $('#ContactNo').val(result.ContactNo);
        $('#FaxNo').val(result.FaxNo);
        $('#Remarks').val(result.Remarks);
        $('#ContractPeriodInYears').val(result.ContractPeriodInYears);
        // $('#TypeOfContractLovId').val(result.TypeOfContractLovId);
        $('#Timestamp').val(result.Timestamp);

        //*********************** Image Logo Start ****************************

        if (result.Base64StringLogo != "" && result.Base64StringLogo != null) {
            ListModel = result.Base64StringLogo;
            $('#showModalImg').show();
            $("#sparePartImageUpload").val("");
            var str = 'data:image/png;base64,' + result.Base64StringLogo;

            //   $("#imgvid1").attr('src', "'" + str + "'");
            //  $("#imgvid1").attr('src', result.Base64StringLogo);    
            // document.getElementById('imgvid1').setAttribute('src', "'"+str+"'");

            document.getElementById('imgvid1').setAttribute('src', str);
        }
        else {
            $('#showModalImg').hide();
        }

        //*********************** Image Logo End ****************************

        if (result.ContactInfoList != null) {
            $('#ContactGrid').empty();
            $.each(result.ContactInfoList, function (index, data) {
                AddFirstGridRow();
                $('#CustomerContactInfoId_' + index).val(data.CustomerContactInfoId);
                $('#Name_' + index).val(data.Name);
                $('#Designation_' + index).val(data.Designation);
                $('#ContactNo_' + index).val(data.ContactNo);
                $('#Email_' + index).val(data.Email);
                linkCliked1 = true;
            });
        }
        $("#CustomerName,#CustomerCode").attr("disabled", "disabled");

    }


    //***************************** Image Logo Upoad *******************************************

    function getLogoImageDetails(e) {

        var primaryId = $("#primaryID").val();
        var CustomerId = $("#CustomerId").val();

        for (var i = 0; i < e.files.length; i++) {
            var f = e.files[i];
            var file = f;
            var blob = e.files[i].slice();
            var filetype = file.type;
            var filesize = file.size;
            var FileName = file.name;
            var filewidth = file.filewidth;
            var fileheight = file.fileheight;
            var extension = FileName.replace(/^.*\./, '');
            var reader = new FileReader();


            var ImgappType = ['image/jpeg', 'image/jpg', 'image/png'];
            var ImgMaxSize = 4194304;   //  - 4Mb;

            if (filetype == "image/png") {
                if (ImgMaxSize >= filesize) {

                    function getB64Str(buffer) {
                        var binary = '';
                        var bytes = new Uint8Array(buffer);
                        var len = bytes.byteLength;
                        for (var i = 0; i < len; i++) {
                            binary += String.fromCharCode(bytes[i]);
                        }
                        return window.btoa(binary);
                    }

                    reader.onloadend = function (evt) {
                        if (evt.target.readyState == FileReader.DONE) {
                            var cont = evt.target.result;
                            var base64String = getB64Str(cont);
                            if (primaryId == 0 || primaryId == null) {
                                ListModel = base64String;
                            }
                            else {
                                if (CustomerId == primaryId) {
                                    ListModel = base64String;
                                }
                            }
                        }
                    };
                    reader.readAsArrayBuffer(blob);
                    $('#showModalImg').show();
                    var Ioutput = document.getElementById('imgvid1');
                    Ioutput.src = URL.createObjectURL(event.target.files[0]);
                }
                else {
                    bootbox.alert("File size must be less than 4MB.");
                    $("#sparePartImageUpload").val("");
                    // $('#imgvid1').attr('src', '');
                }
            }
            else {
                bootbox.alert("Please upload png format only.");
                $("#sparePartImageUpload").val("");
                // $('#imgvid1').attr('src', '');
            }

        }
    }

    //$("#btnConfigAdditionalFieldsCancel,#btnConfigurationCancel").click(function () {
    //    message = "Are you sure that you want to Reset All the Tab(s)?";
    //    bootbox.confirm(message, function (result) {
    //        ClearFields();
    //    });
    //});
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


    $("#facHistoryId").click(function () {
        $('#txtCustomerCode').val('');
        $('#txtCustomerName').val('');
        $('#facilityGridId').empty();
        $("div.errormsgcenter1").text("");
        $('#errorMsg1').css('visibility', 'hidden');
        var primaryId = $('#primaryID').val();

        if (primaryId == 0) {
            bootbox.alert(Messages.SAVE_FIRST_TABALERT);
            return false;
        }
        else {
            if (primaryId != null && primaryId != "0" && primaryId != "" && primaryId != 0) {
                $('#txtCustomerCode').val($('#CustomerCode').val());
                $('#txtCustomerName').val($('#CustomerName').val());

                $.get("/api/Customer/getFacilityList/" + primaryId)
                    .done(function (result) {

                        var res = JSON.parse(result);
                        $('#facilityGridId').empty();
                        if (res != null && res.ActiveFacilityList != null && res.ActiveFacilityList.length > 0) {
                            var html = '';

                            $.each(res.ActiveFacilityList, function (index, data) {
                                var activefromdate;
                                var activeTodate;
                                activefromdate = (data.ActiveFromDate != "") ? DateFormatter(data.ActiveFromDate) : "";
                                activeTodate = (data.ActiveToDate != "") ? DateFormatter(data.ActiveToDate) : "";
                                html += ' <tr> <td width="20%"> <div> <input type="text" value="' + data.FacilityCode + '" class="form-control" readonly/> </div></td> ' +
                                    '<td width="30%"> <div>' +
                                    ' <input type="text"  value="' + data.FacilityName + '" class="form-control" readonly/> </div></td>' +
                                    '<td width="25%"> <div> ' +
                                    '<input type="text"  value="' + activefromdate + '" class="form-control" readonly/> </div></td><td width="25%"> <div> <input type="text"  value="' + activeTodate + '" class="form-control" readonly/> </div></td> ' +
                                    '</tr>';
                            });
                            $('#facilityGridId').append(html);
                        }
                        else {
                            $('#myPleaseWait').modal('hide');
                            var emptyrow = '<tr id="NoActRec" class="norecord"><td width="100%"><h5 class="text-center">No  records to display</h5></td></tr>'
                            $("#facilityGridId ").append(emptyrow);
                        }
                        $('#myPleaseWait').modal('hide');
                    })
                    .fail(function () {
                        $('#myPleaseWait').modal('hide');
                        $("div.errormsgcenter1").text("No records found");
                        $('#errorMsg1').css('visibility', 'visible');
                    });
            }
        }
    })
//---------});