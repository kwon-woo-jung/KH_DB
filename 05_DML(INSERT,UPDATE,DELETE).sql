-- ** DML(Data Manipulation Language) : 데이터 조작 언어 **

-- 테이블에 값을 삽입하거나(INSERT), 수정하거나(UPDATE), 삭제(DELETE)하는 구문

-- 주의 : 혼자서 COMMIT, ROLLBACK을 하지 말것!
-- 원도우 > 설정 > 연결 > 연결유형 Auto commit by default 체크 해제 되어있는지 확인!

-- 테스트용 테이블 생성
CREATE TABLE EMPLOYEE2 AS SELECT * FROM EMPLOYEE;
CREATE TABLE DEPARTMENT2 AS SELECT * FROM DEPARTMENT;


SELECT * FROM EMPLOYEE2;
SELECT * FROM DEPARTMENT2;

----------------------------------------------------------------------------

-- 1. INSERT

-- 테이블에 새로운 행을 추가하는 구문

-- 1) INSERT INTO 테이블명 VALUES(데이터, 데이터, 데이터...);
-- 테이블에 있는 모든 컬럼에 대한 값을 INSERT 할 때 사용
-- INSERT 하고자 하는 컬럼이 모든 컬럼인 경우 컬럼명 생략 가능.
-- 단, 컬럼의 순서를 지켜서 VALUES에 값을 기입해야함.
SELECT * FROM EMPLOYEE2;

INSERT INTO EMPLOYEE2
VALUES('900', '권우중', '020615-1234567', 'Kwon_wo@or.kr',
	'01011111111', 'D1', 'J7', 'S3', 430000, 0.2,
	200, SYSDATE, HULL, 'N'
);  -- 전체 INSERT: 모든 컬럼에 데이터를 넣기 위한 구문입니다. NULL을 통해
	-- 값을 주지 않을 컬럼을 명시합니다. 

SELECT * FROM EMPLOYEE2
NHERE EMP_ID = '900';

ROLLBACK;
-- ROLLBACK: 이전에 삽입한 데이터를 취소합니다, 단, COMMIT 전에만
-- 이 구문을 사용할 수 있습니다.

-- 2) INSERT INTO 테이블명(컬럼명1, 컬럼명2, 컬럼명3...) 
-- 					VALUES (데이터1, 데이터2, 데이터3...);
-- 테이블에 내가 선택한 컬럼에 대한 값만 INSERT 할 때 사용
-- 선택 안된 컬럼은 값이 NULL이 들어감 (DEFAULT 존재 시 DEFAULT 설정한값으로 삽입됨)


INSERT INTO EMPLOYEE2 (EMP_ID, EMP_NAME, EMP_NO, EMAIL, PHONE,
						DEPT_CODE, JOB_CODE, SAL_LEVEL, SALARY)
VALUES('900', '권우중', '020615-1234567', 'Kwon_wo@or.kr',
'01011111111', 'D1', 'J7', 'S3', 430000)
-- 부분 INSERT: 특정 컬럼에만 데이터를 삽입하는 구문입니다. 지정하지 않은
-- 컬럼은 NULL이 삽입되거나 기본값이 있을 경우 해당 값으로 채워집니다.


SELECT * FROM EMPLOYEE2
WHERE EMP_ID = 900;
-- 조회 다시해봄(영구저장 되었기 때문에 롤백한다 하더라도 되돌리기 안된다)

COMMIT; -- 홍길동 데이터 영구저장함
ROLLBACK; -- ROLLBACK 수행해봄
-- COMMIT: 데이터를 영구적으로 저장합니다 COMMIT 이후에는 데이터
-- 변경 사항이 확정되므로, 더 이상 ROLLBACK을 통해 변경 사항을
-- 되돌릴 수 없습니다.

-- ROLLBACK: COMMIT 이후에 ROLLBACK을 사용하면 아무런 효과가 없습니다.

SELECT * FROM EMPLOYEE2
WHERE EMP_ID = 900;
-- 조회 다시해봄(영구저장 되었기 때문에 롤백한다 하더라도 되돌리기 안된다)
-- 마지막으로 EMP_ID가 900인 데이터가 정상적으로 삽인되었는지 확인합니다.

-- 주의사항:
-- ROLLBACK은 COMMIT 이전의 변경 사항만 되돌릴 수 있습니다 COMMIT이 수행되면
-- 데이터는 영구저장되므로, 이후에는 ROLLBACK이 불가능 합니다.

-- 트랜잭션 관리 시 COMMIT과 ROLLBACK의 타이밍을 신중하게 관리해야 합니다.

----------------------------------------------------------------------------------

