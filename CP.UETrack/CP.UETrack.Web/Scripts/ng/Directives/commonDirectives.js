/* Start and end date validation directives */
appUETrack.directive("ngDateStart", function ($timeout) {
    return {
        require: 'ngModel',
        restrict: 'C',
        link: function (scope, elem, attrs, ngModel) {
            $timeout(function () {

                function dateFormat(date) {
                    if (attrs.ngVaidation == "AAGreaterThenBB") {

                        return getPreviousDate(date);
                    }
                    from = date.split("-");
                    var date = new Date(from[2], from[1] - 1, from[0]);
                    date.setDate(date.getDate());
                    return date;
                }
                var enddate = "";
                if ($(elem).parents('tr').length > 0) {
                    enddate = $(elem).parents('tr').find(".ngDateEnd");
                }
                else {
                    enddate = $(elem).closest('.row').find(".ngDateEnd");
                }
                // console.log(attrs);
                $(elem).datetimepicker({
                    format: 'd-m-Y',
                    timepicker: false,
                    scrollInput: false,
                    onShow: function (ct) {
                        this.setOptions({
                            maxDate: $(enddate).val() ? new Date(dateFormat($(enddate).val())) : false
                        });
                    }
                });

            }, 0);
        }
    };
});

appUETrack.directive("mmmngDateStart", function ($timeout) {
    return {
        require: 'ngModel',
        restrict: 'C',
        link: function (scope, elem, attrs, ngModel) {
            $timeout(function () {

                function dateFormat(date) {
                    if (attrs.ngVaidation == "AAGreaterThenBB") {

                        return getPreviousDate(date);
                    }
                    from = date.split("-");
                    var date = new Date(from[2], from[1] - 1, from[0]);
                    date.setDate(date.getDate());
                    return date;
                }
                var enddate = "";
                if ($(elem).parents('tr').length > 0) {
                    enddate = $(elem).parents('tr').find(".mmmngDateEnd");
                }
                else {
                    enddate = $(elem).closest('.row').find(".mmmngDateEnd");
                }
                // console.log(attrs);
                $(elem).datetimepicker({
                    format: 'd-M-Y',
                    timepicker: false,
                    scrollInput: false,
                    onShow: function (ct) {
                        this.setOptions({
                            maxDate: $(enddate).val() ? new Date(dateFormat($(enddate).val())) : false
                        });
                    }
                });

            }, 0);
        }
    };
});
appUETrack.directive("ngDateStartTime", function ($timeout) {
    return {
        require: 'ngModel',
        restrict: 'C',
        link: function (scope, elem, attrs, ngModel) {
            $timeout(function () {

                function dateFormat(date) {
                    if (attrs.ngVaidation == "AAGreaterThenBB") {

                        return getPreviousDate(date);
                    }
                    from = date.split("-");
                    var date = new Date(from[2], from[1] - 1, from[0]);
                    date.setDate(date.getDate());
                    return date;
                }
                var enddate = "";
                if ($(elem).parents('tr').length > 0) {
                    enddate = $(elem).parents('tr').find(".ngDateEnd");
                }
                else {
                    enddate = $(elem).closest('.row').find(".ngDateEnd");
                }
                // console.log(attrs);
                $(elem).datetimepicker({
                    format: 'd-m-Y H:i',

                    scrollInput: false,
                    onShow: function (ct) {
                        this.setOptions({
                            maxDate: $(enddate).val() ? new Date(dateFormat($(enddate).val())) : false
                        });
                    }
                });

            }, 0);
        }
    };
});

appUETrack.directive("ngDateFuture", function ($timeout) {
    return {
        require: 'ngModel',
        restrict: 'C',
        link: function (scope, elem, attrs, ngModel) {
            $timeout(function () {
                $(elem).datetimepicker({
                    format: 'd-M-Y',
                    timepicker: false,
                    scrollInput: false,
                    onShow: function (ct) {
                        this.setOptions({
                            maxDate: 0
                        });
                    }
                });

            }, 0);
        }
    };
});

