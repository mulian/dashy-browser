var app = require('app');  // Module to control application life.
var BrowserWindow = require('browser-window');  // Module to create native browser window.
var fs = require('fs')


// Report crashes to our server.
require('crash-reporter').start();

// Keep a global reference of the window object, if you don't, the window will
// be closed automatically when the JavaScript object is garbage collected.
var mainWindow = null;

// Quit when all windows are closed.
app.on('window-all-closed', function() {
  // On OS X it is common for applications and their menu bar
  // to stay active until the user quits explicitly with Cmd + Q
  if (process.platform != 'darwin') {
    app.quit();
  }
});

// This method will be called when Electron has finished
// initialization and is ready to create browser windows.
app.on('ready', function() {
  // Create the browser window.
  mainWindow = new BrowserWindow({width: 800, height: 600});

  var webContents = mainWindow.webContents;
  webContents.enableDeviceEmulation({
    fitToView: true
  });
  // webContents.enableDeviceEmulation({
  //   screenPosition: 'mobile',
  //   screenSize: 'mobile',
  //   viewPosition: 'mobile',
  //   screenSize: {
  //     width: 800,
  //     height: 600
  //   },
  //   deviceScaleFactor: 0,
  //   viewSize: {
  //     width: 800,
  //     height: 600
  //   },
  //   fitToView: true,
  //   scale: 1,
  //   offset: {
  //     x:0, y:0
  //   }
  // });

  // and load the index.html of the app.
  mainWindow.loadUrl('http://localhost:8081/');
  // mainWindow.loadUrl('file://' + __dirname + '/index.html');
  // mainWindow.loadUrl('file://' + __dirname + '/file.html');
  // mainWindow.loadUrl('https://www.mozilla.org/en-US/firefox/new/#download-fx');
  // mainWindow.loadUrl('https://www.iconfinder.com/iconsets/hawcons');
  // mainWindow.loadUrl('http://www.pdfmerge.com');

  var menujs = fs.readFileSync(__dirname + '/menu.js');
  // console.log(menujs.toString());

  webContents.on('did-frame-finish-load', function(event,isMainFrame) {
    console.log("did-frame-finish-load: "+isMainFrame);
    if (isMainFrame) webContents.executeJavaScript(menujs.toString());
  });

  // Open the DevTools.
  mainWindow.openDevTools();

  var session = webContents.session;

  session.on('will-download',function(event,item,webContents) {
    console.log("DOWNLOAD: "+item.url);
    event.preventDefault();
    // require('request')(item.url, function(data) {
    //   require('fs').writeFileSync('/somewhere', data);
    // });
    //THEN: https://github.com/request/request
  });


  // webContents.on('new-window',function(event) {
  //   console.log("new-window");
  //   event.preventDefault();
  //   console.log(event);
  // });
  // webContents.on('did-start-loading',function(event) {
  //   console.log("did-start-loading");
  //   event.preventDefault();
  //   console.log(event);
  // });
  //

  // Emitted when the window is closed.
  mainWindow.on('closed', function() {
    // Dereference the window object, usually you would store windows
    // in an array if your app supports multi windows, this is the time
    // when you should delete the corresponding element.
    mainWindow = null;
  });
});
