<!-- docqui: análise de impacto | fonte: ANALISE_SP05_novas_vs_alteradas.md | gerado: 2026-08-27 -->
# Relatório de Impacto — Sprint 5 sobre a especificação do Prêmio IEL

---

## Sumário executivo

**O que a SP05 move.** No modelo, seis alterações — uma tabela nova e cinco colunas — que tocam três ALIs e valem **40 PFB — 20 PFL** pela regra de 50% da função alterada. Fora do modelo, onde está o grosso do trabalho: o **comportamento dos N3** (escritos por engenharia reversa das HUs anteriores à sprint) e as **permissões (N2)**. E vários itens que a demanda classifica como "NOVA" são, na spec, **alteração de feature já existente** — porque "novo para o negócio" (primeiro envio à área negocial) não é "novo para a spec".

> **Premissa desta análise.** O modelo físico disponível (`arquivos/modelo_dados.sql`) é um retrato **posterior** à sprint, então as colunas e a tabela listadas na seção 3 (tabelas por função de dados) já aparecem nele. Esta análise as trata como **alterações a realizar**, que é a leitura correta para dimensionar a evolução: o baseline APF é **anterior** à SP05, e é contra ele que o delta se mede. Não foi possível confirmar por comparação que a lista está completa — não há SQL anterior à sprint disponível; ela reproduz o que as migrações V00030 a V00033 declaram.

| Indicador | Valor |
|---|---|
| Features existentes que mudam de comportamento | 15 |
| Features novas a criar | 7 (+1 opcional) |
| N2 com matriz de permissões a ajustar | 3 |
| Alterações de modelo a realizar | 6 — 1 tabela + 5 colunas |
| PF de funções de dados na evolução | 40 (CHGA) |
| **PF apurável da sprint** | **202 PFB · 136,5 PFL** — sem estimativa desde 2026-09-01 |
| Decisões de produto pendentes | nenhuma — as 11 foram respondidas em 2026-09-01 |
| Itens do Jira na Sprint 5 | 8 — todos mapeados, 2 features sem item identificado |

### Classificação por item da demanda

| Item | Jira | Demanda diz | Na spec docqui é |
|---|---|---|---|
| HU-024 Configurar Etapas | `PDTIC25093-67` | ALTERADA | Alteração de `AVL-ETA-02` **Cadastrar Etapa** e `AVL-ETA-03` **Editar Etapa** (campos classificados/premiados) |
| HU-030 Fechar Etapa | `PDTIC25093-49` | NOVA (1º envio) | **Alteração** de `AVL-APU-01/02/03` + `AVL-PAI-03` **Consolidar Avaliação** + 2 features novas (Reabrir Etapa por UF, Exportar Relatório da Etapa) |
| HU-036 Relatório Geral | `PDTIC25093-56` | NOVA | Feature nova `AVL-APU-10` **Gerar Relatório de Inscrições** (tela e planilha) + restrição de permissão em `AVL-APU-06` **Gerar Relatório de Inscrições Paradas** |
| HU-036 Relatório do dashboard | `PDTIC25093-58` | sem documento | Alteração de `VAL-FIL-02` **Acompanhar Painel de Validação** — a exportação do histórico, que não estava especificada |
| HU-038 Ranking por Etapa | `PDTIC25093-66` | NOVA | Feature nova `AVL-APU-08` **Consultar Ranking da Etapa** (irmã somente-leitura do Fechamento) |
| HU-018 Validar Inscrições | `PDTIC25093-68` | ALTERADA | Alteração de `VAL-ANA-01` **Detalhar Inscrição** + 1 feature nova (`VAL-ANA-05` **Editar Inscrição Validada**) |
| HU-025 Alocação | `PDTIC25093-60` | sem documento | Alteração de `AVL-ALO-04` **Alocar Avaliador à Inscrição** — detalhe do projeto e recortes |
| HU-028 Avaliação | `PDTIC25093-61` | sem documento | Alteração de `AVL-AVA-01`, `AVL-AVA-03` e `AVL-AVA-04` — fila de pendentes, download por link e salto "Próxima pendente" |
| Avisos 4 | ⚠️ sem item identificado | sem documento | Altera `AVL-PAI-01` **Acompanhar Painel de Avaliações** + nova `AVL-PAI-04` **Exportar Relatório de Avaliadores** |

### Itens da sprint no Jira

Os oito itens do board `PDTIC25093` na Sprint 5, com o que cada um alcança nesta análise. O título do item costuma nomear a HU — é o elo entre a ferramenta e a spec.

| Item | Título no Jira | HU | Alcança nesta análise |
|---|---|---|---|
| `PDTIC25093-49` | Fechamento da Etapa de Avaliação | HU-030 | `AVL-APU-01` **Apurar Resultado da Etapa**, `AVL-APU-02` **Registrar Desempate**, `AVL-APU-03` **Encerrar Etapa por UF**, `AVL-PAI-03` **Consolidar Avaliação** + novas `AVL-APU-12` **Reabrir Etapa por UF**, `AVL-APU-09` **Exportar Relatório da Etapa** |
| `PDTIC25093-56` | Relatório de inscrições | HU-036 | nova `AVL-APU-10` **Gerar Relatório de Inscrições** + restrição em `AVL-APU-06` **Gerar Relatório de Inscrições Paradas** e ponto de entrada em `VAL-FIL-01` **Pesquisar Inscrições para Validação** |
| `PDTIC25093-58` | Alteração no relatório do dashboard | HU-036 | `VAL-FIL-02` **Acompanhar Painel de Validação** + nova `VAL-FIL-03` **Exportar Histórico do Painel de Validação** |
| `PDTIC25093-60` | Melhorias na alocação | HU-025 | `AVL-ALO-04` **Alocar Avaliador à Inscrição** |
| `PDTIC25093-61` | Melhorias na Avaliação | HU-028 | `AVL-AVA-01`, `AVL-AVA-03`, `AVL-AVA-04` |
| `PDTIC25093-66` | Ranking por Etapa | HU-038 | nova `AVL-APU-08` **Consultar Ranking da Etapa** |
| `PDTIC25093-67` | Melhorias na configuração | HU-024 | `AVL-ETA-02` **Cadastrar Etapa**, `AVL-ETA-03` **Editar Etapa** |
| `PDTIC25093-68` | Melhorias na Validação de Inscrições | HU-018 | `VAL-ANA-01` **Detalhar Inscrição** + nova `VAL-ANA-05` **Editar Inscrição Validada** |

