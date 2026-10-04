<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: CFG-LIS-05
feature_set: CFG-LIS
dominio: CFG
entidade: Item da Lista do Sistema
data_model_ref: data-models/configuracao.md#item-da-lista-do-sistema
endpoints: []
error_codes: []
depende_de: []
origem:
  tipo: issue
  chave: HU-012_Listas_do_Sistema
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

# Configurar Itens da Lista
> **Nível 3** - Feature Set: Listas do Sistema — Major Feature Set: Configuração da Premiação - `CFG-LIS-05`

## Descrição
Permite ao administrador manter os itens de uma lista — incluir, reordenar e remover pares de valor e texto — que compõem as opções oferecidas nos campos de seleção dos formulários.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-012_Listas_do_Sistema`](../../../hus/HU-012_Listas_do_Sistema.docx) | Criação | — |

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/configuracao-premiacao/listas-sistema/:listaSistemaId/editar` *(itens editados no próprio formulário)* (Formulário da Lista, aba Itens)

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. Cada item tem um valor e um texto; ambos são obrigatórios para incluir o item.
2. A ordem dos itens é sequencial a partir de 1 e é recalculada a cada inclusão, remoção ou reordenação.
3. Os itens só podem ser configurados depois que a lista foi salva.
4. Ao abrir a lista, apenas os itens ativos são carregados, na ordem em que estão definidos.
5. A alteração dos itens vale imediatamente para todos os campos de seleção que usam a lista, inclusive em inscrições em andamento. ⚠️ *(impacto a comunicar ao administrador antes de alterar listas já em uso)*
6. A remoção de um item é aplicada como exclusão lógica no salvamento dos itens.

---

## Cenários

```gherkin
Feature: Configurar Itens da Lista

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Incluir um item na lista
    Given que estou na configuração de itens de uma lista já salva
    When informo o valor "SP" e o texto "São Paulo" e clico em "Adicionar"
    Then o sistema inclui o item ao final e recalcula a ordem dos itens

  Scenario: Salvar os itens configurados
    Given que incluí e organizei os itens da lista
    When clico em "Salvar Itens"
    Then o sistema grava os itens e exibe "Registro salvo com sucesso."

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Reordenar um item para cima
    Given que a lista tem um item que não é o primeiro
    When aciono "Mover para cima" nesse item
    Then o sistema troca o item de posição com o anterior e recalcula a ordem

  Scenario: Remover um item
    Given que a lista tem itens configurados
    When aciono "Remover" em um item
    Then o sistema retira o item e recalcula a ordem dos itens restantes

  Scenario: Tentar incluir item sem valor ou sem texto
    Given que estou na configuração de itens
    When aciono "Adicionar" sem preencher o valor ou o texto
    Then o sistema não inclui o item

  # ── Conflitos com dados existentes ─────────────────────────────

  # ← MESSAGE-DICTIONARY: CFG_LISTA_SALVAR_ANTES_ITENS
  Scenario: Salvar itens antes de salvar a lista
    Given que a lista ainda não foi salva
    When tento salvar os itens
    Then o sistema não grava e exibe "Salve a lista antes de salvar os itens."
```

---

## Campos

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Valor | entrada do usuário | editável | texto | sim | valor armazenado do item; máximo de 200 caracteres |
| Texto | entrada do usuário | editável | texto | sim | rótulo exibido ao participante; máximo de 300 caracteres |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Ordem | Sequencial a partir de 1 | Recalculada a cada inclusão, remoção ou reordenação de itens |

---

## Comportamento de tela

### Onde fica
Aba "Itens" do formulário da lista em `/configuracao-premiacao/listas-sistema/:listaSistemaId/editar` *(itens editados no próprio formulário)*: tabela de itens com valor, texto e ordem, o formulário de inclusão de item e o botão de salvar os itens.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Botão "Salvar Itens" desabilitado com indicador enquanto grava |
| Erro de validação | Não inclui item com valor ou texto em branco |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Exibe "Registro salvo com sucesso." e atualiza os itens exibidos |
| Empty state | Lista sem itens: "Nenhum registro encontrado." |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | Incluir, reordenar e remover itens mantém a ordem sequencial a partir de 1 | Critério de aceite RF-06 (HU-012) |
| SC-02 | Os itens configurados são persistidos ao salvar | Critério de aceite RF-07 (HU-012) |
| SC-03 | A tentativa de salvar itens antes de salvar a lista é bloqueada | cenário "Salvar itens antes de salvar a lista" |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Ordenar Lista | EE | 1 | 3 | Simples | 3 | 2026-02-28 |

### Memória de cálculo

- **Ordenar Lista** — ALR (1): Listas do Sistema. DER (3): ID · Ação · Mensagem.

```json
{"pe": "Ordenar Lista",
 "alr": ["Listas do Sistema"],
 "der": ["ID", "Ação", "Mensagem"]}
```

**Total: 3 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Estrutura atualizada | Artefato regenerado com o engine 4.1.0: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, `## Origem` com a HU e os tickets das AIMs, Gherkin com `Feature:` |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (1 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-012 |

---

*Feature Set: Listas do Sistema · Major Feature Set: Configuração da Premiação · Última revisão: 2026-08-27*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
