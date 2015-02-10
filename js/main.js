$(function () {


    })


function handlebutton(id){

switch (id) {


    case 'powerradio0':
        drawchart("Stromzähler","1min_day","stromcontainer","stromzaehler");
        break;

    case 'powerradio1':
        drawchart("Stromzähler","15min_day","stromcontainer","stromzaehler");
        break;

    case 'powerradio2':
        drawchart("Stromzähler","monthly_year","stromcontainer","stromzaehler");
        break;

    case 'powerradio3':
        drawchart("Stromzähler","daily_year","stromcontainer","stromzaehler");
        break;

    case 'powerradio4':
        drawchart("gaszähler","hourly_year","stromcontainer","stromzaehler");
        break;



    case 'gasradio0':
        drawchart("gaszähler","1min_day","gascontainer","gaszaehler");
        break;
    case 'gasradio1':
        drawchart("gaszähler","15min_day","gascontainer","gaszaehler");
        break;
    case 'gasradio2':
        drawchart("gaszähler","monthly_year","gascontainer","gaszaehler");
        break;

    case 'gasradio3':
        drawchart("gaszähler","daily_year","gascontainer","gaszaehler");
        break;
    case 'gasradio4':
        drawchart("gaszähler","hourly_year","gascontainer","gaszaehler");
        break;
}

}






