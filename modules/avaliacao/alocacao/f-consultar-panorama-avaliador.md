<!-- docqui: 2.23.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: AVL-ALO-05
feature_set: AVL-ALO
dominio: AVL
entidade: Alocação de Avaliadores
prioridade: P2
mvp: false
data_model_ref: data-models/avaliacao.md#avaliacao-de-inscricao
endpoints: []
error_codes: []
depende_de: [AVL-ALO-01]
estado: rascunho
gates:
  requisitos:   { aprovado: false, por: "", em: "", pr: "" }
  modelo-dados: { aprovado: false, por: "", em: "", pr: "" }
  testes:       { aprovado: false, por: "", em: "", pr: "" }
  codigo:       { aprovado: false, por: "", em: "", pr: "" }
---

# Consultar Panorama do Avaliador
> **Nível 3** - Feature Set: Alocação — Domínio: Avaliação - `AVL-ALO-05`
> **Prioridade**: P2 · **MVP**: não

## Descrição
Mostra ao administrador quanto trabalho um avaliador já tem numa etapa — quantas avaliações estão alocadas, a iniciar, em andamento e finalizadas, separadas por grupo — para apoiar a decisão de alocar mais projetos a ele.

---

<div class="dev-only">

## Superfície

**Ação em tela** — origem: Alocação por Grupo (`/avaliacao-admin/alocacao-matriz`) e Alocação por Inscrição (`/avaliacao-admin/alocacao-participante`), diálogo aberto pela lupa ao lado do avaliador

**Fidelidade ao protótipo**: n/a *(o protótipo de Alocação não representa o panorama — conferido em 2026-08-28)*

---

</div>

## Regras de negócio

1. O panorama abrange apenas as avaliações ativas do avaliador na etapa consultada.
2. As avaliações do panorama são agrupadas pelo grupo de alocação — categoria, modalidade e tipo de participante.
3. O panorama identifica o participante pelo nome e pelo protocolo, sem anonimização, por ser uma visão do administrador.
4. O Administrador Regional vê no panorama apenas as avaliações cujas inscrições estão nas unidades federativas às quais está vinculado.
5. Grupo em que o avaliador não tem nenhuma avaliação alocada não aparece no panorama.
6. Cada um dos quatro totais do panorama é apresentado com a quantidade e o percentual sobre as avaliações alocadas do avaliador na etapa.
7. Acionar um dos quatro totais filtra a lista pela situação correspondente.

---

## Cenários

```gherkin
# ← MESSAGE-DICTIONARY: BASELINE

# ── Caminho feliz ──────────────────────────────────────────────

Scenario: Consultar a carga de um avaliador antes de alocar
  Given que estou na alocação de uma etapa e um avaliador aparece na lista
  When abro o panorama desse avaliador
  Then vejo os totais de avaliações alocadas, a iniciar, em andamento e finalizadas
  And vejo essas avaliações separadas por grupo, com o participante e a situação de cada uma

Scenario: Filtrar o panorama por situação
  Given que o panorama do avaliador está aberto
  When filtro pela situação "Em andamento"
  Then a lista passa a mostrar apenas as avaliações nessa situação

# ── Restrições de acesso ───────────────────────────────────────

Scenario: Panorama visto por administrador regional
  Given que estou autenticado como Administrador Regional vinculado à Bahia
  When abro o panorama de um avaliador que também atua em São Paulo
  Then vejo apenas as avaliações de inscrições da Bahia

# ── Estados especiais ──────────────────────────────────────────

Scenario: Avaliador sem avaliações na etapa
  Given que o avaliador ainda não tem avaliações alocadas na etapa
  When abro o panorama
  Then o sistema informa que não há avaliações nesta etapa
```

---

## Colunas do resultado

| Coluna (Label PO) | Origem | Ordenação |
|---|---|---|
| Protocolo | Inscrição | padrão ↑ |
| Participante | Inscrição | ordenável |
| Unidade federativa | Inscrição | ordenável |
| Situação da avaliação | Avaliação de Inscrição | ordenável |
| Finalização da avaliação | Avaliação de Inscrição | ordenável |

---

## Campos

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Etapa | seleção → Etapa da premiação | editável | lista de opções | sim | apenas etapas da premiação em que o avaliador tem alocação; cada opção indica se a etapa está Aberta ou Fechada |
| Situação da avaliação | entrada do usuário | editável | lista de opções | não | filtro por A Iniciar, Em Andamento ou Finalizada |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Avaliações alocadas | quantidade de avaliações ativas do avaliador na etapa, com o respectivo percentual | Ao abrir o panorama |
| A iniciar | quantidade de avaliações ainda não iniciadas, com o respectivo percentual | Ao abrir o panorama |
| Em andamento | quantidade de avaliações iniciadas e não finalizadas, com o respectivo percentual | Ao abrir o panorama |
| Finalizadas | quantidade de avaliações concluídas, com o respectivo percentual | Ao abrir o panorama |
| Avaliações do grupo | quantidade de avaliações do avaliador em cada grupo competitivo | Ao abrir o panorama |

---

## Comportamento de tela

