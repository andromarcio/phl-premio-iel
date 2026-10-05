---
tipo: sprint
sprint: SP06
entrega: ""
estado: concluído
---

# AIM SP06

## Sumário

| Indicador | Valor |
|---|---|
| Funcionalidades na entrega | 5 |
| Features novas | 2 — `AVL-APU-13` Desclassificar Inscrição na Etapa · `AVL-APU-14` Enviar Feedback ao Participante |
| Features alteradas | 11 |
| Reclassificações em relação ao que a entrega declara | 2 |
| Migrações de banco | 2 — **V00034** (1 tabela nova, 4 colunas, 1 carga de dados) · **V00035** (5 colunas, 1 constraint) |
| Entidades do data-model | 61 → 62 |
| Regras de negócio acrescentadas | +21 nas features alteradas · 27 próprias das 2 novas |
| Cenários acrescentados | +6 nas features alteradas · 19 próprios das 2 novas |
| Mensagens novas no dicionário | nenhuma |
| **PFB · PFL de transações** | **88 · 65,5** |
| **PFB · PFL de funções de dados** | **20 · 10** |
| **PFB · PFL apurável da sprint** | **108 · 75,5** |
| Decisões de produto respondidas por esta entrega | 6 |
| Decisões ainda pendentes | 5 — 3 de métrica, 2 de produto |

> **Linha do tempo.** O baseline APF foi contado em **2026-02-28** e não cobre nenhuma das capacidades desta sprint. Os N3 foram escritos por engenharia reversa entre **2026-08-25 e 27** e conferidos com o código em **2026-08-28** — o "antes" de cada delta é o N3 como publicado, não o sistema em produção. A SP06 entregou em **duas ondas**: os itens 4 e 5 e a colocação no Relatório da Etapa saíram em **2026-08-28** (PRs 86452 no front e 86451 no back), em produção desde o release de **2026-09-01**; a desclassificação manual e o Disparo de Feedback saíram em **2026-10-01**. A etiqueta "Gerado por I.A." foi removida da aba de feedbacks em **2026-09-23** (PR 88452).

> **A primeira onda coincide com a conferência de código.** Os PRs da onda de 28/08 foram abertos **no mesmo dia** em que a spec foi conferida contra o código, e é isso que explica duas coisas que, vistas de longe, pareciam contradição: as features `AVL-ALO-05` — Consultar Panorama do Avaliador e `AVL-ALO-07` — Exportar Relatório de Alocação **já nasceram** daquela conferência, derivadas de um código entregue dois dias antes; e o encerramento dos cards `PDTIC25093-64` e `-65` no board, em **2026-09-24 às 16:30 e 16:31**, é varredura administrativa, não data de entrega. As análises por item de 2026-10-02 inferiram isso da diferença de 37 segundos entre os dois encerramentos; o resumo de entrega confirma.

### Classificação por item da entrega

| # | Funcionalidade | A entrega declara | Na spec docqui é | Migração |
|---|---|---|---|---|
| 1 | Fechar Etapa de Avaliação | ALTERADA | ⚠️ **Alteração + feature nova** — a colocação altera `AVL-APU-09` Exportar Relatório da Etapa, mas a desclassificação manual é capacidade sem N3: entra como `AVL-APU-13` Desclassificar Inscrição na Etapa, com efeito em `AVL-APU-01`, `-03`, `-08` e `-12` | V00035 |
| 2 | Disparo de Feedback ao Participante | NOVA | **Feature nova** `AVL-APU-14` Enviar Feedback ao Participante, mais alteração de `CFG-EMA-01` Consultar Modelos de E-mail e `CFG-EMA-02` Editar Modelo de E-mail | V00034 |
| 3 | Feedback na área do participante | ALTERADA | **Alteração** de `INS-ACO-02` Visualizar Devolutiva, `INS-ACO-01` Acompanhar Inscrição e `INS-NOT-01` Consultar Notificações | nenhuma |
| 4 | Alocação de Avaliadores | ALTERADA | ⚠️ **Funções incluídas** — `AVL-ALO-05` Consultar Panorama do Avaliador e `AVL-ALO-07` Exportar Relatório de Alocação já tinham N3 desde 2026-08-28, mas nenhuma existe no baseline: para a contagem são **incluídas**, não alteradas | nenhuma |
| 5 | Tela "Avaliações" do administrador | ALTERADA | **Alteração** de `AVL-PAI-01` Acompanhar Painel de Avaliações | nenhuma |

As duas reclassificações têm o mesmo motivo e direções opostas. No item 1, a entrega descreve uma tela que já existia e por isso a chama de alterada — mas o que ela ganhou, a desclassificação, é um processo elementar que não existia em lugar nenhum, e tratá-lo como alteração esconderia 12 PF. No item 4, a entrega chama de alteração o que, do ponto de vista da contagem, são duas funções **incluídas**: os N3 existem desde agosto porque a conferência com o código os derivou, não porque a capacidade fosse antiga.

### Itens do Jira na Sprint 6

