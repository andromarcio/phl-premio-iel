---
id: CFG-TIP-10
feature_set: CFG-TIP
dominio: CFG
entidade: Enquadramento
prioridade: P1
mvp: true
data_model_ref: data-models/configuracao.md#enquadramento
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

# Cadastrar Enquadramento
> **Nível 3** - Feature Set: Tipos de Participante — Domínio: Configuração da Premiação - `CFG-TIP-10`
> **Prioridade**: P1 · **MVP**: sim

## Descrição

> ℹ️ **Rótulo na interface** (conferência com o código, 2026-08-28): o enquadramento aparece para o administrador como **“Sub Modalidade”** — a aba *Sub Modalidades* do Tipo de Participante lista exatamente esta entidade. Ver `global/CONFORMIDADE-CODIGO.md` § 3.2.
Permite ao administrador cadastrar um enquadramento — subdivisão classificatória de um tipo de participante (ex.: "1º Ano", "2º Ano") — que passa a estar disponível como opção de classificação na inscrição.

---

<div class="dev-only">

## Superfície

**Ação em tela** — origem: tela de Enquadramentos (`/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(nó Tipo de Participante → aba **Sub Modalidades**)*), a partir do diálogo "Novo Enquadramento".

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. O nome do enquadramento é único dentro do mesmo tipo de participante; o mesmo nome é permitido em tipos de participante diferentes.
2. O tipo de participante ao qual o enquadramento pertence é definido na criação e não é alterado depois.
3. Um enquadramento inativo não é ofertado como opção de classificação na inscrição pública.

---

## Cenários

```gherkin
# ← MESSAGE-DICTIONARY: BASELINE

# ── Caminho feliz ──────────────────────────────────────────────

Scenario: Cadastrar enquadramento
  Given que acesso o cadastro de enquadramento de um tipo de participante
  When informo o nome "1º Ano" e salvo
  Then o sistema registra o enquadramento e exibe "Registro salvo com sucesso."

# ── Erros de validação ─────────────────────────────────────────

Scenario: Nome em branco
  Given que estou no cadastro de enquadramento
  When deixo o campo Nome em branco e clico em "Salvar"
  Then o sistema não registra e exibe "Campo obrigatório."

# ── Conflitos com dados existentes ─────────────────────────────

Scenario: Nome duplicado no mesmo tipo de participante
  Given que já existe o enquadramento "1º Ano" neste tipo de participante
  When tento criar outro enquadramento com o mesmo nome neste tipo
  Then o sistema não registra e exibe "Já existe um enquadramento com este nome para este tipo de participante."
  # ← MESSAGE-DICTIONARY: CFG_ENQUADRAMENTO_NOME_DUPLICADO

# ── Restrições de acesso ───────────────────────────────────────

Scenario: Usuário sem permissão para cadastrar enquadramento
  Given que meu perfil não tem permissão para cadastrar enquadramentos
  When tento acessar o cadastro de enquadramento
  Then o sistema bloqueia e exibe "Você não tem permissão para esta ação."
```

---

## Campos

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Nome | entrada do usuário | editável | texto | sim | único dentro do mesmo tipo de participante; máximo de 200 caracteres |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Situação | Ativo | Na criação do enquadramento |

---

## Comportamento de tela

### Onde fica
Diálogo de cadastro aberto pela tela de Enquadramentos do tipo de participante (`/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(nó Tipo de Participante → aba **Sub Modalidades**)*), com o campo Nome e as ações Salvar e Cancelar, sem sair da listagem.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Botão "Salvar" desabilitado com indicador enquanto grava |
| Erro de validação | Destaca o campo Nome com "Campo obrigatório." |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Exibe "Registro salvo com sucesso." e atualiza a lista de enquadramentos |
| Empty state | Não se aplica |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | Um enquadramento com nome válido é registrado e passa a constar na lista do tipo | cenário "Cadastrar enquadramento" |
| SC-02 | A tentativa de criar um enquadramento com nome repetido no mesmo tipo é rejeitada | Critério de aceite 3 (HU-008) |

---

## Métricas de tamanho

> **Sem contagem no baseline APF** — sem PE no baseline ⚠️. Ver `global/SIZING.md` → *Conciliação Feature ↔ Processo Elementar*.

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| — | — | — | — | — | — | — |

**Total: — PF.**

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-008 |

---

*Feature Set: Tipos de Participante · Domínio: Configuração da Premiação · Última revisão: 2026-08-27*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
