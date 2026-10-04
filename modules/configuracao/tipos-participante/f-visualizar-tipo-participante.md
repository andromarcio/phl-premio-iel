<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: CFG-TIP-04
feature_set: CFG-TIP
dominio: CFG
entidade: Tipo de Participante
data_model_ref: data-models/configuracao.md#tipo-de-participante
endpoints: []
error_codes: []
depende_de: []
origem:
  tipo: issue
  chave: HU-006_Cadastrar_Tipo_Participantes
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

# Visualizar Tipo de Participante
> **Nível 3** - Feature Set: Tipos de Participante — Major Feature Set: Configuração da Premiação - `CFG-TIP-04`

## Descrição
Permite ao administrador consultar os dados de um tipo de participante, seus vínculos e o resumo dos recursos de inscrição e avaliação já configurados.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-006_Cadastrar_Tipo_Participantes`](../../../hus/HU-006_Cadastrar_Tipo_Participantes.docx) | Criação | — |

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/tipos-participante/:id/visualizar` (Detalhe do Tipo de Participante)

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. A consulta está disponível inclusive para tipos de participante inativos.
2. O resumo de recursos é somente leitura: a configuração de cada recurso acontece nas features próprias de estrutura.

---

## Cenários

```gherkin
Feature: Visualizar Tipo de Participante

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Ver os dados de um tipo de participante
    Given que selecionei um tipo de participante no catálogo
    When abro o detalhe do tipo
    Then o sistema exibe o nome, a descrição, a situação e a opção de inscrição em equipe

  Scenario: Ver o resumo de recursos configurados
    Given que estou no detalhe de um tipo de participante
    When acesso a aba "Recursos"
    Then o sistema exibe o resumo do formulário de inscrição, dos enquadramentos, do questionário e dos anexos exigidos

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Tipo de participante sem vínculos
    Given que o tipo de participante não está vinculado a nenhuma modalidade ou categoria
    When acesso a aba "Vínculos"
    Then o sistema exibe "Nenhum registro encontrado."
```

---

## Campos

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Nome | Tipo de Participante | somente leitura | texto | — | — |
| Descrição | Tipo de Participante | somente leitura | texto longo | — | — |
| Situação | Tipo de Participante | somente leitura | lista (Ativo, Inativo) | — | — |
| Permite equipe | Tipo de Participante | somente leitura | booleano (sim/não) | — | — |
| Vínculos | derivado | somente leitura | lista (modalidade/categoria/prêmio) | — | — |
| Resumo de recursos | derivado | somente leitura | resumo (formulário, enquadramentos, questionário, anexos) | — | — |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| — | — | — |

---

## Comportamento de tela

### Onde fica
Página de detalhe em `/tipos-participante/:id/visualizar`, com a aba "Dados Gerais" (nome, descrição, situação, inscrição em equipe), a aba "Vínculos" (modalidades, categorias e prêmios) e a aba "Recursos" (resumo somente leitura da estrutura configurada).

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Exibe "Carregando…" enquanto os dados são recuperados |
| Erro de validação | Não se aplica |
| Erro de servidor | Exibe "Não foi possível carregar os dados." |
| Sucesso | Exibe os dados do tipo, seus vínculos e o resumo de recursos |
| Empty state | Aba de vínculos sem registros: "Nenhum registro encontrado." |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | O detalhe exibe nome, descrição, situação e opção de inscrição em equipe do tipo | cenário "Ver os dados de um tipo de participante" |
| SC-02 | A aba de recursos exibe o resumo do formulário, enquadramentos, questionário e anexos configurados | Critério de aceite 7 (HU-006) |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Detalhar Tipo de Participante | SE | — | — | — | 0 | 2026-02-28 |

### Memória de cálculo

- **Detalhar Tipo de Participante** — ALR (0): —. DER (0): —.

**Total: 0 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Estrutura atualizada | Artefato regenerado com o engine 4.1.0: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, `## Origem` com a HU e os tickets das AIMs, Gherkin com `Feature:` |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-006 |

---

*Feature Set: Tipos de Participante · Major Feature Set: Configuração da Premiação · Última revisão: 2026-08-27*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