| Item | Título no Jira | Situação no board | Alcança nesta análise |
|---|---|---|---|
| `PDTIC25093-64` | Melhoria no Relatório de Fechamento por Etapa | Done 2026-09-24 | `AVL-APU-09` **Exportar Relatório da Etapa** |
| `PDTIC25093-65` | Melhorias 25/08 | Done 2026-09-24 | `AVL-ALO-05` **Consultar Panorama do Avaliador**, `AVL-ALO-07` **Exportar Relatório de Alocação**, `AVL-PAI-01` **Acompanhar Painel de Avaliações** |
| `PDTIC25093-69` | Melhorias no feedback | ⚠️ **In Progress** em 2026-10-01 | `AVL-APU-14` **Enviar Feedback ao Participante**, `INS-ACO-02` **Visualizar Devolutiva**, `INS-ACO-01` **Acompanhar Inscrição**, `INS-NOT-01` **Consultar Notificações**, `CFG-EMA-01` **Consultar Modelos de E-mail**, `CFG-EMA-02` **Editar Modelo de E-mail** |
| `PDTIC25093-62` | Favicon | ⚠️ **In Progress** desde 2026-07-23 | nada — item sem impacto em feature ou função de dados |
| ⚠️ sem item identificado | — | — | `AVL-APU-13` **Desclassificar Inscrição na Etapa** e o seu efeito em `AVL-APU-01`, `-03`, `-08` e `-12` |

⚠️ **Dois desencontros entre o board e a entrega.** O `PDTIC25093-69` consta como *In Progress*, mas o resumo de entrega descreve as suas três linhas como **entregues em 2026-10-01** — inclusive a tela nova. E a **desclassificação manual**, que é a maior novidade funcional da sprint, **não tem item identificado** no board: é a mesma lacuna de rastreabilidade que o "Aviso 4" abriu na SP05. A contagem por sprint exige a chave da demanda ao lado de cada feature impactada; sem ela, 12 PF ficam sem origem.

## Detalhe por ticket

### 1 · Fechar Etapa de Avaliação — dois deltas em datas diferentes

**Colocação no Relatório da Etapa** (onda de 28/08) — a planilha ganhou a coluna **Colocação** nas abas por tipo de participante, **antes** da coluna Média final, gravada como número para permitir ordenação, e preenchida **apenas** para inscrições de estados já fechados: no estado aberto a célula fica vazia, porque a posição ainda pode mudar. Isso responde duas das três decisões que a análise de `PDTIC25093-64` deixou abertas em 2026-10-02 — ver *Decisões de produto pendentes*.

E corrige um erro da spec. A `## Superfície` de `AVL-APU-09` — Exportar Relatório da Etapa dizia que o relatório é acionado na **Consulta de Ranking da Etapa**; o resumo de entrega o situa na tela de **Fechamento**, e o próprio resumo explica por que o Ranking não pode ser a origem: ali a tela é somente leitura, sem ações. A origem foi corrigida no N3 e no N2 do Feature Set.

**Desclassificação manual** (onda de 01/10) — capacidade inteiramente nova, com motivação concreta: uma mesma instituição de ensino pode concorrer em vários estados, mas só pode seguir **uma vez** para a etapa nacional, e não havia como retirar a inscrição excedente do resultado de um estado.

O que a entrega traz, e que virou `AVL-APU-13` — Desclassificar Inscrição na Etapa: botão por linha do ranking na tela de Fechamento, só para o Administrador Nacional e só enquanto a etapa e o estado estão abertos; justificativa obrigatória de até 100 caracteres, visível ao apontar o selo; a inscrição sai da disputa, perde a colocação e vai ao fim do bloco, com o próximo colocado subindo e as duas linhas de corte recalculadas na hora; no fechamento, é gravada como não classificada; dispensa feedback consolidado para que o estado feche; não recebe o e-mail de feedback; a reabertura do estado ou da etapa **mantém** a desclassificação, que só a reversão desfaz; e o participante não vê nem o selo nem a justificativa.

A reversão ficou **na mesma feature**, não numa feature própria. O `engine/FEATURE-DEFINITION.md` trata par de verbos antônimos sobre um estado binário como **um** toggle — o botão é contextual, e aqui o estado é `Desclassificada ⟷ em disputa`. O verbo `desclassificar` não constava do vocabulário canônico e foi registrado em `global/VOCABULARY-OVERRIDES.md`, com justificativa, como `reabrir` e `conferir` já estavam.

### 2 · Disparo de Feedback ao Participante — funcionalidade inédita

Tela nova, exclusiva do Administrador Nacional, alcançada por ação no Painel de Avaliações. O administrador escolhe premiação e etapa, **confere a relação de quem vai receber antes de enviar**, e envia por ação própria — não há envio automático. Duas condições liberam o envio: a etapa precisa estar **inteiramente** encerrada (o fechamento de um estado isolado não basta) e a devolutiva precisa estar liberada; quando uma falha, o envio fica desabilitado e a tela diz qual. A seleção proposta exclui quem já recebeu ou já está na fila, a situação de cada envio é acompanhada por participante (enviado, aguardando, falha), participante sem e-mail conta como falha, e uma ação própria devolve à fila apenas as falhas.

O e-mail **avisa** que a devolutiva está disponível e leva o link para o sistema — **não** leva o texto da devolutiva. Isso resolve, por caminho que a análise de `PDTIC25093-69` não previra, o conflito que ela havia apontado com a regra 6 de `INS-ACO-02` — Visualizar Devolutiva: se o texto permanece alterável até o fechamento do estado, um e-mail com o texto poderia ficar desatualizado sem possibilidade de recolhimento. Levando só o link, o problema não existe.

O modelo do e-mail é configurável como os demais: o tipo **Feedback disponível** passa a aparecer em *Termos & E-mails* da premiação, com o marcador novo `{{link_sistema}}`. Isso alterou `CFG-EMA-01` — Consultar Modelos de E-mail e `CFG-EMA-02` — Editar Modelo de E-mail, que diziam "quatro tipos" em onze lugares e agora dizem cinco.

