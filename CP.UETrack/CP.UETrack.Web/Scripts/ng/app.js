
//$(document).ready(function () {
//    companyIdFroMultTabCheck = $('#CompanyId').val();
//    hospitalIdFroMultTabCheck = $('#HospitalId').val();
//    serviceIdFroMultTabCheck = $('#moduleServiceId').val();
//    exportUrl = "/api/common/export" + "?companyIdInTab=" + companyIdFroMultTabCheck + "&hospitalIdInTab=" + hospitalIdFroMultTabCheck + "&serviceIdInTab=" + serviceIdFroMultTabCheck;

//    companyIdStringForMultTabCheck = (companyIdFroMultTabCheck == undefined || companyIdFroMultTabCheck == null) ? "0" : companyIdFroMultTabCheck.toString();
//    hospitalIdStringForMultTabCheck = (hospitalIdFroMultTabCheck == undefined || hospitalIdFroMultTabCheck == null) ? "0" : hospitalIdFroMultTabCheck.toString();
//    serviceIdStringForMultTabCheck = (serviceIdFroMultTabCheck == undefined || serviceIdFroMultTabCheck == null) ? "0" : serviceIdFroMultTabCheck.toString();

//    $.ajaxSetup({
//        headers: { 'companyId': companyIdStringForMultTabCheck, 'hospitalId': hospitalIdStringForMultTabCheck, 'serviceId': serviceIdStringForMultTabCheck }
//    });
//});


//appUETrack.factory('httpRequestInterceptor', function () {
//    return {
//        request: function (config) {

//            config.headers['companyId'] = companyIdFroMultTabCheck;
//            config.headers['hospitalId'] = hospitalIdFroMultTabCheck;
//            config.headers['serviceId'] = serviceIdFroMultTabCheck;
//            return config;
//        }
//    };
//});

//appUETrack.config(function ($httpProvider) {
//    $httpProvider.interceptors.push('httpRequestInterceptor');
//});

//redirectForDelete = false;
//appUETrack.config(['$httpProvider', function ($httpProvider) {
//    $httpProvider.interceptors.push(['$location', '$q', function ($location, $q) {
//        return {
//            'request': function (request) {
//                return request;
//            },
//            'responseError': function (response) {
//                if (response.status === 406) {
//                    window.location.href = "/home?r=mts";
//                    redirectForDelete = true;
//                }
//                if (response.status === 409) {
//                    window.location.href = "/account/Logout";
//                    redirectForDelete = true;
//                }
//                return $q.reject(response);
//            }
//        };
//    }]);
//}])

//For Inactive hospitals, only view permission should be there.
//jQuery(document).ready(function () {
//    var isValidHospital = $('#hdnValidHospital').val();
//    var buttonList = $("button");
//    if (isValidHospital == "0" && buttonList.length > 0) {
//        for (i = 0; i < buttonList.length; i++) {
//            var buttonId = buttonList[i].id;
//            var buttonIdCaps = buttonList[i].id.toUpperCase();
//            if (buttonIdCaps.indexOf('CANCEL') > -1)
//                continue;
//            $('#' + buttonId).remove();
//        }
//    }
//    $.ajaxSetup({
//        headers: { 'x-my-custom-header': 'some value' }
//    });

//});

