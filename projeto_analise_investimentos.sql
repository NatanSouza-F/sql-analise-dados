# Scripts de SQL para consulta

**Titulo: Limpeza de Dados e Criação da Tabela Final (ETL)**

Este script resolve os problemas de formatação brasileira (vírgulas e datas invertidas) e cria uma tabela nova pronta para análise.
Segurança (IF OBJECT_ID... DROP): Verifica se a tabela Investimentos_Limpos já existe. Se existir, ele apaga ela para criar uma nova do zero (evita erro de duplicidade).
Tratamento de Dinheiro (REPLACE + CAST): Remove os pontos de milhar.
Troca a vírgula decimal por ponto (padrão do SQL).
Transforma o texto em número DECIMAL (para permitir contas matemáticas).
Tratamento de Data (LEFT + TRY_CONVERT): LEFT(..., 10): Pega apenas os 10 primeiros dígitos da data (ex: "2026/01/26") ignorando o horário zerado.TRY_CONVERT(..., 111): Converte o texto no formato "Ano/Mês/Dia" para uma Data real.
Criação da Tabela (INTO): Salva todo esse resultado tratado numa tabela nova chamada Investimentos_Limpos.

USE DadosPublicos;

IF OBJECT_ID('Investimentos_Limpos', 'U') IS NOT NULL 
DROP TABLE Investimentos_Limpos;

SELECT 
    cod_proposta,
    txt_municipio,
    txt_uf,
    
    CAST(REPLACE(REPLACE(vlr_investimento, '.', ''), ',', '.') AS DECIMAL(18,2)) AS Valor_Investimento,
    CAST(REPLACE(REPLACE(vlr_repasse, '.', ''), ',', '.') AS DECIMAL(18,2)) AS Valor_Repasse,
    TRY_CONVERT(DATE, LEFT(dte_carga, 10), 111) AS Data_Carga,
    
    txt_origem

INTO Investimentos_Limpos
FROM carteira_investimento_mcid;

-- Resultado Final
SELECT TOP 100 * FROM Investimentos_Limpos;
```

```sql
**Título: Ranking dos Maiores Projetos (Ordenação)**

Esta consulta serve para identificar rapidamente os "Outliers" (os valores mais altos) da tabela. Respondemos a pergunta: "Quem está recebendo mais dinheiro?".

SELECT TOP 10:

Como a tabela tem milhares de linhas, usamos o TOP para trazer apenas as 10 primeiras. Isso deixa a consulta leve e focada.

ORDER BY ... DESC:

O segredo está aqui. Ordenamos a coluna Valor_Investimento de forma Descendente (do Maior para o Menor).

Sem o DESC, ele traria os menores valores (os mais baratos).

SELECT TOP 10
    txt_municipio,
    txt_uf,
    Valor_Investimento,
    txt_origem
FROM Investimentos_Limpos
ORDER BY Valor_Investimento DESC;
```

```sql
**Título: Resumo por Estado (Agrupamento)**

Esta consulta serve para transformar dados detalhados em informação gerencial. Em vez de ver linha por linha, vemos o Total de cada região.
COUNT(*): Serve para medir Volume. Conta quantas linhas (projetos) existem dentro de cada grupo.
SUM(Valor_Investimento): Serve para medir Valor. Soma todo o dinheiro dos projetos daquele grupo.
GROUP BY txt_uf: O comando principal. Ele "esmaga" as milhares de linhas, juntando tudo que tem a mesma sigla de estado (UF) em uma única linha de resultado.
Regra de Ouro: Tudo o que está no SELECT e não é conta matemática (soma, média) obrigatróriamente tem que estar no GROUP BY.
ORDER BY: Organiza o ranking pelo total financeiro (Total_Investido), do maior para o menor.

SELECT 
    txt_uf,
    COUNT(*) AS Qtd_Projetos,
    SUM(Valor_Investimento) AS Total_Investido 
FROM Investimentos_Limpos
GROUP BY txt_uf
ORDER BY Total_Investido DESC;
```

```sql
**Título: Caçando Inconsistências (WHERE + AND)**

