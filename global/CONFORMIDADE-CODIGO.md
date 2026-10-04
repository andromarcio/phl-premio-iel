<!-- docqui: 2.8.0 | prompt: PROMPT_CONVERSION | atualizado: 2026-08-28 -->
# Conformidade da documentação com o código
> Conferência da especificação (N0–N3, data-model, protótipos) contra o **código-fonte real** dos dois repositórios do produto, realizada em **2026-08-28**. Registra o que foi **corrigido nesta passada**, o que **permanece divergente** e o que **existe no código e não está documentado**.

## Escopo da conferência

| Fonte | O que foi lido |
|---|---|
| `Projeto_Premio_IEL_Talentos_Backend` | 668 arquivos Java — 60 entidades JPA (`domain/`), 50 controllers (294 endpoints), 56 serviços + 64 implementações, 58 repositórios, 20 enums; 33 migrações SQL (`V00001`–`V00033`); `pom.xml`, `application.properties`, `configuracoes.json`, `Dockerfile`, pipelines |
| `Projeto_Premio_IEL_Talentos_Frontend` | Angular 20.3 — 16 arquivos de rota (todas as rotas da SPA), páginas e componentes dos 6 módulos de feature, `package.json`, `angular.json`, `src/environments/` |
| Documentação (`premio-iel`) | `global/` (MASTER, N0, DATA-MODEL + 5 fragmentos, AUTHZ, API-PATTERNS, NFR, SIZING), `modules/` (5 N1, 21 N2, 110 N3 — **126 após esta passada**), `prototypes/` (9 fluxos), `repos/INDEX.md` |

Os repositórios de código foram entregues **sem histórico git**, então nada foi verificado por commits — só pelo conteúdo dos arquivos.

---

## 1. Resumo

| Dimensão | Situação |
|---|---|
| **Modelo de dados — tabelas e colunas** | ✅ Aderente. Todas as colunas das entidades JPA têm linha no fragmento correspondente; nenhuma coluna documentada está ausente do código. |
| **Modelo de dados — Label Dev** | ❌ → ✅ **144 divergências**, todas corrigidas nesta passada. O Label Dev tinha sido *inferido* dos prefixos do banco porque o código não estava disponível na engenharia reversa. |
| **Modelo de dados — enums** | ❌ → ✅ **18 conjuntos de valores** estavam como "⚠️ a confirmar"; todos preenchidos a partir dos `enum` Java e das `CHECK constraints`. |
| **Modelo de dados — entidades** | ❌ → ✅ Faltavam **2 entidades** (`TB_PESSOA`, `TB_DOWNLOAD_ARQUIVO`); acrescentadas. |
| **Rotas de tela** | ❌ → ✅ **236 ocorrências** de rotas que não existem na SPA; todas substituídas pelas rotas reais. As rotas documentadas eram *sugeridas* (a coluna dos N2 dizia "Rota sugerida"), não observadas. |
| **Arquitetura de navegação** | ⚠️ **Divergência estrutural** — a configuração da premiação é **uma tela só** (árvore + editor contextual), não a dúzia de páginas independentes que os N2/N3 descrevem. Corrigido nas rotas; a prosa de "Onde fica" foi ajustada onde a rota mudou de natureza. |
| **Stack, repositórios, autorização** | ❌ → ✅ `MASTER.md` e `repos/INDEX.md` estavam com os *placeholders* do template; preenchidos com o que está no código. |
| **Regras de negócio** | ⚠️ Divergências pontuais confirmadas (seção 3) — corrigidas quando o código é inequívoco, sinalizadas quando exigem decisão do PO. |
| **Funcionalidades no código sem N3** | ❌ → ✅ **13 capacidades** implementadas e não especificadas; **15 features (N3) criadas** em 2026-08-28 para cobri-las (seção 4). |
| **Funcionalidades no N3 sem código** | ⚠️ **2 features** especificadas e não implementadas (seção 5). |
| **Contrato de API** | ❌ Documentado em `API-PATTERNS.md` como envelope `{data, meta, error}`; o código não usa envelope algum. Registrado em `MASTER.md`; `API-PATTERNS.md` segue como padrão-alvo. |
| **Modelo de autorização** | ❌ `AUTHZ.md` descreve autorização por **ID de Feature** com catálogo e *kill switch*; o sistema autoriza por **perfil do portal corporativo** (`PIT.1`–`PIT.4`). `AUTHZ.md` fica como padrão-alvo, com aviso. |
| **Protótipos** | ⚠️ Divergentes em rota, terminologia e fluxo; ajustados (seção 6). |

