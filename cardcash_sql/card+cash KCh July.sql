select id,
       to_char(date, 'YYYYMMDD') as date,
       float4(amount) / 100 as sum,
case
    when t1.type = 'merchant-acquiring' then 'card'
    when t1.type = 'raiffeisen_terminal' then 'card'
    when t1.type = 'cash' then 'cash'
    end as type,
case
    when o.name = 'Клиника в Москва-Сити' then 'e884414e-345f-11e2-9222-f23cea8074d9'
    when o.name = 'Клиника в Белых садах' then '608fadf8-9055-11e2-ba2e-f1630d599bdb'
    else '720b6201-a0c4-11e1-9f3c-001e37ed2a0b' end as store_uuid,
    '4d0460ff-a0cb-11e2-9494-91acf06830ea' as company_uuid

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
date >= '2024-07-01' and date < '2024-08-01' and
t1.status = 'completed' and
t1.operation in ('payment', 'account_replenishment') and
o.name in ('Клиника в Белых садах', 'Клиника в Москва-Сити') and
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
    when o.name = 'Клиника в Москва-Сити' then 'e884414e-345f-11e2-9222-f23cea8074d9'
    when o.name = 'Клиника в Белых садах' then '608fadf8-9055-11e2-ba2e-f1630d599bdb'
    else '720b6201-a0c4-11e1-9f3c-001e37ed2a0b' end as store_uuid,
    '4d0460ff-a0cb-11e2-9494-91acf06830ea' as company_uuid

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
date >= '2024-07-01' and date < '2024-08-01' and
t1.status = 'completed' and
t1.operation in ('refund') and
o.name in ('Клиника в Белых садах', 'Клиника в Москва-Сити') and
t1.type not in ('personal-account', 'internet-acquiring', 'raiffeisen_sbp_link', 'manual_without_receipt', 'raiffeisen_qr_plate')

order by date asc