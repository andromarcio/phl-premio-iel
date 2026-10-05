---
tipo: ticket
ticket: PDTIC25093-69
ferramenta: ""
link: ""
titulo: ""
estado: concluído
aberta-na-entrega: true
sprint: SP06
avalizado-por: ""
aberta-em: 2026-10-04
---

# AIM PDTIC25093-69

## Sumário

> Migrada de `arquivos/demandas/ANALISE_IMPACTO_PDTIC25093-69.md`.

| Indicador | Valor |
|---|---|
| Features novas | 1 — `AVL-APU-14` Enviar Feedback ao Participante |
| Features alteradas | 5 |
| Processos elementares contados nesta análise | 3 |
| Regras de negócio acrescentadas | +3 |
| Cenários acrescentados | +0 *(2 reescritos)* · 9 próprios da feature nova |
| Mensagens novas no dicionário | nenhuma |
| Alterações de modelo | **V00034** — 1 tabela nova, 4 colunas, 1 carga de dados |
| **PFB · PFL do item** (transações) | **24 · 20,5** |
| **PFB · PFL do item** (funções de dados) | **10 · 5** |
| **PFB · PFL apurável do item** | **34 · 25,5** |

> **Linha do tempo.** O baseline APF foi contado em **2026-02-28** e não cobre nada deste item. Os N3 foram escritos por engenharia reversa entre **2026-08-25 e 27** e conferidos com o código em **2026-08-28** — o "antes" de cada delta é o N3 como publicado. O card foi aberto em **2026-09-10**.
>
> ⚠️ **O board e a entrega discordam, e vale a entrega.** Em 2026-10-01 o item constava como *In Progress*, e a análise de 2026-10-02 registrou, com razão para o que sabia então, que nada havia a aplicar na spec. O **resumo de entrega da Sprint 6**, recebido em 2026-10-04, descreve as três linhas do card como **entregues em 2026-10-01** — inclusive uma tela nova —, com a migração **V00034**, e a remoção da etiqueta "Gerado por I.A." datada de **2026-09-23** (PR 88452). Esta análise foi reescrita sobre a entrega; a versão anterior fica registrada no changelog. ⚠️ Os repositórios de código não estão ao alcance desta sessão: o que se afirma aqui vem do resumo de entrega e da spec, não de leitura do código.

## Detalhe do item

> Migrada de `arquivos/demandas/ANALISE_IMPACTO_PDTIC25093-69.md`.

**`PDTIC25093-69` — Melhorias no feedback**

Três linhas, e o resumo de entrega mostra que elas se resolveram de maneira bem diferente do que a leitura do card sugeria. A análise de 2026-10-02 concluíra que **dois dos três itens já eram o comportamento especificado** e que a lacuna era só o envio por e-mail. A primeira metade estava certa; a segunda, incompleta — o envio não virou uma regra dentro de `INS-ACO-02` — Visualizar Devolutiva, virou **tela própria com tabela própria**, e o item 1 exigiu uma **remoção** que a spec descrevia ao contrário.

**Item 1 — "ver os feedbacks gerados para cada etapa"** → o que mudou não foi passar a mostrar por etapa, que já era a regra 1 de `INS-ACO-02` — Visualizar Devolutiva: foi **parar de mostrar** a etapa cuja devolutiva ainda não foi liberada. O cartão "disponível a partir de…" saiu. E a spec publicada dizia o **oposto** em três lugares: a regra 4 somada ao cenário "Consolidação concluída antes da data de liberação", que afirmava que o sistema "informa que a devolutiva ainda não está disponível e **indica a data** em que será liberada"; o campo `Liberada em`, descrito como "data em que a etapa liberou, **ou em que liberará quando ainda pendente**"; e o estado vazio, que antecipava a data prevista. Os três foram reescritos.

**Item 2 — "contextualização dos feedbacks"** → confirmado como já especificado. A seção por etapa, nomeada pela etapa e com a data da liberação, já era o comportamento descrito. Nenhum delta.

**Item 3 — "vai ser enviado por e-mail e será acessível por dentro do sistema"** → é aqui que está o volume do item, e nada disso existia. Tela nova **Disparo de Feedback**, exclusiva do Administrador Nacional, alcançada por ação no Painel de Avaliações: o administrador escolhe premiação e etapa, **confere quem vai receber antes de enviar**, e envia por ação própria — não há envio automático. O envio exige a etapa **inteiramente** encerrada (fechar um estado isolado não basta) e a devolutiva liberada; quando falta uma, o botão fica desabilitado e a tela diz qual. A seleção proposta exclui quem já recebeu ou já está na fila, a situação de cada envio é acompanhada por participante, participante sem e-mail conta como falha e uma ação própria devolve à fila só as falhas. O e-mail **avisa** e leva o link do sistema; o texto da devolutiva não vai nele.