appUETrack.directive("ngDatePast", function ($timeout) {
    return {
        require: 'ngModel',
        restrict: 'C',
        link: function (scope, elem, attrs, ngModel) {
            $timeout(function () {
                $(elem).datetimepicker({
                    format: 'd-M-Y',
                    timepicker: false,
                    scrollInput: false,
                    onShow: function (ct) {
                        this.setOptions({
                            minDate: 0
                        });
                    }
                });

            }, 0);
        }
    };
});


appUETrack.directive("ngDateTimeFuture", function ($timeout) {
    return {
        require: 'ngModel',
        restrict: 'C',
        link: function (scope, elem, attrs, ngModel) {
            $timeout(function () {
                $(elem).datetimepicker({
                    format: 'd-M-Y H:i',
                    timepicker: true,
                    scrollInput: false,
                    onShow: function (ct) {
                        this.setOptions({
                            maxDate: 0,
                        });
                    }
                });

            }, 0);
        }
    };
});

appUETrack.directive("ngDateTime", function ($timeout) {
    return {
        require: 'ngModel',
        restrict: 'C',
        link: function (scope, elem, attrs, ngModel) {
            $timeout(function () {
                $(elem).datetimepicker({
                    format: 'd-M-Y H:i',
                    timepicker: true,
                    scrollInput: false,
                    onShow: function (ct) {
                        this.setOptions({
                          
                        });
                    }
                });

            }, 0);
        }
    };
});

appUETrack.directive("ngDateEnd", function ($timeout) {
    return {
        require: 'ngModel',
        restrict: 'C',
        link: function (scope, elem, attrs, ngModel) {
            $timeout(function () {

                function dateFormat(date) {
                    if (attrs.ngVaidation == "AAGreaterThenBB") {
                        return getNextDate(date);
                    }
                    from = date.split("-");
                    var date = new Date(from[2], from[1] - 1, from[0]);
                    date.setDate(date.getDate());
                    return date;
                }
                var startDate = "";
                if ($(elem).parents('tr').length > 0) {
                    startDate = $(elem).parents('tr').find(".ngDateStart");
                }
                else {
                    startDate = $(elem).closest('.row').find(".ngDateStart");
                }

                $(elem).datetimepicker({
                    format: 'd-m-Y',
                    timepicker: false,
                    scrollInput: false,
                    onShow: function (ct) {
                        this.setOptions({
                            minDate: $(startDate).val() ? new Date(dateFormat($(startDate).val())) : false
                        });
                    }
                });

            }, 0);
        }
    };
});


/* Start and end date validation directives */
appUETrack.directive("ngDateStartSameRow", function ($timeout) {
    return {
        require: 'ngModel',
        restrict: 'C',
        link: function (scope, elem, attrs, ngModel) {
            $timeout(function () {

                function dateFormat(date) {
                    from = date.split("-");
                    var date = new Date(from[2], from[1] - 1, from[0]);
                    date.setDate(date.getDate());
                    return date;
                }

                var enddate = $(".ngDateEndSameRow");

                $(elem).datetimepicker({
                    format: 'd-m-Y',
                    timepicker: false,
                    scrollInput: false,
                    onShow: function (ct) {
                        this.setOptions({
                            maxDate: $(enddate).val() ? new Date(dateFormat($(enddate).val())) : false
                        });
                    }
                });

            }, 0);
        }
    };
});
//$(elem).parents('tr').length 
// $(elem).closest('.row').find('.ngDateEnd')