Esta consulta não serve para resumir dados, mas sim para investigar casos suspeitos ou específicos. Estamos procurando projetos "estranhos": muito caros, mas sem repasse financeiro.
WHERE ... > 1000000: O filtro inicial. Cortamos fora tudo o que é projeto pequeno e focamos apenas nos milionários.
AND Valor_Repasse = 0: O operador AND é restritivo. Ele obriga que as duas condições sejam verdadeiras ao mesmo tempo.
Lógica de Negócio: Um projeto de 1 milhão com repasse zerado pode indicar um erro de cadastro, um atraso grave no pagamento ou uma fraude. É um alerta vermelho.
ORDER BY ... DESC: Ordenamos pelo valor do investimento para ver os casos mais graves (os mais caros) logo no topo da lista.

SELECT 
    txt_municipio,
    txt_uf,
    Valor_Investimento,
    Valor_Repasse,
    Data_Carga
FROM Investimentos_Limpos
WHERE Valor_Investimento > 1000000
  AND Valor_Repasse = 0
ORDER BY Valor_Investimento DESC;
```

```sql
**Título: Classificação Automática de Risco (Lógica Se/Então)**

Esta consulta serve para criar novas colunas de informação que não existiam na tabela original. Usamos regras lógicas para dar "etiquetas" aos dados.
CASE ... END: É a estrutura que abre e fecha o bloco de lógica. Pense nele como uma "Máquina de Carimbar".
WHEN ... THEN (A Regra): "QUANDO o valor for maior que 1 milhão, ENTÃO carimbe como 'Grande Porte'".
O SQL testa linha por linha. Se a condição for verdadeira, ele aplica a etiqueta e pula para a próxima linha.
ELSE (A Sobra): É o "Senão". Se o valor não for nem Grande (> 1M) nem Pequeno (< 100k), ele cai aqui automaticamente (Médio Porte). É importante para não deixar ninguém sem categoria.
AS Classificacao_Risco: Dá um nome para essa nova coluna virtual que acabamos de inventar.

SELECT TOP 100
    txt_municipio,
    Valor_Investimento,
    
    CASE 
        WHEN Valor_Investimento > 1000000 THEN 'Grande Porte'
        WHEN Valor_Investimento < 100000 THEN 'Pequeno Porte'
        ELSE 'Médio Porte'
    END AS Classificacao_Risco

FROM Investimentos_Limpos
ORDER BY Valor_Investimento DESC;
```

```sql
**Título: Gerador de Frases Automáticas (Concatenação)**

Esta função serve para "humanizar" os dados. Em vez de entregar uma tabela cheia de números frios, você entrega frases prontas que qualquer pessoa consegue ler.
CONCAT(...): Funciona como um "liquidificador". Você joga textos fixos (entre aspas ' ') e colunas do banco (sem aspas) e ele mistura tudo.
Atenção aos Espaços: O SQL não dá espaço sozinho. Você precisa escrever 'O estado ' (com espaço no final) para não grudar na sigla do estado.
Utilidade: Perfeito para criar títulos de e-mails automáticos ou notificações de sistema (ex: "Alerta: O cliente X gastou Y").

SELECT 
    txt_uf,
    COUNT(*) AS Qtd_Projetos,
    SUM(Valor_Investimento) AS Total_Investido 
FROM Investimentos_Limpos
GROUP BY txt_uf
ORDER BY Total_Investido DESC

Título: Filtrando depois de Agrupar (HAVING)

Esta é a pegadinha clássica de entrevista. Quando queremos filtrar pelo resultado de um cálculo (como Média ou Soma), não podemos usar o WHERE. Temos que usar o HAVING.
Regra: WHERE: Filtra linhas antes de agrupar.
HAVING: Filtra o grupo depois de calcular.

SELECT TOP 10
    txt_uf,
    AVG(Valor_Investimento) AS Media_Investimento
FROM Investimentos_Limpos
GROUP BY txt_uf
HAVING AVG(Valor_Investimento) > 500000
ORDER BY Media_Investimento DESC;

