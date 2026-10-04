---
tipo: ticket
ticket: PDTIC25093-60
ferramenta: ""
link: ""
titulo: ""
estado: concluído
aberta-na-entrega: true
sprint: SP05
avalizado-por: ""
aberta-em: 2026-10-04
---

# AIM PDTIC25093-60

## Sumário

> Migrada de `arquivos/demandas/ANALISE_IMPACTO_PDTIC25093-60.md`.

| Indicador | Valor |
|---|---|
| Features alteradas | 1 |
| Features novas | nenhuma |
| Processos elementares com contagem no baseline | 3 |
| Regras de negócio acrescentadas | +5 |
| Cenários acrescentados | +7 |
| Mensagens novas no dicionário | nenhuma |
| Alterações de modelo | nenhuma |
| **PFB · PFL do item** (transações) | **17 · 8,5** |

> **Linha do tempo.** O baseline APF foi contado em **2026-02-28**, antes desta sprint — é o "antes" da contagem. Os N3 foram escritos entre **2026-08-25 e 27**, por engenharia reversa do código **pós-sprint**: logo o "antes" de cada delta é o N3 como publicado, não o sistema em produção. O item aparece encerrado na listagem mais recente do board. ⚠️ Não há SQL anterior à sprint nem os arquivos de migração no acervo — as alterações de modelo abaixo são as **declaradas** pela demanda e confirmadas no modelo atual, não as **verificadas no script**.

## Detalhe do item

> Migrada de `arquivos/demandas/ANALISE_IMPACTO_PDTIC25093-60.md`.

**`PDTIC25093-60` — Melhorias na alocação · HU-025 — Alocar Avaliadores**

Na spec: **alteração pura** de uma única feature, mas a de maior peso individual da sprint — 17 PFB, três processos elementares. A tela de alocação ganhou o detalhe do projeto e três recortes, e a regra de elegibilidade foi corrigida.

Feature única com três PE: é o caso que mostra por que a contagem é por processo elementar e não por feature. Deduplicar por feature aqui subcontaria dois terços do item.

> **Critérios de aceite não numerados.** A HU chega como `.docx` e não numera os critérios. Pela regra da instância, a coluna `CA-n` sai `—` e a rastreabilidade fica pela chave da demanda. Numerar por conta própria produziria referências que não existem na ferramenta do cliente.

## Critérios de aceite

> ⚠️ Migrada sem o registro do ticket: transcreva aqui os critérios de aceite da ferramenta de origem.

## Features

| Feature (N3) | Domínio · Feature Set | Operação | Critérios cobertos | Status |
|---|---|---|---|---|
| [`AVL-ALO-04`: Alocar Avaliador à Inscrição](../modules/avaliacao/alocacao/f-alocar-avaliador-inscricao.md) | Avaliação · Alocação de Avaliadores | Alteração | — | ✏️ Rascunho |

## Artefatos impactados

| Artefato | Tipo | Operação | Seção | Natureza | O quê | Proveniência |
|---|---|---|---|---|---|---|
| `modules/avaliacao/alocacao/f-alocar-avaliador-inscricao.md` | N3 | alterar | — | funcional | — | migrado: relatório |
| `modules/avaliacao/alocacao/f-alocar-avaliador-inscricao.md` | N3 | alterar | — | funcional | — | migrado: relatório |
| `modules/avaliacao/alocacao/f-alocar-avaliador-inscricao.md` | N3 | alterar | — | funcional | — | migrado: relatório |
| `modules/avaliacao/alocacao/f-alocar-avaliador-inscricao.md` | N3 | alterar | — | funcional | — | migrado: relatório |

## Alterações na spec, por Feature Set

### Avaliação › Alocação (`AVL-ALO`)

| Feature | `CA-n` | Natureza | O que mudou em relação ao comportamento anterior | Regras | Cenários | PFB | PFL |
|---|---|---|---|---|---|---|---|
| `AVL-ALO-04` **Alocar Avaliador à Inscrição** | — | alterada | **Inclusão** do detalhe do projeto e de três recortes; **correção** da elegibilidade. Antes a tela listava as inscrições elegíveis com a designação de avaliadores e a etiqueta de situação, sem nenhum filtro e sem como ver o conteúdo do projeto, e as elegíveis das etapas seguintes eram "as aprovadas na etapa anterior". Agora o projeto é consultável em modo somente leitura, há recortes por grupo, estado (com Nacional) e situação da alocação, e quem passa para a etapa seguinte é o classificado | +5 | +7 | 17 | 8,5 |

