import main from './main.coffee';
//import * as Honeycomb from 'honeycomb-grid';
//
//const Hex = Honeycomb.extendHex({ size: 50 })
//const Grid = Honeycomb.defineGrid(Hex)
//
//var c = document.createElement('CANVAS');
//c.width = 1000;
//c.height = 1000;
//document.body.appendChild(c);
//var graphics = c.getContext('2d');
//c.font = '10px Arial';
//graphics.beginPath()
//
//// render 10,000 hexes
//Grid.rectangle({ width: 10, height: 10 }).forEach(hex => {
//    const point = hex.toPoint()
//    // add the hex's position to each of its corner points
//    const corners = hex.corners().map(corner => corner.add(point))
//    // separate the first from the other corners
//    const [firstCorner, ...otherCorners] = corners
//    // move the "pen" to the first corner
//    var hexCoor = Hex().cartesianToCube(hex)
//    var {q, r, s} = hexCoor;
//    graphics.strokeText(`${q}, ${r}, ${s}`,
//        point.x, point.y);
//    graphics.moveTo(firstCorner.x, firstCorner.y)
//    // draw lines to the other corners
//    otherCorners.forEach(({ x, y }) => graphics.lineTo(x, y))
//    // finish at the first corner
//    graphics.lineTo(firstCorner.x, firstCorner.y)
//
//})
//graphics.stroke()
