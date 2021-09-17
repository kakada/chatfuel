// Run this example by adding <%= javascript_pack_tag 'hello_react' %> to the head of your layout file,
// like app/views/layouts/application.html.erb. All it does is render <div>Hello React</div> at the bottom
// of the page.

import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'
import 'react-dates/initialize';
import { DateRangePicker } from 'react-dates';

const Hello = () => (
  <div>Hello {props.name}!</div>
)

class App extends React.Component {
  state = {
    startDate: moment(this.props.startDate),
    endDate: moment(this.props.endDate),
    focusedInput: null
  }

  render() {
    console.log(this.props)

    return (
    <DateRangePicker 
      startDate={this.state.startDate} // momentPropTypes.momentObj or null,
      startDateId="your_unique_start_date_id" // PropTypes.string.isRequired,
      endDate={this.state.endDate} // momentPropTypes.momentObj or null,
      endDateId="your_unique_end_date_id" // PropTypes.string.isRequired,
      onDatesChange={({ startDate, endDate }) => this.setState({ startDate, endDate })} // PropTypes.func.isRequired,
      focusedInput={this.state.focusedInput} // PropTypes.oneOf([START_DATE, END_DATE]) or null,
      noBorder={true}
      block={true}
      small={true}
      onFocusChange={focusedInput => this.setState({ focusedInput })}/>
    )
  }
}

Hello.defaultProps = {
  name: 'David'
}

Hello.propTypes = {
  name: PropTypes.string
}


document.addEventListener('DOMContentLoaded', () => {
  // console.log ( $(".start_date").val() )
  ReactDOM.render(
    <App 
      startDate={$(".start_date").val()}
      endDate={$(".end_date").val()} />,
    document.getElementById("react-dates"),
  )
})
