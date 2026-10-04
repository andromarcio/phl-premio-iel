---
tipo: ticket
ticket: PDTIC25093-68
ferramenta: ""
link: ""
titulo: ""
estado: concluído
aberta-na-entrega: true
sprint: SP05
avalizado-por: ""
aberta-em: 2026-10-04
---

# AIM PDTIC25093-68

## Sumário

> Migrada de `arquivos/demandas/ANALISE_IMPACTO_PDTIC25093-68.md`.

| Indicador | Valor |
|---|---|
| Features alteradas | 1 |
| Features novas | 1 |
| Processos elementares com contagem no baseline | 1 |
| Regras de negócio acrescentadas | +3 |
| Cenários acrescentados | +2 |
| Mensagens novas no dicionário | nenhuma |
| Alterações de modelo | 1 |
| **PFB · PFL do item** (transações) | **13 · 9,5** |

> **Linha do tempo.** O baseline APF foi contado em **2026-02-28**, antes desta sprint — é o "antes" da contagem. Os N3 foram escritos entre **2026-08-25 e 27**, por engenharia reversa do código **pós-sprint**: logo o "antes" de cada delta é o N3 como publicado, não o sistema em produção. O item aparece encerrado na listagem mais recente do board. ⚠️ Não há SQL anterior à sprint nem os arquivos de migração no acervo — as alterações de modelo abaixo são as **declaradas** pela demanda e confirmadas no modelo atual, não as **verificadas no script**.

## Detalhe do item

> Migrada de `arquivos/demandas/ANALISE_IMPACTO_PDTIC25093-68.md`.

**`PDTIC25093-68` — Melhorias na Validação de Inscrições · HU-018 — Analisar e Validar Inscrição**

Na spec: **alteração** do detalhe da inscrição, que passou a baixar documento por endereço individual, mais uma **feature nova** — a edição administrativa da inscrição já validada, que a spec registrava como deferida até ser especificada em 2026-08-28.

A edição administrativa é a única feature nova deste item: o N3 existe desde 2026-08-28 e o seu processo elementar foi contado em 2026-09-01, valendo 6 PF.

> **Critérios de aceite não numerados.** A HU chega como `.docx` e não numera os critérios. Pela regra da instância, a coluna `CA-n` sai `—` e a rastreabilidade fica pela chave da demanda. Numerar por conta própria produziria referências que não existem na ferramenta do cliente.

## Critérios de aceite

> ⚠️ Migrada sem o registro do ticket: transcreva aqui os critérios de aceite da ferramenta de origem.

## Features

| Feature (N3) | Domínio · Feature Set | Operação | Critérios cobertos | Status |
|---|---|---|---|---|
| [`VAL-ANA-01`: Detalhar Inscrição](../modules/validacao/analise-decisao/f-detalhar-inscricao.md) | Validação · Análise e Decisão | Alteração | — | ✏️ Rascunho |
| [`VAL-ANA-05`: Editar Inscrição Validada](../modules/validacao/analise-decisao/f-editar-inscricao-validada.md) | Validação · Análise e Decisão | Criação | — | ✏️ Rascunho |

## Artefatos impactados

| Artefato | Tipo | Operação | Seção | Natureza | O quê | Proveniência |
|---|---|---|---|---|---|---|
| `modules/validacao/analise-decisao/f-detalhar-inscricao.md` | N3 | alterar | — | funcional | — | migrado: relatório |
| `modules/validacao/analise-decisao/f-editar-inscricao-validada.md` | N3 | criar | — | funcional | — | migrado: relatório |
| `modules/validacao/analise-decisao/f-detalhar-inscricao.md` | N3 | alterar | — | funcional | — | migrado: relatório |

## Alterações na spec, por Feature Set

### Validação › Análise e Decisão (`VAL-ANA`)

