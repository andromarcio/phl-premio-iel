---
id: CFG-CAT-05
feature_set: CFG-CAT
dominio: CFG
entidade: Categoria
prioridade: P2
mvp: false
data_model_ref: data-models/configuracao.md#categoria
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

# Ativar/Inativar Categoria
> **Nível 3** - Feature Set: Categorias — Domínio: Configuração da Premiação - `CFG-CAT-05`
> **Prioridade**: P2 · **MVP**: não

## Descrição
Permite ao administrador alternar a situação ativa/inativa de uma categoria (exclusão lógica), controlando sua oferta nos fluxos de inscrição sem removê-la do sistema.

---

<div class="dev-only">

## Superfície

**Ação em tela** — origem: Catálogo de Categorias (`/categorias`), a partir do botão de situação na linha da categoria, com confirmação.

**Fidelidade ao protótipo**: referência — `prototypes/configuracao/categorias/flow.html`

---

</div>

## Regras de negócio

1. A inativação é lógica: a categoria não é removida, apenas passa à situação inativa.
2. A inativação de uma categoria não altera a situação das modalidades a ela vinculadas.
3. Uma categoria inativa não é ofertada nos fluxos de inscrição pública.

---

## Cenários

```gherkin
# ← MESSAGE-DICTIONARY: BASELINE

# ── Caminho feliz ──────────────────────────────────────────────

Scenario: Inativar categoria
  Given que identifico uma categoria ativa
  When clico em "Desativar" e confirmo
  Then o sistema passa a categoria para a situação inativa

Scenario: Reativar categoria
  Given que identifico uma categoria inativa
  When clico em "Ativar" e confirmo
  Then o sistema passa a categoria para a situação ativa

# ── Estados especiais ──────────────────────────────────────────

Scenario: Inativação não cascateia para as modalidades
  Given que a categoria possui modalidades vinculadas ativas
  When inativo a categoria
  Then as modalidades vinculadas permanecem com a situação que tinham

Scenario: Categoria inativa fora da inscrição pública
  Given que a categoria está inativa
  When um participante acessa o fluxo público de inscrição
  Then a categoria inativa não é apresentada como opção

# ── Restrições de acesso ───────────────────────────────────────

Scenario: Usuário sem permissão para inativar
  Given que meu perfil não tem permissão para inativar categorias
  When tento inativar uma categoria
  Then o sistema bloqueia e exibe "Você não tem permissão para esta ação."
```

---

## Campos

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Categoria | Categoria | somente leitura | texto | — | categoria sobre a qual a ação é aplicada |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Situação | Alterna entre Ativo e Inativo | Ao confirmar a ação de situação |

---

## Comportamento de tela

### Onde fica
Ação disparada da linha da categoria no Catálogo de Categorias (`/categorias`): botão contextual que mostra "Desativar" quando ativa e "Ativar" quando inativa, seguido de confirmação.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Ação desabilitada com indicador enquanto processa |
| Erro de validação | Não se aplica |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Atualiza a situação exibida na linha da categoria |
| Empty state | Não se aplica |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | Ao confirmar, a categoria alterna corretamente entre ativa e inativa | cenários "Inativar categoria" / "Reativar categoria" |
| SC-02 | A inativação de uma categoria não altera a situação das modalidades vinculadas | Critério de aceite 3 (HU-004) |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Ativar/Inativar Categoria | EE | 1 | 3 | Simples | 3 | 2026-02-28 |

### Memória de cálculo

- **Ativar/Inativar Categoria** — ALR (1): Categoria. DER (3): ID Categoria · Ação · Mensagem.

```json
{"pe": "Ativar/Inativar Categoria",
 "alr": ["Categoria"],
 "der": ["ID Categoria", "Ação", "Mensagem"]}
```

**Total: 3 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (1 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-02 | Protótipo (docqui) | Vínculo corrigido | A linha dizia **n/a** embora a feature já estivesse desenhada em `prototypes/configuracao/categorias/flow.html` desde a geração daquele fluxo — o manifesto registrava o vínculo e este N3 não. Fidelidade passa a **referência** |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-25 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-004 |

---

*Feature Set: Categorias · Domínio: Configuração da Premiação · Última revisão: 2026-08-25*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