⚠️ **Duas features desta análise não têm item identificado nesta lista**: `AVL-PAI-01` **Acompanhar Painel de Avaliações** e `AVL-PAI-04` **Exportar Relatório de Avaliadores**, ambas vindas do Aviso 4 (consolidação administrativa por estado), que chegou sem documento. Ou o item existe no board e não apareceu no recorte consultado, ou a entrega foi absorvida por outro item — confirmar antes de fechar a contagem, porque as duas somam **14 PFB** e **10,5 PFL**.

---

## 1. Detalhe por item da demanda

### `PDTIC25093-67` · HU-024 — Configurar Etapas de Avaliação (alteração)

Na spec: alteração pura de `AVL-ETA-02` e `AVL-ETA-03` (editor compartilhado). Nenhuma feature nova. O data-model já tem os dois campos — a spec negocial é que está atrás. Delta: Quantidade de classificados (obrigatório, mín. 1, padrão 1) e Quantidade de premiados (opcional; vazio = não premia); selos "Classificados/Premiados" no cartão da etapa; bloqueio de edição do corte com a etapa fechada; abrangência do corte derivada dos perfis autorizados.

### `PDTIC25093-49` · HU-030 — Fechar Etapa de Avaliação (alteração + novas)

Na spec: mistura com forte predominância de alteração — o cluster de fechamento já existe (`AVL-APU-01/02/03`, `AVL-PAI-03`) e o data-model já foi capturado. Genuinamente novo: Reabrir Etapa por UF e Exportar Relatório da Etapa. Delta nos N3 existentes: corte de classificação automático; ranking em baldes estado→grupo; premiação como corte independente; novos KPIs; desempate por corte com justificativa 30–1000; fechamento por estado exige feedback consolidado; trava de consolidação; encerramento automático no último estado. Conflito confirmado: o temido "aprovar/reprovar manual" não está nos N3 (já são automáticos), mas a RN4 de `AVL-APU-03` ("as premiadas avançam") contradiz a SP05 — corrigir.

### `PDTIC25093-56` · HU-036 — Relatório Geral de Inscrições (nova)

Na spec: feature nova em `AVL-APU` (par Gerar/Exportar), mais alteração de permissão no par gêmeo de Paradas e um botão em `VAL-FIL-01`. Delta: consolida todas as inscrições em qualquer situação (difere de Paradas = só em andamento); abas por tipo de participante, colunas fixas + uma por pergunta do formulário; prévia de 50/grupo em tela + XLSX completo; exclusivo do Admin Nacional.

### `PDTIC25093-66` · HU-038 — Ranking por Etapa (nova)

Na spec: feature nova em `AVL-APU` — a irmã somente-leitura da tela de Fechamento. Compartilha `ranking-baldes` e `RelatorioEtapaService`, sem ações de fechar/reabrir/arbitrar. Delta: consulta do resultado consolidado (estado→grupo) com selos "Fechada/Parcial", deep-link e escopo de UF para o Regional; para etapa encerrada, exibe o resultado gravado no fechamento — não um recálculo.

### `PDTIC25093-68` · `-60` · `-61` — Validar Inscrições + tela do avaliador/alocação (alteração + nova)

Três itens do Jira cobrem este bloco: `PDTIC25093-68` (HU-018, validação), `PDTIC25093-60` (HU-025, alocação) e `PDTIC25093-61` (HU-028, avaliação). A demanda os tratava como um item só porque compartilham o mecanismo de download por endereço individual.

Na spec: mistura — download por UUID e "próxima pendente"/drawer alteram N3 existentes; a edição administrativa da inscrição validada é feature nova, `VAL-ANA-05` **Editar Inscrição Validada**, especificada em 2026-08-28 mas ainda sem contagem. Delta: máscara de CPF/telefone no membro e inclusão do 1º membro na edição admin (carrega a config de equipe); download seguro por UUID (habilita também o avaliador); "Próxima pendente" na tela do avaliador; drawer "Projeto" + filtros na alocação. O aviso 7 (rota quebrada do widget de pendências) é bug técnico, sem N3-alvo.

### `PDTIC25093-58` + ⚠️ sem item — Avisos 4–6: consolidação admin, restrição de relatórios, colunas do Excel (alteração + nova)

Na spec: filtros/consolidação por estado alteram `AVL-PAI-01`; o Relatório de Avaliadores é novo (`AVL-PAI-04`); a restrição de permissão e as colunas incidem sobre um export de dashboard que não está especificado. Delta: tela "Avaliações" ganha filtro por UF, visão de consolidação por estado e o novo Relatório de Avaliadores (XLSX, 2 abas); botões "Inscrições Paradas" e "Exportar Excel" restritos ao Admin Nacional; colunas "Nome do Participante" e "Telefone" no Excel de histórico.

---

## 2. Alterações aplicadas na spec, por Feature Set

### Avaliação › Etapas e Configuração da Avaliação (`AVL-ETA`)

| Feature | Item do Jira | Natureza | O que mudou em relação ao comportamento anterior | Regras | Cenários | PFB | PFL |
|---|---|---|---|---|---|---|---|
| `AVL-ETA-02` **Cadastrar Etapa** | `PDTIC25093-67` | alterada | **Inclusão** dos campos *Quantidade de classificados* (obrigatório, mínimo 1) e *Quantidade de premiados* (opcional). Antes o editor capturava apenas nome, período e perfis autorizados — quantos participantes avançam de etapa não era informado em lugar nenhum | +4 | +4 | 3 | 1,5 |
| `AVL-ETA-03` **Editar Etapa** | `PDTIC25093-67` | alterada | **Inclusão** dos mesmos dois campos em edição, **restrição** do corte enquanto a etapa está fechada e **inclusão** dos selos "Classificados" e "Premiados" no cartão. Antes a edição alcançava nome, período e perfis, e a etapa fechada recusava qualquer alteração em bloco | +8 | +6 | 3 | 1,5 |

Mensagens acrescentadas ao dicionário: `AVL_ETAPA_CLASSIFICADOS_INVALIDO`, `AVL_ETAPA_PREMIADOS_INVALIDO`, `AVL_ETAPA_CORTE_BLOQUEADO`. **Subtotal: 2 features · 6 PFB · 3 PFL.**

### Avaliação › Apuração e Devolutiva (`AVL-APU`)

