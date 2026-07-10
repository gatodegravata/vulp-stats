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

    -- Resultado Final 1X2
    MAX(price) FILTER (WHERE market = '101' AND outcome = '101' AND ord = 1) AS "1_abertura",
    MAX(price) FILTER (WHERE market = '101' AND outcome = '101' AND is_last) AS "1_fechamento",
    MAX(price) FILTER (WHERE market = '101' AND outcome = '102' AND ord = 1) AS "X_abertura",
    MAX(price) FILTER (WHERE market = '101' AND outcome = '102' AND is_last) AS "X_fechamento",
    MAX(price) FILTER (WHERE market = '101' AND outcome = '103' AND ord = 1) AS "2_abertura",
    MAX(price) FILTER (WHERE market = '101' AND outcome = '103' AND is_last) AS "2_fechamento",

    -- Ambas Marcam BTTS
    MAX(price) FILTER (WHERE market = '104' AND outcome = '104' AND ord = 1) AS "odd_yes_abertura",
    MAX(price) FILTER (WHERE market = '104' AND outcome = '104' AND is_last) AS "odd_yes_fechamento",
    MAX(price) FILTER (WHERE market = '104' AND outcome = '105' AND ord = 1) AS "odd_no_abertura",
    MAX(price) FILTER (WHERE market = '104' AND outcome = '105' AND is_last) AS "odd_no_fechamento",

    -------------------------------------------------------------------------
    -- MERCADOS EUROPEUS (Over/Under Padrão)
    -------------------------------------------------------------------------
    
    -- Linha 0.5 Gols (Mercado 1060)
    MAX(price) FILTER (WHERE market = '1060' AND outcome = '1060' AND ord = 1) AS "over05_abertura",
    MAX(price) FILTER (WHERE market = '1060' AND outcome = '1060' AND is_last) AS "over05_fechamento",
    MAX(price) FILTER (WHERE market = '1060' AND outcome = '1061' AND ord = 1) AS "under05_abertura",
    MAX(price) FILTER (WHERE market = '1060' AND outcome = '1061' AND is_last) AS "under05_fechamento",

    -- Linha 1.5 Gols (Mercado 1062)
    MAX(price) FILTER (WHERE market = '1062' AND outcome = '1062' AND ord = 1) AS "over15_abertura",
    MAX(price) FILTER (WHERE market = '1062' AND outcome = '1062' AND is_last) AS "over15_fechamento",
    MAX(price) FILTER (WHERE market = '1062' AND outcome = '1063' AND ord = 1) AS "under15_abertura",
    MAX(price) FILTER (WHERE market = '1062' AND outcome = '1063' AND is_last) AS "under15_fechamento",

    -- Linha 2.5 Gols (Mercado 1010)
    MAX(price) FILTER (WHERE market = '1010' AND outcome = '1010' AND ord = 1) AS "over25_abertura",
    MAX(price) FILTER (WHERE market = '1010' AND outcome = '1010' AND is_last) AS "over25_fechamento",
    MAX(price) FILTER (WHERE market = '1010' AND outcome = '1011' AND ord = 1) AS "under25_abertura",
    MAX(price) FILTER (WHERE market = '1010' AND outcome = '1011' AND is_last) AS "under25_fechamento",

    -- Linha 3.5 Gols (Mercado 1012)
    MAX(price) FILTER (WHERE market = '1012' AND outcome = '1012' AND ord = 1) AS "over35_abertura",
    MAX(price) FILTER (WHERE market = '1012' AND outcome = '1012' AND is_last) AS "over35_fechamento",
    MAX(price) FILTER (WHERE market = '1012' AND outcome = '1013' AND ord = 1) AS "under35_abertura",
    MAX(price) FILTER (WHERE market = '1012' AND outcome = '1013' AND is_last) AS "under35_fechamento",

    -- Linha 4.5 Gols (Mercado 1014)
    MAX(price) FILTER (WHERE market = '1014' AND outcome = '1014' AND ord = 1) AS "over45_abertura",
    MAX(price) FILTER (WHERE market = '1014' AND outcome = '1014' AND is_last) AS "over45_fechamento",
    MAX(price) FILTER (WHERE market = '1014' AND outcome = '1015' AND ord = 1) AS "under45_abertura",
    MAX(price) FILTER (WHERE market = '1014' AND outcome = '1015' AND is_last) AS "under45_fechamento",

    -- Linha 5.5 Gols (Mercado 1016)
    MAX(price) FILTER (WHERE market = '1016' AND outcome = '1016' AND ord = 1) AS "over55_abertura",
    MAX(price) FILTER (WHERE market = '1016' AND outcome = '1016' AND is_last) AS "over55_fechamento",
    MAX(price) FILTER (WHERE market = '1016' AND outcome = '1017' AND ord = 1) AS "under55_abertura",
    MAX(price) FILTER (WHERE market = '1016' AND outcome = '1017' AND is_last) AS "under55_fechamento",

    -- Linha 6.5 Gols (Mercado 1018)
    MAX(price) FILTER (WHERE market = '1018' AND outcome = '1018' AND ord = 1) AS "over65_abertura",
    MAX(price) FILTER (WHERE market = '1018' AND outcome = '1018' AND is_last) AS "over65_fechamento",
    MAX(price) FILTER (WHERE market = '1018' AND outcome = '1019' AND ord = 1) AS "under65_abertura",
    MAX(price) FILTER (WHERE market = '1018' AND outcome = '1019' AND is_last) AS "under65_fechamento",

    -------------------------------------------------------------------------
    -- MERCADOS ASIÁTICOS (Asian Total Goals)
    -------------------------------------------------------------------------
    
    -- Handicap 0.25 (Mercado 10158)
    MAX(price) FILTER (WHERE market = '10158' AND outcome = '10158' AND ord = 1) AS "over025_abertura",
    MAX(price) FILTER (WHERE market = '10158' AND outcome = '10158' AND is_last) AS "over025_fechamento",
    MAX(price) FILTER (WHERE market = '10158' AND outcome = '10159' AND ord = 1) AS "under025_abertura",
    MAX(price) FILTER (WHERE market = '10158' AND outcome = '10159' AND is_last) AS "under025_fechamento",

    -- Handicap 0.75 (Mercado 10160)
    MAX(price) FILTER (WHERE market = '10160' AND outcome = '10160' AND ord = 1) AS "over075_abertura",
    MAX(price) FILTER (WHERE market = '10160' AND outcome = '10160' AND is_last) AS "over075_fechamento",
    MAX(price) FILTER (WHERE market = '10160' AND outcome = '10161' AND ord = 1) AS "under075_abertura",
    MAX(price) FILTER (WHERE market = '10160' AND outcome = '10161' AND is_last) AS "under075_fechamento",

    -- Handicap 1.00 (Mercado 10162)
    MAX(price) FILTER (WHERE market = '10162' AND outcome = '10162' AND ord = 1) AS "over10_abertura",
    MAX(price) FILTER (WHERE market = '10162' AND outcome = '10162' AND is_last) AS "over10_fechamento",
    MAX(price) FILTER (WHERE market = '10162' AND outcome = '10163' AND ord = 1) AS "under10_abertura",
    MAX(price) FILTER (WHERE market = '10162' AND outcome = '10163' AND is_last) AS "under10_fechamento",

    -- Handicap 1.25 (Mercado 10164)
    MAX(price) FILTER (WHERE market = '10164' AND outcome = '10164' AND ord = 1) AS "over125_abertura",
    MAX(price) FILTER (WHERE market = '10164' AND outcome = '10164' AND is_last) AS "over125_fechamento",
    MAX(price) FILTER (WHERE market = '10164' AND outcome = '10165' AND ord = 1) AS "under125_abertura",
    MAX(price) FILTER (WHERE market = '10164' AND outcome = '10165' AND is_last) AS "under125_fechamento",

    -- Handicap 1.75 (Mercado 10166)
    MAX(price) FILTER (WHERE market = '10166' AND outcome = '10166' AND ord = 1) AS "over175_abertura",
    MAX(price) FILTER (WHERE market = '10166' AND outcome = '10166' AND is_last) AS "over175_fechamento",
    MAX(price) FILTER (WHERE market = '10166' AND outcome = '10167' AND ord = 1) AS "under175_abertura",
    MAX(price) FILTER (WHERE market = '10166' AND outcome = '10167' AND is_last) AS "under175_fechamento",

    -- Handicap 2.00 (Mercado 10168)
    MAX(price) FILTER (WHERE market = '10168' AND outcome = '10168' AND ord = 1) AS "over20_abertura",
    MAX(price) FILTER (WHERE market = '10168' AND outcome = '10168' AND is_last) AS "over20_fechamento",
    MAX(price) FILTER (WHERE market = '10168' AND outcome = '10169' AND ord = 1) AS "under20_abertura",
    MAX(price) FILTER (WHERE market = '10168' AND outcome = '10169' AND is_last) AS "under20_fechamento",

    -- Handicap 2.25 (Mercado 10170)
    MAX(price) FILTER (WHERE market = '10170' AND outcome = '10170' AND ord = 1) AS "over225_abertura",
    MAX(price) FILTER (WHERE market = '10170' AND outcome = '10170' AND is_last) AS "over225_fechamento",
    MAX(price) FILTER (WHERE market = '10170' AND outcome = '10171' AND ord = 1) AS "under225_abertura",
    MAX(price) FILTER (WHERE market = '10170' AND outcome = '10171' AND is_last) AS "under225_fechamento",

    -- Handicap 2.75 (Mercado 10172)
    MAX(price) FILTER (WHERE market = '10172' AND outcome = '10172' AND ord = 1) AS "over275_abertura",
    MAX(price) FILTER (WHERE market = '10172' AND outcome = '10172' AND is_last) AS "over275_fechamento",
    MAX(price) FILTER (WHERE market = '10172' AND outcome = '10173' AND ord = 1) AS "under275_abertura",
    MAX(price) FILTER (WHERE market = '10172' AND outcome = '10173' AND is_last) AS "under275_fechamento",

    -- Handicap 3.00 (Mercado 10174)
    MAX(price) FILTER (WHERE market = '10174' AND outcome = '10174' AND ord = 1) AS "over30_abertura",
    MAX(price) FILTER (WHERE market = '10174' AND outcome = '10174' AND is_last) AS "over30_fechamento",
    MAX(price) FILTER (WHERE market = '10174' AND outcome = '10175' AND ord = 1) AS "under30_abertura",
    MAX(price) FILTER (WHERE market = '10174' AND outcome = '10175' AND is_last) AS "under30_fechamento",

    -- Handicap 3.25 (Mercado 10176)
    MAX(price) FILTER (WHERE market = '10176' AND outcome = '10176' AND ord = 1) AS "over325_abertura",
    MAX(price) FILTER (WHERE market = '10176' AND outcome = '10176' AND is_last) AS "over325_fechamento",
    MAX(price) FILTER (WHERE market = '10176' AND outcome = '10177' AND ord = 1) AS "under325_abertura",
    MAX(price) FILTER (WHERE market = '10176' AND outcome = '10177' AND is_last) AS "under325_fechamento",

    -- Handicap 3.75 (Mercado 10178)
    MAX(price) FILTER (WHERE market = '10178' AND outcome = '10178' AND ord = 1) AS "over375_abertura",
    MAX(price) FILTER (WHERE market = '10178' AND outcome = '10178' AND is_last) AS "over375_fechamento",
    MAX(price) FILTER (WHERE market = '10178' AND outcome = '10179' AND ord = 1) AS "under375_abertura",
    MAX(price) FILTER (WHERE market = '10178' AND outcome = '10179' AND is_last) AS "under375_fechamento",

    -- Handicap 4.00 (Mercado 10180)
    MAX(price) FILTER (WHERE market = '10180' AND outcome = '10180' AND ord = 1) AS "over40_abertura",
    MAX(price) FILTER (WHERE market = '10180' AND outcome = '10180' AND is_last) AS "over40_fechamento",
    MAX(price) FILTER (WHERE market = '10180' AND outcome = '10181' AND ord = 1) AS "under40_abertura",
    MAX(price) FILTER (WHERE market = '10180' AND outcome = '10181' AND is_last) AS "under40_fechamento",

    -- Handicap 4.25 (Mercado 10182)
    MAX(price) FILTER (WHERE market = '10182' AND outcome = '10182' AND ord = 1) AS "over425_abertura",
    MAX(price) FILTER (WHERE market = '10182' AND outcome = '10182' AND is_last) AS "over425_fechamento",
    MAX(price) FILTER (WHERE market = '10182' AND outcome = '10183' AND ord = 1) AS "under425_abertura",
    MAX(price) FILTER (WHERE market = '10182' AND outcome = '10183' AND is_last) AS "under425_fechamento",

    -- Handicap 4.75 (Mercado 10184)
    MAX(price) FILTER (WHERE market = '10184' AND outcome = '10184' AND ord = 1) AS "over475_abertura",
    MAX(price) FILTER (WHERE market = '10184' AND outcome = '10184' AND is_last) AS "over475_fechamento",
    MAX(price) FILTER (WHERE market = '10184' AND outcome = '10185' AND ord = 1) AS "under475_abertura",
    MAX(price) FILTER (WHERE market = '10184' AND outcome = '10185' AND is_last) AS "under475_fechamento",

    -- Handicap 5.00 (Mercado 10186)
    MAX(price) FILTER (WHERE market = '10186' AND outcome = '10186' AND ord = 1) AS "over50_abertura",
    MAX(price) FILTER (WHERE market = '10186' AND outcome = '10186' AND is_last) AS "over50_fechamento",
    MAX(price) FILTER (WHERE market = '10186' AND outcome = '10187' AND ord = 1) AS "under50_abertura",
    MAX(price) FILTER (WHERE market = '10186' AND outcome = '10187' AND is_last) AS "under50_fechamento"

