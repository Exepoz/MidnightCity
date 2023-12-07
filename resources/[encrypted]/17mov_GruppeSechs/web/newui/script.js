
let currentSliderStatus = 0
let currentActiveTab = "mainMenu"
let lastNotifyId = 0
let PlayerOwnsTeam = false
let startJobBtnExist = true
let scriptIntialized = false
let tutorialActive = false
let counterActive = false
let myId
let showingInvite = false

$(".switchFlex .option").click(function() {
    if (this.id != currentSliderStatus) {
        currentSliderStatus = this.id
        if (currentSliderStatus == 1) {
            $(".activeSlider").css({"margin-left" : "34px"})
            setTimeout(async function() {
                if (currentSliderStatus == 1)
                    $.post(`https://${GetParentResourceName()}/changeClothes`, JSON.stringify({type: "work"}))
                    $("#clothesId").html(Number(currentSliderStatus) + 1)
            }, 200)
        } else {
            $(".activeSlider").css({"margin-left" : "0px"}) 
            setTimeout(async function() {
                if (currentSliderStatus == 0)
                    $.post(`https://${GetParentResourceName()}/changeClothes`, JSON.stringify({type: "citizen"}))
                    $("#clothesId").html(Number(currentSliderStatus) + 1)
            }, 200)
        }
    }
})


$(".tab").click(function() {
    if (currentActiveTab != this.id) {
        currentActiveTab = this.id
        $(".activeTab").removeClass("activeTab")
        $(`#${currentActiveTab}`).addClass("activeTab")
        if (currentActiveTab == "management") {
            $(".tabsSlider").scrollLeft(410)
        } else {
            $(".tabsSlider").scrollLeft(0)
        }
    }
})

function showTutorial(content) {
    $(".header .bgText").text("TUTORIAL")
    $(".header .text").text("Tutorial")
    $(".mainScreen").fadeOut(250)
    $("#tutorialScreen .text").text(content)
    $("#warningScreen").fadeOut(250)
    $("#inviteScreen").fadeOut(250)
    $(".mainScreen").fadeOut(250)
    $(".multiplayerMenu").fadeIn(250)
    $("#tutorialScreen").fadeIn(250)
    $("#startJob").fadeOut(250)
}

function showInvitation(inviter) {
    showingInvite = true;
    $(".header .bgText").text("INVITATION")
    $(".header .text").text("Invitation")
    $(".mainScreen").fadeOut(250)
    $(".inviterName").text(inviter)
    $("#warningScreen").fadeOut(250)
    $("#tutorialScreen").fadeOut(250)
    $(".mainScreen").fadeOut(250)
    $(".multiplayerMenu").fadeIn(250)
    $("#inviteScreen").fadeIn(250)
    $("#startJob").fadeOut(250)
}

function showWarning(warningText) {
    $(".header .bgText").text("WARNING")
    $(".header .text").text("Warning")
    $(".mainScreen").fadeOut(250)
    $("#tutorialScreen").fadeOut(250)
    $("#warningScreen .text").html(warningText)
    $("#inviteScreen").fadeOut(250)
    $(".mainScreen").fadeOut(250)
    $(".multiplayerMenu").fadeIn(250)
    $("#warningScreen").fadeIn(250)
    $("#startJob").fadeOut(250)
}

let oldHostId = 0

async function SetHost(name, playerId, percentage) {
    if (percentage == undefined) {
        percentage = 100
    }

    if (oldHostId != 0) {
        $(`#myTeamHostPlayerId${oldHostId}`).remove()
        $(`#manageRewardHostPlayerId${oldHostId}`).remove()
    }

    oldHostId = playerId
    let mainMenuTemplate = `<div id="myTeamHostPlayerId${playerId}" style="transform: translateX(-106%)" class="box"><div class="icon"><img src="newui/assets/hostIcon.svg" height="50px"><img src="newui/assets/strokes.svg" height="40px"></div><div class="content"><div class="topic">Boss Name</div><div class="value">${name}</div></div></div>`

    let manageRewardTemplate = `<div id="manageRewardHostPlayerId${playerId}" style="transform: translateX(-106%)" class="box"><div class="icon"><img src="newui/assets/hostIcon.svg" height="50px"><img src="newui/assets/strokes.svg" height="40px"></div><div class="content"><div class="topic">Boss Name</div><div class="value">${name}</div></div><input type="number" class="boxInput" id="rewardInput${playerId}" value=${percentage} lastVal=${percentage}></div>`
    
    $(".myLegalTeam").prepend(mainMenuTemplate)
    $(".teamRewards").prepend(manageRewardTemplate)

    if (currentActiveTab == "mainMenu") {
        $(`#manageRewardHostPlayerId${playerId}`).css("transform", "none")
    }

    await new Promise(r => setTimeout(r, 20))
    $(`#myTeamHostPlayerId${playerId}`).css("transform", "none")
    $(`#manageRewardHostPlayerId${playerId}`).css("transform", "none")
    addRewardInputEvent(`#rewardInput${playerId}`, playerId)
}