Acompanham o item 3, do lado do participante: o botão "Ver feedbacks" no painel, oferecido só quando há devolutiva disponível (`INS-ACO-01` — Acompanhar Inscrição), e a notificação do sino levando direto à aba de Feedbacks (`INS-NOT-01` — Consultar Notificações). E, do lado da configuração, o tipo **Feedback disponível** passou a aparecer em *Termos & E-mails*, editável como os demais, com o marcador novo `{{link_sistema}}` — o que alterou `CFG-EMA-01` — Consultar Modelos de E-mail e `CFG-EMA-02` — Editar Modelo de E-mail, que diziam "quatro tipos" em onze lugares.

## Critérios de aceite

> ⚠️ Migrada sem o registro do ticket: transcreva aqui os critérios de aceite da ferramenta de origem.

## Features

| Feature (N3) | Domínio · Feature Set | Operação | Critérios cobertos | Status |
|---|---|---|---|---|
| [`AVL-APU-14`: Enviar Feedback ao Participante](../modules/avaliacao/apuracao-devolutiva/f-enviar-feedback-participante.md) | Avaliação · Apuração e Devolutiva | Criação | — | ✏️ Rascunho |
| [`INS-ACO-01`: Acompanhar Inscrição](../modules/inscricao/acompanhamento/f-acompanhar-inscricao.md) | Inscrição · Acompanhamento | Alteração | — | ✏️ Rascunho |
| [`INS-ACO-02`: Visualizar Devolutiva](../modules/inscricao/acompanhamento/f-visualizar-devolutiva.md) | Inscrição · Acompanhamento | Alteração | — | ✏️ Rascunho |
| [`INS-NOT-01`: Consultar Notificações](../modules/inscricao/notificacoes/f-consultar-notificacao.md) | Inscrição · Notificações | Alteração | — | ✏️ Rascunho |
| [`CFG-EMA-01`: Consultar Modelos de E-mail](../modules/configuracao/modelos-email/f-consultar-modelo-email.md) | Configuração da Premiação · Modelos de E-mail | Alteração | — | ✏️ Rascunho |
| [`CFG-EMA-02`: Editar Modelo de E-mail](../modules/configuracao/modelos-email/f-editar-modelo-email.md) | Configuração da Premiação · Modelos de E-mail | Alteração | — | ✏️ Rascunho |

## Artefatos impactados

| Artefato | Tipo | Operação | Seção | Natureza | O quê | Proveniência |
|---|---|---|---|---|---|---|
| `modules/avaliacao/apuracao-devolutiva/f-enviar-feedback-participante.md` | N3 | criar | — | funcional | — | migrado: relatório |
| `modules/inscricao/acompanhamento/f-acompanhar-inscricao.md` | N3 | alterar | — | funcional | — | migrado: relatório |
| `modules/inscricao/acompanhamento/f-visualizar-devolutiva.md` | N3 | alterar | — | funcional | — | migrado: relatório |
| `modules/inscricao/notificacoes/f-consultar-notificacao.md` | N3 | alterar | — | funcional | — | migrado: relatório |
| `modules/configuracao/modelos-email/f-consultar-modelo-email.md` | N3 | alterar | — | funcional | — | migrado: relatório |
| `modules/configuracao/modelos-email/f-editar-modelo-email.md` | N3 | alterar | — | funcional | — | migrado: relatório |

## Alterações na spec, por Feature Set

### Avaliação › Apuração e Devolutiva (`AVL-APU`)

| Feature | `CA-n` | Natureza | O que mudou em relação ao comportamento anterior | Regras | Cenários | PFB | PFL |
|---|---|---|---|---|---|---|---|
| `AVL-APU-14` **Enviar Feedback ao Participante** | — | incluída | **Feature incluída.** Tela própria em que o Administrador Nacional escolhe premiação e etapa, confere a relação de quem receberá o aviso, envia por ação própria e acompanha a situação de cada envio, com reenfileiramento das falhas. *Antes* a devolutiva ficava à espera de o participante voltar ao sistema e procurá-la, e nenhuma regra mandava avisá-lo — o enum `TipoEmailEnum` tinha sete valores e nenhum era devolutiva. *Agora* há aviso por e-mail, nunca automático, condicionado à etapa inteiramente encerrada e à devolutiva liberada, sem duplicidade, com o link do sistema no lugar do texto | — | — | 17 | 17 |

