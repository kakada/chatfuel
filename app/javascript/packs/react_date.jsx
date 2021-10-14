import React from "react"
import ReactDOM from "react-dom"
import "react-dates/initialize";
import { DateRangePicker } from "react-dates";
import moment from "moment";

const DEFAULT_DATE_FORMAT = "DD/MM/YYYY"
const DATE_DISPLAY_FORMAT = "D MMM YYYY"

let currentLocale = $("#q_locale").val()
moment.locale(currentLocale)

class ReactDate extends React.Component {
  state = {
    startDate: moment(this.props.startDate, DEFAULT_DATE_FORMAT),
    endDate: moment(this.props.endDate, DEFAULT_DATE_FORMAT),
    focusedInput: null
  }

  handleDateChange = ({ startDate, endDate }) => {
    if(startDate != undefined) $(".start_date").val(this.plainDateFormat(startDate))
    if(endDate   != undefined) $(".end_date").val(this.plainDateFormat(endDate))
    this.setState({ startDate, endDate })
  }

  plainDateFormat(date) {
    return date.clone().locale("en").format(DEFAULT_DATE_FORMAT);
  }

  componentDidUpdate(prevProps, prevState) {
    if (prevState.endDate !== this.state.endDate) $("#q").submit()
  }

  render() {
    return (
    <DateRangePicker 
      block={true}
      small={true}
      noBorder={true}
      anchorDirection="right"
      endDateId="endDate"
      startDateId="startDate"
      startDate={this.state.startDate}
      endDate={this.state.endDate}
      isOutsideRange={() => null}
      displayFormat={DATE_DISPLAY_FORMAT}
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
