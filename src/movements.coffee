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

highlightRange = (hex) ->
    for hex in grid.hexesInRange hex, 3, false
        yellowHighlight.highlight hex
# get the hexes that a straight moving
# (i.e. bishop, rook, queen)
# piece can reach
export class Straight
    # return tiles this piece
    # can move to
    # Stopped by obstacles
    tiles: (hex) ->
        ret = []
        {x, y} = hex
        {q, s} = Hex().cartesianToCube hex
        leftDown = leftDowns[Math.abs s]
        for i in [leftDown.indexOf(hex)+1...leftDown.length]
            hex = leftDown[i]
            if hex.piece
                break
            ret.push hex
        for i in [0...leftDown.indexOf(hex)]
            hex = leftDown[i]
            if hex.piece
                break
            ret.push hex
        rightDown = rightDowns[q]
        for i in [rightDown.indexOf(hex)+1...rightDown.length]
            hex = rightDown[i]
            if hex.piece
                break
            ret.push hex
        for i in [0...rightDown.indexOf(hex)]
            hex = rightDown[i]
            if hex.piece
                break
            ret.push hex
        for i in [x+1..9]
            hex = grid.get {x: i, y}
            if hex.piece
                break
            ret.push hex
        for i in [x-1..0]
            hex = grid.get {x: i, y}
            if hex.piece
                break
            ret.push hex
        ret
