/*
Objetivo:
Isolar casos com alto valor investido e repasse zerado (anomalia),
para apoio a auditoria e análise de risco.
*/

SELECT
    txt_municipio,
    txt_uf,
    Valor_Investimento,
    Valor_Repasse,
    Data_Carga
FROM dbo.Investimentos_Limpos
WHERE Valor_Investimento > 1000000
  AND Valor_Repasse = 0
ORDER BY Valor_Investimento DESC;

