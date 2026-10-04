---
id: AVL-PAI-02
feature_set: AVL-PAI
dominio: AVL
entidade: Avaliação de Inscrição
prioridade: P1
mvp: true
data_model_ref: data-models/avaliacao.md#avaliacao-de-inscricao
endpoints: []
error_codes: []
depende_de: [AVL-PAI-01]
estado: rascunho
gates:
  requisitos:   { aprovado: false, por: "", em: "", pr: "" }
  modelo-dados: { aprovado: false, por: "", em: "", pr: "" }
  testes:       { aprovado: false, por: "", em: "", pr: "" }
  codigo:       { aprovado: false, por: "", em: "", pr: "" }
---

# Consultar Avaliações por Etapa
> **Nível 3** - Feature Set: Painel Administrativo de Avaliações — Domínio: Avaliação - `AVL-PAI-02`
> **Prioridade**: P1 · **MVP**: sim

## Descrição
Permite ao administrador consultar o detalhe de uma inscrição em uma etapa, reunindo os avaliadores alocados, o parecer individual de cada um e as notas por questão, como base para a consolidação.

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/avaliacao-admin/avaliacoes/:inscricaoId/etapa/:etapaId` (Detalhe da Avaliação)

**Fidelidade ao protótipo**: referência — `prototypes/avaliacao/painel-administrativo/flow.html`

---

</div>

## Regras de negócio

1. O detalhe reúne os avaliadores alocados para a inscrição na etapa, cada um com seu status individual: A iniciar, Em andamento e Finalizada.
2. O parecer individual de cada avaliador tem no mínimo 50 caracteres e é somente leitura para o administrador.
3. A conferência das notas relaciona, para cada questão do questionário, a nota atribuída por cada avaliador e o peso da questão.
4. A média ponderada de cada avaliador resulta das notas por questão e dos respectivos pesos.
5. A confidencialidade configurada na premiação não se aplica ao administrador; quando ela está ativa, a identidade dos avaliadores é apresentada como "Avaliador N".

---

## Cenários

```gherkin
# ← MESSAGE-DICTIONARY: BASELINE

# ── Caminho feliz ──────────────────────────────────────────────

Scenario: Consultar o detalhe da avaliação
  Given que selecionei uma inscrição em uma etapa
  When abro o detalhe da avaliação
  Then o sistema apresenta os avaliadores alocados com status, datas e média ponderada individual

Scenario: Consultar o parecer individual de um avaliador
  Given que estou no detalhe da avaliação
  When consulto o avaliador finalizado
  Then o sistema apresenta o parecer individual escrito por ele e as notas por questão

# ── Estados especiais ──────────────────────────────────────────

Scenario: Conferir as notas por questão
  Given que estou no detalhe da avaliação
  When abro a conferência de notas
  Then o sistema apresenta, para cada questão, a nota de cada avaliador e o peso da questão

Scenario: Consultar avaliação com premiação confidencial
  Given que a premiação está configurada como confidencial
  When consulto o detalhe da avaliação
  Then o sistema apresenta os avaliadores como "Avaliador N" e mantém visíveis os pareceres e as notas

# ── Restrições de acesso ───────────────────────────────────────

Scenario: Usuário sem permissão de consulta
  Given que meu perfil não tem permissão para consultar avaliações
  When tento abrir o detalhe da avaliação
  Then o sistema bloqueia e exibe "Você não tem permissão para esta ação."
