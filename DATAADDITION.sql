USE ASSIGNMENT2BTD210


-- The Professors Table
CREATE TABLE Professors (
    Professor_ID INT PRIMARY KEY,
    Professor_Name VARCHAR(255) NOT NULL
);

CREATE TABLE Courses (
   Course_Code VARCHAR(20) PRIMARY KEY,   
    Course_Title VARCHAR(255) NOT NULL,        
    Course_Description TEXT,                               
    Contact_Hours_Per_Week INT NOT NULL,   
	Developed_By INT NOT NULL ,   
FOREIGN KEY (Developed_By) REFERENCES Professors(Professor_ID)
ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Textbooks (
  Textbook_ISBN VARCHAR(255) PRIMARY KEY,
    Textbook_Requirement VARCHAR(255)
);



-- The Course Learning Outcomes (CLOs) Table`
CREATE TABLE CLOs (
    CLOs_ID INT,
	Course_Code VARCHAR(20),
	CLO_Description TEXT NOT NULL,
PRIMARY KEY(CLOs_ID, Course_Code),
FOREIGN KEY (Course_Code) REFERENCES Courses(Course_Code)
ON DELETE CASCADE ON UPDATE CASCADE
);

-- The Graduate Attributes (GAs) Table
CREATE TABLE GAs (
		GAs_ID INT PRIMARY KEY,
        GAs_Description VARCHAR(255) NOT NULL
);

-- The Program Learning Outcomes (PLOs) Table
CREATE TABLE PLOs (
    PLOs_ID INT PRIMARY KEY,
    PLO_Description VARCHAR(255) NOT NULL
);
 

CREATE TABLE Sections (
     Section_UniqueID INT PRIMARY KEY,
     Section_ID VARCHAR(50) NOT NULL,  
     Course_Code VARCHAR(20),
     Semester_ID VARCHAR(50),
     Professor_ID INT,
     FOREIGN KEY (Course_Code) REFERENCES Courses(Course_Code)
         ON DELETE CASCADE ON UPDATE CASCADE,
     FOREIGN KEY (Professor_ID) REFERENCES Professors(Professor_ID)
         ON DELETE NO ACTION ON UPDATE NO ACTION
);




-- The Course_Textbooks Bridge
CREATE TABLE Course_Textbooks (
    Textbook_ISBN VARCHAR(255) NULL,
    Course_Code VARCHAR(20),
    PRIMARY KEY (Course_Code), -- Primary key is only on Course_Code
    FOREIGN KEY (Textbook_ISBN) REFERENCES Textbooks(Textbook_ISBN)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Course_Code) REFERENCES Courses(Course_Code)
    ON DELETE NO ACTION ON UPDATE NO ACTION
);


-- The Course_PLOs Bridge
CREATE TABLE Course_PLOs (
   Course_Code VARCHAR(20) NOT NULL,
    PLOs_ID INT NOT NULL,
    PRIMARY KEY (Course_Code, PLOs_ID),
FOREIGN KEY (Course_Code) REFERENCES Courses(Course_Code)
ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (PLOs_ID) REFERENCES PLOs(PLOs_ID)
ON DELETE CASCADE ON UPDATE CASCADE
);

-- The Course_GAs Bridge
CREATE TABLE Course_GAs (
     GAs_ID INT,
    Course_Code VARCHAR(20),
    PRIMARY KEY (GAs_ID, Course_Code),
FOREIGN KEY (GAs_ID) REFERENCES GAs(GAs_ID)
ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (Course_Code) REFERENCES Courses(Course_Code)
ON DELETE CASCADE ON UPDATE CASCADE
);

 --Prerequisite table
CREATE TABLE Prerequisite ( 
    Prerequisite_ID INT PRIMARY KEY, 
    Course_Code VARCHAR(20), 
    Prerequisite_Code VARCHAR(20), 
    FOREIGN KEY (Course_Code) REFERENCES Courses(Course_Code) 
        ON DELETE CASCADE ON UPDATE CASCADE, 
);

-- Creating the modified Section_Professors Bridge Table
CREATE TABLE Sections_Professors (
     Section_UniqueID INT,
    Professor_ID INT,
    PRIMARY KEY (Section_UniqueID, Professor_ID),
    FOREIGN KEY (Section_UniqueID) REFERENCES Sections(Section_UniqueID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Professor_ID) REFERENCES Professors(Professor_ID)
        ON DELETE NO ACTION ON UPDATE NO ACTION
);


-- Inserting professors data for SES250NAA_2244 (Electromagnetics)
INSERT INTO Professors (Professor_ID, Professor_Name)
VALUES (001, 'Arif Obaid'),
       (002, 'Jacky Lau'),
	   (003, 'Mufleh Al-Shatnawi'),
	   (004, 'Ali Sanaee'),
	   (005, 'Allan Randall'),
	   (006, 'Kifah Al-Ansari'),
	   (007, 'Vida Movahedi');
INSERT INTO Courses (Course_Code, Course_Title, Course_Description, Contact_Hours_Per_Week, Developed_By)
VALUES 
    ( 'SEM305' , 'Discrete Mathematics', 'The mathematics of modern computer science is built almost entirely on discrete math. Students are introduced to discrete structures in order to formulate abstract concepts and techniques using the language of propositional and predicate logic and set theory.', 4, 001),
    ( 'MEC110' , 'Mechanics', 'This course introduces the subject of statics. The study of particles and rigid bodies in equilibrium. Students study, and solve problems involving, the equilibrium of particles and rigid bodies in two and in three dimensions.', 6, 002),
    ( 'SES250' , 'Electromagnetics', 'Students are introduced to electrostatics, magnetism and circuit theory with an emphasis on circuit and machine design. Electromagnetics is the foundation of all studies in electronics, wireless communications, and electrical machines. Electromagnetism is one of the four fundamental interactions (commonly called forces) in nature, together with the strong interaction, the weak interaction, and gravitation.', 6, 002),
    ( 'BTD210' , 'Database Design Principles', 'This course introduces the principles of relational database design and use. Students learn a methodology for relational database design that uses Entity Relationship Diagrams and normalization of data. The design is then used to create a database schema, and to implement a database by using an introductory subset of SQL (Structured Query Language). Students also use SQL to perform query and data modification operations. A modern and a widely-used database server is used to host the database.', 4, 007),
    ( 'SEH300' , 'Digital and Analog Circuits', 'An introduction to the basic concepts of electricity, magnetism, electric circuits, and basic combinational and sequential digital circuits. Students develop an understanding of microprocessors and computer architecture in software-driven hardware. DC and AC driven circuits, and digital circuits are studied in detail. Fundamental electronic components are examined such as resistors, inductors, capacitors, diodes, transistors, operational amplifiers, and digital logic gates.', 4, 006);



 --Inserting textbooks data for SEM305
INSERT INTO Textbooks (Textbook_ISBN, Textbook_Requirement)
VALUES ('978-1260091991', 'Discrete Mathematics and Its Applications (8th Edition) by Kenneth H. Rosen, McGraw-Hill Education');

 --Inserting textbooks data for MEC110
INSERT INTO Textbooks (Textbook_ISBN, Textbook_Requirement)
VALUES ('978-0070799233', 'Vector Mechanics for Engineers: Statics and Dynamics (5th Edition) by Ferdinand P. Beer and E. Russell Johnston Jr., McGraw-Hill');

 --Inserting textbooks data for SES250 (Electromagnetics)
INSERT INTO Textbooks (Textbook_ISBN, Textbook_Requirement)
VALUES ('978-1107014022', 'Electricity and Magnetism by Edward M. Purcell and David J. Morin, Cambridge University Press');

 --Inserting textbooks data for BTD210 (Database Design Principles)
INSERT INTO Textbooks (Textbook_ISBN, Textbook_Requirement)
VALUES ('978-1305627482', 'Database Systems: Design, Implementation, & Management (12th Edition) by Carlos Coronel and Steven Morris, Course Technology');

 -- Inserting data into the Course_Textbooks Bridge Table
INSERT INTO Course_Textbooks (Course_Code, Textbook_ISBN)
VALUES
 --SEM305 (Discrete Mathematics)
( 'SEM305' , '978-1260091991'),

 --MEC110 (Statics and Dynamics)
( 'MEC110' , '978-0070799233'),

 --SES250 (Electromagnetics)
( 'SES250' , '978-1107014022'),

 --BTD210 (Database Design Principles)
( 'BTD210' , '978-1305627482'),

 --SEH300 (Digital and Analog Circuits)
( 'SEH300' , NULL);





 --Inserting CLOs for Mechanics (MEC110)
INSERT INTO CLOs (CLOs_ID, Course_Code, CLO_Description)
VALUES 
(1, 'MEC110', 'Calculate the resultant of a number of concurrent forces in two or three dimensions'),
(2, 'MEC110', 'Calculate the magnitude and direction of a force required to keep a given force system in equilibrium'),
(3, 'MEC110', 'Draw a free-body diagram of a particle acted on by forces and use the diagram as an aid to calculate the magnitudes and directions of the unknown force(s) if equilibrium is to be obtained'),
(4, 'MEC110', 'Use the concepts of moments and couples to calculate the single force and the single couple which is equivalent to a system of coplanar couples and/or non-concurrent forces'),
(5, 'MEC110', 'Define a rigid body and use free body diagrams to aid in solving for the unknown forces and/or couples required to maintain a two-dimensional rigid body in equilibrium'),
(6, 'MEC110', 'Calculate the coordinates of the centroids of plane areas and of the centers of gravity of homogeneous plates having uniform thickness. Calculate the magnitude and locate the line of action of that single force which is equivalent to a distributed load using the concept of the centroid of area'),
(7, 'MEC110', 'Calculate the magnitudes of the unknown forces acting in some or all of the members of a truss, machine or frame which is acted on by a number of external forces and/or couples and which is in equilibrium'),
(8, 'MEC110', 'Explain dry friction and use the equations of dry friction to solve the problems of statics equilibrium');

 --Inserting CLOs for Electromagnetics (SES250)
INSERT INTO CLOs (CLOs_ID, Course_Code, CLO_Description)
VALUES 
(1, 'SES250', 'Examine electrostatic induction in machines for commercial applications'),
(2, 'SES250', 'Explore the role of electrical resistance in controlling current and voltage inhardware applications'),
(3, 'SES250', 'Apply magnetic induction to electric motors.'),
(4, 'SES250', 'Connect the interaction between electric and magnetic fields in simple circuits'),
(5, 'SES250', 'Predict component current and voltage for various circuit configurations'),
(6, 'SES250', 'Design simple AC and DC circuits for electrical power transfe');

 --Inserting CLOs for DiSCRETE MATHEMATICS (SEM305)
INSERT INTO CLOs (CLOs_ID, Course_Code, CLO_Description)
VALUES 
(1, 'SEM305', 'Compare logical constructs and proofs to verify mathematical statements'),
(2, 'SEM305', 'Arrange sets as a building block for the types of objects considered in discrete mathematics'),
(3, 'SEM305', 'Construct matrices for mathematical transformations of physical systems'),
(4, 'SEM305', 'Classify algorithms according to growth to minimize computing time'),
(5, 'SEM305', 'Apply the principles of induction for mathematical proofs'),
(6, 'SEM305', 'Assemble graphs to show the relationships between objects'),
(7, 'SEM305', 'Construct trees to model computer algorithms'),
(8, 'SEM305', 'Design logic circuits using the principles of Boolean algebra');

 --Inserting CLOs for DiGITAL ANALOG (SEH300)
INSERT INTO CLOs (CLOs_ID, Course_Code, CLO_Description)
VALUES 
(1, 'SEH300', 'Apply engineering fundamentals to solve hardware problems'),
(3, 'SEH300', 'Employ the operating modes of analog electronic components for linear or non-linear operation'),
(4, 'SEH300', 'Design simple analog circuits for low power and high-power applications'),
(5, 'SEH300', 'Characterize digital components for combinational or sequential operation'),
(6, 'SEH300', 'Create simple digital circuits for synchronous or asynchronous applications'),
(7, 'SEH300', 'Design mixed analog and digital circuit design for interfacing to a computer');

-- Inserting CLOs for Database Design Principles (BTD210)
INSERT INTO CLOs(CLOs_ID, Course_Code, CLO_Description)
VALUES 
(1, 'BTD210', 'Compose SQL to retrieve data from databases'),
(2, 'BTD210', 'Compose SQL to create and modify tables in databases'),
(3, 'BTD210', 'Prepare a physical relational database schema for specific business applications'),
(4, 'BTD210', 'Prepare a logical relational database schema for specific business applications'),
(5, 'BTD210', 'Compose an Entity Relationship Diagram for specific business applications'),
(6, 'BTD210', 'Re-organize data to third normal form'),
(7, 'BTD210', 'Distinguish the differences between relational, hierarchical and network databases'),
(8, 'BTD210', 'Differentiate between the basic functions of a Database Management System'),
(9, 'BTD210', 'Describe the responsibilities of a Database administrator in an organization'),
(10,'BTD210', 'Compose such specialized material as Entity Relationship Diagrams, normalized database schemas and databases');


 --prerequisite table
INSERT INTO Prerequisite (
Prerequisite_ID, Course_Code, Prerequisite_Code) VALUES 
(1, 'SES250', 'MEC110'), 
(2, 'SEH300', 'SES250'),
(3, 'SEH300', 'SEM305');



 --Inserting Graduate Attributes (GAs)
INSERT INTO GAs (GAs_ID, GAs_Description)
VALUES
(1, 'Knowledge Base'),
(2, 'Problem Analysis'),
(3, 'Investigation'),
(4, 'Design'),
(5, 'Use of Engineering Tools'),
(6, 'Individual and Team Work'),
(7, 'Communication Skills'),
(8, 'Professionalism'),
(9, 'Impact on Society and the Environment'),
(10, 'Ethics and Equity'),
(11, 'Economics and Project Management'),
(12, 'Life-long Learning');



 --Inserting the Graduate Attributes for each course

 --Discrete Mathematics
INSERT INTO Course_GAs (Course_Code, GAs_ID)
VALUES
( 'SEH300' ,1)  -- Knowledge Base

 --Mechanics
INSERT INTO Course_GAs (Course_Code, GAs_ID)
VALUES
( 'MEC110' ,1)  -- Knowledge Base

-- Electromagnetics
INSERT INTO Course_GAs (Course_Code, GAs_ID)
VALUES
( 'SES250' ,1)


 --Database Design Principles
INSERT INTO Course_GAs (Course_Code, GAs_ID)
VALUES
( 'BTD210',1),  -- Knowledge Base
( 'BTD210',2),  -- Problem Analysis
( 'BTD210',4),  -- Design
( 'BTD210',5)  -- Use of Engineering Tools

-- Digital and Analog Circuits
INSERT INTO Course_GAs (Course_Code, GAs_ID)
VALUES
( 'SEM305' ,1),  -- Knowledge Base
( 'SEM305' ,2),  -- Problem Analysis
( 'SEM305' ,5)   -- Use of Engineering Tools

 --Insert values into the PLOs table
INSERT INTO PLOs (PLOs_ID, PLO_Description)
VALUES
(1, 'Apply mathematics, natural sciences, and engineering fundamentals to solve engineering problems'),
(2, 'Create software engineering solutions that satisfy technical and business requirements'),
(3, 'Design an optimal solution using artificial intelligence, data mining, and machine learning tools for complex and open-ended problems'),
(4, 'Employ interpersonal, teambuilding, and leadership skills to solve problems independently and in diverse teams'),
(5, 'Communicate complex engineering problems and solutions to fellow software engineers and designers as well as non-technical audiences'),
(6, 'Act ethically and responsibly with public welfare and environmental protection as a guiding professional practice'),
(7, 'Plan and manage the scope, cost, timing, and quality of the project for success as defined by the project stakeholders'),
(8, 'Utilize investigative practices and self-awareness techniques to identify and pursue lifelong learning opportunities within their field of study and more broadly');




 --Inserting PLOs into Courses
INSERT INTO Course_PLOs(Course_Code, PLOs_ID)
VALUES
( 'SEM305' ,1),
( 'SEM305' ,3)


INSERT INTO Course_PLOs(Course_Code, PLOs_ID)
VALUES
( 'MEC110' ,1)


INSERT INTO Course_PLOs(Course_Code, PLOs_ID)
VALUES
( 'SES250' ,1)

INSERT INTO Course_PLOs(Course_Code, PLOs_ID)
VALUES
( 'BTD210',2),
( 'BTD210',3)

INSERT INTO Course_PLOs(Course_Code, PLOs_ID)
VALUES
( 'SEH300' ,1)



 --Inserting unique Section_UniqueID values
INSERT INTO Sections (Section_UniqueID, Semester_ID, Course_Code, Section_ID)
VALUES
(1, 'SES250NAA_2244', 'SES250', '2244'),
(2, 'MEC110NAA_2244', 'MEC110', '2244'),
(3, 'MEC110NAA_2247', 'MEC110', '2247'),
(4, 'SEM305NAA_2247', 'SEM305', '2247'),
(5, 'SEH300NAA_2247', 'SEH300', '2247'),
(6, 'BTD210NBB_2247', 'BTD210', '2247');


INSERT INTO Sections_Professors(Section_UniqueID, Professor_ID)
VALUES
(1,005),
(1,001),
(2,007),
(3,001),
(3,006),
(4,001),
(4,005),
(5,002),
(6,003),
(6,005)
