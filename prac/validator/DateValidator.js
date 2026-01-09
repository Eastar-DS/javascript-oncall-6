import ErrorMessage from '../constants.js';

class DateValidator {
  static validateMonth(monthString) {
    const month = Number(monthString);
    if (month < 1 || month > 12) {
      throw Error(ErrorMessage.INPUT_ERROR);
    }
  }

  static validateDay(dayString) {
    const days = ['일', '월', '화', '수', '목', '금', '토'];
    if (!days.includes(dayString)) {
      throw Error(ErrorMessage.INPUT_ERROR);
    }
  }
}

export default DateValidator;
