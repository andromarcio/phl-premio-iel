## Resumo

| Funcionalidade | Classificação na SP05 |
|---|---|---|
|  Configurar Etapas de Avaliação | **ALTERADA** (dois cortes: classificados + premiados) |
| Fechar Etapa de Avaliação | **NOVA** — primeiro envio à área negocial (a funcionalidade já existia tecnicamente, mas a especificação nunca havia sido enviada) |
| Relatório Geral de Inscrições | **NOVA** |
| Ranking por Etapa | **NOVA** |
| Validar Inscrições | **ALTERADA** (3 ajustes na edição administrativa/documentos) |

Além disso, a Sprint 5 entregou **itens que não constam em nenhum dos 5 documentos** — listados na seção final ("Avisos").

---

## 1. HU-024 — Configurar Etapas de Avaliação — **ALTERADA**

Funcionalidade existente desde abril/2026 (aba "Avaliação & Etapas" do formulário da premiação). O delta da Sprint 5 corresponde à versão interna 1.3 (12/08/2026) do documento.

### O que foi alterado
- **Diálogo de editor de etapa** ganhou dois campos numéricos novos:
  - **Quantidade de classificados** (obrigatório, mínimo 1, padrão 1) — define quantos participantes de cada grupo de disputa avançam para a próxima etapa. Introduzido pela migração **V00031**, que também estabeleceu que a **abrangência do corte deriva dos perfis autorizados** da etapa (Administrador Regional habilitado ⇒ disputa por estado × grupo; caso contrário, por grupo).
  - **Quantidade de premiados** (opcional; vazio = etapa não premia; mínimo 1 quando informada) — segundo corte, **independente** do de classificação. Introduzido pela migração **V00032** (`NR_PREMIADOS`, flag `FL_PREMIADO` ortogonal ao status, `DS_TIPO_CORTE` na decisão de desempate).
- **Cartão da etapa** passou a exibir os selos **"Classificados"** e **"Premiados"** ("N por grupo" ou "N por estado × grupo").
- **Bloqueio de edição dos cortes com a etapa fechada** — o corte já materializado no resultado só pode ser ajustado após reabertura administrativa.

### O que NÃO é desta sprint (contexto)
- O campo "Pontuação máxima por nota máxima" (versão interna 1.2, de 02/07) é de entrega anterior.

**Código:** `etapa-editor-dialog`, `etapa-card` (front); `EtapaDTO/EtapaRequestDTO`, `EtapaServiceImpl`, V00031/V00032 (back). 

---

## 2. HU-030 — Fechar Etapa de Avaliação  — **NOVA** (primeiro envio à área negocial)

> **Por que "NOVA":** a funcionalidade existe tecnicamente desde abril/2026 (versões internas 1.0 a 1.4 do documento) e está em produção desde o release de 26/06, mas a especificação **nunca havia sido enviada à área negocial**. É o **primeiro envio** — portanto, para fins desta entrega, toda a funcionalidade é apresentada como nova, já na sua forma final da Sprint 5.

### O que a funcionalidade entrega (visão completa)
- **Seleção de contexto**: escolha de premiação e etapa, com o status da etapa (Aberta ou Fechada) visível.
- **Ranking em baldes**: visão agrupada por **estado → grupo competitivo**, ordenada por média ponderada (pesos das questões, 2 casas decimais), com colocação reiniciada a cada bloco, linha de corte de classificação e — quando a etapa premia — linha de corte de premiação destacadas.
- **Indicadores (KPIs)**: total no ranking, estados fechados (N de M), quantidade que classifica, empates na linha de corte, vagas de premiação e empates no corte de premiação.
- **Corte de classificação automático**: classificam os primeiros colocados de cada grupo, conforme a quantidade configurada na etapa (HU-024); em etapa regional, a disputa é por estado dentro de cada grupo. Não existe decisão manual de aprovar/reprovar por inscrição.
- **Corte de premiação independente**: quando a etapa define quantidade de premiados, os primeiros colocados são marcados como premiados — condição independente da classificação (um não classificado pode ser premiado e vice-versa).
- **Fechamento por estado**: cada estado (UF) é fechado individualmente pelo Administrador Nacional, com registro de data, responsável e observação opcional (até 500 caracteres); inscrições sem UF ficam no bloco "Nacional". Um estado só fecha quando **todas** as suas inscrições possuem feedback consolidado — as pendências ficam visíveis por participante (sem avaliadores / avaliação em andamento / feedback não consolidado).
- **Encerramento automático da etapa** quando o último estado pendente é fechado.
- **Trava de consolidação**: ao fechar um estado, o feedback consolidado das inscrições daquele estado fica bloqueado para edição (o sistema recusa a alteração e o editor exibe o bloqueio).
- **Reabertura**: reabrir um estado o devolve à apuração e recalcula o corte, preservando o feedback consolidado e desfazendo apenas as decisões de corte/desempate daquele escopo; reabrir a etapa inteira exige etapas posteriores abertas.
- **Desempate manual por corte** (exclusivo do Administrador Nacional): empate que cruza a linha de corte de classificação **ou** de premiação impede o fechamento do estado até ser resolvido; botões "Resolver empate" e "Resolver premiação" abrem o drawer de comparação questão a questão (respostas e notas lado a lado), com escolha da inscrição vencedora e justificativa obrigatória (30 a 1000 caracteres). Cada decisão registra qual corte resolve.
- **Auditoria de notas**: painel lateral com as notas individuais de cada avaliador (questão, peso, nota), médias, status, data de finalização e histórico de transições — visão exclusiva do administrador.
- **Exportar Relatório da Etapa (XLSX)**: planilha com aba "Resumo" (uma linha por UF × grupo) + uma aba por tipo de participante, consolidando respostas do formulário, notas por avaliador, feedback consolidado e decisão de corte; o Administrador Regional recebe o recorte das suas UFs.
- **Permissões**: fechar/reabrir estado ou etapa e desempate manual são exclusivos do Administrador Nacional; consulta do ranking, auditoria e exportação valem também para o Administrador Regional, restrito às inscrições das suas UFs.

