import { useEffect, useState } from 'react';
import './App.css';

function App() {
  const [effects, setEffects] = useState([]);

  useEffect(() => {
    const handleKeyDown = (e) => {
      const newEffect = {
        id: Date.now(),
        key: e.key,
        x: Math.random() * window.innerWidth,
        y: Math.random() * window.innerHeight,
        color: `hsl(${Math.random() * 360}, 100%, 70%)`,
      };

      setEffects((prev) => [...prev, newEffect]);

      setTimeout(() => {
        setEffects((prev) => prev.filter((effect) => effect.id !== newEffect.id));
      }, 1000);
    };

    window.addEventListener('keydown', handleKeyDown);
    return () => window.removeEventListener('keydown', handleKeyDown);
  }, []);

  return (
    <div className="App">
      <div className="centered-text">
        <h1 className="gradient-text">Press any key to see the magic 🎉</h1>
      </div>

      {effects.map((effect) => (
        <span
          key={effect.id}
          className="burst"
          style={{
            left: effect.x,
            top: effect.y,
            backgroundColor: effect.color,
          }}
        >
          <span className="burst-key">{effect.key}</span>
        </span>
      ))}
    </div>
  );
}

export default App;
