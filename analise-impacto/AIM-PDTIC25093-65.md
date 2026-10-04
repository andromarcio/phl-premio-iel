---
tipo: ticket
ticket: PDTIC25093-65
ferramenta: ""
link: ""
titulo: ""
estado: concluído
aberta-na-entrega: true
sprint: SP06
avalizado-por: ""
aberta-em: 2026-10-04
---

# AIM PDTIC25093-65

## Sumário

> Migrada de `arquivos/demandas/ANALISE_IMPACTO_PDTIC25093-65.md`.

| Indicador | Valor |
|---|---|
| Features alteradas | 1 |
| Features novas | 0 *(as 2 já tinham N3 — o que faltava era origem e contagem)* |
| Processos elementares contados nesta análise | 2 |
| Regras de negócio acrescentadas | +2 |
| Cenários acrescentados | +3 |
| Mensagens novas no dicionário | nenhuma |
| Alterações de modelo | nenhuma |
| **PFB · PFL do item** (transações) | **21 · 17,5** |

> **Linha do tempo.** O baseline APF foi contado em **2026-02-28** — nenhuma das três capacidades deste card existia nele. O card foi aberto em **2026-08-26**; os N3 foram escritos por engenharia reversa entre **2026-08-25 e 27** e **conferidos com o código em 2026-08-28**, dois dias depois da abertura do card. É essa conferência que explica o achado central desta análise: duas das três entregas **já estavam especificadas**, derivadas do código, com a origem em branco. O encerramento no board, **2026-09-24 às 16:31** — 37 segundos depois de `PDTIC25093-64` —, é varredura do board e não data de entrega. ⚠️ Os repositórios de código não estão ao alcance desta sessão; a identificação abaixo é por correspondência entre o texto do card e o texto dos N3, não por leitura do código.

## Detalhe do item

> Migrada de `arquivos/demandas/ANALISE_IMPACTO_PDTIC25093-65.md`.

**`PDTIC25093-65` — Melhorias 25/08**

Três melhorias pedidas pela Isabelle, que caem em dois Feature Sets diferentes. O achado principal é de rastreabilidade: **os itens 1 e 2 são a origem que faltava a duas features órfãs**.

`AVL-ALO-05` — Consultar Panorama do Avaliador e `AVL-ALO-07` — Exportar Relatório de Alocação foram criadas em 2026-08-28 pela conferência doc × código, com o rótulo "capacidade implementada e até então não especificada" e a coluna de origem em branco no `modules/INDEX.md`. Este card, aberto dois dias antes, descreve as duas com precisão suficiente para fechar o elo — inclusive detalhes que não se adivinham, como a lupa existir **nas duas** telas de alocação e a aba por estado **só** aparecer quando a etapa é regional.

**Item 1 — relatório na alocação** → `AVL-ALO-07` — Exportar Relatório de Alocação. O card pede "um relatório na alocação de avaliadores, explicando por estado (se for regional, se for nacional não faz por estado) e por avaliador". A regra 3 do N3 diz que "o relatório sempre traz a distribuição por avaliador" e a regra 4 que "a distribuição por estado só integra o relatório quando a etapa é operada também pelo Administrador Regional". É o mesmo requisito, com a condicional invertida na forma e idêntica no efeito. **Não confundir com `AVL-PAI-04` — Exportar Relatório de Avaliadores**, que é outro relatório: vive no Painel de Avaliações (`/avaliacao-admin/avaliacoes`), não tem recorte por estado e já tem origem no Aviso 4 da SP05.

**Item 2 — lupa com o panorama** → `AVL-ALO-05` — Consultar Panorama do Avaliador. O card pede a lupa "tanto na alocação por pool de grupo ou por participante", abrindo "em modal", mostrando "quantos por grupo ela tem, quais por grupo ela tem", "podendo escolher por etapa (dropdown)". A `## Superfície` do N3 registra exatamente as duas origens — `/avaliacao-admin/alocacao-matriz` e `/avaliacao-admin/alocacao-participante` —, o `## Comportamento de tela` descreve o diálogo com o seletor de etapa e os quatro totais, e a regra 2 agrupa as avaliações pelo grupo de alocação. A referência visual do card ("inspirado no visual da validação de inscrição do participante") é orientação de desenho, não regra, e não gera delta.

