--C442 Phase 4 Final Phase
--Due 04.23.24
--Palmer Vu
-------------------------------------------------------------------------------------------------------------------------------------------
-- Task 2: 
--Implement Relational Algebra Queries

-- Query A
-- Find faculty who are also students. List their names.
SELECT u.First_Name, u.Last_Name
FROM "User" u
INNER JOIN Faculty f ON u.ID = f.User_ID
INNER JOIN Student s ON u.ID = s.User_ID;

-- Query B
-- List names of tutors who are hired by College CLAS of Campus IUSB.
SELECT u.First_Name, u.Last_Name
FROM "User" u
INNER JOIN Tutor t ON u.ID = t.User_ID
INNER JOIN College c ON t.Unit_College_ID = c.Unit_Cllge_ID
WHERE c.ID = 'CLAS' AND c.Campus_ID = 'iusb';

-- Query C
-- Count the total number of OnCalls and Appointments that Tutor 9003 hired by Unit CS of Campus IUSB attended in May 2021.
-- Only status in attended (char value ‘3’) will be counted.
WITH CS_Unit AS (
    SELECT Unit_Cllge_ID
    FROM Unit
    WHERE ID = 'CS' AND Campus_ID = 'iusb'
),
Filtered_OnCall AS (
    SELECT *
    FROM OnCall
    WHERE Tutor_Unit_College_ID IN (SELECT Unit_Cllge_ID FROM CS_Unit)
      AND OnCallDate BETWEEN DATE '2021-05-01' AND DATE '2021-05-30'
      AND Status = '3'
),
Filtered_Appointment AS (
    SELECT *
    FROM Appt
    WHERE Tutor_Unit_College_ID IN (SELECT Unit_Cllge_ID FROM CS_Unit)
      AND ApptDate BETWEEN DATE '2021-05-01' AND DATE '2021-05-30'
      AND Status = '3'
)
SELECT COUNT(oc.ID) AS OnCall_Count, COUNT(a.ID) AS Appointment_Count
FROM Filtered_OnCall oc
JOIN Tutor t ON oc.Tutor_User_ID = t.User_ID AND oc.Tutor_Unit_College_ID = t.Unit_College_ID
CROSS JOIN Filtered_Appointment a
WHERE t.User_ID = 9003;
-------------------------------------------------------------------------------------------------------------------------------------------









-------------------------------------------------------------------------------------------------------------------------------------------
--C442 Phase 4
--Due 04.23.24
--Palmer Vu
-------------------------------------------------------------------------------------------------------------------------------------------
--Task 1
--Creating Tables:

CREATE TABLE Academic_Unit
(
    Unit_Campus_ID VARCHAR2 (20 CHAR) NOT NULL ,
    Unit_ID        VARCHAR2 (20 CHAR) NOT NULL ,
    College_ID     VARCHAR2 (20 CHAR) NOT NULL
) ;
ALTER TABLE Academic_Unit ADD CONSTRAINT Academic_Unit_PK PRIMARY KEY ( Unit_Campus_ID, Unit_ID ) ;

CREATE TABLE Appt
(
    ID                    INTEGER NOT NULL ,
    Location              VARCHAR2 (30 CHAR) ,
    ApptDate              DATE NOT NULL ,
    Start_Time            TIMESTAMP ,
    End_Time              TIMESTAMP ,
    Status                CHAR (1 CHAR) NOT NULL ,
    Tutor_User_ID         INTEGER NOT NULL ,
    Tutor_Unit_College_ID INTEGER NOT NULL ,
    Student_User_ID       INTEGER NOT NULL
) ;
ALTER TABLE Appt ADD CONSTRAINT Appt_PK PRIMARY KEY ( ID ) ;

CREATE TABLE Appt_For_Course
(
    Appt_ID       INTEGER NOT NULL ,
    Course_Code   VARCHAR2 (15 CHAR) NOT NULL ,
    Course_Number INTEGER NOT NULL
) ;
ALTER TABLE Appt_For_Course ADD CONSTRAINT Appt_For_Course_PK PRIMARY KEY ( Appt_ID, Course_Code, Course_Number ) ;