appUETrack.directive("ngDateEndSameRow", function ($timeout) {
    return {
        require: 'ngModel',
        restrict: 'C',
        link: function (scope, elem, attrs, ngModel) {
            $timeout(function () {

                function dateFormat(date) {
                    from = date.split("-");
                    var date = new Date(from[2], from[1] - 1, from[0]);
                    date.setDate(date.getDate());
                    return date;
                }
                var startDate = $(".ngDateStartSameRow");

                $(elem).datetimepicker({
                    format: 'd-m-Y',
                    timepicker: false,
                    scrollInput: false,
                    onShow: function (ct) {
                        this.setOptions({
                            minDate: $(startDate).val() ? new Date(dateFormat($(startDate).val())) : false
                        });
                    }
                });

            }, 0);
        }
    };
});



/* Start and end date validation directives */
appUETrack.directive("validateDate", function ($timeout) {
    return {
        require: 'ngModel',
        restrict: 'C',
        link: function (scope, elem, attrs, ngModel) {
            scope.$watch(attrs.ngModel, function (v) {
                $(elem).val(v);
            });
            $timeout(function () {
                $(elem).datetimepicker({
                    format: 'd-m-Y',
                    timepicker: false,

                    onShow: function (ct) {
                        this.setOptions({
                            minDate: minDateStatus(elem),
                            datepicker: DatePickerStatus(elem),
                        });
                    }
                });

            }, 0);
        }
    };
});


function minDateStatus(elem) {

    var currentIndex = $(elem).closest('.datesRowValidation').children().index($(elem).closest('td'));
    var preElement = $(elem).closest('.datesRowValidation').find(".validateDate").eq(currentIndex - 2);
    var previousDate = $(preElement).val();

    return (previousDate != "" && currentIndex != 1) ? new Date(dateFormat(previousDate)) : false;
}

function DatePickerStatus(elem) {

    var currentIndex = $(elem).closest('.datesRowValidation').children().index($(elem).closest('td'));
    var preElement = $(elem).closest('.datesRowValidation').find(".validateDate").eq(currentIndex - 2);
    var previousDate = $(preElement).val();
    return (previousDate == "" && currentIndex != 1) ? false : true;

}


function dateFormat(date) {

    from = date.split("-");
    var date = new Date(from[2], from[1] - 1, from[0]);
    date.setDate(date.getDate());
    return date;

}

function decimalData() {
    $('.decimalValidation').each(function (index) {
        $(this).attr('id', 'rentalSpace_' + index);
        var FloorArea = document.getElementById(this.id);
        FloorArea.addEventListener('input', function (prev) {
            return function (evt) {
                if ((!/^\d{0,10}(?:\.\d{0,2})?$/.test(this.value)) || this.value.length > 11) {
                    this.value = prev;
                }
                else {
                    prev = this.value;
                }
            };
        }(FloorArea.value), false);
    })
}


/* Adds  _RequestVerificationToken to all http requests*/
appUETrack.directive('ncgRequestVerificationToken', ['$http', function ($http) {
    return function (scope, element, attrs) {
        $http.defaults.headers.common['_RequestVerificationToken'] = attrs.ncgRequestVerificationToken || "no request verification token";
    };
}]);


/*
Two dates should be greater validation
*/
appUETrack.directive("ngDateStartGreater", function ($timeout) {
    return {
        require: 'ngModel',
        restrict: 'C',
        link: function (scope, elem, attrs, ngModel) {
            $timeout(function () {

                function dateFormat(date) {
                    from = date.split("-");
                    var date = new Date(from[2], from[1] - 1, from[0]);
                    date.setDate(date.getDate());
                    return date;
                }

                var enddate = "";

                if ($(elem).parents('tr').length > 0) {
                    enddate = $(elem).parents('tr').find(".ngDateEndGreater");
                }
                else {
                    enddate = $(elem).closest('.row').find(".ngDateEndGreater");
                }

                $(elem).datetimepicker({
                    format: 'd-m-Y',
                    timepicker: false,
                    scrollInput: false,
                    onShow: function (ct) {
                        this.setOptions({
                            maxDate: $(enddate).val() ? new Date(getPreviousDate($(enddate).val())) : false
                        });
                    }
                });

            }, 0);
        }
    };
});

