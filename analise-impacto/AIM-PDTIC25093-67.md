---
tipo: ticket
ticket: PDTIC25093-67
ferramenta: ""
link: ""
titulo: ""
estado: concluído
aberta-na-entrega: true
sprint: SP05
avalizado-por: ""
aberta-em: 2026-10-04
---

# AIM PDTIC25093-67

## Sumário

> Migrada de `arquivos/demandas/ANALISE_IMPACTO_PDTIC25093-67.md`.

| Indicador | Valor |
|---|---|
| Features alteradas | 2 |
| Features novas | nenhuma |
| Processos elementares com contagem no baseline | 3 |
| Regras de negócio acrescentadas | +12 |
| Cenários acrescentados | +10 |
| Mensagens novas no dicionário | 3 |
| Alterações de modelo | 2 |
| **PFB · PFL do item** (transações) | **6 · 3** |

> **Linha do tempo.** O baseline APF foi contado em **2026-02-28**, antes desta sprint — é o "antes" da contagem. Os N3 foram escritos entre **2026-08-25 e 27**, por engenharia reversa do código **pós-sprint**: logo o "antes" de cada delta é o N3 como publicado, não o sistema em produção. O item aparece encerrado na listagem mais recente do board. ⚠️ Não há SQL anterior à sprint nem os arquivos de migração no acervo — as alterações de modelo abaixo são as **declaradas** pela demanda e confirmadas no modelo atual, não as **verificadas no script**.

## Detalhe do item

> Migrada de `arquivos/demandas/ANALISE_IMPACTO_PDTIC25093-67.md`.

**`PDTIC25093-67` — Melhorias na configuração · HU-024 — Configurar Etapas de Avaliação**

Na spec: **alteração pura** do editor de etapa, que é compartilhado por cadastrar e editar. O que entrou foram os dois cortes — quantos classificam e quantos premiam —, informação que não existia em lugar nenhum da spec e sem a qual o fechamento não teria como aplicar corte automático.

Este item é pré-requisito do `PDTIC25093-49`: o fechamento aplica o corte que a configuração define. Na spec os dois aparecem separados, mas na entrega um depende do outro.

> **Critérios de aceite não numerados.** A HU chega como `.docx` e não numera os critérios. Pela regra da instância, a coluna `CA-n` sai `—` e a rastreabilidade fica pela chave da demanda. Numerar por conta própria produziria referências que não existem na ferramenta do cliente.

## Critérios de aceite

> ⚠️ Migrada sem o registro do ticket: transcreva aqui os critérios de aceite da ferramenta de origem.

## Features

| Feature (N3) | Domínio · Feature Set | Operação | Critérios cobertos | Status |
|---|---|---|---|---|
| [`AVL-ETA-02`: Cadastrar Etapa](../modules/avaliacao/etapas-configuracao/f-cadastrar-etapa.md) | Avaliação · Etapas e Configuração da Avaliação | Alteração | — | ✏️ Rascunho |
| [`AVL-ETA-03`: Editar Etapa](../modules/avaliacao/etapas-configuracao/f-editar-etapa.md) | Avaliação · Etapas e Configuração da Avaliação | Alteração | — | ✏️ Rascunho |

## Artefatos impactados

| Artefato | Tipo | Operação | Seção | Natureza | O quê | Proveniência |
|---|---|---|---|---|---|---|
| `modules/avaliacao/etapas-configuracao/f-cadastrar-etapa.md` | N3 | alterar | — | funcional | — | migrado: relatório |
| `modules/avaliacao/etapas-configuracao/f-editar-etapa.md` | N3 | alterar | — | funcional | — | migrado: relatório |
| `modules/avaliacao/etapas-configuracao/f-cadastrar-etapa.md` | N3 | alterar | — | funcional | — | migrado: relatório |
| `modules/avaliacao/etapas-configuracao/f-editar-etapa.md` | N3 | alterar | — | funcional | — | migrado: relatório |
| `modules/avaliacao/etapas-configuracao/f-editar-etapa.md` | N3 | alterar | — | funcional | — | migrado: relatório |

## Alterações na spec, por Feature Set

### Avaliação › Etapas e Configuração da Avaliação (`AVL-ETA`)

| Feature | `CA-n` | Natureza | O que mudou em relação ao comportamento anterior | Regras | Cenários | PFB | PFL |
|---|---|---|---|---|---|---|---|
| `AVL-ETA-02` **Cadastrar Etapa** | — | alterada | **Inclusão** dos campos *Quantidade de classificados* (obrigatório, mínimo 1) e *Quantidade de premiados* (opcional). Antes o editor capturava apenas nome, período e perfis autorizados — quantos participantes avançam de etapa não era informado em lugar nenhum | +4 | +4 | 3 | 1,5 |
| `AVL-ETA-03` **Editar Etapa** | — | alterada | **Inclusão** dos mesmos dois campos em edição, **restrição** do corte enquanto a etapa está fechada e **inclusão** dos selos "Classificados" e "Premiados" no cartão. Antes a edição alcançava nome, período e perfis, e a etapa fechada recusava qualquer alteração em bloco | +8 | +6 | 3 | 1,5 |

**Subtotal: 2 features · 6 PFB · 3 PFL.**

