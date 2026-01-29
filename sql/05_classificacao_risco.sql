/*
Objetivo:
Classificar investimentos por porte (regra de negócio) usando CASE WHEN,
facilitando análise de risco e priorização.
*/

SELECT TOP 100
    txt_municipio,
    txt_uf,
    Valor_Investimento,
    CASE
        WHEN Valor_Investimento >= 1000000 THEN 'Grande Porte'
        WHEN Valor_Investimento <  100000  THEN 'Pequeno Porte'
        ELSE 'Médio Porte'
    END AS Classificacao_Risco
FROM dbo.Investimentos_Limpos
ORDER BY Valor_Investimento DESC;