---

## 2. O que foi corrigido nesta passada

### 2.1 `global/data-models/*.md` — Label Dev

O Label Dev de cada campo agora é o **nome do atributo Java da entidade JPA**. Padrão real do código, que a inferência não tinha como adivinhar:

| Situação | Inferido antes | Real no código |
|---|---|---|
| Associação `@ManyToOne` | `premiacaoId`, `etapaId`, `inscricaoId` | `premiacao`, `etapa`, `inscricao` |
| Campo `NM_`/`DS_` da própria entidade | `nomePremiacao`, `descricaoCategoria` | `nome`, `descricao` |
| Abreviação de quantidade | `quantidadeAvaliadoresPorInscricao` | `qtdAvaliadoresPorInscricao` |
| Prefixo `VL_` | `valorFatorPontuacao`, `valorNota` | `fatorPontuacao`, `valor` |
| Campos de e-mail (base CNI, em inglês) | `remetente`, `assunto`, `corpo`, `destinatarios` | `from`, `subject`, `body`, `to` |

Alguns casos merecem atenção porque o nome real **não** segue a convenção do `MASTER.md`: `AjusteItem.nrSequencia` (prefixo do banco vazando para o Java), `FormularioCampo.isIdentificador` (prefixo `is`), `AnexoConfiguracao.tamanhoMaximoMB` (sigla em caixa alta), `AuditoriaEmail.from` (palavra reservada em vários contextos) e `AvaliacaoNota.alocacao` / `AvaliacaoHistorico.alocacao` (nome curto para `alocacaoAvaliadorParticipante`). Foram registrados como estão — a documentação descreve o código, não o corrige. ⚠️ Vale uma decisão da equipe sobre padronizar.

### 2.2 `global/data-models/*.md` + `global/DATA-MODEL.md` — enums

Todos os "⚠️ valores a confirmar" foram substituídos pelos valores reais. Os mais relevantes para o negócio:

- **Situação da inscrição** (`StatusInscricaoEnum`): RASCUNHO · EM_ANDAMENTO · FINALIZADA · EM_VALIDACAO · VALIDADA · REJEITADA · AGUARDANDO_AJUSTE · AJUSTES_CONCLUIDOS.
- **Status da avaliação** (`StatusAvaliacaoEnum`): A_INICIAR · EM_ANDAMENTO · FINALIZADA.
- **Situação da etapa** (`SituacaoEtapaEnum`): ABERTA · FECHADA — não existe "ativa", que o documento supunha.
- **Tipo de e-mail** (`TipoEmailEnum`): 7 tipos, sendo 3 do módulo de Avaliação acrescentados em 2026-04-21.
- **Perfil de acesso à etapa**: `CHECK` restringe a `PIT.1` e `PIT.3` — etapa é operada por Administrador Nacional e Regional, nunca por Participante ou Avaliador.

Quatro enums estão **declarados e não usados** (`StatusEdicaoEnum`, `TipoCampoInscricaoEnum`, `TipoMesaEnum`, `ComposicaoMesaEnum`) — resíduo, registrado no DATA-MODEL.

### 2.3 Entidades acrescentadas

- **`TB_PESSOA`** (Acesso e Gestão) — cadastro legado herdado do projeto base CNI, com CRUD completo em `/administracao/pessoas`. Nenhuma entidade de negócio da premiação o referencia. ⚠️ Confirmar se permanece.
- **`TB_DOWNLOAD_ARQUIVO`** (Inscrição) — infra de download temporário por identificador não-adivinhável.

### 2.4 Rotas

236 ocorrências corrigidas. As substituições estruturais:

