-- Создаем keyspace
CREATE KEYSPACE usersposts
WITH REPLICATION = { 'class' : 'SimpleStrategy','replication_factor' : 1 };

USE usersposts;

-- Создаем таблицы
CREATE TABLE IF NOT EXISTS posts_by_user(
    userId   int,
    username text,
    email    text,
    topicId  int,
    content  text,
    postId   int,
    createdPostAt timestamp,
    PRIMARY KEY ((userId), createdPostAt)
) WITH CLUSTERING ORDER BY (createdPostAt DESC);

CREATE TABLE IF NOT EXISTS posts_by_topic(
     topicId  int,
     userId   int,
     username text,
     email    text,
     content  text,
     postId   int,
     createdPostAt timestamp,
     createdTopicAt date,
     PRIMARY KEY ((topicId, createdTopicAt), createdPostAt)
) WITH CLUSTERING ORDER BY (createdPostAt DESC);

-- Заполняем данными
INSERT INTO posts_by_user (userId, username, email, topicId, content, postId, createdPostAt)
VALUES (0, 'User0', 'user0@example.com', 0, 'Content User0 0', 0 ,'2023-11-01 00:00:00+0000');
INSERT INTO posts_by_user (userId, username, email, topicId, content, postId, createdPostAt)
VALUES (0, 'User0', 'user0@example.com', 0, 'Content User0 0', 1 ,'2023-11-06 00:00:00+0000');
INSERT INTO posts_by_user (userId, username, email, topicId, content, postId, createdPostAt)
VALUES (1, 'User1', 'user1@example.com', 0, 'Content User1 0', 0 ,'2023-11-01 00:00:00+0000');
INSERT INTO posts_by_user (userId, username, email, topicId, content, postId, createdPostAt)
VALUES (1, 'User1', 'user1@example.com', 0, 'Content User1 1', 1 ,'2023-11-03 00:00:00+0000');
INSERT INTO posts_by_user (userId, username, email, topicId, content, postId, createdPostAt)
VALUES (1, 'User1', 'user1@example.com', 0, 'Content User1 2', 2 ,'2023-11-15 00:00:00+0000');
INSERT INTO posts_by_user (userId, username, email, topicId, content, postId, createdPostAt)
VALUES (2, 'User2', 'user2@example.com', 0, 'Content User2 0', 0 ,'2023-11-05 00:00:00+0000');

INSERT INTO posts_by_topic (topicId, userId, username, email, content, postId, createdPostAt, createdTopicAt)
VALUES (0, 0, 'User0', 'user0@example.com', 'Content User0 0', 0, '2023-11-01 00:00:00+0000', '2023-10-29');
INSERT INTO posts_by_topic (topicId, userId, username, email, content, postId, createdPostAt, createdTopicAt)
VALUES (0, 0, 'User0', 'user0@example.com', 'Content User0 1', 1, '2023-11-06 00:00:00+0000', '2023-10-29');
INSERT INTO posts_by_topic (topicId, userId, username, email, content, postId, createdPostAt, createdTopicAt)
VALUES (0, 1, 'User1', 'user1@example.com', 'Content User1 0', 0, '2023-11-01 00:00:01+0000', '2023-10-29');
INSERT INTO posts_by_topic (topicId, userId, username, email, content, postId, createdPostAt, createdTopicAt)
VALUES (0, 1, 'User1', 'user1@example.com', 'Content User1 1', 1, '2023-11-01 00:00:02+0000', '2023-10-29');
INSERT INTO posts_by_topic (topicId, userId, username, email, content, postId, createdPostAt, createdTopicAt)
VALUES (0, 1, 'User1', 'user1@example.com', 'Content User1 2', 2, '2023-11-15 00:00:00+0000', '2023-10-29');
INSERT INTO posts_by_topic (topicId, userId, username, email, content, postId, createdPostAt, createdTopicAt)
VALUES (0, 2, 'User2', 'user2@example.com', 'Content User2 0', 0, '2023-11-05 00:00:00+0000', '2023-10-29');

-- 1) Запрос, который бы доставал посты заданного пользователя упорядоченные
-- по времени создания поста - сначала новые.
-- Запрос должен возвращать post_id, content, дату создания поста.
SELECT postId, content, createdPostAt FROM posts_by_user
WHERE userId = 1;

-- 2) Запрос, который бы доставал последний пост заданного пользователя.
-- Запрос должен возвращать post_id, content, дату создания поста, username.
SELECT postId, content, createdPostAt, username FROM posts_by_user
WHERE userId = 0
LIMIT 1;

-- 3) Запрос, который бы доставал посты заданного пользователя,
-- опубликованные после заданной даты.
-- Запрос должен возвращать post_id, content, дату создания поста.
SELECT postId, content, createdPostAt FROM posts_by_user
WHERE userId = 1
AND createdPostAt >'2023-11-03';

-- 4) Запрос, который бы доставал пользователей, которые сделали пост в заданный день
-- по заданной теме, упорядоченные по времени - сначала новые.
-- Запрос должен возвращать user_id, username, post_id, время создания поста.
SELECT userId, username, postId, createdPostAt FROM posts_by_topic
WHERE topicId = 0
AND createdTopicAt = '2023-10-29'
ORDER BY createdPostAt DESC;
