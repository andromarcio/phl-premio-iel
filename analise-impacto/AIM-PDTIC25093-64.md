---
tipo: ticket
ticket: PDTIC25093-64
ferramenta: ""
link: ""
titulo: ""
estado: concluído
aberta-na-entrega: true
sprint: SP06
avalizado-por: ""
aberta-em: 2026-10-04
---

# AIM PDTIC25093-64

## Sumário

> Migrada de `arquivos/demandas/ANALISE_IMPACTO_PDTIC25093-64.md`.

| Indicador | Valor |
|---|---|
| Features alteradas | 1 |
| Features novas | 0 |
| Processos elementares com contagem no baseline | 0 *(o PE é posterior ao baseline — contado em 2026-09-01)* |
| Regras de negócio acrescentadas | +0 |
| Cenários acrescentados | +0 |
| Mensagens novas no dicionário | nenhuma |
| Alterações de modelo | nenhuma |
| **PFB · PFL do item** (transações) | **7 · 3,5** |

> **Linha do tempo.** O baseline APF foi contado em **2026-02-28** — é o "antes" da contagem, e `AVL-APU-09` — Exportar Relatório da Etapa não existia nele. Os N3 foram escritos por engenharia reversa entre **2026-08-25 e 27** e conferidos com o código em **2026-08-28**: o "antes" de cada delta é o N3 como publicado, não o sistema em produção. O card foi aberto em **2026-08-20** e encerrado em **2026-09-24 às 16:30**, 37 segundos antes de `PDTIC25093-65` — dois encerramentos no mesmo minuto indicam **varredura do board**, não a data da entrega. A entrega, portanto, aconteceu em algum momento entre 2026-08-20 e 2026-09-24, e muito provavelmente **antes** da conferência de 2026-08-28, que é o que explica a spec já descrever o comportamento pedido. ⚠️ Os repositórios de código não estão ao alcance desta sessão — nada aqui foi verificado contra o código.

## Detalhe do item

> Migrada de `arquivos/demandas/ANALISE_IMPACTO_PDTIC25093-64.md`.

**`PDTIC25093-64` — Melhoria no Relatório de Fechamento por Etapa**

Item de uma linha só: *"inserir a colocação no ranking (para as etapas fechadas) dentro do 'Relatório da Etapa', na tela de fechamento"*.

Na spec: **alteração** de `AVL-APU-09` — Exportar Relatório da Etapa. E uma alteração de natureza incomum, porque o conteúdo pedido **já estava descrito** no N3 e o que faltava era o número que o sustenta.

A `## Descrição` da feature já dizia que a planilha traz, para cada tipo de participante, "a lista das inscrições com **colocação**, média, selos e as notas de cada avaliador", e o cenário do caminho feliz repetia: "cada linha traz colocação, média final, selos de classificado e premiado e as notas por avaliador". A `### Memória de cálculo`, porém, enumerava 17 DER e **não listava nem a colocação nem a média final** — o número media uma planilha menor do que a que o próprio N3 descrevia. Essa é a lacuna que o card fecha: o delta aplicado é a enumeração dos dois DER, que leva o DER de 17 a 19 sem mover a complexidade nem o PF.

⚠️ **Resta uma divergência de localização que não se resolve sem o código.** O card põe o Relatório da Etapa **na tela de fechamento**; a `## Superfície` do N3 registra como origem a **Consulta de Ranking da Etapa** (`/avaliacao-admin/ranking-etapa`), botão "Relatório da etapa (XLSX)". São duas telas distintas e especificadas em features distintas — `AVL-APU-08` — Consultar Ranking da Etapa e `AVL-APU-03` — Encerrar Etapa por UF. Ou o botão existe nas duas, ou mudou de lugar, ou a origem registrada em 2026-08-28 estava imprecisa. Fica registrado com ⚠️ no próprio N3 e como decisão pendente na seção 5.

## Critérios de aceite

> ⚠️ Migrada sem o registro do ticket: transcreva aqui os critérios de aceite da ferramenta de origem.

## Features

| Feature (N3) | Domínio · Feature Set | Operação | Critérios cobertos | Status |
|---|---|---|---|---|
| [`AVL-APU-09`: Exportar Relatório da Etapa](../modules/avaliacao/apuracao-devolutiva/f-exportar-relatorio-etapa.md) | Avaliação · Apuração e Devolutiva | Alteração | — | ✏️ Rascunho |

## Artefatos impactados

| Artefato | Tipo | Operação | Seção | Natureza | O quê | Proveniência |
|---|---|---|---|---|---|---|
| `modules/avaliacao/apuracao-devolutiva/f-exportar-relatorio-etapa.md` | N3 | alterar | — | funcional | — | migrado: relatório |

## Alterações na spec, por Feature Set

### Avaliação › Apuração e Devolutiva (`AVL-APU`)

| Feature | `CA-n` | Natureza | O que mudou em relação ao comportamento anterior | Regras | Cenários | PFB | PFL |
|---|---|---|---|---|---|---|---|
| `AVL-APU-09` **Exportar Relatório da Etapa** | — | alterada | **Inclusão** da colocação no ranking e da média final na enumeração de DER. *Antes* a memória de cálculo listava 17 DER e, na saída do detalhe, ia de "Respostas da inscrição" direto a "Nota por avaliador": a colocação e a média apareciam na descrição e no cenário, mas não no que foi medido. *Agora* são 19 DER, com `Colocação no ranking` e `Média final` nomeadas na saída do detalhe. A faixa de complexidade é a mesma (6 a 19 DER), então **o PF não se move**. Nenhuma regra de negócio precisou mudar, porque a regra 1 já determinava que a planilha reproduz o resultado apurado "sem recalcular colocação nem selos" | +0 | +0 | 7 | 3,5 |

