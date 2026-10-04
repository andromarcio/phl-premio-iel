<!-- docqui: 2.16.0 | prompt: analise-impacto | atualizado: 2026-09-01 -->
# Análise Impacto PDTIC25093-66

---

## Sumário

| Indicador | Valor |
|---|---|
| Features alteradas | 0 |
| Features novas | 1 |
| Processos elementares com contagem no baseline | 0 |
| Regras de negócio acrescentadas | +0 |
| Cenários acrescentados | +0 |
| Mensagens novas no dicionário | nenhuma |
| Alterações de modelo | nenhuma |
| **PFB · PFL do item** (transações) | **7 · 7** |

> **Linha do tempo.** O baseline APF foi contado em **2026-02-28**, antes desta sprint — é o "antes" da contagem. Os N3 foram escritos entre **2026-08-25 e 27**, por engenharia reversa do código **pós-sprint**: logo o "antes" de cada delta é o N3 como publicado, não o sistema em produção. O item aparece encerrado na listagem mais recente do board. ⚠️ Não há SQL anterior à sprint nem os arquivos de migração no acervo — as alterações de modelo abaixo são as **declaradas** pela demanda e confirmadas no modelo atual, não as **verificadas no script**.

---

## 1. Detalhe do item

**`PDTIC25093-66` — Ranking por Etapa · HU-038 — Ranking por Etapa**

Na spec: **feature nova** — a irmã somente-leitura da tela de Fechamento. Consulta o resultado consolidado sem as ações de fechar, reabrir ou arbitrar, e para etapa encerrada apresenta o resultado **gravado** no fechamento, não um recálculo.

Item de uma feature só, inteiramente nova. Não estava no baseline; o seu processo elementar foi contado em 2026-09-01 sobre o N3.

> **Critérios de aceite não numerados.** A HU chega como `.docx` e não numera os critérios. Pela regra da instância, a coluna `CA-n` sai `—` e a rastreabilidade fica pela chave da demanda. Numerar por conta própria produziria referências que não existem na ferramenta do cliente.

---

## 2. Alterações aplicadas na spec, por Feature Set

### Avaliação › Apuração e Devolutiva (`AVL-APU`)

| Feature | Demanda | `CA-n` | Natureza | O que mudou em relação ao comportamento anterior | Regras | Cenários | PFB | PFL |
|---|---|---|---|---|---|---|---|---|
| `AVL-APU-08` **Consultar Ranking da Etapa** | `PDTIC25093-66` · HU-038 | — | incluída | **Feature incluída.** Consulta somente leitura do resultado consolidado, em blocos estado→grupo, com endereço direto para um bloco; para etapa encerrada apresenta o resultado gravado no fechamento, não um recálculo. Acessível ao Nacional e ao Regional, este restrito às suas UFs. É a irmã de leitura da tela de Fechamento | — | — | 7 | 7 |

**Subtotal: 1 feature · 7 PFB · 7 PFL** — contado em 2026-09-01; a arbitragem anterior era 5 (E).

**Total do item: 1 feature · +0 regras · +0 cenários · 7 PFB · 7 PFL.**

✅ **1 feature contada em 2026-09-01, fora do baseline** — `AVL-APU-08` **Consultar Ranking da Etapa**: SE, ALR 7, DER 16, complexidade Alta, **7 PF**. A capacidade não estava na contagem de fevereiro; a classificação SE está sujeita à conferência descrita na seção 5.

---

## 3. Tabelas alteradas, por função de dados

**Nenhuma alteração de modelo.** O item não declara migração: a entrega lê e escreve no que já existia.

| Origem | Natureza | PFB | PFL |
|---|---|---|---|
| Funções de transação — 0 PE em 1 feature | alteradas e incluídas | 7 | 7 |
| **Apurável do item** | — | **7** | **7** |

---

## 4. Impacto em dicionários

**Nenhuma mensagem, regra ou campo canônico novo.** A entrega reaproveita o baseline de mensagens do dicionário.

---

## 5. Decisões de produto pendentes

> A decisão sobre o que o Administrador Regional enxerga no ranking foi respondida em 2026-09-01, junto com a abrangência do corte: em etapa **regional** ele enxerga apenas os estados a que está vinculado — confirmando o recorte que a spec já adotava — e a etapa **nacional** não é apresentada a ele. Aplicada na RN4 de `AVL-APU-08` **Consultar Ranking da Etapa** e na matriz de visibilidade do N2. Saiu desta lista; o número **2** não foi reaproveitado.

### 1. `Consultar Ranking da Etapa` é SE ou CE?

**O que foi contado** — o processo elementar de `AVL-APU-08` **Consultar Ranking da Etapa** foi contado em 2026-09-01 sobre o N3: **SE, ALR 7, DER 16, complexidade Alta — 7 PF**, contra os 5 (E) arbitrados. A memória de cálculo, com os ALR e DER nomeados, está no próprio N3.

**Onde está a dúvida** — a classificação como **SE** apoia-se em dado derivado: a *Coleta* é uma contagem de avaliadores finalizados sobre alocados, e as duas **linhas de corte** são posições calculadas a partir das quantidades configuradas na etapa. A regra 2 do N3 diz que a consulta **não recalcula** a apuração, o que puxa para CE; mas apresentar posições e contagens que não estão gravadas é criação de dado derivado, o que exclui CE (CPM 5.5.3).

**O que muda com cada resposta** — mantida como **SE**, vale 7 PF e o item fecha em 7 PFB. Reclassificada como **CE**, vale 6 PF e o item cai para 6.

**Decide** — equipe de métricas. **Alcança** — `AVL-APU-08` **Consultar Ranking da Etapa**.

---

## Metodologia

Cruzamento do item `PDTIC25093-66` com os N3 publicados dos Feature Sets alcançados, o `global/DATA-MODEL.md`, o `global/CONTAGEM-PF.md` e o baseline APF `arquivos/PIEL_BASELINE_PF_CD.xlsx`. O "antes" de cada delta foi extraído das linhas removidas no diff dos N3, não do arquivo atual. Escopo do perfil `requisitos`: a análise para no negocial e no data-model. Este documento é o recorte por item da análise agregada da sprint, em `ANALISE_IMPACTO_SP05.md` — os números dos dois devem sempre fechar.

## Changelog

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-09-01 | Contagem APF (docqui) | Estimativas substituídas por contagem | Os processos elementares que faltavam foram contados sobre os N3, com ALR e DER nomeados. O apurável do item passa de **5 (E) · 5 (E)** para **7 · 7 PF**. ⚠️ Pendente de validação pela equipe de métricas |
| 2026-09-01 | Decisões de produto (docqui) | Decisão respondida | O recorte do Administrador Regional no ranking foi confirmado e ampliado: etapa regional mostra apenas os seus estados, etapa nacional não é apresentada a ele. Saiu da lista de decisões |
| 2026-09-01 | Decisão 3 da sprint (docqui) | Numeração reconciliada | `Consultar Ranking da Etapa` passa de `AVL-APU-10` (numeração proposta) para `AVL-APU-08`, que é o ID real na árvore de arquivos. Decisões reescritas com mais detalhe |
| 2026-09-01 | Análise de impacto (docqui) | Documento criado | Impacto do item `PDTIC25093-66` sobre a spec, derivado da análise agregada da SP05 |