**Título: Criando Atalhos (Views)**

A View é uma "Tabela Virtual". Ela não ocupa espaço no banco, ela apenas salva o código da consulta.
CREATE VIEW Nome AS ...: Salva a lógica. Sempre que você chamar essa View, o SQL roda a consulta original em tempo real.
O Comando GO: Essencial no SQL Server. Ele serve para "limpar a memória" antes de criar um objeto novo. Se não usar o GO antes do CREATE VIEW, o banco trava e dá erro.
Vantagem: Se entrarem dados novos amanhã, sua View já mostra o resultado atualizado sem você precisar fazer nada.

ALTER VIEW Ranking_Estados AS
SELECT 
    txt_uf, 
    COUNT(*) AS Qtd_Projetos, 
    SUM(Valor_Investimento) AS Total_Investido
FROM Investimentos_Limpos
GROUP BY txt_uf;

```

```sql
**Título: Gerador de Frases Automáticas (Concatenação)**

Esta função serve para "humanizar" os dados. Em vez de entregar uma tabela cheia de números frios, você entrega frases prontas que qualquer pessoa consegue ler.
CONCAT(...): Funciona como um "liquidificador". Você joga textos fixos (entre aspas ' ') e colunas do banco (sem aspas) e ele mistura tudo.
Atenção aos Espaços: O SQL não dá espaço sozinho. Você precisa escrever 'O estado ' (com espaço no final) para não grudar na sigla do estado.
Utilidade: Perfeito para criar títulos de e-mails automáticos ou notificações de sistema (ex: "Alerta: O cliente X gastou Y").

SELECT TOP 5
    txt_uf,
    txt_municipio,
    
    CONCAT('O estado ', txt_uf, ' tem um projeto na cidade de ', txt_municipio) AS Relatorio_Automatico

FROM Investimentos_Limpos;
```

```sql
**Título: Filtrando pela Média - HAVING**

Esta consulta resolve uma pergunta de negócio complexa: "Quais estados têm uma média de investimento alta (acima de 500k)?".
AVG(Valor_Investimento):
Calcula a Média Aritmética. Soma tudo e divide pela quantidade.
HAVING ... > 500000: O Conceito Chave: O WHERE não funciona aqui porque ele tenta filtrar linha por linha antes de sabermos a média.
O HAVING espera o GROUP BY terminar de calcular as médias e só depois aplica o filtro.
Resultado: Uma lista limpa, mostrando apenas a "elite" dos estados com projetos caros, ignorando o resto.

SELECT TOP 10
    txt_uf,
    AVG(Valor_Investimento) AS Media_Investimento 

FROM Investimentos_Limpos
GROUP BY txt_uf

HAVING AVG(Valor_Investimento) > 500000 

ORDER BY Media_Investimento DESC;
```

```sql
SELECT * FROM Investimentos_Limpos
WHERE txt_uf IN ('DF', 'GO', 'MT', 'MS');

🧠 O que essa query faz?

👉 Busca todos os registros da tabela Investimentos_Limpos
👉 Filtrando apenas aqueles em que a coluna txt_uf (Unidade Federativa)
👉 Seja DF, GO, MT ou MS

🔍 Que tipo de filtro é esse?

O IN funciona como um “OU múltiplo”:

txt_uf = 'DF'
OU txt_uf = 'GO'
OU txt_uf = 'MT'
OU txt_uf = 'MS'

Ou seja, retorna somente dados dessas UFs:

DF → Distrito Federal
GO → Goiás
MT → Mato Grosso
MS → Mato Grosso do Sul

📌 Na prática: região Centro-Oeste 🇧🇷

📊 O que vem no resultado?

SELECT * → todas as colunas
Apenas as linhas que pertencem aos estados informados
Exemplo mental do retorno:

| id | cliente | valor   | txt_uf |
| -- | ------- | ------- | ------ |
| 10 | João    | 50.000  | GO     |
| 18 | Maria   | 120.000 | DF     |

⚠️ Observação importante (boa prática)
Em ambientes produtivos, o ideal é evitar SELECT *, por exemplo:

