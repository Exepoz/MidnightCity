import React, { useState, useEffect } from 'react';
import { SplashText, HackType, GameType } from '../../typings/gameOptions';
import Splash from './Splash/Splash';
import './Game.css';
import Hack from './Hack/Hack';

// https://sharkiller.ddns.net/nopixel_minigame/hackingdevice/minigame.js?v=20210808

type GameProps = {
    hackType: HackType,
    gameType: GameType,
    duration: number
}

const Game: React.FC<GameProps> = ({ hackType, gameType, duration }) => {
    const [splashText, setSplashText] = useState(SplashText.PREPARING);
    const [gameStarted, setGameStarted] = useState(false);

    useEffect(() => {
        if (!gameStarted) {
            setTimeout(() => {
                setGameStarted(true);
                setSplashText(SplashText.CONNECTING);
            }, 1500);

        }
    }, [gameStarted, duration, hackType])
    return (
        <div className='minigame'>
            <Splash text={splashText}></Splash>
            {gameStarted && (
                <Hack hackType={hackType} gameType={gameType} duration={duration} />
            )}
        </div>
    );
}

export default Game;
