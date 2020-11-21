use sakila;

drop procedure if exists movies_categories;

delimiter //
create procedure movies_categories()
begin 
  select first_name, last_name, email
  from customer
  join rental on customer.customer_id = rental.customer_id
  join inventory on rental.inventory_id = inventory.inventory_id
  join film on film.film_id = inventory.film_id
  join film_category on film_category.film_id = film.film_id
  join category on category.category_id = film_category.category_id
  where category.name = "Action"
  group by first_name, last_name, email;
end;
//
delimiter ;

call movies_categories();


drop procedure if exists movies_categories2;
delimiter //
create procedure movies_categories2(in category varchar(100) )
begin 
  select first_name, last_name, email
  from customer
  join rental on customer.customer_id = rental.customer_id 
  join inventory on rental.inventory_id = inventory.inventory_id
  join film on film.film_id = inventory.film_id
  join film_category on film_category.film_id = film.film_id
  join category on category.category_id = film_category.category_id
  where category.name COLLATE utf8mb4_general_ci = category
  group by first_name, last_name, email;
end;
//
delimiter ;
call movies_categories2("Children");

-- movies released in each category
select count(*) from film as f 
join film_category as fc
on fc.film_id = f.film_id
join category as c
on c.category_id = fc.category_id 
group by c.name
having count(*) > 60;


-- include c.name in output
drop procedure if exists movies_categories_count;
delimiter //
create procedure movies_categories_count(in input_number varchar(100) )
begin 
select c.name, count(*) from film as f 
join film_category as fc
on fc.film_id = f.film_id
join category as c
on c.category_id = fc.category_id 
group by c.name
having count(*) > input_number;
end;
//
delimiter ;
call movies_categories_count(60);

-- afternoon - Lab | SQL Iterations
-- Write a query to find what is the total business done by each store.
select sto.store_id, sum(p.amount) from 
payment as p 
join staff sta 
on p.staff_id = sta.staff_id
join store sto 
on sto.store_id = sta.store_id
group by sto.store_id;


-- Convert the previous query into a stored procedure.
drop procedure if exists store_businesses;

delimiter //
create procedure store_businesses()
begin 
select sto.store_id, sum(p.amount) from 
payment as p 
join staff sta 
on p.staff_id = sta.staff_id
join store sto 
on sto.store_id = sta.store_id
group by sto.store_id;
end;
//
delimiter ;

call store_businesses();

-- Convert the previous query into a stored procedure 
-- that takes the input for store_id and displays the total sales for that store.
drop procedure if exists store_businesses2;

delimiter //
create procedure store_businesses2(in param1 int)
begin 
select sto.store_id, sum(p.amount) from 
payment as p 
join staff sta 
on p.staff_id = sta.staff_id
join store sto 
on sto.store_id = sta.store_id

group by sto.store_id
having store_id = param1;
end;
//
delimiter ;

call store_businesses2(1);

-- Update the previous query. Declare a variable total_sales_value of float type, 
-- that will store the returned result (of the total sales amount for the store). 
-- Call the stored procedure and print the results.
-- Just store, select and print, no need to return it
drop procedure if exists store_businesses3;

delimiter //
create procedure store_businesses3(in param1 int)
begin 

declare total_sales_value float default 0.0;

set total_sales_value = (
select sum(p.amount) from 
payment as p 
join staff sta 
on p.staff_id = sta.staff_id
join store sto 
on sto.store_id = sta.store_id
group by sto.store_id
having store_id = param1); 

select total_sales_value;
end;
//
delimiter ;

call store_businesses3(1);

-- In the previous query, add another variable flag. 
-- If the total sales value for the store is over 30.000, then label it as green_flag, 
-- otherwise label is as red_flag. Update the stored procedure that takes an input as 
-- the store_id and returns total sales value for that store and flag value.
drop procedure if exists store_businesses4;

delimiter //
create procedure store_businesses4(in param1 int, out param2 float, out param3 varchar(100))
begin 

declare total_sales_value float default 0.0;
declare flag varchar(100);

select * into total_sales_value from (
select sum(p.amount) from 
payment as p 
join staff sta 
on p.staff_id = sta.staff_id
join store sto 
on sto.store_id = sta.store_id
group by sto.store_id
having store_id = param1 ) sub1; 

  if total_sales_value > 30000 then
    set flag = 'green_flag';
  else
    set flag = 'red_flag';
  end if;

select total_sales_value into param2;
select flag into param3;

end;
//
delimiter ;

call store_businesses4(1, @x, @y);
select @x;
select @y;