appUETrack.directive("ngDateEndGreater", function ($timeout) {
    return {
        require: 'ngModel',
        restrict: 'C',
        link: function (scope, elem, attrs, ngModel) {
            $timeout(function () {


                var startDate = "";
                if ($(elem).parents('tr').length > 0) {
                    startDate = $(elem).parents('tr').find(".ngDateStartGreater");
                }
                else {
                    startDate = $(elem).closest('.row').find(".ngDateStartGreater");
                }

                $(elem).datetimepicker({
                    format: 'd-m-Y',
                    timepicker: false,
                    scrollInput: false,
                    onShow: function (ct) {
                        this.setOptions({
                            minDate: $(startDate).val() ? new Date(getNextDate($(startDate).val())) : false
                        });
                    }
                });

            }, 0);
        }
    };
});
appUETrack.directive("ngBetweenDate", function ($timeout) {
    return {
        require: 'ngModel',
        restrict: 'C',
        link: function (scope, elem, attrs, ngModel) {
            $timeout(function () {
                var startDate = $(elem).parent(this).find(".ngBetweenDate");

                $(elem).datetimepicker({
                    format: 'd-m-Y',
                    timepicker: false,
                    scrollInput: false,
                    onShow: function (ct) {
                        this.setOptions({
                            minDate: $(startDate).val() ? new Date(getNextDate($(startDate).val())) : false,
                            maxDate: new Date()
                        });
                    }
                });

            }, 0);
        }
    };
});
appUETrack.directive('onlyAlphaNumeric', function () {
    return {
        require: 'ngModel',
        restrict: 'A',
        link: function (scope, element, attrs, modelCtrl) {
            modelCtrl.$parsers.push(function (inputValue) {
                if (inputValue == null)
                    return ''
                cleanInputValue = inputValue.replace(/[^a-zA-Z0-9\s]/gi, '');
                if (cleanInputValue != inputValue) {
                    modelCtrl.$setViewValue(cleanInputValue);
                    modelCtrl.$render();
                }
                return cleanInputValue;
            });
        }
    }
});


appUETrack.directive("mmmngDateEnd", function ($timeout) {
    return {
        require: 'ngModel',
        restrict: 'C',
        link: function (scope, elem, attrs, ngModel) {
            $timeout(function () {

                function dateFormat(date) {
                    if (attrs.ngVaidation == "AAGreaterThenBB") {
                        return getNextDate(date);
                    }
                    from = date.split("-");
                    var date = new Date(from[2], from[1] - 1, from[0]);
                    date.setDate(date.getDate());
                    return date;
                }
                var startDate = "";
                if ($(elem).parents('tr').length > 0) {
                    startDate = $(elem).parents('tr').find(".mmmngDateStart");
                }
                else {
                    startDate = $(elem).closest('.row').find(".mmmngDateStart");
                }

                $(elem).datetimepicker({
                    format: 'd-M-Y',
                    timepicker: false,
                    scrollInput: false,
                    onShow: function (ct) {
                        this.setOptions({
                            minDate: $(startDate).val() ? new Date(dateFormat($(startDate).val())) : false
                        });
                    }
                });

            }, 0);
        }
    };
});
appUETrack.directive("mmmngDateEndTime", function ($timeout) {
    return {
        require: 'ngModel',
        restrict: 'C',
        link: function (scope, elem, attrs, ngModel) {
            $timeout(function () {

                function dateFormat(date) {
                    if (attrs.ngVaidation == "AAGreaterThenBB") {
                        return getNextDate(date);
                    }
                    from = date.split("-");
                    var date = new Date(from[2], from[1] - 1, from[0]);
                    date.setDate(date.getDate());
                    return date;
                }
                var startDate = "";
                if ($(elem).parents('tr').length > 0) {
                    startDate = $(elem).parents('tr').find(".mmmngDateStart");
                }
                else {
                    startDate = $(elem).closest('.row').find(".mmmngDateStart");
                }

                $(elem).datetimepicker({
                    format: 'd-M-Y H:i',
                    scrollInput: false,
                    onShow: function (ct) {
                        this.setOptions({
                            minDate: $(startDate).val() ? new Date(dateFormat($(startDate).val())) : false
                        });
                    }
                });

            }, 0);
        }
    };
});
appUETrack.directive("multiSelectDDL", function ($timeout) {
    return {
        require: 'ngModel',
        restrict: 'C',
        link: function (scope, element, attrs, ngModel) {
            scope.$watch(function (result) {
                if ($(element).children().length > 0) {
                    setTimeout(function(){
                        $(element).multiselect({
                            maxHeight: 200, maxWidth: 500, buttonWidth: '100%',
                            enableFiltering: true,
                            includeSelectAllOption: true
                        });
                        $("#myPleasewait").modal("hide");
                    },300);
                    $("#myPleasewait").modal("hide");
                }
            });
        }
    };
});

