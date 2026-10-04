---
id: CFG-TIP-13
feature_set: CFG-TIP
dominio: CFG
entidade: Questão de Avaliação
prioridade: P1
mvp: true
data_model_ref: data-models/configuracao.md#questão-de-avaliação
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

# Cadastrar Questão
> **Nível 3** - Feature Set: Tipos de Participante — Domínio: Configuração da Premiação - `CFG-TIP-13`
> **Prioridade**: P1 · **MVP**: sim

## Descrição
Permite ao administrador cadastrar uma questão — discursiva ou objetiva — no questionário de avaliação do tipo de participante, com enunciado e peso, para padronizar a pontuação das inscrições pelos avaliadores.

---

<div class="dev-only">

## Superfície

**Ação em tela** — origem: Construtor de Questionário (`/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(nó Tipo de Participante → aba **Avaliação**)*), a partir do diálogo "Adicionar Questão".

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. Uma questão é discursiva ou objetiva.
2. Uma questão discursiva não tem alternativas e pode ter um limite de caracteres para a resposta.
3. Uma questão objetiva tem duas ou mais alternativas de resposta e não usa limite de caracteres.
4. O peso da questão é maior ou igual a zero; peso zero indica questão informativa, sem pontuação.
5. O questionário de um tipo de participante contém pelo menos uma questão.

---

## Cenários

```gherkin
# ← MESSAGE-DICTIONARY: BASELINE

# ── Caminho feliz ──────────────────────────────────────────────

Scenario: Cadastrar questão discursiva
  Given que acesso o cadastro de questão do questionário de um tipo de participante
  When seleciono o tipo "Discursiva", informo o enunciado e o peso 10 e salvo
  Then o sistema adiciona a questão ao questionário e exibe "Registro salvo com sucesso."

Scenario: Cadastrar questão objetiva com alternativas
  Given que estou no cadastro de questão
  When seleciono o tipo "Objetiva", informo o enunciado e duas ou mais alternativas e salvo
  Then o sistema adiciona a questão objetiva com suas alternativas

# ── Erros de validação ─────────────────────────────────────────

Scenario: Enunciado em branco
  Given que estou no cadastro de questão
  When deixo o enunciado em branco e clico em "Salvar"
  Then o sistema não registra e exibe "Campo obrigatório."

# ── Estados especiais ──────────────────────────────────────────

Scenario: Questão informativa com peso zero
  Given que informo o enunciado e o peso 0
  When clico em "Salvar"
  Then o sistema aceita a questão como informativa, sem pontuação

# ── Restrições de acesso ───────────────────────────────────────

Scenario: Usuário sem permissão para cadastrar questão
  Given que meu perfil não tem permissão para cadastrar questões
  When tento acessar o cadastro de questão
  Then o sistema bloqueia e exibe "Você não tem permissão para esta ação."
```

---

## Campos

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Enunciado | entrada do usuário | editável | texto longo | sim | texto da questão |
| Tipo de questão | entrada do usuário | editável | lista (Discursiva, Objetiva) | sim | define os demais campos aplicáveis |
| Peso da nota | entrada do usuário | editável | número decimal | não | maior ou igual a zero; padrão 1 |
| Obrigatório | entrada do usuário | editável | booleano | não | se o avaliador deve responder |
| Limite de caracteres | entrada do usuário | editável | número | não | apenas para questão discursiva |
| Alternativas | entrada do usuário | editável | lista de textos | condicional | apenas para questão objetiva; duas ou mais |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Situação | Ativa | Na criação da questão |
| Peso da nota | 1 | Quando não informado |
| Ordem | Próxima posição no questionário | Ao adicionar a questão |

---

## Comportamento de tela

### Onde fica
Diálogo de questão aberto pelo Construtor de Questionário (`/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(nó Tipo de Participante → aba **Avaliação**)*): um seletor Discursiva/Objetiva alterna os campos aplicáveis, e as questões adicionadas aparecem na lista do construtor.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Botão "Salvar" desabilitado com indicador enquanto grava |
| Erro de validação | Destaca o enunciado com "Campo obrigatório." |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Exibe "Registro salvo com sucesso." e inclui a questão na lista do construtor |
| Empty state | Questionário ainda sem questões: "Nenhum registro encontrado." |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | É possível cadastrar questões discursivas e objetivas | Critério de aceite 1 (HU-010) |
| SC-02 | Uma questão objetiva registra suas múltiplas alternativas | Critério de aceite 2 (HU-010) |
| SC-03 | Uma questão com peso zero é aceita como informativa | Critério de aceite 8 (HU-010) |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Consultar Questões do Questionário Avaliação | CE | 4 | 6 | Complexo | 6 | 2026-02-28 |
| Incluir Questão do Questionário Avaliação | EE | 1 | 9 | Simples | 3 | 2026-02-28 |

### Memória de cálculo

- **Consultar Questões do Questionário Avaliação** — ALR (4): Premiação · Categoria · Modalidade · Tipo Participante. DER (6): Título · Tipo · Peso · Tamanho · Qtd Alternativas · Ação.

```json
{"pe": "Consultar Questões do Questionário Avaliação",
 "alr": ["Premiação", "Categoria", "Modalidade", "Tipo Participante"],
 "der": ["Título", "Tipo", "Peso", "Tamanho", "Qtd Alternativas", "Ação"]}
```
- **Incluir Questão do Questionário Avaliação** — ALR (1): Tipo Participante. DER (9): Titulo · Enunciado · Descrição · Obrigatória · Peso / Nota · Limite de caracteres · Alternativas · Ação · Mensagem.

```json
{"pe": "Incluir Questão do Questionário Avaliação",
 "alr": ["Tipo Participante"],
 "der": ["Titulo", "Enunciado", "Descrição", "Obrigatória", "Peso / Nota", "Limite de caracteres", "Alternativas", "Ação", "Mensagem"]}
```

**Total: 9 PF** (2 processos elementares).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (2 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-010 |

---

*Feature Set: Tipos de Participante · Domínio: Configuração da Premiação · Última revisão: 2026-08-27*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
