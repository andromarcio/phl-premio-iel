<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: AVL-ALO-04
feature_set: AVL-ALO
dominio: AVL
entidade: Avaliação de Inscrição
data_model_ref: data-models/avaliacao.md#avaliação-de-inscrição
endpoints: []
error_codes: []
depende_de: ["AVL-ALO-02"]
origem:
  tipo: issue
  chave: HU-025_Alocar_Avaliadores
estado: rascunho
gates:
  requisitos:   { aprovado: false, por: "", em: "", pr: "" }
  modelo-dados: { aprovado: false, por: "", em: "", pr: "" }
  testes:       { aprovado: false, por: "", em: "", pr: "" }
  codigo:       { aprovado: false, por: "", em: "", pr: "" }
contagem:
  pendente: true
  revisada_em: ""
  revisada_ate: ""
---

# Alocar Avaliador à Inscrição
> **Nível 3** - Feature Set: Alocação de Avaliadores — Major Feature Set: Avaliação - `AVL-ALO-04`

## Descrição
Permite ao administrador designar, a partir do pool do grupo, os avaliadores específicos de cada inscrição elegível de uma etapa, registrando a alocação de quem avaliará cada projeto.

No menu Avaliação › Alocação por Inscrição, o administrador escolhe a premiação e a etapa, recorta a lista por grupo, estado ou situação da alocação, escolhe na linha de cada inscrição os avaliadores do pool e aciona "Salvar"; a ação "Projeto" abre, ao lado da lista, o detalhe da inscrição para consulta.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-025_Alocar_Avaliadores`](../../../hus/HU-025_Alocar_Avaliadores.docx) | Criação | — funcionalidade "Alocar Avaliadores por Inscrição" da HU, que não numera critérios: designar e retirar avaliadores do pool em cada inscrição elegível e salvar a alocação, com sub e sobre-alocação e o indicador N/M |
| [`PDTIC25093-60`](../../../analise-impacto/AIM-PDTIC25093-60.md) | Alteração | — detalhe do projeto em modo leitura durante a alocação, recortes por grupo, estado (com Nacional) e situação da alocação, e elegibilidade das etapas seguintes pelo classificado |

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/avaliacao-admin/alocacao-participante` (Alocação por Inscrição): lista de inscrições elegíveis com a designação de avaliadores por inscrição, os filtros de grupo, estado e situação da alocação e o drawer lateral "Projeto" com o detalhe da inscrição.

**Fidelidade ao protótipo**: referência — `prototypes/avaliacao/alocacao/flow.html`

---

</div>

## Regras de negócio

1. As inscrições elegíveis à alocação são, na primeira etapa, as inscrições validadas e, nas etapas seguintes, as inscrições classificadas na etapa anterior — a marca de premiada não determina o avanço. ⚠️ *(quem avança é o classificado — mesma leitura da SP05 adotada em `AVL-APU-03`, a confirmar com a liderança do prêmio)*
2. Só avaliadores presentes no pool do grupo da inscrição podem ser designados a ela naquela etapa.
3. A quantidade de avaliadores esperada por inscrição é única para toda a premiação; a designação admite de zero a N avaliadores por inscrição, com sub-alocação e sobre-alocação permitidas.
4. O nome e o login do avaliador são preservados no momento da alocação e permanecem inalterados no histórico da inscrição.
5. Ao retirar um avaliador de uma inscrição, as notas que ele havia registrado nessa inscrição deixam de valer por exclusão lógica.
6. O administrador regional designa avaliadores apenas nas inscrições das UFs vinculadas ao seu perfil.
7. O grupo que qualifica uma inscrição para a alocação combina categoria, modalidade, tipo de participante e submodalidade da oferta a que a inscrição pertence. ✅ *(conferência com o código, 2026-08-28: as duas leituras coexistem por finalidades distintas — o **grupo de alocação** de `AVL-ALO-01`/`AVL-ALO-02` é categoria × modalidade × tipo de participante, enquanto o **grupo competitivo** usado aqui e na apuração acrescenta a submodalidade, que no produto é o enquadramento. Ver `global/CONFORMIDADE-CODIGO.md` § 3.2.)*
8. As inscrições sem unidade federativa vinculada compõem o conjunto Nacional para efeito de recorte por estado.
9. A situação da alocação de uma inscrição deriva da comparação entre a quantidade de avaliadores designados e a quantidade esperada por inscrição: sem avaliadores, alocação incompleta, alocação completa ou acima do esperado.
10. O detalhe do projeto consultado durante a alocação é somente leitura e apresenta o **mesmo conteúdo** definido para o detalhe da inscrição — identificação, respostas informadas pelo participante, anexos e equipe. → ver `VAL-ANA-01` (Detalhar Inscrição), que é a definição única desse conteúdo *(decidido em 2026-09-01: as duas visões convergem, e uma alteração no detalhe da inscrição alcança também este drawer)*