**Subtotal: 1 feature · 17 PFB · 17 PFL.**

### Inscrição › Acompanhamento (`INS-ACO`)

| Feature | `CA-n` | Natureza | O que mudou em relação ao comportamento anterior | Regras | Cenários | PFB | PFL |
|---|---|---|---|---|---|---|---|
| `INS-ACO-01` **Acompanhar Inscrição** | — | alterada | **Inclusão** do acesso condicionado à devolutiva. *Antes* o painel não dizia como o participante chega à devolutiva — o caminho era entrar na inscrição e procurar a aba. *Agora* o acesso é oferecido no painel **apenas** quando existe devolutiva liberada para aquela inscrição | +1 | +0 | 7 | 3,5 |
| `INS-ACO-02` **Visualizar Devolutiva** | — | alterada | **Remoção** do anúncio da etapa pendente e da marca de IA. *Antes* a tela listava **todas** as etapas avaliadas: a liberada com o texto, a pendente com o cartão "disponível a partir de…" e a data prevista — e o texto vinha com a etiqueta "Gerado por I.A.". *Agora* só a etapa já liberada aparece; a existência de devolutiva não liberada não é revelada, nem a data; o campo `Liberada em` deixou de prometer data futura; e a etiqueta de IA saiu da tela em 2026-09-23 | +1 | +0 *(2 reescritos)* | — ⚠️ | — ⚠️ |

**Subtotal: 2 features · 7 PFB · 3,5 PFL** — `INS-ACO-02` — Visualizar Devolutiva não tem processo elementar no baseline e está entre as **11 ausências a confirmar com a métrica** listadas em `global/SIZING.md`; sem PE, não há o que alterar em 50%. A lacuna é anterior a este card e segue aberta.

### Inscrição › Notificações (`INS-NOT`)

| Feature | `CA-n` | Natureza | O que mudou em relação ao comportamento anterior | Regras | Cenários | PFB | PFL |
|---|---|---|---|---|---|---|---|
| `INS-NOT-01` **Consultar Notificações** | — | alterada | **Inclusão** do destino da notificação de devolutiva. *Antes* a regra 4 dizia que o evento gera notificação e nada dizia sobre o que acontece ao abri-la. *Agora* fica fixado que ela leva direto à devolutiva da inscrição. **0 PF**: navegação entre telas não é lógica de processamento nem dado que atravesse a fronteira | +1 | +0 | 0 | 0 |

**Subtotal: 1 feature · 0 PFB · 0 PFL.**

### Configuração da Premiação › Modelos de E-mail (`CFG-EMA`)

| Feature | `CA-n` | Natureza | O que mudou em relação ao comportamento anterior | Regras | Cenários | PFB | PFL |
|---|---|---|---|---|---|---|---|
| `CFG-EMA-01` **Consultar Modelos de E-mail** | — | alterada | **Inclusão** do quinto tipo. *Antes* eram **quatro** tipos configuráveis, todos do fluxo de validação, e o N3 dizia "quatro" em sete lugares. *Agora* são cinco, com *feedback disponível*. **0 PF**: o número de tipos é quantidade de linhas de dados, não DER | +0 | +0 | 0 | 0 |
| `CFG-EMA-02` **Editar Modelo de E-mail** | — | alterada | **Inclusão** do marcador `{{link_sistema}}` e do quinto tipo editável. *Antes* eram oito marcadores e quatro tipos. *Agora* são nove e cinco — a regra 2 foi reescrita, não acrescentada. **0 PF**: o marcador é valor substituído dentro de um DER que já existe, o corpo do modelo | +0 | +0 | 0 | 0 |

**Subtotal: 2 features · 0 PFB · 0 PFL.**

**Total do item: 6 features (1 incluída, 5 alteradas) · +3 regras · +0 cenários nas alteradas · 24 PFB · 20,5 PFL de transações.** A feature nova traz, de si, 13 regras e 9 cenários.

