// var app = require('app');  // Module to control application life.
// var BrowserWindow = require('browser-window');  // Module to create native browser window.
var fs = require('fs')
// var packageFile = require('./package.json');


//COFFEESCRIPT
var coffee = require('coffee-script');
// console.log(coffee);

var coffeePath=__dirname+'/lib/', jsPath=__dirname+'/src/'

// if (process.platform == 'win32') {
//   coffeePath = __dirname+coffeePath;
//   jsPath = __dirname+jsPath;
//
//   //coffeePath.replace(/\//g,'\\');
//   //jsPath.replace(/\//g,'\\');
// } else {
//   coffeePath = '.'+coffeePath;
//   jsPath = '.'+jsPath;
// }


compileToCoffe = function(file_path,file_name) {
  // console.log("compileToCoffe: "+file_path+" name: "+file_name);
  var file_name_js = file_name.slice(0,file_name.length-6)+'js';
  // console.log(file_name_js);
  var data=fs.readFileSync(file_path,'utf8');
  console.log(jsPath+file_name_js);
  fs.writeFileSync(jsPath+file_name_js,coffee.compile(data));
};

files = fs.readdirSync(coffeePath);
for(var i=0;i<files.length;i++) {
  var file = files[i];
  // console.log("compile: "+file);
  compileToCoffe(coffeePath+file,file);
}

//LESS
var lessPath=__dirname+'/less/', cssPath=__dirname+'/css/'
// if (process.platform == 'win32') {
//   lessPath = __dirname+lessPath;
//   cssPath = __dirname+cssPath;
// } else {
//   lessPath = '.'+lessPath;
//   cssPath = '.'+cssPath;
// }
var less = require('less');
files = fs.readdirSync(lessPath);
for(var i=0;i<files.length;i++) {
  var file = files[i];
  var cssFile = file.slice(0,file.length-4)+'css';
  // console.log("compile: "+file);
  var fileDate = fs.readFileSync(lessPath+file,'utf8');
  // console.log(fileDate);
  less.render(fileDate,function (e,output) {
    //console.log(output); //maby use output.imports?
    fs.writeFileSync(cssPath+cssFile,output.css,'utf8');
  });
}

//Start src/main.js (lib/main.coffee)
require(jsPath+'main');
