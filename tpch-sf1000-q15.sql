-- using 1747209377 as a seed to the RNG


with revenue0 as (select
		l_suppkey supplier_no,
		sum(l_extendedprice * (1 - l_discount)) total_revenue
	from
		lineitem
	where
		l_shipdate >= date '1996-11-01'
		and l_shipdate < date '1996-11-01' + interval '3' month
	group by
		l_suppkey)
select
	s_suppkey,
	s_name,
	s_address,
	s_phone,
	total_revenue
from
	supplier,
	revenue0
where
	s_suppkey = supplier_no
	and total_revenue = (
		select
			max(total_revenue)
		from
			revenue0
	)
order by
	s_suppkey;

