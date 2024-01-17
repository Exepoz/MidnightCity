import React, { useState } from 'react';
import './App.css'
import { useNuiEvent } from "../../hooks/useNuiEvent";
import { debugData } from "../../utils/debugData";
import { useExitListener } from "../../hooks/useExitListener";
import Game from '../Game/Game';
import { GameType, HackType } from '../../typings/gameOptions';

// This will set the NUI to visible if we are
// developing in browser
debugData([
  {
    action: 'setVisible',
    data: {
      show: true,
      hackType: "NUMERIC",
      gameType: "NORMAL",
      duration: 100
    },
  }
]);

type SetVisibleProps = {
  show: boolean,
  hackType: string,
  gameType: string,
  duration: number
}


const App: React.FC = () => {
  const [isVisible, setIsVisible] = useState(false);
  const [hackType, setHackType] = useState<HackType>(HackType.ALPHANUMERIC);
  const [gameType, setGameType] = useState<GameType>(GameType.RANDOM);
  const [duration, setDuration] = useState<number>(0);

  useNuiEvent<SetVisibleProps>('setVisible', (data) => {
    // This is our handler for the setVisible action.
    setIsVisible(data.show);
    if (data.show) {
      let selectedHackType = data.hackType as HackType;
      let selectedGameType = data.gameType as GameType;
      if (selectedHackType === HackType.RANDOM) {
        const enumValues = Object.keys(HackType);
        const enumKey = enumValues[Math.floor(Math.random() * (enumValues.length - 1))];
        selectedHackType = (enumKey as HackType);
      }
      if (selectedGameType === GameType.RANDOM) {
        const enumValues = Object.keys(GameType);
        const enumKey = enumValues[Math.floor(Math.random() * (enumValues.length - 1))];
        selectedGameType = (enumKey as GameType);
      }
      setHackType(selectedHackType);
      setGameType(selectedGameType);
      setDuration(data.duration);
    }
  });

  useExitListener(setIsVisible);

  return (
    <div className="nui-wrapper">
      {isVisible && (
        <Game hackType={hackType} gameType={gameType} duration={duration} />
      )}
    </div>
  );
}

export default App;
