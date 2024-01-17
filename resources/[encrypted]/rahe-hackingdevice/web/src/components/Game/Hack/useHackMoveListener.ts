import { useEffect, useRef } from "react";
import { noop } from "../../../utils/misc";

type PositionSetter = (position: number) => void;
type ValueChecker = () => void;

const LISTENED_KEYS = ["KeyW", "ArrowUp", "KeyS", "ArrowDown", "KeyA", "ArrowLeft", "KeyD", "ArrowRight", "Enter"];

// Basic hook to listen for key presses in NUI in order to exit
export const useHackMoveListener = (position: number, positionSetter: PositionSetter, valueChecker: ValueChecker) => {
    const setterRef = useRef<PositionSetter>(noop);
    const valueRef = useRef<ValueChecker>(noop);
    const positionRef = useRef<number>(0);

    useEffect(() => {
        setterRef.current = positionSetter
    }, [positionSetter]);

    useEffect(() => {
        valueRef.current = valueChecker
    }, [valueChecker]);

    useEffect(() => {
        positionRef.current = position;
    }, [position]);

    useEffect(() => {
        const keyHandler = (e: KeyboardEvent) => {
            if (LISTENED_KEYS.includes(e.code)) {
                switch (e.code) {
                    case "KeyW":
                    case "ArrowUp":
                        positionRef.current -= 10;
                        if (positionRef.current < 0) positionRef.current += 80;
                        setterRef.current(positionRef.current);
                        break;

                    case "KeyS":
                    case "ArrowDown":
                        positionRef.current += 10;
                        positionRef.current %= 80;
                        setterRef.current(positionRef.current);
                        break;
                    case "KeyA":
                    case "ArrowLeft":
                        positionRef.current--;
                        if (positionRef.current < 0) positionRef.current = 79;
                        setterRef.current(positionRef.current);
                        break;
                    case "KeyD":
                    case "ArrowRight":
                        positionRef.current++;
                        positionRef.current %= 80;
                        setterRef.current(positionRef.current);
                        break;
                    case "Enter":
                        valueRef.current();
                        break;
                    default: break;
                }
            }
        }

        window.addEventListener("keydown", keyHandler)

        return () => window.removeEventListener("keydown", keyHandler)
    }, []);


}