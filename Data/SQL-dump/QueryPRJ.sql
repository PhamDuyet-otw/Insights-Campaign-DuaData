CREATE DATABASE duadata_challenge;
USE duadata_challenge;
-- query 1: tính tổng % học viên hoàn thành đủ cả 10 bài

with fil_duplicate as
(select Lesson,Student_id,row_number() over(partition by Lesson,Student_id order by Submit_date) as ranking
from enrollment
)
,total_student_10 as
(select Student_id,count(*) as Total_finish
from fil_duplicate
where ranking=1
group by Student_id
having count(*)=10)

select cast(count(*)*100.0/(select count(Customer_id) from Customer) as decimal(10,4)) as 'Percent_of_completing'
from total_student_10 ;
-- Với mỗi ngày từ 1–10, tính số lượng học viên không tham gia ở ngày nào đó 
-- → tìm ra ngày có tỷ lệ dropout cao nhất.
select Lesson,
	   (select count(c.Customer_id)
		from Customer c
		where c.Customer_id in (select Student_id from Enrollment e))-count(distinct Student_id) as Dropout,
		(cast(((select count(c.Customer_id)
		from Customer c
		where c.Customer_id in (select Student_id from Enrollment e))-count(distinct Student_id))*100.0/(select count(c.Customer_id)
																									from Customer c
																									where c.Customer_id in (select Student_id from Enrollment e)) as decimal(10,4))) as Percent_dropout
from enrollment
group by Lesson
order by Percent_dropout DESC