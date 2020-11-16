use sakila;

select distinct first_name, last_name, email 
from customer as c
join rental as r
on c.customer_id = r.customer_id;
-- or can also use group by

-- What is the average payment made by each customer
select concat(c.customer_id, ' ', c.first_name, ' ', c.last_name), avg(p.amount) 
from customer as c
join payment as p
on c.customer_id = p.customer_id
group by c.customer_id;

-- with join
select c.first_name, c.last_name, c.email 
from customer as c
join rental as r on r.customer_id = c.customer_id
join inventory as i on r.inventory_id = i.inventory_id
join film as f on f.film_id = i.film_id
join film_category as fc on fc.film_id = f.film_id
join category as cc on cc.category_id = fc.category_id 
where cc.name = 'Action'
group by first_name, last_name, email;

-- Q- the join is different if done through rental vs store
select CONCAT(first_name, " ", last_name) AS name, email
from customer where customer_id in
(select customer_id from rental where inventory_id in
(select inventory_id from inventory where film_id in
(select film_id from film_category join category using (category_id) where category.name="Action")));



select amount, 
case 
	when amount > 0 and amount < 2 then "low"
    when amount > 2 and amount < 4 then "medium"
    when amount > 4 then "high"
    
end 
from payment;
    
    

