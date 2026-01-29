/*
Objetivo:
Consolidar investimentos por UF (quantidade de projetos e total investido),
ordenando do maior para o menor volume financeiro.
*/

SELECT
    txt_uf,
    COUNT(*) AS Qtd_Projetos,
    SUM(Valor_Investimento) AS Total_Investido
FROM dbo.Investimentos_Limpos
GROUP BY txt_uf
ORDER BY Total_Investido DESC;

