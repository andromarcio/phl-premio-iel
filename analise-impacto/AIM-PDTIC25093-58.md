---
tipo: ticket
ticket: PDTIC25093-58
ferramenta: ""
link: ""
titulo: ""
estado: concluído
aberta-na-entrega: true
sprint: SP05
avalizado-por: ""
aberta-em: 2026-10-04
---

# AIM PDTIC25093-58

## Sumário

> Migrada de `arquivos/demandas/ANALISE_IMPACTO_PDTIC25093-58.md`.

| Indicador | Valor |
|---|---|
| Features alteradas | 1 |
| Features novas | 1 — `VAL-FIL-03`, com N3 escrito em 2026-09-01 |
| Processos elementares com contagem no baseline | 1 |
| Regras de negócio acrescentadas | +4 |
| Cenários acrescentados | +4 |
| Mensagens novas no dicionário | nenhuma |
| Alterações de modelo | nenhuma |
| **PFB · PFL do item** (transações) | **14 · 10,5** |

> **Linha do tempo.** O baseline APF foi contado em **2026-02-28**, antes desta sprint — é o "antes" da contagem. Os N3 foram escritos entre **2026-08-25 e 27**, por engenharia reversa do código **pós-sprint**: logo o "antes" de cada delta é o N3 como publicado, não o sistema em produção. O item aparece encerrado na listagem mais recente do board. ⚠️ Não há SQL anterior à sprint nem os arquivos de migração no acervo — as alterações de modelo abaixo são as **declaradas** pela demanda e confirmadas no modelo atual, não as **verificadas no script**.

## Detalhe do item

> Migrada de `arquivos/demandas/ANALISE_IMPACTO_PDTIC25093-58.md`.

**`PDTIC25093-58` — Alteração no relatório do dashboard · HU-036 — Relatório Geral de Inscrições**

Na spec: **alteração** de uma feature que descrevia só os gráficos do painel gerencial, mais **uma feature nova** — a exportação do histórico, separada em 2026-09-01 pela decisão de produto correspondente. A exportação do histórico em planilha **não estava especificada** — a sprint a tornou explícita, restrita ao Administrador Nacional e com duas informações novas na planilha.

O item revela uma lacuna da spec, não só um delta: a exportação existia no sistema e não no documento. A restrição de permissão e as colunas incidiam sobre algo que a spec não registrava.

> **Critérios de aceite não numerados.** A HU chega como `.docx` e não numera os critérios. Pela regra da instância, a coluna `CA-n` sai `—` e a rastreabilidade fica pela chave da demanda. Numerar por conta própria produziria referências que não existem na ferramenta do cliente.

## Critérios de aceite

> ⚠️ Migrada sem o registro do ticket: transcreva aqui os critérios de aceite da ferramenta de origem.

## Features

| Feature (N3) | Domínio · Feature Set | Operação | Critérios cobertos | Status |
|---|---|---|---|---|
| [`VAL-FIL-02`: Acompanhar Painel de Validação](../modules/validacao/fila-validacao/f-acompanhar-painel-validacao.md) | Validação · Fila e Painel de Validação | Alteração | — | ✏️ Rascunho |
| [`VAL-FIL-03`: Exportar Histórico do Painel de Validação](../modules/validacao/fila-validacao/f-exportar-historico-painel.md) | Validação · Fila e Painel de Validação | Criação | — | ✏️ Rascunho |

## Artefatos impactados

| Artefato | Tipo | Operação | Seção | Natureza | O quê | Proveniência |
|---|---|---|---|---|---|---|
| `modules/validacao/fila-validacao/f-acompanhar-painel-validacao.md` | N3 | alterar | — | funcional | — | migrado: relatório |
| `modules/validacao/fila-validacao/f-exportar-historico-painel.md` | N3 | criar | — | funcional | — | migrado: relatório |
| `modules/validacao/fila-validacao/f-acompanhar-painel-validacao.md` | N3 | alterar | — | funcional | — | migrado: relatório |

## Alterações na spec, por Feature Set

### Validação › Fila de Validação (`VAL-FIL`)

| Feature | `CA-n` | Natureza | O que mudou em relação ao comportamento anterior | Regras | Cenários | PFB | PFL |
|---|---|---|---|---|---|---|---|
| `VAL-FIL-02` **Acompanhar Painel de Validação** | — | alterada | **Inclusão** da exportação do histórico, que não estava especificada. Antes o N3 descrevia apenas os gráficos do dashboard — distribuição por situação e comparação por categoria ou UF. Agora a exportação em planilha é ação da feature, restrita ao Administrador Nacional, com Nome do Participante e Telefone resolvidos dos rótulos do formulário da inscrição | +4 | +4 | 7 | 3,5 |
| `VAL-FIL-03` **Exportar Histórico do Painel de Validação** | — | **incluída** ⚠️ | **Feature incluída.** A exportação do histórico estava especificada dentro de `VAL-FIL-02` **Acompanhar Painel de Validação**, com a restrição de perfil e as colunas de Nome e Telefone. Em 2026-09-01 ficou decidido **separá-la**, e o N3 próprio foi escrito na mesma data: os dados diferem, e não só de formato — a tela mostra agregados, a planilha traz uma linha por inscrição, com nome e telefone, que a tela não tem, e pelo `engine/FEATURE-DEFINITION.md` isso é ação com "pronto" próprio, não regra. ✅ Contada em 2026-09-01: SE, ALR 6, DER 18, complexidade Alta — **7 PF** — por analogia com `Consultar Dashboard Gerencial` (SE, ALR 4, DER 12, Complexo, 7 PFB), pode valer entre 4 e 7 PFB | — | — | 7 | 7 |