A feature se chama **Enviar Feedback ao Participante**, e não "Disparar": `envio` é nominalização bloqueada pelo `engine/FEATURE-DEFINITION.md`, que manda usar o verbo canônico `enviar`. *Disparo de Feedback* é o nome da **tela**, registrado como tal no N2.

### 3 · Feedback na área do participante — uma remoção que a spec descrevia ao contrário

O delta central é uma **remoção**: a aba de Feedbacks passa a apresentar **somente** as etapas cuja devolutiva já foi liberada, e o cartão "disponível a partir de…", que anunciava as etapas pendentes, saiu. A spec publicada descrevia o comportamento **oposto** em três lugares — a regra 4 somada ao cenário "Consolidação concluída antes da data de liberação", que dizia que o sistema "informa que a devolutiva ainda não está disponível e **indica a data** em que será liberada", o campo `Liberada em` ("ou em que liberará quando ainda pendente") e o estado vazio. Os três foram reescritos.

Acompanham: o botão "Ver feedbacks" no painel do participante, oferecido **só** quando há devolutiva disponível para aquela inscrição (altera `INS-ACO-01` — Acompanhar Inscrição); a notificação do sino levando direto à aba de Feedbacks (altera `INS-NOT-01` — Consultar Notificações); e a remoção da etiqueta "Gerado por I.A." da aba, em 2026-09-23.

### 4 · Alocação de Avaliadores — as duas features órfãs, agora com origem e colunas conferidas

A análise de `PDTIC25093-65`, de 2026-10-02, identificou este card como a origem provável de `AVL-ALO-05` — Consultar Panorama do Avaliador e `AVL-ALO-07` — Exportar Relatório de Alocação, e registrou a confirmação como decisão pendente. **O resumo de entrega confirma**: os itens 4 e 5 são "as melhorias solicitadas pela área negocial em 25/08", e `PDTIC25093-65` é *Melhorias 25/08*.

O resumo também nomeia as colunas, o que corrigiu as duas memórias de cálculo — que a engenharia reversa havia estimado por baixo. No relatório de alocação, a aba **Por estado** traz Inscrições, Com avaliador, Sem avaliador, A iniciar, Em andamento, Finalizadas e Avaliadores atuantes, com as inscrições sem UF agrupadas como *Nacional*; a aba **Por avaliador** traz Avaliador, Login, Grupo, Alocadas, A iniciar, Em andamento e Finalizadas. A coluna **Grupo** foi o achado: ela referencia o grupo competitivo, e com isso o ALR subiu de 4 para 7. No panorama, cada um dos quatro indicadores traz **quantidade e percentual**, acionar um indicador filtra a lista, o seletor de etapa mostra se ela está Aberta ou Fechada, cada grupo traz a sua quantidade e a lista tem cinco colunas — o DER foi de 14 para 22. **Nenhuma das duas correções move PF**: as duas caem na mesma célula da tabela de SE.

### 5 · Tela "Avaliações" do administrador — o filtro por etapa, completado

A análise de `PDTIC25093-65` já havia aplicado as duas restrições que o card pedia: o Administrador Regional só recebe etapas regionais, e a etapa nacional não apresenta consolidação por estado. O resumo de entrega acrescenta três detalhes que faltavam: a seleção de etapa só é habilitada **depois** da premiação, cada opção identifica a etapa por **ordem, nome e situação** (Aberta ou Fechada), e o recorte alcança **também os indicadores** do topo, não apenas a lista. Trocar ou limpar a premiação limpa a etapa. É também nesta tela que vive o acesso ao Disparo de Feedback, só para o Administrador Nacional.

## Tickets da sprint

| Ticket | AIM | Features | Resumo |
|---|---|---|---|
| `PDTIC25093-64` | [AIM-PDTIC25093-64](AIM-PDTIC25093-64.md) | `AVL-APU-09` **Exportar Relatório da Etapa** | — |
| `PDTIC25093-65` | [AIM-PDTIC25093-65](AIM-PDTIC25093-65.md) | `AVL-ALO-07` **Exportar Relatório de Alocação** · `AVL-ALO-05` **Consultar Panorama do Avaliador** · `AVL-PAI-01` **Acompanhar Painel de Avaliações** | — |
| `PDTIC25093-69` | [AIM-PDTIC25093-69](AIM-PDTIC25093-69.md) | `AVL-APU-14` **Enviar Feedback ao Participante** · `INS-ACO-01` **Acompanhar Inscrição** · `INS-ACO-02` **Visualizar Devolutiva** · `INS-NOT-01` **Consultar Notificações** · `CFG-EMA-01` **Consultar Modelos de E-mail** · `CFG-EMA-02` **Editar Modelo de E-mail** | — |

## Alterações na spec, por Feature Set

### Avaliação › Apuração e Devolutiva (`AVL-APU`)

