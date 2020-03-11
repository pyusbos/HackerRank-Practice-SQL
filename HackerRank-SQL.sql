#Weather Observation Station 5
(select city, length(city)
from station
order by length(city) asc, city asc
limit 1 )
union
(select city, length(city)
from station
order by length(city) desc, city asc
limit 1) ;

#Weather Observation Station 6
select distinct city
from station
where city like 'A%' or city like 'E%' or CITY like 'I%' or city like 'O%' or city like 'U%';

#Weather Observation Station 10
select distinct city
from station
where substr(city,-1,1) not in ('a','e','i','o','u');

#The Blunder
select ceil(avg(salary) - avg(to_number(replace(to_char(salary),'0',''))))
from employees;

#Type of Triangle
SELECT 
CASE 
WHEN (A + B <= C) OR (B + C <= A) OR(A + C <= B) THEN 'Not A Triangle'
WHEN (A = B) AND (B = C) THEN 'Equilateral'
WHEN (A =B) OR (C = A) OR (B = C) THEN 'Isosceles'
ELSE 'Scalene'
END
FROM TRIANGLES;

#Draw the Triangle 2
set @num := 0;
select repeat('* ',@num := @num +1)
from information_schema.tables
where @num <20;

#Placements
Select S.Name
From ( Students S join Friends F Using(ID)
       join Packages P1 on S.ID=P1.ID
       join Packages P2 on F.Friend_ID=P2.ID)
Where P2.Salary > P1.Salary
Order By P2.Salary;

#The Pads
select concat(name,'(',substr(occupation,1,1),')')
from occupations
order by name;
select concat('There are a total of',' ',count(occupation),' ',lower(occupation),'s.')
from occupations
group by occupation
order by count(occupation), occupation;

#New Companies
select c.company_code,c.founder,count(distinct l.lead_manager_code),count(distinct s.senior_manager_code),
       count(distinct m.manager_code),count(distinct e.employee_code)
from company c join lead_manager l on c.company_code = l.company_code
join senior_manager s on l.company_code = s.company_code
join manager m on s.company_code = m.company_code
join employee e on m.company_code = e.company_code
group by c.company_code, c.founder
order by c.company_code;

#The Report
select (case when g.grade >= 8 then s.name else null end) as name,g.grade,s.marks
from students s join grades g on s.marks between g.min_mark and g.max_mark
order by g.grade desc,s.name;

#Ollvander's Inventory
select w.id,p.age,w.coins_needed,w.power
from wands w join wands_property p on w.code = p.code
where p.is_evil = 0 and w.coins_needed = (select min(w1.coins_needed)
                                        from wands w1 join wands_property p1 on w1.code = p1.code
                                        group by w1.power,p1.age
                                        having w1.power = w.power and p1.age = p.age)
order by w.power desc,p.age desc;

#Binary Tree Nodes
select b.N,
case when b.N in (select distinct b1.N
                  from BST b1 cross join BST b2
                  where b1.N = b2.P and b1.P is not null) then 'Inner' 
when b.P is null then 'Root'
else 'Leaf'
end
from BST b
order by b.N;

#SQL Project Planning
select start_date, min(end_date) 
from (select start_date 
      from projects 
      where start_date not in (select end_date from projects)) as s,
      (select end_date
      from projects
      where end_date not in (select start_date from projects)) as e
where start_date < end_date
group by start_date
order by datediff(min(end_date),start_date),start_date;

#Symmetric Pairs
select f1.X,f1.Y
from functions f1
where f1.X = f1.Y
group by f1.X,f1.Y
having count(*) > 1
union
select f2.X,f2.Y
from functions f2 join functions f3 on f2.X = f3.Y and f2.Y = f3.X
where f2.X < f2.Y
order by X;

#Print Prime Numbers
SELECT LISTAGG(PRIME_NUMBER,'&') WITHIN GROUP (ORDER BY PRIME_NUMBER)
FROM(
SELECT L PRIME_NUMBER
FROM(
SELECT LEVEL L
FROM DUAL
CONNECT BY LEVEL <= 1000),
(SELECT LEVEL M FROM DUAL CONNECT BY LEVEL <= 1000)
WHERE M <= L
GROUP BY L
HAVING COUNT(CASE WHEN L/M = TRUNC(L/M) THEN 'Y' END) = 2
ORDER BY L);

#Weather Observation Station 20
SELECT CAST(LAT_N AS DECIMAL (7,4))
FROM
    (SELECT LAT_N, ROW_NUMBER() OVER (ORDER BY LAT_N) as ROWNU 
     FROM STATION 
     ) AS X
WHERE ROWNU = ( SELECT ROUND((COUNT(LAT_N)+1)/2,0) 
                FROM STATION
               );

#15 Days of Learning SQL
select 
submission_date ,

( SELECT COUNT(distinct hacker_id)  
 FROM Submissions s2  
 WHERE s2.submission_date = s1.submission_date AND    (SELECT COUNT(distinct s3.submission_date) FROM      Submissions s3 WHERE s3.hacker_id = s2.hacker_id AND s3.submission_date < s1.submission_date) = dateDIFF(s1.submission_date , '2016-03-01')) ,

(select hacker_id  from submissions s2 where s2.submission_date = s1.submission_date 
group by hacker_id order by count(submission_id) desc , hacker_id limit 1) as shit,
(select name from hackers where hacker_id = shit)
from 
(select distinct submission_date from submissions) s1
group by submission_date;

#Occupations
set @r1=0, @r2=0, @r3=0, @r4=0;
select min(Doctor), min(Professor), min(Singer), min(Actor)
from(
  select case when Occupation='Doctor' then (@r1:=@r1+1)
            when Occupation='Professor' then (@r2:=@r2+1)
            when Occupation='Singer' then (@r3:=@r3+1)
            when Occupation='Actor' then (@r4:=@r4+1) end as RowNumber,
    case when Occupation='Doctor' then Name end as Doctor,
    case when Occupation='Professor' then Name end as Professor,
    case when Occupation='Singer' then Name end as Singer,
    case when Occupation='Actor' then Name end as Actor
  from OCCUPATIONS
  order by Name
) Temp
group by RowNumber;