**Item 3 — filtro por etapa nas avaliações** → `AVL-PAI-01` — Acompanhar Painel de Avaliações. Aqui há delta real, e é o único dos três. O filtro por etapa **já existia** na spec: a tabela `## Campos` traz "Etapa — seleção → Etapa — filtra pela etapa da avaliação" e o `## Comportamento de tela` já listava o seletor. O que **não** existia são as duas restrições que o card acrescenta: o Administrador Regional só pode ver as etapas regionais, e a etapa nacional não deve apresentar consolidações por estado. A segunda contradizia o publicado — as regras 8 e 9 apuravam o andamento da consolidação por estado em **toda** etapa, e o cenário "Consultar o andamento da consolidação por estado" não distinguia a natureza da etapa.

## Critérios de aceite

> ⚠️ Migrada sem o registro do ticket: transcreva aqui os critérios de aceite da ferramenta de origem.

## Features

| Feature (N3) | Domínio · Feature Set | Operação | Critérios cobertos | Status |
|---|---|---|---|---|
| [`AVL-ALO-07`: Exportar Relatório de Alocação](../modules/avaliacao/alocacao/f-exportar-relatorio-alocacao.md) | Avaliação · Alocação | Criação | — | ✏️ Rascunho |
| [`AVL-ALO-05`: Consultar Panorama do Avaliador](../modules/avaliacao/alocacao/f-consultar-panorama-avaliador.md) | Avaliação · Alocação | Criação | — | ✏️ Rascunho |
| [`AVL-PAI-01`: Acompanhar Painel de Avaliações](../modules/avaliacao/painel-administrativo/f-acompanhar-painel-avaliacoes.md) | Avaliação · Painel Administrativo de Avaliações | Alteração | — | ✏️ Rascunho |

## Artefatos impactados

| Artefato | Tipo | Operação | Seção | Natureza | O quê | Proveniência |
|---|---|---|---|---|---|---|
| `modules/avaliacao/alocacao/f-exportar-relatorio-alocacao.md` | N3 | criar | — | funcional | — | migrado: relatório |
| `modules/avaliacao/alocacao/f-consultar-panorama-avaliador.md` | N3 | criar | — | funcional | — | migrado: relatório |
| `modules/avaliacao/painel-administrativo/f-acompanhar-painel-avaliacoes.md` | N3 | alterar | — | funcional | — | migrado: relatório |

## Alterações na spec, por Feature Set

### Avaliação › Alocação (`AVL-ALO`)

| Feature | `CA-n` | Natureza | O que mudou em relação ao comportamento anterior | Regras | Cenários | PFB | PFL |
|---|---|---|---|---|---|---|---|
| `AVL-ALO-07` **Exportar Relatório de Alocação** | — | incluída | **Origem identificada e contagem realizada**, sem delta de conteúdo. *Antes* o N3 existia desde 2026-08-28 com a origem em branco e a premissa "sem contagem no baseline APF — **sem processo elementar correspondente**", que descrevia a ausência na planilha sem dizer a causa, e deixava a feature valendo `—`. *Agora* a premissa diz a causa — a capacidade foi pedida em 2026-08-26, seis meses depois do baseline — e o processo elementar está contado: SE, ALR 4, DER 9, complexidade Alta, **7 PF**. As regras 3 e 4 já diziam o que o card pede e não precisaram mudar | +0 | +0 | 7 | 7 |
| `AVL-ALO-05` **Consultar Panorama do Avaliador** | — | incluída | **Origem identificada e contagem realizada**, sem delta de conteúdo. *Antes*, mesma situação: N3 de 2026-08-28, origem em branco, premissa de "sem PE correspondente" e PF `—`. *Agora* a premissa aponta o card como causa e o processo elementar está contado: SE, ALR 8, DER 14, complexidade Alta, **7 PF**. O diálogo abre a partir de duas telas de alocação e conta como **um** processo elementar, porque a lógica de processamento é a mesma | +0 | +0 | 7 | 7 |

