SELECT * 
FROM jogos 
WHERE (
    (external_providers ->> 'flashscoreId' IS NOT NULL AND external_providers ->> 'flashscoreId' != 'null')
    OR 
    (external_providers ->> 'sofascoreId' IS NOT NULL AND external_providers ->> 'sofascoreId' != 'null')
  )
  AND start_time >= '2026-01-01 00:00:00'
ORDER BY start_time;


===================

SELECT * FROM public.jogos WHERE fixture_id = 'id1000001653452517'
ORDER BY fixture_id ASC LIMIT 100
===========

{
  "oddinId": null,
  "txoddsId": null,
  "lsportsId": 19348569,
  "betradarId": 53452517,
  "mollybetId": "2026-07-05,449,364",
  "pinnacleId": 1632234844,
  "betgeniusId": 13354305,
  "opticoddsId": "202607054D77BD24",
  "sofascoreId": null,
  "flashscoreId": "tpOhKWcC"
}