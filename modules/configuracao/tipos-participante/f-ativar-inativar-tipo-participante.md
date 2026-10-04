---
id: CFG-TIP-05
feature_set: CFG-TIP
dominio: CFG
entidade: Tipo de Participante
prioridade: P2
mvp: false
data_model_ref: data-models/configuracao.md#tipo-de-participante
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

# Ativar/Inativar Tipo de Participante
> **Nível 3** - Feature Set: Tipos de Participante — Domínio: Configuração da Premiação - `CFG-TIP-05`
> **Prioridade**: P2 · **MVP**: não

## Descrição
Permite ao administrador alternar a situação ativa/inativa de um tipo de participante (exclusão lógica), sem afetar as sub-configurações de inscrição e avaliação já montadas.

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

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Tipo de participante | Tipo de Participante | somente leitura | texto | — | tipo sobre o qual a ação é aplicada |

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

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Ativar/Inativar Tipo de Participante | EE | 1 | 3 | Simples | 3 | 2026-02-28 |

### Memória de cálculo

- **Ativar/Inativar Tipo de Participante** — ALR (1): Tipo Participante. DER (3): ID · Ação · Mensagem.

```json
{"pe": "Ativar/Inativar Tipo de Participante",
 "alr": ["Tipo Participante"],
 "der": ["ID", "Ação", "Mensagem"]}
```

**Total: 3 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (1 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-006 |

---

*Feature Set: Tipos de Participante · Domínio: Configuração da Premiação · Última revisão: 2026-08-27*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
