set pages 60
ttitle 'Listado empleados'
select first_name, last_name, department_id from employees where employee_id = &empleado order by department_id;
btitle 'Confidencial'
/
