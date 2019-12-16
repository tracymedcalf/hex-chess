export class RadioButtons extends React.Component
    constructor : (props) ->
        super props
        @state = { selectedOption: 'off'}

    render : ->
        `<div>
            <input type="radio" value="off" checked={true}/> Off
            <input type="radio" value="cartesian"/> Cartesian
            <input type="radio" value="cube"/> Cube
        </div>`