let activeInput = 0
$("body").click(function() {
    if (activeInput != 0) {
        checkReward("#" + activeInput, Number(activeInput.replace(/\D/g, "")))
        activeInput = 0
    }
})

function checkReward(id, plyId) {
    let beforeValue = $(id).attr("lastVal")
    let currentValue = $(id).val()
    $(id).attr("value", Math.floor(currentValue))
    $(id).val(Math.floor(currentValue))
    fetch(`https://${GetParentResourceName()}/checkIfThisRewardIsFine`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            value: currentValue,
            plyId: plyId
        })
    }).then(resp => resp.json()).then(async function(resp) {
        $(id).css("transition", `0.25s`)
        if (resp) {
            $(id).css("border", "1px solid #80FF00")
            $(id).attr("lastVal", currentValue)
            $(id).attr("value", currentValue)
        } else {
            $(id).css("border", "1px solid #FF002E")
            shakeAnim(id, 5)
            $(id).attr("value", beforeValue)
            $(id).val(beforeValue)
        }
        await new Promise(r => setTimeout(r, 250))
        $(id).css("border", "1px rgba(255, 255, 255, 0.15) solid")
    })
}

function addRewardInputEvent(id, plyId) {
    $(id).keyup(async function(event) {
        if (event.keyCode === 13) {
            checkReward(id, plyId)
        }
    })

    $(id).on("focus", function() {
        let idToSet = this.id
        setTimeout(function(){
            activeInput = idToSet
        }, 100)
    })
}

async function shakeAnim(id, offsets) {
    $(id).css("transform", `translateX(${offsets}px)`)
    await new Promise(r => setTimeout(r, 125))
    $(id).css("transform", `translateX(-${offsets}px)`)
    await new Promise(r => setTimeout(r, 125))
    $(id).css("transform", `none`)
}

async function AddMember(name, playerId, addQuitBtn, percentage) {
    let myTeamTemplate = `<div id="myTeamPlayerId${playerId}" style="transform: translateX(-106%)" class="box"><div class="icon"><img src="newui/assets/clientIcon.svg" height="50px"><img src="newui/assets/strokes.svg" height="40px"></div><div class="content"><div class="topic">Member Name</div><div class="value">${name}</div></div></div>`

    let ManageTeamTemplate = `<div id="manageMyTeamPlayerId${playerId}" style="transform: translateX(-106%)" class="box"><div class="icon"><img src="newui/assets/clientIcon.svg" height="50px"><img src="newui/assets/strokes.svg" height="40px"></div><div class="content"><div class="topic">Member Name</div><div class="value">${name}</div></div><div onclick="kickPlayer('${playerId}')" class="kickBtn"><img src="newui/assets/kickIcon.svg"></div></div>`
    
    let manageRewardTemplate = `<div id="manageRewardPlayerId${playerId}" style="transform: translateX(-106%)"  class="box"><div class="icon"><img src="newui/assets/clientIcon.svg" height="50px"><img src="newui/assets/strokes.svg" height="40px"></div><div class="content"><div class="topic">Member Name</div><div class="value">${name}</div></div><input type="number" class="boxInput" id="rewardInput${playerId}" value=${percentage} lastVal=${percentage}></div>`

    $(".myLegalTeam").append(myTeamTemplate)
    $(".manageMyTeam").append(ManageTeamTemplate)
    $(".teamRewards").append(manageRewardTemplate)

    addRewardInputEvent(`#rewardInput${playerId}`, playerId)

    if (addQuitBtn) {
        $(`#myTeamPlayerId${playerId}`).append(`<div onclick="kickPlayer('${playerId}')" class="kickBtn"><img src="newui/assets/kickIcon.svg"></div>`)
    }

    if (currentActiveTab == "mainMenu") {
        $(`#manageMyTeamPlayerId${playerId}`).css("transform", "none")
        $(`#manageRewardPlayerId${playerId}`).css("transform", "none")
    } else {
        $(`#myTeamPlayerId${playerId}`).css("transform", "none")
    }

    await new Promise(r => setTimeout(r, 20))
    $(`#myTeamPlayerId${playerId}`).css("transform", "none")
    $(`#manageMyTeamPlayerId${playerId}`).css("transform", "none")
    $(`#manageRewardPlayerId${playerId}`).css("transform", "none")
}

