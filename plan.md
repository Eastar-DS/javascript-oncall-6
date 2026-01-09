# 개발자 비상근무 자동 배정 시스템 구현 계획

## 📌 프로젝트 이해

### 목적
배달 주문 서비스의 서버 장애 대응을 위한 **월별 비상근무표 자동 생성 프로그램**

### 핵심 개념
- **평일 순번**과 **휴일 순번**을 분리하여 관리
- **연속 2일 근무 방지**: 같은 사람이 연속으로 근무하면 다음 근무자와 순서 교체
- **법정공휴일 처리**: 평일이지만 법정공휴일은 휴일 순번 사용 + "(휴일)" 표기

---

## 🎯 입출력 명세

### 입력
1. **월과 시작 요일**: `5,월` (쉼표로 구분)
2. **평일 비상 근무 순번**: `준팍,도밥,고니,수아,루루,글로,솔로스타,우코,슬링키,참새,도리`
3. **휴일 비상 근무 순번**: `수아,루루,글로,솔로스타,우코,슬링키,참새,도리,준팍,도밥,고니`

### 출력
```
5월 1일 월 준팍
5월 2일 화 도밥
5월 3일 수 고니
5월 4일 목 수아
5월 5일 금(휴일) 루루
5월 6일 토 수아
...
```

### 에러 처리
- 월/요일 입력 오류 → "비상 근무를 배정할 월과 시작 요일"부터 재입력
- 평일/휴일 순번 오류 → "평일 비상 근무 순번"부터 재입력
- 에러 메시지: `[ERROR] 유효하지 않은 입력 값입니다. 다시 입력해 주세요.`

---

## 📋 법정공휴일 목록

```javascript
{
  1: [1],      // 1월 1일: 신정
  3: [1],      // 3월 1일: 삼일절
  5: [5],      // 5월 5일: 어린이날
  6: [6],      // 6월 6일: 현충일
  8: [15],     // 8월 15일: 광복절
  10: [3, 9],  // 10월 3일: 개천절, 10월 9일: 한글날
  12: [25]     // 12월 25일: 성탄절
}
```

---

## 🔍 비상 근무 배정 규칙 상세 분석

### 규칙 1: 기본 배정
- 평일(월~금) → 평일 순번 사용
- 휴일(토,일) → 휴일 순번 사용
- 법정공휴일(평일이지만) → 휴일 순번 사용 + "(휴일)" 표기

### 규칙 2: 연속 근무 방지 (핵심!) ⚠️

**중요한 개념: 교체는 "순번 인덱스 진행"에 영향을 주지 않습니다!**
- 교체는 해당 날짜의 근무자만 바꾸는 것
- 순번 인덱스는 계속 증가하며, 교체된 근무자는 나중에 다시 나옴

#### README 예시 분석 (5월, 월요일 시작)
```
평일 순번: 준팍,도밥,고니,수아,루루,글로,솔로스타,우코,슬링키,참새,도리
휴일 순번: 수아,루루,글로,솔로스타,우코,슬링키,참새,도리,준팍,도밥,고니

5월 1일 월: 준팍 (평일idx=0)
5월 2일 화: 도밥 (평일idx=1)
5월 3일 수: 고니 (평일idx=2)
5월 4일 목: 수아 (평일idx=3)
5월 5일 금(휴일): 루루 (휴일idx=0 → 수아인데 연속! → 휴일idx=1인 루루와 교체)
5월 6일 토: 수아 (휴일idx=0, 교체로 여기로 밀림)
5월 7일 일: 글로 (휴일idx=2)
5월 8일 월: 루루 (평일idx=4, 어제는 글로이므로 연속 아님)
...
```

#### 핵심 알고리즘
```
현재_근무자 = 해당_순번[인덱스++]

if (현재_근무자 == 어제_근무자) {
  다음_근무자 = 해당_순번[인덱스++]  // 인덱스 하나 더 증가!

  오늘_배정(다음_근무자)
  내일_배정(현재_근무자)  // 다음 날짜로 미루기
} else {
  오늘_배정(현재_근무자)
}
```

#### 중요: "앞의 날짜부터 순서 변경"
- 연속 근무가 감지되면 즉시 교체
- 교체된 근무자는 다음 날로 미뤄짐
- 다음 날도 연속이면 다시 교체 (재귀적)

---

## 🏗️ 구현 아키텍처

### 디렉토리 구조 (실용적 최소 설계)
```
src/
├── App.js                    # 메인 애플리케이션 (진입점)
├── constants.js              # 상수 (공휴일, 월별일수, 에러메시지)
├── validators/
│   ├── InputValidator.js     # 모든 입력 검증 통합
├── models/
│   ├── OncallSchedule.js     # 근무표 생성 핵심 로직
│   └── WorkerRotation.js     # 순번 관리 (평일/휴일)
└── utils/
    └── DateHelper.js         # 날짜 계산 유틸리티
```