| Documentado (não existe) | Real |
|---|---|
| `/premios`, `/premios/novo`, `/premios/:id` | `/configuracao-premiacao/premiacoes`, `/…/novo`, `/…/:premiacaoId/configurar` |
| `/premios/:id/estrutura`, `/termos`, `/emails`, `/links`, `/submodalidades` · `/premiacoes/:id/avaliacao-etapas`, `/termo-confidencialidade` | Todas são **abas ou diálogos** da mesma tela `/configuracao-premiacao/premiacoes/:premiacaoId/configurar` |
| `/tipos-participante/:id/formulario` \| `/anexos` \| `/equipe` \| `/avaliacao` \| `/enquadramentos` | Abas do editor contextual de Tipo de Participante, dentro da mesma tela de configuração |
| `/validacao`, `/validacao/inscricoes/:protocolo`, `/validacao/dashboard` | `/validacao-inscricao/inscricoes`, `/…/:inscricaoId/detalhe`, `/…/dashboard` |
| `/avaliacao-admin/alocacao` · `/avaliacao-admin/fechamento/:etapaId` | `/avaliacao-admin/alocacao-matriz` · `/avaliacao-admin/fechamento-etapa/:etapaId` |
| `/avaliacao/avaliador` · `/avaliacao/avaliar/:inscricaoId` · `/avaliacao/termo/:premiacaoId` | `/avaliacao/premiacao/:premiacaoId` · `/avaliacao/:alocacaoId` · `/avaliacao/premiacao/:premiacaoId/termo` |
| `/inscricao/:id/formulario` · `/inscricao/:id/termos` | `/inscricao/formulario/:inscricaoId` · `/inscricao/termos/:inscricaoId` (o id vem **depois** do segmento) |
| `/painel` · `/painel/inscricoes/:id/devolutiva` | `/participante/dashboard` · `/inscricao/minha/:inscricaoId?tab=feedbacks` |
| `/administradores`, `/administradores/novo`, `/administradores/:id/ufs` | `/administracao-usuarios`, `/administracao-usuario`, `/administracao-usuario/:login` |
| `/avaliacao-admin/relatorios/inscricoes-paradas` | `/validacao-inscricao/relatorio-inscricoes-paradas` — o relatório vive no módulo de **Validação**, não no de Avaliação |
| `/notificacoes` | **Não é rota** — é um painel lateral aberto pelo sino no cabeçalho do participante |
| `/auditoria` · `/premios/:id/criterios` | **Não existem** — ver seção 5 |

A coluna "Rota sugerida" dos 21 N2 passou a "Rota (implementada)".

### 2.5 `global/MASTER.md` e `repos/INDEX.md`

Estavam integralmente com os *placeholders* do template (`[nome-backend]`, `[SGBD]`, `[a definir]`). Preenchidos com stack, repositórios, variáveis de ambiente, pipelines, convenções de código, campos globais (`Auditavel`), decisões transversais e contrato de API reais.

---

## 3. Divergências de regra de negócio

### 3.1 Corrigidas (o código é inequívoco)

| Feature | Documentado | Código | Ação |
|---|---|---|---|
| `VAL-ANA-03` Aprovar Inscrição | "A aprovação só está disponível para inscrições na situação **Em Validação**" | `ValidacaoInscricaoServiceImpl.aprovar` aceita **EM_VALIDACAO, AJUSTES_CONCLUIDOS e AGUARDANDO_AJUSTE** | Regra corrigida |
| `VAL-ANA-03` / `VAL-ANA-04` | ⚠️ conflito aberto: "parecer é opcional na aprovação" × HU-026 exigindo mínimo de 10 caracteres | O `validacao-dialog` só emite a confirmação com `parecer.length >= 10`, para **aprovar e rejeitar**; o backend **não valida** | Conflito resolvido: obrigatório com 10 caracteres na tela, sem barreira no servidor. ⚠️ Lacuna de segurança registrada |
| `VAL-ANA-04` Rejeitar Inscrição | Mesma restrição de situação | Mesmas três situações da aprovação | Regra corrigida |
| `AVL-APU-01` Apurar Resultado da Etapa | "A média de cada inscrição é a **média ponderada** das notas dos avaliadores finalizados, calculada pelos pesos das questões" | `CalculoMediaEtapaServiceImpl` faz **dois passos**: (1) média ponderada pelas questões **por avaliador**; (2) **média aritmética** das médias dos avaliadores finalizados. Notas restritas a **1–5**; pesos obrigatoriamente positivos; arredondamento HALF_UP com 2 casas | Regra corrigida e detalhada |

### 3.2 Colisão de terminologia: "Submodalidade"

O documento tratou **Submodalidade** como sinônimo de **Oferta** (`TB_TIPO_PART_MOD_CAT`), com um ⚠️ pedindo confirmação. O código responde o contrário:

- Na UI, a aba **"Sub Modalidades"** do Tipo de Participante renderiza `app-enquadramento-list` e consome `/administracao/tipos-participante/{tpId}/enquadramentos` — ou seja, **Submodalidade = Enquadramento** (`TB_ENQUADRAMENTO`).
- O que os N3 `CFG-VIN-09/10/11` descrevem (tipo de participante × modalidade-categoria, permite equipe, mínimo/máximo de membros, slug da URL) é a **Oferta**, configurada na aba **Geral** do editor de Tipo de Participante.

⚠️ **Decisão do PO necessária.** Duas features do catálogo descrevem a mesma coisa com nomes trocados: `CFG-VIN-09/10/11` (Cadastrar/Editar/Ativar Submodalidade) e `CFG-TIP-10/11` (Cadastrar/Ativar Enquadramento). O caminho recomendado é renomear `CFG-VIN-09/10/11` para "Oferta" e anotar em `CFG-TIP-10/11` que o rótulo de tela é "Sub Modalidade". Não foi feito nesta passada porque renomear e possivelmente fundir features altera o catálogo, a rastreabilidade e a contagem APF.

### 3.3 Autorização

`global/AUTHZ.md` propõe um catálogo de funcionalidades chaveado pelo ID da Feature (`@RequiresFeature`, `*appFeature`, *kill switch*). **Nada disso existe no código.** O que existe:

- Um perfil por usuário, vindo do portal corporativo: `PIT.1` Administrador (Nacional) · `PIT.2` Participante · `PIT.3` Administrador Regional · `PIT.4` Avaliador.
- `PerfilResolverService` resolve o código numérico do perfil para o ID textual consultando a API corporativa, com cache em memória.
- O menu é montado com o que o portal devolve — não há rota escondida por código.
- O Administrador Regional é limitado às UFs vinculadas em `TB_USUARIO_UF` (`EscopoUfRegionalService`).
- A etapa declara quais perfis podem operá-la em `TB_ETAPA_PERFIL_ACESSO` (`EtapaCapabilityService`), restrito a `PIT.1`/`PIT.3`.

`AUTHZ.md` foi mantido como **padrão-alvo**, com aviso em `MASTER.md` e na tabela de arquivos de referência. As matrizes "Permissões por perfil" dos N2 continuam válidas em intenção, mas os nomes de perfil que elas usam devem passar a citar os códigos `PIT.*`. ⚠️

### 3.4 Auditoria

`TL_LOG_AUDITORIA` e `LogAuditoriaRepository` existem, mas **nenhum serviço grava neles**. A trilha efetiva do produto é de domínio: `TB_INSCRICAO_HISTORICO` (+ `TB_AJUSTE_ITEM`), `TB_INSCRICAO_SNAPSHOT` (antes/depois de ajuste e de edição administrativa) e `TB_AVALIACAO_HISTORICO`; todo e-mail fica em `TB_AUDITORIA_EMAIL`. ⚠️ Impacta a NFR **AUD-01** e inviabiliza `ACS-AUD-01` como está especificada.

### 3.5 Identificadores em URL

O `MASTER.md` proibia expor a PK interna. O sistema **expõe** a PK em praticamente toda rota e endpoint. A única exceção é o download de anexo, que passou a usar UUID na migração `V00030` justamente para fechar um IDOR. Registrado em `MASTER.md` como divergência assumida, não como regra. ⚠️

---

## 4. Implementado e não especificado — **N3 gerados**

As capacidades abaixo estavam no código sem especificação. Em **2026-08-28** cada uma recebeu o seu N3, nos Feature Sets existentes (nenhum domínio ou Feature Set novo foi necessário). As linhas "Exportações de avaliação" e "Relatório de Inscrições" se decompõem em mais de uma ação, por isso 13 capacidades resultaram em **16 features**.