✅ **3 processos elementares contados em 2026-10-04**, fora do baseline, no N3 criado nesta análise: `Consultar Envio de Feedback` (SE, ALR 4, DER 12, Alta, 7 PF), `Enviar Feedback da Etapa` (EE, ALR 5, DER 10, Alta, 6 PF) e `Reenfileirar Falhas de Envio` (EE, ALR 2, DER 5, Média, 4 PF). A memória de cálculo está no N3; o espelho, em `global/CONTAGEM-PF.md` → seção 1D. ⚠️ Pendente de validação pela equipe de métricas.

## Funções de dados alteradas

**Migração V00034** — script manual idempotente, controlado por `TB_MIGRACAO_MANUAL`, que não apaga nem altera dado existente.

### ALI: Auditoria de E-mails — RLR 2 → 3 · DER 20 → 36 · Média

Tabela nova **`TB_DISPARO_FEEDBACK`** (entidade *Disparo de Feedback*: premiação, etapa, UF do recorte, data, responsável e nome, quantidades de selecionados, enfileirados e sem e-mail, observação, mais os cinco campos globais de `Auditavel`; índice `IX_DISP_FEEDBACK_ETAPA`). Um registro por disparo.

Quatro colunas novas em `TB_AUDITORIA_EMAIL`, com os índices `IX_AUD_EMAIL_INSC_TIPO` e `IX_AUD_EMAIL_DISPARO`:

| Coluna nova | Tipo | Finalidade |
|---|---|---|
| `DS_TIPO_EMAIL` | `VARCHAR(50) NULL` | Tipo do e-mail enviado |
| `CD_INSCRICAO` | `INT NULL`, FK | Inscrição destinatária |
| `CD_ETAPA` | `INT NULL`, FK | Etapa a que o e-mail se refere |
| `CD_DISPARO_FEEDBACK` | `INT NULL`, FK | Disparo que gerou o e-mail |

São essas quatro colunas que tornam possível saber se um participante **já recebeu** o aviso de uma etapa — sem elas a regra que evita o envio duplicado não teria onde se sustentar. Até aqui a auditoria guardava o e-mail e não o ligava à inscrição. Os e-mails já registrados ficam com as quatro vazias.

**Sem Δ de complexidade**: RLR 3 × DER 36 segue na faixa de 20 a 50 DET, Média, **10 PF** — alterada, logo **10 PFB · 5 PFL**.

**ALI Premiação — examinado, sem alteração.** O script insere o modelo `FEEDBACK_ETAPA_DISPONIVEL` em cada premiação ativa que ainda não o tenha, e acrescenta esse valor ao enum `TipoEmailEnum` da entidade *Configuração de E-mail da Premiação*. Acrescentar valor a enum **não cria DER**: o atributo `DS_TIPO_EMAIL` já existia e já era referenciado. O ALI permanece com 9 RLR, 71 DER e 15 PF, e carga de dados não é alteração de função.

| Origem | Natureza | PFB | PFL |
|---|---|---|---|
| Funções de transação — 3 PE incluídos, 1 alterado | incluídas e alterada | 24 | 20,5 |
| Funções de dados — ALI Auditoria de E-mails | alterada | 10 | 5 |
| **Apurável do item** | — | **34** | **25,5** |

## Impacto em dicionários

**Nenhuma mensagem, regra ou campo canônico novo.** A feature nova usa o baseline de mensagens — "Carregando…", "Não foi possível carregar os dados.", "Ocorreu um erro. Tente novamente.", "Registro salvo com sucesso." e "Nenhum registro encontrado.".

O corpo do e-mail não é mensagem de dicionário: modelos de e-mail são conteúdo editável pelo Administrador Nacional, por `CFG-EMA-02` — Editar Modelo de E-mail, e vivem no banco. O que entra na spec é o **marcador** `{{link_sistema}}`, registrado na regra 2 daquela feature.

## Decisões de produto pendentes

