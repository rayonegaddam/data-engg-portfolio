-- Database Setup
-- =============================================================
CREATE SCHEMA alumni;

-- Data Ingestion Validation
-- =============================================================
SELECT 
    *
FROM
    college_a_hs;
SELECT 
    *
FROM
    college_a_se;
SELECT 
    *
FROM
    college_a_sj;
SELECT 
    *
FROM
    college_b_hs;
SELECT 
    *
FROM
    college_b_se;
SELECT 
    *
FROM
    college_b_sj;

-- Schema Exploration & Validation
desc college_a_hs;
desc college_a_se;
desc college_a_sj;
desc college_b_hs;
desc college_b_se;
DESC college_b_sj;

-- =============================================================
-- Data Quality Management
-- College A - Higher Studies
-- =============================================================

CREATE OR REPLACE VIEW college_a_hs_v AS
    SELECT 
        *
    FROM
        college_a_hs
    WHERE
        RollNo IS NOT NULL
            AND LastUpdate IS NOT NULL
            AND Name IS NOT NULL
            AND FatherName IS NOT NULL
            AND MotherName IS NOT NULL
            AND Batch IS NOT NULL
            AND Degree IS NOT NULL
            AND PresentStatus IS NOT NULL
            AND HSDegree IS NOT NULL
            AND EntranceExam IS NOT NULL
            AND Institute IS NOT NULL
            AND Location IS NOT NULL;

SELECT 
    *
FROM
    college_a_hs_v;

-- =============================================================
-- Data Quality Management
-- College A - Self Employment
-- =============================================================

CREATE OR REPLACE VIEW college_a_se_v AS
    SELECT 
        *
    FROM
        college_a_se
    WHERE
        RollNo IS NOT NULL
            AND LastUpdate IS NOT NULL
            AND Name IS NOT NULL
            AND FatherName IS NOT NULL
            AND MotherName IS NOT NULL
            AND Batch IS NOT NULL
            AND Degree IS NOT NULL
            AND PresentStatus IS NOT NULL
            AND Organization IS NOT NULL
            AND Location IS NOT NULL;

SELECT 
    *
FROM
    college_a_se_v;

-- =============================================================
-- Data Quality Management
-- College A - Service / Employment
-- =============================================================

CREATE OR REPLACE VIEW college_a_sj_v AS
    SELECT 
        *
    FROM
        college_a_sj
    WHERE
        RollNo IS NOT NULL
            AND LastUpdate IS NOT NULL
            AND Name IS NOT NULL
            AND FatherName IS NOT NULL
            AND MotherName IS NOT NULL
            AND Batch IS NOT NULL
            AND Degree IS NOT NULL
            AND PresentStatus IS NOT NULL
            AND Organization IS NOT NULL
            AND Designation IS NOT NULL
            AND Location IS NOT NULL;

SELECT 
    *
FROM
    college_a_sj_v;

-- =============================================================
-- Data Quality Management
-- College B - Higher Studies
-- =============================================================

CREATE OR REPLACE VIEW college_b_hs_v AS
    SELECT 
        *
    FROM
        college_b_hs
    WHERE
        RollNo IS NOT NULL
            AND LastUpdate IS NOT NULL
            AND Name IS NOT NULL
            AND FatherName IS NOT NULL
            AND MotherName IS NOT NULL
            AND Branch IS NOT NULL
            AND Batch IS NOT NULL
            AND Degree IS NOT NULL
            AND PresentStatus IS NOT NULL
            AND HSDegree IS NOT NULL
            AND EntranceExam IS NOT NULL
            AND Institute IS NOT NULL
            AND Location IS NOT NULL;

SELECT 
    *
FROM
    college_b_hs_v;

-- =============================================================
-- Data Quality Management
-- College B - Self Employment
-- =============================================================

CREATE OR REPLACE VIEW college_b_se_v AS
    SELECT 
        *
    FROM
        college_b_se
    WHERE
        RollNo IS NOT NULL
            AND LastUpdate IS NOT NULL
            AND Name IS NOT NULL
            AND FatherName IS NOT NULL
            AND MotherName IS NOT NULL
            AND Branch IS NOT NULL
            AND Batch IS NOT NULL
            AND Degree IS NOT NULL
            AND PresentStatus IS NOT NULL
            AND Organization IS NOT NULL
            AND Location IS NOT NULL;

SELECT 
    *
FROM
    college_b_se_v;

CREATE OR REPLACE VIEW college_b_sj_V AS
    (SELECT 
        *
    FROM
        college_b_sj
    WHERE
        RollNo IS NOT NULL
            AND LastUpdate IS NOT NULL
            AND Name IS NOT NULL
            AND FatherName IS NOT NULL
            AND MotherName IS NOT NULL
            AND Branch IS NOT NULL
            AND Batch IS NOT NULL
            AND Degree IS NOT NULL
            AND PresentStatus IS NOT NULL
            AND Organization IS NOT NULL
            AND Designation IS NOT NULL
            AND Location IS NOT NULL);