| Feature | Ticket | Natureza | O que mudou em relação ao comportamento anterior | Regras | Cenários | PFB | PFL |
|---|---|---|---|---|---|---|---|
| `AVL-APU-13` **Desclassificar Inscrição na Etapa** | ⚠️ sem ticket | incluída | **Feature incluída.** Retirar uma inscrição da disputa de uma etapa, com justificativa obrigatória de até 100 caracteres, responsável e data, e devolvê-la enquanto o estado está aberto. A inscrição perde a colocação, vai ao fim do bloco e as duas linhas de corte são recalculadas na hora; no fechamento é gravada como não classificada; dispensa feedback consolidado; não recebe o e-mail de feedback; sobrevive à reabertura. Exclusiva do Administrador Nacional e invisível ao participante | — | — | 12 | 12 |
| `AVL-APU-14` **Enviar Feedback ao Participante** | `PDTIC25093-69` | incluída | **Feature incluída.** Tela própria em que o Administrador Nacional escolhe premiação e etapa, confere quem receberá, envia por ação própria e acompanha a situação de cada aviso, com reenfileiramento das falhas. Liberada só com a etapa inteiramente encerrada e a devolutiva liberada; sem envio automático e sem duplicidade; o aviso leva o link do sistema, não o texto da devolutiva | — | — | 17 | 17 |
| `AVL-APU-09` **Exportar Relatório da Etapa** | `PDTIC25093-64` | alterada | **Inclusão** da colocação e **correção** da origem. *Antes* a planilha era descrita sem nenhuma regra sobre colocação — ela aparecia só na descrição e num cenário, sem estar enumerada como DER —, e a origem registrada era a Consulta de Ranking da Etapa. *Agora* três regras fixam a coluna (vem do ranking sem recálculo, fica vazia em estado aberto, sai como número ordenável), uma quarta registra que a planilha reflete a desclassificação, e a origem é a tela de **Fechamento de Etapa** | +4 | +2 | 7 | 3,5 |
| `AVL-APU-01` **Apurar Resultado da Etapa** | ⚠️ sem ticket | alterada | **Inclusão** do efeito da desclassificação. *Antes* toda inscrição com avaliação finalizada entrava na disputa do bloco e recebia colocação — não havia como retirar uma do resultado. *Agora* a desclassificada sai da disputa, fica sem colocação e ao fim do bloco, e a ação recalcula na hora as colocações e as duas linhas de corte | +2 | +0 | 7 | 3,5 |
| `AVL-APU-08` **Consultar Ranking da Etapa** | ⚠️ sem ticket | alterada | **Inclusão** da marca de desclassificada e da sua justificativa no resultado. *Antes* o ranking trazia colocação, média, Coleta e os selos de classificado e premiado. *Agora* a inscrição desclassificada aparece marcada, com a justificativa, e o N3 registra que as ações de desclassificar e reverter **não** vivem aqui, porque a consulta é somente leitura | +1 | +0 | 7 | 3,5 |
| `AVL-APU-03` **Encerrar Etapa por UF** | ⚠️ sem ticket | alterada | **Restrição aliviada.** *Antes* a regra 5 exigia feedback consolidado de **todas** as inscrições do estado, sem exceção — uma inscrição retirada da disputa ainda travava o fechamento. *Agora* a desclassificada está dispensada e não gera pendência, e o fechamento a grava como não classificada seja qual fosse a sua colocação | +1 | +0 | 6 | 3 |
| `AVL-APU-12` **Reabrir Etapa por UF** | ⚠️ sem ticket | alterada | **Inclusão** do que a reabertura faz com a desclassificação. *Antes* a reabertura desfazia o fechamento e os desempates do estado e preservava o feedback consolidado; a desclassificação não existia, logo nada dizia sobre ela. *Agora* fica fixado que a reabertura a **preserva**, e que só a reversão a desfaz | +1 | +0 | 4 | 2 |

**Subtotal: 7 features · 60 PFB · 44,5 PFL.**

### Avaliação › Alocação (`AVL-ALO`)

| Feature | Ticket | Natureza | O que mudou em relação ao comportamento anterior | Regras | Cenários | PFB | PFL |
|---|---|---|---|---|---|---|---|
| `AVL-ALO-07` **Exportar Relatório de Alocação** | `PDTIC25093-65` | incluída | **Origem confirmada e enumeração corrigida.** *Antes* a memória de cálculo supunha três colunas na aba por avaliador e duas na por estado, e não via que a coluna **Grupo** referencia o grupo competitivo — ALR 4, DER 9. *Agora* as colunas das duas abas estão nomeadas uma a uma, o ALR é 7 e o DER 16, e a regra 6 registra a inscrição sem UF como *Nacional*. Mesma célula da tabela de SE: **7 PF inalterados** | +1 | +0 | 7 | 7 |
| `AVL-ALO-05` **Consultar Panorama do Avaliador** | `PDTIC25093-65` | incluída | **Origem confirmada e enumeração corrigida.** *Antes* os quatro totais eram só quantidade, o seletor de etapa não dizia a situação, a lista tinha três colunas e nada registrava o filtro por clique — DER 14. *Agora* cada total traz quantidade **e** percentual, acionar um total filtra a lista, o seletor indica Aberta ou Fechada, cada grupo mostra a sua quantidade e a lista traz cinco colunas — DER 22, **7 PF inalterados** | +2 | +0 | 7 | 7 |

**Subtotal: 2 features · 14 PFB · 14 PFL.**

### Avaliação › Painel Administrativo de Avaliações (`AVL-PAI`)

| Feature | Ticket | Natureza | O que mudou em relação ao comportamento anterior | Regras | Cenários | PFB | PFL |
|---|---|---|---|---|---|---|---|
| `AVL-PAI-01` **Acompanhar Painel de Avaliações** | `PDTIC25093-65` | alterada | **Restrição** pela natureza da etapa e **inclusão** do detalhe do filtro. *Antes* a seleção de etapa não distinguia perfil, o andamento da consolidação por estado era apurado em toda etapa — inclusive na nacional, em que a disputa não é por estado —, nada dizia que a seleção depende da premiação nem que o recorte alcança os indicadores do topo. *Agora* o Regional recebe só etapas regionais, a etapa nacional não traz consolidação por estado, cada opção identifica a etapa por ordem, nome e situação, o recorte alcança a lista **e** os indicadores, trocar a premiação limpa a etapa, e o acesso ao envio do feedback vive aqui, só para o Nacional | +6 | +4 | 7 | 3,5 |

