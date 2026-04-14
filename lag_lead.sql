drop table ORDERS purge;
create table ORDERS 
( order_id     int,
  status_date  date,
  status       varchar2(20)
);
insert into ORDERS values (11700, date '2016-01-03', 'New');
insert into ORDERS values (11700, date '2016-01-04', 'Inventory Check');
insert into ORDERS values (11700, date '2016-01-05', 'Inventory Check');
insert into ORDERS values (11700, date '2016-01-06', 'Inventory Check');
insert into ORDERS values (11700, date '2016-01-07', 'Inventory Check');
insert into ORDERS values (11700, date '2016-01-08', 'Inventory Check');
insert into ORDERS values (11700, date '2016-01-09', 'Awaiting Signoff');
insert into ORDERS values (11700, date '2016-01-10', 'Awaiting Signoff');
insert into ORDERS values (11700, date '2016-01-11', 'Awaiting Signoff');
insert into ORDERS values (11700, date '2016-01-12', 'In Warehouse');
insert into ORDERS values (11700, date '2016-01-13', 'In Warehouse');
insert into ORDERS values (11700, date '2016-01-14', 'In Warehouse');
insert into ORDERS values (11700, date '2016-01-15', 'Awaiting Signoff');
insert into ORDERS values (11700, date '2016-01-16', 'Awaiting Signoff');
insert into ORDERS values (11700, date '2016-01-17', 'Payment Pending');
insert into ORDERS values (11700, date '2016-01-18', 'Payment Pending');
insert into ORDERS values (11700, date '2016-01-19', 'Awaiting Signoff');
insert into ORDERS values (11700, date '2016-01-20', 'Awaiting Signoff');
insert into ORDERS values (11700, date '2016-01-21', 'Delivery');
insert into ORDERS values (11700, date '2016-01-22', 'Delivery');
commit;