| Feature | Item do Jira | Natureza | O que mudou em relação ao comportamento anterior | Regras | Cenários | PFB | PFL |
|---|---|---|---|---|---|---|---|
| `AVL-APU-01` **Apurar Resultado da Etapa** | `PDTIC25093-49` | alterada | **Alteração** do agrupamento do ranking e **inclusão** do corte automático. Antes as inscrições competiam por grupo de oferta × enquadramento e a classificação era apenas a ordem por média — nada marcava quem passava. Agora o ranking é em blocos estado→grupo com colocação por bloco, o corte de classificação é aplicado automaticamente pela quantidade definida na etapa e existe um corte de premiação independente dele; as inscrições sem estado formam o bloco Nacional | +10 | +10 | 7 | 7 |
| `AVL-APU-02` **Registrar Desempate** | `PDTIC25093-49` | alterada | **Alteração** do escopo do desempate. Antes qualquer empate dentro do grupo exigia decisão manual, com um único tipo de corte (Classificação) e justificativa de tamanho livre. Agora só o empate que atravessa a linha de corte precisa de decisão, o corte pode ser de classificação ou de premiação, a comparação é questão a questão e a justificativa tem de 30 a 1.000 caracteres | +8 | +7 | 6 | 6 |
| `AVL-APU-03` **Encerrar Etapa por UF** | `PDTIC25093-49` | alterada | **Inclusão** da pré-condição de feedback consolidado e do encerramento automático; **correção** da regra de avanço. Antes bastavam apuração concluída e empates resolvidos para fechar a UF, e a RN4 dizia que "as premiadas avançam". Agora o fechamento exige todas as inscrições do estado com feedback consolidado, lista as pendências por participante, encerra a etapa sozinho quando o último estado fecha, e quem avança é o **classificado** | +10 | +8 | 6 | 6 |
| `AVL-APU-06` **Gerar Relatório de Inscrições Paradas** | `PDTIC25093-56` | alterada | **Restrição** de perfil e **ampliação** da abrangência, na tela e na planilha. Antes o relatório alcançava apenas as UFs no escopo do administrador, tinha cenário próprio para quem não tinha UF vinculada, e a planilha exportava o recorte de UF que estivesse em tela. Agora é exclusivo do Administrador Nacional (APIPIT.22) e alcança todas as UFs da premiação, sem recorte regional — o cenário de administrador sem UF deixou de existir e a planilha sai sempre com todas as UFs. ℹ️ Em 2026-09-01 a feature absorveu a antiga `AVL-APU-07` **Exportar Relatório de Inscrições Paradas** (decisão 6) e passa a responder pelos dois processos elementares | +2 | +1 | 14 | 7 |
| `AVL-APU-08` **Consultar Ranking da Etapa** | `PDTIC25093-66` | **incluída** | **Feature incluída.** Consulta somente leitura do resultado consolidado, em blocos estado→grupo, com endereço direto para um bloco; para etapa encerrada apresenta o resultado gravado no fechamento, não um recálculo. Acessível ao Nacional e ao Regional, este restrito às suas UFs. É a irmã de leitura da tela de Fechamento | — | — | 7 | 7 |
| `AVL-APU-09` **Exportar Relatório da Etapa** | `PDTIC25093-49` | **incluída** | **Feature incluída.** Planilha XLSX com uma aba Resumo (uma linha por UF × grupo) e uma aba por tipo de participante, consolidando respostas do formulário, notas por avaliador, feedback consolidado e decisão de corte. O Administrador Regional recebe o recorte das suas UFs. Compartilha o mesmo serviço de montagem com o Ranking da Etapa | — | — | 7 | 7 |
| `AVL-APU-10` **Gerar Relatório de Inscrições** | `PDTIC25093-56` | **incluída** | **Feature incluída.** Consolida todas as inscrições da premiação em qualquer situação — difere do Relatório de Inscrições Paradas, que alcança só as em andamento —, em abas por tipo de participante, com 13 colunas fixas mais uma coluna por pergunta do formulário; a planilha sai completa, sem o limite de 50 registros por grupo da prévia em tela. Exclusiva do Administrador Nacional. ℹ️ Nasce unificada (decisão 6): a consulta em tela e a exportação são a mesma feature e valem dois processos elementares | — | — | 14 | 14 |
| `AVL-APU-12` **Reabrir Etapa por UF** | `PDTIC25093-49` | **incluída** | **Feature incluída.** Devolve um estado já encerrado à apuração: recalcula o corte, preserva o feedback consolidado e desfaz apenas as decisões de corte e desempate daquele escopo; reabrir a etapa inteira exige as etapas posteriores abertas. Exclusiva do Administrador Nacional. Não existia — na spec o encerramento por UF era irreversível | — | — | 4 | 4 |

Mensagens acrescentadas: `AVL_FECHAMENTO_PENDENCIAS`, `AVL_FECHAMENTO_EMPATE_CORTE`. **Matriz N2 alterada**: Encerrar Etapa por UF deixa de ser acessível ao Administrador Regional — fechar, reabrir e desempatar passam a exclusivos do Nacional — e os dois relatórios ficam restritos ao Nacional. **Subtotal: 8 features · 65 PFB · 58 PFL** — **sem estimativa**: os seis processos elementares que faltavam foram contados em 2026-09-01 sobre os N3, e o subtotal subiu de 50 para 65 PFB. A unificação de 2026-09-01 (decisão 6) reduziu de 10 para 8 o número de features do Feature Set nesta sprint **sem alterar nenhum PF**: as exportações continuam contadas como processo elementar próprio.

### Avaliação › Painel Administrativo (`AVL-PAI`)

| Feature | Item do Jira | Natureza | O que mudou em relação ao comportamento anterior | Regras | Cenários | PFB | PFL |
|---|---|---|---|---|---|---|---|
| `AVL-PAI-01` **Acompanhar Painel de Avaliações** | ⚠️ sem item | alterada | **Inclusão** do recorte por estado e do andamento da consolidação. Antes o painel mostrava a árvore inscrição → etapa → avaliadores de toda a premiação, com indicadores agregados, busca e seletor de status de consolidação — **não havia nenhum filtro por UF**, e o Administrador Regional via exatamente o mesmo que o Nacional. Agora há seleção de estado com escopo de perfil (o Regional enxerga só os seus, o Nacional tem a opção Nacional) e uma visão de quais estados já concluíram a consolidação | +4 | +5 | 7 | 3,5 |
| `AVL-PAI-03` **Consolidar Avaliação** | `PDTIC25093-49` | alterada | **Inclusão** da trava pelo fechamento. Antes o texto consolidado podia ser substituído a qualquer momento — uma nova consolidação sobrescrevia a anterior sem limite de prazo. Agora, com o estado já fechado, a consolidação é recusada; a consolidação completa do estado vira pré-requisito do fechamento e a reabertura do estado devolve o texto à edição | +4 | +3 | 6 | 3 |
| `AVL-PAI-04` **Exportar Relatório de Avaliadores** | ⚠️ sem item | **incluída** | **Feature incluída.** Planilha XLSX com duas abas — resumo por avaliador e a relação das avaliações. Não existe nem na spec nem no sistema: é a única das features novas que não tem nenhum código correspondente hoje | — | — | 7 | 7 |

