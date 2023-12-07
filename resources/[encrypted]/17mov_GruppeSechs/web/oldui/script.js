let PlayerIsHost = true
let PlayerIsCrimeHost = true
let myId = 0
let myName = "17mov.pro"
let shouldGoMainMenu = false
let tutorialActive = false
let LoggedIn = false
let lastPage = ""
let currentPage = ""

let heistSteps = [
    "GET CLOSER",
    "STAY CLOSE TO DOWNLOAD INFO",
    "STOP TRUCK AND OPEN DOORS BY BUTTONS",
    "GRAB MONEY AND RUN",
    "DELIVER MONEY TO DELIVERY LOCATION",
]

function check(ele) {
    if(event.key === 'Enter') {
        fetch(`https://${GetParentResourceName()}/checkPassword`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify({
                password: ele.value
            })
        }).then(resp => resp.json()).then(resp => {
            if (resp) {
                dashboard()
                $("#tabletName").html(myName)
                LoggedIn = true
                ele.value = ""
            }
        })
    }
}

function sendMessage(ele) {
    if(event.key === 'Enter') {
        let _message = ele.value
        ele.value = ""
        $.post(`https://${GetParentResourceName()}/sendMessage`, JSON.stringify({ message: _message }));
    }
}

let CurrentSelectedTransport

function crimeBack() {
    $(".confirmParent").css("display", "none")
}

function crimeStartHeist() {
    $(".confirmParent").css("display", "none")
    if (PlayerIsCrimeHost) {
        $.post(`https://${GetParentResourceName()}/startHeist`, JSON.stringify({ id: CurrentSelectedTransport }));
    } else {
        $.post(`https://${GetParentResourceName()}/notify`, JSON.stringify({ msg: "Only leader can start the heist" }));
    }
}

function cancelHeist() {
    if (PlayerIsCrimeHost) {
        $.post(`https://${GetParentResourceName()}/stopHeist`);
    } else {
        $.post(`https://${GetParentResourceName()}/notify`, JSON.stringify({ msg: "Only leader can start the heist" }));
    }
}

function OpenTablet() {
    ClearAllTabletPages()
    if (LoggedIn) {
        $(".navigationParent").show()
        $(lastPage).show()
        currentPage = lastPage
    } else {
        $(".loginParent").show()
    }
    $(".tabletHider").fadeIn(250)
}

function dashboard() {
    ClearAllTabletPages()
    $(".navigationParent").show()
    $(".dashboardParent").show()
    $(".navBtnActive").removeClass("navBtnActive")
    $("#dashboardNavBtn").addClass("navBtnActive")
    $(".dashboradBox .chatMessages").scrollTop($(".dashboradBox .chatMessages").prop("scrollHeight"))

    currentPage = ".dashboardParent"
}

function myTeam() {
    ClearAllTabletPages()
    $(".navigationParent").show()
    $(".myTeamParent").show()
    $(".navBtnActive").removeClass("navBtnActive")
    $("#myTeamNavBtn").addClass("navBtnActive")
    currentPage = ".myTeamParent"
}

function yourHeist() {
    ClearAllTabletPages()
    $(".navigationParent").show()
    $(".heistPageParent").show()
    $(".navBtnActive").removeClass("navBtnActive")
    $("#yourHeistNavBtn").addClass("navBtnActive")
    currentPage = ".heistPageParent"
}


function chat() {
    ClearAllTabletPages()
    $(".navigationParent").show()
    $(".chatParent").show()
    $(".navBtnActive").removeClass("navBtnActive")
    $("#chatNavBtn").addClass("navBtnActive")
    $(".messages").scrollTop($(".messages").prop("scrollHeight"))
    currentPage = ".chatParent"
}

function transports() {
    ClearAllTabletPages()
    $(".navigationParent").show()
    $(".transportsParent").show()
    $(".navBtnActive").removeClass("navBtnActive")
    $("#transportsNavBtn").addClass("navBtnActive")
    currentPage = ".transportsParent"
}

function closeTablet() {
    ClearAllTabletPages()
    FocusOff()
}

function Logout() {
    ClearAllTabletPages()
    $(".loginParent").show()
    $.post(`https://${GetParentResourceName()}/playerLoggedOut`);
    LoggedIn = false
} 

function sendCrimeInvite(id) {
    $(".inviteParent").fadeOut();
    $.post(`https://${GetParentResourceName()}/sendCrimeRequest`, JSON.stringify({ id: id }));
}

