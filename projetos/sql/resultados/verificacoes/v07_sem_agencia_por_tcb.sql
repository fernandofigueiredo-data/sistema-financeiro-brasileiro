-- v07. Instituições com zero agências por TCB, e postos de atendimento desses grupos
SELECT i.tcb, tcbd.descricao,
       COUNT(*) AS "qtd",
       COUNT(*) FILTER (WHERE e.num_agencias = 0) AS "qtd_zero_agencias",
       MIN(e.num_agencias) AS "min_agencias",
       SUM(e.num_agencias) AS "agencias",
       SUM(e.num_postos) AS "postos"
FROM instituicoes i
JOIN estrutura e ON e.inst_id = i.id
JOIN tipos_consolidado tcbd ON tcbd.tcb = i.tcb
GROUP BY i.tcb, tcbd.descricao
ORDER BY i.tcb;
