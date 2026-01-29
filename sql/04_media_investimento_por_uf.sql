/*
Objetivo:
Identificar as 10 UFs com maior ticket médio de investimento,
considerando apenas UFs com média acima de R$ 500.000.
*/

SELECT TOP 10
    txt_uf,
    AVG(Valor_Investimento) AS Media_Investimento
FROM dbo.Investimentos_Limpos
GROUP BY txt_uf
HAVING AVG(Valor_Investimento) > 500000
ORDER BY Media_Investimento DESC;