| Capacidade no código | Feature criada | Feature Set |
|---|---|---|
| Pré-cadastro público do participante — informa nome e e-mail no link, o sistema cria a conta no diretório corporativo e a inscrição | [`INS-PAR-08` Registrar Pré-cadastro](../modules/inscricao/inscricao-participante/f-registrar-pre-cadastro.md) | INS-PAR |
| Normalização de acesso — vincula ao sistema quem já existe no corporativo mas recebeu acesso não permitido | [`ACS-ACE-03` Vincular Usuário ao Sistema](../modules/acesso/acesso-perfis/f-vincular-usuario-sistema.md) | ACS-ACE |
| Edição administrativa de inscrição validada, com retratos antes e depois | [`VAL-ANA-05` Editar Inscrição Validada](../modules/validacao/analise-decisao/f-editar-inscricao-validada.md) | VAL-ANA |
| Exclusão administrativa de inscrição validada, com justificativa | [`VAL-ANA-06` Excluir Inscrição Validada](../modules/validacao/analise-decisao/f-excluir-inscricao-validada.md) | VAL-ANA |
| Conferência item a item dos ajustes solicitados | [`VAL-AJU-04` Conferir Item de Ajuste](../modules/validacao/ajustes/f-conferir-item-ajuste.md) | VAL-AJU |
| Tela dedicada de consulta ao ranking apurado | [`AVL-APU-08` Consultar Ranking da Etapa](../modules/avaliacao/apuracao-devolutiva/f-consultar-ranking-etapa.md) | AVL-APU |
| Exportação do relatório da etapa | [`AVL-APU-09` Exportar Relatório da Etapa](../modules/avaliacao/apuracao-devolutiva/f-exportar-relatorio-etapa.md) | AVL-APU |
| Relatório geral de inscrições, em tela e em planilha, distinto do de inscrições paradas | [`AVL-APU-10` Gerar Relatório de Inscrições](../modules/avaliacao/apuracao-devolutiva/f-gerar-relatorio-inscricoes.md) | AVL-APU |
| Panorama do avaliador por etapa | [`AVL-ALO-05` Consultar Panorama do Avaliador](../modules/avaliacao/alocacao/f-consultar-panorama-avaliador.md) | AVL-ALO |
| Pendências de alocação entre etapas consecutivas | [`AVL-ALO-06` Consultar Pendências de Alocação](../modules/avaliacao/alocacao/f-consultar-pendencias-alocacao.md) | AVL-ALO |
| Exportação do relatório de alocação da etapa | [`AVL-ALO-07` Exportar Relatório de Alocação](../modules/avaliacao/alocacao/f-exportar-relatorio-alocacao.md) | AVL-ALO |
| Exportação do relatório de avaliadores | [`AVL-PAI-04` Exportar Relatório de Avaliadores](../modules/avaliacao/painel-administrativo/f-exportar-relatorio-avaliadores.md) | AVL-PAI |
| Consulta aos demais avaliadores do projeto, sob apelido numerado e sem notas | [`AVL-AVA-06` Consultar Outros Avaliadores](../modules/avaliacao/avaliacao-projetos/f-consultar-outros-avaliadores.md) | AVL-AVA |
| Seleção de premiação — porta de entrada do avaliador | [`AVL-AVA-07` Consultar Premiações do Avaliador](../modules/avaliacao/avaliacao-projetos/f-consultar-premiacoes-avaliador.md) | AVL-AVA |
| Carga e publicação de imagens da identidade visual | [`CFG-PRE-13` Carregar Imagem de Configuração](../modules/configuracao/premios/f-carregar-imagem-configuracao.md) | CFG-PRE |

**Duas dessas features estão parcialmente implementadas** e o N3 correspondente registra isso: `AVL-ALO-06` (a apuração das pendências existe, mas o aviso não está montado em nenhuma tela) e `CFG-PRE-13` (a carga da imagem existe como operação de serviço, sem tela que a consuma).

A **exportação do histórico de inscrições** (`/administracao/relatorios/historico/exportar`) não gerou feature nova: ela já está especificada como ação de [`VAL-FIL-02` Acompanhar Painel de Validação](../modules/validacao/fila-validacao/f-acompanhar-painel-validacao.md), que traz a decisão aberta de promovê-la a `VAL-FIL-03`. Essa decisão é do PO e continua em aberto.

**Consequência para o dimensionamento:** as 15 features **não têm PF**. O baseline APF é de 2026-02-28 e não cobre capacidades criadas depois; dimensioná-las exige uma nova rodada com a equipe de métricas. O total vigente segue em 487 PF atribuídos a features.

**Vocabulário:** a criação de `VAL-AJU-04` exigiu acrescentar o verbo `conferir` ao vocabulário da instância — registrado em [`global/VOCABULARY-OVERRIDES.md`](./VOCABULARY-OVERRIDES.md), com a justificativa de negócio.

