module.exports = {
  env: {
    browser: true,
    es2021: true,
    node: true,
    jest: true,
  },
  extends: ['airbnb-base', 'plugin:prettier/recommended'],
  parserOptions: {
    ecmaVersion: 'latest',
    sourceType: 'module',
  },
  rules: {
    // Types & References (1.x, 2.x)
    'prefer-const': 'error', // 2.1, 2.2: 재할당하지 않는 변수는 const 사용
    'no-const-assign': 'error', // 2.3: const 재할당 금지
    'no-var': 'error', // 2.4: var 사용 금지

    // Objects (3.x)
    'no-new-object': 'error', // 3.1: Object 생성자 사용 금지
    'object-shorthand': ['error', 'always'], // 3.3, 3.4: 객체 메서드/프로퍼티 단축 구문
    'quote-props': ['error', 'as-needed'], // 3.6: 필요한 경우만 프로퍼티 따옴표
    'no-prototype-builtins': 'error', // 3.7: Object.prototype 메서드 직접 호출 금지
    'prefer-object-spread': 'error', // 3.8: Object.assign 대신 객체 스프레드

    // Arrays (4.x)
    'no-array-constructor': 'error', // 4.1: Array 생성자 사용 금지
    'array-callback-return': 'error', // 4.5: 배열 메서드 콜백에서 반환값 필요

    // Destructuring (5.x)
    'prefer-destructuring': [
      'error',
      {
        VariableDeclarator: {
          array: false,
          object: true,
        },
        AssignmentExpression: {
          array: true,
          object: false,
        },
      },
    ], // 5.1, 5.2: 구조분해 할당 사용

    // Strings (6.x)
    quotes: ['error', 'single', { avoidEscape: true }], // 6.1: 작은따옴표 사용
    'prefer-template': 'error', // 6.3: 문자열 연결 시 템플릿 리터럴 사용
    'template-curly-spacing': ['error', 'never'], // 6.4: 템플릿 문자열 중괄호 공백 제거
    'no-eval': 'error', // 6.5: eval() 사용 금지
    'no-useless-escape': 'error', // 6.6: 불필요한 이스케이프 금지

    // Functions (7.x)
    'func-style': ['error', 'declaration', { allowArrowFunctions: true }], // 7.1: 함수 선언문 사용
    'wrap-iife': ['error', 'inside'], // 7.2: IIFE는 괄호로 감싸기
    'no-loop-func': 'error', // 7.3: 반복문 내 함수 선언 금지
    'prefer-rest-params': 'error', // 7.5: arguments 대신 나머지 매개변수
    'default-param-last': 'error', // 7.6: 기본 매개변수를 마지막에 배치
    'no-new-func': 'error', // 7.9: Function 생성자 금지
    'space-before-function-paren': [
      'error',
      {
        anonymous: 'always',
        named: 'never',
        asyncArrow: 'always',
      },
    ], // 7.10: 함수 괄호 앞 공백
    'space-before-blocks': 'error', // 7.11: 블록 앞 공백
    'no-param-reassign': ['error', { props: false }], // 7.12: 매개변수 재할당 금지
    'prefer-spread': 'error', // 7.13: apply 대신 스프레드 사용
    'prefer-arrow-callback': 'error', // 7.14: 콜백 함수는 화살표 함수
    'arrow-spacing': ['error', { before: true, after: true }], // 7.15: 화살표 함수 공백
    'arrow-parens': ['error', 'always'], // 7.16: 화살표 함수 매개변수 괄호
    'arrow-body-style': ['error', 'as-needed'], // 7.17: 화살표 함수 본문 중괄호
    'no-confusing-arrow': ['error', { allowParens: true }], // 7.18: 혼란스러운 화살표 함수 금지
    'implicit-arrow-linebreak': ['error', 'beside'], // 7.19: 화살표 함수 줄바꿈

    // Classes & Constructors (9.x)
    'no-useless-constructor': 'error', // 9.4: 불필요한 생성자 금지
    'no-dupe-class-members': 'error', // 9.5: 중복 클래스 멤버 금지
    'class-methods-use-this': [
      'error',
      {
        exceptMethods: ['run', 'start'],
      },
    ], // 9.6: this를 사용하지 않는 클래스 메서드 금지 (Controller 진입점 예외)

    // Modules (10.x)
    'no-duplicate-imports': 'error', // 10.4: 중복 import 금지
    'import/no-mutable-exports': 'error', // 10.5: 변경 가능한 바인딩 export 금지
    'import/prefer-default-export': 'error', // 10.6: 단일 export인 경우 default export 선호
    'import/first': 'error', // 10.7: import를 최상단에 배치
    'import/no-webpack-loader-syntax': 'error', // 10.9: Webpack loader 구문 금지
    'import/extensions': [
      'error',
      'ignorePackages',
      {
        js: 'always', // ES Modules에서는 .js 확장자 필요
        jsx: 'never',
      },
    ], // 10.10: JavaScript 파일 확장자 (ES Modules 프로젝트는 always 필요)

    // Iterators and Generators (11.x)
    'no-iterator': 'error', // 11.1: 이터레이터 대신 고차 함수 사용
    'no-restricted-syntax': [
      'error',
      {
        selector: 'ForInStatement',
        message:
          'for..in loops iterate over the entire prototype chain, which is virtually never what you want. Use Object.{keys,values,entries}, and iterate over the resulting array.',
      },
      {
        selector: 'LabeledStatement',
        message:
          'Labels are a form of GOTO; using them makes code confusing and hard to maintain and understand.',
      },
      {
        selector: 'WithStatement',
        message:
          '`with` is disallowed in strict mode because it makes code impossible to predict and optimize.',
      },
    ], // 11.1: for-in, label, with 문 금지
    'generator-star-spacing': ['error', { before: false, after: true }], // 11.3: Generator 함수 * 공백

    // Properties (12.x)
    'dot-notation': ['error', { allowKeywords: true }], // 12.1: 점 표기법 사용
    'no-restricted-properties': [
      'error',
      {
        object: 'Math',
        property: 'pow',
        message: 'Use the exponentiation operator (**) instead.',
      },
    ], // 12.3: Math.pow 대신 ** 연산자

    // Variables (13.x)
    'no-undef': 'error', // 13.1: 선언되지 않은 변수 사용 금지
    'one-var': ['error', 'never'], // 13.2: 변수마다 const/let 사용
    'no-multi-assign': 'error', // 13.4: 연쇄 할당 금지
    'no-plusplus': ['error', { allowForLoopAfterthoughts: true }], // 13.5: ++ -- 연산자 금지
    'operator-linebreak': 'off', // 13.6: Prettier가 처리하도록 비활성화
    'no-unused-vars': [
      'error',
      { vars: 'all', args: 'after-used', ignoreRestSiblings: true },
    ], // 13.7: 사용하지 않는 변수 금지
    eqeqeq: ['error', 'always'], // 15.1: === !== 사용

    // Comparison Operators & Equality (15.x)
    'no-nested-ternary': 'error', // 15.6: 중첩된 삼항 연산자 금지
    'no-unneeded-ternary': 'error', // 15.7: 불필요한 삼항 연산자 금지
    'no-mixed-operators': 'error', // 15.8: 혼합 연산자는 괄호로 감싸기

    // Blocks (16.x)
    'brace-style': ['error', '1tbs', { allowSingleLine: true }], // 16.1: 중괄호 스타일
    'nonblock-statement-body-position': ['error', 'beside'], // 16.2: else 위치
    'no-else-return': 'error', // 16.3: else return 금지

    // Control Statements (17.x)
    'spaced-comment': ['error', 'always'], // 18.3: 주석 공백

    // Whitespace (19.x)
    indent: ['error', 2, { SwitchCase: 1 }], // 19.1: 2칸 들여쓰기
    'keyword-spacing': ['error', { before: true, after: true }], // 19.2: 키워드 공백
    'space-infix-ops': 'error', // 19.3: 중위 연산자 공백
    'eol-last': ['error', 'always'], // 19.5: 파일 끝 개행
    'newline-per-chained-call': ['error', { ignoreChainWithDepth: 4 }], // 19.6: 체이닝 줄바꿈
    'no-whitespace-before-property': 'error', // 19.7: 프로퍼티 앞 공백 금지
    'padded-blocks': ['error', 'never'], // 19.8: 블록 패딩 금지
    'space-in-parens': ['error', 'never'], // 19.9: 괄호 안 공백 금지
    'array-bracket-spacing': ['error', 'never'], // 19.10: 배열 괄호 공백 금지
    'object-curly-spacing': ['error', 'always'], // 19.11: 객체 중괄호 공백
    'max-len': [
      'error',
      {
        code: 100,
        tabWidth: 2,
        ignoreUrls: true,
        ignoreComments: false,
        ignoreRegExpLiterals: true,
        ignoreStrings: true,
        ignoreTemplateLiterals: true,
      },
    ], // 19.12: 최대 줄 길이 100
    'comma-spacing': ['error', { before: false, after: true }], // 19.13: 쉼표 공백
    'computed-property-spacing': ['error', 'never'], // 19.14: 계산된 프로퍼티 공백 금지
    'func-call-spacing': ['error', 'never'], // 19.15: 함수 호출 공백 금지
    'key-spacing': ['error', { beforeColon: false, afterColon: true }], // 19.16: 객체 키 공백
    'no-trailing-spaces': 'error', // 19.17: 후행 공백 금지
    'no-multiple-empty-lines': ['error', { max: 1, maxBOF: 0, maxEOF: 0 }], // 19.18: 여러 빈 줄 금지

    // Commas (20.x)
    'comma-style': ['error', 'last'], // 20.1: 쉼표를 끝에
    // 20.2: 후행 쉼표는 Prettier가 처리 (prettier/recommended가 자동 비활성화)

    // Semicolons (21.x)
    semi: ['error', 'always'], // 21.1: 세미콜론 사용
    'no-extra-semi': 'error', // 불필요한 세미콜론 금지

    // Type Casting & Coercion (22.x)
    'no-new-wrappers': 'error', // 22.2: wrapper 객체 생성자 금지
    radix: 'error', // 22.3: parseInt에 radix 명시

    // Naming Conventions (23.x)
    camelcase: ['error', { properties: 'never', ignoreDestructuring: false }], // 23.1: camelCase 사용
    'new-cap': ['error', { newIsCap: true, capIsNew: false }], // 23.3: 생성자는 PascalCase
    'no-underscore-dangle': [
      'error',
      {
        allow: [],
        allowAfterThis: false,
        allowAfterSuper: false,
        enforceInMethodNames: true,
      },
    ], // 23.4: 언더스코어 금지

    // Accessors (24.x)
    'accessor-pairs': 'error', // 24.3: getter/setter 쌍으로 정의

    // Events (25.x)
    // 커스텀 이벤트는 프로젝트별로 규칙 추가

    // Standard Library (29.x)
    'no-restricted-globals': [
      'error',
      {
        name: 'isNaN',
        message: 'Use Number.isNaN instead.',
      },
      {
        name: 'isFinite',
        message: 'Use Number.isFinite instead.',
      },
    ], // 29.1, 29.2: Number.isNaN, Number.isFinite 사용

    // Testing (30.x)
    'no-empty-function': 'error', // 빈 함수 금지 (테스트 제외)
  },
};
