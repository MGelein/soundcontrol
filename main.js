const { app, BrowserWindow } = require('electron')
const path = require('path')
const url = require('url')

/**
 * Creates the window
 */
function createWindow() {
    // Create the browser window.
    win = new BrowserWindow({ width: 1280, height: 720 })

    // and load the index.html of the app.
    win.loadURL(url.format({
        pathname: path.join(__dirname, 'index.html'),
        protocol: 'file:',
        slashes: true
    }))
}

app.on('ready', createWindow)