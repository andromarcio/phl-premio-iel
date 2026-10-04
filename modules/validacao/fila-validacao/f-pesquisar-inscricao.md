<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: VAL-FIL-01
feature_set: VAL-FIL
dominio: VAL
entidade: Inscrição
data_model_ref: data-models/inscricao.md#inscricao
endpoints: []
error_codes: []
depende_de: []
origem:
  tipo: issue
  chave: HU-017_Listar_Inscricoes_Validacao
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

# Pesquisar Inscrições para Validação
> **Nível 3** - Feature Set: Fila e Painel de Validação — Major Feature Set: Validação - `VAL-FIL-01`

## Descrição
Permite ao validador pesquisar as inscrições submetidas para validação por unidade federativa, premiação, categoria, modalidade, tipo de participante e situação, listando os resultados para conferência e análise.

No menu Premiação › Validação de Inscrições, o validador escolhe os filtros em cascata — como UF, premiação e situação — ou aciona um card de contagem por situação, e na tabela paginada abre o detalhe de cada inscrição numa nova aba.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-017_Listar_Inscricoes_Validacao`](../../../hus/HU-017_Listar_Inscricoes_Validacao.docx) | Criação | — filtros em cascata com a UF obrigatória para o administrador regional, cards de contagem por situação com filtro rápido, tabela paginada de 10, 20 ou 50 registros, a UF "Nacional" para a inscrição sem UF e o detalhe aberto numa nova aba |
| [`PDTIC25093-56`](../../../analise-impacto/AIM-PDTIC25093-56.md) | Alteração | — ponto de entrada do Relatório Geral de Inscrições na fila, oculto para quem não acessa os relatórios administrativos |

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/validacao-inscricao/inscricoes` (Fila de Validação)

**Fidelidade ao protótipo**: referência — `prototypes/validacao/fila-validacao/flow.html`

---

</div>

## Regras de negócio

1. A pesquisa de inscrições fica restrita às unidades federativas a que o validador está vinculado; quando há uma única unidade vinculada, esse recorte é aplicado automaticamente.
2. A seleção de categoria considera apenas as categorias da premiação escolhida, e a de modalidade, apenas as modalidades da categoria escolhida.
3. Uma inscrição não vinculada a nenhuma unidade federativa é classificada como Nacional.
4. A pesquisa alcança inscrições em qualquer situação de validação: Finalizada, Em Validação, Validada, Rejeitada, Aguardando Ajuste e Ajustes Concluídos.

---

## Cenários

```gherkin
Feature: Pesquisar Inscrições para Validação

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Listar as inscrições submetidas para validação
    Given que existem inscrições submetidas nas unidades a que estou vinculado
    When acesso a Fila de Validação
    Then o sistema exibe as inscrições com protocolo, premiação, categoria, modalidade, tipo de participante, UF, situação e data

  Scenario: Pesquisar por premiação e situação
    Given que estou na Fila de Validação
    When seleciono uma premiação e as situações "Finalizada" e "Aguardando Ajuste"
    Then o sistema exibe apenas as inscrições daquela premiação nessas situações

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Recorte por unidade única aplicado automaticamente
    Given que estou vinculado a uma única unidade federativa
    When acesso a Fila de Validação
    Then o sistema exibe apenas as inscrições daquela unidade sem exigir a escolha da UF

  Scenario: Inscrição sem unidade federativa
    Given que existe uma inscrição não vinculada a nenhuma unidade federativa
    When ela consta no resultado
    Then o sistema apresenta a UF como "Nacional"

  Scenario: Pesquisa sem resultados
    Given que nenhuma inscrição corresponde ao recorte informado
    When realizo a pesquisa
    Then o sistema exibe "Nenhum resultado para a busca."

  # ── Restrições de acesso ───────────────────────────────────────

  # O conteúdo do Relatório Geral de Inscrições é especificado em AVL-APU-10 — está fora do escopo desta feature.
  Scenario: Abrir o Relatório Geral de Inscrições a partir da fila
    Given que meu perfil tem acesso aos relatórios administrativos
    When aciono "Relatório de Inscrições" na Fila de Validação
    Then o sistema abre o Relatório Geral de Inscrições

  Scenario: Perfil sem acesso aos relatórios administrativos
    Given que meu perfil não tem acesso aos relatórios administrativos
    When acesso a Fila de Validação
    Then o sistema não oferece as ações "Relatório de Inscrições" e "Inscrições Paradas"
```