### O que mudou na Sprint 5 (rastreabilidade técnica)
Para referência interna, a versão em produção antes da Sprint 5 (release de 26/06) diferia da forma final descrita acima nos seguintes pontos, todos entregues na Sprint 5 sob a migração **V00033** (e V00031/V00032 na configuração):
- O corte de classificação passou a ser **automático** — a decisão manual de aprovar/reprovar por inscrição foi removida.
- O fechamento passou a ser **por estado** (entidade nova `FechamentoEtapaUf`), com reabertura por estado e **encerramento automático** da etapa no último estado; o ranking em baldes foi invertido de grupo → estado para **estado → grupo**.
- Entraram a **trava de consolidação** (recusa com `FechamentoEstadoBloqueadoException`), as **pendências por participante** (`PendenciaFeedbackDTO`), o **corte de premiação** com desempate próprio (`DS_TIPO_CORTE`), os novos KPIs e o **relatório XLSX da etapa** (`RelatorioEtapaService`).

**Código:** `fechamento-etapa`, `desempate-manual-drawer`, `ranking-baldes`, `consolidacao-editor` (front); `FechamentoEtapaService/Impl`, `DesempateDecisaoServiceImpl`, `AprovacaoEtapaParticipanteServiceImpl`, `RelatorioEtapaService/Impl`, DTOs `FechamentoEstadoRequest/Response`, `FechamentoUfDTO`, V00033 (back). PRs de estabilização "Correções no fechamento de etapa" (85139/85140/85158/85181) fazem parte desta entrega.

---

## 3. HU-036 — Relatório Geral de Inscrições — **NOVA**

Funcionalidade inédita (versão 1.0 do documento, 12/08/2026). Não existia antes da Sprint 5.

### O que foi entregue
- Tela administrativa nova `relatorio-inscricoes`, **exclusiva do Administrador Nacional** (guard novo `relatorio-admin-nacional` redireciona os demais perfis para a tela de inscrições).
- Consolida **todas as inscrições da premiação em qualquer situação** (difere do Relatório de Inscrições Paradas, que cobre só as em andamento), organizadas em **abas por tipo de participante** — cada aba com as 13 colunas cadastrais fixas + **uma coluna por pergunta do formulário** do tipo (incluindo perguntas em branco; anexos listam o nome dos arquivos).
- **Prévia em tela de 50 inscrições por grupo** (sempre informando o total real) e **exportação XLSX completa**, sem o limite da prévia.
- Filtros: UF, categoria → modalidade (encadeadas), situação (múltipla), período de início; botão limpar filtros.
- Ponto de entrada: botão novo "Relatório de Inscrições" na tela de inscrições da validação.

**Código:** `relatorio-inscricoes` (página nova), `relatorio-admin-nacional.guard`, `relatorio-inscricoes.model` (front); `RelatorioController` (novo), `RelatorioInscricoesService/Impl`, `RelatorioFormularioHelper` (extraído e compartilhado com o relatório de paradas), `RelatorioInscricoesDTO` (back).

---

## 4. HU-038 — Ranking por Etapa — **NOVA**

Funcionalidade inédita (versão 1.0 do documento, 12/08/2026). Não existia antes da Sprint 5.

### O que foi entregue
- Tela nova `ranking-etapa`, de **consulta somente leitura** do resultado consolidado de etapas apuradas — sem qualquer ação de fechar/reabrir, arbitrar empate ou auditar notas (isso permanece exclusivo da tela de Fechamento).
- Acessível ao **Administrador Nacional e ao Administrador Regional** — o regional enxerga apenas os participantes dos seus estados + os de abrangência nacional (escopo de UF aplicado na leitura de `obterRanking`/`obterAuditoria`).
- Seleção de premiação → etapa **com resultado consultável** (totalmente encerrada ou com ao menos um estado do escopo encerrado), com selos "Fechada"/"Parcial"; suporte a **acesso direto por link** apontando para uma etapa.
- Resultado em blocos **estado → grupo competitivo**, com colocação, protocolo, participante/projeto (ocultos em avaliação confidencial), média (com marcas de empate/decisão manual), coleta N/M e selos de classificação e premiação; para etapa já encerrada exibe o **resultado gravado no fechamento**, não um recálculo.
- **Exportação do relatório da etapa** em planilha (mesmo `RelatorioEtapaService` da HU-030, com recorte de UF para o regional).