async function AddNearbyPlayer(name, playerId) {
    let template = `<div style="transform: translateX(-106%)" id="nearbyPlayerId${playerId}" class="box"><div class="icon"> <img src="newui/assets/newUser.svg" height="50px"><img src="newui/assets/strokes.svg" height="40px"></div><div class="content"><div class="topic">Member Name</div><div class="value">${name}</div></div><div class="inviteBtn" onclick="inviteNearbyPlayer('${playerId}')"><img src="newui/assets/inviteBtn.svg"></img></div></div>`

    $(".nearbyPlayers").append(template)
    await new Promise(r => setTimeout(r, 20))
    $(`#nearbyPlayerId${playerId}`).css("transform", "none")
    await new Promise(r => setTimeout(r, 1000))
}

function kickPlayer(id) {
    if (PlayerOwnsTeam) {
        if (myId == id) {
            $.post(`https://${GetParentResourceName()}/notify`, JSON.stringify({ msg: "The owner of the team can not leave it!" }))
            return
        }
        $.post(`https://${GetParentResourceName()}/kickPlayerFromLobby`, JSON.stringify({ id: id }))
    } else if (myId == id) {
        $.post(`https://${GetParentResourceName()}/leaveLobby`, JSON.stringify({ id: id }))
    }
}

async function DeletePlayer(id) {
    $(`${id}`).css("transform", "translateX(-106%)")
    await new Promise(r => setTimeout(r, 500))
    $(`${id}`).remove()
}

function inviteNearbyPlayer(id) {
    $.post(`https://${GetParentResourceName()}/sendRequest`, JSON.stringify({ id: id }))
}

async function ShowNotification(type, msg) {
    msg = msg.toString()
    lastNotifyId++
    let notificationTemplate
    let thisId = lastNotifyId

    if (type == "wrong") {
        if (msg.length > 135) {
            notificationTemplate = `<div style="transform: translateX(106%)" class="notification" id="notify${thisId}"><div class="flexBox"><div class="text longNotify"><div class="wrongTittle">NOTIFICATION</div><div class="content">${msg}</div></div></div><div class="progressbar"><div class="track"><div class="wrongRdyTrack" id="track${thisId}"></div></div></div></div>`
        } else {
            notificationTemplate = `<div style="transform: translateX(106%)" class="notification" id="notify${thisId}"><div class="flexBox"><div class="icon"><img src="/web/newui/assets/xMark.svg"></div><div class="text shortNotify"><div class="wrongTittle">NOTIFICATION</div><div class="content">${msg}</div></div></div><div class="progressbar"><div class="track"><div class="wrongRdyTrack" id="track${thisId}"></div></div></div></div>`
        }
    } else {
        if (msg.length > 135) {
            notificationTemplate = `<div style="transform: translateX(106%)" class="notification " id="notify${thisId}"><div class="flexBox"><div class="text longNotify"><div class="tittle">NOTIFICATION</div><div class="content">${msg}</div></div></div><div class="progressbar"><div class="track"><div class="rdyTrack" id="track${thisId}"></div></div></div></div>`
        } else {
            notificationTemplate = `<div style="transform: translateX(106%)" class="notification" id="notify${thisId}"><div class="flexBox"><div class="icon"><img src="/web/newui/assets/check.svg"></div><div class="text shortNotify"><div class="tittle">NOTIFICATION</div><div class="content">${msg}</div></div></div><div class="progressbar"><div class="track"><div class="rdyTrack" id="track${thisId}"></div></div></div></div>`

        }
    }
    
    $(".notifications").append(notificationTemplate)
    await new Promise(r => setTimeout(r, 20))

    $(`#notify${thisId}`).css("transform", "translateX(0%)")
    await new Promise(r => setTimeout(r, 500))
    
    let totalTime = msg.split(' ').length * 200
    if (totalTime < 1000) totalTime = 1000
    let addPerTick = 100 / totalTime

    for (let i=0; i<=100; i = i + addPerTick) {
        $(`#track${thisId}`).css("width", i + "%")
        await new Promise(r => setTimeout(r, 1))
    }

    $(`#track${thisId}`).css("width", "100%")
    $(`#notify${thisId}`).css("transform", "translateX(106%)")
    await new Promise(r => setTimeout(r, 500))
    $(`#notify${thisId}`).remove()
}

function reactInvite(boolean) {
    showingInvite = false
    $(".multiplayerMenu").fadeOut(250)
    $("#inviteScreen").fadeOut(250)
    if (startJobBtnExist)
        $("#startJob").fadeIn(250)
    $.post(`https://${GetParentResourceName()}/requestReacted`, JSON.stringify({ boolean: boolean }))
    $.post(`https://${GetParentResourceName()}/focusOff`)
}