### 클래스 책임 분리

#### constants.js
- 월별 일수, 요일 배열
- 법정공휴일 맵
- 에러 메시지, 입력 프롬프트

#### InputValidator.js
- 월/요일 검증 (정적 메서드)
- 닉네임 목록 검증 (중복, 길이, 인원수)

#### DateHelper.js
- 요일 계산 (시작 요일 + 날짜 → 현재 요일)
- 평일/휴일 판별
- 법정공휴일 체크

#### WorkerRotation.js
- 평일 순번, 휴일 순번 저장
- 다음 근무자 반환 (인덱스 관리)
- 순번 인덱스 순환 (% 연산)

#### OncallSchedule.js (핵심)
- 전체 월 근무표 생성
- 연속 근무 감지 및 교체 로직
- 날짜별 근무자 배정

#### App.js
- Console 입출력
- 에러 처리 및 재입력 루프
- 출력 포맷팅

---

## ✅ 구현 단계별 계획

### Phase 1: 기본 설정 및 유틸리티
1. [ ] **constants.js 작성**
   - 월별 일수 맵
   - 요일 배열
   - 법정공휴일 맵
   - 에러 메시지 상수
   - 입력 프롬프트 상수

2. [ ] **DateHelper.js 작성**
   - `getDayOfWeek(month, startDay, date)`: 날짜로 요일 계산
   - `isWeekend(dayOfWeek)`: 토/일 판별
   - `isHoliday(month, date, dayOfWeek)`: 법정공휴일 판별
   - `isWorkday(dayOfWeek)`: 평일 판별 (월~금, 단 공휴일 제외)

### Phase 2: 입력 검증
3. [ ] **InputValidator.js 작성**
   - `validateMonthAndDay(input)`: "5,월" 형식 검증
   - `validateWorkers(input)`: 닉네임 목록 검증
     - 쉼표 구분 파싱
     - 닉네임 1~5자 검증
     - 중복 체크
     - 인원 5~35명 검증
   - `validateWorkerMatch(weekday, weekend)`: 두 목록 인원 일치 검증

### Phase 3: 순번 관리 모델
4. [ ] **WorkerRotation.js 작성**
   - 생성자: `constructor(weekdayWorkers, holidayWorkers)`
   - `getNextWeekdayWorker()`: 평일 순번 다음 근무자
   - `getNextHolidayWorker()`: 휴일 순번 다음 근무자
   - 내부 인덱스 관리 (순환)

### Phase 4: 근무표 생성 핵심 로직
5. [ ] **OncallSchedule.js 작성**
   - 생성자: `constructor(month, startDay, rotation)`
   - `generate()`: 전체 월 근무표 생성
   - `assignWorkerForDate(date, dayOfWeek)`: 날짜별 근무자 배정
   - 연속 근무 감지 및 교체 로직
   - `getSchedule()`: 생성된 근무표 반환

### Phase 5: 메인 애플리케이션
6. [ ] **App.js 작성**
   - `run()`: 메인 실행 메서드
   - 입력 받기 (try-catch로 에러 처리)
   - 검증 실패 시 재입력 루프
   - 근무표 생성 및 출력
   - 출력 포맷: `5월 1일 월 준팍` / `5월 5일 금(휴일) 루루`

### Phase 6: 테스트 및 검증
7. [ ] **단위 테스트 작성**
   - DateHelper 테스트
   - InputValidator 테스트
   - WorkerRotation 테스트
   - OncallSchedule 테스트 (핵심!)

8. [ ] **통합 테스트**
   - `npm test` 실행
   - ApplicationTest.js 통과 확인
   - 예외 케이스 확인

### Phase 7: 문서 작성
9. [ ] **docs/README.md 작성**
   - 구현한 기능 목록
   - 기능별 커밋 단위

10. [ ] **docs/how-to-solve.md 작성**
    - 필수: 순서 교체 예시 설명
    - 선택: 다른 방법과 비교

---

## 🚨 주의사항 체크리스트

### 프로그래밍 요구사항
- [ ] Node.js 18.17.1 환경 확인
- [ ] 외부 라이브러리 사용 금지 (Vanilla JS만)
- [ ] @woowacourse/mission-utils의 Console API만 사용
- [ ] indent depth 2 이하
- [ ] 함수 길이 15라인 이하
- [ ] else 지양
- [ ] process.exit() 사용 금지
- [ ] 파일/패키지 이름 수정 금지

### 테스트 요구사항
- [ ] ApplicationTest.js 모든 테스트 통과
- [ ] 도메인 로직 단위 테스트 작성
- [ ] UI 로직 테스트 제외

