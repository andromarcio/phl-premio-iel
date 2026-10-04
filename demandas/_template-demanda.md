# História de Usuário — [Título curto da história]
> **Origem**: [ServiceNow | issue | experimento] `[STRYxxxxxxx | ISSUE-NNN | EXP-…]`
> **Link**: [URL do item na ferramenta de origem]
> **Status**: 🆕 Nova
> **Especificada em (N3)**: [ainda não especificada]

<!--
  Este arquivo NÃO é um nível de spec (N0–N3). É o INSUMO de entrada do
  processo: a demanda (história de usuário, issue ou experimento — ver
  MASTER.md → "Origem da demanda") que dispara a especificação.
  Vive em `demandas/` — análogo a `_base-conhecimento/`, não é um
  domínio do sistema.

  A chave da ferramenta de origem (ex.: STRY0012345, ISSUE-482, EXP-2026-003)
  é a FONTE DE VERDADE da demanda e o identificador usado em toda a
  rastreabilidade — o framework não gera ID próprio, apenas referencia a
  chave externa.

  Nome do arquivo: a chave em minúsculas — ex.: `stry0012345.md`,
  `issue-482.md`, `exp-2026-003.md`.
-->

---

## História

<!--
  TRANSCRIÇÃO, não formulação. Cole aqui a descrição como ela está na ferramenta
  de origem. Se a fonte enuncia no formato Como/quero/para, transcreva nesse
  formato; se enuncia em prosa, transcreva a prosa. NUNCA converta uma na outra
  nem componha um Como/quero/para que a fonte não tem — a história é o que o
  cliente escreveu, e derivá-la inventa persona e valor que ninguém aprovou.
  O que você concluir a partir dela vai para `## Contexto`, marcado como sua
  leitura.
-->

> Transcrição da descrição da demanda `[chave]` na ferramenta de origem.

[o texto da fonte, como está]

---

## Contexto

[1–3 frases explicando o problema ou a oportunidade que motiva esta história.
O "porquê" por trás da história, em linguagem de negócio.]

---

## Critérios de aceite

<!--
  Cada critério de aceite é analisado no N3 e vira uma regra de negócio (se
  expressa uma invariante), um `## Cenário` (Gherkin, se descreve um comportamento
  observável) ou ambos. Escreva cada critério como uma condição verificável;
  quando possível, use o formato Given/When/Then — o comportamento é transcrito
  quase 1:1 para os cenários, garantindo rastreabilidade semântica (não só por ID).

  NUMERAÇÃO `CA-n` — a contagem por sprint cita o critério pelo número, para o cliente conferir lado a lado com a ferramenta. Só numere quando a FONTE numerar, e use o MESMO número dela. Se a fonte traz os critérios como bullets, prosa ou sub-seções, NÃO invente número: deixe a lista sem `CA-n`, declare isso na linha de Numeração abaixo, e a rastreabilidade fica só pela chave da demanda (a coluna de critério da contagem sai `—`). Número inventado aqui vira número errado no relatório do cliente.
-->

> **Numeração**: [a fonte numera os critérios — `CA-n` é o número da própria ferramenta | a fonte **não** numera — sem `CA-n`; a rastreabilidade é pela chave da demanda]

```gherkin
# ── Critério 1 ──────────────────────────────────────────────
Scenario: [resultado esperado em linguagem de negócio]
  Given [estado inicial]
  When [ação do usuário]
  Then [resultado observável]
```

- [ ] [Critério em linguagem natural, se preferir lista a Gherkin]
- [ ] [Outro critério verificável]

---

## Rastreabilidade — Features (N3) que realizam esta história

<!--
  Relação M:N: uma história pode ser realizada por várias features, e uma
  feature pode atender a várias histórias. Preencher conforme a especificação
  (PROMPT_3A) e a implementação avançam. O elo recíproco fica na seção
  `## Origem` de cada N3.

  CARIMBO DE VERIFICAÇÃO (elo suspeito): após fechar/rever o elo, rode
  `node scripts/suspect-links.mjs --stamp --file <este arquivo>` — ele grava aqui
  um comentário `<!- - trace-verified: [ID da feature] @ fingerprint - ->` por
  feature. Se o N3 mudar depois disso, `suspect-links` acusa o elo como suspeito.
  Não editar os carimbos à mão.
-->

| Feature (N3) | Domínio · Feature Set | Status |
|---|---|---|
| [`SIGLA-SFS-NN`: Nome da Feature](../[dominio]/[feature-set]/[feature].md) | [Domínio] · [Feature Set] | 📋 Especificado |

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| [AAAA-MM-DD] | [autor] | História registrada | Intake da história a partir do ServiceNow |
