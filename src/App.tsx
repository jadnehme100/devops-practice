import { useState } from 'react';

function App() {
  const [count, setCount] = useState(0);

  return (
    <main style={{ fontFamily: 'system-ui, sans-serif', padding: 24 }}>
      <h1>DevOps Practice App</h1>
      <p>Built with Vite + React, packaged with Docker, served by Nginx.</p>
      <button onClick={() => setCount((c) => c + 1)}>
        Clicks: {count}
      </button>
    </main>
  );
}

export default App;