jQuery(document).ready(function () {
    var ActionType = {
        ADD: "ADD",
        SAVE: "SAVE",
        INSERT: "INSERT",
        EDIT: "EDIT",
        VIEW: "VIEW",
        APPROVE: "APPROVE"
    };
    var DefaultActionType = [];
    var ActionControl = [];
    var DummyControl = [];
    DummyControl.push({ "id": "DEFUALT" });

    DefaultActionType.push({ "id": "CANCEL" });
    DefaultActionType.push({ "id": "ASSETTYPEMASTER" });

    ActionControl = $("button");

    //var IsAdmin = $('#IsAdmin').val();
    //if (IsAdmin == 0) {
        try {
            var ActionName = '';
            var ActionPermissionValues = $('#ActionPermissionValues').val();
            var Action = window.location.pathname.split('/');
            for (var Count = 0; Count < Action.length; Count++) {
                var CndActionName = Action[Count].toUpperCase();
                if (CndActionName == ActionType.ADD || CndActionName == ActionType.SAVE || CndActionName == ActionType.EDIT) {
                    ActionName = CndActionName;
                }
            }

            if (ActionPermissionValues != undefined) {
                var ActionPermissions = JSON.parse(ActionPermissionValues);
                if (ActionPermissions.length > 0) {
                    for (var Count1 = 0; Count1 < DefaultActionType.length; Count1++) {
                        $.grep(ActionControl, function (data, index) {
                            if (data.id.toUpperCase().indexOf(DefaultActionType[Count1].id) > -1) {
                                ActionControl.splice(index, 1, DummyControl[0]);
                            }
                        });
                    }

                    for (var Count2 = 0; Count2 < ActionControl.length; Count2++) {
                        var ActionValues = ActionControl[Count2].id.toUpperCase();
                        if (ActionValues != DummyControl[0].id) {
                            if (ActionName == ActionType.ADD || ActionName == ActionType.SAVE || ActionName == ActionType.EDIT || ActionName == "") {     // Authorization for Add,Edit functionality                           
                                var returnData = $.grep(ActionPermissions, function (data, index) {
                                    if ((ActionValues.indexOf("SAVE") > -1 || ActionValues.indexOf("INSERT") > -1) && data.ActionPermissionName.toUpperCase() === "ADD") {
                                        return data; // for Button Id SAVE,INSERT
                                    }
                                    else if (ActionValues.indexOf(data.ActionPermissionName.toUpperCase()) > -1) {
                                        return data;
                                    }
                                });
                                if (returnData.length == 0 && ActionControl[Count2].id != '') {
                                    $('#' + ActionControl[Count2].id).remove();
                                }
                            }
                        }
                    }
                }
                else {  // to remove all control for Unauthorized User
                    for (var Count3 = 0; Count3 < ActionControl.length; Count3++) {
                        if (ActionControl[Count3].id == 'btnChangePassword' || ActionControl[Count3].id == 'btnChangePwdClose')
                            continue;
                        if (ActionControl[Count3].id != '') {
                            $('#' + ActionControl[Count3].id).remove();
                        }
                    }
                }
            };
        }
        catch (e) {
            //alert(e.data.ReturnMessage);
        }
    //}
});

