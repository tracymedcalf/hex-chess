`import * as PIXI from 'pixi.js';`
`import * as Honeycomb from 'honeycomb-grid';`

app = new PIXI.Application({ transparent: true, antialias: true })

width = 50
height = 50

Hex = Honeycomb.extendHex({ size: 20 })
Grid = Honeycomb.defineGrid(Hex)
grid = Grid.rectangle {width, height}

document.body.appendChild(app.view)

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
    for hex in Grid.rectangle({width, height})
        drawHex hex, graphics
    app.stage.addChild graphics

draw()

# assets are in /dist
rookSprite = do ->
    rookSprite = PIXI.Sprite.from 'assets/black_rook.png'
    rookSprite.anchor.x = 0
    rookSprite.anchor.y = 0
    rookSprite.position.x = 100
    rookSprite.position.y = 100
    tempHeight = 50
    rookSprite.width /= rookSprite.height / tempHeight
    rookSprite.height = tempHeight
    app.stage.addChild rookSprite
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
document.addEventListener 'mousedown', (offsets) ->
    mousedown = true
    console.log 'clicked!'
    clickCoordinates = getHexCoordinates offsets
    blueHighlight.highlight clickCoordinates

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
    blueHighlight.unlight()