function crimeInvite() {
    fetch(`https://${GetParentResourceName()}/GetClosestPlayers`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
    }).then(resp => resp.json()).then(resp => {
        let table = resp
        if (table.length != 0) {
            $(".crimePlayers").empty()
            for (i = 0; i < table.length; i++) {
                $(".crimePlayers").append(`<div class="crimePlayer" onclick="sendCrimeInvite(${table[i].id})">${table[i].name} | ${table[i].id}</div>`)
            }
            $(".inviteParent").fadeIn(250)
        }
    })
}

$(document).keyup(function (e) {
    if (e.key === "Escape") {
        if (shouldGoMainMenu) {
            $(".closestPlayers").fadeOut(250)
            $(".WorkMenu").fadeIn(250)
            shouldGoMainMenu = false
            if (tutorialActive) {
                CloseTutorial()
            }
            return
        }
        $(".inviteParent").fadeOut(250)
        $(".confirmParent").css("display", "none")
        FocusOff()
    }
});

window.addEventListener('message', function (event) {
    let action = event.data.action;
    if (action == "OpenWorkMenu") {
        $(".WorkMenu").fadeIn(250)
        shouldGoMainMenu = false
    } else if (action == "openWarning") {
        $(".warningBox .text").text(event.data.text)
        $(".warningBox").fadeIn(250)
    } else if (action == "ShowInviteBox") {
        let name = event.data.name
        $("#inviteUser").text(name)
        $(".inviteBox").fadeIn(250)
    } else if (action == "ShowCrimeInviteBox") {
        let name = event.data.name
        $("#crimeInviteUser").text(name)
        $(".crimeInviteBox").fadeIn(250)
    } else if (action == "showTutorial") {
        if (event.data.customText != undefined) {
            $(".tutorial label").html(event.data.customText)
        }
        tutorialActive = true
        $(".tutorial").fadeIn(250)
    } else if (action == "Init") {
        myName = event.data.name
        myId = event.data.myId
        $(".partyContainer").empty()
        $(".WorkMenu .flex").empty()
        $(".WorkMenu .flex").append('<div class="partyChild childHost" id="' + Number(1+1) + '" plyId="' + myId + ' onclick="Kick(' + myId + ')"><div class="partyHost"><i class="fa-regular fa-user"></i>' + myName + '</div></div>')
        for (i = 0; i < 3; i++) {
            $(".partyContainer").append('<div class="partyChild" onclick="Invite()"><div class="freeSlot"><i class="fa-solid fa-user-plus"></i></div></div>')
        }
        $("#tabletName").html(myName)
        $("#slot1 .name").html(myName)
    } else if (action == "refreshMugs") {
        let names = event.data.names
        myId = event.data.myId
        $(".partyContainer").empty()
        $(".WorkMenu .flex").empty()
        let added = 0
        for (i = 0; i < names.length; i++) {
            added = added + 1
            let p

            if (names[i].isHost) {
                $(".WorkMenu .flex").append('<div class="partyChild childHost" id="' + Number(i+1) + '" plyId="' + names[i].id + '" onclick="Kick(' + names[i].id + ')"><div class="partyHost"><i class="fa-regular fa-user"></i>' + names[i].name + '</div></div>')
            } else {
                $(".partyContainer").append('<div class="partyChild" id="' + Number(i+1) + '" plyId="' + names[i].id + '" onclick="Kick(' + names[i].id + ')"><div class="busySlot"><div class="xmark">❌</div>' + names[i].name + '</div></div>')
            }
        }

        for (i = 0; i < 4-added; i++) {
            $(".partyContainer").append('<div class="partyChild" onclick="Invite()"><div class="freeSlot"><i class="fa-solid fa-user-plus"></i></div></div>')
        }
    } else if (action == "HostStatusUpdate") {
        PlayerIsHost = event.data.status
    } else if (action == "CrimeHostStatusUpdate")
        PlayerIsCrimeHost = event.data.status
    else if (action == "OpenTablet") {
        OpenTablet()
    } else if (action == "refreshCrimeMugs") {
        let names = event.data.names
        myId = event.data.myId
        $("#slot1").empty()
        $("#slot2").empty()
        $("#slot3").empty()
        $("#slot4").empty()
        let added = 0
        let lastSlot = 1
        for (i = 0; i < names.length; i++) {
            added = added + 1
            if (names[i].isHost) {
                $("#slot1").append(`<div class="myTeamBox" onclick="crimeKick(${names[i].id})" id="crimeId${names[i].id}"><i class="fa-solid fa-user"></i><div class="name">${names[i].name}</div><div class="role">LEADER</div></div>`)       
            } else {
                lastSlot++
                $("#slot" + lastSlot ).append(`<div class="myTeamBox" onclick="crimeKick(${names[i].id})" id="crimeId${names[i].id}"><i class="fa-solid fa-user"></i><div class="name">${names[i].name}</div><div class="role">MEMBER</div></div>`)       
            }
        }

        for (i = 0; i < 4-added; i++) {
            lastSlot++
            $("#slot" + lastSlot).append(`<div class="myTeamBox" onclick="crimeInvite()"><i class="fa-solid fa-user-plus"></i><div class="name">EMPTY SLOT</div><div class="role">CLICK TO INVITE</div></div>`)
        }

    } else if (action == "newCrimeMessage") {
        let count = $(".chatMessages .chatMessage").length + 1;
        if (count > 3) {
            $(".chatMessages .chatMessage").first().remove()
        }

        $(".chatMessages").append(`<div class="chatMessage"><div class="pfp"><i class="fa-solid fa-user-secret"></i></div><div class="message">${event.data.message}</div></div>`)
        $(".messages").append(`<div class="chatMessage"><div class="pfp"><i class="fa-solid fa-user-secret"></i></div><div class="message">${event.data.message}</div></div>`)
        $(".messages").scrollTop($(".messages").prop("scrollHeight"))
    } else if (action == "refreshLoggedInUsers") {
        $("#loggedInValue").html(event.data.value)
    } else if (action == "updateTransports") {
        $(".transports").empty()
        let transports = event.data.transports
        $("#transportsValue").html(transports.length)
        if (transports.length > 0) {
            $("#zeroTranports").css("display", "none")
            for (i = 0; i < transports.length; i++) {
                $(".transports").append(`<div class="transport" id=${transports[i].transportId}><div class="info"><div class="tag">TEAM LEADER</div><div class="answer">${transports[i].ownerName}</div></div><div class="info"><div class="tag">POTENTIAL LOOT</div><div class="answer">$${transports[i].loot}</div></div><div class="info"><div class="tag">DESTINATION</div><div class="answer">${transports[i].destination}</div></div><img src="oldui/imgs/stockade2.png"></img></div>`)
            }
            
            $(".transport").click(function() {
                CurrentSelectedTransport = this.id
                $(".confirmParent").css("display", "flex")
            })
        } else {
            $("#zeroTranports").css("display", "flex")
        }
    } else if (action == "openHeistPage") {
        $(".heistTarget").empty()
        $(".heistTarget").append(`<div class="target"><div class="info"><div class="tag">TEAM LEADER</div><div class="answer">${event.data.info.ownerName}</div></div><div class="info"><div class="tag">POTENTIAL LOOT</div><div class="answer">$${event.data.info.loot}</div></div><div class="info"><div class="tag">DESTINATION</div><div class="answer">${event.data.info.destination}</div></div><img src="oldui/imgs/stockade2.png"></img></div>`)
        yourHeist()
        $("#yourHeistNavBtn").fadeIn(250)
        $(".closeButton").addClass("closeButtonAll");
        $("#blockEngine").removeClass("green")
        $("#openDoors").removeClass("green")
        closeTablet()
    } else if (action == "turnOfHeist") {
        $("#yourHeistNavBtn").fadeOut(250)
        dashboard()
        currentPage = ".dashboardParent"
        lastPage = ".dashboardParent"
        $(".heistTarget").empty()
        $(".closeButton").removeClass("closeButtonAll");
    } else if (action == "updateSteps") {
        let step = event.data.value - 1
        $("#currentTask").html(heistSteps[step])
        let string = ""
        for (i = step+1; i < heistSteps.length; i++) {
            string = string + heistSteps[i] + "<br>"
        }
        $(".nextSteps").html(string)
        if (step == 2) {
            $("#blockEngine").addClass("green")
            $("#openDoors").addClass("green")
        }
    }
});

