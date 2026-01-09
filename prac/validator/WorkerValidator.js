import ErrorMessage from '../constants.js';

class WorkerValidator {
  static validateDuplicateWorker(workersArray) {
    const workersSet = new Set(workersArray);
    if (workersArray.length !== workersSet.size) {
      throw Error(ErrorMessage.INPUT_ERROR);
    }
  }

  static validateWorkersNameLength(workersArray) {
    if (workersArray.some((worker) => worker.length > 5)) {
      throw Error(ErrorMessage.INPUT_ERROR);
    }
  }

  static validateWorkersNumbers(workersArray) {
    if (workersArray.length < 5 || workersArray.length > 35) {
      throw Error(ErrorMessage.INPUT_ERROR);
    }
  }

  static validateSameWorkers(dayWorkersArray, weekWorkersArray) {
    dayWorkersArray.forEach((worker) => {
      if (!weekWorkersArray.includes(worker)) {
        throw Error(ErrorMessage.INPUT_ERROR);
      }
    });
    weekWorkersArray.forEach((worker) => {
      if (!dayWorkersArray.includes(worker)) {
        throw Error(ErrorMessage.INPUT_ERROR);
      }
    });
  }
}

export default WorkerValidator;
