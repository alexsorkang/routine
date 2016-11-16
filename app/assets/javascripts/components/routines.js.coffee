@routinerow = React.createClass
  render: ->
    React.DOM.tr null,
      React.DOM.td null, @props.routines.name
      React.DOM.td null, @props.routines.difficulty

@allroutines = React.createClass
  getInitialState: ->
    routines: @props.data
  getDefaultState: ->
    routines: []
  render: ->
    React.DOM.div
      className: 'allroutines'
      React.DOM.table
        className: 'table'
        React.DOM.thead null,
          React.DOM.tr null,
            React.DOM.th null, 'title'
            React.DOM.th null, 'difficulty'
        React.DOM.tbody null,
          for f in @state.routines
            React.createElement routinerow, key: f.id, routines:f