**Subtotal: 1 feature · 7 PFB · 3,5 PFL.**

### Inscrição › Acompanhamento (`INS-ACO`)

| Feature | Ticket | Natureza | O que mudou em relação ao comportamento anterior | Regras | Cenários | PFB | PFL |
|---|---|---|---|---|---|---|---|
| `INS-ACO-01` **Acompanhar Inscrição** | `PDTIC25093-69` | alterada | **Inclusão** do acesso condicionado à devolutiva. *Antes* o painel não dizia como o participante chega à devolutiva — o caminho era entrar na inscrição e procurar a aba. *Agora* o acesso é oferecido no painel **apenas** quando existe devolutiva liberada para aquela inscrição | +1 | +0 | 7 | 3,5 |
| `INS-ACO-02` **Visualizar Devolutiva** | `PDTIC25093-69` | alterada | **Remoção** do anúncio da etapa pendente e da marca de IA. *Antes* a tela listava **todas** as etapas avaliadas: a liberada com o texto, a pendente com o cartão "disponível a partir de…" e a data prevista — e o texto vinha com a etiqueta "Gerado por I.A.". *Agora* só a etapa já liberada aparece; a existência de devolutiva não liberada não é revelada, nem a data; e a etiqueta de IA saiu da tela | +1 | +0 | — ⚠️ | — ⚠️ |

**Subtotal: 2 features · 7 PFB · 3,5 PFL** — `INS-ACO-02` — Visualizar Devolutiva não tem processo elementar no baseline e está entre as **11 ausências a confirmar com a métrica** listadas em `global/SIZING.md`; sem PE, não há o que alterar em 50%.

### Inscrição › Notificações (`INS-NOT`)

| Feature | Ticket | Natureza | O que mudou em relação ao comportamento anterior | Regras | Cenários | PFB | PFL |
|---|---|---|---|---|---|---|---|
| `INS-NOT-01` **Consultar Notificações** | `PDTIC25093-69` | alterada | **Inclusão** do destino da notificação de devolutiva. *Antes* a regra 4 dizia que o evento gera notificação e nada dizia sobre o que acontece ao abri-la. *Agora* fica fixado que ela leva direto à devolutiva da inscrição. **0 PF**: navegação entre telas não é lógica de processamento nem dado que atravesse a fronteira — o processo elementar é o mesmo | +1 | +0 | 0 | 0 |

**Subtotal: 1 feature · 0 PFB · 0 PFL.**

### Configuração da Premiação › Modelos de E-mail (`CFG-EMA`)

| Feature | Ticket | Natureza | O que mudou em relação ao comportamento anterior | Regras | Cenários | PFB | PFL |
|---|---|---|---|---|---|---|---|
| `CFG-EMA-01` **Consultar Modelos de E-mail** | `PDTIC25093-69` | alterada | **Inclusão** do quinto tipo. *Antes* eram **quatro** tipos configuráveis, todos do fluxo de validação, e o N3 dizia "quatro" em sete lugares. *Agora* são cinco, com *feedback disponível*. **0 PF**: o número de tipos é quantidade de linhas de dados, não DER — o processo elementar é o mesmo | +0 | +0 | 0 | 0 |
| `CFG-EMA-02` **Editar Modelo de E-mail** | `PDTIC25093-69` | alterada | **Inclusão** do marcador `{{link_sistema}}` e do quinto tipo editável. *Antes* eram oito marcadores e quatro tipos. *Agora* são nove e cinco — a regra 2 foi **reescrita**, não acrescentada, e por isso a contagem de regras não se move. **0 PF**: o marcador é valor substituído dentro de um DER que já existe, o corpo do modelo | +0 | +0 | 0 | 0 |

**Subtotal: 2 features · 0 PFB · 0 PFL.**

### Total

| Feature Set | Features | PFB | PFL |
|---|---|---|---|
| `AVL-APU` — Apuração e Devolutiva | 7 | 60 | 44,5 |
| `AVL-ALO` — Alocação | 2 | 14 | 14 |
| `AVL-PAI` — Painel Administrativo de Avaliações | 1 | 7 | 3,5 |
| `INS-ACO` — Acompanhamento | 2 | 7 | 3,5 |
| `INS-NOT` — Notificações | 1 | 0 | 0 |
| `CFG-EMA` — Modelos de E-mail | 2 | 0 | 0 |
| **Transações da sprint** | **15** | **88** | **65,5** |

**Total: 15 features (2 incluídas novas, 2 incluídas já especificadas, 11 alteradas) · +21 regras · +6 cenários nas alteradas · 88 PFB · 65,5 PFL de transações.** As duas features novas trazem, de si, 27 regras e 19 cenários — contados à parte porque não são acréscimo a texto anterior. Os números desta linha foram medidos por script, comparando cada N3 com a sua versão anterior à primeira análise da sprint, não contados à mão.