---

## Cenários

```gherkin
Feature: Alocar Avaliador à Inscrição

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Designar avaliadores a uma inscrição
    Given que a inscrição é elegível e o pool do grupo tem avaliadores
    When designo avaliadores do pool para a inscrição e salvo
    Then o sistema registra a alocação e exibe "Registro salvo com sucesso."

  Scenario: Consultar o detalhe do projeto durante a alocação
    Given que estou na lista de inscrições elegíveis da etapa
    When abro o detalhe do projeto de uma inscrição
    Then o sistema apresenta a identificação, as respostas do participante, os anexos e a equipe da inscrição sem sair da lista de alocação

  Scenario: Recortar a lista por grupo
    Given que a etapa tem inscrições de mais de um grupo
    When seleciono um ou mais grupos no recorte
    Then o sistema apresenta apenas as inscrições dos grupos selecionados

  Scenario: Recortar a lista pelas inscrições sem unidade federativa
    Given que a etapa tem inscrições sem unidade federativa vinculada
    When seleciono Nacional no recorte por estado
    Then o sistema apresenta apenas as inscrições sem unidade federativa

  Scenario: Recortar a lista por situação da alocação
    Given que a etapa tem inscrições com e sem avaliadores designados
    When seleciono a situação Sem avaliadores no recorte
    Then o sistema apresenta apenas as inscrições sem nenhum avaliador designado

  Scenario: Combinar recortes de grupo, estado e situação
    Given que selecionei um grupo, um estado e uma situação da alocação
    When aplico os critérios selecionados
    Then o sistema apresenta apenas as inscrições que atendem a todos os critérios e mantém visíveis os critérios aplicados

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Sobre-alocação acima do esperado
    Given que a premiação espera dois avaliadores por inscrição
    When designo três avaliadores para a inscrição e salvo
    Then o sistema registra a alocação mesmo acima da quantidade esperada

  Scenario: Inscrições elegíveis na primeira etapa
    Given que estou na primeira etapa da premiação
    When abro a alocação por inscrição
    Then o sistema apresenta como elegíveis as inscrições validadas

  Scenario: Recorte sem inscrições correspondentes
    Given que nenhuma inscrição elegível corresponde aos critérios selecionados
    When aplico os critérios
    Then o sistema exibe "Nenhum resultado para a busca."

  Scenario: Detalhe do projeto sem alteração da inscrição
    Given que abri o detalhe do projeto de uma inscrição
    When consulto os dados apresentados
    Then o detalhe permanece em modo leitura e os dados informados pelo participante seguem inalterados

  # ── Conflitos com dados existentes ─────────────────────────────

  Scenario: Remover avaliador que já registrou notas
    Given que confirmo a remoção de um avaliador que já pontuou a inscrição
    When salvo a alocação sem esse avaliador
    Then o sistema remove o avaliador e desativa as notas que ele havia registrado na inscrição
```

---