jQuery(document).ready(function () {
    jQuery(document).ready(function () {
        //var IsAdmin = $('#IsAdmin').val();
        //var isValidHospital = $('#hdnValidHospital').val();
        //if (IsAdmin == 0) {
            var grid = $('#grid');
            var ActionControl = new Array(0);
            ActionControl.push({ "id": "ADD" });
            ActionControl.push({ "id": "EDIT" });
            ActionControl.push({ "id": "DELETE" });
            ActionControl.push({ "id": "VIEW" });
            ActionControl.push({ "id": "EXPORT" });
            ActionControl.push({ "id": "VERIFY" });
            ActionControl.push({ "id": "ACKNOWLEDGE" });
            ActionControl.push({ "id": "RECOMMEND" });
            ActionControl.push({ "id": "APPROVE" });
            ActionControl.push({ "id": "REJECT" });
            var ActionPermissionValues = $('#ActionPermissionValues').val();
            if (ActionPermissionValues != undefined && ActionPermissionValues != null && ActionPermissionValues != '') {
                var ActionPermissions = JSON.parse(ActionPermissionValues);

                if (ActionPermissions.length > 0) {

                    var responsedata = ActionPermissions;
                    grid.jqGrid('setGridParam', {
                        gridComplete: function (data) {
                            for (var i = 0; i < ActionControl.length; i++) {

                                var returnData = responsedata.filter(function (data) {
                                    return (data.ActionPermissionName.toUpperCase() == ActionControl[i].id.toUpperCase())

                                });
                                if (returnData.length == 0) {

                                    switch (ActionControl[i].id.toUpperCase()) {
                                        case 'ADD':
                                            $('td #Add').hide();
                                            break;
                                        case 'EDIT':
                                            EditHide();
                                            break;
                                        case 'DELETE':
                                            DeleteHide();
                                            break;
                                        case 'VIEW':
                                            ViewHide();
                                            break;
                                        case 'VERIFY':
                                            VerifyHide();
                                            break;
                                        case 'ACKNOWLEDGE':
                                            AcknowledgeHide();
                                            break;
                                        case 'RECOMMEND':
                                            RecommendHide();
                                            break;
                                        case 'APPROVE':
                                            ApproveHide();
                                            break;
                                        case 'REJECT':
                                            RejectHide();
                                            break;
                                        case 'EXPORT':
                                            $('td #ExporttoExcel').hide();
                                            $('td #ExporttoPDF').hide();
                                            $('td #ExporttoCSV').hide();
                                            break;
                                    }
                                }
                            }
                            //if (isValidHospital == "0") {
                            //    $('td #Add').hide();
                            //    $('td #ExporttoExcel').hide();
                            //    $('td #ExporttoPDF').hide();
                            //    $('td #ExporttoCSV').hide();
                            //    EditHide();
                            //    DeleteHide();
                            //}
                        }
                    });
                }
                else {
                    $('td #Add').hide();
                    $('td #ExporttoExcel').hide();
                    $('td #ExporttoPDF').hide();
                    $('td #ExporttoCSV').hide();
                    grid.jqGrid('setGridParam', {
                        gridComplete: function (data) {
                            EditHide();
                            DeleteHide();
                            ViewHide();
                        }
                    });
                }
            };
        //};

        //if (IsAdmin == 1 && isValidHospital == "0") {
        //    var isValidHospital = $('#hdnValidHospital').val();

        //    if (isValidHospital == "0") {
        //        var grid = $('#grid');
        //        grid.jqGrid('setGridParam', {
        //            gridComplete: function (data) {
        //                $('td #Add').hide();
        //                $('td #ExporttoExcel').hide();
        //                $('td #ExporttoPDF').hide();
        //                $('td #ExporttoCSV').hide();
        //                EditHide();
        //                DeleteHide();
        //            }
        //        });
        //    }
        //}

    });
});

