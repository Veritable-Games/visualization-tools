const express = require('express');
const path = require('path');
const fs = require('fs');
const app = express();
const PORT = 3005;

// Serve static files
app.use(express.static(__dirname));

// Start server
app.listen(PORT, () => {
  console.log(`Enhancement server running on port ${PORT}`);
});
