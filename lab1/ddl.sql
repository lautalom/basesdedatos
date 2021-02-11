USE test;
               
CREATE TABLE department  
(
  dname CHAR(15) NOT NULL,
  dnumber INT    NOT NULL,
  mgrssn CHAR(9) NOT NULL,
  mgrstartdate DATE,
  CONSTRAINT deptPK PRIMARY KEY (dnumber),
  CONSTRAINT deptNameSK UNIQUE (dname)
) ENGINE=InnoDB;           

CREATE TABLE dept_loc    
(
  dnumber INT            NOT NULL,
  dlocation CHAR(10)     NOT NULL,
  CONSTRAINT deptLocPK PRIMARY KEY (dnumber,dlocation),
  CONSTRAINT deptLocFK FOREIGN KEY (dnumber) REFERENCES department(dnumber)
) ENGINE=InnoDB;

CREATE TABLE employee    
(
  fname CHAR(9) NOT NULL,
  minit CHAR(1),      
  lname CHAR(8) NOT NULL,
  ssn   CHAR(9) NOT NULL,
  bdate DATE, 
  address CHAR(25),   
  sex   CHAR(1),      
  salary DECIMAL(7,2),    
  superssn CHAR(9),   
  dno  INT DEFAULT 1 NOT NULL,
  CONSTRAINT employeePK PRIMARY KEY (ssn),
  CONSTRAINT empDeptFK FOREIGN KEY (dno) REFERENCES department(dnumber)
) ENGINE=InnoDB;
           
           
           
CREATE TABLE project 
(
  pname   CHAR(15)       NOT NULL,
  pnumber INT            NOT NULL,
  plocation CHAR(10), 
  dnum    INT            NOT NULL,
  CONSTRAINT projPK PRIMARY KEY (pnumber),
  CONSTRAINT projNameSK UNIQUE (pname),
  CONSTRAINT projDeptFK FOREIGN KEY (dnum) REFERENCES department(dnumber)
) ENGINE=InnoDB;
           
CREATE TABLE works_on    
(
  essn CHAR(9)           NOT NULL,
  pno  INT               NOT NULL,
  hours DECIMAL(5,1)     NOT NULL,
  CONSTRAINT workPK PRIMARY KEY (essn, pno),
  CONSTRAINT workEmpFK FOREIGN KEY (essn) REFERENCES employee(ssn),
  CONSTRAINT workProjFK FOREIGN KEY (pno) REFERENCES project(pnumber)
) ENGINE=InnoDB;                              
           
CREATE TABLE dependent   
(
  essn CHAR(9)           NOT NULL,
  name CHAR(10)          NOT NULL,
  sex  CHAR(1),       
  bdate DATE, 
  relationship CHAR(10),
  CONSTRAINT dependentPK PRIMARY KEY (essn, name),
  CONSTRAINT dependentEmpFK FOREIGN KEY (essn) REFERENCES employee(ssn)
) ENGINE=InnoDB;
