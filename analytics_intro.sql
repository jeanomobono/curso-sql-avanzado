select employee_id, first_name, job_id, hire_date, salary,
       rank () over (order by hire_date) as hire_seq,
       dense_rank() over (order by hire_date) as hire_seq_dense,
       row_number() over (order by hire_date, employee_id) as hire_seq_row
from hr.EMPLOYEES;

create sequence LAB_SAMPLES_SEQ;
create table LAB_SAMPLES
 ( sample_id          int default LAB_SAMPLES_SEQ.NEXTVAL,
   date_taken  date
 );
 insert into LAB_SAMPLES ( date_taken) values (date '2015-12-01');
 insert into LAB_SAMPLES ( date_taken) values (date '2015-12-02');
 insert into LAB_SAMPLES ( date_taken) values (date '2015-12-03');
 insert into LAB_SAMPLES ( date_taken) values (date '2015-12-04');
 insert into LAB_SAMPLES ( date_taken) values (date '2015-12-07');
 insert into LAB_SAMPLES ( date_taken) values (date '2015-12-08');
 insert into LAB_SAMPLES ( date_taken) values (date '2015-12-09');
 insert into LAB_SAMPLES ( date_taken) values (date '2015-12-10');
 insert into LAB_SAMPLES ( date_taken) values (date '2015-12-14');
 insert into LAB_SAMPLES ( date_taken) values (date '2015-12-15');
 insert into LAB_SAMPLES ( date_taken) values (date '2015-12-16');
 insert into LAB_SAMPLES ( date_taken) values (date '2015-12-19');
 insert into LAB_SAMPLES ( date_taken) values (date '2015-12-20');

select * from LAB_SAMPLES order by 2;

select min(DATE_TAKEN) date_from,
       max(DATE_TAKEN) date_to,
       count(*) num_samples
from (select date_taken,
       date_taken - row_number() over(order by date_taken) as delta
       from LAB_SAMPLES)
group by delta
order by 1;