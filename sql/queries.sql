/*
Project: Audio Gear Sales Analysis
Description: This script joins sales, product, and discount data to calculate 
             total revenue, costs, and net revenue after discounts.
*/

WITH Sales_Summary AS (
    SELECT 
        p.Product_ID,
        p.Product AS Product_Name,
        p.Category,
        p.Brand,
        p.Cost_Price,
        p.Sale_Price,
        s.Country,
        s.Date,
        s.Discount_Band,
        s.Units_Sold,
        -- Calculate Gross Revenue and Total Cost
        (p.Sale_Price * s.Units_Sold) AS Gross_Revenue,
        (p.Cost_Price * s.Units_Sold) AS Total_Cost,
        -- Extract Date Parts for Reporting
        DATE_FORMAT(STR_TO_DATE(s.Date, '%e/%c/%Y'), '%M') AS Month_Name,
        YEAR(STR_TO_DATE(s.Date, '%e/%c/%Y')) AS Year
    FROM 
        product_data p
    JOIN 
        product_sales s ON p.Product_ID = s.Product
)

SELECT 
    ss.*,
    dd.Discount AS Discount_Percentage,
    -- Calculate Net Revenue: Revenue * (1 - Discount/100)
    (1 - dd.Discount * 1.0 / 100) * ss.Gross_Revenue AS Net_Revenue
FROM 
    Sales_Summary ss
JOIN 
    discount_data dd 
    ON TRIM(LOWER(dd.Discount_Band)) = TRIM(LOWER(ss.Discount_Band))
    AND TRIM(dd.Month) = TRIM(ss.Month_Name);