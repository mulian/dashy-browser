var start = false;
document.body.addEventListener('mousedown', function(event) {
  if (event.clientX < 10) {
    start=true
  }
});

document.body.addEventListener('mousemove', function(event) {
  if (start && (event.clientX > 20)) {
    console.log("menu?");
    start=false
  }
});

document.body.addEventListener('mouseup', function(event) {
  if (start && (event.clientX > 20)) {
    console.log("menu?");
  }
  start=false
});
