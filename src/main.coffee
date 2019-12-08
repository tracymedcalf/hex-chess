import * as PIXI from 'pixi.js'
import * as Honeycomb from 'honeycomb-grid'
#import * as ECS from '@fritzy/ecs'

app = new PIXI.Application({ transparent: true, antialias: true })

# width and height in hexes
width = 10
height = 10

Hex = Honeycomb.extendHex({ size: 40 })
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
    hex = grid.get(24)
    tempHeight = hex.width()
    rookSprite.width /= rookSprite.height / tempHeight
    rookSprite.height = tempHeight
    rookSprite.position.x = rookSprite.width * hex.x
    rookSprite.position.y = rookSprite.height * hex.y
    app.stage.addChild rookSprite
    hex.piece = rookSprite
    rookSprite

class H
    constructor : (@color) ->
        @line = new PIXI.Graphics()
        @line.lineStyle 4, @color
    highlight : (coordinates) ->
        drawHex grid.get(coordinates), @line
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

lightCube = (x, y) ->
    yellowHighlight.highlight(
        grid.get x, y)

#o = Hex().cartesianToCube({x: width-1, y: height-1})
#a = o.q
#b = o.r
#c = o.s
#console.log o
highlightStraight = (hex) ->
    {q, r, s} = Hex().cartesianToCube(hex)
    a = -1 # x coordinate of leftmost hex
    # or y coordinate of topmost hex
    b = 9 # y coordinate of rightmost hex or
    # x coordinate of bottomost hex
    `
    //for (var i=0,j=10; i<10 && j>0; i++, j--) {
    //    lightCube(q, i, j)
    //}
    //for (var i=0,j=10; i<10 && j>0; i++, j--) {
    //    lightCube(i, r, j)
    //}
    //for (var i=-a,j=b; i<10 && j>0; i++, j--) {
    //    lightCube(i, j, s)
    //}
    // go down diagonally to the left
    for (var i=a,j=10; j <= b; i--, j++) {
        lightCube(i, j);
        j++;
        lightCube(i, j);
    }
    // go down diagonally to the right
    for (var i=a,j=a; j<b; i++, j++) {
        lightCube(i, j);
        j++;
        lightCube(i, j);
    }
    `
    for i in [0..10]
        lightCube(i, j)
    #for i in [0..b]
    #    lightCube q, i, i
    #for i in [0..c]
    #    lightCube i, r, i
        
    
select = (hex) ->
    if hex?.piece
        blueHighlight.unlight()
        blueHighlight.highlight hex
        #highlightRange hex
        highlightStraight hex

document.addEventListener 'mousedown', (offsets) ->
    mousedown = true
    clickCoordinates = getHexCoordinates offsets
    console.log clickCoordinates
    #console.log Hex().cartesianToCube clickCoordinates
    #blueHighlight.highlight clickCoordinates
    select grid.get(clickCoordinates)

document.addEventListener 'mousemove', (event) ->
    if mousedown
        {x, y} = destCoordinates = getHexCoordinates event
        # check if player dragged between hexes
        if x != clickCoordinates.x or y != clickCoordinates.y
            console.log 'dragging'
            blueHighlight.highlight destCoordinates
            # source cube coordinates
            sC = Hex().cartesianToCube(x, y)
            # destination cube coordinates
            dC = Hex().cartesianToCube(clickCoordinates)
            if sC.q == dC.q or sC.r == dC.r or sC.s == dC.s
                console.log 'straight line drag'

document.addEventListener 'mouseup', (event) ->
    mousedown = false
    console.log 'mouseup'
    #blueHighlight.unlight()