### 출력 형식 요구사항
- [ ] `5월 1일 월 준팍` 형식 정확히 준수
- [ ] 법정공휴일: `5월 5일 금(휴일) 루루` 형식
- [ ] 에러: `[ERROR] 유효하지 않은 입력 값입니다. 다시 입력해 주세요.`

---

## 🧪 테스트 케이스 분석

### ApplicationTest.js 분석

#### 예외 테스트
- 입력: `"0,일"` → 잘못된 월 입력
- 재입력: 정상 입력
- 기대: `[ERROR]` 출력 + 정상 근무표 생성

#### 기능 테스트
- 4월, 토요일 시작
- 35명의 근무자 (최대 인원)
- 예상 출력:
  - 4월 1일(토): 휴일 순번 첫 번째 (오션)
  - 4월 2일(일): 휴일 순번 두 번째 (로이스)
  - 4월 3일(월): 평일 순번 첫 번째 (허브)
  - ...

---

## 💡 구현 시 핵심 고려사항

### 1. 연속 근무 방지 알고리즘 (가장 중요!)
```javascript
// 핵심 의사코드
generate() {
  let previousWorker = null;

  for (date = 1 to monthDays) {
    const dayOfWeek = this.getDayOfWeek(date);
    const isHoliday = this.isHoliday(date, dayOfWeek);

    // 평일인지 휴일인지에 따라 순번 선택
    let currentWorker = isHoliday
      ? this.rotation.getNextHolidayWorker()
      : this.rotation.getNextWeekdayWorker();

    // 연속 근무 체크
    if (currentWorker === previousWorker) {
      // 다음 근무자를 미리 가져옴 (인덱스 증가!)
      const nextWorker = isHoliday
        ? this.rotation.getNextHolidayWorker()
        : this.rotation.getNextWeekdayWorker();

      // 교체: 오늘은 다음 근무자, 내일은 현재 근무자
      this.schedule[date] = nextWorker;
      previousWorker = nextWorker;

      // 현재 근무자는 다음 날로 "미뤄짐" (인덱스는 이미 증가했으므로 처리 완료)
    } else {
      this.schedule[date] = currentWorker;
      previousWorker = currentWorker;
    }
  }
}
```

### 2. WorkerRotation 인덱스 관리
```javascript
class WorkerRotation {
  constructor(weekdayWorkers, holidayWorkers) {
    this.weekdayWorkers = weekdayWorkers;
    this.holidayWorkers = holidayWorkers;
    this.weekdayIndex = 0;
    this.holidayIndex = 0;
  }

  getNextWeekdayWorker() {
    const worker = this.weekdayWorkers[this.weekdayIndex];
    this.weekdayIndex = (this.weekdayIndex + 1) % this.weekdayWorkers.length;
    return worker;
  }

  getNextHolidayWorker() {
    const worker = this.holidayWorkers[this.holidayIndex];
    this.holidayIndex = (this.holidayIndex + 1) % this.holidayWorkers.length;
    return worker;
  }
}
```

### 3. 법정공휴일 처리
```javascript
const HOLIDAYS = {
  1: [1],      // 신정
  3: [1],      // 삼일절
  5: [5],      // 어린이날
  6: [6],      // 현충일
  8: [15],     // 광복절
  10: [3, 9],  // 개천절, 한글날
  12: [25]     // 성탄절
};

isHoliday(month, date, dayOfWeek) {
  // 토요일, 일요일
  if (dayOfWeek === '토' || dayOfWeek === '일') return true;

  // 법정공휴일
  if (HOLIDAYS[month] && HOLIDAYS[month].includes(date)) return true;

  return false;
}
```

### 4. 출력 포맷 주의사항
```javascript
// 평일이면서 법정공휴일인 경우만 (휴일) 표기
const formatOutput = (month, date, dayOfWeek, worker, isHoliday) => {
  const isWeekday = !['토', '일'].includes(dayOfWeek);
  const isLegalHoliday = HOLIDAYS[month]?.includes(date);

  // 평일 + 법정공휴일 = (휴일) 표기
  const holidayMark = (isWeekday && isLegalHoliday) ? '(휴일)' : '';

  return `${month}월 ${date}일 ${dayOfWeek}${holidayMark} ${worker}`;
};
```