appUETrack.directive("multiSelectDDLwithoutSearch", function ($timeout) {
    return {
        require: 'ngModel',
        restrict: 'C',
        link: function (scope, element, attrs, ngModel) {
            scope.$watch(function (result) {
                if ($(element).children().length > 0) {
                    setTimeout(function () {
                        $(element).multiselect({
                            maxHeight: 200, maxWidth: 500, buttonWidth: '100%',
                            //enableFiltering: true,
                            includeSelectAllOption: true
                        });
                        $("#myPleasewait").modal("hide");
                    }, 300);
                    $("#myPleasewait").modal("hide");
                }
            });
        }
    };
});


appUETrack.directive("mmmngDateStartTime", function ($timeout) {
    return {
        require: 'ngModel',
        restrict: 'C',
        link: function (scope, elem, attrs, ngModel) {
            $timeout(function () {

                function dateFormat(date) {
                    if (attrs.ngVaidation == "AAGreaterThenBB") {

                        return getPreviousDate(date);
                    }
                    from = date.split("-");
                    var date = new Date(from[2], from[1] - 1, from[0]);
                    date.setDate(date.getDate());
                    return date;
                }
                var enddate = "";
                if ($(elem).parents('tr').length > 0) {
                    enddate = $(elem).parents('tr').find(".mmmngDateEnd");
                }
                else {
                    enddate = $(elem).closest('.row').find(".mmmngDateEnd");
                }
                // console.log(attrs);
                $(elem).datetimepicker({
                    format: 'd-M-Y H:i',
                    step: 30,
                    scrollInput: false,
                    onShow: function (ct) {
                        this.setOptions({
                            maxDate: $(enddate).val() ? new Date(dateFormat($(enddate).val())) : false
                        });
                    }
                });

            }, 0);
        }
    };
});

// Service Work (UnScheduled) & Work Order (Scheduled) 

appUETrack.directive('serviceWorkStatusColor', function () {
    return {
        require: 'ngModel',
        restrict: 'A',
        link: function (scope, elem, attrs, ngModel) {
            scope.$watch(function () {
                var Value = ngModel.$modelValue;
               // $(elem).css('line-height', '1.5');
               // $(elem).css('font-size', '12px');
                switch (Value) {
                    // Work Order & Service Work - FEMS / BEMS
                    case 'Open':
                        $(elem).css('background-color', '#ff4d4d'); // Red 
                        break;
                    case 'Work In Progress':
                        $(elem).css('background-color', '#FFC200'); //Amber
                        break;
                    case 'Completed':
                        $(elem).css('background-color', '#ffff80'); //Yellow
                        break;
                    case 'Closed':
                        $(elem).css('background-color', 'yellowgreen'); //Green
                        break;
                    case 'Cancelled':
                        $(elem).css('background-color', '#a6a6a6'); //Grey
                        break;
                        // Work Order & Service Work - FEMS / BEMS

                    default:
                        $(elem).css('background-color', 'White');
                        break;
                }
                // return ngModel.$modelValue;
            });
        }
    };
});