| Feature | `CA-n` | Natureza | O que mudou em relação ao comportamento anterior | Regras | Cenários | PFB | PFL |
|---|---|---|---|---|---|---|---|
| `VAL-ANA-01` **Detalhar Inscrição** | — | alterada | **Alteração** da forma de baixar o documento. Antes o detalhe "disponibilizava o arquivo do documento", sem dizer como o acesso era controlado. Agora cada documento tem endereço individual, conferido a cada acesso a quem tem direito à inscrição — o mesmo mecanismo que habilita o anexo do avaliador em `AVL-AVA-03` | +3 | +2 | 7 | 3,5 |
| `VAL-ANA-05` **Editar Inscrição Validada** | — | incluída | **Feature incluída.** Permite ao Administrador Nacional editar uma inscrição já validada: correção dos dados do membro da equipe com máscara de CPF e telefone, e inclusão do primeiro membro quando a equipe está vazia. Não existia na spec até a conferência com o código: o N2 registrava a edição administrativa como deferida, e o N3 foi escrito em 2026-08-28 — a lotação em `VAL-ANA`, dentro da tela de validação da inscrição, foi confirmada em 2026-09-01 | — | — | 6 | 6 |

**Subtotal: 2 features · 13 PFB · 9,5 PFL** — `VAL-ANA-05` **Editar Inscrição Validada** foi contada em 2026-09-01 e vale 6 PF.

**Total do item: 2 features · +3 regras · +2 cenários · 13 PFB · 9,5 PFL.**

### Processos elementares por trás dos PFB medidos

A contagem é por **processo elementar**, não por feature — uma feature pode absorver mais de um PE, e deduplicar por feature subconta.

| Processo elementar | Feature | Tipo | ALR | DER | Complexidade | PFB |
|---|---|---|---|---|---|---|
| Detalhar Inscrição | `VAL-ANA-01` **Detalhar Inscrição** | SE | 5 | 37 | Complexo | 7 |

A memória de cálculo de cada PE — ALR e DER nomeados — vive na seção `## Métricas de tamanho` do respectivo N3 e no `global/CONTAGEM-PF.md`.

✅ **1 feature contada em 2026-09-01, fora do baseline** — `VAL-ANA-05` **Editar Inscrição Validada**: EE, ALR 3, DER 11, complexidade Alta, **6 PF**, como função incluída a 100%. O `0 (E)` provisório era piso, não medida.

## Funções de dados alteradas

### ALI: Inscrição — RLR 11 · DER 85 → 86 · Alta

| Migração | Alteração | Tabela |
|---|---|---|
| V00030 | **Inclusão da coluna** `CD_UUID` (nvarchar(36), não nulo, único) — endereço individual do documento, conferido a cada acesso a quem tem direito à inscrição. *Antes* o documento não tinha endereço próprio | `TB_INSCRICAO_DOCUMENTO` |

**PFB 15 · PFL 7,5** — a função é **alterada**, não incluída: as tabelas já existiam e já pertenciam ao grupo. Não muda de faixa de complexidade.

> ⚠️ **Esta função de dados é compartilhada com o `PDTIC25093-61`.** Uma função conta **uma vez** no projeto de melhoria, venha de quantos itens de backlog vier. Somá-la aqui e lá daria o dobro do que a sprint tem. Enquanto a decisão não vier, o ALI fica **fora do apurável deste item**, com o valor visível para quem consolidar a sprint. Na análise agregada da SP05 ele entra uma vez, corretamente.

| Origem | Natureza | PFB | PFL |
|---|---|---|---|
| Funções de transação — 1 PE em 2 features | alteradas e incluídas | 13 | 9,5 |
| **Apurável do item** | — | **13** | **9,5** |
| ALI Inscrição ⚠️ *compartilhado com `PDTIC25093-61`* | alterada · 50% | *(15)* | *(7,5)* |

## Impacto em dicionários

**Nenhuma mensagem, regra ou campo canônico novo.** A entrega reaproveita o baseline de mensagens do dicionário.

## Decisões de produto pendentes

