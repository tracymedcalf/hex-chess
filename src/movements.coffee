import * as globals from './globals.coffee'
# create a list of lists
# each sublist is a diagonal going left and down
#leftDowns = for i in [0...window.width]
#    {x, y} = hex = grid.get(i)
#    # a single diagonal line of hexes
#    diag = []
#    while hex?
#        diag.push hex
#        y++
#        hex = grid.get({x, y})
#        diag.push hex
#        x--
#        y++
#        hex = grid.get({x, y})
#    diag

class A extends Array
    pushIfExists: (i, el) ->
        unless el?
            console.log 'woops!'
        if @[i]?
            @[i].push el
        else
            @[i] = [el]
    refine: (compareFunction = (hex1, hex2) ->
            hex1.r - hex2.r) ->
        for arr in @
            if arr?
                arr.sort compareFunction

leftDowns = new A()
rightDowns = new A()
horizontals = new A()

for hex in globals.grid
    {q, s} = hex
    leftDowns.pushIfExists (Math.abs s), hex
    rightDowns.pushIfExists q, hex
    horizontals.pushIfExists hex.y, hex

# order the hexes

leftDowns.refine()
rightDowns.refine()
horizontals.refine((hex1, hex2) ->
    hex1.x - hex2.x)
#rightDowns = for i in [0..window.width]
#    {x, y} = hex = grid.get(i)
#    # a single diagonal line of hexes
#    diag = []
#    while hex?
#        diag.push hex
#        x++
#        y++
#        hex = grid.get {x, y}
#        diag.push hex
#        y++
#        hex = grid.get {x, y}
#    diag

highlightRange = (hex) ->
    for hex in grid.hexesInRange hex, 3, false
        yellowHighlight.highlight hex

# get hexes in array until obstacle appears
gather = (source, target, j, k) ->
    for i in [j..k]
        hex = source[i]
        if hex.piece
            break
        target.push hex

# get the hexes that a straight moving
# (i.e. bishop, rook, queen)
# piece can reach
export class Straight
    # Return tiles this piece
    # can move to.
    # (Stopped by obstacles)
    tiles: (pHex) ->
        ret = []
        {x, y, q, s} = pHex
        leftDown = leftDowns[Math.abs s]
        gather leftDown, ret,
            leftDown.indexOf(pHex)+1, leftDown.length-1
        gather leftDown, ret,
            leftDown.indexOf(pHex)-1, 0
        
        rightDown = rightDowns[q]
        gather rightDown, ret,
            rightDown.indexOf(pHex)+1, rightDown.length-1,
        gather rightDown, ret,
            rightDown.indexOf(pHex)-1, 0
        
        horizontal = horizontals[y]
        gather horizontal, ret,
            horizontal.indexOf(pHex)+1, horizontal.length-1
        gather horizontal, ret,
            horizontal.indexOf(pHex)-1, 0
        #for i in [leftDown.indexOf(pHex)+1...leftDown.length]
        #    hex = leftDown[i]
        #    if hex.piece
        #        break
        #    ret.push hex
        #for i in [0...leftDown.indexOf(pHex)]
        #    hex = leftDown[i]
        #    if hex.piece
        #        break
        #    ret.push hex
        #for i in [rightDown.indexOf(pHex)+1...rightDown.length]
        #    hex = rightDown[i]
        #    if hex.piece
        #        break
        #    ret.push hex
        #for i in [0...rightDown.indexOf(pHex)]
        #    hex = rightDown[i]
        #    if hex.piece
        #        break
        #    ret.push hex
       # for i in [horizontal.indexOf(pHex)+1...horizontal.length]
       #     hex = horizontal[i]
       #     console.log hex
       #     if hex.piece
       #         break
       #     ret.push hex
       # for i in [horizontal.indexOf(pHex)-1..0]
       #     hex = horizontal[i]
       #     console.log hex
       #     if hex.piece
       #         break
       #     ret.push hex
        ret