## Campos

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Premiação | Premiação | entrada do usuário | editável | seleção → Premiação | sim | premiações ativas |
| Etapa | Etapa | entrada do usuário | editável | seleção → Etapa | sim | etapas da premiação selecionada |
| Avaliadores alocados | Alocação de Avaliadores | entrada do usuário | editável | multi-seleção → Alocação de Avaliadores (avaliadores do pool) | não | limitado ao pool do grupo da inscrição na etapa |
| Grupo | derivado ↓ | entrada do usuário | editável | seleção múltipla de grupos (categoria, modalidade, tipo de participante e submodalidade) | não | grupos com inscrições elegíveis na etapa selecionada |
| Estado | Unidade Federativa | entrada do usuário | editável | seleção múltipla → Unidade Federativa | não | UFs alcançadas pelo perfil, mais a opção Nacional, que reúne as inscrições sem unidade federativa |
| Situação da alocação | dado de código | entrada do usuário | editável | seleção múltipla (Sem avaliadores, Alocação incompleta, Alocação completa, Acima do esperado) | não | — |

---

## Derivações

| Campo derivado | Fórmula (Label PO) | Campos-fonte (Entidade) |
|---|---|---|
| Grupo | Categoria × Modalidade × Tipo de participante × Submodalidade da oferta a que a inscrição pertence (regra 7) | Nome da categoria (Categoria), Nome da modalidade (Modalidade), Nome do tipo de participante (Tipo de Participante), Nome do enquadramento (Enquadramento) |

---

## Colunas do resultado

| Coluna (Label PO) | Origem | Ordenação |
|---|---|---|
| Protocolo | Inscrição | padrão ↑ |
| Participante / Projeto | Inscrição | — |
| Grupo | derivado | — |
| Estado | Inscrição (unidade federativa; Nacional quando ausente) | — |
| Avaliadores alocados | Avaliação de Inscrição | — |
| Situação da alocação (N/M) | derivado (Sem avaliadores, Alocação incompleta, Alocação completa, Acima do esperado) | — |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Nome do avaliador | Nome vigente no cadastro corporativo | No momento da alocação à inscrição |
| Login do avaliador | Login vigente no cadastro corporativo | No momento da alocação à inscrição |
| Status da avaliação | A iniciar | Ao designar o avaliador à inscrição |
| Situação da alocação | Sem avaliadores, Alocação incompleta, Alocação completa ou Acima do esperado, conforme a quantidade de avaliadores designados frente à esperada | A cada alocação salva na inscrição |
| Estado da inscrição | Nacional, quando a inscrição não tem unidade federativa vinculada | Ao apresentar e recortar as inscrições por estado |

---

## Dados lidos e gravados

| Entidade | Papel | Por que a feature a toca |
|---|---|---|
| Avaliação de Inscrição | lê e grava | Recebe a designação de cada avaliador à inscrição, com o nome, o login e o status A iniciar (regras 3 e 4 e campos automáticos), e alimenta a coluna *Avaliadores alocados* |
| Nota de Avaliação | grava | Retirar um avaliador da inscrição desativa as notas que ele havia registrado nela (regra 5) |
| Inscrição | lê | As inscrições elegíveis da etapa, com protocolo, participante, projeto e unidade federativa (regras 1 e 8), e o detalhe do projeto (regra 10) |
| Apuração por Etapa | lê | Nas etapas seguintes à primeira, só as inscrições classificadas na etapa anterior são elegíveis (regra 1) |
| Usuário | lê | As UFs vinculadas ao perfil limitam as inscrições em que o administrador regional designa avaliadores (regra 6) |

---

## Comportamento de tela

