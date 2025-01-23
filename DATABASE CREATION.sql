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


