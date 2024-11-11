select id,
       to_char(date, 'YYYYMMDD') as date,
       float4(amount) / 100 as sum,
case
    when t1.type = 'merchant-acquiring' then 'card'
    when t1.type = 'raiffeisen_terminal' then 'card'
    when t1.type = 'cash' then 'cash'
    end as type,
case
    when o.name = 'Клиника на Университете' then 'f966000c-3c48-11dd-96d9-000c6e46fcad' end as store_uuid,
'c84cdf1b-6720-11ed-a221-00155d59dd05' as company_uuid

from

(select fp.payment_id as id,
        fp.method::json->>'type' as type,
        fp.amount as amount,
        fp.organization_id as org_id,
        fp.author_id as user_id,
        fp.created_at as date,
        fp.status as status,
        fp.operation as operation
 from finance.payment fp) as t1

join organization o on o.organization_id = t1.org_id
join users u on u.user_id = t1.user_id

where
date >= '2024-10-01' and date < '2024-11-01' and
t1.status = 'completed' and
t1.operation in ('payment', 'account_replenishment') and
o.name in ('Клиника на Университете') and
t1.type not in ('personal-account', 'internet-acquiring', 'raiffeisen_sbp_link', 'manual_without_receipt', 'raiffeisen_qr_plate')



union



select id,
       to_char(date, 'YYYYMMDD') as date,
       float4(-amount) / 100 as sum,
case
    when t1.type = 'merchant-acquiring' then 'card'
    when t1.type = 'raiffeisen_terminal' then 'card'
    when t1.type = 'cash' then 'cash'
    end as type,
case
    when o.name = 'Клиника на Университете' then 'f966000c-3c48-11dd-96d9-000c6e46fcad' end as store_uuid,
'c84cdf1b-6720-11ed-a221-00155d59dd05' as company_uuid

from

(select fp.payment_id as id,
        fp.method::json->>'type' as type,
        fp.amount as amount,
        fp.organization_id as org_id,
        fp.author_id as user_id,
        fp.created_at as date,
        fp.status as status,
        fp.operation as operation
 from finance.payment fp) as t1

join organization o on o.organization_id = t1.org_id
join users u on u.user_id = t1.user_id

where
date >= '2024-10-01' and date < '2024-11-01' and
t1.status = 'completed' and
t1.operation in ('refund') and
o.name in ('Клиника на Университете') and
t1.type not in ('personal-account', 'internet-acquiring', 'raiffeisen_sbp_link', 'manual_without_receipt', 'raiffeisen_qr_plate')

order by date asc