**Subtotal: 2 features · 14 PFB · 14 PFL.**

### Avaliação › Painel Administrativo de Avaliações (`AVL-PAI`)

| Feature | `CA-n` | Natureza | O que mudou em relação ao comportamento anterior | Regras | Cenários | PFB | PFL |
|---|---|---|---|---|---|---|---|
| `AVL-PAI-01` **Acompanhar Painel de Avaliações** | — | alterada | **Restrição** do acompanhamento pela natureza da etapa. *Antes* a seleção de etapa existia mas não distinguia perfil — o Administrador Regional recebia também as etapas nacionais —, e o andamento da consolidação por estado era apurado em toda etapa, inclusive na nacional, em que a disputa não se organiza por estado: as regras 8 e 9 não tinham qualquer condicional e o cenário correspondente apresentava o resumo por estado sem ressalva. *Agora* a RN10 restringe a seleção de etapa do Regional às etapas de natureza regional e a RN11 condiciona o andamento da consolidação por estado às etapas regionais, suprimindo-o na nacional | +2 | +3 | 7 | 3,5 |

**Subtotal: 1 feature · 7 PFB · 3,5 PFL.**

**Total do item: 3 features · +2 regras · +3 cenários · 21 PFB · 17,5 PFL.**

✅ **2 processos elementares contados em 2026-10-02, fora do baseline** — `AVL-ALO-07` — Exportar Relatório de Alocação (SE, ALR 4, DER 9, Alta, **7 PF**) e `AVL-ALO-05` — Consultar Panorama do Avaliador (SE, ALR 8, DER 14, Alta, **7 PF**). As memórias de cálculo, com ALR e DER nomeados, estão nos respectivos N3; o espelho está em `global/CONTAGEM-PF.md` → seção 1C. ⚠️ Pendente de validação pela equipe de métricas, como os 77 PF da seção 1B. A classificação **SE** está sujeita à conferência descrita na seção 5.

⚠️ **`AVL-PAI-01` — Acompanhar Painel de Avaliações já foi contada como alterada antes.** Na análise da SP05 ela aparece com **7 PFB · 3,5 PFL**, atribuída ao "Aviso 4" (⚠️ sem item identificado), por outro delta: a inclusão do recorte por estado e do andamento da consolidação. Este card a altera de novo, agora para **condicionar** aquele mesmo andamento à natureza da etapa — a sequência é coerente (primeiro se cria a visão por estado, depois se descobre que ela não faz sentido na etapa nacional), mas significa que a mesma função é alterada duas vezes. Ver a seção 5.

## Funções de dados alteradas

**Nenhuma alteração de modelo.** Os três itens leem o que já existe. A natureza da etapa, de que dependem as duas novas regras, já está no modelo: a Etapa é subgrupo do ALI **Premiação** e os perfis que a operam vivem em `TB_ETAPA_PERFIL_ACESSO`, restrita a `PIT.1` e `PIT.3` — é dela que `AVL-APU-08` — Consultar Ranking da Etapa já deriva a sua regra 4 de visibilidade.

| Origem | Natureza | PFB | PFL |
|---|---|---|---|
| Funções de transação — 2 PE incluídos | incluídas | 14 | 14 |
| Funções de transação — 1 PE alterado | alterada | 7 | 3,5 |
| Funções de dados — 0 ALI | — | 0 | 0 |
| **Apurável do item** | — | **21** | **17,5** |

## Impacto em dicionários