### 5. 에러 처리 전략
```javascript
async run() {
  // 월/요일 입력 루프
  let monthData;
  while (true) {
    try {
      const input = await Console.readLineAsync(PROMPTS.MONTH_AND_DAY);
      monthData = InputValidator.validateMonthAndDay(input);
      break;
    } catch (error) {
      Console.print(error.message);
    }
  }

  // 근무자 입력 루프
  let weekdayWorkers, holidayWorkers;
  while (true) {
    try {
      const weekdayInput = await Console.readLineAsync(PROMPTS.WEEKDAY_WORKERS);
      weekdayWorkers = InputValidator.validateWorkers(weekdayInput);

      const holidayInput = await Console.readLineAsync(PROMPTS.HOLIDAY_WORKERS);
      holidayWorkers = InputValidator.validateWorkers(holidayInput);

      InputValidator.validateWorkerMatch(weekdayWorkers, holidayWorkers);
      break;
    } catch (error) {
      Console.print(error.message);
      // 평일 순번부터 다시!
    }
  }
}

---

## 📝 커밋 전략

기능 단위로 세밀하게 커밋 (우아한테크코스 요구사항):
1. `docs: 기능 목록 작성`
2. `feat: 상수 정의 (공휴일, 월별 일수, 에러 메시지)`
3. `feat: 날짜 계산 유틸리티 구현`
4. `feat: 입력 검증 기능 구현`
5. `feat: 근무자 순번 관리 클래스 구현`
6. `feat: 근무표 생성 핵심 로직 구현`
7. `feat: 연속 근무 방지 로직 구현`
8. `feat: 메인 애플리케이션 입출력 구현`
9. `test: DateHelper 단위 테스트 추가`
10. `test: InputValidator 단위 테스트 추가`
11. `test: OncallSchedule 단위 테스트 추가`
12. `docs: 미션 해결 전략 문서 작성`

---

## 🎓 학습 포인트

1. **도메인 로직 분리**: UI와 핵심 로직의 명확한 분리
2. **입력 검증**: 다양한 예외 상황 처리
3. **알고리즘**: 순번 관리 및 교체 로직
4. **테스트**: Jest를 활용한 단위 테스트
5. **클린 코드**: indent depth, 함수 길이, else 지양

---

## ✅ 요구사항 최종 체크리스트

### 기능 요구사항
- [ ] 월과 시작 요일 입력 받기
- [ ] 평일 비상 근무 순번 입력 받기
- [ ] 휴일 비상 근무 순번 입력 받기
- [ ] 기본 순번에 따라 근무일 배정
- [ ] 평일/휴일 구분하여 순번 적용
- [ ] 법정공휴일 처리 (평일이지만 휴일 순번 사용)
- [ ] 연속 2일 근무 방지 (다음 근무자와 교체)
- [ ] 앞의 날짜부터 순서 변경
- [ ] 평일 법정공휴일에만 "(휴일)" 표기
- [ ] 잘못된 입력 시 [ERROR] 출력 후 재입력
- [ ] 월/요일 오류 시 월/요일부터 재입력
- [ ] 평일/휴일 순번 오류 시 평일 순번부터 재입력

### 프로그래밍 요구사항
- [ ] Node.js 18.17.1 환경
- [ ] 외부 라이브러리 사용 안 함 (Vanilla JS)
- [ ] @woowacourse/mission-utils의 Console API만 사용
- [ ] package.json 변경 안 함
- [ ] indent depth 2 이하
- [ ] 함수 길이 15라인 이하
- [ ] else 지양
- [ ] process.exit() 사용 안 함
- [ ] 파일/패키지 이름 수정 안 함
- [ ] 도메인 로직 단위 테스트 작성
- [ ] UI 로직과 핵심 로직 분리
- [ ] throw로 예외 발생

### 테스트 요구사항
- [ ] ApplicationTest.js 모든 테스트 통과
- [ ] 예외 테스트 통과
- [ ] 기능 테스트 통과

### 과제 진행 요구사항
- [ ] docs/README.md에 기능 목록 작성
- [ ] 기능 목록 단위로 커밋
- [ ] docs/how-to-solve.md 필수 문항 작성

---

## ✨ 예상 난이도 및 구현 시간

- **난이도**: 중상
  - 알고리즘: 연속 근무 방지 로직이 핵심
  - 요구사항: 많고 세밀함 (0점 위험 높음)
  - 코드 제약: indent, 함수 길이, else 지양

- **핵심 난관**
  1. 연속 근무 방지 로직 (교체 알고리즘 이해)
  2. 출력 포맷 정확성 (공백, 괄호 위치)
  3. 에러 처리 흐름 (어디부터 재입력?)

- **예상 시간**: 4-6시간
  - 구조 설계: 30분
  - 구현: 3-4시간
  - 테스트 및 디버깅: 1-1.5시간
  - 문서 작성: 30분

---

## 🚀 다음 단계

1. **먼저 docs/README.md에 기능 목록 작성** (필수!)
2. constants.js 구현 시작
3. 순차적으로 Phase별 구현
4. 각 Phase마다 커밋
5. 테스트 확인 후 문서 작성