CREATE TABLE Campus
(
    ID      VARCHAR2 (20) NOT NULL ,
    Name    VARCHAR2 (30 CHAR) NOT NULL ,
    Address VARCHAR2 (50 CHAR) ,
    City    VARCHAR2 (20 CHAR) ,
    State   VARCHAR2 (20 CHAR) ,
    Country VARCHAR2 (10 CHAR) ,
    URL     VARCHAR2 (50 CHAR)
) ;
ALTER TABLE Campus ADD CONSTRAINT Campus_PK PRIMARY KEY ( ID ) ;

CREATE TABLE College
(
    ID            VARCHAR2 (20 CHAR) NOT NULL ,
    Name          VARCHAR2 (30 CHAR) NOT NULL ,
    Phone         VARCHAR2 (15 CHAR) ,
    Email         VARCHAR2 (50 CHAR) ,
    URL           VARCHAR2 (50 CHAR) ,
    Campus_ID     VARCHAR2 (20 CHAR) NOT NULL ,
    Unit_Cllge_ID INTEGER
) ;
ALTER TABLE College ADD CONSTRAINT College_PK PRIMARY KEY ( ID ) ;

CREATE TABLE Course
(
    Code          VARCHAR2 (15 CHAR) NOT NULL ,
    "Number"      INTEGER NOT NULL ,
    Title         VARCHAR2 (20 CHAR) NOT NULL ,
    Unit_Cllge_ID INTEGER NOT NULL
) ;
ALTER TABLE Course ADD CONSTRAINT Course_PK PRIMARY KEY ( Code, "Number" ) ;

CREATE TABLE Faculty
(
    User_ID INTEGER NOT NULL , 
    Rank VARCHAR2 (30 CHAR)
) ;
ALTER TABLE Faculty ADD CONSTRAINT Faculty_PK PRIMARY KEY ( User_ID ) ;

CREATE TABLE Non_Academic_Unit
(
    Unit_Campus_ID VARCHAR2 (20 CHAR) NOT NULL ,
    Unit_ID        VARCHAR2 (20 CHAR) NOT NULL ,
    Description    VARCHAR2 (100 CHAR)
) ;
ALTER TABLE Non_Academic_Unit ADD CONSTRAINT Non_Academic_Unit_PK PRIMARY KEY ( Unit_Campus_ID, Unit_ID ) ;

CREATE TABLE OnCall
(
    ID                    INTEGER NOT NULL ,
    Tutor_User_ID         INTEGER NOT NULL ,
    Tutor_Unit_College_ID INTEGER NOT NULL ,
    Faculty_User_ID       INTEGER NOT NULL ,
    Location              VARCHAR2 (100 CHAR) ,
    OnCallDate            DATE NOT NULL ,
    Start_Time            TIMESTAMP ,
    End_Time              TIMESTAMP ,
    task_type             CHAR (1 CHAR) NOT NULL ,
    Status                CHAR (1 CHAR) NOT NULL ,
    Course_Code           VARCHAR2 (15 CHAR) NOT NULL ,
    Course_Number         INTEGER NOT NULL
) ;
ALTER TABLE OnCall ADD CONSTRAINT OnCall_PK PRIMARY KEY ( ID ) ;

CREATE TABLE Student
(
    User_ID   INTEGER NOT NULL ,
    Grad_Flag CHAR (1 CHAR) NOT NULL
) ;
ALTER TABLE Student ADD CONSTRAINT Student_PK PRIMARY KEY ( User_ID ) ;

CREATE TABLE Supervisor
(
    User_ID     INTEGER NOT NULL ,
    Office_Hour VARCHAR2 (40 CHAR)
) ;
ALTER TABLE Supervisor ADD CONSTRAINT Supervisor_PK PRIMARY KEY ( User_ID ) ;

CREATE TABLE Tutor
(
    User_ID         INTEGER NOT NULL ,
    Unit_College_ID INTEGER NOT NULL ,
    Pay_Rate        NUMBER NOT NULL ,
    Supervisor_ID   INTEGER NOT NULL
) ;
ALTER TABLE Tutor ADD CONSTRAINT Tutor_PK PRIMARY KEY ( User_ID, Unit_College_ID ) ;

