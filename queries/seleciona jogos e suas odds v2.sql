SELECT 
    TO_CHAR(j.start_time, 'YYYY-MM-DD') as "Data",
    TO_CHAR(j.start_time, 'HH24:MI') as "Horario",
    j.tournament_slug,
    j.category_slug,
    j.participant1_id,
    j.participant1_name,
    j.participant2_id,
    j.participant2_name,
    j.fixture_id,

    -- 1 (casa)
    MAX(price) FILTER (WHERE market = '101' AND outcome = '101' AND ord = 1) AS "1_abertura",
    MAX(price) FILTER (WHERE market = '101' AND outcome = '101' AND is_last) AS "1_fechamento",

    -- X
    MAX(price) FILTER (WHERE market = '101' AND outcome = '102' AND ord = 1) AS "X_abertura",
    MAX(price) FILTER (WHERE market = '101' AND outcome = '102' AND is_last) AS "X_fechamento",

    -- 2
    MAX(price) FILTER (WHERE market = '101' AND outcome = '103' AND ord = 1) AS "2_abertura",
    MAX(price) FILTER (WHERE market = '101' AND outcome = '103' AND is_last) AS "2_fechamento",

    -- BTTS YES
    MAX(price) FILTER (WHERE market = '104' AND outcome = '104' AND ord = 1) AS "odd_yes_abertura",
    MAX(price) FILTER (WHERE market = '104' AND outcome = '104' AND is_last) AS "odd_yes_fechamento",

    -- OVER 2.5 GOLS (Market 1010 / Outcome 1010)
    MAX(price) FILTER (WHERE market = '1010' AND outcome = '1010' AND ord = 1) AS "over25_abertura",
    MAX(price) FILTER (WHERE market = '1010' AND outcome = '1010' AND is_last) AS "over25_fechamento",

    -- UNDER 2.5 GOLS (Market 1010 / Outcome 1011)
    MAX(price) FILTER (WHERE market = '1010' AND outcome = '1011' AND ord = 1) AS "under25_abertura",
    MAX(price) FILTER (WHERE market = '1010' AND outcome = '1011' AND is_last) AS "under25_fechamento"

FROM jogos j

JOIN jogos_odds o 
  ON j.fixture_id = o.fixture_id
  AND (
    COALESCE(o.odds_brutas->'bookmakers'->'bet365'->'markets', '{}'::jsonb) ? '104'
    OR COALESCE(o.odds_brutas->'bookmakers'->'bet365'->'markets', '{}'::jsonb) ? '1010'
  )

LEFT JOIN LATERAL (
    SELECT 
        m.key AS market,
        oc.key AS outcome,
        (pl_elem->>'price')::numeric AS price,
        pl.ord,
        pl.is_last

    FROM jsonb_each(
        COALESCE(o.odds_brutas->'bookmakers'->'bet365'->'markets', '{}'::jsonb)
    ) m -- <-- Parêntese corrigido aqui

    JOIN LATERAL jsonb_each(m.value->'outcomes') oc ON true

    JOIN LATERAL (
        SELECT 
            pl_elem,
            ROW_NUMBER() OVER (
                PARTITION BY j.fixture_id, m.key, oc.key
                ORDER BY (pl_elem->>'createdAt')::timestamp ASC
            ) AS ord,
            ROW_NUMBER() OVER (
                PARTITION BY j.fixture_id, m.key, oc.key
                ORDER BY (pl_elem->>'createdAt')::timestamp DESC
            ) = 1 AS is_last
        FROM jsonb_array_elements(
            COALESCE(oc.value->'players'->'0', '[]'::jsonb)
        ) pl(pl_elem)
    ) pl ON true

) odds ON true

WHERE j.start_time >= '2025-10-01 00:00:00+00'
  AND j.start_time <= '2026-05-25 23:59:59+00'
  AND j.participant1_name NOT LIKE '%SRL%'

GROUP BY 
    j.start_time,
    j.tournament_slug,
    j.category_slug,
    j.participant1_id,
    j.participant1_name,
    j.participant2_id,
    j.participant2_name,
    j.fixture_id

ORDER BY j.start_time ASC;