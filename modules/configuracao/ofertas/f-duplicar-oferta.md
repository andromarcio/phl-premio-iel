<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: CFG-VIN-08
feature_set: CFG-VIN
dominio: CFG
entidade: Oferta
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

# Duplicar Oferta
> **Nível 3** - Feature Set: Vínculos e Ofertas — Major Feature Set: Configuração da Premiação - `CFG-VIN-08`

## Descrição
Permite ao administrador duplicar um ramo da estrutura — categoria, modalidade ou oferta — copiando toda a subestrutura abaixo dele, para reaproveitar a montagem entre edições sem refazer nó a nó.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-011_Vincular_Categoria_Modalidade_TipoParticipante`](../../../hus/HU-011_Vincular_Categoria_Modalidade_TipoParticipante.docx) | Criação | — |
| [`HU-004_Cadastrar_Categorias`](../../../hus/HU-004_Cadastrar_Categorias.docx) | Criação | — |

---

<div class="dev-only">

## Superfície

**Ação em tela** — origem: Árvore de Configuração do Prêmio (`/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(árvore de estrutura, à esquerda)*), ação de duplicar no nó escolhido.

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. Duplicar um ramo cria uma cópia independente dele com toda a subestrutura abaixo, do nó copiado até o último nível de detalhe das ofertas.
2. A cópia não altera o ramo de origem: origem e cópia passam a existir separadamente na estrutura.
3. O slug da URL não é copiado: cada oferta gerada pela cópia nasce sem slug, para receber o seu próprio.

---

## Cenários

```gherkin
Feature: Duplicar Oferta

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Duplicar uma categoria com toda a subestrutura
    Given que uma categoria da edição tem modalidades e tipos de participante vinculados
    When duplico o nó da categoria
    Then o sistema cria uma nova categoria com a mesma subestrutura, independente da original

  Scenario: Slug da URL não é copiado nas ofertas duplicadas
    Given que a oferta de origem tem um slug de URL definido
    When duplico o ramo que contém a oferta
    Then a oferta copiada é criada sem slug, para receber um slug próprio

  # ── Restrições de acesso ───────────────────────────────────────

  Scenario: Usuário sem permissão para duplicar
    Given que meu perfil não tem permissão para duplicar ramos da estrutura
    When tento duplicar um nó
    Then o sistema bloqueia e exibe "Você não tem permissão para esta ação."
```

---

## Campos

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Nó de origem | seleção na árvore | somente leitura | seleção | sim | ramo (categoria, modalidade ou oferta) a ser duplicado com sua subestrutura |
| Nome da cópia | entrada do usuário | editável | texto | não | nome do nó copiado; padrão deriva do nó de origem |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Subestrutura | Copiada integralmente a partir do nó de origem: modalidades, tipos de participante, enquadramentos, formulários, campos, questionários, questões, alternativas e anexos | Ao duplicar o ramo |
| Slug da URL (ofertas copiadas) | Não copiado (nasce vazio) | Ao duplicar ofertas com slug |
| Situação | Ativo | Nos nós e vínculos gerados pela cópia |

---

## Comportamento de tela

### Onde fica
Ação disparada do nó escolhido na Árvore de Configuração do Prêmio (`/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(árvore de estrutura, à esquerda)*): opção de duplicar o ramo, que recarrega a árvore com a cópia ao concluir.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Ação desabilitada com indicador enquanto a cópia é gerada |
| Erro de validação | Não se aplica |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Recarrega a árvore com o ramo copiado ao lado do original |
| Empty state | Não se aplica |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | Duplicar um ramo cria uma cópia com toda a subestrutura, sem alterar a origem | Critério de aceite 4 (HU-011); RN5 (HU-004) |
| SC-02 | As ofertas duplicadas são criadas sem o slug da URL da origem | cenário "Slug da URL não é copiado nas ofertas duplicadas" |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Duplicar Categoria | EE | 4 | 3 | Médio | 4 | 2026-02-28 |
| Duplicar Modalidade | EE | 4 | 3 | Médio | 4 | 2026-02-28 |
| Duplicar Tipo de Participante | EE | 4 | 3 | Médio | 4 | 2026-02-28 |

### Memória de cálculo

- **Duplicar Categoria** — ALR (4): Categoria · Modalidade · Tipo Participante · Premiação. DER (3): Identificador · Ação · Mensagem.

```json
{"pe": "Duplicar Categoria",
 "alr": ["Categoria", "Modalidade", "Tipo Participante", "Premiação"],
 "der": ["Identificador", "Ação", "Mensagem"]}
```
- **Duplicar Modalidade** — ALR (4): Premiação · Categoria · Modalidade · Tipo Participante. DER (3): Identificador · Ação · Mensagem.

```json
{"pe": "Duplicar Modalidade",
 "alr": ["Premiação", "Categoria", "Modalidade", "Tipo Participante"],
 "der": ["Identificador", "Ação", "Mensagem"]}
```
- **Duplicar Tipo de Participante** — ALR (4): Premiação · Tipo de Participante · Categoria · Modalidade. DER (3): Identificador · Ação · Mensagem.

```json
{"pe": "Duplicar Tipo de Participante",
 "alr": ["Premiação", "Tipo de Participante", "Categoria", "Modalidade"],
 "der": ["Identificador", "Ação", "Mensagem"]}
```

**Total: 12 PF** (3 processos elementares).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Estrutura atualizada | Artefato regenerado com o engine 4.1.0: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, `## Origem` com a HU e os tickets das AIMs, Gherkin com `Feature:` |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (3 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-011 e da RN5 da HU-004 |

---

*Feature Set: Vínculos e Ofertas · Major Feature Set: Configuração da Premiação · Última revisão: 2026-08-27*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