function reactWarning(boolean) {
    $(".multiplayerMenu").fadeOut(250)
    $("#warningScreen").fadeOut(250)
    if (startJobBtnExist)
        $("#startJob").fadeIn(250)
    if (boolean)
        $.post(`https://${GetParentResourceName()}/acceptWarning`)
    
    $.post(`https://${GetParentResourceName()}/focusOff`)
}

function closeTutorial(boolean) {
    tutorialActive = false
    $(".multiplayerMenu").fadeOut(250)
    $("#tutorialScreen").fadeOut(250)
    if (boolean)
        $.post(`https://${GetParentResourceName()}/dontShowTutorialAgain`)

    if (startJobBtnExist)
        $("#startJob").fadeIn(250)
        
    $.post(`https://${GetParentResourceName()}/tutorialClosed`)
    $.post(`https://${GetParentResourceName()}/focusOff`)
}

function startJob() {
    if (PlayerOwnsTeam || scriptIntialized) {
        $.post(`https://${GetParentResourceName()}/startJob`)
        closeHUD()
    } else {
        $.post(`https://${GetParentResourceName()}/notify`, JSON.stringify({ msg: "Only owner of the party can start job!" }))
    }
}

window.addEventListener('message', function (event) {
    let action = event.data.action
    if (action == "addNewMember") {
        scriptIntialized = false
        if (event.data.isHost) {
            SetHost(event.data.name, event.data.id, event.data.rewardPercent)
        } else {
            AddMember(event.data.name, event.data.id, event.data.showQuitBtn, event.data.rewardPercent)
        }
    } else if (action == "ToggleHostHUD") {
        if (event.data.boolean) {
            PlayerOwnsTeam = true
            currentActiveTab = "mainMenu"
            $(".activeTab").removeClass("activeTab")
            $(`#${currentActiveTab}`).addClass("activeTab")
            $(".tabs").fadeIn(250)
            $(".nearbyPlayersParent").fadeIn(250)
            $(".management").fadeIn(250)
            $("#startJob").fadeIn(250)
            startJobBtnExist = true
        } else {
            PlayerOwnsTeam = false
            $(".tabsSlider").scrollLeft(0)
            currentActiveTab = "mainMenu"
            $(".activeTab").removeClass("activeTab")
            $(`#${currentActiveTab}`).addClass("activeTab")
            $(".tabs").fadeOut(250)
            $(".nearbyPlayersParent").fadeOut(250)
            $(".management").fadeOut(250)
            $("#startJob").fadeOut(250)
            startJobBtnExist = false
        }
    } else if (action == "DeletePlayer") {
        scriptIntialized = false
        DeletePlayer(`#myTeamPlayerId${event.data.id}`)
        DeletePlayer(`#manageMyTeamPlayerId${event.data.id}`)
        DeletePlayer(`#manageRewardPlayerId${event.data.id}`)
    } else if (action == "OpenWorkMenu") {
        if (startJobBtnExist) {
            $("#startJob").fadeIn(250)
        }
        $("#counter").fadeOut(250)
        $(".header .bgText").text("GROUP LOBBY")
        $(".header .text").text("GROUP LOBBY")
        $("#inviteScreen").fadeOut(250)
        $("#warningScreen").fadeOut(250)
        $("#tutorialScreen").fadeOut(250)
        $(".mainScreen").fadeIn(250)
        $(".multiplayerMenu").fadeIn(250)
    } else if (action == "hideCloakroom") {
        $("#cloakroom").css("display", "none")
    } else if (action == "openWarning") {
        showWarning(event.data.text)
    } else if (action == "ShowInviteBox") {
        showInvitation(event.data.name)
    } else if (action == "showTutorial") {
        tutorialActive = true
        showTutorial(event.data.customText)
    } else if (action == "Init") {
        scriptIntialized = true
        myId = event.data.myId
        $(".myLegalTeam").empty()
        $(".manageMyTeam").empty()
        $(".teamRewards").empty()
        SetHost(event.data.name, event.data.myId, 100)
        $(".tabs").fadeOut(250)
        $(".tabsSlider").scrollLeft(0)
        $(".management").fadeOut(250)
        $("#startJob").fadeIn(250)
        startJobBtnExist = true
        $("#tabletName").html(event.data.name)
        $("#slot1 .name").html(event.data.name)
    } else if (action == "showMyTeamTab") {
        $(".myTeamParent").fadeIn(250)
    } else if (action == "hideMyTeamTab") {
        $(".myTeamParent").fadeOut(250)
    } else if (action == "hideNearbyPlayersTab") {
        $(".nearbyPlayersParent").fadeOut(250)
    } else if (action == "showNearbyPlayersTab") {
        $(".nearbyPlayersParent").fadeIn(250)
    } else if (action == "addNewNearbyPlayer") {
        AddNearbyPlayer(event.data.name, event.data.id)
    } else if (action == "DeleteNearbyPlayer") {
        DeletePlayer(`#nearbyPlayerId${event.data.id}`)
    } else if (action == "updateMyReward") {
        $(".salaryPercent").text(event.data.reward + "%")
    } else if (action == "showNotification") {
        ShowNotification(event.data.type, event.data.msg)
    } else if (action == "hideManageRewards") {
        $(".manageReward").fadeOut(100) 
        $("#cashPercentage").fadeOut(100) 
    }  else if (action == "CrimeHostStatusUpdate")
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
                $(".transports").append(`<div class="transport" id=${transports[i].transportId}><div class="info"><div class="tag">TEAM LEADER</div><div class="answer">${transports[i].ownerName}</div></div><div class="info"><div class="tag">POTENTIAL LOOT</div><div class="answer">$${transports[i].loot}</div></div><div class="info"><div class="tag">DESTINATION</div><div class="answer">${transports[i].destination}</div></div><img src="newui/assets/imgs/stockade2.png"></img></div>`)
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
        $(".heistTarget").append(`<div class="target"><div class="info"><div class="tag">TEAM LEADER</div><div class="answer">${event.data.info.ownerName}</div></div><div class="info"><div class="tag">POTENTIAL LOOT</div><div class="answer">$${event.data.info.loot}</div></div><div class="info"><div class="tag">DESTINATION</div><div class="answer">${event.data.info.destination}</div></div><img src="newui/assets/imgs/stockade2.png"></img></div>`)
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
    } else if (action == "ShowCrimeInviteBox") {
        let name = event.data.name
        $("#crimeInviteUser").text(name)
        $(".crimeInviteBox").fadeIn(250)
    } else if (action == "updateHostRewards") {
        $(".teamRewards input").attr("lastVal", event.data.value)
        $(".teamRewards input").attr("value", event.data.value)
    } else if (action == "setProgressBarAlign") {
        var $counter = $("#counter")

        $counter.css({
            top: '',
            bottom: '',
            left: '',
            right: '',
            margin: ''
        })
    
        var position = event.data.offset
        switch (event.data.align) { 
            case 'top-left':
                $counter.css({
                    top: position,
                    left: position
                })
                break
            case 'top-center':
                $counter.css({
                    top: position,
                    left: '50%',
                    transform: 'translateX(-50%)'
                })
                break
            case 'top-right':
                $counter.css({
                    top: position,
                    right: position
                })
                break
            case 'bottom-left':
                $counter.css({
                    bottom: position,
                    left: position
                })
                break
            case 'bottom-center':
                $counter.css({
                    bottom: position,
                    left: '50%',
                    transform: 'translateX(-50%)'
                })
                break
            case 'bottom-right':
                $counter.css({
                    bottom: position,
                    right: position
                })
                break
            default:
        }
    }
})