Mensagem acrescentada: `AVL_CONSOLIDACAO_ESTADO_FECHADO`. **Matriz N2 alterada**: recorte por estado do Administrador Regional e trava de consolidação após o fechamento. **Subtotal: 3 features · 20 PFB · 13,5 PFL** — sem estimativa: `AVL-PAI-04` **Exportar Relatório de Avaliadores** foi contada em 2026-09-01 e vale 7 PF, não os 5 arbitrados.

### Avaliação › Avaliação de Projetos (`AVL-AVA`)

| Feature | Item do Jira | Natureza | O que mudou em relação ao comportamento anterior | Regras | Cenários | PFB | PFL |
|---|---|---|---|---|---|---|---|
| `AVL-AVA-01` **Acompanhar Minhas Avaliações** | `PDTIC25093-61` | alterada | **Inclusão** do papel de fila. Antes o painel do avaliador era só uma tela de consulta — cartões das inscrições alocadas, com seletores de premiação, etapa e status. Agora ele também define a sequência e o recorte das avaliações pendentes que o salto "Próxima pendente" consome | +2 | +1 | 7 | 3,5 |
| `AVL-AVA-03` **Avaliar Inscrição** | `PDTIC25093-61` | alterada | **Alteração** da forma de baixar o anexo. Antes a tela apenas listava os anexos para download, sem dizer como o acesso era conferido. Agora cada documento tem endereço individual e o direito é verificado a cada acesso, contra a inscrição designada ao avaliador | +2 | +2 | 10 | 5 |
| `AVL-AVA-04` **Finalizar Avaliação** | `PDTIC25093-61` | alterada | **Inclusão** do salto para a próxima avaliação. Antes finalizar encerrava o registro em somente leitura e o avaliador voltava ao painel para escolher a próxima inscrição. Agora existe o salto "Próxima pendente", restrito ao recorte vigente do acompanhamento, com aviso quando não resta pendência | +3 | +3 | 3 | 1,5 |

Mensagem acrescentada: `AVL_SEM_PENDENTES`. **Subtotal: 3 features · 20 PFB · 10 PFL.**

### Avaliação › Alocação (`AVL-ALO`)

| Feature | Item do Jira | Natureza | O que mudou em relação ao comportamento anterior | Regras | Cenários | PFB | PFL |
|---|---|---|---|---|---|---|---|
| `AVL-ALO-04` **Alocar Avaliador à Inscrição** | `PDTIC25093-60` | alterada | **Inclusão** do detalhe do projeto e de três recortes; **correção** da elegibilidade. Antes a tela listava as inscrições elegíveis com a designação de avaliadores e a etiqueta de situação, sem nenhum filtro e sem como ver o conteúdo do projeto, e as elegíveis das etapas seguintes eram "as aprovadas na etapa anterior". Agora o projeto é consultável em modo somente leitura, há recortes por grupo, estado (com Nacional) e situação da alocação, e quem passa para a etapa seguinte é o classificado | +5 | +7 | 17 | 8,5 |

**Subtotal: 1 feature · 17 PFB · 8,5 PFL.**

### Validação › Fila de Validação (`VAL-FIL`)

| Feature | Item do Jira | Natureza | O que mudou em relação ao comportamento anterior | Regras | Cenários | PFB | PFL |
|---|---|---|---|---|---|---|---|
| `VAL-FIL-01` **Pesquisar Inscrições para Validação** | `PDTIC25093-56` | alterada | **Inclusão** do ponto de entrada do Relatório Geral de Inscrições na fila, oculto para quem não acessa relatórios administrativos (APIPIT.22). Filtros em cascata, cards KPI e tabela paginada seguem como estavam | — | +2 | 7 | 3,5 |
| `VAL-FIL-02` **Acompanhar Painel de Validação** | `PDTIC25093-58` | alterada | **Inclusão** da exportação do histórico, que não estava especificada. Antes o N3 descrevia apenas os gráficos do dashboard — distribuição por situação e comparação por categoria ou UF. Agora a exportação em planilha é ação da feature, restrita ao Administrador Nacional, com Nome do Participante e Telefone resolvidos dos rótulos do formulário da inscrição | +4 | +4 | 7 | 3,5 |
| `VAL-FIL-03` **Exportar Histórico do Painel de Validação** | `PDTIC25093-58` | **incluída** ⚠️ | **Feature incluída.** A exportação do histórico estava especificada dentro de `VAL-FIL-02` **Acompanhar Painel de Validação**, com a restrição de perfil e as colunas de Nome e Telefone. Em 2026-09-01 ficou decidido **separá-la**, e o N3 próprio foi escrito na mesma data: os dados diferem, e não só de formato — a tela mostra agregados, a planilha traz uma linha por inscrição, com nome e telefone, que a tela não tem. ✅ Contada em 2026-09-01: SE, ALR 6, DER 18, complexidade Alta — **7 PF**, como função incluída a 100% | — | — | 7 | 7 |

**Matriz N2 alterada**: exportação do histórico restrita ao Nacional; registrados os acessos aos relatórios administrativos ocultos ao Regional. **Subtotal: 3 features · 21 PFB · 14 PFL** — `VAL-FIL-03` **Exportar Histórico do Painel de Validação** deixou o zero provisório: o processo elementar foi contado em 2026-09-01 e vale **7 PF**.

### Validação › Análise e Decisão (`VAL-ANA`)

