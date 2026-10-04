<!-- docqui: 4.1.0 | prompt: PROMPT_N0 | atualizado: 2026-10-04 -->
# Visão de Produto: Prêmio IEL de Talentos
> **Nível 0** - Visão de Produto - `PIEL`

> O documento de referência mais alto do sistema: define **por que** o produto existe, para **quem** e **que valor** entrega. Os níveis N1–N3 são confrontados contra ele para garantir que não extrapolam o escopo nem contradizem os objetivos do produto. O N0 dá a direção; não detalha funcionalidades, telas ou campos.
>
> **Identidade**: o nome e a sigla vêm de `global/MASTER.md` → *Identificação do sistema*, a fonte única — aqui eles só se repetem (o `validate-doc` reprova sigla divergente).
>
> **Quem mantém**: PO / Liderança de Produto
> **Atualização**: revisado quando a estratégia do produto muda — não a cada feature.

---

## Propósito

Hoje o Prêmio IEL de Talentos é conduzido com controles manuais e dispersos (planilhas, Pipefy, e-mails), sem rastreabilidade para ninguém: o candidato envia a inscrição "e acabou" — só descobre o resultado perto da cerimônia e nunca sabe como foi avaliado; os administradores regionais e o nacional não têm um fluxo único para validar inscrições, alocar avaliadores, apurar notas e dar devolutiva; e cada edição recomeça a montagem da estrutura do zero. O produto substitui esses controles por uma plataforma própria, configurável e transparente, que conduz o ciclo completo da premiação — da montagem da edição à devolutiva ao participante — com rastreabilidade ponta a ponta e reaproveitamento entre edições e premiações.

---

## Proposta de valor

Um único sistema parametrizável que conduz todo o ciclo da premiação com transparência para o inscrito — que passa a acompanhar sua inscrição e a receber uma devolutiva sobre a avaliação recebida —, controle e visão consolidada para os administradores regionais e nacional, e reaproveitamento da estrutura entre edições, categorias e modalidades.

---

## Público-alvo e personas

| Persona | Quem é | Principal dor | O que espera do produto |
|---|---|---|---|
| Participante / Inscrito | Pessoa ou organização que concorre (instituição de ensino, empresa de qualquer porte, estagiário/estudante bolsista, empreendedor, projeto de educação inovadora) | Inscreve-se e não tem retorno: não sabe o status nem como foi avaliado; só descobre o resultado perto da cerimônia | Inscrever-se com facilidade (podendo salvar e retomar), acompanhar o andamento e receber uma devolutiva sobre a nota |
| Avaliador | Voluntário externo — professores, coordenadores de curso, parceiros, ex-participantes | Avaliar projetos sem uma ferramenta padronizada e sem garantia de sigilo | Receber os projetos que lhe foram alocados e registrar nota por questão e um parecer, com confidencialidade |
| Administrador Regional (DR) | Responsável vinculado a uma ou mais UFs (unidades regionais) | Validar, alocar avaliadores e apurar manualmente, sem visão consolidada do que está acontecendo | Validar inscrições, alocar avaliadores, acompanhar avaliações, revisar a devolutiva e selecionar quem avança de etapa |
| Administrador Nacional | Perfil máster do IEL Nacional (liderança do prêmio) | Montar e conduzir a premiação inteira sem uma plataforma de apoio | Configurar a edição, definir etapas e modo de avaliação, conduzir a etapa nacional e resolver desempates |

---

## Objetivos do produto

> O **quê** o produto busca alcançar — em linguagem de negócio, sem soluções técnicas.

1. Digitalizar e unificar o ciclo completo da premiação — configuração, inscrição, validação, avaliação, apuração e devolutiva — substituindo planilhas e controles manuais.
2. Dar transparência ponta a ponta ao participante, que passa a acompanhar o status da inscrição e a receber devolutiva sobre a avaliação.
3. Dar aos administradores regionais e ao nacional controle e visão consolidada de cada etapa (validação, alocação, apuração e desempate).
4. Tornar a premiação configurável e reaproveitável entre edições, categorias, modalidades e tipos de participante.
5. Escalar o volume de inscrições e avaliações com padronização, sigilo na avaliação e auditabilidade das ações.
6. Apoiar a devolutiva ao participante com consolidação assistida por Inteligência Artificial, sempre com revisão humana antes do envio. ⚠️ *(recurso em evolução)*

---

## Métricas de sucesso (KPIs)

> Como saberemos que o produto está cumprindo seus objetivos. ⚠️ As metas não foram definidas nas reuniões — propostas a validar com a liderança do produto.

| KPI | O que mede | Meta |
|---|---|---|
| Taxa de conclusão da inscrição | Inscrições finalizadas ÷ inscrições iniciadas | ⚠️ a definir *(referência 26/05/2026: 94 concluídas, 404 em andamento, 521 em rascunho)* |
| Cobertura de devolutiva | Participantes avaliados que recebem devolutiva ÷ total avaliado | ⚠️ a definir *(meta sugerida: 100%)* |
| Tempo de validação | Dias entre o envio da inscrição e a decisão de validação regional | ⚠️ a definir |
| Reaproveitamento entre edições | Proporção da estrutura (categorias/modalidades/formulários) reutilizada em nova edição | ⚠️ a definir |
| Adesão de avaliadores | Avaliadores que concluem as avaliações alocadas ÷ avaliadores alocados | ⚠️ a definir |