**Subtotal: 2 features · 14 PFB · 10,5 PFL** — `VAL-FIL-03` **Exportar Histórico do Painel de Validação** foi contada em 2026-09-01 e vale 7 PF.

**Total do item: 2 features · +4 regras · +4 cenários · 14 PFB · 10,5 PFL.**

**Matriz N2 alterada**: exportação do histórico restrita ao Nacional; registrados os acessos aos relatórios administrativos ocultos ao Regional.

### Processos elementares por trás dos PFB medidos

A contagem é por **processo elementar**, não por feature — uma feature pode absorver mais de um PE, e deduplicar por feature subconta.

| Processo elementar | Feature | Tipo | ALR | DER | Complexidade | PFB |
|---|---|---|---|---|---|---|
| Consultar Dashboard Gerencial | `VAL-FIL-02` **Acompanhar Painel de Validação** | SE | 4 | 12 | Complexo | 7 |

A memória de cálculo de cada PE — ALR e DER nomeados — vive na seção `## Métricas de tamanho` do respectivo N3 e no `global/CONTAGEM-PF.md`.

✅ **1 feature contada em 2026-09-01, fora do baseline** — `VAL-FIL-03` **Exportar Histórico do Painel de Validação**: SE, ALR 6, DER 18, complexidade Alta, **7 PF**, como função incluída a 100%. O `0 (E)` provisório era piso, não medida — e o medido ficou sete pontos acima.

## Funções de dados alteradas

**Nenhuma alteração de modelo.** O item não declara migração: a entrega lê e escreve no que já existia.

| Origem | Natureza | PFB | PFL |
|---|---|---|---|
| Funções de transação — 1 PE em 2 features | alteradas · 50% | 14 | 10,5 |
| **Apurável do item** | — | **14** | **10,5** |

## Impacto em dicionários

**Nenhuma mensagem, regra ou campo canônico novo.** A entrega reaproveita o baseline de mensagens do dicionário.

## Decisões de produto pendentes

✅ **Nenhuma.** As duas decisões deste item foram respondidas em 2026-09-01:

- **A exportação vira feature própria ou fica embutida?** — **separar**. Os dados diferem, e não só de formato: a tela mostra agregados e a planilha traz uma linha por inscrição, com nome e telefone, que a tela não tem. `VAL-FIL-03` **Exportar Histórico do Painel de Validação** passa a ser feature própria, com N3 escrito em 2026-09-01 e processo elementar a contar.
- **Nome e telefone do participante resolvidos por rótulo — aceitar o risco?** — **sim, o produto está ciente**. A regra 6 de `VAL-FIL-02` **Acompanhar Painel de Validação** deixa de ser suposição a confirmar e passa a registrar a limitação como conhecida e aceita: renomear o rótulo do campo na configuração do tipo de participante **esvazia a coluna na planilha, sem erro e sem aviso**. O cenário que descreve esse caso permanece na feature, agora como comportamento esperado.

O item está fechado do lado do produto e do dimensionamento: o N3 de `VAL-FIL-03` foi escrito em 2026-09-01 e o seu processo elementar foi contado na mesma data — **7 PF**, contra o `0 (E)` provisório que a análise carregava. Resta a **validação da equipe de métricas**.

## Metodologia

> Migrada de `arquivos/demandas/ANALISE_IMPACTO_PDTIC25093-58.md`.

Cruzamento do item `PDTIC25093-58` com os N3 publicados dos Feature Sets alcançados, o `global/DATA-MODEL.md`, o `global/CONTAGEM-PF.md` e o baseline APF `arquivos/PIEL_BASELINE_PF_CD.xlsx`. O "antes" de cada delta foi extraído das linhas removidas no diff dos N3, não do arquivo atual. Escopo do perfil `requisitos`: a análise para no negocial e no data-model. Este documento é o recorte por item da análise agregada da sprint, em `ANALISE_IMPACTO_SP05.md` — os números dos dois devem sempre fechar.

## Reconciliação

Aberta na entrega — migrada do relatório `arquivos/demandas/ANALISE_IMPACTO_PDTIC25093-58.md`: não houve escopo prévio a reconciliar.

## Changelog

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | migra-aim | AIM migrada | relatório `arquivos/demandas/ANALISE_IMPACTO_PDTIC25093-58.md` → AIM única |