> A decisão sobre **onde mora a edição administrativa** foi respondida em 2026-09-01 — dentro da tela de validação da inscrição, confirmando a lotação em `VAL-ANA` que a spec já registrava. O que restou dela é a contagem, na decisão 2 abaixo.

### 1. A função de dados alterada é deste item ou do `PDTIC25093-61`?

**A situação** — a coluna `CD_UUID` de `TB_INSCRICAO_DOCUMENTO` (migração V00030) serve às **duas entregas**: aqui, ao download de documento na validação, em `VAL-ANA-01` **Detalhar Inscrição**; lá, ao download de anexo pelo avaliador, em `AVL-AVA-03` **Avaliar Inscrição**. A alteração de modelo é **uma só**; os itens de backlog são dois.

**Por que não pode entrar nos dois** — pela regra do CPM, o escopo de um projeto de melhoria é o **conjunto** das funções alteradas, e cada função tem um único estado "depois". O ALI **Inscrição** vale **15 PFB · 7,5 PFL**; somá-lo aqui e no `PDTIC25093-61` daria **o dobro do que a sprint tem**.

**Como está tratado** — enquanto a decisão não vier, o ALI fica **fora do apurável deste item**, com o valor visível entre parênteses para quem consolidar a sprint. Na análise agregada da SP05 ele entra **uma vez**, corretamente.

**Opções** — (a) *atribuir a este item*: o apurável de `PDTIC25093-68` sobe de 7 para **22 PFB**, e o de `PDTIC25093-61` fica em 20; (b) *atribuir ao `PDTIC25093-61`*: o inverso; (c) *não atribuir a nenhum*: o ALI entra apenas no consolidado da sprint — é a opção mais segura para quem audita por item.

**O que trava** — fecha o apurável do item. **Não muda o total da sprint** em nenhuma das opções: muda apenas onde os 15 PFB aparecem.

**Decide** — equipe de métricas, com o PO. **Alcança** — `PDTIC25093-68`, `PDTIC25093-61` e o ALI **Inscrição**.

### 2. A contagem da edição administrativa se confirma na métrica?

**O que foi contado** — o processo elementar de `VAL-ANA-05` **Editar Inscrição Validada** foi contado em 2026-09-01 sobre o N3: **EE, ALR 3, DER 11, complexidade Alta — 6 PF**, contra o `0 (E)` provisório que a análise carregava. A memória de cálculo está no próprio N3.

**O que merece conferência** — os **dois retratos da inscrição** (o estado antes e o depois da correção) ficaram **fora dos DER**: são gravados sem cruzar a fronteira, e o CPM 5.5.5 exclui atributos gerados dentro da fronteira. Se a métrica entender que eles são apresentados ao usuário em algum ponto, entram como DER e o PE sobe de faixa.

**Decide** — equipe de métricas. **Alcança** — `VAL-ANA-05` **Editar Inscrição Validada** e, por analogia de estrutura, `VAL-ANA-06` **Excluir Inscrição Validada**, que segue sem contagem.

## Metodologia

> Migrada de `arquivos/demandas/ANALISE_IMPACTO_PDTIC25093-68.md`.

Cruzamento do item `PDTIC25093-68` com os N3 publicados dos Feature Sets alcançados, o `global/DATA-MODEL.md`, o `global/CONTAGEM-PF.md` e o baseline APF `arquivos/PIEL_BASELINE_PF_CD.xlsx`. O "antes" de cada delta foi extraído das linhas removidas no diff dos N3, não do arquivo atual. Escopo do perfil `requisitos`: a análise para no negocial e no data-model. Este documento é o recorte por item da análise agregada da sprint, em `ANALISE_IMPACTO_SP05.md` — os números dos dois devem sempre fechar.

## Reconciliação

Aberta na entrega — migrada do relatório `arquivos/demandas/ANALISE_IMPACTO_PDTIC25093-68.md`: não houve escopo prévio a reconciliar.

## Changelog

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | migra-aim | AIM migrada | relatório `arquivos/demandas/ANALISE_IMPACTO_PDTIC25093-68.md` → AIM única |
