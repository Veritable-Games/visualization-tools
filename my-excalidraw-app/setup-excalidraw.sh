#!/bin/bash

# Excalidraw App Setup Script
# This script ensures proper installation of Excalidraw and its dependencies

set -e
echo "=== Setting up Excalidraw App ==="

# Navigate to the app directory
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
cd "$SCRIPT_DIR"

# Clean existing installation
echo "=== Cleaning previous installation ==="
rm -rf node_modules package-lock.json

# Update package.json with correct dependencies
echo "=== Creating compatible package.json ==="
cat > package.json << 'EOL'
{
  "name": "my-excalidraw-app",
  "version": "0.1.0",
  "private": true,
  "dependencies": {
    "@excalidraw/excalidraw": "^0.14.2",
    "@testing-library/jest-dom": "^5.16.5",
    "@testing-library/react": "^13.4.0",
    "@testing-library/user-event": "^13.5.0",
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-scripts": "5.0.1",
    "roughjs": "^4.5.2",
    "web-vitals": "^2.1.4"
  },
  "scripts": {
    "start": "react-scripts start",
    "build": "react-scripts build",
    "test": "react-scripts test",
    "eject": "react-scripts eject",
    "lint": "eslint src",
    "lint:fix": "eslint src --fix",
    "serve": "serve -s build"
  },
  "eslintConfig": {
    "extends": [
      "react-app",
      "react-app/jest"
    ]
  },
  "browserslist": {
    "production": [
      ">0.2%",
      "not dead",
      "not op_mini all"
    ],
    "development": [
      "last 1 chrome version",
      "last 1 firefox version",
      "last 1 safari version"
    ]
  }
}
EOL

# Install dependencies with clean cache
echo "=== Installing dependencies ==="
npm cache clean --force
npm install

# Create the main App.js file
echo "=== Creating App.js ==="
mkdir -p src
cat > src/App.js << 'EOL'
import React, { useState, useRef } from 'react';
import './App.css';
import { Excalidraw } from "@excalidraw/excalidraw";

function App() {
  const excalidrawRef = useRef(null);
  const [viewModeEnabled, setViewModeEnabled] = useState(false);
  
  const toggleViewMode = () => {
    setViewModeEnabled(!viewModeEnabled);
  };

  const handleSave = () => {
    if (!excalidrawRef.current) return;
    
    const elements = excalidrawRef.current.getSceneElements();
    const appState = excalidrawRef.current.getAppState();
    
    const data = JSON.stringify({ elements, appState });
    localStorage.setItem('excalidraw-data', data);
    
    alert('Drawing saved!');
  };
  
  const handleLoad = () => {
    if (!excalidrawRef.current) return;
    
    const savedData = localStorage.getItem('excalidraw-data');
    if (savedData) {
      try {
        const { elements, appState } = JSON.parse(savedData);
        excalidrawRef.current.updateScene({ elements, appState });
        alert('Drawing loaded!');
      } catch (error) {
        console.error('Error loading saved data:', error);
        alert('Error loading drawing');
      }
    } else {
      alert('No saved drawing found');
    }
  };
  
  const handleClear = () => {
    if (!excalidrawRef.current) return;
    
    if (window.confirm('Are you sure you want to clear the canvas?')) {
      excalidrawRef.current.resetScene();
    }
  };

  return (
    <div className="App">
      <header className="App-header">
        <h1>My Excalidraw App</h1>
        <div className="header-controls">
          <button onClick={toggleViewMode}>
            {viewModeEnabled ? 'Edit Mode' : 'View Mode'}
          </button>
        </div>
      </header>
      <div className="control-panel">
        <button onClick={handleSave}>Save</button>
        <button onClick={handleLoad}>Load</button>
        <button onClick={handleClear}>Clear</button>
      </div>
      <div className="excalidraw-wrapper">
        <Excalidraw
          ref={excalidrawRef}
          initialData={{
            elements: [],
            appState: {
              viewBackgroundColor: '#ffffff',
              currentItemFontFamily: 1,
            },
          }}
          viewModeEnabled={viewModeEnabled}
          theme="light"
        />
      </div>
    </div>
  );
}

export default App;
EOL

# Create the CSS file
echo "=== Creating App.css ==="
cat > src/App.css << 'EOL'
.App {
  text-align: center;
  display: flex;
  flex-direction: column;
  height: 100vh;
}

.App-header {
  background-color: #282c34;
  padding: 20px;
  color: white;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.App-header h1 {
  margin: 0;
  font-size: 1.5em;
}

.header-controls button {
  background-color: #61dafb;
  border: none;
  border-radius: 4px;
  color: #282c34;
  padding: 8px 16px;
  font-weight: bold;
  cursor: pointer;
}

.header-controls button:hover {
  background-color: #4fa8d1;
}

.control-panel {
  display: flex;
  justify-content: center;
  gap: 10px;
  padding: 10px;
  background-color: #f5f5f5;
  border-bottom: 1px solid #ddd;
}

.control-panel button {
  background-color: #4285f4;
  color: white;
  border: none;
  border-radius: 4px;
  padding: 8px 16px;
  cursor: pointer;
  font-weight: bold;
}

.control-panel button:hover {
  background-color: #3367d6;
}

.excalidraw-wrapper {
  flex-grow: 1;
  height: calc(100vh - 130px);
  position: relative;
}

.excalidraw-container {
  height: 100%;
}
EOL

# Create the index.js file
echo "=== Creating index.js ==="
cat > src/index.js << 'EOL'
import React from 'react';
import ReactDOM from 'react-dom/client';
import './index.css';
import App from './App';
import reportWebVitals from './reportWebVitals';

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);

// If you want to start measuring performance in your app, pass a function
// to log results (for example: reportWebVitals(console.log))
// or send to an analytics endpoint. Learn more: https://bit.ly/CRA-vitals
reportWebVitals();
EOL

# Create the index.css file
echo "=== Creating index.css ==="
cat > src/index.css << 'EOL'
body {
  margin: 0;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Oxygen',
    'Ubuntu', 'Cantarell', 'Fira Sans', 'Droid Sans', 'Helvetica Neue',
    sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

code {
  font-family: source-code-pro, Menlo, Monaco, Consolas, 'Courier New',
    monospace;
}
EOL

# Create reportWebVitals.js
echo "=== Creating reportWebVitals.js ==="
cat > src/reportWebVitals.js << 'EOL'
const reportWebVitals = onPerfEntry => {
  if (onPerfEntry && onPerfEntry instanceof Function) {
    import('web-vitals').then(({ getCLS, getFID, getFCP, getLCP, getTTFB }) => {
      getCLS(onPerfEntry);
      getFID(onPerfEntry);
      getFCP(onPerfEntry);
      getLCP(onPerfEntry);
      getTTFB(onPerfEntry);
    });
  }
};

export default reportWebVitals;
EOL

# Create a start script
echo "=== Creating start-app.sh ==="
cat > start-app.sh << 'EOL'
#!/bin/bash

# Start the Excalidraw App

# Navigate to the app directory
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
cd "$SCRIPT_DIR"

# Start the React development server
echo "Starting Excalidraw App..."
npm start
EOL

# Make the start script executable
chmod +x start-app.sh

echo "=== Setup complete! ==="
echo "You can now run the app with: ./start-app.sh"