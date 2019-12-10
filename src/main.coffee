import * as PIXI from 'pixi.js'
import * as Honeycomb from 'honeycomb-grid'

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

app = new PIXI.Application({ transparent: true, antialias: true })
document.body.appendChild(app.view)

setup = ->
    sheet = PIXI.Loader.shared.resources['assets/spritesheet.json'].spritesheet
    sprite = new PIXI.Sprite sheet.textures['image_part_001.png']
    sprite.anchor.x = 0
    sprite.anchor.y = 0
    sprite.position.x = 0
    sprite.position.y = 0
    app.stage.addChild sprite

PIXI.Loader.shared.add('assets/spritesheet.json').load(setup)

#drawHex = (hex, graphics) ->
#    point = hex.toPoint()
#    corners = hex.corners().map (corner) -> corner.add point
#    [firstCorner, otherCorners...] = corners
#    graphics.moveTo firstCorner.x, firstCorner.y
#    for { x, y } in otherCorners
#        graphics.lineTo x, y
#    graphics.lineTo firstCorner.x, firstCorner.y
#
#draw = ->
#    graphics = new PIXI.Graphics()
#    graphics.lineStyle(1, 0x999999)
#    count = 0
#    for hex in grid
#        drawHex hex, graphics
#    app.stage.addChild graphics
#
#draw()
#
#
#class H
#    constructor : (@color) ->
#        @line = new PIXI.Graphics()
#        @line.lineStyle 4, @color
#    highlight : (hex) ->
#        drawHex hex, @line
#        app.stage.addChild @line
#    unlight : ->
#        @line.clear()
#        @setup()
#    setup : ->
#        @line.lineStyle 4, @color
#
#blueHighlight = new H 0x0000ff
#yellowHighlight = new H 0xffff00
#
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
