import React from "react"
import ReactDOM from "react-dom"
import "react-dates/initialize";
import { DateRangePicker } from "react-dates";
import moment from "moment";

const DEFAULT_DATE_FORMAT = "DD/MM/YYYY"

let currentLocale = $("#q_locale").val()
moment.locale(currentLocale)

class ReactDate extends React.Component {
  state = {
    startDate: moment(this.props.startDate, DEFAULT_DATE_FORMAT),
    endDate: moment(this.props.endDate, DEFAULT_DATE_FORMAT),
    focusedInput: null
  }

  handleDateChange = ({ startDate, endDate }) => {
    if(startDate != undefined) $(".start_date").val(startDate.clone().locale("en").format(DEFAULT_DATE_FORMAT))
    if(endDate   != undefined) $(".end_date").val(endDate.clone().locale("en").format(DEFAULT_DATE_FORMAT))
    this.setState({ startDate, endDate })
  }

  render() {
    return (
    <DateRangePicker 
      block={true}
      small={true}
      noBorder={true}
      endDateId="endDate"
      startDateId="startDate"
      startDate={this.state.startDate}
      endDate={this.state.endDate}
      isOutsideRange={() => null}
      displayFormat={DEFAULT_DATE_FORMAT}
      onDatesChange={this.handleDateChange}
      focusedInput={this.state.focusedInput}
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
