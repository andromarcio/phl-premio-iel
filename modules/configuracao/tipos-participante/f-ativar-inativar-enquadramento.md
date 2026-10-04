<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: CFG-TIP-11
feature_set: CFG-TIP
dominio: CFG
entidade: Enquadramento
data_model_ref: data-models/configuracao.md#enquadramento
endpoints: []
error_codes: []
depende_de: []
origem:
  tipo: issue
  chave: HU-008_Enquadramento_Tipo_Participante
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

# Ativar/Inativar Enquadramento
> **Nível 3** - Feature Set: Tipos de Participante — Major Feature Set: Configuração da Premiação - `CFG-TIP-11`

## Descrição
Permite ao administrador alternar a situação ativa/inativa de um enquadramento (exclusão lógica), controlando sua oferta como opção de classificação na inscrição sem removê-lo do tipo de participante.

Na lista da aba "Sub Modalidades" do tipo de participante, o administrador aciona "Desativar" (ou "Ativar", se o enquadramento estiver inativo) na linha do enquadramento e confirma; para o enquadramento "Geral" a desativação fica indisponível.

> ℹ️ **Rótulo na interface** (conferência com o código, 2026-08-28): o enquadramento aparece para o administrador como **“Sub Modalidade”** — a aba *Sub Modalidades* do Tipo de Participante lista exatamente esta entidade. Ver `global/CONFORMIDADE-CODIGO.md` § 3.2.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-008_Enquadramento_Tipo_Participante`](../../../hus/HU-008_Enquadramento_Tipo_Participante.docx) | Criação | `CA-1, CA-4, CA-5` — enquadramento "Geral" protegido, com a desativação sempre indisponível (a criação automática dele é do `CFG-TIP-02` — Cadastrar Tipo de Participante); lista recarregada após a troca de situação; enquadramento inativo mantido na lista administrativa e fora da inscrição pública |

---

<div class="dev-only">

## Superfície

**Ação em tela** — origem: tela de Enquadramentos (`/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(nó Tipo de Participante → aba **Sub Modalidades**)*), a partir da ação de situação na linha do enquadramento, com confirmação.

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. A inativação é lógica: o enquadramento não é removido, apenas passa à situação inativa.
2. O enquadramento "Geral" é protegido e não pode ser inativado.
3. Um enquadramento inativo não é ofertado como opção de classificação na inscrição pública.

---

## Cenários

```gherkin
Feature: Ativar/Inativar Enquadramento

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Inativar enquadramento
    Given que identifico um enquadramento ativo diferente do "Geral"
    When clico em "Desativar" e confirmo
    Then o sistema passa o enquadramento para a situação inativa

  Scenario: Reativar enquadramento
    Given que identifico um enquadramento inativo
    When clico em "Ativar" e confirmo
    Then o sistema passa o enquadramento para a situação ativa

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Enquadramento "Geral" protegido
    Given que o enquadramento é o "Geral"
    When tento inativá-lo
    Then o sistema mantém o "Geral" ativo e não conclui a inativação

  Scenario: Enquadramento inativo fora da inscrição pública
    Given que o enquadramento está inativo
    When um participante acessa o fluxo público de inscrição
    Then o enquadramento inativo não é apresentado como opção de classificação

  # ── Restrições de acesso ───────────────────────────────────────

  Scenario: Usuário sem permissão para inativar enquadramento
    Given que meu perfil não tem permissão para inativar enquadramentos
    When tento inativar um enquadramento
    Then o sistema bloqueia e exibe "Você não tem permissão para esta ação."
```

---

## Campos

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Enquadramento | Enquadramento | exibido do cadastro | somente leitura | texto | — | enquadramento sobre o qual a ação é aplicada |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Situação | Alterna entre Ativo e Inativo | Ao confirmar a ação de situação |

---

## Comportamento de tela

### Onde fica
Ação disparada da linha do enquadramento na tela de Enquadramentos (`/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(nó Tipo de Participante → aba **Sub Modalidades**)*): botão contextual que mostra "Desativar" quando ativo e "Ativar" quando inativo, seguido de confirmação; para o enquadramento "Geral" a ação de inativação fica indisponível.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Ação desabilitada com indicador enquanto processa |
| Erro de validação | Não se aplica |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Atualiza a situação exibida na linha do enquadramento |
| Empty state | Não se aplica |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | Ao confirmar, o enquadramento alterna corretamente entre ativo e inativo | cenários "Inativar enquadramento" / "Reativar enquadramento" |
| SC-02 | O enquadramento "Geral" não pode ser inativado | Critério de aceite 1 (HU-008) |

---

## Métricas de tamanho

> **Sem contagem no baseline APF** — sem PE no baseline ⚠️. Ver `global/SIZING.md` → *Conciliação Feature ↔ Processo Elementar*.

| Função de Transação | Papel | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| — | — | — | — | — | — | — | — |

**Total: — PF.**

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0. Estrutura: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, Gherkin com `Feature:`. Redação: segundo parágrafo da Descrição (como se usa), com a nota sobre o rótulo na interface movida para depois dele (antes ela precedia o contrato de entrega e o absorvia na mesma citação), critérios `CA-n` da HU na `## Origem`, coluna Entidade em `## Campos`, coluna Papel na tabela de `## Métricas de tamanho` (sem processo elementar no baseline, nada a medir). Sem mudança de regra, cenário ou número de PF |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-008 |

---

*Feature Set: Tipos de Participante · Major Feature Set: Configuração da Premiação · Última revisão: 2026-10-04*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