---

## Campos

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| UF | Unidade Federativa | entrada do usuário | editável | lista (unidades federativas) | condicional | obrigatória para o validador regional; restrita às unidades a que está vinculado |
| Premiação | Premiação | entrada do usuário | editável | lista (premiações) | não | — |
| Categoria | Categoria | entrada do usuário | editável | lista (categorias da premiação) | não | habilitada após escolher a premiação |
| Modalidade | Modalidade | entrada do usuário | editável | lista (modalidades da categoria) | não | habilitada após escolher a categoria |
| Tipo de participante | Tipo de Participante | entrada do usuário | editável | lista (tipos de participante) | não | — |
| Situação | dado de código | entrada do usuário | editável | seleção múltipla (Finalizada, Em Validação, Validada, Rejeitada, Aguardando Ajuste, Ajustes Concluídos) | não | permite selecionar mais de uma situação |

---

## Colunas do resultado

| Coluna (Label PO) | Origem | Ordenação |
|---|---|---|
| Protocolo | Inscrição | — |
| Premiação | Inscrição → Premiação | — |
| Categoria | Inscrição → Categoria | — |
| Modalidade | Inscrição → Modalidade | — |
| Tipo de participante | Inscrição → Tipo de Participante | — |
| UF | Inscrição → Unidade Federativa | ordenável |
| Situação | Inscrição | ordenável |
| Data | Inscrição (data de finalização) | padrão ↓ |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| — | — | — |

---

## Dados lidos e gravados

| Entidade | Papel | Por que a feature a toca |
|---|---|---|
| Inscrição | lê | A fila lista as inscrições submetidas em qualquer situação de validação, com protocolo, situação e data, e conta as inscrições por situação nos cards (regras 3 e 4; `## Colunas do resultado`) |

---

## Comportamento de tela

### Onde fica
Página própria em `/validacao-inscricao/inscricoes` (Fila de Validação): filtros em cascata (UF, premiação, categoria, modalidade, tipo de participante e situação), cards KPI de contagem por situação que aplicam um recorte rápido ao serem acionados, tabela paginada (10, 20 ou 50 registros) e o botão de acesso ao Dashboard Gerencial de Validação. A barra de ações traz ainda os pontos de entrada dos relatórios administrativos — "Relatório de Inscrições", que abre o Relatório Geral de Inscrições (`AVL-APU-10`), e "Inscrições Paradas", que abre o relatório de `AVL-APU-06` —, ocultos para quem não tem acesso aos relatórios administrativos. ⚠️ *(restrição ao Administrador Nacional — recurso APIPIT.22 — é decisão de produto pendente; a matriz vive no N2)* A ação de visualização (ícone de olho) abre o detalhe da inscrição em uma nova aba. ⚠️ *(os cards "Pendentes" e "Aprovadas" citados na HU-017 não correspondem diretamente às situações do modelo — confirmar o mapeamento: "Pendentes" = Finalizada e "Aprovadas" = Validada.)*

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Exibe "Carregando…" enquanto a lista é recuperada |
| Erro de validação | Não se aplica (os filtros são opcionais, exceto a UF do validador regional) |
| Erro de servidor | Exibe "Não foi possível carregar os dados." |
| Sucesso | Exibe a lista de inscrições correspondentes ao recorte |
| Empty state | Sem inscrições na fila: "Nenhum registro encontrado."; pesquisa sem resultado: "Nenhum resultado para a busca." |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | A fila lista as inscrições com os filtros em cascata e a UF obrigatória para o validador regional | Critério de aceite (HU-017) |
| SC-02 | Os cards KPI de contagem por situação aplicam o recorte rápido correspondente | cenário "Pesquisar por premiação e situação" |
| SC-03 | Uma inscrição sem unidade federativa é apresentada como "Nacional" | cenário "Inscrição sem unidade federativa" |
| SC-04 | O acesso ao Relatório Geral de Inscrições a partir da fila é oferecido apenas aos perfis com acesso aos relatórios administrativos | cenário "Perfil sem acesso aos relatórios administrativos" |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Papel | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| Pesquisar Inscrições para Validação | principal | SE | 5 | 14 | Complexo | 7 | 2026-02-28 |

