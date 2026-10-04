<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: CFG-VIN-07
feature_set: CFG-VIN
dominio: CFG
entidade: Tipo de Participante
data_model_ref: data-models/configuracao.md#oferta-tipo--modalidade--categoria
endpoints: []
error_codes: []
depende_de: []
origem:
  tipo: issue
  chave: HU-011_Vincular_Categoria_Modalidade_TipoParticipante
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

# Desvincular Tipo de Participante
> **Nível 3** - Feature Set: Vínculos e Ofertas — Major Feature Set: Configuração da Premiação - `CFG-VIN-07`

## Descrição
Permite ao administrador desfazer uma oferta ao remover, por exclusão lógica, o vínculo de um tipo de participante com uma modalidade, sem excluir o tipo do catálogo.

No nó do tipo de participante, na árvore de configuração do prêmio, o administrador aciona "Remover" e confirma a desvinculação.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-011_Vincular_Categoria_Modalidade_TipoParticipante`](../../../hus/HU-011_Vincular_Categoria_Modalidade_TipoParticipante.docx) | Criação | `CA-3, CA-4` — desvincular é exclusão lógica da oferta, sem desativar o tipo de participante do catálogo; a árvore recarrega após desvincular |

---

<div class="dev-only">

## Superfície

**Ação em tela** — origem: Árvore de Configuração do Prêmio (`/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(árvore de estrutura, à esquerda)*), ação de remover no nó do tipo de participante, com confirmação.

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. Desvincular é exclusão lógica do vínculo do tipo de participante com a modalidade e a categoria; o tipo continua no catálogo.
2. A exclusão do vínculo não desativa o tipo de participante nem afeta as ofertas que ele compõe em outras modalidades.
3. Desfeita a oferta, o caminho tipo de participante dentro da modalidade e da categoria deixa de estar disponível na edição.

---

## Cenários

```gherkin
Feature: Desvincular Tipo de Participante

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Desvincular um tipo de participante da modalidade
    Given que um tipo de participante compõe uma oferta na modalidade
    When escolho remover o vínculo e confirmo
    Then o sistema desfaz a oferta e o tipo deixa de integrar aquela modalidade

  Scenario: Tipo de participante permanece no catálogo após a desvinculação
    Given que desvinculei o tipo de participante da modalidade
    When consulto o catálogo de tipos de participante
    Then o tipo continua disponível para compor ofertas em outras modalidades

  # ── Restrições de acesso ───────────────────────────────────────

  Scenario: Usuário sem permissão para desvincular
    Given que meu perfil não tem permissão para desvincular tipos de participante
    When tento remover o vínculo de um tipo de participante
    Then o sistema bloqueia e exibe "Você não tem permissão para esta ação."
```

---

## Campos

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Tipo de participante | Tipo de Participante | exibido do cadastro | somente leitura | texto | — | tipo cujo vínculo com a modalidade será desfeito |
| Modalidade da estrutura | Modalidade | exibido do cadastro | somente leitura | texto | — | modalidade de origem da oferta, já vinculada na estrutura |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Situação da oferta | Inativo | Ao confirmar a desvinculação |

---

## Dados lidos e gravados

| Entidade | Papel | Por que a feature a toca |
|---|---|---|
| Oferta | grava | A oferta — vínculo do tipo com a modalidade e a categoria — passa à situação inativa (regra 1; campo automático) |

---

## Comportamento de tela

### Onde fica
Ação disparada do nó do tipo de participante na Árvore de Configuração do Prêmio (`/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(árvore de estrutura, à esquerda)*): opção de remover o vínculo, precedida de confirmação.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Ação desabilitada com indicador enquanto processa |
| Erro de validação | Não se aplica |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Remove o nó do tipo de participante da árvore e recarrega a estrutura |
| Empty state | Não se aplica |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | Ao confirmar, o vínculo do tipo com a modalidade é desfeito por exclusão lógica | cenário "Desvincular um tipo de participante da modalidade" |
| SC-02 | O tipo desvinculado permanece no catálogo, sem ser desativado | Critério de aceite 3 (HU-011) |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Papel | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| Desvincular Tipo de Participante | principal | EE | 1 | 3 | Simples | 3 | 2026-02-28 |

### Memória de cálculo

**Desvincular Tipo de Participante** — EE · ALR 1 · DER 3 · Simples · 3 PF

```json
{"pe": "Desvincular Tipo de Participante",
 "alr": ["Tipo Participante"],
 "der": ["ID", "Ação", "Mensagem"]}
```

Por que cada ALR:
1. `Tipo Participante` — grava a situação inativa na oferta (a oferta é subgrupo do arquivo lógico Tipo de Participante)

**Total: 3 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0. Estrutura: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, Gherkin com `Feature:`. Redação: segundo parágrafo da Descrição (como se usa), critérios `CA-n` da HU na `## Origem`, coluna Entidade em `## Campos`, `## Dados lidos e gravados`, coluna Papel e memória de cálculo em bloco JSON, com o processo elementar principal levando o nome da feature. Sem mudança de regra, cenário ou número de PF |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (1 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-011 |

---

*Feature Set: Vínculos e Ofertas · Major Feature Set: Configuração da Premiação · Última revisão: 2026-10-04*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