**Código:** `ranking-etapa` (página nova) + componente compartilhado `ranking-baldes` (front); endpoints de ranking/auditoria com escopo de UF em `AvaliacaoAdminController`/`FechamentoEtapaController`, `RankingEtapaResponseDTO` (back).

---

## 5. PIEL Validar Inscrições — **ALTERADA**

Funcionalidade existente desde abril/2026. O delta documentado na linha de **12/08/2026** do histórico são **3 ajustes** na edição administrativa e nos documentos da inscrição.

> **Observação de rastreabilidade:** estes 3 itens foram **entregues em produção antes do release "Sprint 5"** — nos PRs 82777/82776 (06/07) e 82846/82845 (07/07) — e documentados agora na v3.

### O que foi alterado
- **Máscara de CPF e telefone** nos campos do membro da equipe ao adicionar/editar membro na edição administrativa da inscrição validada (formatos `000.000.000-00` e `(00) 00000-0000`; o valor não é mais apagado ao sair do campo). *(PR 82754)*
- **Inclusão do primeiro membro da equipe**: o Administrador Nacional passou a poder adicionar membro em inscrição que ainda não possui nenhum (a tela de edição passou a carregar a configuração de equipe da premiação); quando a inscrição não admite equipe, o botão permanece indisponível com aviso. *(PR 82693)*
- **Download de documentos por link individual e seguro**: cada documento anexado passou a ser baixado por URL própria protegida por **UUID** (migração **V00030**), acessível apenas a quem tem direito à inscrição — mecanismo que também habilitou o download de anexos pelo avaliador (PR 82846/82845). *(PRs 82693/82694)*

### O que NÃO é desta sprint (contexto)
- A linha de 26/06 do histórico (exclusão de inscrição não finalizada; edição e exclusão administrativas de inscrição validada com justificativa e auditoria) é da sprint anterior — subiu em produção no release de 26/06.

**Código:** `edicao-inscricao-admin`, `documento-viewer-dialog`, services de `inscricao-publica` (front); `InscricaoDocumentoController/Service`, V00030 (back).

---

## ⚠️ Avisos — itens da Sprint 5 que NÃO constam nos documentos desta pasta

Itens funcionais entregues no release de produção da Sprint 5 (11/08) sem cobertura em nenhum dos 5 documentos (correções Snyk desconsideradas):

1. **Botão "Próxima pendente" na tela de avaliação do avaliador** (`avaliacao-detalhe`) — após concluir uma avaliação, o avaliador pode saltar direto para a próxima avaliação não finalizada da sua lista, sem voltar ao painel. Nenhum documento da pasta cobre a tela do avaliador.
2. **Drawer "Projeto" na alocação por participante** (`projeto-drawer`, ~860 linhas novas) — painel lateral com os detalhes do projeto/inscrição aberto a partir da tela de alocação de avaliadores.
3. **Filtros novos na tela de alocação por participante** — Grupo (Categoria–Modalidade–Tipo–Submodalidade), Estado (UF, com "Nacional" agrupando inscrições sem UF) e Status da alocação, em multiseleção com chips.
4. **Tela "Avaliações" (consolidação) do administrador** ganhou: filtro por **Premiação**, filtro por **UF** (com escopo para o regional), visão de **consolidação por estado** ("quais UFs já concluíram e quais faltam") e um **relatório novo — "Relatório de avaliadores" (XLSX, 2 abas: resumo por avaliador + avaliações)** via endpoint novo `/relatorio-avaliadores/exportar` (PIT.1/PIT.3). Este relatório não aparece em nenhum documento.
5. **Restrição dos relatórios ao Administrador Nacional (recurso APIPIT.22 no SNA)** — os botões "Inscrições Paradas" (tela de inscrições) e "Exportar Excel" (dashboard gerencial) agora só aparecem para o Administrador Nacional, e os endpoints de relatório foram movidos para o novo `RelatorioController`. O documento do Relatório de Inscrições Paradas não está nesta pasta, portanto essa mudança de permissão está sem registro.
6. **Excel de histórico do Dashboard Gerencial ganhou as colunas "Nome do Participante" e "Telefone"** — resolvidas de forma *best-effort* a partir dos rótulos dos campos do formulário dinâmico (`ContatoParticipanteResolver`; se o admin renomear o campo, a coluna sai vazia). Também sem documento na pasta.
7. *(Menor)* Correção de rota no widget de pendências de alocação (link quebrado `/admin/avaliacao-admin/...` → `/avaliacao-admin/...`).

**Sugestão:** os itens 1–3 pertenceriam a uma HU da tela de Alocação/Painel do Avaliador; os itens 4–6 pediriam atualização das especificações do Dashboard Gerencial / Relatório de Inscrições Paradas / tela de Avaliações — nenhuma dessas especificações está na pasta SP05.

