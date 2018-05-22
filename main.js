const { app, BrowserWindow } = require('electron')
const path = require('path')
const url = require('url')

/**
 * Creates the window
 */
function createWindow() {
    // Create the browser window.
    win = new BrowserWindow({ width: 1280, height: 720, minWidth: 1024, minHeight: 576 });

    // and load the index.html of the app.
    win.loadURL(url.format({
        pathname: path.join(__dirname, 'index.html'),
        protocol: 'file:',
        slashes: true
    }));
    //Remove the top menu bar
    //win.setMenu(null);
}

app.on('ready', createWindow)