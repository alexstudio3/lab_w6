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