// Service Work (UnScheduled) & Work Order (Scheduled) 



// Advisory Services 

appUETrack.directive('adsColor', function () {
    return {
        require: 'ngModel',
        restrict: 'A',
        link: function (scope, elem, attrs, ngModel) {
            scope.$watch(function () {
                var Value = ngModel.$modelValue;
               // $(elem).css('line-height', '1.5');
               // $(elem).css('font-size', '12px');
                switch (Value) {
                    // Work Order & Service Work - FEMS / BEMS
                    case 'Draft':
                        $(elem).css('background-color', 'Grey'); //Rejected
                        break;
                    case 'Prepared':
                        $(elem).css('background-color', '#f69c55'); // Orange 
                        break;
                    case 'Checked':
                        $(elem).css('background-color', '#FFC200'); //Amber
                        break;
                    case 'Approved':
                        $(elem).css('background-color', '#ffff80'); //Yellow
                        break;
                    case 'Recommended':
                        $(elem).css('background-color', 'yellowgreen'); //Green
                        break;
                    case 'Conclusion':
                        $(elem).css('background-color', '#a6a6a6'); //Grey
                        break;
                    case 'Rejected':
                        $(elem).css('background-color', '#ff4d4d'); //Rejected
                        break;
                        // Work Order & Service Work - FEMS / BEMS
                    case 'Clarification Sought':
                        $(elem).css('background-color', '#ffff80'); //Rejected
                        break;
                    case 'Clarified':
                        $(elem).css('background-color', '#f69c55');
                        break;
                    default:
                        $(elem).css('background-color', 'White');
                        break;
                }
                // return ngModel.$modelValue;
            });
        }
    };
});

//escKey Function 
appUETrack.directive('escKey', function () {
    return function (scope, element, attrs) {
        element.bind('keydown keypress', function (event) {
            if (event.which === 27) { // 27 = esc key
                scope.$apply(function () {
                    scope.$eval(attrs.escKey);
                });

                event.preventDefault();
            }
        });
    };
});

appUETrack.directive('customAutofocus', function () {
    return {
        restrict: 'A',

        link: function (scope, element, attrs) {
            scope.$watch(function () {
                return scope.$eval(attrs.customAutofocus);
            }, function (newValue) {
                if (newValue === true) {
                    element[0].focus();//use focus function instead of autofocus attribute to avoid cross browser problem. And autofocus should only be used to mark an element to be focused when page loads.
                }
            });
        }
    };
});

//Effective Date with no future
appUETrack.directive("mmmngDateStartNoPast", function ($timeout) {
    return {
        require: 'ngModel',
        restrict: 'C',
        link: function (scope, elem, attrs, ngModel) {
            $timeout(function () {

                function dateFormat(date) {
                    if (attrs.ngVaidation == "AAGreaterThenBB") {

                        return getPreviousDate(date);
                    }
                    from = date.split("-");
                    var date = new Date(from[2], from[1] - 1, from[0]);
                    date.setDate(date.getDate());
                    return date;
                }
                var enddate = "";
                if ($(elem).parents('tr').length > 0) {
                    enddate = $(elem).parents('tr').find(".mmmngDateEndNoFuture");
                }
                else {
                    enddate = $(elem).closest('.row').find(".mmmngDateEndNoFuture");
                }
                // console.log(attrs);
                $(elem).datetimepicker({
                    format: 'd-M-Y',
                    timepicker: false,
                    scrollInput: false,
                    onShow: function (ct) {
                        this.setOptions({
                            minDate : getDate(),
                            maxDate: $(enddate).val() ? new Date(dateFormat($(enddate).val())) : false
                        });
                    }
                });

            }, 0);
        }
    };
});
//EndDate with no Future
appUETrack.directive("mmmngDateEndNoFuture", function ($timeout) {
    return {
        require: 'ngModel',
        restrict: 'C',
        link: function (scope, elem, attrs, ngModel) {
            $timeout(function () {

                function dateFormat(date) {
                    if (attrs.ngVaidation == "AAGreaterThenBB") {
                        return getNextDate(date);
                    }
                    from = date.split("-");
                    var date = new Date(from[2], from[1] - 1, from[0]);
                    date.setDate(date.getDate());
                    return date;
                }
                var startDate = "";
                if ($(elem).parents('tr').length > 0) {
                    startDate = $(elem).parents('tr').find(".mmmngDateStartNoPast");
                }
                else {
                    startDate = $(elem).closest('.row').find(".mmmngDateStartNoPast");
                }

                $(elem).datetimepicker({
                    format: 'd-M-Y',
                    timepicker: false,
                    scrollInput: false,
                    onShow: function (ct) {
                        this.setOptions({
                            minDate: $(startDate).val() ? new Date(dateFormat($(startDate).val())) : false,
                            maxDate: getDate()
                        });
                    }
                });

            }, 0);
        }
    };
});

