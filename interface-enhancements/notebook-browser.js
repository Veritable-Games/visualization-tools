// Notebook Browser Component for Unified Interface

// State
let currentDirectory = '';
let currentFile = '';
let fileContent = '';

// Initialize when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
  // Get references to elements
  const directorySelect = document.getElementById('directory-select');
  const fileList = document.getElementById('file-list');
  const contentArea = document.getElementById('notebook-content');
  const importButton = document.getElementById('import-button');
  
  // Add event listeners
  directorySelect.addEventListener('change', handleDirectoryChange);
  importButton.addEventListener('click', handleImport);
  
  // Initial load of directories
  loadDirectories();
  
  // Function to load directories
  async function loadDirectories() {
    try {
      const response = await fetch('http://localhost:3003/notebooks');
      const data = await response.json();
      
      if (data.directories && data.directories.length > 0) {
        // Clear select
        directorySelect.innerHTML = '<option value="">Select a directory...</option>';
        
        // Add options
        data.directories.forEach(dir => {
          const option = document.createElement('option');
          option.value = dir;
          option.textContent = dir;
          directorySelect.appendChild(option);
        });
      } else {
        directorySelect.innerHTML = '<option value="">No directories found</option>';
      }
    } catch (error) {
      console.error('Error loading directories:', error);
      directorySelect.innerHTML = '<option value="">Error loading directories</option>';
    }
  }
  
  // Handle directory change
  async function handleDirectoryChange() {
    const directory = directorySelect.value;
    currentDirectory = directory;
    
    if (!directory) {
      fileList.innerHTML = '<div class="file-item">Select a directory first</div>';
      return;
    }
    
    try {
      const response = await fetch(`http://localhost:3003/notebooks/${directory}`);
      const data = await response.json();
      
      if (data.files && data.files.length > 0) {
        fileList.innerHTML = '';
        
        data.files.forEach(file => {
          const div = document.createElement('div');
          div.className = 'file-item';
          div.textContent = file;
          div.addEventListener('click', () => loadFile(directory, file));
          fileList.appendChild(div);
        });
      } else {
        fileList.innerHTML = '<div class="file-item">No files in this directory</div>';
      }
    } catch (error) {
      console.error('Error loading files:', error);
      fileList.innerHTML = '<div class="file-item">Error loading files</div>';
    }
  }
  
  // Load file content
  async function loadFile(directory, file) {
    try {
      const response = await fetch(`http://localhost:3003/notebooks/${directory}/${file}`);
      const content = await response.text();
      
      contentArea.textContent = content;
      currentFile = file;
      fileContent = content;
      
      // Enable import button
      importButton.disabled = false;
    } catch (error) {
      console.error('Error loading file:', error);
      contentArea.textContent = 'Error loading file';
    }
  }
  
  // Handle import
  async function handleImport() {
    if (!currentDirectory || !currentFile) {
      alert('Please select a file first');
      return;
    }
    
    try {
      const response = await fetch(`http://localhost:3003/notebooks/wiki/${currentDirectory}/${currentFile}`, {
        method: 'POST'
      });
      
      if (response.ok) {
        alert('File imported to wiki successfully');
        
        // Provide link to view in wiki
        const fileName = currentFile.replace('.txt', '');
        const wikiLink = document.createElement('a');
        wikiLink.href = `http://localhost:3003/pages/${fileName}`;
        wikiLink.target = '_blank';
        wikiLink.textContent = 'View in Wiki';
        wikiLink.style.display = 'block';
        wikiLink.style.marginTop = '10px';
        contentArea.appendChild(wikiLink);
      } else {
        alert('Failed to import to wiki');
      }
    } catch (error) {
      console.error('Error importing file:', error);
      alert('Error importing file');
    }
  }
});
