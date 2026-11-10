-- =====================================================================
-- ISYS2099 | ISYS3434 Week 3 tutorial: COMPANY database WITH keys
--
-- Creates the database `company` from scratch, with primary keys,
-- UNIQUE constraints and foreign keys (so InnoDB builds their indexes).
--
-- How to run: open this file in MySQL Workbench, make sure no text is
-- selected, and run the whole script (lightning icon, or
-- Ctrl + Shift + Enter on Windows / Cmd + Shift + Return on macOS).
--
-- WARNING: this first drops any existing database called `company`,
-- including the Week 1 Sample DB if you loaded it under that name.
-- The script can be run again at any time to get a clean copy.
-- =====================================================================

DROP DATABASE IF EXISTS company;
CREATE DATABASE company;
USE company;

CREATE TABLE EMPLOYEE
(
  Fname VARCHAR(10) NOT NULL,
  Minit CHAR,
  Lname VARCHAR(20) NOT NULL,
  Ssn CHAR(9) NOT NULL,
  Bdate DATE,
  Address VARCHAR(30),
  Sex CHAR(1),
  Salary DECIMAL(5),
  Super_ssn CHAR(9),
  Dno INT NOT NULL,
  PRIMARY KEY (Ssn)
) ENGINE = InnoDB;

CREATE TABLE DEPARTMENT
(
  Dname VARCHAR(15) NOT NULL,
  Dnumber INT NOT NULL,
  Mgr_ssn CHAR(9) NOT NULL,
  Mgr_start_date DATE,
  PRIMARY KEY (Dnumber),
  UNIQUE (Dname),
  FOREIGN KEY (Mgr_ssn) REFERENCES EMPLOYEE(Ssn)
) ENGINE = InnoDB;

CREATE TABLE DEPT_LOCATIONS
(
  Dnumber INT NOT NULL,
  Dlocation VARCHAR(15) NOT NULL,
  PRIMARY KEY (Dnumber, Dlocation),
  FOREIGN KEY (Dnumber) REFERENCES DEPARTMENT(Dnumber)
) ENGINE = InnoDB;

CREATE TABLE PROJECT
(
  Pname VARCHAR(15) NOT NULL,
  Pnumber INT NOT NULL,
  Plocation VARCHAR(15),
  Dnum INT NOT NULL,
  PRIMARY KEY (Pnumber),
  UNIQUE (Pname),
  FOREIGN KEY (Dnum) REFERENCES DEPARTMENT(Dnumber)
) ENGINE = InnoDB;

CREATE TABLE WORKS_ON
(
  Essn CHAR(9) NOT NULL,
  Pno INT NOT NULL,
  Hours DECIMAL(3,1) NOT NULL,
  PRIMARY KEY (Essn, Pno),
  FOREIGN KEY (Essn) REFERENCES EMPLOYEE(Ssn),
  FOREIGN KEY (Pno) REFERENCES PROJECT(Pnumber)
) ENGINE = InnoDB;

CREATE TABLE DEPENDENT
(
  Essn CHAR(9) NOT NULL,
  Dependent_name VARCHAR(15) NOT NULL,
  Sex CHAR,
  Bdate DATE,
  Relationship VARCHAR(8),
  PRIMARY KEY (Essn, Dependent_name),
  FOREIGN KEY (Essn) REFERENCES EMPLOYEE(Ssn)
) ENGINE = InnoDB;

INSERT INTO EMPLOYEE VALUES
('John','B','Smith',123456789,'1965-01-09','731 Fondren, Houston TX','M',30000,333445555,5),
('Franklin','T','Wong',333445555,'1965-12-08','638 Voss, Houston TX','M',40000,888665555,5),
('Alicia','J','Zelaya',999887777,'1968-01-19','3321 Castle, Spring TX','F',25000,987654321,4),
('Jennifer','S','Wallace',987654321,'1941-06-20','291 Berry, Bellaire TX','F',43000,888665555,4),
('Ramesh','K','Narayan',666884444,'1962-09-15','975 Fire Oak, Humble TX','M',38000,333445555,5),
('Joyce','A','English',453453453,'1972-07-31','5631 Rice, Houston TX','F',25000,333445555,5),
('Ahmad','V','Jabbar',987987987,'1969-03-29','980 Dallas, Houston TX','M',25000,987654321,4),
('James','E','Borg',888665555,'1937-11-10','450 Stone, Houston TX','M',55000,null,1);

INSERT INTO DEPARTMENT VALUES
('Research',5,333445555,'1988-05-22'),
('Administration',4,987654321,'1995-01-01'),
('Headquarters',1,888665555,'1981-06-19');

INSERT INTO PROJECT VALUES
('ProductX',1,'Bellaire',5),
('ProductY',2,'Sugarland',5),
('ProductZ',3,'Houston',5),
('Computerization',10,'Stafford',4),
('Reorganization',20,'Houston',1),
('Newbenefits',30,'Stafford',4);

INSERT INTO WORKS_ON VALUES
(123456789,1,32.5),
(123456789,2,7.5),
(666884444,3,40.0),
(453453453,1,20.0),
(453453453,2,20.0),
(333445555,2,10.0),
(333445555,3,10.0),
(333445555,10,10.0),
(333445555,20,10.0),
(999887777,30,30.0),
(999887777,10,10.0),
(987987987,10,35.0),
(987987987,30,5.0),
(987654321,30,20.0),
(987654321,20,15.0),
(888665555,20,16.0);

INSERT INTO DEPENDENT VALUES
(333445555,'Alice','F','1986-04-04','Daughter'),
(333445555,'Theodore','M','1983-10-25','Son'),
(333445555,'Joy','F','1958-05-03','Spouse'),
(987654321,'Abner','M','1942-02-28','Spouse'),
(123456789,'Michael','M','1988-01-04','Son'),
(123456789,'Alice','F','1988-12-30','Daughter'),
(123456789,'Elizabeth','F','1967-05-05','Spouse');

INSERT INTO DEPT_LOCATIONS VALUES
(1,'Houston'),
(4,'Stafford'),
(5,'Bellaire'),
(5,'Sugarland'),
(5,'Houston');
-- Foreign keys on EMPLOYEE are added after the data is loaded, because
-- EMPLOYEE and DEPARTMENT reference each other and EMPLOYEE references
-- itself. InnoDB creates an index for each one (named Super_ssn and Dno).
ALTER TABLE EMPLOYEE
  ADD FOREIGN KEY (Super_ssn) REFERENCES EMPLOYEE(Ssn),
  ADD FOREIGN KEY (Dno) REFERENCES DEPARTMENT(Dnumber);

-- Check: expect EMPLOYEE 8, DEPARTMENT 3, DEPENDENT 7, PROJECT 6,
-- WORKS_ON 16, DEPT_LOCATIONS 5; and indexes PRIMARY, Super_ssn, Dno.
SELECT 'EMPLOYEE' AS tbl, COUNT(*) AS n FROM EMPLOYEE
UNION ALL SELECT 'DEPARTMENT', COUNT(*) FROM DEPARTMENT
UNION ALL SELECT 'DEPENDENT', COUNT(*) FROM DEPENDENT
UNION ALL SELECT 'PROJECT', COUNT(*) FROM PROJECT
UNION ALL SELECT 'WORKS_ON', COUNT(*) FROM WORKS_ON
UNION ALL SELECT 'DEPT_LOCATIONS', COUNT(*) FROM DEPT_LOCATIONS;
SHOW INDEXES FROM EMPLOYEE;