---

## 5. Especificado e não implementado

| Feature | Situação no código |
|---|---|
| `CFG-PRE-12` **Configurar Critérios de Avaliação** | `TB_CRITERIO_AVALIACAO` e `CriterioAvaliacaoRepository` existem, mas **não há controller nem serviço** — nenhuma tela e nenhum endpoint. Atenção: os "critérios de desempate" (`AVL-ETA-06`, `TB_DESEMPATE_CRITERIO`) **estão** implementados e são outra coisa. |
| `ACS-AUD-01` **Consultar Trilha de Auditoria** | Sem controller, sem tela e — como registrado em 3.4 — sem nada escrito na tabela de log. |

As features de fechamento e devolutiva que o `modules/INDEX.md` marcava como "fora do baseline: entrega da SP05" (`AVL-APU-01`, `AVL-APU-02`, `AVL-APU-03`, `AVL-APU-05`) **estão implementadas**: `FechamentoEtapaController` (ranking, resumo, fechar/reabrir estado, desempate manual, auditoria), `AvaliacaoAdminController` (consolidar, gerar feedback com IA) e as telas `fechamento-etapa` e `ranking-etapa`. Continuam fora do baseline APF, mas não estão mais pendentes de implementação.

---

## 6. Protótipos

Os 9 fluxos em `prototypes/` têm fidelidade **referência** (guiam a intenção, não são contrato). Ajustes aplicados:

- Rotas exibidas nas telas e nos textos trocadas pelas rotas reais (mesmo mapa da seção 2.4).
- Perfis passam a citar os códigos do portal (`PIT.1` Administrador Nacional, `PIT.3` Administrador Regional, `PIT.4` Avaliador).
- Rótulos alinhados à UI implementada, com destaque para **"Sub Modalidades"** (aba do Tipo de Participante) e para as abas reais da configuração da premiação (**Dados**, **Termos & E-mails**, **Avaliação & Etapas**).
- Nota de conformidade no cabeçalho de cada protótipo, ligando-o a este documento.

⚠️ Os protótipos continuam retratando a configuração da premiação como páginas independentes em alguns fluxos; refazê-los no formato "árvore + editor contextual" é retrabalho de design que deve ser decidido pelo time — está registrado, não executado.

---

## 7. Pendências para decisão

1. ~~**Submodalidade × Enquadramento × Oferta**~~ ✅ **Decidido (2026-08-28)**: mantém-se o vocabulário da interface — "Sub Modalidade" continua sendo o rótulo do Enquadramento. Nenhuma feature foi renomeada; as notas de esclarecimento em `CFG-VIN-09/10/11` e `CFG-TIP-10/11` permanecem (seção 3.2).
2. **Pré-cadastro e criação de conta corporativa** — o N0 declara "gerir identidade" como não-objetivo, mas o produto cria o usuário no diretório. Ajustar o N0 ou o escopo.
3. **Parecer obrigatório** — a regra dos 10 caracteres vive só no frontend; decidir se sobe para o backend.
4. **`ACS-AUD-01` e a NFR AUD-01** — implementar a trilha, ou reespecificar a feature sobre os históricos de domínio que já existem.
5. **`CFG-PRE-12`** — implementar ou remover do catálogo.
6. ~~**`AUTHZ.md` e `API-PATTERNS.md`**~~ ✅ **Decidido (2026-08-28)**: seguem como **padrão-alvo**, com o aviso de divergência já registrado em `MASTER.md` e na tabela de arquivos de referência.
7. **`TB_PESSOA`** — manter ou remover como resíduo do projeto base.
8. ~~**13 capacidades sem N3**~~ ✅ **Resolvido (2026-08-28)**: 15 features criadas (seção 4). Resta **dimensioná-las em APF** — hoje entram no catálogo sem PF.
9. **Padronização de nomes Java** que fogem à convenção (seção 2.1).

---

## Changelog

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-08-28 | Conferência doc × código (docqui) | Pendências decididas | Itens 1 e 6 decididos pelo PO (manter a interface; manter os padrões-alvo); item 8 resolvido com a criação de 16 N3 (seção 4) |
| 2026-08-28 | Conferência doc × código (docqui) | Documento criado | Primeira conferência da documentação contra o código-fonte do backend e do frontend |