SELECT 
    *
FROM
    college_b_sj_V;

-- =============================================================
-- Data Standardization
-- =============================================================

SELECT LOWER(Name),LOWER(FatherName),LOWER(MotherName) FROM College_A_HS_V;
SELECT LOWER(Name),LOWER(FatherName),LOWER(MotherName) FROM College_A_Se_V;
SELECT LOWER(Name),LOWER(FatherName),LOWER(MotherName) FROM College_A_Sj_V;
SELECT LOWER(Name),LOWER(FatherName),LOWER(MotherName) FROM College_B_HS_V;
SELECT LOWER(Name),LOWER(FatherName),LOWER(MotherName) FROM College_B_Se_V;
SELECT LOWER(Name),LOWER(FatherName),LOWER(MotherName) FROM College_B_Sj_V;

-- =============================================================
-- Cursor Procedure
-- =============================================================
DROP PROCEDURE get_name_collegeA
DELIMITER $$
CREATE PROCEDURE get_name_collegeA 
(
         INOUT name1 TEXT(40000)
)
BEGIN 
    DECLARE na INT DEFAULT 0;
    DECLARE namelist VARCHAR(16000) DEFAULT "";
    
    DECLARE namedetail 
           CURSOR FOR
				SELECT Name FROM college_a_hs UNION SELECT Name FROM college_a_se UNION SELECT Name FROM college_a_sj;
                
	DECLARE CONTINUE HANDLER 
            FOR NOT FOUND SET na =1;
            
	OPEN namedetail;
    
    getame :
         LOOP
         FETCH FROM namedetail INTO namelist;
         IF na = 1 THEN
              LEAVE getame;
		END IF;
        SET name1 = CONCAT(namelist,";",name1);
        
        END LOOP getame;
        CLOSE namedetail;
END $$
DELIMITER ;

SET @Name = "";
CALL get_name_collegeA(@Name);
SELECT @Name Name;

-- =============================================================
DROP PROCEDURE get_name_collegeB
DELIMITER $$
CREATE PROCEDURE get_name_collegeB 
(
         INOUT name1 TEXT(40000)
)
BEGIN 
    DECLARE na INT DEFAULT 0;
    DECLARE namelist VARCHAR(16000) DEFAULT "";
    
    DECLARE namedetail 
           CURSOR FOR
				SELECT Name FROM college_b_hs UNION SELECT Name FROM college_b_se UNION SELECT Name FROM college_b_sj;
                
	DECLARE CONTINUE HANDLER 
            FOR NOT FOUND SET na =1;
            
	OPEN namedetail;
    
    getame :
         LOOP
         FETCH FROM namedetail INTO namelist;
         IF na = 1 THEN
              LEAVE getame;
		END IF;
        SET name1 = CONCAT(namelist,";",name1);
        
        END LOOP getame;
        CLOSE namedetail;
END $$
DELIMITER ;

SET @Name = "";
CALL get_name_collegeB(@Name);
SELECT @Name Name;

-- =============================================================
-- CAREER OUTCOME ANALYSIS
-- =============================================================
WITH alumni_totals AS (
    SELECT
        (SELECT COUNT(*) FROM college_a_hs) +
        (SELECT COUNT(*) FROM college_a_se) +
        (SELECT COUNT(*) FROM college_a_sj) AS college_a_total,

        (SELECT COUNT(*) FROM college_b_hs) +
        (SELECT COUNT(*) FROM college_b_se) +
        (SELECT COUNT(*) FROM college_b_sj) AS college_b_total
)

SELECT
    'Higher Studies' AS Present_Status,
    ROUND(
        (SELECT COUNT(*) FROM college_a_hs) * 100.0 /
        college_a_total, 2
    ) AS College_A_Percentage,
    ROUND(
        (SELECT COUNT(*) FROM college_b_hs) * 100.0 /
        college_b_total, 2
    ) AS College_B_Percentage
FROM alumni_totals

UNION ALL

SELECT
    'Self Employment',
    ROUND(
        (SELECT COUNT(*) FROM college_a_se) * 100.0 /
        college_a_total, 2
    ),
    ROUND(
        (SELECT COUNT(*) FROM college_b_se) * 100.0 /
        college_b_total, 2
    )
FROM alumni_totals

UNION ALL

SELECT
    'Service Job',
    ROUND(
        (SELECT COUNT(*) FROM college_a_sj) * 100.0 /
        college_a_total, 2
    ),
    ROUND(
        (SELECT COUNT(*) FROM college_b_sj) * 100.0 /
        college_b_total, 2
    )
FROM alumni_totals;