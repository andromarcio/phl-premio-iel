---
tipo: ticket
ticket: PDTIC25093-56
ferramenta: ""
link: ""
titulo: ""
estado: concluído
aberta-na-entrega: true
sprint: SP05
avalizado-por: ""
aberta-em: 2026-10-04
---

# AIM PDTIC25093-56

## Sumário

> Migrada de `arquivos/demandas/ANALISE_IMPACTO_PDTIC25093-56.md`.

| Indicador | Valor |
|---|---|
| Features alteradas | 2 |
| Features novas | 1 |
| Processos elementares com contagem no baseline | 3 — mais 2 estimados |
| Regras de negócio acrescentadas | +2 |
| Cenários acrescentados | +3 |
| Mensagens novas no dicionário | nenhuma |
| Alterações de modelo | nenhuma |
| **PFB · PFL do item** (transações) | **35 · 24,5** |

> **Linha do tempo.** O baseline APF foi contado em **2026-02-28**, antes desta sprint — é o "antes" da contagem. Os N3 foram escritos entre **2026-08-25 e 27**, por engenharia reversa do código **pós-sprint**: logo o "antes" de cada delta é o N3 como publicado, não o sistema em produção. O item aparece encerrado na listagem mais recente do board. ⚠️ Não há SQL anterior à sprint nem os arquivos de migração no acervo — as alterações de modelo abaixo são as **declaradas** pela demanda e confirmadas no modelo atual, não as **verificadas no script**.

## Detalhe do item

> Migrada de `arquivos/demandas/ANALISE_IMPACTO_PDTIC25093-56.md`.

**`PDTIC25093-56` — Relatório de inscrições · HU-036 — Relatório Geral de Inscrições**

Na spec: **uma feature nova** — o Relatório Geral de Inscrições, em tela e em planilha —, mais **restrição de permissão** no relatório gêmeo que já existia (o de Inscrições Paradas) e um **ponto de entrada** na fila de validação. O relatório novo difere do de Paradas por alcançar inscrições em qualquer situação, não só as em andamento.

É o item que mais mistura naturezas: uma feature incluída, uma alterada por restrição de perfil e uma alterada por ganhar um botão. ℹ️ Este item foi o gatilho da **decisão 6 da sprint** (gerar e exportar são a mesma feature): antes dela o item tinha 5 features, depois passou a 3, **sem perder um único PF**.

> **Critérios de aceite não numerados.** A HU chega como `.docx` e não numera os critérios. Pela regra da instância, a coluna `CA-n` sai `—` e a rastreabilidade fica pela chave da demanda. Numerar por conta própria produziria referências que não existem na ferramenta do cliente.

## Critérios de aceite

> ⚠️ Migrada sem o registro do ticket: transcreva aqui os critérios de aceite da ferramenta de origem.

## Features

| Feature (N3) | Domínio · Feature Set | Operação | Critérios cobertos | Status |
|---|---|---|---|---|
| [`AVL-APU-06`: Gerar Relatório de Inscrições Paradas](../modules/avaliacao/apuracao-devolutiva/f-gerar-relatorio-inscricoes-paradas.md) | Avaliação · Apuração e Devolutiva | Alteração | — | ✏️ Rascunho |
| [`AVL-APU-10`: Gerar Relatório de Inscrições](../modules/avaliacao/apuracao-devolutiva/f-gerar-relatorio-inscricoes.md) | Avaliação · Apuração e Devolutiva | Criação | — | ✏️ Rascunho |
| [`VAL-FIL-01`: Pesquisar Inscrições para Validação](../modules/validacao/fila-validacao/f-pesquisar-inscricao.md) | Validação · Fila e Painel de Validação | Alteração | — | ✏️ Rascunho |

## Artefatos impactados

