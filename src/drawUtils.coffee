export drawHex = (hex, graphics) ->
    point = hex.toPoint()
    corners = hex.corners().map (corner) -> corner.add point
    [firstCorner, otherCorners...] = corners
    graphics.moveTo firstCorner.x, firstCorner.y
    for { x, y } in otherCorners
        graphics.lineTo x, y
    graphics.lineTo firstCorner.x, firstCorner.y
