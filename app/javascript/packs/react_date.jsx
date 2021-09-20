import React from 'react'
import ReactDOM from 'react-dom'
import 'react-dates/initialize';
import { DateRangePicker } from 'react-dates';
import moment from 'moment';
import km from 'moment/locale/km';
import en from 'moment/locale/en-gb';

let currentLocale = $("#q_locale").val()
moment.locale(currentLocale)

class ReactDate extends React.Component {
  state = {
    startDate: moment(this.props.startDate),
    endDate: moment(this.props.endDate),
    focusedInput: null
  }

  render() {
    return (
    <DateRangePicker 
      startDate={this.state.startDate}
      startDateId="startDate"
      endDate={this.state.endDate}
      endDateId="endDate"
      isOutsideRange={() => null}
      displayFormat= "DD/MM/YYYY"
      onDatesChange={({ startDate, endDate }) => {
        if(startDate != undefined) $(".start_date").val(startDate.format("Y/MM/D"))
        if(endDate != undefined) $(".end_date").val(endDate.format("Y/MM/D"))
        this.setState({ startDate, endDate })
      }}
      focusedInput={this.state.focusedInput}
      noBorder={true}
      block={true}
      small={true}
      onFocusChange={focusedInput => this.setState({ focusedInput })}/>
    )
  }
}

ReactDOM.render(
  <ReactDate 
    startDate={$(".start_date").val()}
    endDate={$(".end_date").val()} />,
  document.getElementById("react-dates"),
)