**Nenhuma mensagem, regra ou campo canônico novo.** As duas features contadas já reaproveitavam o baseline de mensagens, e as mensagens de estado vazio que elas usam — "Nenhuma avaliação nesta etapa." e "Nenhuma avaliação com este status nesta etapa." — já estavam registradas nos N3 desde 2026-08-28. A supressão da consolidação por estado na etapa nacional não gera aviso ao usuário: o bloco simplesmente não é apresentado.

⚠️ Vale uma nota de vocabulário, não de dicionário: a mesma ideia aparece com **três formulações** diferentes na spec — "capability configurada na etapa" (regra 4 de `AVL-PAI-01` — Acompanhar Painel de Avaliações, com ⚠️), "etapa operada também pelo Administrador Regional" (regra 4 de `AVL-ALO-07` — Exportar Relatório de Alocação) e "natureza da etapa" (regra 4 de `AVL-APU-08` — Consultar Ranking da Etapa). As novas regras deste delta adotaram a terceira, que é a mais explícita, mas a divergência permanece nas outras duas. Ver a seção 5.

## Decisões de produto pendentes

> **A decisão 4 foi respondida pelo resumo de entrega da Sprint 6**, recebido em 2026-10-04: *"os itens 4 e 5 e a colocação no Relatório da Etapa são as melhorias solicitadas pela área negocial em **25/08**, entregues em 28/08 (PRs 86452 no front e 86451 no back) e em produção desde o release de 01/09"*. Este card é *Melhorias 25/08*, aberto em 2026-08-26. Está **confirmado** que ele é a origem de `AVL-ALO-05` — Consultar Panorama do Avaliador e de `AVL-ALO-07` — Exportar Relatório de Alocação, e os 14 PF ficam atribuídos a ele. A correspondência de texto que a análise usara em 2026-10-02 era mesmo o elo certo.
>
> O resumo também **corrigiu as duas memórias de cálculo**, ao nomear as colunas das abas e os indicadores: `AVL-ALO-07` — Exportar Relatório de Alocação passou de ALR 4 × DER 9 para ALR 7 × DER 16 — a coluna **Grupo** referencia o grupo competitivo, o que a engenharia reversa não tinha visto —, e `AVL-ALO-05` — Consultar Panorama do Avaliador passou de DER 14 para 22, com quantidade **e** percentual em cada indicador. **Nenhuma das duas move PF**: as duas caem na mesma célula da tabela de SE, e o apurável do card segue **21 PFB · 17,5 PFL**.
>
> A decisão **1**, do vocabulário da natureza da etapa, ganhou evidência mas não resposta: o resumo descreve o comportamento entregue em termos de etapa **regional** e **nacional** ("aba Por estado, gerada só quando a etapa é regional"; "quando a etapa escolhida é nacional"), o que sustenta a formulação adotada — mas não diz se existe campo que declare essa natureza, que é o que a decisão pergunta. A numeração abaixo é preservada.

### 1. "Natureza da etapa", "capability da etapa" e "etapa operada pelo Regional" são a mesma coisa?

**Onde está a divergência** — três features descrevem o mesmo mecanismo com três vocabulários. `AVL-APU-08` — Consultar Ranking da Etapa fala de **natureza da etapa** (regional ou nacional); `AVL-ALO-07` — Exportar Relatório de Alocação fala de etapa **operada também pelo Administrador Regional**; `AVL-PAI-01` — Acompanhar Painel de Avaliações fala de **capability configurada na etapa**, e já traz ⚠️ pedindo confirmação do modelo de escopo. No banco existe uma só estrutura, `TB_ETAPA_PERFIL_ACESSO`, restrita a `PIT.1` e `PIT.3`.

**O que trava** — a redação das regras em quatro features e a matriz de visibilidade do N2. Se há um único mecanismo, as três formulações devem convergir para uma e o ⚠️ de `AVL-PAI-01` fecha; se "natureza" e "perfis que operam" são atributos independentes — uma etapa nacional que o Regional pode operar, por exemplo —, então as regras novas deste delta estão escritas com a condicional errada e precisam ser reescritas.