$(document).keyup(function(e) {
    if (e.keyCode === 27) {
        closeHUD()
    }
})

function closeHUD() {
    if (showingInvite) {
        reactInvite(false)
    }
    $(".mainScreen").fadeOut(250)
    $(".multiplayerMenu").fadeOut(250)
    $("#inviteScreen").fadeOut(250)
    $("#warningScreen").fadeOut(250)
    $("#tutorialScreen").fadeOut(250)
    $.post(`https://${GetParentResourceName()}/menuClosed`)

    if (tutorialActive) { 
        tutorialActive = false
        $.post(`https://${GetParentResourceName()}/tutorialClosed`)
    }

    if (counterActive)
        $("#counter").fadeIn(250)

    FocusOff()
}

// TABLET SCRIPTS: 

let PlayerIsCrimeHost = true
let myName = "17mov.pro"
let shouldGoMainMenu = false
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

function reactCrimeRequest(boolean) {
    $(".crimeInviteBox").fadeOut(250)
    FocusOff()
    $.post(`https://${GetParentResourceName()}/requestReacted`, JSON.stringify({ boolean: boolean, isCrime: true}));
}

function FocusOff() {
    $(".tabletHider").fadeOut(250)
    lastPage = currentPage
    $.post(`https://${GetParentResourceName()}/focusOff`);
}

$.post(`https://${GetParentResourceName()}/nuiLoaded`)
