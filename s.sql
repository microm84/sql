-- SQL Movie-Rating Query Exercises
-- q1
select title from Movie where director = 'Steven Spielberg';
-- q2
select year from Movie where mID in (select mID from Rating where stars >= 4) order by year;
-- q3
select title from Movie where mID not in (select mID from Rating);
-- q4
select name from Reviewer where rID in (select rID from Rating where ratingDate is null);
-- q5
select name, title, stars, ratingDate 
from ((Rating left join Reviewer using(rID)) left join Movie using(mID)) 
order by name, title, stars;
-- q6
select R1.name, R1.title 
from ((Rating left join Reviewer using(rID)) left join Movie using(mID)) R1, 
((Rating left join Reviewer using(rID)) left join Movie using(mID)) R2 
where R1.rID = R2.rID and R1.mID = R2.mID and R1.stars < R2.stars and R1.ratingDate < R2.ratingDate;
-- q7
select title, max(stars) from Rating left join Movie using(mID) group by mID order by title;
-- q8
select title, max(stars)-min(stars) 
from Rating left join Movie using(mID) 
group by mID 
order by max(stars)-min(stars) desc, title;
-- q9
select avg(r1.s) - avg(r2.s) from
(select avg(stars) as s from Rating left join Movie using (mID) where year < 1980 group by mID) r1,
(select avg(stars) as s from Rating left join Movie using (mID) where year > 1980 group by mID) r2;
-- SQL Movie-Rating Query Exercises Extras
-- q1
select name from Reviewer where rID in (select distinct rID from Rating where mID = 101);
-- q2
select re.name, m.title, ra.stars 
from Rating ra 
inner join Reviewer re on ra.rID = re.rID 
inner join Movie m on ra.mID = m.mID 
where re.name = m.director;
-- q3
select * from (select name as l from Reviewer union select title as l from Movie) order by l;
-- q4
select title from Movie where mID not in (select distinct mID from Rating where rID = 205);
-- q5
select distinct re1.name, re2.name
from Rating r1 
inner join Rating r2 on r1.mID = r2.mID
inner join Reviewer re1 on re1.rID = r1.rID
inner join Reviewer re2 on re2.rID = r2.rID
where r1.rID <> r2.rID and re1.name < re2.name
order by re1.name;
-- q6
select re.name, m.title, ra.stars
from Rating ra
inner join Reviewer re on ra.rID = re.rID
inner join Movie m on ra.mID = m.mID
where stars = 
(select min(s) from
(select stars as s from Rating));
-- q7
select title, avg(stars) as a 
from Rating r inner join Movie m on r.mID = m.mID 
group by r.mID 
order by a desc, title;
-- q8
select name 
from Reviewer 
where rID in 
(select rID from (select rID, count() as c from Rating group by rID having c >= 3));
-- q9
select title, director 
from Movie 
where director in 
(select director from Movie group by director having count() > 1) 
order by director, title;
-- q10
select title, avg(stars) 
from Rating r inner join Movie m on r.mID = m.mID 
group by r.mID 
having avg(stars) = (select max(s) from (select mID, avg(stars) as s from Rating group by mID));
-- q11
select title, avg(stars) 
from Rating r 
inner join Movie m on r.mID = m.mID 
group by r.mID 
having avg(stars) = (select min(s) from (select mID, avg(stars) as s from Rating group by mID));
-- q12
select director, title, max(stars)
from Movie m
inner join Rating r on m.mID = r.mID
where director is not null
group by director;
-- SQL Social-Network Query Exercises
-- q1
select H1.name 
from Highschooler H1 
inner join Friend on H1.ID = Friend.ID1 
inner join Highschooler H2 on H2.ID = Friend.ID2 
where H2.name = 'Gabriel';
-- q2
select H1.name, H1.grade, H2.name, H2.grade 
from Highschooler H1 
inner join Likes on H1.ID = Likes.ID1 
inner join Highschooler H2 on H2.ID = Likes.ID2 
where H1.grade - H2.grade >= 2;
-- q3
select h1.name, h1.grade, h2.name, h2.grade 
from (
    (Highschooler h1 
    inner join 
    (select l1.ID1 as ID1, l1.ID2 as ID2 
    from Likes l1, Likes l2 
    where l1.ID1 = l2.ID2 and l1.ID2 = l2.ID1) as l on h1.ID = l.ID1) 
    inner join Highschooler h2 on l.ID2 = h2.ID) 