CREATE TABLE Tutor_Responsible_Courses
(
    Tutor_User_ID         INTEGER NOT NULL ,
    Tutor_Unit_College_ID INTEGER NOT NULL ,
    Course_Code           VARCHAR2 (15 CHAR) NOT NULL ,
    Course_Number         INTEGER NOT NULL
) ;
ALTER TABLE Tutor_Responsible_Courses ADD CONSTRAINT Tutor_Responsible_Courses_PK PRIMARY KEY ( Tutor_User_ID, Tutor_Unit_College_ID, Course_Code, Course_Number ) ;

CREATE TABLE Unit
(
    Campus_ID     VARCHAR2 (20 CHAR) NOT NULL ,
    ID            VARCHAR2 (20 CHAR) NOT NULL ,
    Name          VARCHAR2 (50 CHAR) NOT NULL ,
    Phone         VARCHAR2 (15 CHAR) ,
    Type          CHAR (1 CHAR) NOT NULL ,
    Unit_Cllge_ID INTEGER
) ;
ALTER TABLE Unit ADD CONSTRAINT Unit_PK PRIMARY KEY ( Campus_ID, ID ) ;

CREATE TABLE Unit_Cllge
( ID INTEGER NOT NULL ) ;
ALTER TABLE Unit_Cllge ADD CONSTRAINT Unit_Cllge_PK PRIMARY KEY ( ID ) ;

CREATE TABLE "User"
(
    ID         INTEGER NOT NULL ,
    First_Name VARCHAR2 (20 CHAR) NOT NULL ,
    Last_Name  VARCHAR2 (30 CHAR) NOT NULL ,
    Email      VARCHAR2 (50 CHAR)
) ;
ALTER TABLE "User" ADD CONSTRAINT User_PK PRIMARY KEY ( ID ) ;

CREATE TABLE User_Phone
(
    USER_ID INTEGER NOT NULL ,
    Phone   VARCHAR2 (15 CHAR) NOT NULL
) ;
ALTER TABLE User_Phone ADD CONSTRAINT User_Phone_PK PRIMARY KEY ( USER_ID, Phone ) ;

ALTER TABLE Academic_Unit ADD CONSTRAINT Academic_Unit_College_FK FOREIGN KEY ( College_ID ) REFERENCES College ( ID ) ;

ALTER TABLE Academic_Unit ADD CONSTRAINT Academic_Unit_Unit_FK FOREIGN KEY ( Unit_Campus_ID, Unit_ID ) REFERENCES Unit ( Campus_ID, ID ) ;

ALTER TABLE Appt_For_Course ADD CONSTRAINT Appt_For_Course_Appt_FK FOREIGN KEY ( Appt_ID ) REFERENCES Appt ( ID ) ;

ALTER TABLE Appt_For_Course ADD CONSTRAINT Appt_For_Course_Course_FK FOREIGN KEY ( Course_Code, Course_Number ) REFERENCES Course ( Code, "Number" ) ;

ALTER TABLE Appt ADD CONSTRAINT Appt_Student_FK FOREIGN KEY ( Student_User_ID ) REFERENCES Student ( User_ID ) ;

ALTER TABLE Appt ADD CONSTRAINT Appt_Tutor_FK FOREIGN KEY ( Tutor_User_ID, Tutor_Unit_College_ID ) REFERENCES Tutor ( User_ID, Unit_College_ID ) ;

ALTER TABLE College ADD CONSTRAINT College_Campus_FK FOREIGN KEY ( Campus_ID ) REFERENCES Campus ( ID ) ;

ALTER TABLE College ADD CONSTRAINT College_Unit_Cllge_FK FOREIGN KEY ( Unit_Cllge_ID ) REFERENCES Unit_Cllge ( ID ) ;

ALTER TABLE Course ADD CONSTRAINT Course_Unit_Cllge_FK FOREIGN KEY ( Unit_Cllge_ID ) REFERENCES Unit_Cllge ( ID ) ;

ALTER TABLE Faculty ADD CONSTRAINT Faculty_User_FK FOREIGN KEY ( User_ID ) REFERENCES "User" ( ID ) ;