| Artefato | Tipo | Operação | Seção | Natureza | O quê | Proveniência |
|---|---|---|---|---|---|---|
| `modules/avaliacao/apuracao-devolutiva/f-gerar-relatorio-inscricoes-paradas.md` | N3 | alterar | — | funcional | — | migrado: relatório |
| `modules/avaliacao/apuracao-devolutiva/f-gerar-relatorio-inscricoes.md` | N3 | criar | — | funcional | — | migrado: relatório |
| `modules/validacao/fila-validacao/f-pesquisar-inscricao.md` | N3 | alterar | — | funcional | — | migrado: relatório |
| `modules/avaliacao/apuracao-devolutiva/f-gerar-relatorio-inscricoes-paradas.md` | N3 | alterar | — | funcional | — | migrado: relatório |
| `modules/avaliacao/apuracao-devolutiva/f-gerar-relatorio-inscricoes-paradas.md` | N3 | alterar | — | funcional | — | migrado: relatório |
| `modules/validacao/fila-validacao/f-pesquisar-inscricao.md` | N3 | alterar | — | funcional | — | migrado: relatório |

## Alterações na spec, por Feature Set

### Avaliação › Apuração e Devolutiva (`AVL-APU`)

| Feature | `CA-n` | Natureza | O que mudou em relação ao comportamento anterior | Regras | Cenários | PFB | PFL |
|---|---|---|---|---|---|---|---|
| `AVL-APU-06` **Gerar Relatório de Inscrições Paradas** | — | alterada | **Restrição** de perfil e **ampliação** da abrangência, na tela e na planilha. Antes o relatório alcançava apenas as UFs no escopo do administrador, tinha cenário próprio para quem não tinha UF vinculada, e a planilha exportava o recorte de UF que estivesse em tela. Agora é exclusivo do Administrador Nacional (APIPIT.22) e alcança todas as UFs da premiação, sem recorte regional — o cenário de administrador sem UF deixou de existir e a planilha sai sempre com todas as UFs. ℹ️ Absorveu a antiga `AVL-APU-07` **Exportar Relatório de Inscrições Paradas** (decisão 6) e responde pelos dois processos elementares | +2 | +1 | 14 | 7 |
| `AVL-APU-10` **Gerar Relatório de Inscrições** | — | incluída | **Feature incluída.** Consolida todas as inscrições da premiação em qualquer situação — difere do Relatório de Inscrições Paradas, que alcança só as em andamento —, em abas por tipo de participante, com 13 colunas fixas mais uma coluna por pergunta do formulário; a planilha sai completa, sem o limite de 50 registros por grupo da prévia em tela. Exclusiva do Administrador Nacional. ℹ️ Nasce unificada (decisão 6): a consulta em tela e a exportação são a mesma feature e valem dois processos elementares | — | — | 14 | 14 |

**Subtotal: 2 features · 28 PFB · 21 PFL** — `AVL-APU-06` **Gerar Relatório de Inscrições Paradas** mantém os 14 PF do baseline; `AVL-APU-10` **Gerar Relatório de Inscrições** passou de 10 (E) para 14 PF contados em 2026-09-01.

### Validação › Fila de Validação (`VAL-FIL`)

| Feature | `CA-n` | Natureza | O que mudou em relação ao comportamento anterior | Regras | Cenários | PFB | PFL |
|---|---|---|---|---|---|---|---|
| `VAL-FIL-01` **Pesquisar Inscrições para Validação** | — | alterada | **Inclusão** do ponto de entrada do Relatório Geral de Inscrições na fila, oculto para quem não acessa relatórios administrativos (APIPIT.22). Filtros em cascata, cards KPI e tabela paginada seguem como estavam | — | +2 | 7 | 3,5 |

**Subtotal: 1 feature · 7 PFB · 3,5 PFL.**

**Total do item: 3 features · +2 regras · +3 cenários · 35 PFB · 24,5 PFL.**

**Matriz N2 alterada**: o Relatório de Inscrições Paradas — a tela e a exportação, que são a mesma feature — fica restrito ao Administrador Nacional (recurso APIPIT.22).

### Processos elementares por trás dos PFB medidos

A contagem é por **processo elementar**, não por feature — uma feature pode absorver mais de um PE, e deduplicar por feature subconta.

