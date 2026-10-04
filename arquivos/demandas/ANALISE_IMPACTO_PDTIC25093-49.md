<!-- docqui: 2.16.0 | prompt: analise-impacto | atualizado: 2026-09-01 -->
# Análise Impacto PDTIC25093-49

---

## Sumário

| Indicador | Valor |
|---|---|
| Features alteradas | 4 |
| Features novas | 2 |
| Processos elementares com contagem no baseline | 2 |
| Regras de negócio acrescentadas | +32 |
| Cenários acrescentados | +28 |
| Mensagens novas no dicionário | 2 |
| Alterações de modelo | 3 |
| **PFB · PFL do item** (transações) | **36 · 33** |

> **Linha do tempo.** O baseline APF foi contado em **2026-02-28**, antes desta sprint — é o "antes" da contagem. Os N3 foram escritos entre **2026-08-25 e 27**, por engenharia reversa do código **pós-sprint**: logo o "antes" de cada delta é o N3 como publicado, não o sistema em produção. O item aparece encerrado na listagem mais recente do board. ⚠️ Não há SQL anterior à sprint nem os arquivos de migração no acervo — as alterações de modelo abaixo são as **declaradas** pela demanda e confirmadas no modelo atual, não as **verificadas no script**.

---

## 1. Detalhe do item

**`PDTIC25093-49` — Fechamento da Etapa de Avaliação · HU-030 — Fechar Etapa de Avaliação**

Na spec: **mistura com forte predominância de alteração**. O cluster de fechamento já existia — apurar, desempatar, encerrar e consolidar —, e o que a sprint fez foi trocar o miolo de cada um: o corte passou a ser automático, o ranking foi reorganizado em blocos estado→grupo e o fechamento ganhou pré-condição de feedback consolidado. Genuinamente novo: **reabrir um estado** e **exportar o relatório da etapa**.

O item concentra a maior parte do delta da sprint e é o único que cria features. Três das features alteradas não estavam no baseline — o módulo de fechamento é posterior à contagem de fevereiro —, então entram como **funções incluídas**, a 100%, com PFB estimado.

> **Critérios de aceite não numerados.** A HU chega como `.docx` e não numera os critérios. Pela regra da instância, a coluna `CA-n` sai `—` e a rastreabilidade fica pela chave da demanda. Numerar por conta própria produziria referências que não existem na ferramenta do cliente.

---

## 2. Alterações aplicadas na spec, por Feature Set

### Avaliação › Apuração e Devolutiva (`AVL-APU`)

| Feature | Demanda | `CA-n` | Natureza | O que mudou em relação ao comportamento anterior | Regras | Cenários | PFB | PFL |
|---|---|---|---|---|---|---|---|---|
| `AVL-APU-01` **Apurar Resultado da Etapa** | `PDTIC25093-49` · HU-030 | — | alterada | **Alteração** do agrupamento do ranking e **inclusão** do corte automático. Antes as inscrições competiam por grupo de oferta × enquadramento e a classificação era apenas a ordem por média — nada marcava quem passava. Agora o ranking é em blocos estado→grupo com colocação por bloco, o corte de classificação é aplicado automaticamente pela quantidade definida na etapa e existe um corte de premiação independente dele; as inscrições sem estado formam o bloco Nacional | +10 | +10 | 7 | 7 |
| `AVL-APU-02` **Registrar Desempate** | `PDTIC25093-49` · HU-030 | — | alterada | **Alteração** do escopo do desempate. Antes qualquer empate dentro do grupo exigia decisão manual, com um único tipo de corte (Classificação) e justificativa de tamanho livre. Agora só o empate que atravessa a linha de corte precisa de decisão, o corte pode ser de classificação ou de premiação, a comparação é questão a questão e a justificativa tem de 30 a 1.000 caracteres | +8 | +7 | 6 | 6 |
| `AVL-APU-03` **Encerrar Etapa por UF** | `PDTIC25093-49` · HU-030 | — | alterada | **Inclusão** da pré-condição de feedback consolidado e do encerramento automático; **correção** da regra de avanço. Antes bastavam apuração concluída e empates resolvidos para fechar a UF, e a RN4 dizia que "as premiadas avançam". Agora o fechamento exige todas as inscrições do estado com feedback consolidado, lista as pendências por participante, encerra a etapa sozinho quando o último estado fecha, e quem avança é o **classificado** | +10 | +8 | 6 | 6 |
| `AVL-APU-12` **Reabrir Etapa por UF** | `PDTIC25093-49` · HU-030 | — | incluída | **Feature incluída.** Devolve um estado já encerrado à apuração: recalcula o corte, preserva o feedback consolidado e desfaz apenas as decisões de corte e desempate daquele escopo; reabrir a etapa inteira exige as etapas posteriores abertas. Exclusiva do Administrador Nacional. Não existia — na spec o encerramento por UF era irreversível | — | — | 4 | 4 |
| `AVL-APU-09` **Exportar Relatório da Etapa** | `PDTIC25093-49` · HU-030 | — | incluída | **Feature incluída.** Planilha XLSX com uma aba Resumo (uma linha por UF × grupo) e uma aba por tipo de participante, consolidando respostas do formulário, notas por avaliador, feedback consolidado e decisão de corte. O Administrador Regional recebe o recorte das suas UFs. Compartilha o mesmo serviço de montagem com o Ranking da Etapa | — | — | 7 | 7 |