ALTER TABLE Non_Academic_Unit ADD CONSTRAINT Non_Academic_Unit_Unit_FK FOREIGN KEY ( Unit_Campus_ID, Unit_ID ) REFERENCES Unit ( Campus_ID, ID ) ;

ALTER TABLE OnCall ADD CONSTRAINT OnCall_Course_FK FOREIGN KEY ( Course_Code, Course_Number ) REFERENCES Course ( Code, "Number" ) ;

ALTER TABLE OnCall ADD CONSTRAINT OnCall_Faculty_FK FOREIGN KEY ( Faculty_User_ID ) REFERENCES Faculty ( User_ID ) ;

ALTER TABLE OnCall ADD CONSTRAINT OnCall_Tutor_FK FOREIGN KEY ( Tutor_User_ID, Tutor_Unit_College_ID ) REFERENCES Tutor ( User_ID, Unit_College_ID ) ;

ALTER TABLE Student ADD CONSTRAINT Student_User_FK FOREIGN KEY ( User_ID ) REFERENCES "User" ( ID ) ;

ALTER TABLE Supervisor ADD CONSTRAINT Supervisor_Faculty_FK FOREIGN KEY ( User_ID ) REFERENCES Faculty ( User_ID ) ;

ALTER TABLE Tutor_Responsible_Courses ADD CONSTRAINT TRC_Course_FK FOREIGN KEY ( Course_Code, Course_Number ) REFERENCES Course ( Code, "Number" ) ON DELETE CASCADE ;

ALTER TABLE Tutor_Responsible_Courses ADD CONSTRAINT TRC_Tutor_FK FOREIGN KEY ( Tutor_User_ID, Tutor_Unit_College_ID ) REFERENCES Tutor ( User_ID, Unit_College_ID ) ON DELETE CASCADE ;

ALTER TABLE Tutor ADD CONSTRAINT Tutor_Supervisor_FK FOREIGN KEY ( Supervisor_ID ) REFERENCES Supervisor ( User_ID ) ;

ALTER TABLE Tutor ADD CONSTRAINT Tutor_Unit_Cllge_FK FOREIGN KEY ( Unit_College_ID ) REFERENCES Unit_Cllge ( ID ) ;

ALTER TABLE Tutor ADD CONSTRAINT Tutor_User_FK FOREIGN KEY ( User_ID ) REFERENCES "User" ( ID ) ;

ALTER TABLE Unit ADD CONSTRAINT UnitCollege_FK FOREIGN KEY ( Unit_Cllge_ID ) REFERENCES Unit_Cllge ( ID ) ;

ALTER TABLE Unit ADD CONSTRAINT Unit_Campus_FK FOREIGN KEY ( Campus_ID ) REFERENCES Campus ( ID ) ;

ALTER TABLE User_Phone ADD CONSTRAINT User_Phone_User_FK FOREIGN KEY ( USER_ID ) REFERENCES "User" ( ID ) ON DELETE CASCADE ;
-------------------------------------------------------------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------------------------------------------------------------
--Task 1
--Populate Tables:

--- Table 1
INSERT INTO campus (id, name) VALUES ('iusb', 'IU South Bend');
INSERT INTO campus (id, name) VALUES ('iub', 'IU Bloomington');
INSERT INTO campus (id, name) VALUES ('iuk', 'IU Kokomo');

--- Table 2
--101: iusb CLAS College
--102: iusb Business School
--103: iusb Financial Aid
--201: iub School of Informatics
--104: iusb Computer Science
--105: iusb Mathematics

INSERT INTO unit_cllge VALUES (101); 
INSERT INTO unit_cllge VALUES (102); 
INSERT INTO unit_cllge VALUES (103); 
INSERT INTO unit_cllge VALUES (201); 
INSERT INTO unit_cllge VALUES (104); 
INSERT INTO unit_cllge VALUES (105); 

--- Table 3
INSERT INTO college (id, name, campus_id, unit_cllge_id) VALUES ('CLAS', 'College of LAS', 'iusb', 101);
INSERT INTO college (id, name, campus_id, unit_cllge_id) VALUES ('Business', 'School of Business', 'iusb', 102);
INSERT INTO college (id, name, campus_id, unit_cllge_id) VALUES ('Informatics', 'School of Informatics', 'iub', 201);