> **As quatro decisões desta análise foram respondidas pela entrega**, e ficam registradas com a resposta porque o que foi considerado — e descartado — importa a quem audita.
>
> **1. O e-mail dispara na consolidação ou na liberação da etapa? — RESPONDIDA: em nenhuma das duas.** Não há disparo por evento: o envio é **ação do administrador**, e as duas condições que o liberam são a etapa **inteiramente** encerrada e a devolutiva liberada. A análise havia enquadrado a pergunta como escolha entre dois gatilhos automáticos, e a entrega respondeu trocando a premissa — nenhum gatilho. A preocupação que motivava a pergunta ficou atendida: como o envio exige devolutiva liberada, não se avisa sobre devolutiva que o participante ainda não pode ler.
>
> **2. O e-mail leva o texto da devolutiva ou só o aviso com o link? — RESPONDIDA: o link.** O e-mail avisa que a devolutiva da etapa está disponível e traz o endereço do sistema, pelo marcador `{{link_sistema}}`. Com isso **dissolve-se** o conflito que a análise apontou com a regra 6 de `INS-ACO-02` — Visualizar Devolutiva: se o texto permanece alterável até o fechamento do estado, um e-mail que o levasse poderia ficar desatualizado sem possibilidade de recolhimento. Levando só o link, o participante lê sempre a versão corrente. O ⚠️ da regra 6 continua de pé pelo seu próprio motivo — uma devolutiva lida antes do fechamento pode mudar depois —, mas não é mais agravado pelo e-mail.
>
> **3. O envio é regra de `INS-ACO-02` ou feature própria? — RESPONDIDA: feature própria.** `AVL-APU-14` — Enviar Feedback ao Participante, com tela própria, tabela própria (`TB_DISPARO_FEEDBACK`) e três processos elementares. A análise argumentara pelo caminho oposto, por analogia com os outros e-mails do sistema, que são efeito das features que os provocam; a entrega mostrou que aqui há **ator humano decidindo o momento**, conferindo a lista e acompanhando o resultado, o que é feature e não efeito. A consequência de contagem é a maior deste item: 17 PF que, como regra de `INS-ACO-02`, não existiriam.
>
> **4. A notificação in-app acompanha o e-mail? — RESPONDIDA: sim, e já existia.** A notificação de devolutiva disponível já era gerada — consta da regra 4 de `INS-NOT-01` — Consultar Notificações desde 2026-08-27 — e o que a sprint acrescentou foi o **destino**: abri-la leva direto à aba de Feedbacks. Nenhum valor novo foi criado nos tipos de notificação do participante. Os dois canais convivem; o e-mail é o que é novo.

**Nenhuma decisão segue pendente neste item.** Duas pendências que o alcançam são de outra natureza e estão registradas onde pertencem: a ausência de processo elementar de `INS-ACO-02` — Visualizar Devolutiva, entre as 11 ausências a confirmar com a métrica em `global/SIZING.md`; e a classificação de `TB_DISPARO_FEEDBACK` como subgrupo do ALI *Auditoria de E-mails* ou como ALI próprio, que vale 7 PF e está na seção 5 de `ANALISE_IMPACTO_SP06.md`.

## Metodologia

> Migrada de `arquivos/demandas/ANALISE_IMPACTO_PDTIC25093-69.md`.

Card lido no Jira em 2026-10-02 e confrontado, em 2026-10-04, com o **resumo de entrega da Sprint 6**, que descreve as três linhas como entregues em 2026-10-01 com a migração V00034. Cruzado com `INS-ACO-02` — Visualizar Devolutiva, `INS-ACO-01` — Acompanhar Inscrição, `INS-NOT-01` — Consultar Notificações e os N3 de `CFG-EMA`, com os fragmentos de data-model de Inscrição, Validação e Configuração (enums `TipoEmailEnum` e tipos de notificação), com o `global/SIZING.md` e com o `global/MASTER.md` (fila de e-mail em banco, sem broker). O N3 da feature nova foi escrito a partir do resumo de entrega, com preflight de ID e aprovação dos quatro validadores da instância. O "antes" de cada delta foi extraído do N3 publicado. Escopo do perfil `requisitos`: a análise para no negocial e no data-model. Este documento é o recorte por item da análise consolidada da sprint, em `ANALISE_IMPACTO_SP06.md` — os números dos dois devem sempre fechar. ⚠️ Sem acesso aos repositórios de código nesta sessão.

## Reconciliação

Aberta na entrega — migrada do relatório `arquivos/demandas/ANALISE_IMPACTO_PDTIC25093-69.md`: não houve escopo prévio a reconciliar.

## Changelog

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-05 | Contagem da SP06 (docqui) | Função de dados reclassificada | O ALI Premiação, examinado e **não** alterado pela V00034, deixa de ser título `### ALI:` em `## Funções de dados alteradas` e passa a parágrafo da mesma seção. O título o fazia entrar na planilha de contagem como função da entrega — sem natureza, com os 15 PF dele contados no PFB. A análise e os números não mudam: 10 PFB · 5 PFL de funções de dados, só a Auditoria de E-mails |
| 2026-10-04 | migra-aim | AIM migrada | relatório `arquivos/demandas/ANALISE_IMPACTO_PDTIC25093-69.md` → AIM única |
