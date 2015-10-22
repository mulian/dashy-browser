//main.js
//It compiles coffeescript to js and runs the main.coffe aka. main.js

var settings = require('./package.json').settings;

//define path
var coffeePath=__dirname+'/lib/', jsPath=__dirname+'/src/'
//if package.json > settings.debug is true, the coffeescript will compile
if (settings.debug) {
  var fs = require('fs')
  var coffee = require('coffee-script');

  //compiles the file_path from coffeescript to js and write it to jsPath+file_name
  compileToCoffe = function(file_path,file_name) {
    var file_name_js = file_name.slice(0,file_name.length-6)+'js';
    var data=fs.readFileSync(file_path,'utf8');
    fs.writeFileSync(jsPath+file_name_js,coffee.compile(data));
  };

  //Scan all files in cofeescript dir
  files = fs.readdirSync(coffeePath);
  for(var i=0;i<files.length;i++) {
    var file = files[i];
    compileToCoffe(coffeePath+file,file);
  }

  //Compile LESS to CSS
  var lessPath=__dirname+'/less/', cssPath=__dirname+'/css/'
  var less = require('less');
  files = fs.readdirSync(lessPath);
  for(var i=0;i<files.length;i++) {
    var file = files[i];
    var cssFile = file.slice(0,file.length-4)+'css';
    var fileDate = fs.readFileSync(lessPath+file,'utf8');
    less.render(fileDate,function (e,output) {
      fs.writeFileSync(cssPath+cssFile,output.css,'utf8');
    });
  }
}
//Run the main APP (jsPath+'main.js')
require(jsPath+'main');