--- Table 4
INSERT INTO unit VALUES ('iusb', 'CS', 'Computer Science Department', '574-520-5555', 'A', 104);
INSERT INTO unit VALUES ('iusb', 'MATH', 'Mathematics Department', '574-520-5545', 'A', 105);
INSERT INTO unit VALUES ('iusb', 'FA', 'Financial Aid Department', '999-520-5545', 'N', 103);

--- Table 5
INSERT INTO academic_unit VALUES ('iusb', 'CS', 'CLAS');
INSERT INTO academic_unit VALUES ('iusb', 'MATH', 'CLAS');

--- Table 6
INSERT INTO non_academic_unit VALUES ('iusb', 'FA', 'Financial Aid Service');

--- Table 7
INSERT INTO "User" VALUES (9001, 'Janet', 'Omi', 'jim@iu.edu');
INSERT INTO "User" VALUES (9002, 'Jane', 'Tim', 'jom@iu.edu');
INSERT INTO "User" VALUES (9003, 'Janet', 'Lew', 'jum@iu.edu');
INSERT INTO "User" VALUES (9004, 'Jant', 'Goth', 'jkm@iu.edu');
INSERT INTO "User" VALUES (9005, 'Bnnet', 'Maha', 'jdm@iu.edu');
INSERT INTO "User" VALUES (9006, 'Net', 'Maeh', 'jcm@iu.edu');
INSERT INTO "User" VALUES (9007, 'Jet', 'Hith', 'jbm@iu.edu');
INSERT INTO "User" VALUES (9008, 'Jt', 'Doug', 'jnm@iu.edu');
INSERT INTO "User" VALUES (9009, 'Jet', 'Dith', 'jsm@iu.edu');
INSERT INTO "User" VALUES (9010, 'Jim', 'Champ', 'jam@iu.edu');
INSERT INTO "User" VALUES (9011, 'Tim', 'Power', 'jqm@iu.edu');

--- Table 8
INSERT INTO user_phone VALUES (9001, '574-909-9876');

--- Table 9
INSERT INTO faculty VALUES (9001, 'FP');
INSERT INTO faculty VALUES (9002, 'AP');
INSERT INTO faculty VALUES (9004, 'AP');
INSERT INTO faculty VALUES (9006, 'AP');
INSERT INTO faculty VALUES (9011, 'FP');

--- Table 10
INSERT INTO student VALUES (9003, 'u');
INSERT INTO student VALUES (9005, 'u');
INSERT INTO student VALUES (9004, 'g');
INSERT INTO student VALUES (9006, 'g');
INSERT INTO student VALUES (9007, 'g');
INSERT INTO student VALUES (9008, 'u');
INSERT INTO student VALUES (9009, 'u');
INSERT INTO student VALUES (9010, 'u');

--- Table 11
INSERT INTO supervisor VALUES (9001, 'MW: 1-2Pm');

--- Table 12
INSERT INTO tutor VALUES (9002, 101, 20.5, 9001);
INSERT INTO tutor VALUES (9003, 101, 10.5, 9001);
INSERT INTO tutor VALUES (9003, 104, 15.5, 9001);
INSERT INTO tutor VALUES (9004, 104, 16.5, 9001);
INSERT INTO tutor VALUES (9010, 101, 11.5, 9001);
INSERT INTO tutor VALUES (9010, 104, 17.5, 9001);

--- Table 13
INSERT INTO course VALUES ('IUSBCSCI', 101, 'Programming 1', 104);
INSERT INTO course VALUES ('IUSBCSCI', 201, 'Programming 2', 104);

--- Table 14
INSERT INTO tutor_responsible_courses VALUES (9002, 101, 'IUSBCSCI', 101);
INSERT INTO tutor_responsible_courses VALUES (9003, 101, 'IUSBCSCI', 101);
INSERT INTO tutor_responsible_courses VALUES (9003, 104, 'IUSBCSCI', 201);
INSERT INTO tutor_responsible_courses VALUES (9003, 104, 'IUSBCSCI', 101);
INSERT INTO tutor_responsible_courses VALUES (9004, 104, 'IUSBCSCI', 101);
INSERT INTO tutor_responsible_courses VALUES (9004, 104, 'IUSBCSCI', 201);
INSERT INTO tutor_responsible_courses VALUES (9010, 104, 'IUSBCSCI', 101);
INSERT INTO tutor_responsible_courses VALUES (9010, 101, 'IUSBCSCI', 201);