FROM jogos j

-- Mantemos o INNER JOIN para garantir que o jogo possui um registro de odds
JOIN jogos_odds o  
  ON j.fixture_id = o.fixture_id
  -- Esta condição garante que a lista de mercados NÃO está vazia '{}' e nem é nula
  AND o.odds_brutas->'bookmakers'->'bet365'->'markets' IS NOT NULL
  AND o.odds_brutas->'bookmakers'->'bet365'->'markets' <> '{}'::jsonb

LEFT JOIN LATERAL (
    SELECT 
        m.key AS market,
        oc.key AS outcome,
        (pl_elem->>'price')::numeric AS price,
        pl.ord,
        pl.is_last

    FROM jsonb_each(
        COALESCE(o.odds_brutas->'bookmakers'->'bet365'->'markets', '{}'::jsonb)
    ) m
	
    JOIN LATERAL jsonb_each(m.value->'outcomes') oc ON true

    JOIN LATERAL (
        SELECT 
            pl_elem,
            ROW_NUMBER() OVER (
                PARTITION BY o.fixture_id, m.key, oc.key
                ORDER BY (pl_elem->>'createdAt')::timestamp ASC
            ) AS ord,
            ROW_NUMBER() OVER (
                PARTITION BY o.fixture_id, m.key, oc.key
                ORDER BY CASE 
                    WHEN (pl_elem->>'createdAt')::timestamp <= j.start_time 
                    THEN (pl_elem->>'createdAt')::timestamp 
                    ELSE '1970-01-01'::timestamp 
                END DESC
            ) = 1 AS is_last
        FROM jsonb_array_elements(
            COALESCE(oc.value->'players'->'0', '[]'::jsonb)
        ) pl(pl_elem)
    ) pl ON true

) odds ON true

WHERE j.start_time >= '2025-10-01 00:00:00+00'
  AND j.start_time <= '2026-05-26 23:59:59+00'
  AND j.participant1_name NOT LIKE '%SRL%'

GROUP BY 
    j.start_time,
    j.tournament_slug,
    j.category_slug,
    j.participant1_id,
    j.participant1_name,
    j.fixture_id

ORDER BY j.start_time ASC;