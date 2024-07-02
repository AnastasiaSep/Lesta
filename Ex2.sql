--2.1. Определите топ 5% игроков, которые нанесли 
--больше всего суммарного урона за все сыгранные бои.

with t as (
    select
        account_db_id,
        sum(damage + team_damage) as total_damage
    from
        arena_members
    where
        account_db_id >= 0
    group by
        account_db_id
),

k as (
    select
        account_db_id,
        total_damage,
        ntile(100) over (order by total_damage desc) as percentile
    from t
)

select
    account_db_id,
    total_damage
from k
where percentile <= 5
order by
    total_damage desc;

   

--2.2. Для каждого игрока определите корабль, на котором он нанес 
--больше всего урона за все бои. Ограничьте выгрузку 10-ю лучшими результатами

with t as (
    -- Вычисляем суммарный урон для каждого игрока на каждом корабле
    select
        account_db_id,
        vehicle_type_id,
        sum(damage + team_damage) as total_damage
    from
        arena_members
    where
        account_db_id >= 0
    group by
        account_db_id, vehicle_type_id
),

k as (
    -- Вычисляем процентиль для каждого игрока
    select
        vehicle_type_id,
        account_db_id,
        total_damage,
        NTILE(100) over (order by total_damage desc) as percentile
    from
        t
),

q as (
    -- Игроки из верхних 5 процентилей
    select
        account_db_id,
        vehicle_type_id,
        total_damage
    from
        k
    where
        percentile <= 5
    order by
        total_damage desc
)

-- Имена кораблей
select
    q.account_db_id,
    s.item_name as ship_name,
    max(q.total_damage) as dealt_damage
from
    q
left join
    glossary_ships as s on q.vehicle_type_id = s.item_cd  
where
    s.item_name is not null 
group by
    q.account_db_id,
    s.item_name
order by
    dealt_damage desc
limit 10;