-- INSERT 시 VALUES 대신 서브쿼리 사용 가능
CREATE TABLE EMP_01(
	EMP_ID NUMBER,
	EMP_NAME VARCHAR2(30),
	DEPT_TITLE VARCHAR2(20)
);

SELECT * FROM EMP_01; 


SELECT EMP_ID, EMP_NAME, DEPT_TITLE
FROM EMPLOYEE2
LEFT JOIN DEPARTMENT2 ON(DEPT_CODE = DEPT_ID);

-- 서브쿼리(SELECT) 결과를 EMP_01 테이블에 INSERT
--> SELECT 조회 결과의 데이터 타입, 컬럼 개수가
-- INSERT 하려는 테이블의 컬럼과 일치해야함

INSERT INTO EMP_01(
	SELECT EMP_ID, EMP_NAME, DEPT_TITLE
	FROM EMPLOYEE2
	LEFT JOIN DEPARTMENT2 ON(DEPT_CODE = DEPT_ID)
);

SELECT * FROM EMP_01;

---------------------------------------------------------------------


-- 2. UPDATE (내용을 바꾸던가 추가해서 최신화)
-- 테이블에 기록된 컬럼의 값을 수정하는 구문

--[작성법]
/*
 * UPDATE 테이블명 SET 컬럼명 = 바꿀값
 * [WHERE 컬럼명 비교연산자 비교값];
 * --> WHERE 조건 중요!
 * 
 * */

-- DEPARTMENT2 테이블에서 DEPT_ID가 'D9' 인 부서 정보 조회
SELECT * FROM DEPARTMENT2
WHERE DEPT_ID = 'D9';

-- DEPARTMENT2 테이블에서 DEPT_ID가 'D9' 인 부서의 DEPT_TITLE을
-- DEPT_TITLE을 '전략기획팀' 으로 수정

UPDATE DEPARTMENT2
SET DEPT_TITLE = '전략기획팀'
WHERE DEPT_ID = 'D9';

-- UPDATE 확인
SELECT * FROM DEPARTMENT2
WHERE DEPT_ID = 'D9';


-- EMPLOYEE2 테이블에서 BONUS를 받지 않는 사원의
-- BONUS를 0.1로 변경

SELECT * FROM EMPLOYEE2

UPDATE EMPLOYEE2
SET BONUS = 0.1
WHERE BONUS IS NULL; -- 15개 행 수정

SELECT EMP_NAME, BONUS FROM EMPLOTEE2;

-------------------------------------------------------------

-- * 조건절을 설정하지 않고 UPDATE 구문 실행 시
-- 모든 행의 컬럼값이 변경 *

SELECT * FROM DEPARTMENT2;

UPDATE DEPARTMENT2
SET DEPT_TITLE = '기술연구팀';


SELECT * FROM DEPARTMENT2;

ROLLBACK;


------------------------------------------------------------------

-- * 여러 컬럼을 한번에 수정할 시 콤마(,)로 컬럼을 구분하면됨.
-- D9 / 총무부  --> D0 / 전략기획팀 수정


UPDATE DEPARTMENT2 SET
DEPT_ID = 'D0',
DEPT_TITLE = '전략기획팀' -- WHERE 절 직전 컬럼 작성 콤마 X
WHERE DEPT_ID = 'D9'
AND DEPT_TITLE = '총무부';


SELECT * FROM DEPARTMENT2;


-------------------------------------------------------------------

-- * UPDATE시에도 서브쿼리를 사용 가능

-- [작성법]
-- UPDATE 테이블명 SET
-- 컬렴명 = (서브쿼리)


-- EMPLOYEE2 테이블에서
-- 방명수 사원의 급여와 보너스율을
-- 유재식 사원과 동일하게 변경해주기로 했다.
-- 이를 반영하는 UPDATE 문을 작성해보자!

-- 유재식의 급여
SELECT SALARY FROM EMPLOYEE2
WHERE EMP_NAME = '유재식'; -- 3,400,000

-- 유재식의 보너스율
SELECT BONUS FROM EMPLOYEE2
WHERE EMP_NAME = '유재식'; -- 0.2


-- 박명수 급여, 보너스 수정
UPDATE EMPLOYEE2 SET
SALARY = (SELECT SALARY FROM EMPLOYEE2 WHERE EMP_NAME = '유재식'),
BONUS = (SELECT SALARY FROM EMPLOYEE2 WHERE EMP_NAME = '유재식')
WHERE EMP_NAME = '방명수';



SELECT EMP_NAME, SALARY, BONUS
FROM EMPLOYEE2
WHERE EMP_NAME IN ('유재식', '방명수');

-----------------------------------------------------------------------------------

-- 3. MERGE(병합)

-- 구조가 같은 두 개의 테이블을 하나로 합치는 기능
-- 테이블에서 지정하는 조건의 값이 존재하면 UPDATE
-- 없으면 INSERT 됨


