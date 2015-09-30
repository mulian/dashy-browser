var app = require('app');  // Module to control application life.
var BrowserWindow = require('browser-window');  // Module to create native browser window.
var fs = require('fs')
// var packageFile = require('./package.json');

var coffee = require('coffee-script');
// console.log(coffee);
require('crash-reporter').start();
var coffeePath='./lib/', jsPath='./src/'

var numFiles=0;

compileToCoffe = function(file_path,file_name) {
  // console.log("compileToCoffe: "+file_path+" name: "+file_name);
  var file_name_js = file_name.slice(0,file_name.length-7)+'.js';
  // console.log(file_name_js);
  fs.readFile(file_path,'utf8',function(err,data) {
    // console.log(data);
    fs.writeFile(jsPath+file_name_js,coffee.compile(data),function(err) {
      if(err) throw err;
      console.log("Compile: "+file_path+" to "+jsPath+file_name_js);
      numFiles--;
      //run main.js (aka. main.coffee), after compile
      if(numFiles==0) require(jsPath+'main.js')(app,BrowserWindow)
    });
  });
};

fs.readdir(coffeePath,function(err,files) {
  if(err) throw err;
  numFiles=files.length;
  for(var i=0;i<files.length;i++) {
    var file = files[i];
    // console.log("compile: "+file);
    compileToCoffe(coffeePath+file,file);
  }
});