```

---

## Campos

| Label PO | Preenchimento | Tipo | Obrigatório | Validação |
|---|---|---|---|---|
| Identificação do participante | derivado da inscrição | texto (somente leitura) | — | identificador · protocolo, ou só o protocolo quando não há identificador |
| Premiação · Categoria · Modalidade | derivado da inscrição | texto (somente leitura) | — | categoria e modalidade apenas quando preenchidas |
| Etapa atual | derivado da avaliação | texto (somente leitura) | — | ordem e nome da etapa |
| Avaliadores (finalizados / alocados) | derivado (contagem) | texto (somente leitura) | — | indica se todos finalizaram |

---

## Colunas do resultado

| Coluna (Label PO) | Origem | Ordenação |
|---|---|---|
| Avaliador | Avaliação de Inscrição | padrão ↑ |
| Status | Avaliação de Inscrição | ordenável |
| Início da avaliação | Avaliação de Inscrição | — |
| Finalização da avaliação | Avaliação de Inscrição | — |
| Média ponderada | derivado (notas × pesos) | — |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| — | — | — |

---

## Comportamento de tela

### Onde fica
Página de detalhe em `/avaliacao-admin/avaliacoes/:inscricaoId/etapa/:etapaId`: cabeçalho com a identificação e as métricas de etapa, avaliadores e consolidação, uma aba somente leitura por avaliador com o parecer e as notas, e a conferência de notas por questão aberta sob demanda.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Exibe "Carregando…" enquanto o detalhe é recuperado |
| Erro de validação | Não se aplica (consulta somente leitura) |
| Erro de servidor | Exibe "Não foi possível carregar os dados." |
| Sucesso | Apresenta os avaliadores, os pareceres e as notas por questão |
| Empty state | Etapa sem avaliadores alocados: "Nenhum registro encontrado." |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | O detalhe lista os avaliadores alocados com status, datas e média ponderada individual | cenário "Consultar o detalhe da avaliação" |
| SC-02 | A conferência de notas mostra a nota de cada avaliador por questão com o peso da questão | cenário "Conferir as notas por questão" |
| SC-03 | Em premiação confidencial, os avaliadores aparecem como "Avaliador N" sem ocultar pareceres e notas ao administrador | cenário "Consultar avaliação com premiação confidencial" |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Consultar Avaliações por Etapa | SE | 3 | 5 | Simples | 4 | 2026-02-28 |
| Visualizar Avaliações | SE | 6 | 20 | Complexo | 7 | 2026-02-28 |

### Memória de cálculo

- **Consultar Avaliações por Etapa** — ALR (3): Alocação Avaliadores · Usuário · Inscrição. DER (5): Avaliador · Data/hora finalização · Qtd de questões · Status · Ação.

```json
{"pe": "Consultar Avaliações por Etapa",
 "alr": ["Alocação Avaliadores", "Usuário", "Inscrição"],
 "der": ["Avaliador", "Data/hora finalização", "Qtd de questões", "Status", "Ação"]}
```
- **Visualizar Avaliações** — ALR (6): Inscrição · Premiação · Alocação Avaliadores · Usuário · Avaliação de Inscrição · Tipo de Participante. DER (20): Inscrição · Premiação · Modalidade · Categoria · Etapa atual · Qtd avaliações finalizadas/total avaliações · Status da consolidação · Inicial Avaliador · Número Avaliador · Nome Avaliador · Status avaliação · Qtd questões · Nota da questão · Número questão · Descrição questão · Feedback · Feedback consolidado · Status feedback consolidado · Ação · Mensagem.

```json
{"pe": "Visualizar Avaliações",
 "alr": ["Inscrição", "Premiação", "Alocação Avaliadores", "Usuário", "Avaliação de Inscrição", "Tipo de Participante"],
 "der": ["Inscrição", "Premiação", "Modalidade", "Categoria", "Etapa atual", "Qtd avaliações finalizadas/total avaliações", "Status da consolidação", "Inicial Avaliador", "Número Avaliador", "Nome Avaliador", "Status avaliação", "Qtd questões", "Nota da questão", "Número questão", "Descrição questão", "Feedback", "Feedback consolidado", "Status feedback consolidado", "Ação", "Mensagem"]}
```

**Total: 11 PF** (2 processos elementares).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (2 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-02 | Protótipo (docqui) | Vínculo corrigido | A linha dizia **n/a** embora a feature já estivesse desenhada em `prototypes/avaliacao/painel-administrativo/flow.html` desde a geração daquele fluxo — o manifesto registrava o vínculo e este N3 não. Fidelidade passa a **referência** |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-027 |

---

*Feature Set: Painel Administrativo de Avaliações · Domínio: Avaliação · Última revisão: 2026-08-27*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