| Feature | Item do Jira | Natureza | O que mudou em relação ao comportamento anterior | Regras | Cenários | PFB | PFL |
|---|---|---|---|---|---|---|---|
| `VAL-ANA-01` **Detalhar Inscrição** | `PDTIC25093-68` | alterada | **Alteração** da forma de baixar o documento. Antes o detalhe "disponibilizava o arquivo do documento", sem dizer como o acesso era controlado. Agora cada documento tem endereço individual, conferido a cada acesso a quem tem direito à inscrição — o mesmo mecanismo que habilita o anexo do avaliador em `AVL-AVA-03` | +3 | +2 | 7 | 3,5 |
| `VAL-ANA-05` **Editar Inscrição Validada** | `PDTIC25093-68` | **incluída** | **Feature incluída.** Permite ao Administrador Nacional editar uma inscrição já validada: correção dos dados do membro da equipe com máscara de CPF e telefone, e inclusão do primeiro membro quando a equipe está vazia. Não existia na spec até a conferência com o código: o N2 registrava a edição administrativa como deferida, e o N3 foi escrito em 2026-08-28 — a lotação em `VAL-ANA`, dentro da tela de validação da inscrição, foi confirmada em 2026-09-01 | — | — | 6 | 6 |

**Subtotal: 2 features · 13 PFB · 9,5 PFL** — `VAL-ANA-05` **Editar Inscrição Validada** deixou o zero provisório: o processo elementar foi contado em 2026-09-01 e vale **6 PF**.

### Total

| Recorte | Features | Regras | Cenários | Natureza | PFB | PFL |
|---|---|---|---|---|---|---|
| **Alteradas — medidas** no baseline | 12 | +41 | +40 | alteradas (50%) | **91** | **45,5** |
| **Alteradas** — fechamento fora do baseline, contado em 2026-09-01 | 3 | +28 | +25 | incluídas (100%) | **19** | **19** |
| **Novas** — contadas em 2026-09-01 | 7 | — | — | incluídas (100%) | **52** | **52** |
| **Total** | **22** | **+69** | **+65** | — | **162** | **116,5** |

Todas as 22 features têm um número **medido** — o total deixou de carregar `(E)` em 2026-09-01, quando os 12 processos elementares que faltavam foram contados sobre os N3 (memória de cálculo em cada um; consolidado em `global/CONTAGEM-PF.md`, seção 1B). O delta subiu de **132 (E) para 162 PFB** e de **86,5 (E) para 116,5 PFL** — as estimativas estavam **30 PFB abaixo** do medido, principalmente nas três features de fechamento, que ganharam ALR e DER muito além do que 4 PF arbitrados supunham. ⚠️ A contagem é própria e está **pendente de validação pela equipe de métricas**.

### Fora do delta da SP05 — revisão contra o sistema

Alterações aplicadas na mesma passagem, mas que **não vêm da SP05**: nasceram da conferência da spec contra as telas do sistema. Estão aqui para que a auditoria da sprint não as conte como delta da demanda — e por isso **não somam PFB nem PFL**.

| Feature | Item do Jira | O que mudou em relação ao comportamento anterior | Regras | Cenários | PFB | PFL |
|---|---|---|---|---|---|---|
| `AVL-ETA-02` **Cadastrar Etapa** | — | **Inclusão** do campo *Liberação do feedback*, que existia no editor e no modelo mas não fora capturado da HU-024 — a spec simplesmente não tinha o campo | +2 | +2 | — *(mesma feature já contada acima)* | — |
| `AVL-ETA-03` **Editar Etapa** | — | **Inclusão** do mesmo campo em edição, incluindo o caso de antecipar o término depois de a liberação já estar gravada | +2 | +2 | — *(mesma feature já contada acima)* | — |
| `INS-ACO-02` **Visualizar Devolutiva** | — | **Inclusão** da regra de liberação. Antes o N3 dizia apenas que a devolutiva aparece "após a liberação pela avaliação", sem dizer o que causa a liberação. Agora há uma devolutiva por etapa avaliada, disponível quando a consolidação daquela etapa está concluída **e** a data de liberação do feedback da etapa já ocorreu | +8 | +5 | — *(sem PE no baseline)* | — |

Mensagem acrescentada: `AVL_ETAPA_LIBERACAO_INVALIDA`. Total do bloco: **+12 regras · +9 cenários**.

### Examinadas sem impacto

Features conferidas contra a demanda e que **não** absorveram delta — registradas para que a auditoria saiba que foram olhadas, e não esquecidas.

**Sem impacto material (apenas confirmar/reusar):** `AVL-ETA-01`, `AVL-ETA-06`, `AVL-PAI-02` (a "auditoria de notas" já existe aqui), `CFG-TIP-15`, `AVL-ALO-01`, `AVL-APU-04/05`. **Opcional, mesmo gap da edição admin:** `VAL-ANA-06` Excluir Inscrição (administrativa).


---

## 3. Tabelas alteradas, por função de dados

As seis alterações físicas declaradas pelas migrações V00030 a V00033, agrupadas pela função de dados (ALI) a que cada tabela pertence. A regra de contagem é a mesma das features: como as três funções são **alteradas** — nenhuma é incluída —, o **PFL é 50% do PFB**. O baseline não tem AIE.

> **Três níveis, não confundir.** Na **coluna**, são cinco inclusões — nenhuma coluna existente mudou de tipo, tamanho ou semântica. Na **tabela**, quatro são alteradas (ganharam coluna) e uma é incluída. Na **função de dados**, que é o que a APF conta, são **três alteradas e nenhuma incluída**: a tabela nova é entidade dependente e entra como registro lógico de um ALI que já existia. Por isso a regra aplicada é a de **função alterada (50%)**, e não a de incluída (100%). ✅ **Confirmado pela equipe de métricas (2026-08-28)**, em resposta ao item (a) da Q11: `TB_FECHAMENTO_ETAPA_UF` faz parte de um ALI existente. Tratá-la como ALI próprio acrescentaria de 7 a 10 PF indevidos. A mesma resposta confirmou os outros dois itens da Q11: a inclusão do `CD_UUID` é **funcional**, então o ALI Inscrição permanece na conta, e a de fechamento é a **única tabela incluída** na sprint.

### ALI: Premiação — RLR 9 · DER 71 → 73 · Alta

| Tabela | Natureza | Alteração | Migração |
|---|---|---|---|
| `TB_ETAPA` | Tabela alterada | **Inclusão da coluna** `NR_CLASSIFICADOS` (int, não nulo, padrão 1) — quantos participantes de cada grupo de disputa avançam. Antes a etapa não guardava corte nenhum | V00031 |
| `TB_ETAPA` | Tabela alterada | **Inclusão da coluna** `NR_PREMIADOS` (int, aceita nulo) — segundo corte, independente do de classificação; nulo significa etapa que não premia | V00032 |

