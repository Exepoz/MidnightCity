let canvas = document.getElementById("fishingCanvas");
let ctx = canvas.getContext("2d");

let progressValue = 0;
let isPlaying = false;
let fishPos = 50;
let isGoingUp = true;
let fishSpeed = 3;

let playerBarPos = canvas.height / 2 - 50;  // This will be the green bar, controlled by the player
let playerBarSpeed = 4;

let maxTime = 10; // This represents the total time in seconds.
let currentTime = maxTime; // This represents the current remaining time.

let fishImage = document.getElementById("fishSVG");
let hookImage = document.getElementById("hookSVG");
let hourglassImage = document.getElementById("hourglassSVG");


window.addEventListener('message', (event) => {
    if (event.data.action === 'startGame') {
        startGame();
    }
});

function startGame() {
    isPlaying = true;
    resetGame();
    $('#fishingCanvas').show();
    lastTime = Date.now();
    if (fishImage.complete) {  // If the image is already loaded
        gameLoop();
    } else {
        fishImage.onload = function () {

            gameLoop();
        };
    }
}
let lastTime = Date.now();
let animationFrameId;

function gameLoop() {
    if (!isPlaying) {
        return;  // Exit the loop if the game isn't playing.
    }
    let now = Date.now();
    let deltaTime = (now - lastTime) / 1000; // Convert to seconds
    lastTime = now;

    currentTime -= deltaTime;

    if (currentTime <= 0) {
        endGame(false);
    }
    draw();    // Draw game objects.
    moveFish();

    // Request the next frame.
    animationFrameID = requestAnimationFrame(gameLoop);
}


function drawTimerBar(ctx, canvas) {
    let timerBarHeight = (currentTime / maxTime) * canvas.height;
    ctx.fillStyle = 'yellow';
    ctx.fillRect(40, canvas.height - timerBarHeight, 30, timerBarHeight); // Assuming the x-coordinate is 50 to place it next to the other bar
}

function drawBeveledBox(x, y, width, height, bevelWidth) {
    // Base color for the beveled box
    let baseColor = "#42403d"; // 

    // Top edge
    let topGradient = ctx.createLinearGradient(x, y, x, y + bevelWidth);
    topGradient.addColorStop(0, 'rgba(255, 255, 255, 0.6)');  // Lighter shade for the top bevel
    topGradient.addColorStop(1, baseColor);
    ctx.fillStyle = topGradient;
    ctx.fillRect(x, y, width, bevelWidth);

    // Bottom edge
    let bottomGradient = ctx.createLinearGradient(x, y + height, x, y + height - bevelWidth);
    bottomGradient.addColorStop(0, 'rgba(0, 0, 0, 0.6)');  // Darker shade for the bottom bevel
    bottomGradient.addColorStop(1, baseColor);
    ctx.fillStyle = bottomGradient;
    ctx.fillRect(x, y + height - bevelWidth, width, bevelWidth);

    // Left edge
    let leftGradient = ctx.createLinearGradient(x, y, x + bevelWidth, y);
    leftGradient.addColorStop(0, 'rgba(255, 255, 255, 0.6)');
    leftGradient.addColorStop(1, baseColor);
    ctx.fillStyle = leftGradient;
    ctx.fillRect(x, y, bevelWidth, height);

    // Right edge
    let rightGradient = ctx.createLinearGradient(x + width, y, x + width - bevelWidth, y);
    rightGradient.addColorStop(0, 'rgba(0, 0, 0, 0.6)');
    rightGradient.addColorStop(1, baseColor);
    ctx.fillStyle = rightGradient;
    ctx.fillRect(x + width - bevelWidth, y, bevelWidth, height);

    // Fill the center
    ctx.fillStyle = baseColor;
    ctx.fillRect(x + bevelWidth, y + bevelWidth, width - 2 * bevelWidth, height - 2 * bevelWidth);
}