✅ **5 processos elementares contados em 2026-10-04**, todos fora do baseline, nos dois N3 criados nesta análise: `Desclassificar Inscrição na Etapa` (EE 4×8, Alta, 6 PF), `Reverter Desclassificação da Inscrição` (EE 3×6, Alta, 6 PF), `Consultar Envio de Feedback` (SE 4×12, Alta, 7 PF), `Enviar Feedback da Etapa` (EE 5×10, Alta, 6 PF) e `Reenfileirar Falhas de Envio` (EE 2×5, Média, 4 PF). As memórias de cálculo estão nos N3; o espelho, em `global/CONTAGEM-PF.md` → seção 1D. ⚠️ Pendente de validação pela equipe de métricas.

### Examinadas sem alteração

`AVL-APU-02` — Registrar Desempate, `AVL-APU-04` — Gerar Devolutiva com IA, `AVL-APU-05` — Revisar Devolutiva e `AVL-PAI-03` — Consolidar Avaliação foram confrontadas com a entrega e não mudam. A desclassificação não toca o desempate (a inscrição sai da disputa antes de disputar a linha de corte, e o empate que ela deixaria de causar é efeito da reapuração, não regra nova), e a remoção da etiqueta "Gerado por I.A." é da tela do participante — `AVL-APU-04`, que **produz** a devolutiva com apoio de IA, segue registrando `FL_FEEDBACK_GERADO_POR_IA` como antes.

## Funções de dados alteradas

As duas migrações são scripts manuais, executados uma única vez por ambiente: cada uma registra o próprio nome em `TB_MIGRACAO_MANUAL` e aborta se já tiver sido aplicada. Nenhuma apaga nem altera dado existente — os registros anteriores recebem os valores padrão.

### V00035 → ALI: Avaliação de Inscrição — RLR 3 · DER 38 → 43 · Média

Tabela alterada: `TB_APROVACAO_ETAPA_PARTICIPANTE`, que é a entidade **Apuração por Etapa**, subgrupo deste ALI. Nenhuma tabela nova.

| Coluna nova | Tipo | Finalidade |
|---|---|---|
| `FL_DESCLASSIFICADO` | `BIT NOT NULL`, padrão `0` | Marca a inscrição como desclassificada na etapa |
| `DS_JUSTIFICATIVA_DESCLASSIFICACAO` | `NVARCHAR(100) NULL` | Justificativa informada pelo administrador |
| `DT_DESCLASSIFICACAO` | `DATETIME2 NULL` | Data e hora da desclassificação |
| `CD_USUARIO_DESCLASSIFICACAO` | `BIGINT NULL` | Código de quem desclassificou |
| `NM_USUARIO_DESCLASSIFICACAO` | `NVARCHAR(200) NULL` | Nome de quem desclassificou |

Restrição nova `CK_APROV_ETAPA_PART_DESCLASSIF`: impede gravar a inscrição como desclassificada sem justificativa. É a regra 3 de `AVL-APU-13` — Desclassificar Inscrição na Etapa garantida no banco, não só na aplicação — raro nesta base e digno de nota, porque o `global/CONFORMIDADE-CODIGO.md` registra o padrão oposto, de regras que vivem só no frontend.

**Sem Δ PF**: RLR 3 × DER 43 segue na faixa de 20 a 50 DET, Média, **10 PF**.

### V00034 → ALI: Auditoria de E-mails — RLR 2 → 3 · DER 20 → 36 · Média

Tabela nova `TB_DISPARO_FEEDBACK` (entidade **Disparo de Feedback**, 11 atributos mais os cinco campos globais de `Auditavel`, índice `IX_DISP_FEEDBACK_ETAPA`) e quatro colunas de ligação em `TB_AUDITORIA_EMAIL`:

| Coluna nova | Tipo | Finalidade |
|---|---|---|
| `DS_TIPO_EMAIL` | `VARCHAR(50) NULL` | Tipo do e-mail enviado |
| `CD_INSCRICAO` | `INT NULL`, FK | Inscrição destinatária |
| `CD_ETAPA` | `INT NULL`, FK | Etapa a que o e-mail se refere |
| `CD_DISPARO_FEEDBACK` | `INT NULL`, FK | Disparo que gerou o e-mail |

Índices novos `IX_AUD_EMAIL_INSC_TIPO` e `IX_AUD_EMAIL_DISPARO`. As quatro colunas são o que torna possível saber se um participante já recebeu o aviso de uma etapa — é delas que vive a regra 6 de `AVL-APU-14` — Enviar Feedback ao Participante. Até aqui a auditoria guardava o e-mail e não o ligava à inscrição.

**Sem Δ PF**: RLR 3 × DER 36 segue na faixa de 20 a 50 DET, Média, **10 PF**.

**V00034 → ALI Premiação — examinado, sem alteração.** O script insere o modelo `FEEDBACK_ETAPA_DISPONIVEL` em cada premiação ativa que ainda não o tenha, e acrescenta esse valor ao enum `TipoEmailEnum` da entidade **Configuração de E-mail da Premiação**. Acrescentar valor a um enum **não cria DER**: o atributo `DS_TIPO_EMAIL` já existia e já era referenciado. O ALI permanece com 9 RLR, 71 DER e **15 PF**, e a carga de dados não é alteração de função.

### Funções de dados da sprint

| Função de dados | Natureza da função | PFB | PFL |
|---|---|---|---|
| Avaliação de Inscrição | alterada | 10 | 5 |
| Auditoria de E-mails | alterada | 10 | 5 |

## Apurável da sprint

| | PFB | PFL |
|---|---|---|
| Transações — 15 features, 5 PE incluídos e 7 alterados | 88 | 65,5 |
| Funções de dados — 2 ALIs alterados | 20 | 10 |
| **Total** | **108** | **75,5** |