//Effective Date with no Past for IssueDate --- HWMs TreatmentFacility Transportation License
appUETrack.directive("mmmngDateStartIssueDate", function ($timeout) {
    return {
        require: 'ngModel',
        restrict: 'C',
        link: function (scope, elem, attrs, ngModel) {
            $timeout(function () {

                function dateFormat(date) {
                    if (attrs.ngVaidation == "AAGreaterThenBB") {

                        return getPreviousDate(date);
                    }
                    from = date.split("-");
                    var date = new Date(from[2], from[1] - 1, from[0]);
                    date.setDate(date.getDate());
                    return date;
                }
                var enddate = "";
                if ($(elem).parents('tr').length > 0) {
                    enddate = $(elem).parents('tr').find(".mmmngDateEndExpiryDate");
                }
                else {
                    enddate = $(elem).closest('.row').find(".mmmngDateEndExpiryDate");
                }
                // console.log(attrs);
                $(elem).datetimepicker({
                    format: 'd-M-Y',
                    timepicker: false,
                    scrollInput: false,
                    onShow: function (ct) {
                        this.setOptions({
                          //  minDate: getDate(),
                            maxDate:getDate()
                        });
                    }
                });

            }, 0);
        }
    };
});

//EndDate for Expiry Date for HWMS Treatment Facility Transport and License 
appUETrack.directive("mmmngDateEndExpiryDate", function ($timeout) {
    return {
        require: 'ngModel',
        restrict: 'C',
        link: function (scope, elem, attrs, ngModel) {
            $timeout(function () {

                function dateFormat(date) {
                    if (attrs.ngVaidation == "AAGreaterThenBB") {
                        return getNextDate(date);
                    }
                    from = date.split("-");
                    var date = new Date(from[2], from[1] - 1, from[0]);
                    date.setDate(date.getDate());
                    return date;
                }
                var startDate = "";
                if ($(elem).parents('tr').length > 0) {
                    startDate = $(elem).parents('tr').find(".mmmngDateStartIssueDate");
                }
                else {
                    startDate = $(elem).closest('.row').find(".mmmngDateStartIssueDate");
                }

                $(elem).datetimepicker({
                    format: 'd-M-Y',
                    timepicker: false,
                    scrollInput: false,
                    onShow: function (ct) {
                        this.setOptions({
                            minDate: $(startDate).val() ? new Date(dateFormat($(startDate).val())) : false,
                           // maxDate: getDate()
                        });
                    }
                });

            }, 0);
        }
    };
});

