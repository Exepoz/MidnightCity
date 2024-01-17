import React, { useState, useEffect, useCallback, useRef } from 'react';
import classNames from 'classnames';
import { GameType, HackType } from '../../../typings/gameOptions';
import './Hack.css';
import { getRandomSetChar, randomNumber, sleep } from '../../../utils/random';
import { useHackMoveListener } from './useHackMoveListener';
import { fetchNui } from '../../../utils/fetchNui';

type HackProps = {
    hackType: HackType,
    gameType: GameType,
    duration: number
}

const Hack: React.FC<HackProps> = ({ hackType, gameType, duration }) => {
    const timerStart = useRef<Date>(new Date());
    const timerGame: any = useRef();
    const timerTime = useRef<any>();
    const timerFinish: any = useRef();
    const [correctPosition] = useState<number>(randomNumber(0, 79));
    const codes = useRef<any[]>([]);
    const [showCorrect, setShowCorrect] = useState(false);
    const codesPosition = useRef<number>(1);
    const currentPosition = useRef<number>(43);
    const [timerValue, setTimerValue] = useState<string>('');

    const getGroupFromPosition = (position: number): Array<number> => {
        let group = [position];
        for (let i = 1; i < 4; i++) {
            if (position + 1 >= 80) group.push(position + i - 80);
            else group.push(position + i);
        }
        return group;
    }

    const [toFind] = useState<Array<number>>(getGroupFromPosition(correctPosition));


    const moveCodes = useCallback(() => {
        let codesPos = (codesPosition.current + 1) % 80;
        codesPosition.current = codesPos;

        let temporaryCodes = [...codes.current];
        temporaryCodes.push(temporaryCodes.shift());
        codes.current = temporaryCodes;

    }, [codesPosition]);

    const timer = () => {
        let msString;
        let timerNow = new Date();
        let timerDiff = new Date();
        timerDiff.setTime(timerNow.getTime() - timerStart.current.getTime());
        let ms = (999 - timerDiff.getMilliseconds());
        let sec = timerDiff.getSeconds();
        if (ms > 99) msString = Math.floor(ms / 10);
        else if (ms < 10) msString = `0${ms}`;
        else msString = ms;
        setTimerValue(`${duration - 1 - sec}.${msString}`);
    }

    const check = () => {
        clearInterval(timerTime.current);

        let currentAttempt = (currentPosition.current + codesPosition.current);
        currentAttempt %= 80;

        setShowCorrect(true);

        setTimeout(() => {
            if (currentAttempt === correctPosition) {
                fetchNui('close-frame', true);
            } else {
                fetchNui('close-frame', false);
            }
        }, 1500);

        resetGame();
    }

    const resetGame = () => {
        clearInterval(timerTime.current);
        clearTimeout(timerGame.current);
        clearTimeout(timerFinish.current);
    }

    const hackClassName = classNames({
        'hack': true,
        'mirrored': gameType === GameType.MIRRORED
    });

    function generateCodes() {
        let tempCodes = [];
        for (let i = 0; i < 80; i++) {
            tempCodes.push(getRandomSetChar(hackType) + getRandomSetChar(hackType));
        }
        codes.current = tempCodes;
    }


    useEffect(() => {
        generateCodes();
        currentPosition.current = 43;
        codesPosition.current = 0;
        setShowCorrect(false);

        timerStart.current = new Date();
        timerTime.current = setInterval(timer, 1);
        timerGame.current = setInterval(moveCodes, 1500);
        timerFinish.current = sleep(duration * 1000, () => {
            check();
        });
        // eslint-disable-next-line react-hooks/exhaustive-deps
    }, []);

    const checkTrail = (position: number, trailPosition: number) => {
        if (trailPosition >= 80) return position === trailPosition - 80;
        return position === trailPosition;
    }

    const shouldShowAsCurrent = (position: number) => {
        if (position === currentPosition.current) return true;
        if (checkTrail(position, currentPosition.current + 1)) return true;
        if (checkTrail(position, currentPosition.current + 2)) return true;
        if (checkTrail(position, currentPosition.current + 3)) return true;
        return false;
    }

    useHackMoveListener(currentPosition.current, (newPos) => currentPosition.current = newPos, check);


    return (
        <div className={hackClassName}>
            <div className='find'>
                {toFind.map((toFind) => {
                    let positionToCheck = toFind - codesPosition.current;
                    if (positionToCheck < 0) positionToCheck += 80;
                    if (positionToCheck >= 80) positionToCheck -= 80;

                    return (<div key={toFind}>{codes.current[positionToCheck]}</div>);
                })}
            </div>
            <div className='timer'>{timerValue}</div>
            <div className='codes'>
                {codes.current.map((code, i) => {
                    let codesCorrect = i + codesPosition.current;
                    if (codesCorrect >= 80) codesCorrect -= 80;
                    const classname = classNames({
                        'current': shouldShowAsCurrent(i),
                        'correct': showCorrect && toFind.some((tf) => tf === codesCorrect),
                    })
                    return (<div className={classname} key={code + i}>{code}</div>);
                })
                }
            </div>
        </div>
    );
}

export default Hack;

