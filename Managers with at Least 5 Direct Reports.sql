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

with t1 as
    (
        select managerid, count(name) as total
        from employee
        group by managerid
    )

select
    e.name
from t1
    join employee e
    on t1.managerid = e.id
where t1.total >= 5