### Onde fica
Página própria em `/avaliacao-admin/alocacao-participante` (Alocação por Inscrição): seletores de premiação e etapa, o indicador de avaliadores esperados por inscrição, a barra de filtros em multisseleção — Grupo, Estado (com a opção Nacional) e Situação da alocação —, cujos critérios aplicados ficam visíveis como chips removíveis acima da lista, e a lista de inscrições elegíveis, cada uma com a designação de avaliadores, a etiqueta de situação e a ação que abre o drawer "Projeto": painel lateral em modo leitura, sobre a própria lista, com a identificação da inscrição, as respostas do participante, os anexos e a equipe, que ao fechar devolve a lista no mesmo ponto.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Botão "Salvar" da inscrição desabilitado com indicador enquanto grava; o drawer "Projeto" exibe "Carregando…" enquanto o detalhe é recuperado |
| Erro de validação | Não se aplica (designação opcional por inscrição) |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Exibe "Registro salvo com sucesso." e atualiza a situação da inscrição, mantendo os filtros aplicados |
| Empty state | Sem inscrições elegíveis: "Nenhum registro encontrado."; sem correspondência aos filtros aplicados: "Nenhum resultado para a busca." |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | Uma inscrição elegível recebe avaliadores do pool do seu grupo, com sub e sobre-alocação permitidas | Regra de negócio (HU-025) |
| SC-02 | A remoção de um avaliador desativa em cascata as notas que ele havia registrado na inscrição | cenário "Remover avaliador que já registrou notas" |
| SC-03 | A lista de inscrições elegíveis é recortada por grupo, por estado e por situação da alocação, com os critérios combinados entre si | cenário "Combinar recortes de grupo, estado e situação" |
| SC-04 | As inscrições sem unidade federativa são alcançadas pelo recorte Nacional | cenário "Recortar a lista pelas inscrições sem unidade federativa" |
| SC-05 | O detalhe do projeto de uma inscrição é consultado sem sair da lista de alocação | cenário "Consultar o detalhe do projeto durante a alocação" |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Papel | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| Consultar Alocação de Avaliadores por Participante | acessório | SE | 6 | 18 | Complexo | 7 | 2026-02-28 |
| Consultar Avaliadores por Inscrição | acessório | SE | 4 | 10 | Complexo | 7 | 2026-02-28 |
| Alocar Avaliador à Inscrição | principal | EE | 2 | 3 | Simples | 3 | 2026-02-28 |

> No baseline, o processo elementar principal se chama *Incluir Avaliadores para Inscrição*; aqui leva o nome da feature, como pede o `global/SIZING.md` para o `principal`. O número é o do baseline. As duas consultas são acessórias: apresentam a lista de inscrições elegíveis e os avaliadores de cada inscrição, que a feature hospeda na sua tela para designar.

### Memória de cálculo

**Consultar Alocação de Avaliadores por Participante** — SE · ALR 6 · DER 18 · Complexo · 7 PF

```json
{"pe": "Consultar Alocação de Avaliadores por Participante",
 "alr": ["Alocação Avaliadores", "Usuário", "Avaliação de Inscrição", "Categoria", "Modalidade", "Inscrição"],
 "der": ["Premiação", "Etapa", "Grupo", "Total de Inscrições", "Participante", "Projeto", "Total avaliadores selecionados/necessários", "Localidade", "Categoria", "Modalidade", "Tipo de Participante", "Avaliador", "E-mail avaliador", "Total avaliações alocadas", "Total avaliações em andamento", "Total avaliações finalizadas", "Ação", "Mensagem"]}
```

Por que cada ALR:
1. `Alocação Avaliadores` — o pool do grupo de cada inscrição, de onde saem os avaliadores designáveis (regra 2)
2. `Usuário` — os avaliadores, com e-mail, e o recorte de UFs do administrador regional (regra 6)
3. `Avaliação de Inscrição` — os avaliadores já designados a cada inscrição e os totais de avaliações alocadas, em andamento e finalizadas
4. `Categoria` — a categoria que compõe o grupo da inscrição (regra 7)
5. `Modalidade` — a modalidade que compõe o grupo da inscrição (regra 7)
6. `Inscrição` — as inscrições elegíveis da etapa, com participante, projeto e localidade (regras 1 e 8)

**Consultar Avaliadores por Inscrição** — SE · ALR 4 · DER 10 · Complexo · 7 PF