**Total do item: 2 features · +12 regras · +10 cenários · 6 PFB · 3 PFL.**

### Processos elementares por trás dos PFB medidos

A contagem é por **processo elementar**, não por feature — uma feature pode absorver mais de um PE, e deduplicar por feature subconta.

| Processo elementar | Feature | Tipo | ALR | DER | Complexidade | PFB |
|---|---|---|---|---|---|---|
| Cadastrar Nova Etapa | `AVL-ETA-02` **Cadastrar Etapa** | EE | 1 | 7 | Simples | 3 |
| Consultar Etapa (implícita) | `AVL-ETA-03` **Editar Etapa** | CE | — | — | — | 0 |
| Editar Etapa | `AVL-ETA-03` **Editar Etapa** | EE | 1 | 7 | Simples | 3 |

A memória de cálculo de cada PE — ALR e DER nomeados — vive na seção `## Métricas de tamanho` do respectivo N3 e no `global/CONTAGEM-PF.md`.

## Funções de dados alteradas

### ALI: Premiação — RLR 9 · DER 71 → 73 · Alta

| Migração | Alteração | Tabela |
|---|---|---|
| V00031 | **Inclusão da coluna** `NR_CLASSIFICADOS` (int, não nulo, padrão 1) — quantos participantes de cada grupo de disputa avançam. *Antes* a etapa não guardava corte nenhum | `TB_ETAPA` |
| V00032 | **Inclusão da coluna** `NR_PREMIADOS` (int, aceita nulo) — segundo corte, independente do de classificação; nulo significa etapa que não premia | `TB_ETAPA` |

**PFB 15 · PFL 7,5** — a função é **alterada**, não incluída: as tabelas já existiam e já pertenciam ao grupo. Não muda de faixa de complexidade.

| Origem | Natureza | PFB | PFL |
|---|---|---|---|
| Funções de transação — 3 PE em 2 features | alteradas · 50% | 6 | 3 |
| ALI Premiação | alterada · 50% | 15 | 7,5 |
| **Apurável do item** | — | **21** | **10,5** |

## Impacto em dicionários

| Chave | Texto | Onde é usada |
|---|---|---|
| `AVL_ETAPA_CLASSIFICADOS_INVALIDO` | recusa quantidade de classificados menor que um | `AVL-ETA-02` **Cadastrar Etapa** · `AVL-ETA-03` **Editar Etapa** |
| `AVL_ETAPA_PREMIADOS_INVALIDO` | recusa quantidade de premiados informada menor que um | `AVL-ETA-02` **Cadastrar Etapa** · `AVL-ETA-03` **Editar Etapa** |
| `AVL_ETAPA_CORTE_BLOQUEADO` | recusa alteração do corte com a etapa fechada | `AVL-ETA-03` **Editar Etapa** |

Nenhuma regra ou campo canônico novo.

## Decisões de produto pendentes

✅ **Nenhuma.** A única decisão deste item — de onde vem a abrangência do corte de classificação — foi respondida em 2026-09-01: ela deriva da **natureza da etapa**, e não dos perfis autorizados a operá-la. A etapa **nacional** apura o corte entre todos os inscritos, dentro de cada grupo; a etapa **regional** apura por estado dentro de cada grupo. A visibilidade sai da mesma natureza: o Administrador Regional não enxerga uma etapa nacional e, na regional, enxerga apenas os estados a que está vinculado.

A decisão **desacoplou** permissão de resultado, que era o risco apontado: uma configuração de perfil deixa de mudar quem classifica. Foi aplicada nas regras de `AVL-ETA-02` **Cadastrar Etapa** e `AVL-ETA-03` **Editar Etapa**, em `AVL-APU-01` **Apurar Resultado da Etapa** e `AVL-APU-08` **Consultar Ranking da Etapa**, com a matriz de visibilidade no N2 de Apuração e Devolutiva.

⚠️ **Sobrou um ponto de especificação, não de produto**: não há campo em Etapa que declare se ela é nacional ou regional — hoje isso só pode ser lido da lista de perfis autorizados, que é o acoplamento que a decisão quis remover. Está registrado em *Definições ainda em aberto* do relatório agregado.

## Metodologia

> Migrada de `arquivos/demandas/ANALISE_IMPACTO_PDTIC25093-67.md`.

Cruzamento do item `PDTIC25093-67` com os N3 publicados dos Feature Sets alcançados, o `global/DATA-MODEL.md`, o `global/CONTAGEM-PF.md` e o baseline APF `arquivos/PIEL_BASELINE_PF_CD.xlsx`. O "antes" de cada delta foi extraído das linhas removidas no diff dos N3, não do arquivo atual. Escopo do perfil `requisitos`: a análise para no negocial e no data-model. Este documento é o recorte por item da análise agregada da sprint, em `ANALISE_IMPACTO_SP05.md` — os números dos dois devem sempre fechar.

## Reconciliação

Aberta na entrega — migrada do relatório `arquivos/demandas/ANALISE_IMPACTO_PDTIC25093-67.md`: não houve escopo prévio a reconciliar.

## Changelog

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | migra-aim | AIM migrada | relatório `arquivos/demandas/ANALISE_IMPACTO_PDTIC25093-67.md` → AIM única |
