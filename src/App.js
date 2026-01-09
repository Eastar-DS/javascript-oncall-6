import { Console } from '@woowacourse/mission-utils';
import DateValidator from '../prac/validator/DateValidator.js';
import WorkerValidator from '../prac/validator/WorkerValidator.js';

class App {
  async run() {
    let month;
    let day;
    let dayWorkers;
    let weekWorkers;
    while (true) {
      // eslint-disable-next-line no-await-in-loop
      const input = await Console.readLineAsync('비상 근무를 배정할 월과 시작 요일을 입력하세요> ');
      const [monthString, dayString] = input.split(',');
      try {
        DateValidator.validateMonth(monthString);
        DateValidator.validateDay(dayString);
      } catch (error) {
        Console.print(error);
        // eslint-disable-next-line no-continue
        continue;
      }
      month = monthString;
      day = dayString;
      break;
    }

    while (true) {
      // eslint-disable-next-line no-await-in-loop
      const dayWorkersString = await Console.readLineAsync(
        '평일 비상 근무 순번대로 사원 닉네임을 입력하세요> '
      );
      const dayWorkersArray = dayWorkersString.split(',').map((worker) => worker.trim());
      try {
        WorkerValidator.validateDuplicateWorker(dayWorkersArray);
        WorkerValidator.validateWorkersNameLength(dayWorkersArray);
        WorkerValidator.validateWorkersNumbers(dayWorkersArray);
      } catch (error) {
        Console.print(error);
        // eslint-disable-next-line no-continue
        continue;
      }

      // eslint-disable-next-line no-await-in-loop
      const weekWorkersString = await Console.readLineAsync(
        '휴일 비상 근무 순번대로 사원 닉네임을 입력하세요> '
      );
      const weekWorkersArray = weekWorkersString.split(',').map((worker) => worker.trim());
      try {
        WorkerValidator.validateDuplicateWorker(weekWorkersArray);
        WorkerValidator.validateWorkersNameLength(weekWorkersArray);
        WorkerValidator.validateWorkersNumbers(weekWorkersArray);
        WorkerValidator.validateSameWorkers(dayWorkersArray, weekWorkersArray);
      } catch (error) {
        Console.print(error);
        // eslint-disable-next-line no-continue
        continue;
      }
      dayWorkers = dayWorkersArray;
      weekWorkers = weekWorkersArray;
      break;
    }

    const monthAndDays = {
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

    const holiday = ['1-1', '3-1', '5-5', '6-6', '8-15', '10-3', '10-9', '12-25'];

    const allDays = ['일', '월', '화', '수', '목', '금', '토'];
    let index = allDays.indexOf(day);

    // const workDays = ['월', '화', '수', '목', '금'];

    const weekDays = ['일', '토'];

    // let beforeDay = '평일';
    let beforeWorker = '';

    // if (weekDays.includes(day)) {
    //   beforeDay = '휴무';
    // } else if (holiday.includes(`${month}-${1}`)) {
    //   beforeDay = '휴무';
    // }

    for (let i = 0; i < monthAndDays[month]; i++) {
      if (weekDays.includes(allDays[index])) {
        if (beforeWorker === weekWorkers[0]) {
          const [first, second] = weekWorkers;
          weekWorkers = [second, first, ...weekWorkers.slice(2)];
        }
        Console.print(`${month}월 ${i + 1}일 ${allDays[index]} ${weekWorkers[0]}`);
        [beforeWorker] = weekWorkers;
        const workerName = weekWorkers.shift();
        weekWorkers.push(workerName);

        index = (index + 1) % 7;
      } else if (holiday.includes(`${month}-${i + 1}`)) {
        if (beforeWorker === weekWorkers[0]) {
          const [first, second] = weekWorkers;
          weekWorkers = [second, first, ...weekWorkers.slice(2)];
        }
        Console.print(`${month}월 ${i + 1}일 ${allDays[index]}(휴일) ${weekWorkers[0]}`);
        [beforeWorker] = weekWorkers;
        const workerName = weekWorkers.shift();
        weekWorkers.push(workerName);

        index = (index + 1) % 7;
      } else {
        if (beforeWorker === dayWorkers[0]) {
          const [first, second] = dayWorkers;
          dayWorkers = [second, first, ...dayWorkers.slice(2)];
        }
        Console.print(`${month}월 ${i + 1}일 ${allDays[index]} ${dayWorkers[0]}`);
        [beforeWorker] = dayWorkers;
        const workerName = dayWorkers.shift();
        dayWorkers.push(workerName);

        index = (index + 1) % 7;
      }
    }
  }
}

export default App;