### Onde fica
Diálogo aberto pela lupa ao lado do avaliador, nas telas de Alocação por Grupo (`/avaliacao-admin/alocacao-matriz`) e Alocação por Inscrição (`/avaliacao-admin/alocacao-participante`). O diálogo traz o nome, o e-mail e as unidades federativas de atuação do avaliador, o seletor de etapa — que indica se a etapa está Aberta ou Fechada —, a faixa com os quatro totais em quantidade e percentual e, abaixo, uma seção por grupo competitivo, cada uma com a quantidade de avaliações do grupo e a lista das inscrições. Acionar um total filtra a lista por aquela situação.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Indicador no corpo do diálogo enquanto o panorama é carregado |
| Erro de validação | Não se aplica (não há preenchimento livre) |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Apresenta os totais e as seções por grupo |
| Empty state | Sem avaliações na etapa, exibe "Nenhuma avaliação nesta etapa."; com filtro aplicado, "Nenhuma avaliação com este status nesta etapa." |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | O administrador vê a carga do avaliador na etapa sem sair da tela de alocação | cenário "Consultar a carga de um avaliador antes de alocar" |
| SC-02 | O panorama respeita o escopo de unidades federativas do Administrador Regional | cenário "Panorama visto por administrador regional" |

---

## Métricas de tamanho

> Contagem realizada em 2026-10-02 sobre este N3, para um processo elementar que **não existe no baseline APF** de 2026-02-28 — a capacidade foi pedida em `PDTIC25093-65`, de 2026-08-26, seis meses depois de o baseline ser levantado. A premissa anterior desta seção dizia "sem processo elementar correspondente", o que descrevia a ausência na planilha e não a sua causa. Regras do IFPUG CPM 4.3.1; as convenções de ALR seguem as do próprio baseline (Categoria, Modalidade e Tipo de Participante contam separado; UF vive no ALI Usuário; Etapa, Apuração por Etapa, Fechamento por UF e Desempate são subgrupos dos ALIs Premiação e Avaliação de Inscrição, não arquivos próprios). ⚠️ **Pendente de validação pela equipe de métricas.**

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Consultar Panorama do Avaliador | SE | 8 | 22 | Alta | 7 | 2026-10-04 |

### Memória de cálculo

**Consultar Panorama do Avaliador** — SE. Formas de lógica: 3 (só as avaliações ativas da etapa, regra 1; grupo sem alocação não aparece, regra 5), 4, 7, 8, 9 (os quatro totais são contagens), 11, 12. Intenção primária: apresentar, com dado derivado.
- **ALR (8)**: Alocação Avaliadores *(as alocações do avaliador na etapa)* · Avaliação de Inscrição *(a situação de cada avaliação)* · Inscrição *(o participante e o protocolo, regra 3)* · Premiação *(a Etapa)* · Usuário *(o avaliador, o e-mail, as unidades de atuação e o recorte por UF do Regional, regra 4)* · Categoria · Modalidade · Tipo de Participante *(o grupo de alocação que organiza o panorama, regra 2)*.
- **DER (22)** — entrada (2): Etapa · Situação da avaliação *(filtro, acionado pelo próprio total)*. Saída do avaliador (3): Avaliador · E-mail · Unidades de atuação. Saída do seletor (1): Situação da etapa *(Aberta ou Fechada)*. Saída dos totais (8): Alocadas · Percentual de alocadas · A iniciar · Percentual a iniciar · Em andamento · Percentual em andamento · Finalizadas · Percentual finalizadas. Saída por grupo (2): Grupo competitivo · Avaliações do grupo. Saída da lista (4): Protocolo · Participante · Unidade federativa · Finalização da avaliação. Padrão (2): Mensagem · Ação. Quantidade e percentual contam separado, como no baseline de `AVL-PAI-01` (Acompanhar Painel de Avaliações).
- **Fora da contagem**: a situação da avaliação serve de filtro e de coluna da lista, e conta uma vez; o diálogo abrir a partir de duas telas de alocação diferentes não cria dois processos elementares, porque a lógica de processamento é a mesma.

**Total: 7 PF** (1 processo elementar). A revisão de 2026-10-04 contra o resumo de entrega da Sprint 6 levou o DER de 14 a 22 — entraram os percentuais dos quatro totais, a situação da etapa no seletor, a quantidade por grupo e duas colunas da lista. O PF não se move: com ALR 4 ou mais, as faixas de 6 a 19 e de 20 ou mais DET caem ambas em Alta na tabela de SE.

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Análise de impacto SP06 (docqui) | Colunas conciliadas · memória corrigida | **Inclusão** do que o resumo de entrega da Sprint 6 detalha e a engenharia reversa não tinha visto. *Antes* os quatro totais eram só quantidade, o seletor de etapa não dizia a situação, a lista tinha três colunas e nada registrava o filtro por clique no total. *Agora* cada total traz quantidade **e** percentual (RN6), acionar um total filtra a lista (RN7), o seletor indica Aberta ou Fechada, cada grupo mostra a sua quantidade e a lista traz Protocolo, Participante, UF, Situação e Finalização. +2 regras. DER 14 → 22, **7 PF inalterados** |
| 2026-10-02 | Análise de impacto `PDTIC25093-65` (docqui) | Contagem realizada · origem identificada | Processo elementar contado sobre este N3 — **7 PF** (SE, ALR 8, DER 14), com a memória de cálculo. A premissa de "sem PE correspondente" era efeito, não causa: a capacidade foi pedida em `PDTIC25093-65`, de 2026-08-26, depois do baseline de 2026-02-28. ⚠️ Pendente de validação pela equipe de métricas |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-28 | Conferência doc × código (docqui) | Feature criada | N3 derivado do código (panorama do avaliador por etapa, agrupado por grupo de alocação) — capacidade implementada e até então não especificada |

---

*Feature Set: Alocação · Domínio: Avaliação · Última revisão: 2026-08-28*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
