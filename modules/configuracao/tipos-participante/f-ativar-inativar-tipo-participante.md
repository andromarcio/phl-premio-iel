<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: CFG-TIP-05
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

# Ativar/Inativar Tipo de Participante
> **Nível 3** - Feature Set: Tipos de Participante — Major Feature Set: Configuração da Premiação - `CFG-TIP-05`

## Descrição
Permite ao administrador alternar a situação ativa/inativa de um tipo de participante (exclusão lógica), sem afetar as sub-configurações de inscrição e avaliação já montadas.

Na linha do tipo, no Catálogo de Tipos de Participante, o administrador aciona "Desativar" (ou "Ativar", se ele estiver inativo) e confirma a troca de situação.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-006_Cadastrar_Tipo_Participantes`](../../../hus/HU-006_Cadastrar_Tipo_Participantes.docx) | Criação | `CA-6` — a desativação do tipo não cascateia para as sub-configurações (formulário, questionário e enquadramentos) |

---

<div class="dev-only">

## Superfície

**Ação em tela** — origem: Catálogo de Tipos de Participante (`/tipos-participante`), a partir do botão de situação na linha do tipo, com confirmação.

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. A inativação é lógica: o tipo de participante não é removido, apenas passa à situação inativa.
2. A inativação de um tipo de participante não cascateia para as suas sub-configurações de inscrição e avaliação, que permanecem preservadas.
3. Um tipo de participante inativo não é ofertado nos fluxos de inscrição pública.

---

## Cenários

```gherkin
Feature: Ativar/Inativar Tipo de Participante

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Inativar tipo de participante
    Given que identifico um tipo de participante ativo
    When clico em "Desativar" e confirmo
    Then o sistema passa o tipo de participante para a situação inativa

  Scenario: Reativar tipo de participante
    Given que identifico um tipo de participante inativo
    When clico em "Ativar" e confirmo
    Then o sistema passa o tipo de participante para a situação ativa

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Inativação preserva a estrutura configurada
    Given que o tipo de participante possui formulário, enquadramentos e questionário configurados
    When inativo o tipo de participante
    Then as sub-configurações permanecem preservadas e inalteradas

  Scenario: Tipo inativo fora da inscrição pública
    Given que o tipo de participante está inativo
    When um participante acessa o fluxo público de inscrição
    Then o tipo inativo não é apresentado como opção

  # ── Restrições de acesso ───────────────────────────────────────

  Scenario: Usuário sem permissão para inativar
    Given que meu perfil não tem permissão para inativar tipos de participante
    When tento inativar um tipo de participante
    Then o sistema bloqueia e exibe "Você não tem permissão para esta ação."
```

---

## Campos

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Tipo de participante | Tipo de Participante | exibido do cadastro | somente leitura | texto | — | tipo sobre o qual a ação é aplicada |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Situação | Alterna entre Ativo e Inativo | Ao confirmar a ação de situação |

---

## Comportamento de tela

### Onde fica
Ação disparada da linha do tipo no Catálogo de Tipos de Participante (`/tipos-participante`): botão contextual que mostra "Desativar" quando ativo e "Ativar" quando inativo, seguido de confirmação.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Ação desabilitada com indicador enquanto processa |
| Erro de validação | Não se aplica |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Atualiza a situação exibida na linha do tipo de participante |
| Empty state | Não se aplica |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | Ao confirmar, o tipo de participante alterna corretamente entre ativo e inativo | cenários "Inativar tipo de participante" / "Reativar tipo de participante" |
| SC-02 | A inativação não cascateia para as sub-configurações do tipo | Critério de aceite 6 (HU-006) |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Papel | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| Ativar/Inativar Tipo de Participante | principal | EE | 1 | 3 | Simples | 3 | 2026-02-28 |

### Memória de cálculo

**Ativar/Inativar Tipo de Participante** — EE · ALR 1 · DER 3 · Simples · 3 PF

```json
{"pe": "Ativar/Inativar Tipo de Participante",
 "alr": ["Tipo Participante"],
 "der": ["ID", "Ação", "Mensagem"]}
```

Por que cada ALR:
1. `Tipo Participante` — a transação grava a nova situação do tipo de participante

**Total: 3 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0. Estrutura: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, Gherkin com `Feature:`. Redação: segundo parágrafo da Descrição (como se usa), critérios `CA-n` da HU na `## Origem`, coluna Entidade em `## Campos`, coluna Papel e memória de cálculo em bloco JSON (o processo elementar principal já levava o nome da feature). Sem mudança de regra, cenário ou número de PF |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (1 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-006 |

---

*Feature Set: Tipos de Participante · Major Feature Set: Configuração da Premiação · Última revisão: 2026-10-04*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
