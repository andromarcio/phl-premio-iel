---
id: VAL-FIL-01
feature_set: VAL-FIL
dominio: VAL
entidade: Inscrição
prioridade: P1
mvp: true
data_model_ref: data-models/inscricao.md#inscricao
endpoints: []
error_codes: []
depende_de: []
estado: rascunho
gates:
  requisitos:   { aprovado: false, por: "", em: "", pr: "" }
  modelo-dados: { aprovado: false, por: "", em: "", pr: "" }
  testes:       { aprovado: false, por: "", em: "", pr: "" }
  codigo:       { aprovado: false, por: "", em: "", pr: "" }
---

# Pesquisar Inscrições para Validação
> **Nível 3** - Feature Set: Fila e Painel de Validação — Domínio: Validação - `VAL-FIL-01`
> **Prioridade**: P1 · **MVP**: sim

## Descrição
Permite ao validador pesquisar as inscrições submetidas para validação por unidade federativa, premiação, categoria, modalidade, tipo de participante e situação, listando os resultados para conferência e análise.

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

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| UF | entrada do usuário | editável | lista (unidades federativas) | condicional | obrigatória para o validador regional; restrita às unidades a que está vinculado |
| Premiação | entrada do usuário | editável | lista (premiações) | não | — |
| Categoria | entrada do usuário | editável | lista (categorias da premiação) | não | habilitada após escolher a premiação |
| Modalidade | entrada do usuário | editável | lista (modalidades da categoria) | não | habilitada após escolher a categoria |
| Tipo de participante | entrada do usuário | editável | lista (tipos de participante) | não | — |
| Situação | entrada do usuário | editável | seleção múltipla (Finalizada, Em Validação, Validada, Rejeitada, Aguardando Ajuste, Ajustes Concluídos) | não | permite selecionar mais de uma situação |

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

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Consultar Dashboard Validação de Inscrições | SE | 5 | 14 | Complexo | 7 | 2026-02-28 |

### Memória de cálculo

- **Consultar Dashboard Validação de Inscrições** — ALR (5): Inscrição · Premiação · Categoria · Modalidade · Tipo de Participante. DER (14): Qtd Inscrições · Status Inscrição · Percentual Inscritos por Status · UF · Premiação · Categoria · Modalidade · Tipo Participante · Status · Protocolo · UF · Data Finalização · Ação · Mensagem.

**Total: 7 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-09-02 | Protótipo (docqui) | Vínculo corrigido | A linha dizia **n/a** embora a feature já estivesse desenhada em `prototypes/validacao/fila-validacao/flow.html` desde a geração daquele fluxo — o manifesto registrava o vínculo e este N3 não. Fidelidade passa a **referência** |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-28 | Impacto SP05 (docqui) | Feature alterada | Ponto de entrada do Relatório Geral de Inscrições na fila, oculto para quem não acessa relatórios administrativos (APIPIT.22) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-017 |

---

*Feature Set: Fila e Painel de Validação · Domínio: Validação · Última revisão: 2026-08-28*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
