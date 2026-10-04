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

No Construtor de Questionário, o administrador aciona a edição de uma questão da lista, altera no diálogo o que quiser — como enunciado, peso ou alternativas — e salva.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-010_Questoes_Tipo_Participante`](../../../hus/HU-010_Questoes_Tipo_Participante.docx) | Criação | `CA-3, CA-5, CA-6, CA-8` — nova posição da questão refletida na gravação; enunciado preenchido também na edição; troca de objetiva para discursiva que descarta as alternativas; peso maior ou igual a zero, aceitando zero |

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

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Enunciado | Questão de Avaliação | entrada do usuário | editável | texto longo | sim | texto da questão |
| Tipo de questão | Tipo de Questão | entrada do usuário | editável | lista (Discursiva, Objetiva) | sim | ao mudar para discursiva, as alternativas são descartadas |
| Peso da nota | Questão de Avaliação | entrada do usuário | editável | número decimal | não | maior ou igual a zero |
| Obrigatório | Questão de Avaliação | entrada do usuário | editável | booleano | não | se o avaliador deve responder |
| Limite de caracteres | Questão de Avaliação | entrada do usuário | editável | número | não | apenas para questão discursiva |
| Alternativas | Alternativa da Questão | entrada do usuário | editável | lista de textos | condicional | apenas para questão objetiva; duas ou mais |
| Ordem | Questão de Avaliação | entrada do usuário | editável | número | não | posição da questão no questionário |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| — | — | — |

---

## Dados lidos e gravados

| Entidade | Papel | Por que a feature a toca |
|---|---|---|
| Questionário | lê | A posição da questão é a ordem dentro do questionário do tipo de participante (regra 3) |
| Premiação | lê | O diálogo de edição abre no nó do tipo de participante, dentro da premiação (ALR da consulta implícita) |
| Categoria | lê | O diálogo de edição abre no nó do tipo de participante, sob a categoria (ALR da consulta implícita) |
| Modalidade | lê | O diálogo de edição abre no nó do tipo de participante, sob a modalidade (ALR da consulta implícita) |

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

| Função de Transação | Papel | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| Consultar Questão do Questionário Avaliação (implícita) | acessório | CE | 4 | 8 | Complexo | 6 | 2026-02-28 |
| Editar Questão | principal | EE | 1 | 9 | Simples | 3 | 2026-02-28 |

> No baseline, o processo elementar principal se chama *Editar Questão do Questionário Avaliação*; aqui leva o nome da feature, como pede o `global/SIZING.md` para o `principal`. O número é o do baseline.

### Memória de cálculo

**Consultar Questão do Questionário Avaliação (implícita)** — CE · ALR 4 · DER 8 · Complexo · 6 PF

```json
{"pe": "Consultar Questão do Questionário Avaliação (implícita)",
 "alr": ["Premiação", "Categoria", "Modalidade", "Tipo Participante"],
 "der": ["Titulo", "Enunciado", "Descrição", "Obrigatória", "Peso / Nota", "Limite de caracteres", "Alternativas", "Ação"]}
```

Por que cada ALR:
1. `Premiação` — o diálogo de edição abre no nó do tipo de participante, dentro da premiação
2. `Categoria` — o diálogo abre sob a categoria do nó
3. `Modalidade` — o diálogo abre sob a modalidade do nó
4. `Tipo Participante` — o diálogo abre preenchido com a questão e as suas alternativas, que a lista do construtor não mostra por inteiro

**Editar Questão** — EE · ALR 1 · DER 9 · Simples · 3 PF

```json
{"pe": "Editar Questão",
 "alr": ["Tipo Participante"],
 "der": ["Titulo", "Enunciado", "Descrição", "Obrigatória", "Peso / Nota", "Limite de caracteres", "Alternativas", "Ação", "Mensagem"]}
```

Por que cada ALR:
1. `Tipo Participante` — a transação grava a questão alterada e as suas alternativas; questão e alternativa são subgrupos do mesmo arquivo lógico

⚠️ Nos dois processos a planilha conta *Titulo* e *Descrição*, que o N3 não traz em `## Campos`, e não conta o *Tipo de questão* nem a *Ordem*, que o N3 traz. A divergência entre a tela documentada e a medida vai à equipe de métricas.

**Total: 9 PF** (2 processos elementares).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0. Estrutura: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, Gherkin com `Feature:`. Redação: segundo parágrafo da Descrição (como se usa), critérios `CA-n` da HU na `## Origem`, coluna Entidade em `## Campos`, `## Dados lidos e gravados`, coluna Papel e memória de cálculo em bloco JSON, com o processo elementar principal levando o nome da feature. Sem mudança de regra, cenário ou número de PF |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (2 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-010 |

---

*Feature Set: Tipos de Participante · Major Feature Set: Configuração da Premiação · Última revisão: 2026-10-04*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
