import { DAYS_OF_WEEK, DAYS_IN_MONTH, HOLIDAYS } from '../constants.js';

class DateHelper {
  static getDayOfWeek(startDay, date) {
    const startIndex = DAYS_OF_WEEK.indexOf(startDay);
    return DAYS_OF_WEEK[(startIndex + date - 1) % 7];
  }

  static isWeekend(dayOfWeek) {
    return dayOfWeek === '토' || dayOfWeek === '일';
  }

  static isLegalHoliday(month, date) {
    return HOLIDAYS[month]?.includes(date) || false;
  }

  static isHoliday(month, date, dayOfWeek) {
    return this.isWeekend(dayOfWeek) || this.isLegalHoliday(month, date);
  }

  static getDaysInMonth(month) {
    return DAYS_IN_MONTH[month];
  }
}

export default DateHelper;
