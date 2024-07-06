/*

Managers with at Least 5 Direct Reports

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |  -- Primary Key
| name        | varchar |
| department  | varchar |
| managerId   | int     |
+-------------+---------+

1.	Each row of this table indicates the name of an employee, their department, and the id of their manager.
2.	If managerId is null, then the employee does not have a manager.
3.	No employee will be the manager of themself.

Example 1: 
Input: Employee table:
+-----+-------+------------+-----------+
| id  | name  | department | managerId |
+-----+-------+------------+-----------+
| 101 | John  | A          | None      |
| 102 | Dan   | A          | 101       |
| 103 | James | A          | 101       |
| 104 | Amy   | A          | 101       |
| 105 | Anne  | A          | 101       |
| 106 | Ron   | B          | 101       |
+-----+-------+------------+-----------+
Output: 
+------+
| name |
+------+
| John |
+------+ */

-- Solution:--

/* Temporary Table (t1):
This part creates a temporary table t1 that counts the number of employees managed by each manager.
managerid is grouped, and the count of employees (name) is calculated. */

WITH t1 AS (
        SELECT managerid, count(name) AS total
        FROM employee
        GROUP BY managerid)

/* Main Query:
This part selects the names of managers from the employee table whose managerid has a total count of employees (total) greater than or equal to 5.
It joins the temporary table t1 with the employee table on managerid and id. */

SELECT
    e.name
FROM t1
INNER JOIN employee e ON t1.managerid = e.id
WHERE t1.total >= 5