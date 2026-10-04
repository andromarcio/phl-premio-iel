<!-- docqui: 2.16.0 | prompt: analise-impacto | atualizado: 2026-09-01 -->
# Análise Impacto PDTIC25093-61

---

## Sumário

| Indicador | Valor |
|---|---|
| Features alteradas | 3 |
| Features novas | nenhuma |
| Processos elementares com contagem no baseline | 4 |
| Regras de negócio acrescentadas | +7 |
| Cenários acrescentados | +6 |
| Mensagens novas no dicionário | 1 |
| Alterações de modelo | 1 |
| **PFB · PFL do item** (transações) | **20 · 10** |

> **Linha do tempo.** O baseline APF foi contado em **2026-02-28**, antes desta sprint — é o "antes" da contagem. Os N3 foram escritos entre **2026-08-25 e 27**, por engenharia reversa do código **pós-sprint**: logo o "antes" de cada delta é o N3 como publicado, não o sistema em produção. O item aparece encerrado na listagem mais recente do board. ⚠️ Não há SQL anterior à sprint nem os arquivos de migração no acervo — as alterações de modelo abaixo são as **declaradas** pela demanda e confirmadas no modelo atual, não as **verificadas no script**.

---

## 1. Detalhe do item

**`PDTIC25093-61` — Melhorias na Avaliação · HU-028 — Avaliar Inscrição**

Na spec: **alteração pura** de três features do Feature Set de Avaliação de Projetos. O item reúne duas entregas independentes que só se encontram na tela do avaliador — o salto entre avaliações pendentes e o download seguro de anexo.

O salto é o que tem consequência de projeto: ele obriga `AVL-AVA-01` **Acompanhar Minhas Avaliações** a deixar de ser tela de consulta e passar a ser a **fonte da fila**. A feature que mais muda de comportamento não é a que o usuário percebe mudando.

> **Critérios de aceite não numerados.** A HU chega como `.docx` e não numera os critérios. Pela regra da instância, a coluna `CA-n` sai `—` e a rastreabilidade fica pela chave da demanda. Numerar por conta própria produziria referências que não existem na ferramenta do cliente.

---

## 2. Alterações aplicadas na spec, por Feature Set

### Avaliação › Avaliação de Projetos (`AVL-AVA`)

| Feature | Demanda | `CA-n` | Natureza | O que mudou em relação ao comportamento anterior | Regras | Cenários | PFB | PFL |
|---|---|---|---|---|---|---|---|---|
| `AVL-AVA-01` **Acompanhar Minhas Avaliações** | `PDTIC25093-61` · HU-028 | — | alterada | **Inclusão** do papel de fila. Antes o painel do avaliador era só uma tela de consulta — cartões das inscrições alocadas, com seletores de premiação, etapa e status. Agora ele também define a sequência e o recorte das avaliações pendentes que o salto "Próxima pendente" consome | +2 | +1 | 7 | 3,5 |
| `AVL-AVA-03` **Avaliar Inscrição** | `PDTIC25093-61` · HU-028 | — | alterada | **Alteração** da forma de baixar o anexo. Antes a tela apenas listava os anexos para download, sem dizer como o acesso era conferido. Agora cada documento tem endereço individual e o direito é verificado a cada acesso, contra a inscrição designada ao avaliador | +2 | +2 | 10 | 5 |
| `AVL-AVA-04` **Finalizar Avaliação** | `PDTIC25093-61` · HU-028 | — | alterada | **Inclusão** do salto para a próxima avaliação. Antes finalizar encerrava o registro em somente leitura e o avaliador voltava ao painel para escolher a próxima inscrição. Agora existe o salto "Próxima pendente", restrito ao recorte vigente do acompanhamento, com aviso quando não resta pendência | +3 | +3 | 3 | 1,5 |

**Subtotal: 3 features · 20 PFB · 10 PFL.**

**Total do item: 3 features · +7 regras · +6 cenários · 20 PFB · 10 PFL.**

### Processos elementares por trás dos PFB medidos

A contagem é por **processo elementar**, não por feature — uma feature pode absorver mais de um PE, e deduplicar por feature subconta.

| Processo elementar | Feature | Tipo | ALR | DER | Complexidade | PFB |
|---|---|---|---|---|---|---|
| Consultar Painel Minhas Avaliações | `AVL-AVA-01` **Acompanhar Minhas Avaliações** | SE | 7 | 18 | Complexo | 7 |
| Consultar Avaliação (implícita) | `AVL-AVA-03` **Avaliar Inscrição** | SE | 7 | 31 | Complexo | 7 |
| Salvar Avaliação | `AVL-AVA-03` **Avaliar Inscrição** | EE | 1 | 5 | Simples | 3 |
| Finalizar Avaliação | `AVL-AVA-04` **Finalizar Avaliação** | EE | 1 | 3 | Simples | 3 |

A memória de cálculo de cada PE — ALR e DER nomeados — vive na seção `## Métricas de tamanho` do respectivo N3 e no `global/CONTAGEM-PF.md`.

---

## 3. Tabelas alteradas, por função de dados

### ALI: Inscrição — RLR 11 · DER 85 → 86 · Alta

| Migração | Alteração | Tabela |
|---|---|---|
| V00030 | **Inclusão da coluna** `CD_UUID` (nvarchar(36), não nulo, único) — endereço individual do documento, base do download conferido a cada acesso. *Antes* o documento não tinha endereço próprio | `TB_INSCRICAO_DOCUMENTO` |