**Subtotal: 5 features · 30 PFB · 30 PFL** — contadas em 2026-09-01; antes eram 21 (E).

### Avaliação › Painel Administrativo (`AVL-PAI`)

| Feature | Demanda | `CA-n` | Natureza | O que mudou em relação ao comportamento anterior | Regras | Cenários | PFB | PFL |
|---|---|---|---|---|---|---|---|---|
| `AVL-PAI-03` **Consolidar Avaliação** | `PDTIC25093-49` · HU-030 | — | alterada | **Inclusão** da trava pelo fechamento. Antes o texto consolidado podia ser substituído a qualquer momento — uma nova consolidação sobrescrevia a anterior sem limite de prazo. Agora, com o estado já fechado, a consolidação é recusada; a consolidação completa do estado vira pré-requisito do fechamento e a reabertura do estado devolve o texto à edição | +4 | +3 | 6 | 3 |

**Subtotal: 1 feature · 6 PFB · 3 PFL.**

**Total do item: 6 features · +32 regras · +28 cenários · 36 PFB · 33 PFL.**

**Matriz N2 alterada**: Encerrar Etapa por UF deixa de ser acessível ao Administrador Regional — fechar, reabrir e desempatar passam a exclusivos do Nacional.

### Processos elementares por trás dos PFB medidos

A contagem é por **processo elementar**, não por feature — uma feature pode absorver mais de um PE, e deduplicar por feature subconta.

| Processo elementar | Feature | Tipo | ALR | DER | Complexidade | PFB |
|---|---|---|---|---|---|---|
| Consolidar Avaliação | `AVL-PAI-03` **Consolidar Avaliação** | EE | 1 | 3 | Simples | 3 |
| Pré-visualizar Consolidação | `AVL-PAI-03` **Consolidar Avaliação** | CE | 1 | 2 | Simples | 3 |

A memória de cálculo de cada PE — ALR e DER nomeados — vive na seção `## Métricas de tamanho` do respectivo N3 e no `global/CONTAGEM-PF.md`.

✅ **5 features contadas em 2026-09-01, fora do baseline** — `AVL-APU-01` **Apurar Resultado da Etapa**, `AVL-APU-02` **Registrar Desempate**, `AVL-APU-03` **Encerrar Etapa por UF**, `AVL-APU-12` **Reabrir Etapa por UF**, `AVL-APU-09` **Exportar Relatório da Etapa**. O PFB dessas linhas é **estimativa** `(E)`: não estavam na contagem de fevereiro.

---

## 3. Tabelas alteradas, por função de dados

### ALI: Avaliação de Inscrição — RLR 3 → 4 · DER 38 → 42 · Média

| Migração | Alteração | Tabela |
|---|---|---|
| V00032 | **Inclusão da coluna** `FL_PREMIADO` (bit, não nulo, padrão 0) — marca a inscrição premiada. *Antes* não havia como distinguir a premiada da classificada | `TB_APROVACAO_ETAPA_PARTICIPANTE` |
| V00032 | **Inclusão da coluna** `DS_TIPO_CORTE` (varchar(15), não nulo, padrão `CLASSIFICACAO`) — distingue o desempate de classificação do de premiação. *Antes* toda decisão de desempate era de classificação | `TB_DESEMPATE_DECISAO` |
| V00033 | **Criação da tabela** — fechamento da etapa por estado. *Antes* o fechamento era da etapa inteira, sem recorte por estado. Entidade dependente da Etapa: entra como registro lógico do ALI, **não** como função de dados nova | `TB_FECHAMENTO_ETAPA_UF` |

**PFB 10 · PFL 5** — a função é **alterada**, não incluída: as tabelas já existiam e já pertenciam ao grupo. Não muda de faixa de complexidade.

