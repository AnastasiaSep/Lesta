--1.2. Проанализируйте показатели эффективности кораблей.
--Визуализируйте результаты и расскажите почему выбрали этот 
-- подход к анализу данных и визуализации.

with t as (
    select
        vehicle_type_id,
        max_hp
    from
        arena_members
),

ship_hp as (
    select
        s.item_name as ship_name,
        t.max_hp
    from
        t
    left join
        glossary_ships as s on t.vehicle_type_id = s.item_cd
    where
        s.item_name is not null
)

select
    ship_name,
    max(max_hp) as max_hp
from
    ship_hp
group by
    ship_name
order by
    max_hp desc
limit 10;


 показатели эффективности
