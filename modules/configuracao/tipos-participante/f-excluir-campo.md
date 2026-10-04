<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: CFG-TIP-09
feature_set: CFG-TIP
dominio: CFG
entidade: Campo do Formulário
data_model_ref: data-models/configuracao.md#campo-do-formulário
endpoints: []
error_codes: []
depende_de: []
origem:
  tipo: issue
  chave: HU-007_Configurar_Formulario_Tipo_Participante
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

# Excluir Campo
> **Nível 3** - Feature Set: Tipos de Participante — Major Feature Set: Configuração da Premiação - `CFG-TIP-09`

## Descrição
Permite ao administrador excluir um campo do formulário de inscrição do tipo de participante — de forma definitiva quando o campo ainda não foi respondido, ou lógica quando já existem inscrições que o utilizaram, preservando o histórico.

No Construtor de Formulário, o administrador aciona a remoção de um campo na área de montagem e confirma a exclusão.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-007_Configurar_Formulario_Tipo_Participante`](../../../hus/HU-007_Configurar_Formulario_Tipo_Participante.docx) | Criação | `CA-7` — campo já respondido em inscrições existentes recebe exclusão lógica em vez de ser removido |

---

<div class="dev-only">

## Superfície

**Ação em tela** — origem: Construtor de Formulário (`/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(nó Tipo de Participante → aba **Formulário de Inscrição**)*), a partir da remoção de um campo no canvas, com confirmação.

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. Um campo ainda não utilizado por nenhuma inscrição pode ser excluído definitivamente.
2. Um campo já respondido em inscrições existentes não é removido fisicamente — passa à situação inativa, mantendo o vínculo com as respostas → ver RULES-DICTIONARY: RC-09 — Registro vinculado não pode ser excluído (entidade vinculada: inscrições; ação alternativa: exclusão lógica).
3. A exclusão de um campo preserva as respostas já registradas nas inscrições anteriores.

---

## Cenários

```gherkin
Feature: Excluir Campo

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Excluir campo ainda não utilizado
    Given que o campo selecionado não foi respondido em nenhuma inscrição
    When aciono a exclusão do campo e confirmo
    Then o sistema remove o campo definitivamente do formulário

  Scenario: Exclusão lógica de campo já respondido
    Given que o campo já foi respondido em inscrições existentes
    When aciono a exclusão do campo e confirmo
    Then o sistema passa o campo à situação inativa e mantém as respostas já registradas

  # ── Confirmação ────────────────────────────────────────────────

  Scenario: Confirmar antes de excluir
    Given que aciono a exclusão de um campo
    When o sistema pede confirmação
    Then o sistema exibe "Deseja realmente excluir este registro?"

  # ── Restrições de acesso ───────────────────────────────────────

  Scenario: Usuário sem permissão para excluir campo
    Given que meu perfil não tem permissão para excluir campos
    When tento excluir um campo
    Then o sistema bloqueia e exibe "Você não tem permissão para esta ação."
```

---

## Campos

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Campo | Campo do Formulário | exibido do cadastro | somente leitura | texto | — | campo do formulário sobre o qual a exclusão é aplicada |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Situação do campo | Inativo (exclusão lógica) | Ao excluir um campo já respondido em inscrições |

---

## Dados lidos e gravados

| Entidade | Papel | Por que a feature a toca |
|---|---|---|
| Inscrição | lê | Verifica se alguma inscrição já respondeu ao campo, o que decide entre a exclusão definitiva e a lógica (regras 1 a 3) |

---

## Comportamento de tela

### Onde fica
Ação disparada no Construtor de Formulário (`/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(nó Tipo de Participante → aba **Formulário de Inscrição**)*) ao remover um campo do canvas: para campos novos a remoção é imediata; para campos já respondidos, uma confirmação precede a inativação.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Ação desabilitada com indicador enquanto processa |
| Erro de validação | Não se aplica |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Remove o campo do canvas ou o marca como inativo, conforme o caso |
| Empty state | Não se aplica |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | Um campo sem inscrições é excluído definitivamente do formulário | cenário "Excluir campo ainda não utilizado" |
| SC-02 | Um campo já respondido recebe exclusão lógica e as respostas são preservadas | Critério de aceite 7 (HU-007) |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Papel | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| Excluir Campo | principal | EE | 1 | 3 | Simples | 3 | 2026-02-28 |

### Memória de cálculo

**Excluir Campo** — EE · ALR 1 · DER 3 · Simples · 3 PF

```json
{"pe": "Excluir Campo",
 "alr": ["Tipo Participante"],
 "der": ["ID Campo", "Ação", "Mensagem"]}
```

Por que cada ALR:
1. `Tipo Participante` — a transação remove o campo ou grava nele a situação inativa; o campo é subgrupo do arquivo lógico do tipo de participante

⚠️ A escolha entre a exclusão definitiva e a lógica lê as inscrições (arquivo lógico Inscrição), que a planilha não conta no ALR — a confirmar com a equipe de métricas.

**Total: 3 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0. Estrutura: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, Gherkin com `Feature:`. Redação: segundo parágrafo da Descrição (como se usa), critérios `CA-n` da HU na `## Origem`, coluna Entidade em `## Campos`, `## Dados lidos e gravados`, coluna Papel e memória de cálculo em bloco JSON (o processo elementar principal já levava o nome da feature). Sem mudança de regra, cenário ou número de PF |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (1 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-007 |

---

*Feature Set: Tipos de Participante · Major Feature Set: Configuração da Premiação · Última revisão: 2026-10-04*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
