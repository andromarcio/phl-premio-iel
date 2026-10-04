<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: CFG-TIP-14
feature_set: CFG-TIP
dominio: CFG
entidade: Questão de Avaliação
data_model_ref: data-models/configuracao.md#questão-de-avaliação
endpoints: []
error_codes: []
depende_de: []
origem:
  tipo: issue
  chave: HU-010_Questoes_Tipo_Participante
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

# Editar Questão
> **Nível 3** - Feature Set: Tipos de Participante — Major Feature Set: Configuração da Premiação - `CFG-TIP-14`

## Descrição
Permite ao administrador editar uma questão já cadastrada no questionário de avaliação — alterando enunciado, peso, alternativas, limite de caracteres e posição — para manter o questionário do tipo de participante atualizado.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-010_Questoes_Tipo_Participante`](../../../hus/HU-010_Questoes_Tipo_Participante.docx) | Criação | — |

---

<div class="dev-only">

## Superfície

**Ação em tela** — origem: Construtor de Questionário (`/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(nó Tipo de Participante → aba **Avaliação**)*), a partir da edição de uma questão existente na lista.

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. Alterar o tipo de uma questão de objetiva para discursiva descarta suas alternativas.
2. O peso da questão permanece maior ou igual a zero após a edição.
3. A posição (ordem) da questão no questionário pode ser alterada.

---

## Cenários

```gherkin
Feature: Editar Questão

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Editar enunciado e peso
    Given que selecionei uma questão existente
    When altero o enunciado e o peso e clico em "Salvar"
    Then o sistema grava as alterações e exibe "Registro salvo com sucesso."

  # ── Erros de validação ─────────────────────────────────────────

  Scenario: Enunciado apagado na edição
    Given que estou editando uma questão
    When apago o enunciado e clico em "Salvar"
    Then o sistema não grava e exibe "Campo obrigatório."

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Mudar de objetiva para discursiva
    Given que edito uma questão objetiva com alternativas
    When altero o tipo para "Discursiva" e salvo
    Then o sistema descarta as alternativas da questão

  # ── Restrições de acesso ───────────────────────────────────────

  Scenario: Usuário sem permissão para editar questão
    Given que meu perfil não tem permissão para editar questões
    When tento editar uma questão
    Then o sistema bloqueia e exibe "Você não tem permissão para esta ação."
```

---

## Campos

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Enunciado | entrada do usuário | editável | texto longo | sim | texto da questão |
| Tipo de questão | entrada do usuário | editável | lista (Discursiva, Objetiva) | sim | ao mudar para discursiva, as alternativas são descartadas |
| Peso da nota | entrada do usuário | editável | número decimal | não | maior ou igual a zero |
| Obrigatório | entrada do usuário | editável | booleano | não | se o avaliador deve responder |
| Limite de caracteres | entrada do usuário | editável | número | não | apenas para questão discursiva |
| Alternativas | entrada do usuário | editável | lista de textos | condicional | apenas para questão objetiva; duas ou mais |
| Ordem | entrada do usuário | editável | número | não | posição da questão no questionário |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| — | — | — |

---

## Comportamento de tela

### Onde fica
Diálogo de questão aberto pelo Construtor de Questionário (`/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(nó Tipo de Participante → aba **Avaliação**)*) com os dados atuais preenchidos; ao trocar o tipo para Discursiva, os campos de alternativas deixam de ser exibidos.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Botão "Salvar" desabilitado com indicador enquanto grava |
| Erro de validação | Destaca o enunciado com "Campo obrigatório." |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Exibe "Registro salvo com sucesso." e reflete as alterações na lista do construtor |
| Empty state | Não se aplica |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | As alterações de enunciado, peso e demais propriedades da questão são persistidas | cenário "Editar enunciado e peso" |
| SC-02 | Mudar o tipo de objetiva para discursiva descarta as alternativas | Critério de aceite 6 (HU-010) |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Consultar Questão do Questionário Avaliação (implícita) | CE | 4 | 8 | Complexo | 6 | 2026-02-28 |
| Editar Questão do Questionário Avaliação | EE | 1 | 9 | Simples | 3 | 2026-02-28 |

### Memória de cálculo

- **Consultar Questão do Questionário Avaliação (implícita)** — ALR (4): Premiação · Categoria · Modalidade · Tipo Participante. DER (8): Titulo · Enunciado · Descrição · Obrigatória · Peso / Nota · Limite de caracteres · Alternativas · Ação.

```json
{"pe": "Consultar Questão do Questionário Avaliação (implícita)",
 "alr": ["Premiação", "Categoria", "Modalidade", "Tipo Participante"],
 "der": ["Titulo", "Enunciado", "Descrição", "Obrigatória", "Peso / Nota", "Limite de caracteres", "Alternativas", "Ação"]}
```
- **Editar Questão do Questionário Avaliação** — ALR (1): Tipo Participante. DER (9): Titulo · Enunciado · Descrição · Obrigatória · Peso / Nota · Limite de caracteres · Alternativas · Ação · Mensagem.

```json
{"pe": "Editar Questão do Questionário Avaliação",
 "alr": ["Tipo Participante"],
 "der": ["Titulo", "Enunciado", "Descrição", "Obrigatória", "Peso / Nota", "Limite de caracteres", "Alternativas", "Ação", "Mensagem"]}
```

**Total: 9 PF** (2 processos elementares).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Estrutura atualizada | Artefato regenerado com o engine 4.1.0: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, `## Origem` com a HU e os tickets das AIMs, Gherkin com `Feature:` |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (2 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-010 |

---

*Feature Set: Tipos de Participante · Major Feature Set: Configuração da Premiação · Última revisão: 2026-08-27*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