> No baseline, o processo elementar se chama *Consultar Dashboard Validação de Inscrições*; aqui leva o nome da feature, como pede o `global/SIZING.md` para o `principal`. O número é o do baseline.

### Memória de cálculo

**Pesquisar Inscrições para Validação** — SE · ALR 5 · DER 14 · Complexo · 7 PF

```json
{"pe": "Pesquisar Inscrições para Validação",
 "alr": ["Inscrição", "Premiação", "Categoria", "Modalidade", "Tipo de Participante"],
 "der": ["Qtd Inscrições", "Status Inscrição", "Percentual Inscritos por Status", "UF (filtro)", "Premiação", "Categoria", "Modalidade", "Tipo Participante", "Status", "Protocolo", "UF (coluna)", "Data Finalização", "Ação", "Mensagem"]}
```

Por que cada ALR:
1. `Inscrição` — a pesquisa lista as inscrições do recorte e conta as inscrições por situação nos cards
2. `Premiação` — filtro e coluna da premiação da inscrição
3. `Categoria` — filtro em cascata e coluna da categoria da inscrição
4. `Modalidade` — filtro em cascata e coluna da modalidade da inscrição
5. `Tipo de Participante` — filtro e coluna do tipo de participante da inscrição

⚠️ A planilha conta *UF* duas vezes — no filtro e na coluna da tabela; aqui cada um leva entre parênteses o lugar onde aparece. Pelo CPM o mesmo DER conta uma vez; mantido como o baseline contou, a confirmar com a equipe de métricas.

⚠️ A UF do filtro e da coluna vem da Unidade Federativa, do arquivo lógico Usuário (coluna Entidade de `## Campos`), que a planilha não enumera. Ficou o número da planilha; a divergência vai à equipe de métricas.

⚠️ As listas dos filtros Premiação, Categoria, Modalidade e Tipo de participante são, no baseline, processos elementares próprios — *Consultar Premiação (combo)*, *Consultar Categoria por Premiação (combo)*, *Consultar Modalidade por Categoria (combo)* e *Consultar Tipo de Participante por Modalidade (combo)*, 3 PF cada —, contados na planilha sob a HU-017, a desta tela, e registrados em `global/SIZING.md` entre os PE sem feature. Pela *Regra da lista consultada* seriam acessórios desta feature, dona da tela; a decisão de trazê-los para cá é da equipe de métricas.

**Total: 7 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0. Estrutura: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, Gherkin com `Feature:`. Redação: segundo parágrafo da Descrição (como se usa), critérios da HU e do ticket na `## Origem` (nenhum dos dois numera critérios: `—` e a prosa do que a feature realiza), coluna Entidade em `## Campos`, `## Dados lidos e gravados`, coluna Papel e memória de cálculo em bloco JSON, com o processo elementar principal levando o nome da feature (no baseline, *Consultar Dashboard Validação de Inscrições*), o DER *UF* repetido desambiguado e o porquê de cada ALR. Sem mudança de regra, cenário ou número de PF |
| 2026-09-02 | Protótipo (docqui) | Vínculo corrigido | A linha dizia **n/a** embora a feature já estivesse desenhada em `prototypes/validacao/fila-validacao/flow.html` desde a geração daquele fluxo — o manifesto registrava o vínculo e este N3 não. Fidelidade passa a **referência** |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-28 | Impacto SP05 (docqui) | Feature alterada | Ponto de entrada do Relatório Geral de Inscrições na fila, oculto para quem não acessa relatórios administrativos (APIPIT.22) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-017 |

---

*Feature Set: Fila e Painel de Validação · Major Feature Set: Validação · Última revisão: 2026-10-04*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