SELECT cliente, valor, txt_uf
FROM Investimentos_Limpos
WHERE txt_uf IN ('DF', 'GO', 'MT', 'MS');

✔️ Mais performance
✔️ Mais clareza
✔️ Menos risco em alterações futuras da tabela

🧩 Resumo em uma frase:
Essa query lista todos os investimentos “limpos” registrados para clientes localizados 
nos estados do Centro-Oeste.

__________________________________________________________________________________________

SELECT txt_municipio, txt_uf, Valor_Investimento
FROM Investimentos_Limpos
WHERE Valor_Investimento BETWEEN 100000 AND 50000

🧠 O que essa query faz?

👉 Seleciona três colunas:
Município (txt_municipio)
Estado (txt_uf)
Valor do investimento (Valor_Investimento)

👉 Filtra apenas os investimentos:
Com valor entre 100.000 e 500.000
Inclui 100.000 e 500.000 (o BETWEEN é inclusivo)

👉 Ordena o resultado:
Do maior para o menor valor (DESC)

📊 Resumo
“Liste os investimentos limpos entre R$ 100 mil e R$ 500 mil, mostrando o município e o 
estado, ordenando do maior investimento para o menor.”

🔍 Pontos técnicos importantes
🔹 BETWEEN Equivale a:

Valor_Investimento >= 100000
AND Valor_Investimento <= 500000

⚠️ Se o campo for DECIMAL ou FLOAT, o comportamento continua correto, mas é sempre bom 
garantir o tipo.

	ORDER BY ... DESC
	DESC → valores maiores aparecem primeiro
	Muito usado para ranking, análise de impacto, priorização
	
Exemplo de Resultado
	
| txt_municipio | txt_uf | Valor_Investimento |
| ------------- | ------ | ------------------ |
| Goiânia       | GO     | 480.000            |
| Brasília      | DF     | 350.000            |
| Cuiabá        | MT     | 120.000            |

💡 Dica de melhoria (opcional)

Se isso for um relatório frequente, pode-se fazer:
Dar alias para deixar mais legível:

SELECT 
  txt_municipio AS Municipio,
  txt_uf AS UF,
  Valor_Investimento AS Valor
FROM Investimentos_Limpos
WHERE Valor_Investimento BETWEEN 100000 AND 500000
ORDER BY Valor DESC;

🧠 Resumo:

Essa query lista investimentos de médio porte, exibindo município e UF, organizados do 
maior para o menor valor.

__________________________________________________________________________________________

SELECT txt_municipio, txt_uf
FROM Investimentos_Limpos
WHERE txt_municipio LIKE '%SANTOS%';

🧠 O que essa query faz?

👉 Busca municípios cujo nome contém a palavra “PARÁ”
👉 Retorna apenas:

**o nome do município
a UF

🔍 Entendendo o LIKE '%PARÁ%'

LIKE → usado para busca por padrão de texto
% → curinga, significa “qualquer coisa antes ou depois”

Ou seja: %PARÁ%

Significa:

Pode ter qualquer texto antes
Deve conter PARÁ
Pode ter qualquer texto depois

Exemplos que seriam retornados:

PARÁ DE MINAS
SANTA RITA DO PARÁ
PARÁ DOS SANTOS

⚠️ Pontos importantes (pegadinhas comuns)
🔹 Sensibilidade a acentos

Se o banco não ignora acentos, PARÁ ≠ PARA. Alguns registros podem estar como:

PARA
PARÁ

📌 Alternativa mais segura: 
WHERE txt_municipio LIKE '%PARA%';

Ou, se o banco permitir:

WHERE UPPER(txt_municipio) LIKE '%PARA%';

🔹 Performance

LIKE '%texto%' não usa índice
Em tabelas grandes, pode ficar pesado
Boa prática (quando possível):

Evitar % no início
Ou usar colunas normalizadas / buscas específicas

🧩 Resumo

“Liste todos os municípios que possuem a palavra PARÁ em seu nome, mostrando também o 
estado correspondente.”
