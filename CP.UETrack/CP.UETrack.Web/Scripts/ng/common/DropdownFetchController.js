appUETrack.controller("DropdownFetchController", function ($scope, $window, $http) {
    var callMethod;
    var returnValueMethod;
    var resetValueMethod
    $scope.init = function () {
        $scope.FetchResult = [];
    }

    $scope.$on('FetchLookUp', function (event, args) {
        var searchKey;        
        if (args.searchKey == undefined || args.searchKey == '')
            args.searchKey = "☺";
        else
            return false;

        args.searchKey = args.searchKey.split("/");
        args.searchKey = args.searchKey.join("²");

        $scope.callMethod = args.callMethod;
        $scope.returnValueMethod = args.returnValueMethod;
        $scope.resetValueMethod = args.resetValueMethod;
        $scope.FetchRecords(args.searchKey);
        //$('#dropList').show();
    });

    $scope.FetchRecords = function (searchKey) {
        $scope.fcurrentPage = 1;
        $scope.PageIndex = 1;
        $scope.PageSize = 5;
        $scope.searchKey = searchKey;
        $scope.$emit($scope.resetValueMethod);
        $scope.$emit($scope.callMethod);
        $scope.Pagination = {};
        $scope.Pagination.startIndex = 1;
        $scope.Pagination.endIndex = 5;

    }

    $scope.$on('FetchSearchRecords', function (event, args) {
       // if (args.searchKey.length < 2) {
            $scope.$emit(args.resetValueMethod);
      //  }
        if (!AllowFetch(args.searchKey, '#dropList')) {
            $scope.callMethod = args.callMethod;
            $scope.returnValueMethod = args.returnValueMethod;
            $scope.resetValueMethod = args.resetValueMethod;
            args.searchKey = args.searchKey.split("/");
            args.searchKey = args.searchKey.join("²");
            $scope.FetchRecords(args.searchKey);
        }
    });

    $scope.$on('serverResponse', function (event, args) {
        $scope.FetchResult = args.returnData;
        $scope.setPagination();
        $('#dropList').show();
    });

    $scope.prevClick = function () {
        if ($scope.PageIndex > 1) {
            $scope.PageIndex = $scope.PageIndex - 1;
            var startIndex = ($scope.PageIndex * $scope.PageSize) - 4;
            var endIndex = ($scope.PageIndex * $scope.PageSize);
            $scope.$emit($scope.callMethod);
            $scope.Pagination.startIndex = startIndex;
            $scope.Pagination.endIndex = endIndex;
            $scope.setPagination();
        }
        else {
            $scope.Pagination.startIndex = 1;
            $scope.Pagination.endIndex = 5;
        }
    };

    $scope.nextClick = function () {
        if ($scope.PageIndex != $scope.LastPage) {
            $scope.PageIndex = $scope.PageIndex + 1;
            $scope.$emit($scope.callMethod);
            var startIndex = ($scope.PageIndex * $scope.PageSize) - 4;
            var endIndex = ($scope.PageIndex * $scope.PageSize);
            $scope.Pagination.startIndex = startIndex;
            $scope.Pagination.endIndex = endIndex;
            $scope.setPagination();
        }
    };

    $scope.setPagination = function () {
        if ($scope.FetchResult.length > 0) {
            var pageSize = $scope.pageSize;
            $scope.FetchPageResult = $scope.FetchResult.slice(($scope.fcurrentPage - 1) * pageSize);
            $scope.Pagination.totalRecords = $scope.FetchResult[0].TotalRecords;
            $scope.Pagination.LastPage = $scope.FetchResult[0].LastPage;
            $scope.Pagination.currentPage = $scope.FetchResult[0].PageIndex + 1;
            $scope.LastPage = $scope.FetchResult[0].LastPage;
            var endIndex = $scope.Pagination.endIndex;
            if ($scope.Pagination.totalRecords < endIndex) {
                $scope.Pagination.endIndex = $scope.Pagination.totalRecords;
            }
        }
        else {
            $scope.FetchPageResult = [];
            $scope.$emit($scope.resetValueMethod);
        }
    }
    $scope.mapSelectedItem = function (selectedItem) {
        $('#dropList').hide();
        $scope.$emit($scope.returnValueMethod, { selectedItem : selectedItem });
    }
});