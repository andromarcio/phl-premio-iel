<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: CFG-VIN-05
feature_set: CFG-VIN
dominio: CFG
entidade: Modalidade
data_model_ref: data-models/configuracao.md#modalidade--categoria-vinculo
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

# Desvincular Modalidade
> **Nível 3** - Feature Set: Vínculos e Ofertas — Major Feature Set: Configuração da Premiação - `CFG-VIN-05`

## Descrição
Permite ao administrador desfazer o vínculo de uma modalidade com uma categoria da edição por exclusão lógica, retirando aquele ramo sem remover a modalidade do catálogo.

No nó da modalidade, na árvore de configuração do prêmio, o administrador aciona "Remover" e confirma a desvinculação.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-011_Vincular_Categoria_Modalidade_TipoParticipante`](../../../hus/HU-011_Vincular_Categoria_Modalidade_TipoParticipante.docx) | Criação | `CA-3, CA-4` — desvincular é exclusão lógica do vínculo, sem desativar a modalidade do catálogo; a árvore recarrega após desvincular |

---

<div class="dev-only">

## Superfície

**Ação em tela** — origem: Árvore de Configuração do Prêmio (`/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(árvore de estrutura, à esquerda)*), ação de remover no nó da modalidade, com confirmação.

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. Desvincular é exclusão lógica do vínculo entre a modalidade e a categoria; a modalidade continua no catálogo.
2. A exclusão do vínculo não desativa a modalidade nem afeta seus vínculos com outras categorias.
3. Uma modalidade sem vínculo vigente com a categoria não integra aquele ramo da estrutura.

---

## Cenários

```gherkin
Feature: Desvincular Modalidade

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Desvincular uma modalidade da categoria
    Given que uma modalidade está vinculada a uma categoria da edição
    When escolho remover o vínculo e confirmo
    Then o sistema desfaz o vínculo e a modalidade deixa de integrar aquela categoria

  Scenario: Modalidade permanece no catálogo após a desvinculação
    Given que desvinculei a modalidade da categoria
    When consulto o catálogo de modalidades
    Then a modalidade continua disponível para vínculo a outras categorias

  # ── Restrições de acesso ───────────────────────────────────────

  Scenario: Usuário sem permissão para desvincular
    Given que meu perfil não tem permissão para desvincular modalidades
    When tento remover o vínculo de uma modalidade
    Then o sistema bloqueia e exibe "Você não tem permissão para esta ação."
```

---

## Campos

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Modalidade | Modalidade | exibido do cadastro | somente leitura | texto | — | modalidade cujo vínculo com a categoria será desfeito |
| Categoria da edição | Categoria | exibido do cadastro | somente leitura | texto | — | categoria de origem do vínculo, já vinculada à edição |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Situação do vínculo | Inativo | Ao confirmar a desvinculação |

---

## Dados lidos e gravados

| Entidade | Papel | Por que a feature a toca |
|---|---|---|
| Modalidade × Categoria | grava | O vínculo da modalidade com a categoria passa à situação inativa (regra 1; campo automático) |
| Premiação | lê | A edição a que pertence o vínculo desfeito (ALR do baseline) |

---

## Comportamento de tela

### Onde fica
Ação disparada do nó da modalidade na Árvore de Configuração do Prêmio (`/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(árvore de estrutura, à esquerda)*): opção de remover o vínculo, precedida de confirmação.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Ação desabilitada com indicador enquanto processa |
| Erro de validação | Não se aplica |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Remove o nó da modalidade da árvore e recarrega a estrutura |
| Empty state | Não se aplica |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | Ao confirmar, o vínculo da modalidade com a categoria é desfeito por exclusão lógica | cenário "Desvincular uma modalidade da categoria" |
| SC-02 | A modalidade desvinculada permanece no catálogo, sem ser desativada | Critério de aceite 3 (HU-011) |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Papel | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| Desvincular Modalidade | principal | EE | 2 | 3 | Simples | 3 | 2026-02-28 |

### Memória de cálculo

**Desvincular Modalidade** — EE · ALR 2 · DER 3 · Simples · 3 PF

```json
{"pe": "Desvincular Modalidade",
 "alr": ["Modalidade", "Premiação"],
 "der": ["ID", "Ação", "Mensagem"]}
```

Por que cada ALR:
1. `Modalidade` — grava a situação inativa no vínculo da modalidade com a categoria (o vínculo é subgrupo do arquivo lógico Modalidade)
2. `Premiação` — lê a edição a que pertence o vínculo desfeito

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