function setGridPermission(data) {

    //console.log('Permission');

    //var IsAdmin = $('#IsAdmin').val();
    //var isValidHospital = $('#hdnValidHospital').val();

    //if (IsAdmin == 0) {
        var grid = $('#grid');
        var ActionControl = new Array(0);
        ActionControl.push({ "id": "ADD" });
        ActionControl.push({ "id": "EDIT" });
        ActionControl.push({ "id": "DELETE" });
        ActionControl.push({ "id": "VIEW" });
        ActionControl.push({ "id": "EXPORT" });
        ActionControl.push({ "id": "VERIFY" });
        ActionControl.push({ "id": "ACKNOWLEDGE" });
        ActionControl.push({ "id": "RECOMMEND" });
        ActionControl.push({ "id": "APPROVE" });
        ActionControl.push({ "id": "REJECT" });

        var ActionPermissionValues = $('#ActionPermissionValues').val();

        if (ActionPermissionValues != undefined) {
            var ActionPermissions = JSON.parse(ActionPermissionValues);

            if (ActionPermissions.length > 0) {

                var responsedata = ActionPermissions;
                //grid.jqGrid('setGridParam', {
                //    gridComplete: function (data) {
                for (var i = 0; i < ActionControl.length; i++) {

                    var returnData = responsedata.filter(function (data) {
                        return (data.ActionPermissionName.toUpperCase() == ActionControl[i].id.toUpperCase())

                    });
                    if (returnData.length == 0) {

                        switch (ActionControl[i].id.toUpperCase()) {
                            case 'ADD':
                                $('td #Add').hide();
                                break;
                            case 'EDIT':
                                EditHide();
                                break;
                            case 'DELETE':
                                DeleteHide();
                                break;
                            case 'VIEW':
                                ViewHide();
                                break;
                            case 'VERIFY':
                                VerifyHide();
                                break;
                            case 'ACKNOWLEDGE':
                                AcknowledgeHide();
                                break;
                            case 'RECOMMEND':
                                RecommendHide();
                                break;
                            case 'APPROVE':
                                ApproveHide();
                                break;
                            case 'REJECT':
                                RejectHide();
                                break;
                            case 'EXPORT':
                                $('td #ExporttoExcel').hide();
                                $('td #ExporttoPDF').hide();
                                $('td #ExporttoCSV').hide();
                                break;
                        }
                    }
                }
                //if (isValidHospital == "0") {
                //    $('td #Add').hide();
                //    $('td #ExporttoExcel').hide();
                //    $('td #ExporttoPDF').hide();
                //    $('td #ExporttoCSV').hide();
                //    EditHide();
                //    DeleteHide();
                //}
                //    }
                //});
            }
            else {
                $('td #Add').hide();
                $('td #ExporttoExcel').hide();
                $('td #ExporttoPDF').hide();
                $('td #ExporttoCSV').hide();
                grid.jqGrid('setGridParam', {
                    gridComplete: function (data) {
                        EditHide();
                        DeleteHide();
                        ViewHide();
                    }
                });
            }
        };
    //};

    //if (IsAdmin == 1 && isValidHospital == "0") {
    //    var isValidHospital = $('#hdnValidHospital').val();

    //    if (isValidHospital == "0") {
    //        var grid = $('#grid');
    //        grid.jqGrid('setGridParam', {
    //            gridComplete: function (data) {
    //                $('td #Add').hide();
    //                $('td #ExporttoExcel').hide();
    //                $('td #ExporttoPDF').hide();
    //                $('td #ExporttoCSV').hide();
    //                EditHide();
    //                DeleteHide();
    //            }
    //        });
    //    }
    //}

}

function EditHide() {

    if ($('.ui-jqgrid-btable td[aria-describedby=grid_edit]').length > 0) {
        $('#grid_edit').hide();
        var EditId = $('.ui-jqgrid-btable td[aria-describedby=grid_edit]')[0].cellIndex + 1;
        $('.ui-jqgrid-btable td:nth-child(' + EditId + ')').hide();
    }
    if ($('.ui-jqgrid-btable td[aria-describedby=grid_Edit]').length > 0) {
        $('#grid_Edit').hide();
        var EditId = $('.ui-jqgrid-btable td[aria-describedby=grid_Edit]')[0].cellIndex + 1;
        $('.ui-jqgrid-btable td:nth-child(' + EditId + ')').hide();
    }
}
function DeleteHide() {

    if ($('.ui-jqgrid-btable td[aria-describedby=grid_delete]').length > 0) {
        $('#grid_delete').hide();
        var DeleteId = $('.ui-jqgrid-btable td[aria-describedby=grid_delete]')[0].cellIndex + 1;
        $('.ui-jqgrid-btable td:nth-child(' + DeleteId + ')').hide();
    }
    if ($('.ui-jqgrid-btable td[aria-describedby=grid_Delete]').length > 0) {
        $('#grid_Delete').hide();
        var DeleteId = $('.ui-jqgrid-btable td[aria-describedby=grid_Delete]')[0].cellIndex + 1;
        $('.ui-jqgrid-btable td:nth-child(' + DeleteId + ')').hide();
    }
}
function ViewHide() {

    if ($('.ui-jqgrid-btable td[aria-describedby=grid_view]').length > 0) {
        $('#grid_view').hide();
        var ViewId = $('.ui-jqgrid-btable td[aria-describedby=grid_view]')[0].cellIndex + 1;
        $('.ui-jqgrid-btable td:nth-child(' + ViewId + ')').hide();
    }
    if ($('.ui-jqgrid-btable td[aria-describedby=grid_View]').length > 0) {
        $('#grid_View').hide();
        var ViewId = $('.ui-jqgrid-btable td[aria-describedby=grid_View]')[0].cellIndex + 1;
        $('.ui-jqgrid-btable td:nth-child(' + ViewId + ')').hide();
    }
}