| Processo elementar | Feature | Tipo | ALR | DER | Complexidade | PFB |
|---|---|---|---|---|---|---|
| Relatório de Inscrições Paradas | `AVL-APU-06` **Gerar Relatório de Inscrições Paradas** | SE | 5 | 37 | Complexo | 7 |
| Exportar Relatório de Inscrições Paradas para Excel | `AVL-APU-06` **Gerar Relatório de Inscrições Paradas** | SE | 5 | 37 | Complexo | 7 |
| Consultar Dashboard Validação de Inscrições | `VAL-FIL-01` **Pesquisar Inscrições para Validação** | SE | 5 | 14 | Complexo | 7 |

A memória de cálculo de cada PE — ALR e DER nomeados — vive na seção `## Métricas de tamanho` do respectivo N3 e no `global/CONTAGEM-PF.md`.

✅ **1 feature contada em 2026-09-01, fora do baseline** — `AVL-APU-10` **Gerar Relatório de Inscrições**, com **dois processos elementares**: a consulta em tela (SE, ALR 6, DER 14, 7 PF) e a exportação em planilha (SE, ALR 6, DER 13, 7 PF). A capacidade não existia na contagem de fevereiro; a memória de cálculo está no N3.

As duas primeiras linhas da tabela acima mostram por que a unificação não retirou PF: os dois PE do Relatório de Inscrições Paradas têm **ALR e DER idênticos** e hoje pertencem à mesma feature — é exatamente a convenção descrita em `global/SIZING.md` → *Funcionalidades iguais em formatos de saída diferentes*.

## Funções de dados alteradas

**Nenhuma alteração de modelo.** O item não declara migração: a entrega lê e escreve no que já existia.

| Origem | Natureza | PFB | PFL |
|---|---|---|---|
| Funções de transação — 3 PE medidos + 2 estimados, em 3 features | alteradas e incluídas | 35 | 24,5 |
| **Apurável do item** | — | **35** | **24,5** |

## Impacto em dicionários

**Nenhuma mensagem, regra ou campo canônico novo.** A entrega reaproveita o baseline de mensagens do dicionário.

## Decisões de produto pendentes

> A decisão sobre unificar gerar e exportar foi tomada em 2026-09-01 e já está aplicada na spec — saiu desta lista; o registro está no `## Changelog`. O número **1** não foi reaproveitado.

### 2. A contagem de `AVL-APU-10` se confirma na métrica?

**O que foi contado** — os **dois processos elementares** de `AVL-APU-10` **Gerar Relatório de Inscrições** foram contados em 2026-09-01 sobre o N3: a consulta em tela (SE, ALR 6, DER 14) e a exportação em planilha (SE, ALR 6, DER 13), ambas complexidade Alta, **7 PF cada — 14 PF**. A arbitragem anterior era 5 (E) por PE; o medido ficou 40% acima.

**O que merece conferência** — os dois PE contam como **processos elementares distintos** pela convenção destes sistemas para exportação (`global/SIZING.md` → *Funcionalidades iguais em formatos de saída diferentes*), que **diverge da regra geral do CPM**. Se a métrica aplicar a regra geral, o par vira um PE só e o item cai de 35 para 28 PFB.

**Decide** — equipe de métricas. **Alcança** — `AVL-APU-10` **Gerar Relatório de Inscrições** e, pela mesma convenção, `AVL-APU-06` **Gerar Relatório de Inscrições Paradas**.

## Metodologia

> Migrada de `arquivos/demandas/ANALISE_IMPACTO_PDTIC25093-56.md`.

Cruzamento do item `PDTIC25093-56` com os N3 publicados dos Feature Sets alcançados, o `global/DATA-MODEL.md`, o `global/CONTAGEM-PF.md` e o baseline APF `arquivos/PIEL_BASELINE_PF_CD.xlsx`. O "antes" de cada delta foi extraído das linhas removidas no diff dos N3, não do arquivo atual. Escopo do perfil `requisitos`: a análise para no negocial e no data-model. Este documento é o recorte por item da análise agregada da sprint, em `ANALISE_IMPACTO_SP05.md` — os números dos dois devem sempre fechar.

## Reconciliação

Aberta na entrega — migrada do relatório `arquivos/demandas/ANALISE_IMPACTO_PDTIC25093-56.md`: não houve escopo prévio a reconciliar.

## Changelog

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | migra-aim | AIM migrada | relatório `arquivos/demandas/ANALISE_IMPACTO_PDTIC25093-56.md` → AIM única |