---

## Escopo

### Está dentro

- Configuração da edição: categorias, modalidades, tipos de participante e ofertas (submodalidades), formulários de inscrição dinâmicos, questionários de avaliação, etapas, modelos de e-mail, critérios de avaliação e de desempate, identidade visual e links públicos de inscrição.
- Inscrição do participante: acesso por link público, preenchimento com salvar e retomar, anexos, aceite de termos, inscrição em equipe, painel de acompanhamento e notificações.
- Validação regional: conferência de dados, documentos e termos, decisão de aprovar ou rejeitar e solicitação de ajustes com auditoria por rodadas.
- Avaliação: alocação de avaliadores, notas por questão e parecer por projeto, com sigilo (termo de confidencialidade e avaliação às cegas quando configurada).
- Apuração e resultados: cálculo de média, ranqueamento, aplicação de critérios de desempate e fechamento por etapa e por UF.
- Devolutiva: consolidação dos pareceres (com apoio de IA) e revisão humana antes da liberação ao participante.
- Gestão transversal: controle de acesso por perfil (via login corporativo), administradores regionais, notificações, relatórios e exportações.

### Está fora (não-objetivos)

- Gerir a identidade e a autenticação dos usuários — o produto usa o login corporativo do Sistema Indústria (SSO), não mantém cadastro próprio de senhas. ⚠️
- Pagamentos, repasses ou premiação monetária. ⚠️
- Aplicativo mobile nativo — o foco de uso é desktop web (telas responsivas, sem app dedicado).
- Organização da cerimônia e do evento presencial em si.
- Substituir a ferramenta de origem das demandas (backlog/histórias) — o produto é o sistema da premiação, não a gestão do projeto.

---

## Major Feature Sets previstos (N1)

> Visão preliminar das grandes áreas que comporão o sistema. Cada uma será detalhada em seu próprio N1. Mantenha esta lista alinhada com `modules/INDEX.md`. As siglas já são as usadas no modelo de dados (`global/data-models/`).

| Major Feature Set | SIGLA | O que cuida |
|---|---|---|
| Configuração da Premiação | CFG | Montar a edição: categorias, modalidades, tipos de participante, formulários, questionários, etapas, e-mails e critérios |
| Inscrição | INS | Inscrição do participante, anexos, equipe, acompanhamento e notificações |
| Validação | VAL | Conferência e aprovação/rejeição de inscrições, com solicitação de ajustes auditada |
| Avaliação | AVL | Alocação de avaliadores, notas e pareceres, apuração, desempate e devolutiva |
| Acesso e Gestão | ACS | Acesso e perfis (login corporativo), administradores regionais, auditoria e relatórios |

---

## Tom de voz e princípios de experiência

- **Tom**: direto, profissional e institucional — coerente com um produto do Sistema Indústria / IEL Nacional.
- **Princípios**:
  - **Transparência com o participante** — ele sempre sabe em que pé está a inscrição e recebe devolutiva sobre a avaliação.
  - **Nunca perder o trabalho do usuário** — inscrição com salvar e retomar e rascunho autossalvo.
  - **Configurável e reaproveitável** — a edição é montada por parâmetros e reutilizada entre anos e premiações.
  - **Sigilo na avaliação** — confidencialidade do avaliador e avaliação às cegas quando configurada.
  - **IA com revisão humana** — a consolidação da devolutiva por IA nunca é enviada sem revisão de uma pessoa.
  - **Auditabilidade** — ações críticas (validação, ajustes, avaliação) ficam registradas.

---

## Restrições e premissas

- A autenticação e a identidade dos usuários vêm do **login corporativo do Sistema Indústria (SSO)**, com um perfil por usuário — o produto não mantém cadastro próprio de senhas. ⚠️
- A premiação ocorre em duas etapas, **Regional → Nacional**; a inscrição acontece **apenas na etapa regional** e os classificados avançam ao nacional sem nova inscrição.
- O uso é majoritariamente em **desktop** (telas responsivas, mas sem aplicativo mobile).
- O apoio de **IA na devolutiva** depende de custo/aprovação específica e está em evolução. ⚠️
- **Premissa**: a plataforma atende ao Prêmio IEL de Talentos e é reaproveitável para outras edições e premiações do IEL; se o produto passar a ser de uso exclusivo de uma única edição, a visão muda. ⚠️

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0: carimbo, cabeçalho com Identidade, Quem mantém e Atualização, e a seção *Domínios previstos* renomeada para *Major Feature Sets previstos (N1)*. Conteúdo de visão sem alteração |
| 2026-08-25 | Engenharia reversa (docqui) | N0 criado | Visão de produto inicial — derivada das transcrições, HUs e modelo de dados |

---

## Instrução para a LLM

Ao gerar ou alterar qualquer N1/N2/N3:
1. Confronte o artefato com este N0 — escopo, objetivos e público-alvo.
2. Sinalize com ⚠️ qualquer divergência (funcionalidade que extrapola a visão, contradição de objetivo, persona não prevista).
3. O N0 é documento de visão — **não o reestruture** para acomodar detalhes de implementação. Proponha ajustes e peça aprovação antes de alterá-lo.