function blockEngine() {
    if (PlayerIsCrimeHost) {
        $.post(`https://${GetParentResourceName()}/blockEngine`);
    } else {
        $.post(`https://${GetParentResourceName()}/notify`, JSON.stringify({ msg: "Only leader can do it" }));
    }
}

function openBackDoors() {
    if (PlayerIsCrimeHost) {
        $.post(`https://${GetParentResourceName()}/openDoors`);
    } else {
        $.post(`https://${GetParentResourceName()}/notify`, JSON.stringify({ msg: "Only leader can do it" }));
    }
}

function ClearAllTabletPages() {
    $(".dashboardParent").hide()
    $(".transportsParent").hide()
    $(".chatParent").hide()
    $(".myTeamParent").hide()
    $(".navigationParent").hide()
    $(".loginParent").hide()
    $(".heistPageParent").hide()
}

function CloseTutorial() {
    tutorialActive = false
    $.post(`https://${GetParentResourceName()}/tutorialClosed`);
    $(".tutorial").fadeOut(250)
    FocusOff()
}

function pickPlayers(id) {
    shouldGoMainMenu = false
    $(".closestPlayers").fadeOut(250)
    $(".WorkMenu").fadeIn(250)
    $.post(`https://${GetParentResourceName()}/sendRequest`, JSON.stringify({ id: id }));
}

