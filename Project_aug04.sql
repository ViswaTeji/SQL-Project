use mavenmovies;
/* Write a SQL query to count the number of characters except for the spaces for each actor. Return the
 first 10 actors' name lengths along with their names. */ 
 
 select first_name,last_name,length(Trim(replace(first_name,' ',''))) length_firstname,length(Trim(replace(last_name,' ',''))) length_lastname
 from actor limit 10;

/* List all Oscar awardees(Actors who received the Oscar award) with their full names and the length of their names. */
select * from film_actor;
select  concat(first_name,' ',last_name) name,length(Trim(replace(concat(first_name,last_name),' ',''))) name_length from actor_award
where awards like '%Oscar%';
/*Find the actors who have acted in the film ‘Frost Head.’ */
select concat(first_name,' ',last_name) actors from actor a join
film_actor fa on a.actor_id=fa.actor_id join film f on fa.film_id=f.film_id where title='Frost Head';
/* Pull all the films acted by the actor ‘Will Wilson.’ */
select title from film f join
film_actor fa on fa.film_id=f.film_id join actor a on a.actor_id=fa.actor_id where concat(first_name,' ',last_name)='Will Wilson';
/* Pull all the films which were rented and return them in the month of May. */
select title from rental r join inventory i on r.inventory_id=i.inventory_id 
join film f on f.film_id=i.film_id where month(rental_date)=5 and month(return_date)=5;
/* Pull all the films with ‘Comedy’ category. */
select title from film f join film_category fc on f.film_id=fc.film_id
join category c on c.category_id=fc.category_id where c.name='Comedy';
select * from film_category ;