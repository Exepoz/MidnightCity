var up = false;
var kankart = false;
var system = false;

function popupfunction(source) {
    if(!up){
        $('#popup').fadeIn('slow');
        $('.popupclass').fadeIn('slow');
        $('<img  src='+source+' style = "width:100%; height: 100%;">').appendTo('.popupclass')
        up = true
    }
}

function popdownfunction() {
    if(up){
        $('#popup').fadeOut('slow');
        $('.popupclass').fadeOut('slow');
        $('.popupclass').html("");
        up = false
        $.post('https://wert-ambulancejob/Close', JSON.stringify({}));
    }
}

function closekankart() {
    if(kankart) {
        $('#kankart').fadeOut('slow');
        $('#csn').html('')
        $('#firstname').html('')
        $('#lastname').html('')
        $('#birthdate').html('')
        $('#kangrub').html('')
        kankart = false
    }
}


function openkankart(data) {
    if(!kankart) {
        $('#kankart').fadeIn('slow');
        $('#csn').html('<i class="fa-solid fa-id-card-clip"></i><span style="padding: 1.3vh;">Csn : ' + data.citizenid + '</span>')
        $('#firstname').html('<i class="fa-solid fa-user"></i><span style="padding: 2vh;">Firstname : ' + data.firstname + '</span>')
        $('#lastname').html('<i class="fa-solid fa-user-pen"></i><span style="padding: 1.3vh;">Lastname : ' + data.lastname + '</span>')
        $('#birthdate').html('<i class="fa-solid fa-cake-candles"></i><span style="padding: 2vh;">Birthdate : ' + data.birthdate + '</span>')
        $('#kangrub').html(data.bloodtype)
        kankart = true
    }
}

////
function database() {
    $("#main").html('')
    $('#main').css('display', 'block');
    $.post('https://wert-ambulancejob/patientdata', JSON.stringify({}), function(patientdata){
        patientdata.reverse()
        $.each(patientdata, function(i, test){
            let name = test.hasta
            let date = test.date
            let aciklama = test.aciklama

            let htmlItem = '<div id="hastasatır" data-name="' + name + '" data-aciklama="' + aciklama + '" data-date="' + date + '"><i class="fa-solid fa-bed"></i> ' + name +'  | ' + date +'</div>'
            $("#main").append(htmlItem)
        });
    });
}

function savenewpatient() {
    let name = $('#nameinfo').val();
    let aciklama = $('#aciklama').val();
    if (name !== null && name !== undefined && name !== "") {
        if (aciklama !== null && aciklama !== undefined && aciklama !== "") {
            $('#ekmenu').css('display', 'none');
            $('#ekmenu').html('');
            $.post('https://wert-ambulancejob/new-data', JSON.stringify({hasta: name, aciklama: aciklama}));
            setTimeout(function(){
                database();
            }, 250);

        } else {
            $.post('https://wert-ambulancejob/notify', JSON.stringify({notif: "Açıklama alanını doldurmalısın!"}));
        }

    } else {
        $.post('https://wert-ambulancejob/notify', JSON.stringify({notif: "Hastanın isim bilgilerini doldurmalısın!"}));
    }
}

function newpatient() {
    $('#ekmenu').css('display', 'block');
    $('#ekmenu').html(`
        <div id="closeekmenu"><i class="fa-solid fa-circle-xmark"></i></div>
        <input type="text" id="nameinfo" name="name" placeholder="Firstname Lastname"><br>
        <textarea id="aciklama" name="aciklama" rows="4" cols="50" placeholder="Description"></textarea>
        <input id="onayla" type="button" value="Save" onclick="savenewpatient()">
    `);
}

function activeunits() {
    $("#main").html('')
    $.post('https://wert-ambulancejob/activeunits', JSON.stringify({}), function(result){
        $('#main').css('display', 'block');
        $.each(result, function(i, test){
            let name = test.name
            let csn = i
            let phone = test.phone
            let htmlItem = `<div id="unitsatır"><i class="fa-solid fa-hospital-user"></i> ${name}  | Phone : ${phone} | Csn : ${csn}</div>`
            $("#main").append(htmlItem)
        });
    });
}

function openbank() {
    $("#main").html('')
    $.post('https://wert-ambulancejob/get-blood-bank', JSON.stringify({}), function(result){
        $('#main').css('display', 'block');
        $.each(result, function(i, test){
            let kanname = i.toUpperCase();
            let color = 'rgba(87, 19, 19, 0.863)' // Düşük renk
            if ( test > 5 ) {
                color = 'rgba(11, 148, 52, 0.863)'
            }
            let htmlItem = `<div id="kansatır" style="background-color: ${color};"><i class="fa-solid fa-syringe"></i> ${kanname}<span id="kanyazi">| Stock : ${test}</span></div>`
            $("#main").append(htmlItem)
        });
    });
}

$(document).on('click', '#hastasatır', function(event){
    event.preventDefault();
    let name = $(this).data('name');
    let date = $(this).data('date');
    let aciklama = $(this).data('aciklama');

    $('#ekmenu').css('display', 'block');
    $('#ekmenu').html(`
        <div id="closeekmenu"><i class="fa-solid fa-circle-xmark"></i></div>
        <div id="hastainfos"></div>
    `);

    $("#hastainfos").append(`<div id="hastainfotext"><i class="fas fa-user"></i> ${name}</div>`)
    $("#hastainfos").append(`<div id="hastainfotext"><i class="fas fa-calendar"></i> Date : ${date}</div>`)
    $("#hastainfos").append(`<div id="hastainfotext"><i class="fas fa-folder"></i> Description : ${aciklama}</div>`)
});

$(document).on('click', '#closeekmenu', function(event){
    event.preventDefault();
    $('#ekmenu').css('display', 'none');
    $('#ekmenu').html('');
});

$(document).on('keydown', function() {
    switch(event.keyCode) {
        case 27: // ESCAPE
            popdownfunction();
            /* closekankart(); */
            if (system) {
                $('#system').css('display', 'none');
                $.post('https://wert-ambulancejob/Close', JSON.stringify({}));
                system = false
            }

            break;
    }
});

$(document).ready(function(){
    window.addEventListener('message', function(event) {
        switch(event.data.action) {
            case "Photo":
                popupfunction(event.data.photo);
                break;
            case "Kart":
                openkankart(event.data.kartdata);
                break;
            case "System":
                $('#system').css('display', 'block');
                system = true
                break;
            case "CloseKart":
                closekankart();
                break;
        }
    })
});