**PFB 15 · PFL 7,5** — 2 colunas incluídas em 1 tabela alterada. Permanece Alta: 73 DER com 9 RLR não muda a faixa.

### ALI: Inscrição — RLR 11 · DER 85 → 86 · Alta

| Tabela | Natureza | Alteração | Migração |
|---|---|---|---|
| `TB_INSCRICAO_DOCUMENTO` | Tabela alterada | **Inclusão da coluna** `CD_UUID` (nvarchar(36), não nulo, único) — endereço individual do documento, base do download conferido a cada acesso. Antes o documento não tinha endereço próprio | V00030 |

**PFB 15 · PFL 7,5** — 1 coluna incluída em 1 tabela alterada. Permanece Alta. ✅ A inclusão do `CD_UUID` é **funcional** — necessidade de negócio, não motivação técnica —, confirmado pela equipe de métricas em 2026-08-28 (item (b) da Q11), então este ALI permanece na conta.

### ALI: Avaliação de Inscrição — RLR 3 → 4 · DER 38 → 42 · Média

| Tabela | Natureza | Alteração | Migração |
|---|---|---|---|
| `TB_APROVACAO_ETAPA_PARTICIPANTE` | Tabela alterada | **Inclusão da coluna** `FL_PREMIADO` (bit, não nulo, padrão 0) — marca a inscrição premiada. Antes não havia como distinguir a premiada da classificada | V00032 |
| `TB_DESEMPATE_DECISAO` | Tabela alterada | **Inclusão da coluna** `DS_TIPO_CORTE` (varchar(15), não nulo, padrão `CLASSIFICACAO`) — distingue o desempate de classificação do de premiação. Antes toda decisão de desempate era de classificação | V00032 |
| `TB_FECHAMENTO_ETAPA_UF` | **Tabela incluída** | **Criação da tabela** — fechamento da etapa por estado. Antes o fechamento era da etapa inteira, sem recorte por estado. Entra como registro lógico (RLR) do ALI, não como função de dados nova | V00033 |

**PFB 10 · PFL 5** — 2 colunas incluídas em 2 tabelas alteradas, mais 1 tabela incluída. Dos seis campos da tabela nova, quatro (`CD_ETAPA`, `CD_USUARIO_RESPONSAVEL`, `NM_USUARIO_RESPONSAVEL`, `DS_OBSERVACAO`) já existiam no grupo: só `CD_UF` e `DT_FECHAMENTO` acrescentam DER. Permanece Média — 4 RLR × 42 DER continua na faixa pela Tabela 1 do CPM.

### Total das funções de dados

| Função de dados | Tabelas alteradas | Tabelas incluídas | Colunas incluídas | Natureza da **função** | PFB | PFL |
|---|---|---|---|---|---|---|
| Premiação | 1 | — | 2 | alterada | 15 | 7,5 |
| Inscrição | 1 | — | 1 | alterada | 15 | 7,5 |
| Avaliação de Inscrição | 2 | 1 | 2 | alterada | 10 | 5 |
| **Total** | **4** | **1** | **5** | **3 alteradas · 0 incluídas** | **40** | **20** |

Os 40 PFB entram na fórmula do projeto de melhoria como **CHGA** — nenhum ADD, nenhum DEL. O CHGA é dimensionado pelo tamanho da função **depois** da alteração, e nenhuma das três muda de faixa: Premiação e Inscrição já estavam no teto (Alta) e Avaliação de Inscrição permanece Média. Ou seja, os 40 PFB são o mesmo que essas três funções já valiam — a evolução muda o conteúdo, não o tamanho. Aplicada a regra de 50%, o valor a considerar é **20 PFL**.

### Fechamento do dimensionamento da SP05

| Origem | Natureza | PFB | PFL |
|---|---|---|---|
| Features com contagem no baseline (seção 2) | alteradas — 50% | 91 | 45,5 |
| Features de fechamento `AVL-APU-01/02/03` (seção 2) | incluídas — 100% | 19 | 19 |
| Features novas — as 7 (seção 2) | incluídas — 100% | 52 | 52 |
| Funções de dados (seção 3) | alteradas — 50% | 40 | 20 |
| **Total apurável** | — | **202** | **136,5** |

✅ **Nenhum dos 202 PFB é estimativa.** Os 12 processos elementares que faltavam foram contados em 2026-09-01 sobre os N3 já escritos, com ALR e DER nomeados na memória de cálculo de cada feature. O dimensionamento da sprint está fechado, à espera apenas da **validação da equipe de métricas** — duas classificações merecem conferência: `Consultar Ranking da Etapa`, contada como SE por causa das linhas de corte derivadas (seria 6 PF como CE), e o par consulta/exportação do Relatório de Inscrições, contado como dois PE pela convenção destes sistemas. Do lado de dados **não resta pendência**: a Q11 foi respondida nos três itens — a tabela de fechamento é registro lógico de um ALI existente, a inclusão do `CD_UUID` é funcional e não há outra tabela nova na sprint.

### Definições ainda em aberto