Nenhum ticket da SP06 tem contagem estimada — as três AIMs foram abertas na entrega —, por isso não há as linhas Estimado e Diferença.

Os 29 PF dos cinco processos elementares novos entram **integralmente** no PFL, por serem funções incluídas; os sete processos elementares alterados entram a 50%. As três features alteradas sem Δ de contagem — `INS-NOT-01` — Consultar Notificações, `CFG-EMA-01` — Consultar Modelos de E-mail e `CFG-EMA-02` — Editar Modelo de E-mail — aparecem em *Alterações na spec, por Feature Set* com zero, e o motivo está em cada linha: navegação e quantidade de linhas de dados não são alteração funcional.

⚠️ **Dois números do apurável podem cair**, e as duas perguntas são da métrica: se a alternância da desclassificação for um processo elementar só, o apurável vai a **102 PFB · 69,5 PFL**; se `AVL-APU-09` — Exportar Relatório da Etapa pertencer ao mesmo período de medição de `PDTIC25093-49`, que a contou integralmente na SP05, saem outros 3,5 PFL. Ver *Decisões de produto pendentes*.

## Impacto em dicionários

**Nenhuma mensagem, regra ou campo canônico novo.** As duas features novas usam o baseline de mensagens — "Campo obrigatório.", "Registro salvo com sucesso.", "Ocorreu um erro. Tente novamente.", "Nenhum registro encontrado." e "Você não tem permissão para esta ação." —, com uma exceção a conferir: *"Máximo de 100 caracteres."*, usada na validação da justificativa. ⚠️ Confirmar se o `global/MESSAGE-DICTIONARY.md` já traz a mensagem de limite de tamanho com o número parametrizado; se traz, a citação é por referência e nada entra.

**Uma entrada nova em `global/VOCABULARY-OVERRIDES.md`**: o verbo `desclassificar`, com a justificativa de ser ato administrativo próprio da premiação — distinto de `rejeitar` (decisão de validação, anterior à avaliação) e de `excluir` (nada é removido). É a terceira linha daquele arquivo, ao lado de `reabrir` e `conferir`.

**Nenhum código de erro novo.** O `global/ERROR-DICTIONARY.md` segue sem contrapartida no código, como o `MASTER.md` registra.

## Metodologia

Cruzamento do resumo de entrega da Sprint 6 — recebido em 2026-10-04, com as duas migrações, as telas, as regras e os arquivos de código de cada item — com os N3 publicados dos seis Feature Sets alcançados, o `global/DATA-MODEL.md` e os fragmentos de Avaliação, Validação e Configuração, o `global/CONTAGEM-PF.md`, o `global/SIZING.md`, o `engine/FEATURE-DEFINITION.md` (granularidade e vocabulário) e as quatro análises por item de 2026-10-02 (`PDTIC25093-62`, `-64`, `-65`, `-69`), que esta consolida. O "antes" de cada delta foi extraído do N3 publicado e do seu `## Changelog`, não do sistema em produção. Os dois N3 novos foram escritos a partir do resumo de entrega, com preflight de ID (`scripts/preflight-spec.mjs`) e aprovação dos quatro validadores da instância. Escopo do perfil `requisitos`: a análise para no negocial e no data-model. ⚠️ Os repositórios de código não estão ao alcance desta sessão — os nomes de componente, controller e serviço citados no resumo não foram verificados, e a rota da tela de Disparo de Feedback está registrada com ⚠️ *a conferir*.

## Decisões de produto pendentes

> **Seis decisões saíram desta lista com a entrega**, e ficam registradas aqui porque o que foi considerado importa a quem audita. De `PDTIC25093-64`: o Relatório da Etapa é acionado na tela de **Fechamento**, não na de Ranking — a origem da spec estava errada e foi corrigida; e a colocação **só** é preenchida para estados fechados, ficando vazia no estado aberto. De `PDTIC25093-69`: o aviso **não** é automático, sai por ação do Administrador Nacional, com etapa inteiramente encerrada e devolutiva liberada; o e-mail leva o **link**, não o texto, o que dissolve o conflito com a regra 6 de `INS-ACO-02` — Visualizar Devolutiva; o envio é **feature própria** com tela e tabela próprias, não uma regra de `INS-ACO-02`; e a notificação in-app continua existindo ao lado do e-mail, levando à aba de Feedbacks. De `PDTIC25093-65`: está **confirmado** que o card é a origem de `AVL-ALO-05` — Consultar Panorama do Avaliador e `AVL-ALO-07` — Exportar Relatório de Alocação.

### 1. A alternância da desclassificação é um processo elementar ou dois?

**O que foi contado** — **dois**: `Desclassificar Inscrição na Etapa` (EE, ALR 4, DER 8, Alta, 6 PF) e `Reverter Desclassificação da Inscrição` (EE, ALR 3, DER 6, Alta, 6 PF).

**Onde está a dúvida** — o `engine/FEATURE-DEFINITION.md` trata o par antônimo sobre estado binário como **uma feature**, e é assim que a feature está escrita. Para a **contagem**, o critério é outro: a lógica de processamento e os dados que atravessam a fronteira diferem entre as duas direções — a desclassificação valida e grava justificativa obrigatória, responsável e data; a reversão não recebe justificativa e apaga os três. É isso que separa este par do caso clássico de *toggle* contado como um PE só, `CFG-CAT-05` — Ativar/Inativar Categoria, em que as duas direções movem o mesmo campo com os mesmos dados.

