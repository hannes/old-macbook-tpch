
create temporary table new_default as from read_json('sf1000_2023/profile*.json', filename=TRUE) select median(latency)::DECIMAL(5,1) latency_new, (string_split(filename, '-'))[2]::int exp group by exp;

create temporary table new_default2 as from read_json('sf1000_2023/profile*.json', filename=TRUE) select *, latency::DECIMAL(5,1) latency_new, (string_split(filename, '-'))[2]::int exp order by exp;

-- from new_default

create temporary table new_default2 as from read_json('sf1000_2012/profile*.json', filename=TRUE) select  latency::DECIMAL(5,1) latency_old, string_split(filename, '-') exp;
from new_default2 select exp[2]::int query, latency_old latency where exp[3] = '1.json' order by query;




create temporary table old_default as from read_json('sf1000_2012/profile*.json', filename=TRUE) select median(latency)::DECIMAL(5,1) latency_old, (string_split(filename, '-'))[2]::int exp group by exp;



.mode markdown


select sum(latency_old) sum_old, geomean(latency_old)::DECIMAL(5,1) geomean_old, from old_default;


select exp query, latency_old latency, (latency/60.0)::DECIMAL(5,1) mins from old_default order by exp;


select sum(latency_old) sum_old, sum(latency_new) sum_new, geomean(latency_old)::DECIMAL(5,1) geomean_old, geomean(latency_new)::DECIMAL(5,1) geomean_new, (geomean(latency_old)/ geomean(latency_new))::DECIMAL(5,1) speedup from old_default join new_default using (exp);

select exp query, latency_old, latency_new, (latency_old/latency_new)::DECIMAL(4,2) speedup from old_default join new_default using (exp) order by exp;