**Decide** — produto, com conferência no modelo. **Alcança** — `AVL-PAI-01` — Acompanhar Painel de Avaliações, `AVL-ALO-07` — Exportar Relatório de Alocação, `AVL-APU-08` — Consultar Ranking da Etapa e `AVL-APU-09` — Exportar Relatório da Etapa.

### 2. `Consultar Panorama do Avaliador` e `Exportar Relatório de Alocação` são SE ou CE?

**O que foi contado** — ambos como **SE**, complexidade Alta, 7 PF cada, pelas memórias de cálculo nos N3.

**Onde está a dúvida** — a classificação apoia-se em **dado derivado**: no panorama, os quatro totais (alocadas, a iniciar, em andamento, finalizadas) são contagens apuradas na hora; no relatório, a carga por avaliador e o total por estado também. Nenhum dos dois recalcula nota ou colocação — só conta —, e há leitura possível de que contar não é derivar, o que puxaria para **CE**. É a mesma dúvida já registrada para `AVL-APU-08` — Consultar Ranking da Etapa.

**O que muda com cada resposta** — mantidos como **SE**, valem 7 PF cada e o item fecha em 21 PFB · 17,5 PFL. Reclassificados como **CE**, valem 6 cada e o item cai para **19 PFB · 15,5 PFL**.

**Decide** — equipe de métricas. **Alcança** — `AVL-ALO-05` — Consultar Panorama do Avaliador e `AVL-ALO-07` — Exportar Relatório de Alocação.

### 3. O "Aviso 4" da SP05 e este card estão no mesmo período de medição?

**O que trava** — os 3,5 PFL de `AVL-PAI-01` — Acompanhar Painel de Avaliações. A função já foi contada como alterada na análise da SP05, atribuída a um aviso sem item identificado. Se os dois deltas caem no mesmo período, a função conta uma vez e estes 3,5 PFL são dedução, levando o item a **21 PFB · 14 PFL**; se caem em períodos distintos, as duas alterações contam.

**O que ajuda a decidir** — este card **não** é o Aviso 4: o Aviso 4 também criou `AVL-PAI-04` — Exportar Relatório de Avaliadores, que é o relatório do Painel de Avaliações e não aparece em nenhum dos três itens daqui. Então são duas demandas distintas sobre a mesma feature, e a pergunta é só de calendário.

**Decide** — equipe de métricas. **Alcança** — `AVL-PAI-01` — Acompanhar Painel de Avaliações.

## Metodologia

> Migrada de `arquivos/demandas/ANALISE_IMPACTO_PDTIC25093-65.md`.

Card lido no Jira em 2026-10-02 (`sistemaindustria.atlassian.net`, board `PDTIC25093`), item por item. Confrontado com os N3 de `AVL-ALO` e `AVL-PAI` publicados, o `global/CONTAGEM-PF.md`, o `global/SIZING.md`, o `global/data-models/avaliacao.md`, o baseline APF `arquivos/PIEL_BASELINE_PF_CD.xlsx` e as análises já existentes — `ANALISE_IMPACTO_SP05.md`, que é onde o Aviso 4 e `AVL-PAI-04` — Exportar Relatório de Avaliadores foram registrados. O "antes" de cada delta foi extraído do N3 publicado e do seu `## Changelog`, não do sistema em produção. A desambiguação entre `AVL-ALO-07` — Exportar Relatório de Alocação e `AVL-PAI-04` — Exportar Relatório de Avaliadores foi feita pela tela de origem e pelo conteúdo das abas, porque os dois nomes se confundem. Escopo do perfil `requisitos`: a análise para no negocial e no data-model. ⚠️ Sem acesso aos repositórios de código nesta sessão.

## Reconciliação

Aberta na entrega — migrada do relatório `arquivos/demandas/ANALISE_IMPACTO_PDTIC25093-65.md`: não houve escopo prévio a reconciliar.

## Changelog

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | migra-aim | AIM migrada | relatório `arquivos/demandas/ANALISE_IMPACTO_PDTIC25093-65.md` → AIM única |
