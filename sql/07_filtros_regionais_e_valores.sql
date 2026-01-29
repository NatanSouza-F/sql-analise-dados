/*
Objetivo:
Exemplos de filtros clássicos (IN, BETWEEN, LIKE) para consultas operacionais.
*/

-- 1) Filtro por UFs específicas (ex: Centro-Oeste)
SELECT *
FROM dbo.Investimentos_Limpos
WHERE txt_uf IN ('DF', 'GO', 'MT', 'MS');

-- 2) Investimentos em uma faixa de valor
SELECT
    txt_municipio,
    txt_uf,
    Valor_Investimento
FROM dbo.Investimentos_Limpos
WHERE Valor_Investimento BETWEEN 100000 AND 500000
ORDER BY Valor_Investimento DESC;

-- 3) Busca textual por padrão no município
SELECT
    txt_municipio,
    txt_uf
FROM dbo.Investimentos_Limpos
WHERE txt_municipio LIKE '%PARÁ%';

