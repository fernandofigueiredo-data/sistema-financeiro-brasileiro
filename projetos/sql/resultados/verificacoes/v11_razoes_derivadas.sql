-- v11. Razões derivadas citadas no README e na ANÁLISE_FINAL (todas sobre instituições com dados)
WITH t AS (
    SELECT SUM(f.ativo_total)::NUMERIC AS at_sis,
           AVG(f.ativo_total)::NUMERIC AS at_med,
           (PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY f.ativo_total))::NUMERIC AS at_mdn,
           SUM(f.ativo_total) FILTER (WHERE i.tc = 1)::NUMERIC AS at_pub,
           SUM(f.ativo_total) FILTER (WHERE i.id IN (1, 2, 6))::NUMERIC AS at_bb_cef_bndes,
           SUM(f.ativo_total) FILTER (WHERE i.ti = 8)::NUMERIC AS at_multiplo,
           SUM(f.ativo_total) FILTER (WHERE i.tcb IN ('b3S', 'b3C'))::NUMERIC AS at_coop,
           COUNT(*) FILTER (WHERE i.tcb IN ('b3S', 'b3C'))::NUMERIC AS n_coop_com_dados
    FROM instituicoes i JOIN financeiros f ON f.inst_id = i.id
    WHERE f.ativo_total IS NOT NULL
), n AS (
    SELECT COUNT(*)::NUMERIC AS n_total,
           COUNT(*) FILTER (WHERE tcb IN ('b3S', 'b3C'))::NUMERIC AS n_coop
    FROM instituicoes
)
SELECT 'razao_ativo_medio_sobre_mediano' AS "indicador", ROUND(at_med / at_mdn, 1) AS "valor" FROM t
UNION ALL SELECT 'pct_ativo_sistema_bb_cef_bndes', ROUND(100 * at_bb_cef_bndes / at_sis, 1) FROM t
UNION ALL SELECT 'pct_ativo_publico_que_esta_em_bb_cef_bndes', ROUND(100 * at_bb_cef_bndes / at_pub, 1) FROM t
UNION ALL SELECT 'pct_ativo_sistema_ti8_banco_multiplo', ROUND(100 * at_multiplo / at_sis, 1) FROM t
UNION ALL SELECT 'pct_ativo_sistema_cooperativas_b3S_b3C', ROUND(100 * at_coop / at_sis, 1) FROM t
UNION ALL SELECT 'pct_instituicoes_cooperativas_b3S_b3C', ROUND(100 * n_coop / n_total, 1) FROM n
UNION ALL SELECT 'roe_semestre_agregado_menos_media_simples_pp', 7.52 - 0.84;
