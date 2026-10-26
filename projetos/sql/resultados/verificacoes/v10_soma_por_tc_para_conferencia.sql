-- v10. Somas por TC no banco, para conferir contra a aba Totais_Fonte do Excel
SELECT i.tc, SUM(f.ativo_total) AS "ativo_soma_banco", SUM(f.lucro_liquido) AS "lucro_soma_banco",
       SUM(f.patrimonio_liquido) AS "pl_soma_banco", SUM(e.num_agencias) AS "agencias_banco"
FROM instituicoes i JOIN financeiros f ON f.inst_id = i.id JOIN estrutura e ON e.inst_id = i.id
GROUP BY i.tc ORDER BY i.tc;
