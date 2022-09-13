var AsisModal = {
    CtrlDetail: null,
    CurrentModalDetail: null,
    RevertInput: {},
    Init: function (eventElement, inputObject, ControllID) {
    
        CtrlDetail = $(eventElement).data('controller-detail');
        if (CtrlDetail != null) {
            var inputKey = CtrlDetail.ObjKey;
            if (inputKey != 'undefined' && inputKey != null && inputObject != 'undefined' && inputObject != null) {
                this.RevertInput[inputKey] = inputObject;
            }
            else {
                this.RevertInput[inputKey] = null;
            }
            CurrentModalDetail = $(eventElement).data('modal-composer');
            
            if (CurrentModalDetail != null) {
                var AsisModalID = CurrentModalDetail.Id.replace('#', '');
                if ($(CurrentModalDetail.Id).length == 0) {
                    var modalTemp = '<div id="' + AsisModalID + '" class="modal fade" data-backdrop="static" tabindex="-1" ng-controller="AsisModalCtrl" ng-init="Init();">';
                    modalTemp += '<div class="modal-dialog"><div class="modal-content">';
                    modalTemp += '<div class="modal-header"><h4 class="modal-title"><label>' + CurrentModalDetail.Title + '</label><button id="current-modal-id" value="' + inputKey + '" data-current-ctrl-id="' + CtrlDetail.Id + '" data-current-modal-id="' + CurrentModalDetail.Id + '" class="close" ng-click="CancelCallBack($event);">&times;</button></h4></div>';//data-dismiss="modal"
                    modalTemp += '<div class="modal-body">' + $(CurrentModalDetail.Content).html(); + '</div>';
                    modalTemp += '<div class="modal-footer buttonCenter">';
                   
                   // modalTemp += '<button id="' + AsisModalID + 'Cancel" type="button" class="btn btn-grey" value="' + inputKey + '" data-current-ctrl-id="' + CtrlDetail.Id + '" data-current-modal-id="' + CurrentModalDetail.Id + '" ng-click="CancelCallBack($event);">Close</button>';
                    
                     if(ControllID !='undefined')
                    {
                        ControllID.ActionType != "VIEW" ?  
                        modalTemp += '<button id="' + AsisModalID + 'Save" type="button" class="btn btn-primary" value="' + inputKey + '" data-current-ctrl-id="' + CtrlDetail.Id + '" data-current-modal-id="' + CurrentModalDetail.Id + '" ng-click="SaveCallBack($event);">Save</button>' : "";
                    }
                    else
                    {
                        modalTemp += '<button id="' + AsisModalID + 'Save" type="button" class="btn btn-primary" value="' + inputKey + '" data-current-ctrl-id="' + CtrlDetail.Id + '" data-current-modal-id="' + CurrentModalDetail.Id + '" ng-click="SaveCallBack($event);">Save</button>';
                     }
                     modalTemp += '<button id="' + AsisModalID + 'Cancel" type="button" class="btn btn-grey btnCenter" value="' + inputKey + '" data-current-ctrl-id="' + CtrlDetail.Id + '" data-current-modal-id="' + CurrentModalDetail.Id + '" ng-click="CancelCallBack($event);">Close</button>';

                    modalTemp += '</div></div></div></div>';
                    $(CtrlDetail.Id).append($(modalTemp));
                    //To Inject Parent Scope.

                    angular.element(CtrlDetail.Id).injector().invoke(function ($compile) {
                        var scope = angular.element(CurrentModalDetail.Id).scope();
                        $compile(CurrentModalDetail.Id)(scope);
                    });
                    $(CurrentModalDetail.Id).modal('show');
                    if(ControllID !='undefined')
                    {
                        ControllID.ActionType == "VIEW" ? $(CurrentModalDetail.Id + "Save").hide() : 
                                                $(CurrentModalDetail.Id + "Save").show();
                        ControllID.ActionType == "VIEW" ? $("#"+ControllID.Add).hide() : 
                                                $("#" + ControllID.Add).show();
                    }
                }
                else {
                    $(CurrentModalDetail.Id + "Save").val(inputKey);
                    $(CurrentModalDetail.Id + "Cancel").val(inputKey);
                    $(CurrentModalDetail.Id).modal('show');
                }
            }
            else {
                console.log("Please provide data-modal-composer='' in modal button.");
            }
        }
        else {
            console.log("Please provide data-controller-detail='' in modal button.");
        }
    }
};



