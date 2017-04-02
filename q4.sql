use `lahman2016`;

select count(*)
from Parks P
where P.`park.name` like '%Stadium%';