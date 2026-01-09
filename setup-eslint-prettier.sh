#!/bin/bash

# ESLint & Prettier 자동 설정 스크립트 (Airbnb JavaScript Style Guide 기반)
# ES Modules 프로젝트용

set -e  # 에러 발생 시 스크립트 중단

echo "=================================================="
echo "ESLint & Prettier 자동 설정 시작"
echo "Airbnb JavaScript Style Guide 기반"
echo "=================================================="
echo ""

# 0단계: Node.js 버전 확인 및 설정
echo "🔍 0단계: Node.js 버전 확인 중..."

REQUIRED_NODE_VERSION="22.19.0"
CURRENT_NODE_VERSION=$(node -v | sed 's/v//')

echo "현재 Node.js 버전: v${CURRENT_NODE_VERSION}"
echo "필요한 Node.js 버전: v${REQUIRED_NODE_VERSION}"

# 버전 비교 함수
version_compare() {
  echo "$@" | awk -F. '{ printf("%d%03d%03d\n", $1,$2,$3); }'
}

CURRENT_VERSION_NUM=$(version_compare ${CURRENT_NODE_VERSION})
REQUIRED_VERSION_NUM=$(version_compare ${REQUIRED_NODE_VERSION})

if [ ${CURRENT_VERSION_NUM} -lt ${REQUIRED_VERSION_NUM} ]; then
  echo "⚠️  Node.js 버전이 요구사항보다 낮습니다."
  echo ""

  # nvm이 설치되어 있는지 확인
  if [ -s "$HOME/.nvm/nvm.sh" ]; then
    echo "📦 nvm을 사용하여 Node.js ${REQUIRED_NODE_VERSION} 설치 및 적용 중..."

    # nvm 로드
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    # 필요한 버전 설치 및 사용
    nvm install ${REQUIRED_NODE_VERSION}
    nvm use ${REQUIRED_NODE_VERSION}

    echo "✅ Node.js ${REQUIRED_NODE_VERSION} 설정 완료"
    echo "현재 Node.js 버전: $(node -v)"
    echo ""
  else
    echo "❌ nvm이 설치되어 있지 않습니다."
    echo "다음 명령어로 수동으로 Node.js 버전을 업데이트해주세요:"
    echo ""
    echo "  # nvm 설치 (설치되지 않은 경우)"
    echo "  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash"
    echo ""
    echo "  # 터미널 재시작 후"
    echo "  nvm install ${REQUIRED_NODE_VERSION}"
    echo "  nvm use ${REQUIRED_NODE_VERSION}"
    echo ""
    exit 1
  fi
else
  echo "✅ Node.js 버전이 요구사항을 충족합니다."
  echo ""
fi

# 1단계: 패키지 설치
echo "📦 1단계: 필요한 패키지 설치 중..."
npm install --save-dev \
  eslint@^8.57.1 \
  eslint-config-airbnb-base@^15.0.0 \
  eslint-config-prettier@^10.1.8 \
  eslint-plugin-import@^2.32.0 \
  eslint-plugin-prettier@^5.5.4 \
  prettier@^3.7.4

echo "✅ 패키지 설치 완료"
echo ""

# 2단계: ESLint 설정 파일 생성
echo "📝 2단계: .eslintrc.cjs 파일 생성 중..."
cat > .eslintrc.cjs << 'EOF'
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
EOF

echo "✅ .eslintrc.cjs 파일 생성 완료"
echo ""

# 3단계: Prettier 설정 파일 생성
echo "📝 3단계: .prettierrc.cjs 파일 생성 중..."
cat > .prettierrc.cjs << 'EOF'
module.exports = {
  // 6.1: 작은따옴표 사용
  singleQuote: true,

  // 21.1: 세미콜론 사용
  semi: true,

  // 19.1: 2칸 들여쓰기
  tabWidth: 2,
  useTabs: false,

  // 19.12: 최대 줄 길이 100
  printWidth: 100,

  // 20.2: 후행 쉼표 사용 (ES5: 객체, 배열만. 함수 파라미터는 제외)
  trailingComma: 'es5',

  // 19.11: 객체 중괄호 공백
  bracketSpacing: true,

  // 8.4: 화살표 함수 매개변수 괄호
  arrowParens: 'always',

  // 19.5: 파일 끝 개행 (운영체제에 따라 자동)
  endOfLine: 'auto',

  // 3.6: 필요한 경우만 프로퍼티 따옴표
  quoteProps: 'as-needed',
};
EOF

echo "✅ .prettierrc.cjs 파일 생성 완료"
echo ""

# 4단계: Ignore 파일 생성
echo "📝 4단계: .eslintignore 및 .prettierignore 파일 생성 중..."

# .eslintignore 파일 생성
cat > .eslintignore << 'EOF'
# Dependencies
node_modules/

# Build outputs
dist/
build/
*.min.js

# Test coverage
coverage/

# Logs
*.log
npm-debug.log*

# Environment files
.env
.env.*

# IDE
.vscode/
.idea/

# OS files
.DS_Store
Thumbs.db
EOF

# .prettierignore 파일 생성
cat > .prettierignore << 'EOF'
# Dependencies
node_modules/

