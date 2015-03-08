var chart; // global

function drawchart(charttitle, aggregator, container, sensor) {

    var options = {
        chart: {
            renderTo: container,

            zoomType: 'x'


        },
        title: {
            text: charttitle
        },
        xAxis: {
            type: 'datetime',
            dateTimeLabelFormats: { // don't display the dummy year
                month: '%e. %b',
                year: '%b'
            }
        },
        yAxis: {

            title: {
                text: '1/1000 Kubikmeter',
                margin: 80
            }
        },

        plotOptions: {
            area: {
                fillColor: {
                    linearGradient: { x1: 0, y1: 0, x2: 0, y2: 1},
                    stops: [
                        [0, Highcharts.getOptions().colors[0]],
                        [1, Highcharts.Color(Highcharts.getOptions().colors[0]).setOpacity(0).get('rgba')]
                    ]
                },
                marker: {
                    radius: 2
                },
                lineWidth: 1,
                states: {
                    hover: {
                        lineWidth: 1
                    }
                },
                threshold: null
            }
        },



        series: [

            {
                type: 'area',
                name: '',
                data: []
            }
        ]
    };

    $.getJSON("../cgi-bin/powerpanel/powerdata.pl?aggregator=" + aggregator+";sensor=" + sensor, function (json) {

      //$.getJSON("json.data", function (json) {
        options.xAxis.categories = json['category'];
        options.series[0].name = json['name'];
        options.series[0].data = json['values'];
        options.yAxis.title.text = json['unit'];
        options.yAxis.max = (3*json['avg']);

        options.title.text=charttitle +" "+ Date(json['date']*1000);


            chart = new Highcharts.Chart(options);


    });

};