where h1.name < h2.name;
-- q4
select name, grade 
from Highschooler 
where ID not in (select ID1 from Likes union select ID2 from Likes) 
order by grade, name;
-- q5
select H1.name, H1.grade, H2.name, H2.grade 
from (
    Highschooler H1 
    inner join (select * from Likes where ID2 not in (select ID1 from Likes)) l on H1.ID = l.ID1) 
inner join Highschooler H2 on l.ID2 = H2.ID;
-- q6
select name, grade from Highschooler where ID in 
(select distinct ID1
from Highschooler h1
inner join Friend f on h1.ID = f.ID1
inner join Highschooler h2 on f.Id2 = h2.ID
where h1.grade = h2.grade
except
select distinct ID1
from Highschooler h1
inner join Friend f on h1.ID = f.ID1
inner join Highschooler h2 on f.Id2 = h2.ID
where h1.grade <> h2.grade)
order by grade, name;
-- q7
select h1.name, h1.grade, h2.name, h2.grade, h3.name, h3.grade
from
(select n.ID1 as a, n.ID2 as b, f2.ID2 as c 
from Friend f1 inner join 
(select * from Likes where ID1 not in (select l.ID1 from Likes l inner join Friend f on l.ID1 = f.ID1 where l.ID2 = f.ID2)) n on f1.ID1 = n.ID1
inner join Friend f2 on n.ID2 = f2.ID1
where f1.ID2 = f2.ID2) n
inner join Highschooler h1 on n.a = h1.ID
inner join Highschooler h2 on n.b = h2.ID
inner join Highschooler h3 on n.c = h3.ID;
-- q8
select count(ID) - count(distinct name) from Highschooler;
-- q9
select name, grade from Highschooler 
where ID in 
(select ID2 
from (select ID2, count(ID1) as n from Likes group by ID2)
where n > 1);
-- SQL Social-Network Query Exercises Extras
-- q1
select h1.name, h1.grade, h2.name, h2.grade, h3.name, h3.grade 
from 
(select l.ID1 as a, l.ID2 as b, t.ID2 as c 
from Likes l 
inner join (select * from Likes where ID1 in (select ID2 from Likes intersect select ID1 from Likes)) t on l.ID2 = t.ID1 
where l.ID1 <> t.ID2) tt 
inner join Highschooler h1 on tt.a = h1.ID 
inner join Highschooler h2 on tt.b = h2.ID 
inner join Highschooler h3 on tt.c = h3.ID;
-- q2
select name, grade
from Highschooler
where ID not in 
(select h1.ID
from Highschooler h1 
inner join Friend f on h1.ID = f.ID1
inner join Highschooler h2 on f.ID2 = h2.ID
where h1.grade = h2.grade);
-- q3
select avg(c) 
from
(select count(*) as c 
from Highschooler h 
inner join Friend f on h.ID = f.ID1
group by h.ID);
-- q4
select count()
from
(select ID2 from Friend where ID1 in
(select ID2 from Friend where ID1 = 1709)
and ID2 <> 1709
union
select ID2 from Friend where ID1 = 1709);
-- q5
select h.name, h.grade
from Highschooler h 
inner join Friend f on h.ID = f.ID1 
group by h.ID
having count() = 
(select max(c) 
from
(select count() as c
from Highschooler h 
inner join Friend f on h.ID = f.ID1 
group by h.ID));
-- SQL Movie-Rating Modification Exercises
-- q1
insert into Reviewer values (209, 'Roger Ebert');
-- q2
update Movie 
set year = year + 25
where mID in 
(select mID 
from (select mID, avg(stars) as s from Rating group by mID)
where s >= 4);
-- q3
delete from Rating
where mID in (select mID from Movie where year < 1970 or year > 2000) and stars < 4;
-- SQL Social-Network Modification Exercises
-- q1
delete from Highschooler where grade = 12;
-- q2
delete from Likes
where ID1 in 
(select l.ID1 
from Likes l inner join Friend f on l.ID1 = f.ID1 
where l.ID2 = f.ID2)
and ID1 not in 
(select l1.ID1
from Likes l1 inner join Likes l2 on l1.ID1 = l2.ID2
where l1.ID2 = l2.ID1);
-- q3
insert into Friend
select f1.ID1, f2.ID2
from Friend f1 
inner join Friend f2 on f1.ID2 = f2.ID1
inner join Friend f3 on f2.ID2 = f3.ID1
where f1.ID1 <> F3.ID2 and f1.ID1 <> F2.ID2
except
select * from Friend
order by f1.ID1, f2.ID2;
