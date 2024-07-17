--1.1. Проанализируйте популярность игровых режимов среди
--игроков и визуализируйте Ваши наблюдения. 
-- Расскажите, почему Вы выбрали этот подход

select
    a.team_build_type_id as users_id,
    c.cat_name as game_mode,
    count(a.arena_id) as battles_count
from
    arenas as a
inner join
    catalog_items as c
    on
        a.team_build_type_id = c.cat_value
where
    c.cat_type = 'TEAM_BUILD_TYPE'
group by
    users_id, c.cat_name
order by
    battles_count desc;
