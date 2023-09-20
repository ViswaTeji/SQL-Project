-- Here's a brief overview of the tables you'll be working with:
/* users: Contains user information such as usernames and creation timestamps.
photos: Stores details about posted photos, including image URLs and user IDs.
comments: Stores comments made on photos, along with associated user and photo IDs.
likes: Tracks user likes on photos.
follows: Records user follow relationships.
tags: Manages unique tag names for photos.
photo_tags: Links photos with associated tags.
*/
-- 1. How many times does the average user post?
select COUNT(*),user_id from photos GROUP BY USER_ID ;
-- final query:
select user_id,username,COUNT(*) user_postcount from photos p
join users u on u.id=p.user_id GROUP BY USER_ID ;

-- 2.  Find the top 5 most used hashtags.
select count(*),tag_id from photo_tags group by tag_id order by 1 desc limit 5;
-- final query
select tag_id,tag_name,count(*) tag_count from photo_tags pt join tags t on t.id=pt.tag_id
group by tag_id order by 1 desc limit 5;

-- 3. Find users who have liked every single photo on the site.
select * from likes where user_id in (select user_id from likes group by user_id 
having count(distinct photo_id)=(select count(distinct id) from photos)) ;

select count(user_id),user_id from likes group by user_id 
having count(distinct photo_id)=(select count(distinct id) from photos) order by user_id;
-- final query
select distinct username, id from users u join likes l on  u.id=l.user_id
where user_id in (select user_id from likes group by user_id 
having count(distinct photo_id)=(select count(distinct id) from photos)) order by id;



-- 4. Retrieve a list of users along with their usernames and the rank of their account creation, 
-- ordered by the creation date in ascending order.

select username,id, rank() over(order by created_at asc ) rank_account_creation,created_at  from users ;

-- 5. List the comments made on photos with their comment texts, photo URLs, 
-- and usernames of users who posted the comments. Include the comment count for each photo

select comment_text,image_url photo_URLs, username,count(c.id) over(partition by c.photo_id ) comment_count_photo from comments c 
join photos p on c.photo_id=p.id
join users u on u.id=p.user_id;

-- 6. For each tag, show the tag name and the number of photos associated 
-- with that tag. Rank the tags by the number of photos in descending order.
select * from tags;
select * from photo_tags;
-- final query
select t.id,tag_name, count(pt.photo_id) no_of_photos , rank() over(order by count(pt.photo_id) desc)from tags t 
left join photo_tags pt on pt.tag_id=t.id
group by t.id ;

-- 7. List the usernames of users who have posted photos along with the count of photos they have posted. 
-- Rank them by the number of photos in descending order.

select u.id,username, count(p.id) count_photos,rank() over(order by count(p.id) desc) Rank__photos from users u 
join photos p on u.id=p.user_id 
group by p.user_id ;


-- 8. Display the username of each user along with the creation date of their 
-- first posted photo and the creation date of their next posted photo.
select * from photos order by created_at;

select distinct user_id, created_at,
lead(created_at) over(partition by user_id order by created_at desc) as second_post_creationdate
from  photos  ;

-- final query
select distinct u.id,username, p.created_at , 
lead(p.created_at) over(partition by user_id order by p.created_at) as second_post_creationdate
from users u join  photos p on u.id=p.user_id ;



-- 9. For each comment, show the comment text, the username of the commenter,
-- and the comment text of the previous comment made on the same photo.
select * from comments;
-- final query 
select comment_text, username,lag(c.comment_text) over(partition by c.photo_id order by c.created_at) previous_commenton_photo 
from comments c join users u on u.id=c.user_id;

-- 10.  Show the username of each user along with the number of photos they 
-- have posted and the number of photos posted by the user before them and after them, based on the creation date.
select * from users order by created_at;
select * from photos where user_id=80;
-- final query
select username, count(p.id),
lead(count(p.id)) over(order by u.created_at),lag(count(p.id)) over(order by u.created_at)
from users u left join photos p on u.id=p.user_id group by u.id order by u.created_at;

