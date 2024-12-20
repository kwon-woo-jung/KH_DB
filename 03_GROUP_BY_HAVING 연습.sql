/*	SELECT문 해석 순서
 * 
 * 5 : SELECT 컬럼명 AS 별칭, 계산식, 함수식
 * 1 : FROM 테이블명
 * 2 : WHERE 컬럼명 | 함수식 비교연산자 비교값
 * 3 : GROUP BY 그룹을 묶을 컬럼명
 * 4 : HAVING 그룹함수식 비교연산자 비교값
 * 6 : ORDER BY 컬럼명 | 별칭 | 컬럼순서 정렬방식(ASC/DESC) [NULLS FIRST | LAST];
 * 
 * */

------------------------------------------------------------------------------------

-- * GROUP BY절 : 같은 값들이 여러개 기록된 컬럼을 가지고
--									같은 값들을 하나의 그룹으로 묶음


-- GROUP BY 컬럼명 | 함수식, ..

-- 여러개의 값을 묶어서 하나로 처리할 목적으로 사용함
-- 그룹으로 묶은 값에 대해서 SELECT절에서 그룹함수를 사용함

-- 그룹함수는 단 한개의 결과만 산출하기 때문에 그룹이 여러개일 경우 오류 발생
-- 여러 개의 결과값을 산출하기 위해 그룹함수가 적용된 그룹의 기준을 ORDER BY절에 기술하여 사용

-- EMPLOYEE 테이블에서 부서코드, 부서별 그여 합 조회

-- 1) 부서코드만 조회
SELECT DEPT_CODE FROM EMPLOYEE; -- 23행


-- 2) 전체 급여 합 조회
SELECT SUM(SALARY) FROM EMPLOYEE; -- 1행


SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE;
-- SQL Error [937] [42000]: ORA-00937: 단일 그룹의 그룹 함수가 아닙니다



-- 이렇게 해결
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;
-- DEPT_CODE 컬럼을 그룹으로 묶어, 그 그룹의 급여 합계(SUM(SALARY)) 를 구함


-- EMPLOYEE 테이블에서 	(FROM 절)
-- 직급코드가 같은 사람의 (직급을 그룹으로 묶기 : JOB_CODE)
-- 직급코드, 급여 평균, 인원 수를 (SELECT 절 )
-- 직급코드 오름차순으로 조회 (ORDER BY 절)

SELECT JOB_CODE, ROUND(AVG(SALARY)), COUNT(*)
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY JOB_CODE;



-- EMPLOYEE 테이블에서
-- 성별(남/여)과 각 성별 별 인원수, 급여 합을
-- 인원 수 오름차순으로 조회

SELECT DECODE(SUBSTR(EMP_NO, 8, 1), '남', '2', '여') 성별,
COUNT(*) "인원 수",
SUM(SALARY) "급여 합"
FROM EMPLOYEE
GROUP BY DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여') -- 별칭 사용 x (SELECT 해석 X)
ORDER BY "인원 수"; -- 별칭사용 O (SELECT 절 해석 완료)

-----------------------------------------------------------------------------------

-- * WHERE 절 GROUP BY 절 혼합하여 사용하기 *


--> WHERE 절은 각 컬럼값에 대한 조건
--> HAVING 절은 그룹에 대한 조건

/* SELECT문 해석 순서
 * 
 * 5 : SELECT 컬럼명 AS 별칭, 계산식, 함수식
 * 1 : FROM 테이블명
 * 2 : WHERE 컬럼명 | 함수식 비교연산자 비교값
 * 3 : GROUP BY 그룹을 묶을 컬럼명
 * 4 : HAVING 그룹함수식 비교연산자 비교값
 * 6 : ORDER BY 컬럼명 | 별칭 | 컬럼순번 정렬방식(ASC/DESC) [NULLS FIRST | LAST];
 * 
 * 
 * */

-- EMPLOYEE 테이블에서 (FROM 절)
-- 부서코드가 D5, D6인 부서의 (WHERE 절 -> GROUP BY 절)
-- 부서코드, 평균급여, 인원 수 조회 (SELECT 절)

SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
WHERE
-- HIRE_DATE >= TO_DATE('2000-01-01')
-- EXTRACT(YEAR FROM HIRE_DATE) >= 2000
SUBSTR( TO_CHAR(HIRE_DATE, 'YYYY'), 1, 4) >= '2000'
GROUP BY JOB_CODE;

--------------------------------------------------------

-- * 여러 컬럼을 묶어서 그룹으로 지정 가능 --> 그룹 내 그룹이 가능하다!

-- ***GROUP BY 사용 시 주의사항 ***
--> SELECT 문에 GROUP BY절을 사용할 경우
-- SELECT절에 명시한 조회하려는 컬럼 중
-- 그룹함수가 적용되지 않은 컬럼을
-- 모두 GROUP BY 절에 작성해야함.


-- EMPLOYEE 테이블에서
-- 부서별로 같은 직급인 사원의 인원수를 조회
-- 부서코드 오름차순, 직급코드 내림차순으로 정렬
-- 부서코드, 직급코드, 인원수

SELECT DEPT_CODE, JOB_CODE, COUNT(*)
FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE -- DEPT_CODE로 그룹을 나누고,
														-- 나눠진 그룹 내에서 JOB_CODE 로 그룹을 분류
ORDER BY DEPT_CODE, JOB_CODE DESC;
-- SQL Error [979] [42000]: ORA-OO979: GROUP BY 표현식이 아닙니다.

-------------------------------------------------------------------------

-- * HAVING 절 : 그룹함수로 구해 올 그룹에 대한 조건을 설정할 때 사용
-- HAVING 컬럼명 | 함수식 비교연산자 비교값

/*
 * 5 : SELECT 컬럼명 AS 별칭, 계산식, 함수식
 * 1 : FROM 테이블명
 * 2 : WHERE 컬럼명 | 함수식 비교연산자 비교값
 * 3 : GROUP BY 그룹을 묶을 컬럼명
 * 4 : HAVING 그룹함수식 비교연산자 비교값
 * 6 : ORDER BY 컬럼명 | 별칭 | 컬럼순번 정렬방식(ASC/DESC) [NULLS FIRST | LAST];
 * 
 * */

-- EMPLOYEE 테이블에서
-- 부서별 평균 급여가 3백만원 이상인 부서의
-- 부서코드, 평균급여 조회
-- 부서코드 오름차순


