//EndDatePrevious Expiry Date  for HWMS Treatment Facility Transport and License 
appUETrack.directive("mmmngDateEndPreviousExpiryDate", function ($timeout) {
    return {
        require: 'ngModel',
        restrict: 'C',
        link: function (scope, elem, attrs, ngModel) {
            $timeout(function () {

                function dateFormat(date) {
                    if (attrs.ngVaidation == "AAGreaterThenBB") {
                        return getNextDate(date);
                    }
                    from = date.split("-");
                    var date = new Date(from[2], from[1] - 1, from[0]);
                    date.setDate(date.getDate());
                    return date;
                }
                var startDate = "";
                if ($(elem).parents('tr').length > 0) {
                    startDate = $(elem).parents('tr').find(".mmmngDateStartIssueDate");
                }
                else {
                    startDate = $(elem).closest('.row').find(".mmmngDateStartIssueDate");
                }
                var endDate = "";
                if ($(elem).parents('tr').length > 0) {
                  endDate = $(elem).parents('tr').find(".mmmngDateEndExpiryDate");
                   // endDate = getPreviousDate(_endDate);
                }
                else {
                    endDate = $(elem).closest('.row').find(".mmmngDateEndExpiryDate");
                   // endDate = getPreviousDate(_endDate);
                }

                $(elem).datetimepicker({
                    format: 'd-M-Y',
                    timepicker: false,
                    scrollInput: false,
                    onShow: function (ct) {
                        this.setOptions({
                            minDate: $(startDate).val() ? new Date(dateFormat($(startDate).val())) : false,
                            maxDate: $(endDate).val() ? new Date(dateFormat($(endDate).val())) : false
                        });
                    }
                });

            }, 0);
        }
    };
});
appUETrack.directive('timeValidator', function () {
    return {
        require: 'ngModel',
        restrict: 'A',
        link: function (scope, element, attrs, modelCtrl) {
            modelCtrl.$parsers.push(function (inputValue) {
                
                var cleanInputValue;
                if (inputValue == null || inputValue == "") {
                    return ''
                }
                else
                {
                    var valu = inputValue.split(':');
                    
                    if (parseInt(valu[0]) >= 24)
                    {
                        //alert(valu[0])
                        cleanInputValue = '';
                    }
                    else
                    {
                        
                        cleanInputValue = (parseInt(valu[1])>59)?'': inputValue;
                    }
                }
                 modelCtrl.$setViewValue(cleanInputValue);
                 modelCtrl.$render();
                //alert(cleanInputValue)
                return cleanInputValue;
            });
        }
    }
});
//EndDatePrevious Expiry Date  for HWMS Treatment Facility Transport and License 
appUETrack.directive("mmmngDateEffectiveFrom", function ($timeout) {
    return {
        require: 'ngModel',
        restrict: 'C',
        link: function (scope, elem, attrs, ngModel) {
            $timeout(function () {

                function dateFormat(date) {
                  
                    from = date.split("-");
                    var date = new Date(from[2], from[1] - 1, from[0]);
                    date.setDate(date.getDate());
                    return date;
                }
               
               

                $(elem).datetimepicker({
                    format: 'd-M-Y',
                    timepicker: false,
                    scrollInput: false,
                    onShow: function (ct) {
                        this.setOptions({
                           // minDate:getDate()
                           maxDate: getDate()
                        });
                    }
                });

            }, 0);
        }
    };
});

appUETrack.directive("mmmngCurrentDate", function ($timeout) {
    return {
        require: 'ngModel',
        restrict: 'C',
        link: function (scope, elem, attrs, ngModel) {
            $timeout(function () {

                function dateFormat(date) {

                    from = date.split("-");
                    var date = new Date(from[2], from[1] - 1, from[0]);
                    date.setDate(date.getDate());
                    return date;
                }



                $(elem).datetimepicker({
                    format: 'd-M-Y',
                    timepicker: false,
                    scrollInput: false,
                    onShow: function (ct) {
                        this.setOptions({
                            minDate:getDate(),
                            maxDate:getDate()
                        });
                    }
                });

            }, 0);
        }
    };
});
