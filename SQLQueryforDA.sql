select * from blinkit_data

select count(*) from blinkit_data

-----data cleaning------
update blinkit_data
set Item_Fat_Content = 
case 
when Item_Fat_Content in ('LF','low fat') then 'Low Fat'
when Item_Fat_Content = 'reg' then 'Regular'
else Item_Fat_Content
end 

-----checking data is cleaned or not------
select distinct(Item_Fat_Content) from blinkit_data

------casting value upto 2 decimal and calculating total sales---------
select Cast(sum(Sales)/1000000 as decimal(10,2)) as Total_Sales_Millions 
from blinkit_data

---------average sales------------
select cast(avg(Sales) as decimal(10,0)) as Avg_Sales from blinkit_data

-----------no. of items----------------
select COUNT(*) as No_of_Items from blinkit_data

-----------total sales for low fat------------------
select Cast(sum(Sales)/1000000 as decimal(10,2)) as LowFat_Sales_Millions 
from blinkit_data
where Item_Fat_Content = 'Low Fat'

-----------total sales by est. year-----------------
select Cast(sum(Sales)/1000000 as decimal(10,2)) as estyear_Sales_Millions 
from blinkit_data
where Outlet_Establishment_Year = 2022

select * from blinkit_data
----------average rating-------------------------
select cast(AVG(Rating) as decimal(10,2)) as AvG_Rating
from blinkit_data

-------total sales by Fat content----------------
select Item_Fat_Content, 
                        CONCAT(CAST(ROUND(SUM(Sales)/1000, 2) AS CHAR),'K') AS Total_Sales_inThousands,
                        cast(avg(Sales) as decimal(10,1)) as Avg_Sales,
                        count(*) as No_of_Items,
                        cast(AVG(Rating) as decimal(10,2)) as AvG_Rating
                        
from blinkit_data
where Outlet_Establishment_Year = 2020
group by Item_Fat_Content
order by Total_Sales_inThousands DESC

------------Total Sales by ItemType--------------
select Top 5 Item_Type,
                        cast(sum(Sales) as decimal(10,2)) as Total_Sales,
                        cast(avg(Sales) as decimal(10,1)) as Avg_Sales,
                        count(*) as No_of_Items,
                        cast(AVG(Rating) as decimal(10,2)) as AvG_Rating
                        
from blinkit_data
group by Item_Type
order by Total_Sales ASC

--------------FaT Content by Outlet for Total Sales-----------------------------
select * from blinkit_data

select Outlet_Location_Type, 
            ISNULL([Low Fat], 0) as Low_Fat,
            ISNULL([Regular], 0) as Regular
from 
    (select Outlet_Location_Type, Item_Fat_Content,
         CAST(Sum(Sales) as decimal(10,2)) as Total_Sales
         from blinkit_data
         group by Outlet_Location_Type, Item_Fat_Content) as SourceTable
PIVOT
(   sum(Total_Sales)
    for Item_Fat_Content in ([Low Fat], [Regular])
) as PivotTable 
order by Outlet_Location_Type;

------------Total Sales by Qutlet Est. Year---------------------
select Outlet_Establishment_Year, 
           CAST(sum(Sales)as decimal(10,2)) AS Total_Sales
                        
from blinkit_data
group by Outlet_Establishment_Year
order by Total_Sales asc

-------------------percentage of sales by outlet_size--------------
select * from blinkit_data

select Outlet_Size,
       CAST(sum(Sales)as decimal(10,2)) AS Total_Sales,
       CAST((sum(Sales) * 100.0/ sum(sum(Sales)) over ()) as decimal(10,2)) AS Sales_Percentage
from blinkit_data
group by Outlet_Size
order by Total_Sales Desc

-------------sales by outlet location Type--------------
select Outlet_Location_Type,
                        cast(sum(Sales) as decimal(10,2)) as Total_Sales,
                        CAST((sum(Sales) * 100.0/ sum(sum(Sales)) over ()) as decimal(10,2)) AS Sales_Percentage,
                        cast(avg(Sales) as decimal(10,1)) as Avg_Sales,
                        count(*) as No_of_Items,
                        cast(AVG(Rating) as decimal(10,2)) as AvG_Rating
                        
from blinkit_data
group by Outlet_Location_Type
order by Total_Sales DESC

---------All the metrics by Outlet type--------------
select Outlet_Type,
                        cast(sum(Sales) as decimal(10,2)) as Total_Sales,
                        CAST((sum(Sales) * 100.0/ sum(sum(Sales)) over ()) as decimal(10,2)) AS Sales_Percentage,
                        cast(avg(Sales) as decimal(10,1)) as Avg_Sales,
                        count(*) as No_of_Items,
                        cast(AVG(Rating) as decimal(10,2)) as AvG_Rating
                        
from blinkit_data
group by Outlet_Type
order by Total_Sales DESC


