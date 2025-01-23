-- 1. List all CLOs for the course with code 'BTD210'
SELECT CLOs_ID, CLO_Description
FROM CLOs
WHERE Course_Code = 'BTD210';

-- 2. List all PLOs and the number of courses that teach each PLO
SELECT P.PLOs_ID, P.PLO_Description, COUNT(CP.Course_Code) AS NumberOfCourses
FROM PLOs P
LEFT JOIN Course_PLOs CP ON P.PLOs_ID = CP.PLOs_ID
GROUP BY P.PLOs_ID, P.PLO_Description;

-- 3. List publishers for all textbooks of all courses
SELECT T.Textbook_ISBN, T.Textbook_Requirement
FROM Textbooks T
JOIN Course_Textbooks CT ON T.Textbook_ISBN = CT.Textbook_ISBN
JOIN Courses C ON CT.Course_Code = C.Course_Code;

-- 4. For all courses offered in 2247, list course code, title, the name of the professor who developed the course, and all professors teaching the course
SELECT S.Course_Code, C.Course_Title, P.Professor_Name AS Developed_By, P2.Professor_Name AS Teaching_Professor
FROM Sections S
JOIN Courses C ON S.Course_Code = C.Course_Code
JOIN Professors P ON C.Developed_By = P.Professor_ID
JOIN Sections_Professors SP ON S.Section_UniqueID = SP.Section_UniqueID
JOIN Professors P2 ON SP.Professor_ID = P2.Professor_ID
WHERE S.Section_ID = '2247';

-- 5. List the course code, course title, and the textbook titles for courses that teach about 'circuit'
SELECT DISTINCT C.Course_Code, C.Course_Title, T.Textbook_Requirement
FROM Courses C
JOIN Course_Textbooks CT ON C.Course_Code = CT.Course_Code
JOIN Textbooks T ON CT.Textbook_ISBN = T.Textbook_ISBN
WHERE C.Course_Description LIKE '%circuit%'
   OR C.Course_Code IN (
        SELECT Course_Code
        FROM CLOs
        WHERE CLO_Description LIKE '%circuit%'
   );

-- 6. Create a view that lists all course codes, course titles, and their prerequisites
CREATE VIEW CoursePrerequisites AS
SELECT C.Course_Code, C.Course_Title, P.Course_Code AS Prerequisite_Code, P2.Course_Title AS Prerequisite_Title
FROM Courses C
JOIN Prerequisite P ON C.Course_Code = P.Course_Code
JOIN Courses P2 ON P.Prerequisite_Code = P2.Course_Code;

-- 7. List all courses that do NOT have a laboratory component in their method of instruction
SELECT Course_Code, Course_Title
FROM Courses
WHERE Course_Description NOT LIKE '%laboratory%'
   AND Course_Description NOT LIKE '%lab%';

-- 8. What is the total number of hours of all courses in the program?
SELECT SUM(Contact_Hours_Per_Week) AS TotalHours
FROM Courses;

-- 9. What is the total number of hours of all courses offered in Fall 2024?
SELECT SUM(C.Contact_Hours_Per_Week) AS TotalHours
FROM Courses C
JOIN Sections S ON C.Course_Code = S.Course_Code
WHERE S.Semester_ID = '2247';

-- 10. Which GA is taught in the highest number of courses?
SELECT G.GAs_ID, 
       G.GAs_Description, 
       COUNT(CG.Course_Code) AS NumberOfCourses
FROM GAs G
JOIN Course_GAs CG ON G.GAs_ID = CG.GAs_ID
GROUP BY G.GAs_ID, G.GAs_Description
HAVING COUNT(CG.Course_Code) = (
    SELECT MAX(NumberOfCourses)
    FROM (
        SELECT COUNT(CG.Course_Code) AS NumberOfCourses
        FROM GAs G
        JOIN Course_GAs CG ON G.GAs_ID = CG.GAs_ID
        GROUP BY G.GAs_ID
    ) AS SubQuery
);

-- 11. List all GAs and the highest semester they are taught in
SELECT G.GAs_ID, G.GAs_Description, MAX(S.Semester_ID) AS HighestSemester
FROM GAs G
JOIN Course_GAs CG ON G.GAs_ID = CG.GAs_ID
JOIN Courses C ON CG.Course_Code = C.Course_Code
JOIN Sections S ON C.Course_Code = S.Course_Code
GROUP BY G.GAs_ID, G.GAs_Description;

-- 12. What is the minimum, maximum, and average number of CLOs in courses?
SELECT MIN(CLOCount) AS MinCLOs, MAX(CLOCount) AS MaxCLOs, AVG(CLOCount) AS AvgCLOs
FROM (
    SELECT COUNT(*) AS CLOCount
    FROM CLOs
    GROUP BY Course_Code
) AS CLOCounts;

-- 13. Create a view named ‘DesignInCLO’ listing course codes and the number of times 'design' is mentioned in CLOs
CREATE VIEW DesignInCLOs AS
SELECT Course_Code, COUNT(*) AS nDesign
FROM CLOs
WHERE CLO_Description LIKE '%design%'
GROUP BY Course_Code;

-- 14. List course code, nDesign, and whether the course is checked off for 'design' in GAs for courses with nDesign > 0
SELECT DISTINCT 
    CG.Course_Code, 
    D.nDesign, 
    CASE 
        WHEN GA.GAs_ID IS NOT NULL THEN 'Yes' 
        ELSE 'No' 
    END AS GA_DesignChecked
FROM DesignInCLOs D
LEFT JOIN Course_GAs CG ON D.Course_Code = CG.Course_Code
LEFT JOIN GAs GA ON CG.GAs_ID = GA.GAs_ID AND GA.GAs_Description LIKE '%design%'
WHERE D.nDesign > 0;

-- 15. Calculate the percentage of CLOs per course that are at the ‘APPLY’ level in Bloom’s taxonomy
SELECT 
    C.Course_Code, 
    COUNT(CLOs.CLOs_ID) AS TotalCLOs,
    SUM(CASE 
            WHEN CLOs.CLO_Description LIKE '%Apply%' 
              OR CLOs.CLO_Description LIKE '%Use%' 
              OR CLOs.CLO_Description LIKE '%Implement%' 
              OR CLOs.CLO_Description LIKE '%Demonstrate%' 
              OR CLOs.CLO_Description LIKE '%Interpret%' 
              OR CLOs.CLO_Description LIKE '%Execute%' 
              OR CLOs.CLO_Description LIKE '%Solve%' 
              OR CLOs.CLO_Description LIKE '%Calculate%' 
            THEN 1 
            ELSE 0 
         END) AS ApplyCLOs,
    (SUM(CASE 
            WHEN CLOs.CLO_Description LIKE '%Apply%' 
              OR CLOs.CLO_Description LIKE '%Use%' 
              OR CLOs.CLO_Description LIKE '%Implement%' 
              OR CLOs.CLO_Description LIKE '%Demonstrate%' 
              OR CLOs.CLO_Description LIKE '%Interpret%' 
              OR CLOs.CLO_Description LIKE '%Execute%' 
              OR CLOs.CLO_Description LIKE '%Solve%' 
              OR CLOs.CLO_Description LIKE '%Calculate%' 
            THEN 1 
            ELSE 0 
         END) * 100.0) / COUNT(CLOs.CLOs_ID) AS ApplyPercentage
FROM Courses C
LEFT JOIN CLOs ON C.Course_Code = CLOs.Course_Code
GROUP BY C.Course_Code;
