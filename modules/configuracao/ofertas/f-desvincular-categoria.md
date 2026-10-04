<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: CFG-VIN-03
feature_set: CFG-VIN
dominio: CFG
entidade: Categoria
data_model_ref: data-models/configuracao.md#premiacao--categoria-vinculo
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

# Desvincular Categoria
> **Nível 3** - Feature Set: Vínculos e Ofertas — Major Feature Set: Configuração da Premiação - `CFG-VIN-03`

## Descrição
Permite ao administrador desfazer o vínculo de uma categoria com a edição do prêmio por exclusão lógica, retirando-a da estrutura sem apagá-la do catálogo nem de outras edições.

No nó da categoria, na árvore de configuração do prêmio, o administrador aciona "Remover" e confirma a desvinculação.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-011_Vincular_Categoria_Modalidade_TipoParticipante`](../../../hus/HU-011_Vincular_Categoria_Modalidade_TipoParticipante.docx) | Criação | `CA-3, CA-4` — desvincular é exclusão lógica do vínculo, sem desativar a categoria do catálogo; a árvore recarrega após desvincular |

---

<div class="dev-only">

## Superfície

**Ação em tela** — origem: Árvore de Configuração do Prêmio (`/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(árvore de estrutura, à esquerda)*), ação de remover no nó da categoria, com confirmação.

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. Desvincular é exclusão lógica do vínculo entre a categoria e a edição; a categoria continua no catálogo.
2. A exclusão do vínculo não desativa a categoria nem afeta seus vínculos com outras edições.
3. Uma categoria sem vínculo vigente com a edição não integra a estrutura daquela edição.

---

## Cenários

```gherkin
Feature: Desvincular Categoria

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Desvincular uma categoria da edição
    Given que uma categoria está vinculada à edição
    When escolho remover o vínculo e confirmo
    Then o sistema desfaz o vínculo e a categoria deixa de integrar a estrutura da edição

  Scenario: Categoria permanece no catálogo após a desvinculação
    Given que desvinculei a categoria da edição
    When consulto o catálogo de categorias
    Then a categoria continua disponível para vínculo a outras edições

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Desistir da desvinculação
    Given que iniciei a remoção do vínculo de uma categoria
    When cancelo a confirmação
    Then o sistema mantém o vínculo e a estrutura permanece como estava

  # ── Restrições de acesso ───────────────────────────────────────

  Scenario: Usuário sem permissão para desvincular
    Given que meu perfil não tem permissão para desvincular categorias
    When tento remover o vínculo de uma categoria
    Then o sistema bloqueia e exibe "Você não tem permissão para esta ação."
```

---

## Campos

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Categoria | Categoria | exibido do cadastro | somente leitura | texto | — | categoria cujo vínculo com a edição será desfeito |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Situação do vínculo | Inativo | Ao confirmar a desvinculação |

---

## Dados lidos e gravados

| Entidade | Papel | Por que a feature a toca |
|---|---|---|
| Premiação × Categoria | grava | O vínculo da categoria com a edição passa à situação inativa (regra 1; campo automático) |

---

## Comportamento de tela

### Onde fica
Ação disparada do nó da categoria na Árvore de Configuração do Prêmio (`/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(árvore de estrutura, à esquerda)*): opção de remover o vínculo, precedida de confirmação.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Ação desabilitada com indicador enquanto processa |
| Erro de validação | Não se aplica |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Remove o nó da categoria da árvore e recarrega a estrutura |
| Empty state | Não se aplica |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | Ao confirmar, o vínculo da categoria com a edição é desfeito por exclusão lógica | cenário "Desvincular uma categoria da edição" |
| SC-02 | A categoria desvinculada permanece no catálogo, sem ser desativada | Critério de aceite 3 (HU-011) |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Papel | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| Desvincular Categoria | principal | EE | 1 | 3 | Simples | 3 | 2026-02-28 |

### Memória de cálculo

**Desvincular Categoria** — EE · ALR 1 · DER 3 · Simples · 3 PF

```json
{"pe": "Desvincular Categoria",
 "alr": ["Categoria"],
 "der": ["ID", "Ação", "Mensagem"]}
```

Por que cada ALR:
1. `Categoria` — grava a situação inativa no vínculo da categoria com a edição (o vínculo é subgrupo do arquivo lógico Categoria)

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