```json
{"pe": "Consultar Avaliadores por Inscrição",
 "alr": ["Premiação", "Categoria", "Modalidade", "Tipo Participante"],
 "der": ["Participante", "Projeto", "Etapa", "Localidade", "Avaliador", "E-mail avaliador", "Total avaliações alocadas", "Total avaliações em andamento", "Total avaliações finalizadas", "Ação"]}
```

Por que cada ALR:
1. `Premiação` — a etapa selecionada e a quantidade de avaliadores esperada por inscrição (regra 3)
2. `Categoria` — compõe o grupo da inscrição, que delimita os avaliadores oferecidos (regras 2 e 7)
3. `Modalidade` — compõe o grupo da inscrição (regras 2 e 7)
4. `Tipo Participante` — o tipo de participante e a submodalidade que completam o grupo (regra 7)

⚠️ Os avaliadores e os totais de avaliações enumerados como DER vêm do pool e das avaliações já designadas, arquivos que a planilha não enumera neste processo. Ficou o número da planilha — com ALR 4 a SE já está na faixa mais alta, sem efeito na complexidade; a divergência vai à equipe de métricas.

**Alocar Avaliador à Inscrição** — EE · ALR 2 · DER 3 · Simples · 3 PF

```json
{"pe": "Alocar Avaliador à Inscrição",
 "alr": ["Premiação", "Alocação Avaliadores"],
 "der": ["ID Avaliador", "Ação", "Mensagem"]}
```

Por que cada ALR:
1. `Premiação` — a etapa e a quantidade esperada de avaliadores por inscrição, que dá a situação da alocação (regras 3 e 9)
2. `Alocação Avaliadores` — a designação de avaliadores à inscrição, limitada ao pool do grupo (regra 2)

⚠️ No data-model, a designação etapa × inscrição × avaliador é gravada em `Avaliação de Inscrição` — a retirada desativa as notas, subgrupo do mesmo arquivo (regra 5) —, enquanto `Alocação Avaliadores` é o pool por grupo, lido para limitar os designáveis. Se a planilha quis dizer o pool, falta o arquivo gravado, e ALR 3 com DER 3 leva a EE de Simples (3 PF) a Médio (4 PF). Ficou o número da planilha; a divergência vai à equipe de métricas junto com o questionamento do baseline.

**Total: 17 PF** (3 processos elementares).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0. Estrutura: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, Gherkin com `Feature:`. Redação: segundo parágrafo da Descrição (como se usa); `## Origem` com o que a feature realiza da HU, que não numera critérios, e do ticket; coluna Entidade em `## Campos`; `## Derivações` (grupo); `## Dados lidos e gravados`; coluna Papel e memória de cálculo em bloco JSON, com o processo elementar principal levando o nome da feature e as duas consultas como acessórias. Sem mudança de regra, cenário ou número de PF |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (3 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-02 | Protótipo (docqui) | Vínculo corrigido | A linha dizia **n/a** embora a feature já estivesse desenhada em `prototypes/avaliacao/alocacao/flow.html` desde a geração daquele fluxo — o manifesto registrava o vínculo e este N3 não. Fidelidade passa a **referência** |
| 2026-09-01 | Decisões de produto (docqui) | Regra confirmada | Decidido que o drawer "Projeto" **reaproveita** a visão de `VAL-ANA-01` Detalhar Inscrição: a RN10 passa a referenciá-la como definição única do detalhe da inscrição, em vez de descrever um conteúdo paralelo |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-28 | Impacto SP05 (docqui) | Feature alterada | Detalhe do projeto consultável durante a alocação (drawer "Projeto") e recortes por grupo, estado (com Nacional) e situação da alocação; situação da alocação com valores explícitos; elegibilidade das etapas seguintes alinhada ao classificado |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-025 |

---

*Feature Set: Alocação de Avaliadores · Major Feature Set: Avaliação · Última revisão: 2026-10-04*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
