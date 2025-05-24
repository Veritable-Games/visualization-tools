// This script is meant to be loaded into the unified interface
// It will inject our enhanced features

document.addEventListener('DOMContentLoaded', () => {
  // Get the container element
  const container = document.querySelector('.container');
  
  if (!container) {
    console.error('Container element not found');
    return;
  }
  
  // Create a request to fetch our enhancements
  fetch('/enhancements.html')
    .then(response => response.text())
    .then(html => {
      // Insert the enhancements before the views
      const views = document.querySelector('.views');
      if (views) {
        // Create a div for our enhancements
        const enhancementsDiv = document.createElement('div');
        enhancementsDiv.innerHTML = html;
        
        // Insert before the views
        container.insertBefore(enhancementsDiv, views);
      }
    })
    .catch(error => {
      console.error('Error loading enhancements:', error);
    });
});
