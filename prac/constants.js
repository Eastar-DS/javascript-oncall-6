export const DAYS_IN_MONTH = {
  1: 31,
  2: 28,
  3: 31,
  4: 30,
  5: 31,
  6: 30,
  7: 31,
  8: 31,
  9: 30,
  10: 31,
  11: 30,
  12: 31,
};

export const DAYS_OF_WEEK = ['일', '월', '화', '수', '목', '금', '토'];

export const HOLIDAYS = {
  1: [1],
  3: [1],
  5: [5],
  6: [6],
  8: [15],
  10: [3, 9],
  12: [25],
};

export const ERROR_MESSAGE = '[ERROR] 유효하지 않은 입력 값입니다. 다시 입력해 주세요.';

export const PROMPTS = {
  MONTH_AND_DAY: '비상 근무를 배정할 월과 시작 요일을 입력하세요> ',
  WEEKDAY_WORKERS: '평일 비상 근무 순번대로 사원 닉네임을 입력하세요> ',
  HOLIDAY_WORKERS: '휴일 비상 근무 순번대로 사원 닉네임을 입력하세요> ',
};

const ErrorMessage = {
  INPUT_ERROR: ERROR_MESSAGE,
};

export default ErrorMessage;