| Origem | Natureza | PFB | PFL |
|---|---|---|---|
| Funções de transação — 2 PE em 6 features | alteradas e incluídas | 36 | 33 |
| ALI Avaliação de Inscrição | alterada · 50% | 10 | 5 |
| **Apurável do item** | — | **36** | **33** |

---

## 4. Impacto em dicionários

| Chave | Texto | Onde é usada |
|---|---|---|
| `AVL_FECHAMENTO_PENDENCIAS` | recusa o fechamento do estado quando resta inscrição sem feedback consolidado | `AVL-APU-03` **Encerrar Etapa por UF** |
| `AVL_FECHAMENTO_EMPATE_CORTE` | recusa o fechamento quando há empate pendente na linha de corte | `AVL-APU-03` **Encerrar Etapa por UF** |

Nenhuma regra ou campo canônico novo.

---

## 5. Decisões de produto pendentes

> Três decisões deste item foram respondidas em 2026-09-01 e já estão aplicadas na spec: **avança o classificado** (RN4 de `AVL-APU-03` **Encerrar Etapa por UF**) e **a reabertura apaga a linha de fechamento**, sem trilha do fechamento anterior — o que confirma as 3 alterações de modelo do item, sem a quarta que estava em estudo. A terceira era a confirmação dos PFB estimados: os cinco processos elementares foram **contados** em 2026-09-01 — as três de fechamento passaram de 4 (E) para 7, 6 e 6 PF, e o item subiu de 27 (E) para 36 PFB. Saíram desta lista; os números **1**, **2** e **3** anteriores não foram reaproveitados.

### 3. `AVL-APU-12` **Reabrir Etapa por UF** — contagem a validar

**O que mudou** — a feature ganhou N3 em 2026-09-01, e o processo elementar foi contado na mesma data: **EE, ALR 3, DER 4, complexidade Média — 4 PF**, com a memória de cálculo no próprio N3. O valor confirma exatamente a arbitragem anterior, mas agora com ALR e DER nomeados.

**O que falta** — a **validação da equipe de métricas**. Duas leituras desta contagem merecem conferência: os três subgrupos que a reabertura toca (Fechamento por UF, Apuração por Etapa e Decisões de Desempate) pertencem todos ao ALI **Avaliação de Inscrição** e contam **um ALR só**; e a ausência de justificativa reduz os DER de entrada a um.

**Por que o ID é `12`** — `AVL-APU-07` e `AVL-APU-11` foram aposentados pela unificação de gerar+exportar (decisão 6 da sprint) e, pela regra de identificadores do `global/MASTER.md`, não são reutilizados.

**Decide** — equipe de métricas. **Alcança** — `AVL-APU-12` **Reabrir Etapa por UF**.

---

## Metodologia

Cruzamento do item `PDTIC25093-49` com os N3 publicados dos Feature Sets alcançados, o `global/DATA-MODEL.md`, o `global/CONTAGEM-PF.md` e o baseline APF `arquivos/PIEL_BASELINE_PF_CD.xlsx`. O "antes" de cada delta foi extraído das linhas removidas no diff dos N3, não do arquivo atual. Escopo do perfil `requisitos`: a análise para no negocial e no data-model. Este documento é o recorte por item da análise agregada da sprint, em `ANALISE_IMPACTO_SP05.md` — os números dos dois devem sempre fechar.

## Changelog

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-09-01 | Contagem APF (docqui) | Estimativas substituídas por contagem | Os processos elementares que faltavam foram contados sobre os N3, com ALR e DER nomeados. O apurável do item passa de **27 (E) · 24 (E)** para **36 · 33 PF**. ⚠️ Pendente de validação pela equipe de métricas |
| 2026-09-01 | Especificação (docqui) | Feature especificada | `AVL-APU-12` **Reabrir Etapa por UF** ganhou N3; a pendência deixa de ser a spec e passa a ser a contagem do processo elementar |
| 2026-09-01 | Decisões de produto (docqui) | Decisões respondidas | O produto respondeu as decisões pendentes deste documento; elas foram aplicadas na spec e saíram da lista da seção 5. Os números das que ficaram não foram reaproveitados |
| 2026-09-01 | Decisão 3 da sprint (docqui) | Numeração reconciliada | `Reabrir Etapa por UF` passa de `AVL-APU-08` (numeração proposta, que colidia com `Consultar Ranking da Etapa` na árvore) para `AVL-APU-12`, o próximo ID livre depois dos aposentados pela decisão 6. Decisões reescritas com mais detalhe e acrescida a pendência do N3 da reabertura |
| 2026-09-01 | Análise de impacto (docqui) | Documento criado | Impacto do item `PDTIC25093-49` sobre a spec, derivado da análise agregada da SP05 |
