-- Copyright 2004-2021 H2 Group. Multiple-Licensed under the MPL 2.0,
-- and the EPL 1.0 (https://h2database.com/html/license.html).
-- Initial Developer: H2 Group
--

CREATE SEQUENCE SEQ START WITH 0 INCREMENT BY 1 MINVALUE 0 MAXVALUE 1;
> ok

DROP SEQUENCE SEQ;
> ok

CREATE SEQUENCE SEQ START WITH 0 INCREMENT BY 1 MINVALUE 0 MAXVALUE 0;
> exception SEQUENCE_ATTRIBUTES_INVALID_7

CREATE SEQUENCE SEQ START WITH 1 INCREMENT BY 1 MINVALUE 1 MAXVALUE 0;
> exception SEQUENCE_ATTRIBUTES_INVALID_7

CREATE SEQUENCE SEQ START WITH 0 INCREMENT BY 0 MINVALUE 0 MAXVALUE 1;
> exception SEQUENCE_ATTRIBUTES_INVALID_7

CREATE SEQUENCE SEQ START WITH 1 INCREMENT BY 1 MINVALUE 2 MAXVALUE 10;
> exception SEQUENCE_ATTRIBUTES_INVALID_7

CREATE SEQUENCE SEQ START WITH 20 INCREMENT BY 1 MINVALUE 1 MAXVALUE 10;
> exception SEQUENCE_ATTRIBUTES_INVALID_7

CREATE SEQUENCE SEQ START WITH 0 INCREMENT BY 9223372036854775807 MINVALUE -9223372036854775808 MAXVALUE 9223372036854775807;
> ok

DROP SEQUENCE SEQ;
> ok

CREATE SEQUENCE SEQ START WITH 0 INCREMENT BY 9223372036854775807 MINVALUE -9223372036854775808 MAXVALUE 9223372036854775807 CACHE 2;
> exception SEQUENCE_ATTRIBUTES_INVALID_7

CREATE SEQUENCE SEQ START WITH 0 INCREMENT BY -9223372036854775808 MINVALUE -9223372036854775808 MAXVALUE 9223372036854775807;
> ok

DROP SEQUENCE SEQ;
> ok

CREATE SEQUENCE SEQ START WITH 0 INCREMENT BY -9223372036854775808 MINVALUE -9223372036854775808 MAXVALUE 9223372036854775807 CACHE 2;
> exception SEQUENCE_ATTRIBUTES_INVALID_7

CREATE SEQUENCE SEQ START WITH 0 INCREMENT BY -9223372036854775808 MINVALUE -1 MAXVALUE 9223372036854775807 NO CACHE;
> ok

DROP SEQUENCE SEQ;
> ok

CREATE SEQUENCE SEQ START WITH 0 INCREMENT BY -9223372036854775808 MINVALUE 0 MAXVALUE 9223372036854775807 NO CACHE;
> exception SEQUENCE_ATTRIBUTES_INVALID_7

CREATE SEQUENCE SEQ START WITH 0 INCREMENT BY -9223372036854775808 MINVALUE -1 MAXVALUE 9223372036854775807 CACHE 2;
> exception SEQUENCE_ATTRIBUTES_INVALID_7

CREATE SEQUENCE SEQ CACHE -1;
> exception SEQUENCE_ATTRIBUTES_INVALID_7

CREATE SEQUENCE SEQ MINVALUE 10 START WITH 9 RESTART WITH 10;
> exception SEQUENCE_ATTRIBUTES_INVALID_7

CREATE SEQUENCE SEQ MAXVALUE 10 START WITH 11 RESTART WITH 1;
> exception SEQUENCE_ATTRIBUTES_INVALID_7

CREATE SEQUENCE SEQ START WITH 0 MINVALUE -10 MAXVALUE 10;
> ok

SELECT SEQUENCE_NAME, START_VALUE, MINIMUM_VALUE, MAXIMUM_VALUE, INCREMENT, CYCLE_OPTION, BASE_VALUE, CACHE
    FROM INFORMATION_SCHEMA.SEQUENCES;
> SEQUENCE_NAME START_VALUE MINIMUM_VALUE MAXIMUM_VALUE INCREMENT CYCLE_OPTION BASE_VALUE CACHE
> ------------- ----------- ------------- ------------- --------- ------------ ---------- -----
> SEQ           0           -10           10            1         NO           0          21
> rows: 1

ALTER SEQUENCE SEQ NO MINVALUE NO MAXVALUE;
> ok

SELECT SEQUENCE_NAME, START_VALUE, MINIMUM_VALUE, MAXIMUM_VALUE, INCREMENT, CYCLE_OPTION, BASE_VALUE, CACHE
    FROM INFORMATION_SCHEMA.SEQUENCES;
> SEQUENCE_NAME START_VALUE MINIMUM_VALUE MAXIMUM_VALUE       INCREMENT CYCLE_OPTION BASE_VALUE CACHE
> ------------- ----------- ------------- ------------------- --------- ------------ ---------- -----
> SEQ           0           0             9223372036854775807 1         NO           0          21
> rows: 1

ALTER SEQUENCE SEQ MINVALUE -100 MAXVALUE 100;
> ok

SELECT SEQUENCE_NAME, START_VALUE, MINIMUM_VALUE, MAXIMUM_VALUE, INCREMENT, CYCLE_OPTION, BASE_VALUE, CACHE
    FROM INFORMATION_SCHEMA.SEQUENCES;
> SEQUENCE_NAME START_VALUE MINIMUM_VALUE MAXIMUM_VALUE INCREMENT CYCLE_OPTION BASE_VALUE CACHE
> ------------- ----------- ------------- ------------- --------- ------------ ---------- -----
> SEQ           0           -100          100           1         NO           0          21
> rows: 1

VALUES NEXT VALUE FOR SEQ;
>> 0

ALTER SEQUENCE SEQ START WITH 10;
> ok

SELECT SEQUENCE_NAME, START_VALUE, MINIMUM_VALUE, MAXIMUM_VALUE, INCREMENT, CYCLE_OPTION, BASE_VALUE, CACHE
    FROM INFORMATION_SCHEMA.SEQUENCES;
> SEQUENCE_NAME START_VALUE MINIMUM_VALUE MAXIMUM_VALUE INCREMENT CYCLE_OPTION BASE_VALUE CACHE
> ------------- ----------- ------------- ------------- --------- ------------ ---------- -----
> SEQ           10          -100          100           1         NO           1          21
> rows: 1

VALUES NEXT VALUE FOR SEQ;
>> 1

ALTER SEQUENCE SEQ RESTART;
> ok

VALUES NEXT VALUE FOR SEQ;
>> 10

ALTER SEQUENCE SEQ START WITH 5 RESTART WITH 20;
> ok

VALUES NEXT VALUE FOR SEQ;
>> 20

@reconnect

SELECT SEQUENCE_NAME, START_VALUE, MINIMUM_VALUE, MAXIMUM_VALUE, INCREMENT, CYCLE_OPTION, BASE_VALUE, CACHE
    FROM INFORMATION_SCHEMA.SEQUENCES;
> SEQUENCE_NAME START_VALUE MINIMUM_VALUE MAXIMUM_VALUE INCREMENT CYCLE_OPTION BASE_VALUE CACHE
> ------------- ----------- ------------- ------------- --------- ------------ ---------- -----
> SEQ           5           -100          100           1         NO           21         21
> rows: 1

DROP SEQUENCE SEQ;
> ok

CREATE SEQUENCE SEQ START WITH 10 RESTART WITH 20;
> ok

VALUES NEXT VALUE FOR SEQ;
>> 20

DROP SEQUENCE SEQ;
> ok

SET AUTOCOMMIT OFF;
> ok

CREATE SEQUENCE SEQ;
> ok

ALTER SEQUENCE SEQ RESTART WITH 1;
> ok

SELECT NEXT VALUE FOR SEQ;
>> 1

DROP SEQUENCE SEQ;
> ok

COMMIT;
> ok

SET AUTOCOMMIT ON;
> ok

CREATE SEQUENCE SEQ MINVALUE 1 MAXVALUE 10 INCREMENT BY -1;
> ok

VALUES NEXT VALUE FOR SEQ, NEXT VALUE FOR SEQ;
> C1
> --
> 10
> 9
> rows: 2

ALTER SEQUENCE SEQ RESTART;
> ok

VALUES NEXT VALUE FOR SEQ, NEXT VALUE FOR SEQ;
> C1
> --
> 10
> 9
> rows: 2

ALTER SEQUENCE SEQ RESTART WITH 1;
> ok

VALUES NEXT VALUE FOR SEQ;
>> 1

VALUES NEXT VALUE FOR SEQ;
> exception SEQUENCE_EXHAUSTED

DROP SEQUENCE SEQ;
> ok
