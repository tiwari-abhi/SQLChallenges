/* Using this dataset, show the SQL query to find the rolling 3 day average transaction amount for each day in January 2021. */

WITH CTE AS (
  SELECT 
      q.dt,
      SUM(transaction_amount) "day_total"
  FROM (
    SELECT 
        transaction_time,
        transaction_amount,
        DATE(transaction_time) "dt"
    FROM transactions
  ) q
  GROUP BY q.dt
)

SELECT
  dt,
  day_total,
  CASE
     WHEN COUNT(*) OVER (ORDER BY dt ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) = 3 THEN
     AVG(day_total) OVER (ORDER BY dt ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)
     ELSE day_total
  END AS THREE_DAY_ROLLING_AVG
FROM CTE