**O que muda com cada resposta** — dois PE, a feature vale 12 PF e a sprint apura 108 PFB · 75,5 PFL. Um PE, a feature vale **6 PF** e a sprint apura **102 PFB · 69,5 PFL**.

**Decide** — equipe de métricas. **Alcança** — `AVL-APU-13` — Desclassificar Inscrição na Etapa.

### 2. O Disparo de Feedback é ALI próprio ou subgrupo da Auditoria de E-mails?

**O que foi adotado** — **subgrupo** do ALI *Auditoria de E-mails*, porque o dado que `TB_DISPARO_FEEDBACK` guarda é o lote dos e-mails enviados e a ligação é direta, por `TB_AUDITORIA_EMAIL.CD_DISPARO_FEEDBACK`. É a opção conservadora: não cria função de dados nova.

**Onde está a dúvida** — a leitura alternativa é defensável: o disparo é mantido por transação própria, tem identidade de negócio (quem disparou, quando, para quantos) e é consultado como registro de negócio, enquanto o data-model descreve `TB_AUDITORIA_EMAIL` como "log próprio". Um registro de ação administrativa não é naturalmente subgrupo de um log técnico.

**O que muda com cada resposta** — como subgrupo, **0 PF** de função de dados nova e o ALI segue Média com 10 PF. Como ALI próprio, RLR 1 × DER 11, Baixa, **+7 PFB · +7 PFL**, e o ALR de `Consultar Envio de Feedback` e de `Enviar Feedback da Etapa` sobe em 1 — sem mover a complexidade de nenhum dos dois.

**Decide** — equipe de métricas. **Alcança** — ALI Auditoria de E-mails e `AVL-APU-14` — Enviar Feedback ao Participante.

### 3. `PDTIC25093-49` e `PDTIC25093-64` estão no mesmo período de medição?

**O que trava** — 3,5 PFL. `AVL-APU-09` — Exportar Relatório da Etapa entrou como **incluída** em `PDTIC25093-49`, na SP05, valendo 7 PFB · 7 PFL; aqui ela é **alterada** e vale 3,5 PFL. Se a métrica concluir que os dois itens pertencem ao mesmo período, a função conta uma vez e estes 3,5 PFL são dedução. A pergunta vinha aberta desde 2026-10-02 e segue aberta.

**Decide** — equipe de métricas. **Alcança** — `AVL-APU-09` — Exportar Relatório da Etapa.

### 4. A desclassificação precisa de trilha?

**Onde está a dúvida** — a reversão **apaga** o registro da desclassificação: justificativa, data e responsável. Depois dela, não resta rastro de que a inscrição esteve fora da disputa, nem de quem a retirou. É a mesma consequência que o fechamento por UF já aceita na sua regra 11, e foi aceita lá explicitamente em 2026-09-01.

**O que trava** — a especificação de `AVL-APU-13` — Desclassificar Inscrição na Etapa e, se a resposta for que a trilha é necessária, uma alteração de modelo: hoje não há onde gravá-la, porque as cinco colunas da V00035 guardam **o estado atual**, não o histórico. O N0 lista a auditabilidade das ações críticas entre os princípios de experiência, e retirar um concorrente do resultado é ação crítica.

**Decide** — produto. **Alcança** — `AVL-APU-13` — Desclassificar Inscrição na Etapa e o data-model de Avaliação.

### 5. Quem é a demanda de origem da desclassificação manual?

**O que trava** — a rastreabilidade de 12 PF e, com ela, a contagem por sprint, que exige a chave da demanda ao lado de cada feature impactada. Nenhum dos quatro cards analisados em 2026-10-02 pede a desclassificação, e o resumo de entrega não cita item do Jira para ela. É a terceira vez que o padrão se repete nesta base: o "Aviso 4" da SP05 deixou `AVL-PAI-01` — Acompanhar Painel de Avaliações e `AVL-PAI-04` — Exportar Relatório de Avaliadores sem item, e `PDTIC25093-65` só foi ligado às duas features de alocação por correspondência de texto.

**Decide** — produto, com conferência no board. **Alcança** — `AVL-APU-13` — Desclassificar Inscrição na Etapa e as quatro features de `AVL-APU` que ela alcança.

## Changelog

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-05 | Contagem da SP06 (docqui) | Função de dados reclassificada | O ALI Premiação, examinado e não alterado, sai da tabela das funções de dados da sprint e deixa de ser título `### ALI:` — os dois o levavam à planilha de contagem como função da entrega. Fica o parágrafo que explica por que a carga de dados da V00034 não o altera. Números inalterados: 20 PFB · 10 PFL de funções de dados, 108 PFB · 75,5 PFL no apurável |
| 2026-10-05 | Especificação Funcional SP06 (docqui) | Estrutura conformada | AIM da sprint posta no formato do template 4.1.0, sem mudar número: a tabela das funções de dados passa a ter as colunas do template e o nome da função sem o prefixo "ALI" — que impedia o `validate-impact` de casá-la com o `### ALI:` das AIMs dos tickets —, a linha de total sai dela, e o antigo *Fechamento do dimensionamento* vira a seção `## Apurável da sprint`. As remissões à numeração do relatório anterior à migração ("seção 2", "seção 5") passam a citar as seções pelo nome |
| 2026-10-04 | migra-aim | AIM da sprint migrada | relatório agregado `arquivos/demandas/ANALISE_IMPACTO_SP06.md` → AIM da sprint |