function crimeKick(target) {
    if (PlayerIsCrimeHost) {
        if (myId == target) {
            $.post(`https://${GetParentResourceName()}/notify`, JSON.stringify({ msg: "The leader of the team can not leave it!" }));
            return
        }
        $.post(`https://${GetParentResourceName()}/kickPlayerFromCrimeLobby`, JSON.stringify({ id: target, name: $(`#crimeId${target} .name`).text() }));
        $("#" + $(`#crimeId${target}`).parent().attr("id")).append('<div class="myTeamBox" onclick="crimeInvite()"><i class="fa-solid fa-user-plus"></i><div class="name">EMPTY SLOT</div><div class="role">CLICK TO INVITE</div></div>')
        $(`#crimeId${target}`).remove()
    } else if (myId == target) {
        $.post(`https://${GetParentResourceName()}/leaveCrimeLobby`, JSON.stringify({ id: myId }));
        return
    }
}

function Kick(target) {
    if (target != undefined && target != 0) {
        if (PlayerIsHost) {
            if (myId == target) {
                $.post(`https://${GetParentResourceName()}/notify`, JSON.stringify({ msg: "The owner of the team can not leave it!" }));
                return
            }
            $(".partyChild[plyId='" + target + "']").text()
            $.post(`https://${GetParentResourceName()}/kickPlayerFromLobby`, JSON.stringify({ id: target, name: $(".partyChild[plyId='" + target + "']").text() }));
            $(".partyChild[plyId='" + target + "']").remove();
            $(".partyContainer").append('<div class="partyChild" onclick="Invite()"><div class="freeSlot"><i class="fa-solid fa-user-plus"></i></div></div>')
        } else if (myId == target) {
            $.post(`https://${GetParentResourceName()}/leaveLobby`, JSON.stringify({ id: myId }));
            return
        }
    }
}

function Invite() {
    fetch(`https://${GetParentResourceName()}/GetClosestPlayers`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
    }).then(resp => resp.json()).then(resp => {
        let table = resp
        if (table.length != 0) {
            shouldGoMainMenu = true
            $(".WorkMenu").fadeOut(250)
            $(".closestPlayers .flex2").empty()
            for (i = 0; i < table.length; i++) {
                $(".closestPlayers .flex2").append('<div class="button" onclick="pickPlayers(' + table[i].id + ')">'+ table[i].name + ' | ' + table[i].id + '</div>')
            }
            $(".closestPlayers").fadeIn(250)
        }
    })
}

function reactRequest(boolean) {
    $(".inviteBox").fadeOut(250)
    FocusOff()
    $.post(`https://${GetParentResourceName()}/requestReacted`, JSON.stringify({ boolean: boolean, isCrime: false }));
}

function reactCrimeRequest(boolean) {
    $(".crimeInviteBox").fadeOut(250)
    FocusOff()
    $.post(`https://${GetParentResourceName()}/requestReacted`, JSON.stringify({ boolean: boolean, isCrime: true}));
}

function reactWarning(boolean) {
    $(".warningBox").fadeOut(250)
    FocusOff()
    if (boolean)
        $.post(`https://${GetParentResourceName()}/acceptWarning`);
}

function FocusOff() {
    $(".WorkMenu").fadeOut(250)
    $(".closestPlayers").fadeOut(250)
    $(".tutorial").fadeOut(250)
    $(".warningBox").fadeOut(250)
    $(".tabletHider").fadeOut(250)
    lastPage = currentPage
    if (tutorialActive) {
        CloseTutorial()
    }
    $.post(`https://${GetParentResourceName()}/focusOff`);
}

function startJob() {
    if (PlayerIsHost) {
        $.post(`https://${GetParentResourceName()}/startJob`);
        FocusOff()
    } else {
        $.post(`https://${GetParentResourceName()}/notify`, JSON.stringify({ msg: "Only owner of the party can start job!" }));
    }
}