CREATE TABLE EMP_M01
AD SELECT * FROM EMPLOYEE;

CREATE TABLE EMP_M02
AS SELECT * FROM EMPLOYEE
WHERE JOB_CODE = 'J4';

SELECT * FROM EMP_MO1;
SELECT * FROM EMP_MO2;



INSERT INTO EMP_MO2 
VALUES(999, '곽두원', '561016-1234567', 'kwack_dw@kh.or.kr',
      '01011112222', 'D9', 'J4', 'S1', 9000000, 0.5, NULL,
      SYSDATE, NULL, DEFAULT);
     
     
SELECT * FROM EMP_MO1; -- 23명
SELECT * FROM EMP_MO2; -- 5명 (기존4 + 신규1)

UPDATE EMP_MO2 SET SALARY = 0;

MERGE INTO EMP_M01 USING EMP_M02 ON(EMP_M01.EMP_ID = EMP_M02.EMP_ID)
WHEN MATCHED THEN
UPDATE SET
  EMP_M01.EMP_NAME = EMP_M02.EMP_NAME,
  EMP_M01.EMP_NO = EMP_M02.EMP_NO,
  EMP_M01.EMAIL = EMP_M02.EMAIL,
  EMP_M01.PHONE = EMP_M02.PHONE,
  EMP_M01.DEPT_CODE = EMP_M02.DEPT_CODE,
  EMP_M01.JOB_CODE = EMP_M02.JOB_CODE,
  EMP_M01.SAL_LEVEL = EMP_M02.SAL_LEVEL,
  EMP_M01.SALARY = EMP_M02.SALARY,
  EMP_M01.BONUS = EMP_M02.BONUS,
  EMP_M01.MANAGER_ID = EMP_M02.MANAGER_ID,
  EMP_M01.HIRE_DATE = EMP_M02.HIRE_DATE,
  EMP_M01.ENT_DATE = EMP_M02.ENT_DATE,
  EMP_M01.ENT_YN = EMP_M02.ENT_YN
WHEN NOT MATCHED THEN
INSERT VALUES(EMP_M02.EMP_ID, EMP_M02.EMP_NAME, EMP_M02.EMP_NO, EMP_M02.EMAIL,
           EMP_M02.PHONE, EMP_M02.DEPT_CODE, EMP_M02.JOB_CODE, EMP_M02.SAL_LEVEL, EMP_M02.SALARY, EMP_M02.BONUS, EMP_M02.MANAGER_ID, EMP_M02.HIRE_DATE,
           EMP_M02.ENT_DATE, EMP_M02.ENT_YN);



SELECT * FROM EMP_MO1;


------------------------------------------------------------------------------------------------------------

-- 4. DELETE
-- 테이블의 행을 삭제하는 구문

-- [작성법]
-- DELETE FROM 테이블명 WHERE 조건설정;
-- 만약에 WHERE 조건을 설정하지 않으면 모든 행이 다 삭제됨!


COMMIT;

SELECT * FROM EMPLOYEE2
WHERE EMP_NAME = '유재식';

-- 홍길동 삭제해보기
DELETE FROM EMPLOYEE2
WHERE EMP_NAME = '홍길동';

-- 삭제 확인
SELECT * FROM EMPLOYEE2
WHERE EMP_NAME = '유재식';


ROLLBACK; -- 마지막 커밋 시점까지 돌아감


DELETE FROM EMPLOYEE2
WHERE EMP_NAME = '홍길동'; --> 조회 결과 있음

-- EMPLOYEE2 테이블 전체 삭제
DELETE FROM EMPLOYEE2;
--> 24행 삭제



SELECT * FROM EMPLOYEE2;


ROLLBACK;



SELECT * FROM EMPLOYEE2;


--------------------------------------------------------------------------------------------

-- 5. TRUNCATE (DML 아닙니다 DDL 입니다!)
-- 테이블의 전체 행을 삭제하는 DDL
-- DELETE 보다 수행속도 더 빠르다.
-- ROLLBACK 을 통해 복구할 수 없다.


-- TRUNCATE 테스트용 테이블 생성
CREATE TABLE EMPLOYEE3
AS SELECT * FROM EMPLOYEE2;


-- 생성 확인
SELECT * FROM EMPLOYEE3;


-- TRUNCATE로 삭제

TRUNCATE TABLE EMPLOYEE3;

-- 삭제 확인
SELECT * FROM EMPLOYEE3; -- 삭제됨


ROLLBACK;

-- 롤백 후 복구 확인 (복구 안됨을 확인!)
SELECT * FROM EMPLOYEE3;



-- DELETE : 휴지통 버리기
-- TRUNCATE : 완전 삭제






