# Build outputs
dist/
build/
*.min.js

# Test coverage
coverage/

# Logs
*.log
npm-debug.log*

# Environment files
.env
.env.*

# IDE
.vscode/
.idea/

# OS files
.DS_Store
Thumbs.db

# Lock files
package-lock.json
yarn.lock
pnpm-lock.yaml
EOF

echo "✅ .eslintignore 및 .prettierignore 파일 생성 완료"
echo ""

# 5단계: package.json 스크립트 추가
echo "📝 5단계: package.json에 스크립트 추가 중..."

# package.json에 스크립트 추가 (기존 스크립트 유지)
if command -v jq &> /dev/null; then
  # jq가 설치되어 있는 경우
  jq '.scripts.lint = "eslint ." |
      .scripts["lint:fix"] = "eslint . --fix" |
      .scripts.format = "prettier --write ." |
      .scripts["format:check"] = "prettier --check ."' package.json > package.json.tmp && \
  mv package.json.tmp package.json
else
  # jq가 없는 경우 - 사용자에게 수동 추가 안내
  echo "⚠️  jq가 설치되어 있지 않아 package.json 스크립트를 자동으로 추가할 수 없습니다."
  echo "다음 스크립트를 package.json의 scripts 섹션에 수동으로 추가해주세요:"
  echo ""
  echo '  "lint": "eslint .",'
  echo '  "lint:fix": "eslint . --fix",'
  echo '  "format": "prettier --write .",'
  echo '  "format:check": "prettier --check ."'
  echo ""
fi

echo "✅ package.json 스크립트 추가 완료"
echo ""

# 6단계: VSCode 설정 파일 생성
echo "📝 6단계: VSCode 설정 파일 생성 중..."

# .vscode 디렉토리 생성
mkdir -p .vscode

# .vscode/settings.json 파일 생성
cat > .vscode/settings.json << 'EOF'
{
  "eslint.enable": true,
  "eslint.validate": [
    "javascript",
    "javascriptreact"
  ],
  "eslint.options": {
    "overrideConfigFile": ".eslintrc.cjs"
  },
  "eslint.workingDirectories": [
    {
      "mode": "auto"
    }
  ],
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "editor.formatOnSave": true,
  "prettier.requireConfig": true,
  "[javascript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode",
    "editor.formatOnSave": true,
    "editor.codeActionsOnSave": {
      "source.fixAll.eslint": "explicit"
    }
  },
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": "explicit"
  },
  "files.insertFinalNewline": true,
  "files.trimFinalNewlines": true,
  "files.trimTrailingWhitespace": true,
  "editor.tabSize": 2,
  "editor.insertSpaces": true,
  "editor.detectIndentation": false
}
EOF

# .vscode/extensions.json 파일 생성
cat > .vscode/extensions.json << 'EOF'
{
  "recommendations": [
    "dbaeumer.vscode-eslint",
    "esbenp.prettier-vscode"
  ]
}
EOF

echo "✅ VSCode 설정 파일 생성 완료"
echo ""

# 7단계: 기존 코드 포맷팅
echo "🎨 7단계: 기존 코드 자동 포맷팅 및 lint 수정 중..."
echo ""

echo "📝 Prettier로 코드 포맷팅 실행 중..."
npm run format || echo "⚠️  포맷팅 중 일부 오류가 발생했습니다."
echo ""

echo "🔧 ESLint로 자동 수정 가능한 오류 수정 중..."
npm run lint:fix || echo "⚠️  일부 lint 오류가 자동 수정되지 않았습니다."
echo ""

echo "🔍 남은 lint 오류 확인 중..."
if npm run lint; then
  echo "✅ 모든 lint 오류가 수정되었습니다!"
else
  echo "⚠️  수동으로 수정이 필요한 lint 오류가 있습니다."
  echo "    'npm run lint' 명령어로 상세 오류를 확인하세요."
fi
echo ""

# 완료 메시지
echo "=================================================="
echo "✅ ESLint & Prettier 설정 완료!"
echo "=================================================="
echo ""
echo "생성된 파일:"
echo "  ✓ .eslintrc.cjs"
echo "  ✓ .prettierrc.cjs"
echo "  ✓ .eslintignore"
echo "  ✓ .prettierignore"
echo "  ✓ .vscode/settings.json"
echo "  ✓ .vscode/extensions.json"
echo ""
echo "추가된 npm 스크립트:"
echo "  ✓ npm run lint         - lint 오류 확인"
echo "  ✓ npm run lint:fix     - lint 오류 자동 수정"
echo "  ✓ npm run format       - 코드 포맷팅"
echo "  ✓ npm run format:check - 포맷팅 확인 (CI/CD용)"
echo ""
echo "VSCode 사용자를 위한 안내:"
echo "  1. ESLint 확장 프로그램 설치 (dbaeumer.vscode-eslint)"
echo "  2. Prettier 확장 프로그램 설치 (esbenp.prettier-vscode)"
echo "  3. VSCode 재시작 또는 'Developer: Reload Window' 실행"
echo "  4. 명령 팔레트(Cmd/Ctrl+Shift+P)에서 'ESLint: Restart ESLint Server' 실행"
echo ""
echo "=================================================="