function VerifyHide() {

    if ($('.ui-jqgrid-btable td[aria-describedby=grid_verify]').length > 0) {
        $('#grid_verify').remove();
        var VerifyId = $('.ui-jqgrid-btable td[aria-describedby=grid_verify]')[0].cellIndex + 1;
        $('.ui-jqgrid-btable td:nth-child(' + VerifyId + ')').remove();
    }
    if ($('.ui-jqgrid-btable td[aria-describedby=grid_Verify]').length > 0) {
        $('#grid_Verify').remove();
        var VerifyId = $('.ui-jqgrid-btable td[aria-describedby=grid_Verify]')[0].cellIndex + 1;
        $('.ui-jqgrid-btable td:nth-child(' + VerifyId + ')').remove();
    }
}

function AcknowledgeHide() {

    if ($('.ui-jqgrid-btable td[aria-describedby=grid_acknowledge]').length > 0) {
        $('#grid_acknowledge').hide();
        var AcknowledgeId = $('.ui-jqgrid-btable td[aria-describedby=grid_acknowledge]')[0].cellIndex + 1;
        $('.ui-jqgrid-btable td:nth-child(' + AcknowledgeId + ')').remove();
    }
    if ($('.ui-jqgrid-btable td[aria-describedby=grid_Acknowledge]').length > 0) {
        $('#grid_Acknowledge').hide();
        var AcknowledgeId = $('.ui-jqgrid-btable td[aria-describedby=grid_Acknowledge]')[0].cellIndex + 1;
        $('.ui-jqgrid-btable td:nth-child(' + AcknowledgeId + ')').remove();
    }
}

function RecommendHide() {

    if ($('.ui-jqgrid-btable td[aria-describedby=grid_recommend]').length > 0) {
        $('#grid_recommend').hide();
        var RecommendId = $('.ui-jqgrid-btable td[aria-describedby=grid_recommend]')[0].cellIndex + 1;
        $('.ui-jqgrid-btable td:nth-child(' + RecommendId + ')').remove();
    }
    if ($('.ui-jqgrid-btable td[aria-describedby=grid_Recommend]').length > 0) {
        $('#grid_Recommend').hide();
        var RecommendId = $('.ui-jqgrid-btable td[aria-describedby=grid_Recommend]')[0].cellIndex + 1;
        $('.ui-jqgrid-btable td:nth-child(' + RecommendId + ')').remove();
    }
}

function ApproveHide() {

    if ($('.ui-jqgrid-btable td[aria-describedby=grid_approve]').length > 0) {
        $('#grid_approve').hide();
        var ApproveId = $('.ui-jqgrid-btable td[aria-describedby=grid_approve]')[0].cellIndex + 1;
        $('.ui-jqgrid-btable td:nth-child(' + ApproveId + ')').remove();
    }
    if ($('.ui-jqgrid-btable td[aria-describedby=grid_Approve]').length > 0) {
        $('#grid_Approve').hide();
        var ApproveId = $('.ui-jqgrid-btable td[aria-describedby=grid_Approve]')[0].cellIndex + 1;
        $('.ui-jqgrid-btable td:nth-child(' + ApproveId + ')').remove();
    }
}


function RejectHide() {

    if ($('.ui-jqgrid-btable td[aria-describedby=grid_reject]').length > 0) {
        $('#grid_reject').hide();
        var RejectId = $('.ui-jqgrid-btable td[aria-describedby=grid_reject]')[0].cellIndex + 1;
        $('.ui-jqgrid-btable td:nth-child(' + RejectId + ')').remove();
    }
    if ($('.ui-jqgrid-btable td[aria-describedby=grid_Reject]').length > 0) {
        $('#grid_Reject').hide();
        var RejectId = $('.ui-jqgrid-btable td[aria-describedby=grid_Reject]')[0].cellIndex + 1;
        $('.ui-jqgrid-btable td:nth-child(' + RejectId + ')').remove();
    }
}