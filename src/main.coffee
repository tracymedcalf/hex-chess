import * as PIXI from 'pixi.js'
import * as Honeycomb from 'honeycomb-grid'
import { Sprite } from './sprites.coffee'

config = require './config.json'
# add globals to window.

# width and height in hexes
window.width = 10
window.height = 10
window.Hex = Honeycomb.extendHex({
    size: 40
    offset: 1
})
window.Grid = Honeycomb.defineGrid(Hex)
window.grid = Grid.rectangle {width, height}

newNode = (className, type = 'DIV') =>
    (ret = document.createElement type).className +=
        className
    ret


    
app = new PIXI.Application({ transparent: true, antialias: true })
textLayer = do ->
    view = app.view
    document.body.appendChild container = newNode 'container'
    container.appendChild view

    # create the text layer
    container.appendChild textLayer = newNode 'text-layer'
    textLayer

addText = (text, {x, y}) =>
    textLayer.appendChild cont = newNode 'floating-div'
    cont.style.left = x + 'px'
    cont.style.top = y + 'px'
    cont.appendChild document.createTextNode text
    cont

drawHex = (hex, graphics) ->
    point = hex.toPoint()
    corners = hex.corners().map (corner) -> corner.add point
    [firstCorner, otherCorners...] = corners
    graphics.moveTo firstCorner.x, firstCorner.y
    for { x, y } in otherCorners
        graphics.lineTo x, y
    graphics.lineTo firstCorner.x, firstCorner.y

draw = ->
    graphics = new PIXI.Graphics()
    graphics.lineStyle(1, 0x999999)
    count = 0
    for hex in grid
        drawHex hex, graphics
    app.stage.addChild graphics

draw()

setup = ->
    sheet = PIXI.Loader.shared.resources['assets/spritesheet.json'].spritesheet
    sprite = new PIXI.Sprite sheet.textures['image_part_001.png']
    app.stage.addChild sprite

PIXI.Loader.shared.add('assets/spritesheet.json').load(setup)

#getHexCoordinates = (offsets) ->
#    {offsetX, offsetY} = offsets
#    Grid.pointToHex(offsetX, offsetY)
#
#clickCoordinates = {}
#mousedown = false
#
## highlight the hex specified by
## cube coordinates
##lightCube = (q, r, s) ->
##    yellowHighlight.highlight(
##        grid.get Hex().cubeToCartesian {q, r, s})
#
#lightCartesian = (x, y) ->
#    hex = grid.get {x, y}
#    if hex?
#        yellowHighlight.highlight(hex)
#
#highlightStraight = (hex) ->
#    for hex in straightRange hex
#        yellowHighlight.highlight hex
#
#select = (hex) ->
#    if hex?.piece
#        highlightStraight hex
#        blueHighlight.unlight()
#        blueHighlight.highlight hex
#
#document.addEventListener 'mousedown', (offsets) ->
#    mousedown = true
#    clickCoordinates = getHexCoordinates offsets
#    select grid.get(clickCoordinates)
#
##document.addEventListener 'mousemove', (event) ->
##    if mousedown
##        {x, y} = destCoordinates = getHexCoordinates event
##        # check if player dragged between hexes
##        if x != clickCoordinates.x or y != clickCoordinates.y
##            console.log 'dragging'
##            blueHighlight.highlight destCoordinates
##            # source cube coordinates
##            sC = Hex().cartesianToCube(x, y)
##            # destination cube coordinates
##            dC = Hex().cartesianToCube(clickCoordinates)
##            if sC.q == dC.q or sC.r == dC.r or sC.s == dC.s
##                console.log 'straight line drag'
##
##document.addEventListener 'mouseup', (event) ->
##    mousedown = false
##    console.log 'mouseup'
##    #blueHighlight.unlight()

coordinatesNodes = []

removeCoordinates = ->
    for node in coordinatesNodes
        node.remove()

displayCoordinates = (f) ->
    removeCoordinates()
    coordinatesNodes = for hex in grid
        addText (f hex), hex.toPoint()

radioHandler = ({target}) ->
    switch target.value
        when 'cartesian' then displayCoordinates ({x, y}) ->
            "(#{x}, #{y})"
        when 'cube' then displayCoordinates (hex) ->
            {q, r, s} = Hex().cartesianToCube hex
            "(#{q},#{r},#{s})"
        when 'off' then removeCoordinates()
for button in document.getElementsByTagName 'input'
    console.log 'adding event'
    button.addEventListener 'change', radioHandler
