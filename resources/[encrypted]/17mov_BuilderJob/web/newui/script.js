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
    showingInvite = true
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

function showWarning() {
    $(".header .bgText").text("WARNING")
    $(".header .text").text("Warning")
    $(".mainScreen").fadeOut(250)
    $("#tutorialScreen").fadeOut(250)
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
    
    $(".myTeam").prepend(mainMenuTemplate)
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
            'Content-Type': 'application/json charset=UTF-8',
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

    $(".myTeam").append(myTeamTemplate)
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
        $(".header .bgText").text("BUILDER LOBBY")
        $(".header .text").text("BUILDER LOBBY")
        $("#inviteScreen").fadeOut(250)
        $("#warningScreen").fadeOut(250)
        $("#tutorialScreen").fadeOut(250)
        $(".mainScreen").fadeIn(250)
        $(".multiplayerMenu").fadeIn(250)
    } else if (action == "hideCloakroom") {
        $("#cloakroom").css("display", "none")
    } else if (action == "openWarning") {
        showWarning()
    } else if (action == "ShowInviteBox") {
        showInvitation(event.data.name)
    } else if (action == "showTutorial") {
        tutorialActive = true
        showTutorial(event.data.customText)
    } else if (action == "Init") {
        scriptIntialized = true
        myId = event.data.myId
        $(".myTeam").empty()
        $(".manageMyTeam").empty()
        $(".teamRewards").empty()
        SetHost(event.data.name, event.data.myId, 100)
        $(".tabs").fadeOut(250)
        $(".tabsSlider").scrollLeft(0)
        $(".management").fadeOut(250)
        $("#startJob").fadeIn(250)
        startJobBtnExist = true
    } else if (action == "showMyTeamTab") {
        $(".myTeamParent").fadeIn(250)
    } else if (action == "hideMyTeamTab") {
        $(".myTeamParent").fadeOut(250)
    } else if (action == "showCounter") {
        $("#counterValue").text(0 + "%")
        $("#counter").fadeIn(250)
        counterActive = true
    } else if (action == "hideCounter") {
        $("#counter").fadeOut(250)
        counterActive = false
    } else if (action == "updateCounter") {
        $("#counterValue").text(event.data.value.toString() + "%")
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
}

$.post(`https://${GetParentResourceName()}/nuiLoaded`)
