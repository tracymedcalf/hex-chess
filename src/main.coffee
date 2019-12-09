import * as PIXI from 'pixi.js'
import * as Honeycomb from 'honeycomb-grid'
#import * as ECS from '@fritzy/ecs'

app = new PIXI.Application({ transparent: true, antialias: true })
document.body.appendChild(app.view)

# width and height in hexes
width = 10
height = 10

Hex = Honeycomb.extendHex({
    size: 40
    offset: 1
})
Grid = Honeycomb.defineGrid(Hex)
grid = Grid.rectangle {width, height}

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

# assets are in /dist
rookSprite = do ->
    rookSprite = PIXI.Sprite.from 'assets/black_rook.png'
    rookSprite.anchor.x = 0
    rookSprite.anchor.y = 0
    hex = grid.get(34)
    tempHeight = hex.width()
    rookSprite.width /= rookSprite.height / tempHeight
    rookSprite.height = tempHeight
    point = hex.toPoint()
    rookSprite.position.x = point.x
    rookSprite.position.y = point.y
    app.stage.addChild rookSprite
    hex.piece = rookSprite
    rookSprite

class H
    constructor : (@color) ->
        @line = new PIXI.Graphics()
        @line.lineStyle 4, @color
    highlight : (hex) ->
        drawHex hex, @line
        app.stage.addChild @line
    unlight : ->
        @line.clear()
        @setup()
    setup : ->
        @line.lineStyle 4, @color

blueHighlight = new H 0x0000ff
yellowHighlight = new H 0xffff00

getHexCoordinates = (offsets) ->
    {offsetX, offsetY} = offsets
    Grid.pointToHex(offsetX, offsetY)

clickCoordinates = {}
mousedown = false
highlightRange = (hex) ->
    for hex in grid.hexesInRange hex, 3, false
        yellowHighlight.highlight hex

# highlight the hex specified by
# cube coordinates
#lightCube = (q, r, s) ->
#    yellowHighlight.highlight(
#        grid.get Hex().cubeToCartesian {q, r, s})

lightCartesian = (x, y) ->
    hex = grid.get {x, y}
    if hex?
        yellowHighlight.highlight(hex)

# create a list of lists
# each sublist is a diagonal going left and down
leftDowns = for i in [0...width]
    {x, y} = hex = grid.get(i)
    # a single diagonal line of hexes
    diag = []
    while hex?
        diag.push hex
        y++
        hex = grid.get({x, y})
        diag.push hex
        x--
        y++
        hex = grid.get({x, y})
    diag

rightDowns = for i in [0..width]
    {x, y} = hex = grid.get(i)
    # a single diagonal line of hexes
    diag = []
    while hex?
        diag.push hex
        x++
        y++
        hex = grid.get {x, y}
        diag.push hex
        y++
        hex = grid.get {x, y}
    diag

console.log rightDowns
highlightStraight = (hex) ->
    {x, y} = hex
    # y coordinate of topmost hex
    # or x coordinate of leftmost hex
    a = -1
    # x coordinate of bottomost hex
    # or y coordinate of rightmost hex
    b = 9
   
    {q, s} = Hex().cartesianToCube hex
    # go down and to left
    console.log s
    console.log x, y
    for hex in leftDowns[Math.abs(s)]
        yellowHighlight.highlight hex
    for hex in rightDowns[q]
        yellowHighlight.highlight hex
    for i in [a..b]
        lightCartesian(i, y)
        
    
select = (hex) ->
    if hex?.piece
        blueHighlight.unlight()
        blueHighlight.highlight hex
        #highlightRange hex
        highlightStraight hex

document.addEventListener 'mousedown', (offsets) ->
    mousedown = true
    clickCoordinates = getHexCoordinates offsets
    #console.log Hex().cartesianToCube clickCoordinates
    #blueHighlight.highlight clickCoordinates
    select grid.get(clickCoordinates)

#document.addEventListener 'mousemove', (event) ->
#    if mousedown
#        {x, y} = destCoordinates = getHexCoordinates event
#        # check if player dragged between hexes
#        if x != clickCoordinates.x or y != clickCoordinates.y
#            console.log 'dragging'
#            blueHighlight.highlight destCoordinates
#            # source cube coordinates
#            sC = Hex().cartesianToCube(x, y)
#            # destination cube coordinates
#            dC = Hex().cartesianToCube(clickCoordinates)
#            if sC.q == dC.q or sC.r == dC.r or sC.s == dC.s
#                console.log 'straight line drag'
#
#document.addEventListener 'mouseup', (event) ->
#    mousedown = false
#    console.log 'mouseup'
#    #blueHighlight.unlight()
