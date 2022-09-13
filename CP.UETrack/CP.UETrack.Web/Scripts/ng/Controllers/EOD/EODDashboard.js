$(document).ready(function () {

   
    $('#myPleaseWait').modal('show');

    $("#YearId").change(function () {
        var LoadData = GetYearMonth(this.value);

        $('#MonthId').empty();
        $.each(LoadData.MonthData, function (index, value) {
            var Selected = "";
            if (new Date().getMonth() == index)
                Selected = "selected"

            $('#MonthId').append('<option ' + Selected + ' value="' + (index + 1) + '">' + value[index + 1] + '</option>');
        });

        $.get("/api/EODDashboard/Load/" + this.value + "/" + $('#MonthId').val())
        .done(function (result) {
            var loadResult = JSON.parse(result);

            LoadChangeDataFill(loadResult);
        })
      .fail(function () {
          $('#myPleaseWait').modal('hide');
          $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
          $('#errorMsg').css('visibility', 'visible');
      });

    });

    $("#MonthId").change(function () {
        var Year = $("#YearId").val();

        $.get("/api/EODDashboard/Load/" + Year + "/" + this.value)
        .done(function (result) {
            var loadResult = JSON.parse(result);

            LoadChangeDataFill(loadResult);
        })
      .fail(function () {
          $('#myPleaseWait').modal('hide');
          $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
          $('#errorMsg').css('visibility', 'visible');
      });

    });

    var LoadData = GetYearMonth();
    $.each(LoadData.MonthData, function (index, value) {
        var Selected = "";
        if (new Date().getMonth() == index)
            Selected = "selected"

        $('#MonthId').append('<option ' + Selected + ' value="' + (index + 1) + '">' + value[index + 1] + '</option>');
    });
    $.each(LoadData.YearData, function (index, value) {
        var Selected = "";
        if (new Date().getFullYear() == value)
            Selected = "selected"

        $('#YearId').append('<option ' + Selected + ' value="' + value + '">' + value + '</option>');
    });

    var UrlData = { Year: $('#YearId').val(), Month: $('#MonthId').val() }
    $.get("/api/EODDashboard/Load/" + UrlData.Year + "/" + UrlData.Month)
        .done(function (result) {
            var loadResult = JSON.parse(result);
            
            LoadChangeDataFill(loadResult);

        })
      .fail(function () {
          $('#myPleaseWait').modal('hide');
          $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
          $('#errorMsg').css('visibility', 'visible');
      });

    var FacilityId = 0;
    var NoofMonth = 12;
    $.get("/api/EODDashboard/getChartData/" + NoofMonth + "/" + FacilityId)
        .done(function (result) {
            var loadResult = JSON.parse(result);
            
            InitChartCall(loadResult);

            //SeriesDataFormation(loadResult.DashboardGridData, 'abc');

        })
      .fail(function () {
          $('#myPleaseWait').modal('hide');
          $("div.errormsgcenter").text(Messages.COMMON_FAILURE_MESSAGE);
          $('#errorMsg').css('visibility', 'visible');
      });

    $("#btnFetchCancel,#btnSaveCancel").click(function () {
        window.location.href = "/eod";
    });
    $("#btnAddNew").click(function () {
        window.location.href = window.location.href;
    });
});

function LoadChangeDataFill(result) {

    $("#EODTbodyGridId").empty();

    //$("#EODTbodyGridId").append('<tr><td colspan="4"><h4 class="text-center">No records to display</h4></td></tr>');


    //getResult.EODCaptureGridData[index].ParamterValue
    $.each(result.DashboardGridData, function (index, value) {
        AddNewRow();
        $("#CategorySystemName_" + index).text(result.DashboardGridData[index].CategorySystemName);
        $("#PassCount_" + index).text(result.DashboardGridData[index].Pass);
        $("#FailCount_" + index).text(result.DashboardGridData[index].Fail);
    });
}

function errorMsg(errMsg) {
    $("div.errormsgcenter").text((!Messages[errMsg]) ? errMsg : Messages[errMsg]).css('visibility', 'visible');

    $('#btnlogin').attr('disabled', false);
    $('#myPleaseWait').modal('hide');
    InvalidFn();
    return false;
}

function EODInlineGridHtml() {
    return '<tr><td style="text-align:left;"><label name="Item" id="CategorySystemName_maxindexval" class=""></label></td>' +
                '<td style="text-align:center;"><label id="PassCount_maxindexval" name="Item" class=""></label></td>' +
                '<td style="text-align:center;"><label id="FailCount_maxindexval" name="Count" class="text-center"></label></td>';
}

function AddNewRow() {

    var inputpar = {
        inlineHTML: EODInlineGridHtml(),
        TargetId: "#EODTbodyGridId",
        TargetElement: ["tr"]
    }
    AddNewRowToDataGrid(inputpar);
}


function InitChartCall(loadResult) {
    var ChartOptions;

    (function () {
        ChartOptions = {
            ChartType: 'line',
            RenderTo: 'EOD_Dashboard_Chart',
            Legend: { enabled: true },
            tooltip: {
                formatter: function () {
                    return '<span style="color:' + this.color + '">\u25CF</span> ' + this.key + ' : ' + addCommas(this.y) + ' %';
                }
            },
            Series: [{
                name: "BEMS Pass (%)",
                color: "#8A8FEB",
                data: dataOptions(loadResult)
                   
            }]
        }
        CommonChart(ChartOptions);

    })();
}

function dataOptions(loadResult) {

    var month = []; var year = []; var PassPer = []; var arr = [];
    for (ind = 0; ind < loadResult.DashboardGridData.length; ind++) {
        month = loadResult.DashboardGridData[ind].MonthName;
        year = loadResult.DashboardGridData[ind].Year;
        PassPer = loadResult.DashboardGridData[ind].PassPerc;

        arr.push({ name:month+' '+year, y: PassPer });

    }
    return arr;
}

function SeriesDataFormation(SeriesData, SeriesName) {

    var colors = ['#90ED7D', '#F7A35B', '#7CB5EC', '#434348', '#F45A5A', '#CB2326', '#DDDF00', '#24CBE5', '#64E572', '#FF9655', '#CB2326',
        '#EEF475', '#C4C4B7', '#89EEB0', '#B5E678', '#7cb5ec', '#434348', '#90ed7d', '#f7a35c', '#8085e9',
   '#f15c80', '#e4d354', '#2b908f', '#f45b5b', '#91e8e1']
    var data = [];

    var Series = [{
        name: SeriesName,
        data: [{ name: '', y: '', color: '' }]
    }];

    //var ar = [];
    //var innerTemp = [];
    if (SeriesData && SeriesData.length) {
        for (var i = 0; i < SeriesData.length; i++) {
           var innerTemp = {
                name: SeriesData[i].MonthName,
                y: SeriesData[i].PassPerc,
                color: colors[i],
            }
            //ar.push({ name: SeriesData[i].MonthName, y: SeriesData[i].PassPerc, color: colors[i] });
            //Series.data.push(ar);
            Series.data.push(innerTemp);
           //ar.push(innerTemp);
        }
        //Series.data.push(ar);
        
        return Series;
    } else {
        return [];
    }

}

