#First Menu
start = false
document.body.addEventListener 'mousedown', (event) ->
  if event.clientX < 10
    start = true
  return
document.body.addEventListener 'mousemove', (event) ->
  if start and event.clientX > 20
    console.log 'menu?'
    start = false
  return
document.body.addEventListener 'mouseup', (event) ->
  if start and event.clientX > 20
    console.log 'menu?'
  start = false
  return