- ✅ **Reabertura do fechamento — resolvida em 2026-09-01**: reabrir um estado **apaga a linha de fechamento**, em vez de marcá-la com uma situação. Confirma as **6 alterações de modelo** da sprint — a sétima que estava em estudo não existe. Consequência aceita: **não fica trilha dos fechamentos anteriores** de um mesmo estado. Registrada em `AVL-APU-03` **Encerrar Etapa por UF** (regra 11) e no data-model de Avaliação.
- ⚠️ **A natureza da etapa não tem onde ser declarada** *(resíduo da decisão sobre a abrangência do corte, tomada em 2026-09-01)*: ficou decidido que a **etapa nacional** apura o corte entre todos os inscritos e a **etapa regional** apura por estado, e que a visibilidade sai da mesma natureza — mas **não existe campo em Etapa que diga qual das duas ela é**. Hoje isso só pode ser lido da lista de perfis autorizados (Regional presente ⇒ etapa regional), que é justamente o acoplamento que a decisão quis remover. Declarar a natureza como campo próprio da Etapa seria uma **alteração de modelo nova**, não declarada nas migrações V00030–V00033. Recomendação: campo próprio — enquanto não houver, mexer nos perfis autorizados continua mudando o resultado da apuração.
- **Enums a definir**: `DS_STATUS` da Apuração (classificado / não classificado), o valor `PREMIACAO` em `DS_TIPO_CORTE`, `FECHADA`/`REABERTA` em `DS_SITUACAO` **da Etapa** — que segue em aberto, por ser o estado da etapa e não o do fechamento por UF — e a semântica de vencedora/perdedora em `DS_STATUS_DECIDIDO`.
- **`NR_CLASSIFICADOS` é campo de entrada**, obrigatório, mínimo 1 e padrão 1 — não um campo automático do sistema.
- **Aviso 6 não é alteração de schema**: a Inscrição não guarda nome nem telefone do inscrito, e o código os resolve "best-effort" a partir dos rótulos do formulário dinâmico (`ContatoParticipanteResolver`). Isso vira regra de negócio do N3, não coluna nova.
- ⚠️ **A contagem de 2026-09-01 aguarda validação da equipe de métricas**: os 12 processos elementares fora do baseline foram contados sobre os N3, com ALR e DER nomeados (`global/CONTAGEM-PF.md`, seção 1B). Duas leituras merecem conferência — `Consultar Ranking da Etapa` classificado como **SE** por causa das linhas de corte e da Coleta derivadas, que como **CE** valeria 6 em vez de 7 PF; e o par consulta/exportação do Relatório de Inscrições contado como **dois PE** pela convenção destes sistemas, que diverge da regra geral do CPM e, se revista, tira 7 PF da sprint.
- **Enums a definir**: `DS_STATUS` da Apuração (classificado / não classificado), o valor `PREMIACAO` em `DS_TIPO_CORTE`, `FECHADA`/`REABERTA` em `DS_SITUACAO` **da Etapa** — que segue em aberto, por ser o estado da etapa e não o do fechamento por UF — e a semântica de vencedora/perdedora em `DS_STATUS_DECIDIDO`.
- **`NR_CLASSIFICADOS` é campo de entrada**, obrigatório, mínimo 1 e padrão 1 — não um campo automático do sistema.
- **Aviso 6 não é alteração de schema**: a Inscrição não guarda nome nem telefone do inscrito, e o código os resolve "best-effort" a partir dos rótulos do formulário dinâmico (`ContatoParticipanteResolver`). Isso vira regra de negócio do N3, não coluna nova.
- **`VAL-FIL-03` Exportar Histórico do Painel de Validação — PE a contar** *(resíduo da decisão de separar a exportação, tomada em 2026-09-01)*: o N3 foi escrito em 2026-09-01; o processo elementar não está no baseline, porque nunca foi especificado nem contado, então entra como **função incluída a 100%**, com PFB **a arbitrar** com a métrica. Até lá o número desta análise segue o atual — o `0 (E)` é piso, não valor: por analogia com `Consultar Dashboard Gerencial` (SE, ALR 4, DER 12, Complexo, 7 PFB), a exportação pode valer entre **4 e 7 PFB**.
- **`AVL-APU-12` Reabrir Etapa por UF — PE a contar**: o N3 foi escrito em 2026-09-01 e nenhuma feature nova da sprint ficou sem spec. O processo elementar não está no baseline — é entrega da SP05 — e precisa ser contado. O ID é `12` porque `AVL-APU-07` e `AVL-APU-11` foram aposentados pela unificação de gerar+exportar e não são reutilizados.


---

## 4. Impacto em dicionários

Poucas mensagens novas; nenhum código de erro é obrigatório no perfil `requisitos` (códigos são artefato do 3B técnico).

**MESSAGE-DICTIONARY — novas mensagens prováveis:** trava de consolidação (`AVL_CONSOLIDACAO_ESTADO_FECHADO`), estado não fecha com pendências (`AVL_FECHAMENTO_PENDENCIAS`), empate na linha de corte (`AVL_FECHAMENTO_EMPATE_CORTE`), reabrir exige etapas posteriores abertas, membro indisponível quando a inscrição não admite equipe, "não há mais avaliações pendentes". A justificativa 30–1000 usa o baseline `MIN_LENGTH`/`MAX_LENGTH`.

**FIELD-DICTIONARY:** CPF e Telefone ganham nota de máscara de exibição (`000.000.000-00`, `(00) 00000-0000`) — sem campo novo.

**ERROR-DICTIONARY:** `FechamentoEstadoBloqueadoException` → código de erro futuro (`AVL_FECHAMENTO_ESTADO_BLOQUEADO`, 409/422), registrado como pendência técnica de 3B.

---

## 5. Decisões de produto

✅ **Nenhuma pendente.** As oito decisões que este relatório registrava e as três que vinham dos relatórios por item foram todas respondidas — as últimas em 2026-09-01. Cada uma foi aplicada nos N3, nos N2 e, quando alcançava o modelo, no data-model; o que foi decidido está no `## Changelog` deste documento e no de cada artefato alterado.

As três últimas, para registro:

| Decisão | Resposta | O que mudou na spec |
|---|---|---|
| O grupo de disputa inclui a submodalidade? | **Sim** | `AVL-ALO-01` **Consultar Alocação de Avaliadores** e `AVL-ALO-02` **Alocar Avaliador ao Grupo** passam a incluir a submodalidade, convergindo com `AVL-ALO-04` **Alocar Avaliador à Inscrição**, cuja definição fora conferida contra o código; `AVL-APU-01` **Apurar Resultado da Etapa** acrescenta a submodalidade ao grupo de disputa |
| Nome e telefone resolvidos por rótulo — aceitar o risco? | **Sim, o produto está ciente** | A regra 6 de `VAL-FIL-02` **Acompanhar Painel de Validação** deixa de ser suposição a confirmar e passa a registrar a limitação como **conhecida e aceita**: renomear o rótulo esvazia a coluna na planilha, sem erro e sem aviso |
| Qual a ordenação da fila do "Próxima pendente"? | **A do painel** | Confirmado o que a spec já dizia — mesmo recorte e mesma ordem de protocolo do acompanhamento. Os ⚠️ de suposição saem de `AVL-AVA-01` **Acompanhar Minhas Avaliações** e `AVL-AVA-04` **Finalizar Avaliação** |

O que **ainda falta** não é decisão de produto: é especificação e contagem, listado em *Definições ainda em aberto*, ao final da seção 3, e nas seções 5 dos relatórios por item.

---

## Metodologia

