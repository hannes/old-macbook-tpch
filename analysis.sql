
create temporary table old_default as from read_json('2012_default/profile*.json', filename=TRUE) select median(latency)::DECIMAL(3,1) latency_old, (string_split(filename, '-'))[2]::int exp group by exp;

create temporary table new_default as from read_json('2023_default/profile*.json', filename=TRUE) select median(latency)::DECIMAL(3,1) latency_new, (string_split(filename, '-'))[2]::int exp group by exp;

create temporary table old_settings as from read_json('2012_settings/profile*.json', filename=TRUE) select median(latency)::DECIMAL(3,1) latency_old, (string_split(filename, '-'))[2]::int exp group by exp;

create temporary table new_settings as from read_json('2023_settings/profile*.json', filename=TRUE) select median(latency)::DECIMAL(3,1) latency_new, (string_split(filename, '-'))[2]::int exp group by exp;


.mode markdown


select 'default settings', geomean(latency_old), geomean(latency_new), geomean(latency_old)/ geomean(latency_new)  from old_default join new_default using (exp);

select 'default settings', exp, latency_old, latency_new, (latency_old/latency_new)::DECIMAL(3,1) speedup from old_default join new_default using (exp) order by exp;

select 'fair settings', geomean(latency_old), geomean(latency_new), geomean(latency_old)/ geomean(latency_new)  from old_settings join new_settings using (exp);

select 'fair settings', exp, latency_old, latency_new, (latency_old/latency_new)::DECIMAL(3,1) speedup from old_settings join new_settings using (exp) order by exp;





