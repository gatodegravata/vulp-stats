SELECT DISTINCT ON (unificado.time_id, unificado.tournament_slug)
    unificado.time_id,
    unificado.tournament_slug,
    unificado.tournament_name,
    unificado.category_slug,
    unificado.category_name,
    unificado.nome_completo,
    unificado.nome_curto,
    unificado.ultimo_registro_visto
FROM (
    -- Unifica Mandantes
    SELECT 
        participant1_id AS time_id,
        tournament_slug,
        tournament_name,
        category_slug,
        category_name,
        participant1_name AS nome_completo,
        participant1_short_name AS nome_curto,
        start_time AS ultimo_registro_visto
    FROM jogos
    WHERE start_time >= '2026-01-01 00:00:00+00'

    UNION ALL

    -- Unifica Visitantes
    SELECT 
        participant2_id AS time_id,
        tournament_slug,
        tournament_name, -- Adicionado para igualar
        category_slug,   -- Adicionado para igualar
        category_name,   -- Adicionado para igualar
        participant2_name AS nome_completo,
        participant2_short_name AS nome_curto,
        start_time AS ultimo_registro_visto
    FROM jogos
    WHERE start_time >= '2026-01-01 00:00:00+00'
) AS unificado
ORDER BY 
    unificado.time_id, 
    unificado.tournament_slug, 
    unificado.ultimo_registro_visto DESC;