Leitura direta da demanda e do SQL/data-models, e 5 análises paralelas cruzando cada item da SP05 com os N3 reais dos domínios Avaliação e Validação (inventário de 34 features), os dicionários e as matrizes de permissão dos N2. Escopo do perfil `requisitos`: as recomendações param no negocial + data-model; códigos de erro e endpoints ficam para o 3B técnico. A seção 1 traduz cada item da demanda para o vocabulário da spec e foi produzida antes de qualquer alteração; as seções 2 e 3 registram o que a atualização dos N3 e do modelo efetivamente aplicou, pelo preflight de especificação.

## Changelog

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-09-02 | Análise de impacto (docqui) | Correção de número | O alerta das duas features sem item no Jira dizia **12 PFB / 8,5 PFL**; a tabela do Feature Set e o subtotal dizem **7 + 7 = 14 PFB** e **3,5 + 7 = 10,5 PFL**. Prevalece a tabela — o alerta subestimava em 2 PFB e 2 PFL justamente o que precisa ser conciliado |
| 2026-09-01 | Contagem APF (docqui) | Resíduos de contagem fechados | As duas pendências de "PE a contar" saíram de *Definições ainda em aberto* — os processos elementares foram contados. No lugar entrou a única coisa que resta: a validação da métrica, com as duas classificações que merecem conferência |
| 2026-09-01 | Contagem APF (docqui) | Estimativas substituídas por contagem | Os 12 processos elementares que faltavam foram contados sobre os N3, com ALR e DER nomeados. O apurável da sprint passa de **172 (E) · 106,5 (E)** para **202 · 136,5 PF**, sem nenhuma estimativa. As arbitragens estavam 30 PFB abaixo do medido. ⚠️ Contagem própria, pendente de validação pela equipe de métricas |
| 2026-09-01 | Especificação (docqui) | Textos conciliados | Removidas as três menções remanescentes a features "sem N3" — `AVL-APU-12` na regra 10 de `AVL-APU-03`, `VAL-ANA-05` no detalhe do item `-68` e `VAL-FIL-03` na tabela do Feature Set. Todas as três têm N3 escrito |
| 2026-09-01 | Especificação (docqui) | Duas features especificadas | `AVL-APU-12` **Reabrir Etapa por UF** e `VAL-FIL-03` **Exportar Histórico do Painel de Validação** ganharam N3. Eram as duas entregas da SP05 sem spec; nenhuma feature da sprint fica sem especificação. As duas pendências passam de "N3 a escrever" para apenas "PE a contar" |
| 2026-09-01 | Decisões de produto (docqui) | Últimas três respondidas | O grupo de disputa passa a **incluir a submodalidade**; a resolução de nome e telefone por rótulo é **limitação aceita** pelo produto; e a fila do "Próxima pendente" é **a do painel**, confirmando o que a spec já dizia. Aplicadas em seis features. A seção 5 fica sem nenhuma decisão de produto pendente |
| 2026-09-01 | Análise de impacto (docqui) | Lista consolidada | Três decisões de produto que só existiam nos relatórios por item — o grupo de disputa com ou sem submodalidade, a resolução de nome e telefone por rótulo, e a ordenação da fila do "Próxima pendente" — sobem para a lista do agregado. A lista dizia "nenhuma pendente" enquanto elas estavam abertas |
| 2026-09-01 | Decisões de produto (docqui) | Última decisão respondida | A abrangência do corte passa a derivar da **natureza da etapa**: nacional apura entre todos os inscritos, regional apura por estado; e a visibilidade sai da mesma natureza — o Administrador Regional não enxerga etapa nacional e, na regional, só os seus estados. Aplicada em `AVL-APU-01`, `AVL-ETA-02`, `AVL-ETA-03` e `AVL-APU-08`, com a matriz de visibilidade no N2. A seção 5 fica sem decisões pendentes; o resíduo — não há campo que declare a natureza da etapa — foi para *Definições ainda em aberto* |
| 2026-09-01 | Decisões de produto (docqui) | Quatro decisões respondidas | O produto respondeu: **avança o classificado**; a **edição administrativa mora dentro da tela de validação da inscrição** (fica em `VAL-ANA`, confirmando a spec); a **reabertura apaga a linha de fechamento**, sem trilha do fechamento anterior e sem a sétima alteração de modelo; e o **drawer "Projeto" reaproveita** `VAL-ANA-01` **Detalhar Inscrição**. Aplicadas nos N3 e no data-model, saíram da lista da seção 5 — resta apenas a decisão 8 |
| 2026-09-01 | Análise de impacto (docqui) | Decisões resolvidas removidas | As decisões já tomadas saíram da lista da seção 5 — o registro do que foi decidido fica no changelog, e o trabalho que sobrou delas foi para onde é acompanhado. Os números das que ficaram não foram reaproveitados |
| 2026-09-01 | Decisões 3 e 6 (docqui) | Decisões aplicadas e seção 5 reescrita | Removida a decisão sobre a restrição dos relatórios ao Administrador Nacional — confirmada, deixa de ser pendência, e os ⚠️ correspondentes saíram dos N3, N2 e protótipos. Aplicada a decisão 6: `AVL-APU-07` incorporada a `AVL-APU-06` **Gerar Relatório de Inscrições Paradas** e `AVL-APU-11` a `AVL-APU-10` **Gerar Relatório de Inscrições**, sem alterar um único PF. Numeração de `AVL-APU` reconciliada com a árvore de arquivos (Ranking `08`, Reabrir `12`). Seção 5 reescrita: cada decisão traz o que está na spec hoje, as opções com o custo de cada uma, o que trava e quem decide; todas as features citadas com código **e** nome |
| 2026-09-01 | Análise de impacto (docqui) | Roteiro reestruturado | Relatório remontado no roteiro de 5 seções: saíram as três de diagnóstico que duplicavam o registro do delta (features que mudam, features novas, alterações de modelo) e a ordem passou a detalhe por item · alterações aplicadas · tabelas por função de dados · dicionários · decisões pendentes. Nada de conteúdo se perdeu: o inventário das examinadas sem impacto foi para a seção 2 e as definições de modelo em aberto para a seção 3 |
| 2026-08-28 | Análise de impacto (docqui) | Seções acrescentadas | Seção 7 — alterações efetivamente aplicadas aos N3, por Feature Set e por feature, com o comportamento anterior e as colunas PFB/PFL; seção 8 — tabelas alteradas agrupadas por função de dados, com a mesma regra de contagem |
| 2026-08-27 | Análise de impacto (docqui) | Relatório criado | Impacto da demanda SP05 sobre a spec — derivado da análise "novas vs alteradas", do data-model e dos N3 de Avaliação/Validação |