**Subtotal: 1 feature · 17 PFB · 8,5 PFL.**

**Total do item: 1 features · +5 regras · +7 cenários · 17 PFB · 8,5 PFL.**

### Processos elementares por trás dos PFB medidos

A contagem é por **processo elementar**, não por feature — uma feature pode absorver mais de um PE, e deduplicar por feature subconta.

| Processo elementar | Feature | Tipo | ALR | DER | Complexidade | PFB |
|---|---|---|---|---|---|---|
| Consultar Alocação de Avaliadores por Participante | `AVL-ALO-04` **Alocar Avaliador à Inscrição** | SE | 6 | 18 | Complexo | 7 |
| Consultar Avaliadores por Inscrição | `AVL-ALO-04` **Alocar Avaliador à Inscrição** | SE | 4 | 10 | Complexo | 7 |
| Incluir Avaliadores para Inscrição | `AVL-ALO-04` **Alocar Avaliador à Inscrição** | EE | 2 | 3 | Simples | 3 |

A memória de cálculo de cada PE — ALR e DER nomeados — vive na seção `## Métricas de tamanho` do respectivo N3 e no `global/CONTAGEM-PF.md`.

## Funções de dados alteradas

**Nenhuma alteração de modelo.** O item não declara migração: a entrega lê e escreve no que já existia.

| Origem | Natureza | PFB | PFL |
|---|---|---|---|
| Funções de transação — 3 PE em 1 feature | alteradas · 50% | 17 | 8,5 |
| **Apurável do item** | — | **17** | **8,5** |

## Impacto em dicionários

**Nenhuma mensagem, regra ou campo canônico novo.** A entrega reaproveita o baseline de mensagens do dicionário.

## Decisões de produto pendentes

✅ **Nenhuma.** As duas decisões deste item foram respondidas em 2026-09-01 e já estão aplicadas na spec:

- **O drawer "Projeto" reaproveita `VAL-ANA-01` Detalhar Inscrição?** — **sim**. A RN10 de `AVL-ALO-04` **Alocar Avaliador à Inscrição** passa a referenciar aquela feature como definição única do detalhe da inscrição, em vez de descrever um conteúdo paralelo. Uma alteração no detalhe passa a alcançar também o drawer.
- **O grupo de disputa inclui a submodalidade?** — **sim**. `AVL-ALO-01` **Consultar Alocação de Avaliadores** e `AVL-ALO-02` **Alocar Avaliador ao Grupo** foram corrigidas para incluí-la, convergindo com `AVL-ALO-04` **Alocar Avaliador à Inscrição** — cuja definição já fora conferida contra o código —, e `AVL-APU-01` **Apurar Resultado da Etapa** acrescentou a submodalidade ao grupo de disputa. As duas leituras que conviviam na spec deixaram de existir.

## Metodologia

> Migrada de `arquivos/demandas/ANALISE_IMPACTO_PDTIC25093-60.md`.

Cruzamento do item `PDTIC25093-60` com os N3 publicados dos Feature Sets alcançados, o `global/DATA-MODEL.md`, o `global/CONTAGEM-PF.md` e o baseline APF `arquivos/PIEL_BASELINE_PF_CD.xlsx`. O "antes" de cada delta foi extraído das linhas removidas no diff dos N3, não do arquivo atual. Escopo do perfil `requisitos`: a análise para no negocial e no data-model. Este documento é o recorte por item da análise agregada da sprint, em `ANALISE_IMPACTO_SP05.md` — os números dos dois devem sempre fechar.

## Reconciliação

Aberta na entrega — migrada do relatório `arquivos/demandas/ANALISE_IMPACTO_PDTIC25093-60.md`: não houve escopo prévio a reconciliar.

## Changelog

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | migra-aim | AIM migrada | relatório `arquivos/demandas/ANALISE_IMPACTO_PDTIC25093-60.md` → AIM única |
