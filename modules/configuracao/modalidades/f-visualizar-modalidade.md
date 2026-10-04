<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: CFG-MOD-04
feature_set: CFG-MOD
dominio: CFG
entidade: Modalidade
data_model_ref: data-models/configuracao.md#modalidade
endpoints: []
error_codes: []
depende_de: []
origem:
  tipo: issue
  chave: HU-005_Cadastrar_Modalidades
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

# Visualizar Modalidade
> **Nível 3** - Feature Set: Modalidades — Major Feature Set: Configuração da Premiação - `CFG-MOD-04`

## Descrição
Permite ao administrador consultar os dados de uma modalidade e as categorias e prêmios a que ela está vinculada, com o período de inscrição próprio de cada vínculo.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-005_Cadastrar_Modalidades`](../../../hus/HU-005_Cadastrar_Modalidades.docx) | Criação | — |

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/modalidades/:id/visualizar` (Detalhe da Modalidade)

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. A consulta está disponível inclusive para modalidades inativas.
2. Uma modalidade pode estar vinculada a várias categorias e prêmios, cada vínculo com o seu próprio período de inscrição e link de regulamento.

---

## Cenários

```gherkin
Feature: Visualizar Modalidade

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Ver os dados de uma modalidade
    Given que selecionei uma modalidade no catálogo
    When abro o detalhe da modalidade
    Then o sistema exibe o nome, a descrição e a situação da modalidade

  Scenario: Ver os vínculos da modalidade
    Given que estou no detalhe de uma modalidade
    When acesso a aba "Vínculos"
    Then o sistema exibe as categorias e os prêmios aos quais a modalidade está vinculada

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Modalidade sem vínculos
    Given que a modalidade não está vinculada a nenhuma categoria
    When acesso a aba "Vínculos"
    Then o sistema exibe "Nenhum registro encontrado."
```

---

## Campos

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Nome | Modalidade | somente leitura | texto | — | — |
| Descrição | Modalidade | somente leitura | texto longo | — | — |
| Situação | Modalidade | somente leitura | lista (Ativo, Inativo) | — | — |
| Categorias e prêmios vinculados | derivado | somente leitura | lista (categoria + prêmio + situação do vínculo) | — | — |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| — | — | — |

---

## Comportamento de tela

### Onde fica
Página de detalhe em `/modalidades/:id/visualizar`, com a aba "Dados Gerais" (nome, descrição, situação) e a aba "Vínculos" (categorias e prêmios vinculados).

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Exibe "Carregando…" enquanto os dados são recuperados |
| Erro de validação | Não se aplica |
| Erro de servidor | Exibe "Não foi possível carregar os dados." |
| Sucesso | Exibe os dados da modalidade e a aba de vínculos |
| Empty state | Aba de vínculos sem categorias: "Nenhum registro encontrado." |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | O detalhe exibe nome, descrição e situação da modalidade | cenário "Ver os dados de uma modalidade" |
| SC-02 | A aba de vínculos exibe as categorias e prêmios vinculados | Critério de aceite 6 (HU-005) |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Detalhar Modalidade | — | — | — | — | 0 | 2026-02-28 |

### Memória de cálculo

- **Detalhar Modalidade** — ALR (0): —. DER (0): —.

**Total: 0 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Estrutura atualizada | Artefato regenerado com o engine 4.1.0: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, `## Origem` com a HU e os tickets das AIMs, Gherkin com `Feature:` |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-005 |

---

*Feature Set: Modalidades · Major Feature Set: Configuração da Premiação · Última revisão: 2026-08-27*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
