/*
Objetivo:
Listar os 10 maiores investimentos (ranking), exibindo município, UF, valor e origem.
*/

SELECT TOP 10
    txt_municipio,
    txt_uf,
    Valor_Investimento,
    txt_origem
FROM dbo.Investimentos_Limpos
ORDER BY Valor_Investimento DESC;
