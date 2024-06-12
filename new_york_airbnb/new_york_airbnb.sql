SELECT
	booking_id,
	listing_name,
	neighbourhood_group,
	AVG(price) OVER()
FROM bookings;

SELECT
	booking_id, 
	listing_name, 
	neighbourhood_group,
	AVG (price) OVER(), 
	MIN (price) OVER(), 
	MAX (price) OVER()
FROM bookings;

SELECT
	booking_id, 
	listing_name, 
	neighbourhood_group, 
	price,
	ROUND (AVG (price) OVER, 2) ,
	ROUND ((price - AVG(price) OVER()), 2) AS diff_from_avg
FROM bookings;

-- Percent of average price with OVER()
SELECT
	booking_id, 
	listing_name, 
	neighbourhood_group, 
	price,
	ROUND (AVG (price) OVER), 2) AS avg-price,
	ROUND ((price / AVG (price) OVER() * 100), 2) AS percent_of_avg_price
FROM bookings;

-- Percent difference from average price
SELECT
	booking_id, 
	listing_name, 
	neighbourhood_group, 
	price,
	ROUND (AVG (price) OVER(), 2) AS avg-price,
	ROUND ((price / AVG (price) OVER() - 1) * 100, 2) AS percent_diff_from_avg_price
FROM bookings;

SELECT
	booking_id, 
	listing_name, 
	neighbourhood_group, 
	neighbourhood, 
	price,
	AVG (price) OVER(PARTITION BY neighbourhood_group) AS avg_price_by_neigh_group
FROM bookings;

SELECT
	booking_id, 
	listing_name, 
	neighbourhood_group, 
	neighbourhood, 
	price,
	AVG (price) OVER (PARTITION BY neighbourhood_group) AS avg-price_by_neigh_group,
	AVG (price) OVER (PARTITION BY neighbourhood_group, neighbourhood) AS avg_price_by-group_and_neigh
FROM bookings;

SELECT
	booking_id, 
	listing_name, 
	neighbourhood_group, 
	neighbourhood, 
	price,
	AVG (price) OVER(PARTITION BY neighbourhood_group) AS avg-price_by_neigh-group,
	AVG (price) OVER(PARTITION BY neighbourhood_group, neighbourhood) AS avg_price_by-group_and_neigh,
	ROUND (price - AVG(price) OVER(PARTITION BY neighbourhood_group), 2) AS neigh_group_delta,
	ROUND (price - AVG(price) OVER(PARTITION BY neighbourhood_group, neighbourhood), 2) AS group_and_neigh_delta
FROM bookings;

SELECT
	booking_id, 
	listing_name, 
	neighbourhood_group, 
	neighbourhood, 
	price,
	ROW_NUMBER() OVER(ORDER BY price DESC) AS overall_price_rank
FROM bookings;

SELECT
	booking_id,
	listing_name, 
	neighbourhood_group, 
	neighbourhood, 
	price,
	ROW_NUMBER() OVER(ORDER BY price DESC) AS overall_price_rank,
	ROW_NUMBER() OVER(PARTITION BY neighbourhood_group ORDER BY price DESC) AS neigh_group_price_rank
FROM bookings;

SELECT
	booking_id, 
	listing_name, 
	neighbourhood_group, 
	neighbourhood, 
	price,
	ROW_NUMBER() OVER(ORDER BY price DESC) AS overall_price_rank,
	ROW_NUMBER OVER(PARTITION BY neighbourhood_group ORDER BY price DESC) AS neigh-group_price_rank,
	CASE
		WHEN ROW_NUMBER () OVER(PARTITION BX neighbourhood-group ORDER BY price DESC) <= 3 THEN 'Yes'
		ELSE 'No'
	END AS top3_flag
FROM bookings;

SELECT
	booking_id, 
	listing_name, 
	neighbourhood_group, 
	neighbourhood, 
	price,
	ROW_NUMBER() OVER(ORDER BY price DESC) AS overall_price_rank,
	RANK () OVER(ORDER BY price DESC) AS overall_price_rank_with_rank,
	ROW_NUMBER() OVER(PARTITION BY neighbourhood_group ORDER BY price DESC) AS neigh-group_price_rank, RANK() OVER (PARTITION BY neighbourhood_group ORDER BY price DESC) AS neigh-group_price_rank_with_rank
FROM bookings;

SELECT
	booking_id,
	listing_name,
	neighbourhood_group ,
	neighbourhood,
	price,
	ROW_NUMBER() OVER(ORDER BY price DESC) AS overall_price_rank,
	RANK () OVER(ORDER BY price DESC) AS overall_price_rank_with_rank,
	DENSE_RANK() OVER(ORDER BY price DESC) AS overall_price_rank_with_dense_rank
FROM bookings;

-- LAG BY 1 period
SELECT|
	booking_id, 
	listing_name, 
	host_name, 
	price, 
	last_review,
	LAG (price) OVER(PARTITION BY host_name ORDER BY last_review)
FROM bookings;

-- LAG BY 2 periods
SELECT
	booking_id, 
	listing_name, 
	host_name, 
	price, 
	last_review,
	LAG (price, 2) OVER(PARTITION BY host_name ORDER BY last_review)
FROM bookings;

-- LEAD by 1 period
SELECT
	booking_id,
	listing_name, 
	host_name, 
	price, 
	last_review,
	LEAD (price) OVER(PARTITION BY host_name ORDER BY last_review)
FROM bookings;

-- LEAD by 2 periods
SELECT
	booking_id,
	listing_name,
	host_name,
	price,
	last_review,
	LEAD (price, 2) OVER(PARTITION BY host_name ORDER BY last_review)
FROM bookings;

SELECT * FROM (
	SELECT
		booking_id, 
		listing_name, 
		neighbourhood_group, 
		neighbourhood, 
		price,
		ROW_NUMBER () OVERCORDER BY price DESC) AS overall_price_rank,
		ROW_NUMBER) OVER(PARTITION BY neighbourhood_group ORDER BY price DESC) AS neigh_group_price_rank,
		CASE
			WHEN ROW_NUMBER() OVER(PARTITION BY neighbourhood_group ORDER BY price DESC) <= 3 THEN 'Yes'
			ELSE 'No'
		END AS top3_flag
	FROM bookings
	) a
WHERE top3_flag = 'Yes'