--- Table 15
--C: class; L: lab; E: exam

INSERT INTO oncall (id, tutor_user_id, tutor_unit_college_id, faculty_user_id, oncalldate, task_type, status, course_code, course_number) VALUES (801, 9003, 104, 9011, '19-MAY-2021', 'E', '3', 'IUSBCSCI', 101);

INSERT INTO oncall (id, tutor_user_id, tutor_unit_college_id, faculty_user_id, oncalldate, task_type, status, course_code, course_number) VALUES (802, 9003, 104, 9011, '19-JUN-2021', 'C', '3', 'IUSBCSCI', 101);

INSERT INTO oncall (id, tutor_user_id, tutor_unit_college_id, faculty_user_id, oncalldate, task_type, status, course_code, course_number) VALUES (803, 9003, 104, 9011, '19-APR-2021', 'L', '3', 'IUSBCSCI', 101);

INSERT INTO oncall (id, tutor_user_id, tutor_unit_college_id, faculty_user_id, oncalldate, task_type, status, course_code, course_number) VALUES (804, 9003, 104, 9011, '29-MAY-2021', 'E', '2', 'IUSBCSCI', 101);

INSERT INTO oncall (id, tutor_user_id, tutor_unit_college_id, faculty_user_id, oncalldate, task_type, status, course_code, course_number) VALUES (805, 9003, 101, 9011, '09-MAY-2021', 'C', '3', 'IUSBCSCI', 101);

INSERT INTO oncall (id, tutor_user_id, tutor_unit_college_id, faculty_user_id, oncalldate, task_type, status, course_code, course_number) VALUES (806, 9004, 104, 9011, '27-MAY-2021', 'L', '3', 'IUSBCSCI', 201);

--- Table 16
INSERT INTO appt (id, apptdate, status, tutor_user_id, tutor_unit_college_id, student_user_id) VALUES (701, '15-MAY-2021', '3', 9003, 104, 9010);

INSERT INTO appt (id, apptdate, status, tutor_user_id, tutor_unit_college_id, student_user_id) VALUES (702, '05-MAY-2021', '2', 9003, 104, 9010);

INSERT INTO appt (id, apptdate, status, tutor_user_id, tutor_unit_college_id, student_user_id) VALUES (703, '15-JUN-2021', '3', 9003, 104, 9010);

INSERT INTO appt (id, apptdate, status, tutor_user_id, tutor_unit_college_id, student_user_id) VALUES (704, '15-APR-2021', '3', 9003, 104, 9010);

INSERT INTO appt (id, apptdate, status, tutor_user_id, tutor_unit_college_id, student_user_id) VALUES (705, '10-MAY-2021', '3', 9003, 104, 9008);

INSERT INTO appt (id, apptdate, status, tutor_user_id, tutor_unit_college_id, student_user_id) VALUES (706, '18-MAY-2021', '3', 9003, 101, 9009);

INSERT INTO appt (id, apptdate, status, tutor_user_id, tutor_unit_college_id, student_user_id) VALUES (707, '13-MAY-2021', '3', 9004, 104, 9010);

--- Table 17
INSERT INTO appt_for_course VALUES (701, 'IUSBCSCI', 101);
INSERT INTO appt_for_course VALUES (702, 'IUSBCSCI', 101);
INSERT INTO appt_for_course VALUES (703, 'IUSBCSCI', 101);
INSERT INTO appt_for_course VALUES (704, 'IUSBCSCI', 101);
INSERT INTO appt_for_course VALUES (705, 'IUSBCSCI', 101);
INSERT INTO appt_for_course VALUES (706, 'IUSBCSCI', 101);
INSERT INTO appt_for_course VALUES (707, 'IUSBCSCI', 101);
INSERT INTO appt_for_course VALUES (707, 'IUSBCSCI', 201);
-------------------------------------------------------------------------------------------------------------------------------------------