**Subtotal: 1 feature · 7 PFB · 3,5 PFL.**

**Total do item: 1 feature · +0 regras · +0 cenários · 7 PFB · 3,5 PFL.**

A natureza **alterada** merece a conta explícita, porque o mesmo processo elementar já foi contado antes. `AVL-APU-09` — Exportar Relatório da Etapa entrou como **incluída** em `PDTIC25093-49` (HU-030 — Fechar Etapa de Avaliação), na análise da SP05, valendo **7 PFB · 7 PFL**: foi aquele item que entregou a exportação. Este card a **altera**, e por isso vale 50% — **3,5 PFL**. Não há dupla contagem: são dois itens em ondas diferentes, um que criou a função e outro que lhe acrescentou dois dados de saída. Se a métrica concluir que `PDTIC25093-49` e `PDTIC25093-64` pertencem ao **mesmo** período de medição, então a função conta uma vez só e estes 3,5 PFL são dedução — ver a seção 5.

## Funções de dados alteradas

**Nenhuma alteração de modelo.** A colocação e a média final não são colunas novas: a colocação é apurada e gravada no fechamento da etapa (`AVL-APU-01` — Apurar Resultado da Etapa) e a média já existe na avaliação consolidada. A planilha passa a **ler e exibir** o que já estava gravado, o que altera a transação e não o arquivo lógico.

| Origem | Natureza | PFB | PFL |
|---|---|---|---|
| Funções de transação — 1 PE em 1 feature | alterada | 7 | 3,5 |
| Funções de dados — 0 ALI | — | 0 | 0 |
| **Apurável do item** | — | **7** | **3,5** |

## Impacto em dicionários

**Nenhuma mensagem, regra ou campo canônico novo.** `Colocação no ranking` e `Média final` são dados derivados da apuração, não campos canônicos de entrada — não entram no `global/FIELD-DICTIONARY.md`.

## Decisões de produto pendentes

> **Duas das três decisões foram respondidas pelo resumo de entrega da Sprint 6**, recebido em 2026-10-04. Ficam registradas, com a resposta, porque o que foi considerado importa a quem audita.
>
> **1. O Relatório da Etapa é acionado na tela de fechamento, na de ranking, ou nas duas? — RESPONDIDA: na de fechamento.** O resumo situa o relatório na tela de Fechamento e dá o motivo de o Ranking não poder ser a origem: ali a tela é somente leitura, sem ações. A `## Superfície` de `AVL-APU-09` — Exportar Relatório da Etapa estava **errada**, e foi corrigida no N3, no N2 do Feature Set e na linha da tela de Fechamento de Etapa. `AVL-APU-08` — Consultar Ranking da Etapa perdeu a ação que a spec lhe atribuía. Nada mudou na contagem, como previsto: a origem de uma ação em tela não é DER.
>
> **3. A colocação sai também para as etapas não fechadas? — RESPONDIDA: não.** A colocação é preenchida **apenas** para inscrições de estados já fechados; no estado ainda aberto a célula fica vazia, porque a posição pode mudar. O valor é gravado como número, para permitir ordenar a planilha por ele. Virou as regras 8 e 9 de `AVL-APU-09` — Exportar Relatório da Etapa, com cenário próprio. A terceira hipótese que a análise levantou — colocação provisória com aviso — foi descartada pela entrega.
>
> A numeração abaixo é preservada: a decisão que segue aberta continua sendo a **2**.

### 2. `PDTIC25093-49` e `PDTIC25093-64` estão no mesmo período de medição?

**O que trava** — o apurável deste item. A regra *uma função conta uma vez por sprint* vale dentro do período: se os dois itens caem no mesmo, `AVL-APU-09` — Exportar Relatório da Etapa já contou integralmente em `PDTIC25093-49` e este card apura **0**; se caem em períodos distintos, apura os **3,5 PFL** da alteração. Os dois itens foram encerrados no board em datas diferentes (`-49` na SP05, `-64` em 2026-09-24), o que sustenta períodos distintos, mas a definição do período é da métrica, não da spec.

**Decide** — equipe de métricas. **Alcança** — `AVL-APU-09` — Exportar Relatório da Etapa.

## Metodologia

> Migrada de `arquivos/demandas/ANALISE_IMPACTO_PDTIC25093-64.md`.

Card lido no Jira em 2026-10-02 (`sistemaindustria.atlassian.net`, board `PDTIC25093`). Confrontado com os N3 de `AVL-APU` publicados, o `global/CONTAGEM-PF.md`, o `global/SIZING.md`, o baseline APF `arquivos/PIEL_BASELINE_PF_CD.xlsx` e as análises já existentes — `ANALISE_IMPACTO_SP05.md` e `ANALISE_IMPACTO_PDTIC25093-49.md`, que é onde este processo elementar foi contado pela primeira vez. O "antes" do delta foi extraído do próprio N3 publicado. Escopo do perfil `requisitos`: a análise para no negocial e no data-model. ⚠️ Sem acesso aos repositórios de código nesta sessão: a divergência de localização do botão fica em aberto por falta de fonte, não por falta de leitura.

## Reconciliação

Aberta na entrega — migrada do relatório `arquivos/demandas/ANALISE_IMPACTO_PDTIC25093-64.md`: não houve escopo prévio a reconciliar.

## Changelog

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | migra-aim | AIM migrada | relatório `arquivos/demandas/ANALISE_IMPACTO_PDTIC25093-64.md` → AIM única |
