-- mapping tables
CREATE TABLE students (
	id		BIGINT PRIMARY KEY,
	name	varchar(256) NOT NULL,
	address	varchar(256) NOT NULL,
	email	varchar(256) NOT NULL UNIQUE
);

CREATE TABLE phone_numbers (
	student_id bigint,
	number	varchar(256) unique,
	FOREIGN KEY (student_id) REFERENCES students(id)
);

CREATE TABLE subjects (
	id		bigint PRIMARY KEY,
	name	varchar(256) NOT NULL,
	description	varchar(256) NOT NULL,
    max_score smallint NOT NULL
);

CREATE TABLE enroll (
	student_id bigint,	
    subject_id bigint,
    date	date
);

CREATE TABLE exams (
	student_id bigint,	
    subject_id bigint,
    result float,
    date	date
);


-- 1. Insert 5 students
INSERT INTO students (id, name, address, email)
VALUES
(1, 'Ahmed Hassan', '123 Main St, Cairo', 'ahmed@test.com'),
(2, 'Mariam Ali', '456 Nile St, Giza', 'mariam@test.com'),
(3, 'Ali Ibrahim', '789 Sea St, Alexandria', 'ali@test.com'),
(4, 'Sara Mahmoud', '101 Temple Rd, Aswan', 'sara@test.com'),
(5, 'Omar Khaled', '202 Sphinx Ave, Luxor', 'omar@test.com');

-- 2. Insert subjects
INSERT INTO subjects (id, name, description, max_score)
VALUES
(101, 'Mathematics', 'Fundamentals of Algebra and Calculus',100),
(102, 'Physics', 'Mechanics and Thermodynamics',200),
(103, 'History', 'World History from 1900',100);

-- 3. Insert 5 phone numbers
INSERT INTO phone_numbers (student_id, number)
VALUES
(1, '01000000001'),
(1, '01000000002'),
(2, '01111111111'),
(3, '01222222222'),
(5, '01555555555');

-- 4. Insert 5 enroll
INSERT INTO enroll (student_id, subject_id, date)
VALUES
(1, 101, '2025-01-10'),
(1, 102, '2025-01-12'),
(2, 101,  '2025-01-10'),
(3, 103, '2025-01-11'),
(4, 101, '2025-01-10');

-- 5. Insert 5 exam results
INSERT INTO exams (student_id, subject_id, result, date)
VALUES
(1, 101, 85.5, '2025-05-10'),
(1, 102, 90.0, '2025-05-12'),
(2, 101, 95.0, '2025-05-10'),
(3, 103, 70.0, '2025-05-11'),
(4, 101, 88.0, '2025-05-10');

-- 1. Add gender column for the student table. It holds two value (male or female).
ALTER TABLE students
ADD gender enum("male", "female");

-- 2. Add birth date column for the student table.

ALTER TABLE students
ADD birth_date date;

-- 3. Delete the name column and replace it with two colums first name and last name.
ALTER TABLE students
DROP COLUMN name;

ALTER TABLE students
ADD first_name varchar(265);

ALTER TABLE students
ADD last_name varchar(265);

ALTER TABLE students
ADD last_name varchar(265);

-- 4. Delete the address and email column and replace it with contact info (Address, email) as object Data type.

ALTER TABLE students
DROP COLUMN address,
DROP COLUMN email,
ADD contact_info json;

-- 5. Add foreign key constrains in Your Tables with options on delete cascaded .

ALTER TABLE enroll
ADD CONSTRAINT fk_student_id 
FOREIGN KEY (student_id)
REFERENCES students(id)
ON DELETE CASCADE;

-- 6. Update your information by changing data for (gender, birthdate, first name, last name, contact info).

-- Student 1
UPDATE students
SET 
    first_name = 'Ahmed',
    last_name = 'Hassan',
    gender = 'male',
    birth_date = '1998-05-15',
    contact_info = '{"address": "123 Main St, Cairo", "email": "ahmed@test.com"}'
WHERE id = 1;

-- Student 2
UPDATE students
SET 
    first_name = 'Mariam',
    last_name = 'Ali',
    gender = 'female',
    birth_date = '1999-02-20',
    contact_info = '{"address": "456 Nile St, Giza", "email": "mariam@test.com"}'
WHERE id = 2;

-- Student 3
UPDATE students
SET 
    first_name = 'Ali',
    last_name = 'Ibrahim',
    gender = 'male',
    birth_date = '1997-11-30',
    contact_info = '{"address": "789 Sea St, Alexandria", "email": "ali@test.com"}'
WHERE id = 3;

-- Student 4
UPDATE students
SET 
    first_name = 'Sara',
    last_name = 'Mahmoud',
    gender = 'female',
    birth_date = '2000-07-10',
    contact_info = '{"address": "101 Temple Rd, Aswan", "email": "sara@test.com"}'
WHERE id = 4;

-- Student 5
UPDATE students
SET 
    first_name = 'Omar',
    last_name = 'Khaled',
    gender = 'male',
    birth_date = '1998-09-05',
    contact_info = '{"address": "202 Sphinx Ave, Luxor", "email": "omar@test.com"}'
WHERE id = 5;

-- 7. Display all students’ information.

SELECT * FROM students;

-- 8. Display male students only.

SELECT * FROM students WHERE gender = "male";

-- 9. Display the number of female students.

SELECT count(gender) as gender_count 
FROM students 
WHERE gender = "female" 
GROUP BY gender;

-- 10. Display the students who are born before 1992-10-01.

SELECT * FROM students WHERE birth_date < "1992-10-01";

-- 11. Display male students who are born before 1991-10-01.

SELECT * FROM students WHERE gender = "male" AND  birth_date < "1991-10-01";

-- 12. Display subjects and their max score sorted by max score.

SELECT * FROM subjects ORDER BY max_score; 


-- 13. Display the subject with highest max score

SELECT * FROM subjects ORDER BY max_score desc limit 1; 


-- 14. Display students’ names that begin with A.

SELECT first_name, last_name 
FROM students
WHERE first_name LIKE 'A%';

-- 15. Display the number of students’ their name is “Mohammed”

SELECT COUNT(*) AS mohammed_count
FROM students
WHERE first_name = 'Mohammed';

-- 16. Display the number of males and females.

SELECT gender, COUNT(*) AS total_count
FROM students
GROUP BY gender;

-- 17. Display the repeated first names and their counts if higher than 2.

SELECT first_name, COUNT(*) AS name_count
FROM students
GROUP BY first_name
HAVING COUNT(*) > 2;

-- 18. Display students’ names, their score and subject name.

SELECT first_name, last_name, name AS subject_name, result
FROM students
JOIN exams ON students.id = exams.subject_id
JOIN subjects ON exams.subject_id = subjects.id;


-- 19. Delete students their score is lower than 50 in a particular subject exam.
-- subject 101
DELETE FROM students
WHERE id IN (
    SELECT DISTINCT student_id 
    FROM exams 
    WHERE result < 50 AND subject_id = 101
);
