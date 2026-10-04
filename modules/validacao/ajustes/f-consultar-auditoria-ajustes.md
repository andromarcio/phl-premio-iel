<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: VAL-AJU-02
feature_set: VAL-AJU
dominio: VAL
entidade: Snapshot da Inscrição
data_model_ref: data-models/inscricao.md#snapshot-da-inscricao
endpoints: []
error_codes: []
depende_de: [VAL-AJU-01]
origem:
  tipo: issue
  chave: HU-026_Auditoria_Ajustes_Inscricao
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

# Consultar Auditoria de Ajustes
> **Nível 3** - Feature Set: Ajustes da Inscrição — Major Feature Set: Validação - `VAL-AJU-02`

## Descrição
Permite ao validador consultar, por rodada de ajuste, o que o participante alterou entre a solicitação e o reenvio da inscrição, agrupado por respostas, documentos e equipe.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-026_Auditoria_Ajustes_Inscricao`](../../../hus/HU-026_Auditoria_Ajustes_Inscricao.docx) | Criação | — |
| [`HU-019_Solicitar_Ajustes_Inscricao`](../../../hus/HU-019_Solicitar_Ajustes_Inscricao.docx) | Criação | — |

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/validacao-inscricao/inscricoes/:inscricaoId/detalhe` (Auditoria de Ajustes, aberta a partir do Detalhe da Inscrição)

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. A auditoria só está disponível quando existe ao menos uma rodada de ajuste fechada — solicitada e reenviada.
2. A auditoria de uma rodada compara o estado da inscrição antes da solicitação e depois do reenvio, classificando cada registro como Inserido, Alterado ou Removido.
3. As alterações são agrupadas por superfície: respostas da inscrição, documentos, equipe e respostas do questionário. ⚠️ *(a HU-019 cita três superfícies — resposta, documento e equipe — e a HU-026 acrescenta as respostas de questão; confirmar o conjunto definitivo.)*
4. Rodadas anteriores à disponibilização da auditoria não possuem captura e ficam indisponíveis para consulta.
5. A auditoria de uma inscrição só é acessível ao validador vinculado à unidade federativa da inscrição.

---

## Cenários

```gherkin
Feature: Consultar Auditoria de Ajustes

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Consultar as alterações de uma rodada
    Given que a inscrição tem uma rodada de ajuste fechada
    When abro a auditoria e seleciono a rodada
    Then o sistema exibe as alterações da rodada com o valor anterior e o valor novo de cada registro

  Scenario: Alternar entre rodadas
    Given que a inscrição tem mais de uma rodada de ajuste fechada
    When seleciono outra rodada
    Then o sistema recalcula e exibe as alterações daquela rodada

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Ocultar registros sem alteração
    Given que estou na auditoria de uma rodada
    When mantenho ativo o filtro "Apenas alterações"
    Then o sistema oculta os registros sem alteração

  Scenario: Rodada sem auditoria disponível
    Given que a rodada é anterior à disponibilização da auditoria
    When tento consultá-la
    Then o sistema indica que a auditoria não está disponível para aquela rodada

  Scenario: Rodada sem alterações no recorte
    Given que nenhuma alteração corresponde ao recorte selecionado
    When consulto a auditoria da rodada
    Then o sistema exibe "Nenhum resultado para a busca."
```

---

## Campos

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Rodada | entrada do usuário | editável | lista (rodadas de ajuste fechadas) | sim | apenas rodadas com solicitação e reenvio |
| Apenas alterações | entrada do usuário | editável | opção (ligado/desligado) | não | padrão ligado; quando ligado, oculta os registros sem alteração |

---

## Colunas do resultado

| Coluna (Label PO) | Origem | Ordenação |
|---|---|---|
| Superfície | derivado (respostas, documentos, equipe, questionário) | agrupador |
| Registro | registro alterado (item afetado) | — |
| Campo | registro alterado (atributo) | — |
| Ação | derivado (Inserido, Alterado, Removido, Sem alteração) | — |
| Valor anterior | Snapshot da Inscrição (antes do reenvio) | — |
| Valor novo | Snapshot da Inscrição (depois do reenvio) | — |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Data da solicitação | data e hora do pedido de ajuste da rodada | Ao selecionar a rodada |
| Data do reenvio | data e hora do reenvio da inscrição na rodada | Ao selecionar a rodada |
| Total de alterações | soma das inserções, alterações e remoções da rodada | Ao selecionar a rodada |

---

## Comportamento de tela

### Onde fica
Popup de Auditoria de Ajustes aberto a partir do Detalhe da Inscrição (`/validacao-inscricao/inscricoes/:inscricaoId/detalhe`) — pelo botão "Ver auditoria de ajustes" ou por uma rodada na linha do tempo do histórico. Exibe o seletor de rodada, as datas de solicitação e reenvio, o total de alterações, o filtro "Apenas alterações" e a lista de alterações agrupada por superfície, com o valor anterior e o novo de cada registro.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Exibe "Carregando…" enquanto as alterações da rodada são recuperadas |
| Erro de validação | Não se aplica (seleção de rodada e filtro) |
| Erro de servidor | Exibe "Não foi possível carregar os dados." |
| Sucesso | Exibe as alterações da rodada selecionada |
| Empty state | Rodada sem captura: indica que a auditoria não está disponível; recorte sem alterações: "Nenhum resultado para a busca." |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | A auditoria de uma rodada exibe cada alteração com o valor anterior e o valor novo | cenário "Consultar as alterações de uma rodada" |
| SC-02 | O filtro "Apenas alterações" oculta os registros sem alteração | cenário "Ocultar registros sem alteração" |
| SC-03 | Rodadas sem captura ficam indisponíveis para consulta | cenário "Rodada sem auditoria disponível" |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Consultar Auditoria de Ajustes | SE | 2 | 13 | Médio | 5 | 2026-02-28 |

### Memória de cálculo

- **Consultar Auditoria de Ajustes** — ALR (2): Inscrição · Tipo de Participante. DER (13): Rodada · Apenas alterações · Data solicitação · Data reenvio · Qtd alterações · Tipo de alteração · Qtd alteração por tipo · Status alteração · Item alterado · Valor anterior · Valor atual · Ação · Mensagem.

```json
{"pe": "Consultar Auditoria de Ajustes",
 "alr": ["Inscrição", "Tipo de Participante"],
 "der": ["Rodada", "Apenas alterações", "Data solicitação", "Data reenvio", "Qtd alterações", "Tipo de alteração", "Qtd alteração por tipo", "Status alteração", "Item alterado", "Valor anterior", "Valor atual", "Ação", "Mensagem"]}
```

**Total: 5 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Estrutura atualizada | Artefato regenerado com o engine 4.1.0: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, `## Origem` com a HU e os tickets das AIMs, Gherkin com `Feature:` |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (1 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado das HU-019 e HU-026 |

---

*Feature Set: Ajustes da Inscrição · Major Feature Set: Validação · Última revisão: 2026-08-27*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
