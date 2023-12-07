let PlayerIsHost = true 
let myId = 0
let myName
let shouldGoMainMenu = false
let tutorialActive = false

$(document).keyup(function (e) {
    if (e.key === "Escape") {
        if (shouldGoMainMenu) {
            $(".cloakroomMenu").fadeOut(250)
            $(".closestPlayers").fadeOut(250)
            $(".WorkMenu").fadeIn(250)
            shouldGoMainMenu = false
            if (tutorialActive) {
                CloseTutorial()
            }
            return
        }
        FocusOff()
    }
});

window.addEventListener('message', function (event) {
    let action = event.data.action;
    if (action == "OpenWorkMenu") {
        $(".WorkMenu").fadeIn(250)
        shouldGoMainMenu = false
    } else if (action == "openWarning") {
        $(".warningBox").fadeIn(250)
    } else if (action == "hideCloakroom") {
        $("#Cloakroom").fadeOut(0)
    } else if (action == "ShowInviteBox") {
        let name = event.data.name
        $("#inviteUser").text(name)
        $(".inviteBox").fadeIn(250)
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
    } else if (action == "showCounter") {
        $(".counter span").text(0 + "%");
        $(".counter").fadeIn(250);
    } else if (action == "hideCounter") {
        $(".counter").fadeOut(250);
    } else if (action == "updateCounter") {
        $(".counter span").text(event.data.value.toString() + "%");
    }
});


function cloakroom() {
    shouldGoMainMenu = true
    $(".WorkMenu").fadeOut(250)
    $(".cloakroomMenu").fadeIn(250)
}

function citizenClothes() {
    shouldGoMainMenu = false
    $(".cloakroomMenu").fadeOut(250)
    $(".WorkMenu").fadeIn(250)
    $.post(`https://${GetParentResourceName()}/changeClothes`, JSON.stringify({ type: "citizen" }));
}

function workClothes() {
    shouldGoMainMenu = false
    $(".cloakroomMenu").fadeOut(250)
    $(".WorkMenu").fadeIn(250)
    $.post(`https://${GetParentResourceName()}/changeClothes`, JSON.stringify({ type: "work" }));
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
    $.post(`https://${GetParentResourceName()}/requestReacted`, JSON.stringify({ boolean: boolean }));
}

function reactWarning(boolean) {
    $(".warningBox").fadeOut(250)
    FocusOff()
    if (boolean)
        $.post(`https://${GetParentResourceName()}/acceptWarning`);
}

function FocusOff() {
    $(".cloakroomMenu").fadeOut(250)
    $(".WorkMenu").fadeOut(250)
    $(".closestPlayers").fadeOut(250)
    $(".tutorial").fadeOut(250)
    $(".warningBox").fadeOut(250)
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