**PFB 15 · PFL 7,5** — a função é **alterada**, não incluída: as tabelas já existiam e já pertenciam ao grupo. Não muda de faixa de complexidade.

> ⚠️ **Esta função de dados é compartilhada com o `PDTIC25093-68`.** Uma função conta **uma vez** no projeto de melhoria, venha de quantos itens de backlog vier. Somá-la aqui e lá daria o dobro do que a sprint tem. Enquanto a decisão não vier, o ALI fica **fora do apurável deste item**, com o valor visível para quem consolidar a sprint. Na análise agregada da SP05 ele entra uma vez, corretamente.

| Origem | Natureza | PFB | PFL |
|---|---|---|---|
| Funções de transação — 4 PE em 3 features | alteradas · 50% | 20 | 10 |
| **Apurável do item** | — | **20** | **10** |
| ALI Inscrição ⚠️ *compartilhado com `PDTIC25093-68`* | alterada · 50% | *(15)* | *(7,5)* |

---

## 4. Impacto em dicionários

| Chave | Texto | Onde é usada |
|---|---|---|
| `AVL_SEM_PENDENTES` | aviso quando não resta avaliação pendente após o salto | `AVL-AVA-04` **Finalizar Avaliação** |

Nenhuma regra ou campo canônico novo.

---

## 5. Decisões de produto pendentes

> A decisão sobre a fila do "Próxima pendente" foi respondida em 2026-09-01 — **é a do painel**, mesmo recorte e mesma ordem de protocolo do acompanhamento. ⚠️ Esta análise afirmava que a spec não fixava a ordem; **estava errada**: a regra 7 de `AVL-AVA-01` **Acompanhar Minhas Avaliações** já dizia "na sequência crescente de protocolo com que este acompanhamento as apresenta". O que era suposição e caiu foi a **abrangência** do salto, não a ordem. Os ⚠️ correspondentes saíram de `AVL-AVA-01` e de `AVL-AVA-04` **Finalizar Avaliação**. Saiu desta lista; o número **2** não foi reaproveitado.

### 1. A função de dados alterada é deste item ou do `PDTIC25093-68`?

**A situação** — a coluna `CD_UUID` de `TB_INSCRICAO_DOCUMENTO` (migração V00030) serve às **duas entregas**: aqui, ao download de anexo pelo avaliador em `AVL-AVA-03` **Avaliar Inscrição**; lá, ao download de documento na validação, em `VAL-ANA-01` **Detalhar Inscrição**. A alteração de modelo é **uma só**; os itens de backlog são dois.

**Por que não pode entrar nos dois** — pela regra do CPM, o escopo de um projeto de melhoria é o **conjunto** das funções alteradas, e cada função tem um único estado "depois". O ALI **Inscrição** vale **15 PFB · 7,5 PFL**; somá-lo aqui e no `PDTIC25093-68` daria **o dobro do que a sprint tem**.

**Como está tratado** — enquanto a decisão não vier, o ALI fica **fora do apurável deste item**, com o valor visível entre parênteses para quem consolidar a sprint. Na análise agregada da SP05 ele entra **uma vez**, corretamente — os 40 PFB de funções de dados da sprint já contam com essa deduplicação.

**Opções** — (a) *atribuir a este item*: o apurável de `PDTIC25093-61` sobe de 20 para **35 PFB**, e o de `PDTIC25093-68` fica em 7; (b) *atribuir ao `PDTIC25093-68`*: o inverso; (c) *não atribuir a nenhum*: o ALI entra apenas no consolidado da sprint, e nenhum item o reivindica — é a opção mais segura para quem audita por item.

**O que trava** — fecha o apurável do item. **Não muda o total da sprint** em nenhuma das opções: muda apenas onde os 15 PFB aparecem.

**Decide** — equipe de métricas, com o PO. **Alcança** — `PDTIC25093-61`, `PDTIC25093-68` e o ALI **Inscrição**.

---

## Metodologia

Cruzamento do item `PDTIC25093-61` com os N3 publicados dos Feature Sets alcançados, o `global/DATA-MODEL.md`, o `global/CONTAGEM-PF.md` e o baseline APF `arquivos/PIEL_BASELINE_PF_CD.xlsx`. O "antes" de cada delta foi extraído das linhas removidas no diff dos N3, não do arquivo atual. Escopo do perfil `requisitos`: a análise para no negocial e no data-model. Este documento é o recorte por item da análise agregada da sprint, em `ANALISE_IMPACTO_SP05.md` — os números dos dois devem sempre fechar.

## Changelog

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-09-01 | Decisões de produto (docqui) | Decisão respondida e erro corrigido | A fila do salto é a do painel, confirmando o recorte e a ordem que a spec já registrava. Corrigida a afirmação desta análise de que a spec não fixava a ordem — a regra 7 de `AVL-AVA-01` **Acompanhar Minhas Avaliações** já a fixava por protocolo crescente |
| 2026-09-01 | Análise de impacto (docqui) | Decisões detalhadas | Seção 5 reescrita: cada decisão passa a trazer o que está na spec hoje, as opções com o custo de cada uma, o que ela trava e quem decide; todas as features citadas com código **e** nome |
| 2026-09-01 | Análise de impacto (docqui) | Documento criado | Impacto do item `PDTIC25093-61` sobre a spec, derivado da análise agregada da SP05 |
