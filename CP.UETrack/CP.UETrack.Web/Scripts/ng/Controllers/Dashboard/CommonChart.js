Highcharts.setOptions({
    chart: {
        style: {
            fontFamily: 'inherit'
        }
    },
    exporting: {
        enabled : false
    },
    lang: {
        decimalPoint: '.',
        thousandsSep: ',',
        drillUpText: '◁ Back to {series.CustomName} Level',
        style: {
            fontSize: '10px',
        }
    },
    tooltip: {
        headerFormat: '<b>{point.value}</b><br/>',
        pointFormat: '<span style="color:{point.color}">\u25CF</span> {point.name} : {point.y}<br/>',
        followPointer: true
    },
    legend: {
        itemStyle: {
            "fontWeight": "normal"
        },
        //itemHoverStyle: { "color": "#FFFFFF" }
    },
    xAxis: {
        labels: {
            formatter: function () {
                return '<span style="font-weight: bold;">' + this.value + '</span>';
            },
            style: {
                //"color": '#FFF',
            }
        }
    },
    yAxis: {
        allowDecimals: false,
        labels: {
            formatter: function () {
                return '<span style="font-weight: bold;">' + this.value + '</span>';
            },
            style: {
                //"color": '#FFF',
            }
        }
    },
    plotOptions: {
        series: {
            maxPointWidth: 50,
            turboThreshold: 10000000000,
            states: {
                hover: {
                    enabled: false
                }
            }
        }
    },
    colors: ['#69B34A', '#2A6BB4', '#ECBA0E', '#1BA4D4', '#EE7422', '#CB2326', '#DDDF00', '#24CBE5', '#64E572', '#FF9655', '#CB2326',
        '#EEF475', '#C4C4B7', '#89EEB0', '#B5E678', '#7cb5ec', '#434348', '#90ed7d', '#f7a35c', '#8085e9',
   '#f15c80', '#e4d354', '#2b908f', '#f45b5b', '#91e8e1']
});

function CommonChart(ChartData) {

    var chart = new Highcharts.Chart({
        lang: {
            noData: (!(ChartData.Err || 0) && 1) && "No Data." || (ChartData.CustomNoDataMessage || "No Data")
        },
        chart: {
            renderTo: ChartData.RenderTo,
            type: ChartData.ChartType,
            backgroundColor: null,
            height: 235
        },
        title: {
            text: ''
        },
        subtitle: {
            text: ''
        },
        xAxis: {
            categories: true,
            tickLength: 0,
            lineWidth: 1
        },
        yAxis: {
            lineWidth: 1,
            gridLineWidth: 0,
            min: 0,
            title: {
                text: '',
                //align: 'high'
            }
        },
        tooltip: ChartData.tooltip || {
            enabled : true
        },
        legend: (ChartData && ChartData.Legend) || {
            enabled: true,
            align: 'left',
            floating: true,
            verticalAlign: 'top',
            layout: 'vertical',
            x: -10,
            y: 0,
            symbolHeight: 10,
            symbolWidth: 10,
            symbolRadius: 0,
            padding: 2,
            margin: 2
        },
        plotOptions: {
            series: {
                allowPointSelect: true,
                cursor: 'pointer',
                dataLabels: {
                    enabled: true,
                    formatter: function () {
                        switch (ChartData.customDataLabels) {
                            case "RM":
                                return "RM " + addCommas(this.y.toFixed(2));
                                break;
                            case "Decimal":
                                return addCommas(this.y.toFixed(2));
                                break;
                            case "Percentage":
                                return addCommas(this.y.toFixed(2)) + "%";
                                break;
                            default:
                                return addCommas(this.y);
                        }
                    },
                    crop: false,
                    overflow: "none",
                    distance: 1,
                    softConnector: false,
                    connectorWidth: 0,
                    style: {
                        fontWeight: 'normal'
                    }
                },
                showInLegend: true
            }
        },
        credits: {
            enabled: false
        },
        series: ChartData.Series
    });
}

function SimpleChartLogic1Bar(data, Param, customcolor) {
    var Series = [];

    var outerTemp1 = {
        name: Param,
        data: [],
        color: Highcharts.getOptions().colors[2]
    }

    if (data && data.Series1 && data.Series1.length) {
        for (var j = 0; j < data.Series1.length; j++) {
            var innerTemp1 = {
                name: data.Series1[j],
                y: data.Result1[j],
                id: data.Param1[j],
            }

            outerTemp1.data.push(innerTemp1);
        }
        Series.push(outerTemp1)

        return Series;
    } else {
        return [];
    }

}

function SimpleChartLogic2Bar(data, Params, customcolor) {
    var Series = [];

    var outerTemp1 = {
        name: Params && Params[0],
        data: [],
        color: Highcharts.getOptions().colors[2]
    }
    var outerTemp2 = {
        name: Params && Params[1],
        data: [],
        color: Highcharts.getOptions().colors[3]
    }

    if (data && data.Series1 && data.Series1.length) {
        for (var j = 0; j < data.Series1.length; j++) {
            var innerTemp1 = {
                name: data.Series1[j],
                y: data.Result1[j],
                id: data.Param1[j],
            }
            var innerTemp2 = {
                name: data.Series1[j],
                y: data.Result2[j],
                id: data.Param1[j],
            }

            outerTemp1.data.push(innerTemp1);
            outerTemp2.data.push(innerTemp2);
        }
        Series.push(outerTemp1)
        Series.push(outerTemp2)

        return Series;
    } else {
        return [];
    }
}

function SimpleChartLogic3Bar(data, Params) {
    var Series = [];

    var outerTemp1 = {
        name: Params && Params[0],
        data: [],
        color: Params && Params[3]

    }
    var outerTemp2 = {
        name: Params && Params[1],
        data: [],
        color: Params && Params[4]
    }

    var outerTemp3 = {
        name: Params && Params[2],
        data: [],
        color: Params && Params[5] 
    }

    if (data && data.Series1 && data.Series1.length) {
        for (var j = 0; j < data.Series1.length; j++) {
            var innerTemp1 = {
                name: data.Series1[j],
                y: data.Result1[j],
                id: data.Param1[j],
            }
            var innerTemp2 = {
                name: data.Series1[j],
                y: data.Result2[j],
                id: data.Param1[j],
            }

            var innerTemp3 = {
                name: data.Series1[j],
                y: data.Result3[j],
                id: data.Param1[j],
            }

            outerTemp1.data.push(innerTemp1);
            outerTemp2.data.push(innerTemp2);
            outerTemp3.data.push(innerTemp3);
        }
        Series.push(outerTemp1)
        Series.push(outerTemp2)
        Series.push(outerTemp3)

        return Series;
    } else {
        return [];
    }
}

function addCommas(nStr) {
    nStr += '';
    x = nStr.split('.');
    x1 = x[0];
    x2 = x.length > 1 ? '.' + x[1] : '';
    var rgx = /(\d+)(\d{3})/;
    while (rgx.test(x1)) {
        x1 = x1.replace(rgx, '$1' + ',' + '$2');
    }
    return x1 + x2;
}