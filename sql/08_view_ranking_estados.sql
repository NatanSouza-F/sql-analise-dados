/*
Objetivo:
Criar uma VIEW reutilizável para consolidar investimentos por UF.
Boa prática para camadas analíticas e consumo em BI/relatórios.
*/

CREATE OR ALTER VIEW dbo.Ranking_Estados AS
SELECT
    txt_uf,
    COUNT(*) AS Qtd_Projetos,
    SUM(Valor_Investimento) AS Total_Investido
FROM dbo.Investimentos_Limpos
GROUP BY txt_uf;
GO

-- Uso da view (ordenar fora da view)
SELECT *
FROM dbo.Ranking_Estados
ORDER BY Total_Investido DESC;
GO