appUETrack.controller("AsisModalCtrl", function ($scope) {
    $scope.Init = function () {

    };

    $scope.SaveCallBack = function (eventElement) {
        var currentModalID = $(eventElement.target).data('current-modal-id');
        var currentKey = $(eventElement.target).val();
        var parentControllerID = $(eventElement.target).data('current-ctrl-id');
        
       var isClosePopup = angular.element(parentControllerID).scope().OnAsisModalSave(currentModalID, currentKey, $scope.$parent);
        if (isClosePopup) {
            $(currentModalID).modal('hide');
        }
    };

    $scope.CancelCallBack = function (eventElement) {
        var currentModalID = $(eventElement.target).data('current-modal-id');
        var currentKey = $(eventElement.target).val();
        var parentControllerID = $(eventElement.target).data('current-ctrl-id');
        if (AsisModal.RevertInput != null && AsisModal.RevertInput[currentKey] != null) {
            var isClosePopup = angular.element(parentControllerID).scope().OnAsisModalCancel
                (currentModalID, currentKey, AsisModal.RevertInput[currentKey]);
            if (isClosePopup) {
                $(currentModalID).modal('hide');
            }
        }
    };
});

/*//Normal Syntex: 
//<button type="button" onclick="AsisModal.Init(this,'testObject');" class="btn btn-sm btn-primary" data-controller-detail='{"Id":"#ClsUserArea","ObjKey":"testKey"}' data-modal-composer='{"Id":"#AsisModal","Title":"testTitle","Content":"#TestContent"}'><i class="glyphicon glyphicon-floppy-disk"></i></button>

//In Html Syntex: 
//<script id="TestContent" type="text/html">
//Your Modal Body Content
//</script>

//In Table List Syntex: 
//<button type="button" ng-click="ValueFromToiletToCubicle($index,$event)" class="btn btn-sm btn-danger" data-controller-detail='{"Id":"#ClsUserArea","ObjKey":"{{$index}}"}' data-modal-composer='{"Id":"#AsisModal","Title":"test1","Content":"#Content1"}'><i class="glyphicon glyphicon-floppy-disk"></i></button>

//In your Controller.js Syntex:
 //$scope.ValueFromToiletToCubicle = function ($index, event) {
 //       var IsDuplicateList = IsDuplicateListValidation($index);
 //       if (!IsDuplicateList) {
 //           $scope.ToiletCubicle = {};
 //           $scope.ClsUserAreaTotalCubicalMsts = [];
 //           $scope.ToiletCubicle = $scope.ToiletDetails[$index];
 //           if ($scope.ToiletDetails[$index].ClsUserAreaTotalCubicalMsts.length > 0) {
 //               $scope.ClsUserAreaTotalCubicalMsts = $scope.ToiletDetails[$index].ClsUserAreaTotalCubicalMsts;
 //           }
 //           else {
 //               $scope.ToiletCubicle.ClsUserAreaTotalCubicalMsts = $scope.ClsUserAreaTotalCubicalMsts;
 //           }
 //           AsisModal.Init(event.target, $scope.ToiletCubicle);
 //       }
 //   };

 //   $scope.OnAsisModalSave = function (currentModalID, key, ToutPutScope) {
 //       var closePopupFlag = false;
 //       try {
 //           if (currentModalID == "#AsisModal") {
 //               var currentIndex = parseInt(key);
 //               $scope.ToiletDetails[currentIndex].ClsUserAreaTotalCubicalMsts = ToutPutScope.ToiletCubicle.ClsUserAreaTotalCubicalMsts;
 //               return closePopupFlag = true;
 //           }
 //       } catch (e) {
 //           return closePopupFlag = false;
 //       }
 //   };

 //   $scope.OnAsisModalCancel = function (currentModalID, key, TrevertOutPut) {
 //       var closePopupFlag = false;
 //       try {
 //           if (currentModalID == "#AsisModal") {
 //               var currentIndex = parseInt(key);
 //               if ($scope.ToiletDetails[currentIndex].ClsUserAreaTotalCubicalMsts.length > 0) {
 //                   for (var i = 0; i < $scope.ToiletDetails[currentIndex].ClsUserAreaTotalCubicalMsts.length; i++) {
 //                       if ($scope.ToiletDetails[currentIndex].ClsUserAreaTotalCubicalMsts[i].CubicalId == 0) {
 //                           $scope.ToiletDetails[currentIndex].ClsUserAreaTotalCubicalMsts.splice(i, 1);
 //                           $scope.ToiletDetails[currentIndex].TotalCubicle = $scope.ToiletDetails[currentIndex].ClsUserAreaTotalCubicalMsts.length;
 //                           if ($scope.ToiletDetails[currentIndex].TotalCubicle == 0) {
 //                               $scope.ToiletDetails[currentIndex].TotalCubicle = "";
 //                           }
 //                           i--;
 //                       }
 //                   }
 //               }
 //               return closePopupFlag = true;
 //           }
 //       } catch (e) {
 //           return closePopupFlag = false;
 //       }
 //   };*/
