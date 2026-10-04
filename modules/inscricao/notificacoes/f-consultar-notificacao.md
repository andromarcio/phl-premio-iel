<!-- docqui: 2.23.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: INS-NOT-01
feature_set: INS-NOT
dominio: INS
entidade: Notificação Participante
prioridade: P1
mvp: true
data_model_ref: data-models/inscricao.md#notificacao-participante
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

# Consultar Notificações
> **Nível 3** - Feature Set: Notificações — Domínio: Inscrição - `INS-NOT-01`
> **Prioridade**: P1 · **MVP**: sim

## Descrição
Permite ao participante consultar as próprias notificações sobre o andamento da inscrição e ver quantas ainda não foram lidas.

---

<div class="dev-only">

## Superfície

**Tela própria** — rota *(sem rota própria — painel lateral aberto pelo sino no cabeçalho da área do participante)* (Sino e Painel de Notificações).

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. O participante consulta apenas as próprias notificações, relativas às suas inscrições.
2. A consulta traz as notificações mais recentes do participante, limitadas às últimas quinze.
3. A contagem de não lidas corresponde à quantidade de notificações do participante ainda não lidas.
4. As notificações são geradas automaticamente por eventos das inscrições e da avaliação — solicitação de ajuste, aprovação, rejeição, reenvio e disponibilidade da devolutiva.
5. A notificação de devolutiva disponível leva o participante diretamente à devolutiva da inscrição. → ver `INS-ACO-02` (Visualizar Devolutiva)

---

## Cenários

```gherkin
# ← MESSAGE-DICTIONARY: BASELINE

# ── Caminho feliz ──────────────────────────────────────────────

Scenario: Consultar as notificações mais recentes
  Given que tenho notificações sobre as minhas inscrições
  When abro o painel de notificações
  Then o sistema apresenta as notificações mais recentes com título, mensagem e data
  And o sistema informa a quantidade de notificações não lidas

# ── Estados especiais ──────────────────────────────────────────

Scenario: Limite de notificações apresentadas
  Given que tenho mais de quinze notificações
  When abro o painel de notificações
  Then o sistema apresenta apenas as quinze notificações mais recentes

Scenario: Sem notificações
  Given que ainda não tenho nenhuma notificação
  When abro o painel de notificações
  Then o sistema exibe "Nenhum registro encontrado."
```

---

## Campos

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Participante | contexto de sessão | somente leitura | texto | — | notificações do participante autenticado |

---

## Colunas do resultado

| Coluna (Label PO) | Origem | Ordenação |
|---|---|---|
| Título | Notificação Participante | — |
| Mensagem | Notificação Participante | — |
| Data de envio | Notificação Participante | padrão ↓ (mais recentes primeiro) |
| Lida | Notificação Participante | — |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Contagem de não lidas | Quantidade de notificações do participante ainda não lidas | Ao abrir o painel e a cada leitura |

---

## Comportamento de tela

### Onde fica
Painel lateral aberto pelo sino de notificações no cabeçalho, na rota *(sem rota própria — painel lateral aberto pelo sino no cabeçalho da área do participante)*, com as últimas quinze notificações do participante e a contagem de não lidas no sino.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Exibe "Carregando…" enquanto recupera as notificações |
| Erro de validação | Não se aplica |
| Erro de servidor | Exibe "Não foi possível carregar os dados." |
| Sucesso | Apresenta as notificações; não lidas em destaque e data em formato contextual (hoje: hora; ontem: "Ontem"; demais: dd/MM) |
| Empty state | Participante sem notificações: "Nenhum registro encontrado." |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | O painel apresenta as notificações mais recentes do participante e a contagem de não lidas | cenário "Consultar as notificações mais recentes" |
| SC-02 | São apresentadas no máximo quinze notificações | cenário "Limite de notificações apresentadas" |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Consultar Notificações | SE | 3 | 5 | Simples | 4 | 2026-02-28 |

### Memória de cálculo

- **Consultar Notificações** — ALR (3): Premiação · Inscrição · Notificação Participante. DER (5): Qtd Não Lidas · Titulo · Descrição · Data/Hora · Ação.

```json
{"pe": "Consultar Notificações",
 "alr": ["Premiação", "Inscrição", "Notificação Participante"],
 "der": ["Qtd Não Lidas", "Titulo", "Descrição", "Data/Hora", "Ação"]}
```

**Total: 4 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (1 PE) — migra-enumeracao; sem mudança de número |
| 2026-10-04 | Análise de impacto SP06 (docqui) | Feature alterada | **Inclusão** do destino da notificação de devolutiva. *Antes* a regra 4 dizia que o evento gera notificação e nada dizia sobre o que acontece ao abri-la. *Agora* a RN5 fixa que ela leva direto à devolutiva da inscrição. +1 regra. Sem Δ DER |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-022 |

---

*Feature Set: Notificações · Domínio: Inscrição · Última revisão: 2026-08-27*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