function draw() {
    // Clear canvas
    ctx.clearRect(0, 0, canvas.width, canvas.height);

    // Draw a box around everything
    ctx.fillStyle = "#141414";  // Color of the outer box      
    ctx.fillRect(0, 0, 150, canvas.height);


    let gradient = ctx.createLinearGradient(0, canvas.height, 0, 0);
    gradient.addColorStop(0, '#05696B');    // Start color (bottom)
    gradient.addColorStop(1, 'lightblue');   // End color (top)

    // Draw background of bar
    ctx.fillStyle = gradient;
    ctx.fillRect(0, 0, 40, canvas.height);

    // Draw player's bar (green bar)
    drawBeveledBox(0, playerBarPos, 40, 100, 2);

    // Set the font, size, and style for the letter "R"
    ctx.font = "20px Arial";
    ctx.fillStyle = "white";  // color of the text

    // Calculate the position to center the letter inside the playerBar
    let textWidth = ctx.measureText("R").width;
    let textX = (40 - textWidth) / 2;  // centering horizontally
    let textY = playerBarPos + 30;    // assuming 48px font, this will center it vertically

    // Draw the letter "R" centered inside the playerBar
    ctx.fillText("R", textX, textY);
    ctx.fillText("E", textX, textY + 20);
    ctx.fillText("E", textX, textY + 40);
    ctx.fillText("L", textX, textY + 60);


    //fish SVG
    ctx.drawImage(fishImage, 0, fishPos, 40, 30);  // x, y, width, height



    drawTimerBar(ctx, canvas)
    // Draw progress
    ctx.fillStyle = "#2ee06f";
    ctx.fillRect(70, canvas.height - (progressValue * (canvas.height / 100)), 40, progressValue * (canvas.height / 100));

    //hourglass and hook SVG
    ctx.drawImage(hookImage, 75, 475, 20, 20);  // x, y, width, height
    ctx.drawImage(hourglassImage, 45, 475, 20, 20);  // x, y, width, height

    if (progressValue >= 100) {
        endGame(true);
    }

}

let isLeftButtonDown = false;
let isRightButtonDown = false;

canvas.addEventListener('mousedown', function (event) {
    switch (event.button) {
        case 0: // Left button
            isLeftButtonDown = true;
            break;
        case 2: // Right button
            isRightButtonDown = true;
            event.preventDefault(); // to prevent context menu
            break;
    }
    movePlayerBar();
});

canvas.addEventListener('mouseup', function (event) {
    switch (event.button) {
        case 0: // Left button
            isLeftButtonDown = false;
            break;
        case 2: // Right button
            isRightButtonDown = false;
            break;
    }
});

function resetGame() {
    currentTime = maxTime
    progressValue = 0;
    fishPos = 50;
    fishSpeed = 3;
    playerBarSpeed = 4;
    isLeftButtonDown = false;
    isRightButtonDown = false;
    // ... any other variables you have
}


let changeDirectionTimeout;
let blueBox = document.querySelector('.blue-box');

function moveFish() {
    if (Math.random() > 0.98) {
        isGoingUp = !isGoingUp;  // Randomly change direction
    }

    if (isGoingUp) {
        fishPos -= fishSpeed;  // Modified to ensure the fish moves up when isGoingUp is true
    } else {
        fishPos += fishSpeed;  // Modified to ensure the fish moves down when isGoingUp is false
    }

    // Boundary checks: Change direction if the fish hits the top or bottom
    if (fishPos > canvas.height - 30 || fishPos < 0) {
        isGoingUp = !isGoingUp;
    }

    // Logic to check if the fish (blue box) is within the green bar
    if (fishPos + 30 > playerBarPos && fishPos < playerBarPos + 100) {
        progressValue += 0.5;
    } else {
        progressValue -= 0.3;
    }

    progressValue = Math.max(Math.min(progressValue, 100), 0);
}



function movePlayerBar() {
    if (isLeftButtonDown) {
        playerBarPos -= playerBarSpeed;
    } else if (isRightButtonDown) {
        playerBarPos += playerBarSpeed;
    }

    // Boundary checks
    if (playerBarPos < 0) playerBarPos = 0;
    if (playerBarPos > canvas.height - 100) playerBarPos = canvas.height - 100;

    // If either button is still down, keep moving
    if (isLeftButtonDown || isRightButtonDown) {
        requestAnimationFrame(movePlayerBar);
    }
}


function endGame(status) {
    isPlaying = false;
    window.cancelAnimationFrame(animationFrameId);
    $('#fishingCanvas').hide();
    var xhr = new XMLHttpRequest();
    let u = "fail";
    if (status)
        u = "success";
    xhr.open("POST", `https://malmofish/fish-${u}`, true);
    xhr.setRequestHeader('Content-Type', 'application/json');
    xhr.send(JSON.stringify({}));
    // Close the NUI
    ctx.clearRect(0, 0, canvas.width, canvas.height);
}

