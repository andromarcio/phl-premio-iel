---
id: VAL-AJU-01
feature_set: VAL-AJU
dominio: VAL
entidade: Item de Ajuste
prioridade: P1
mvp: true
data_model_ref: data-models/inscricao.md#item-de-ajuste
endpoints: []
error_codes: []
depende_de: [VAL-ANA-02]
estado: rascunho
gates:
  requisitos:   { aprovado: false, por: "", em: "", pr: "" }
  modelo-dados: { aprovado: false, por: "", em: "", pr: "" }
  testes:       { aprovado: false, por: "", em: "", pr: "" }
  codigo:       { aprovado: false, por: "", em: "", pr: "" }
---

# Solicitar Ajuste
> **Nível 3** - Feature Set: Ajustes da Inscrição — Domínio: Validação - `VAL-AJU-01`
> **Prioridade**: P1 · **MVP**: sim

## Descrição
Permite ao validador solicitar ao participante correções na inscrição em validação, reunindo de um a dez itens de ajuste e movendo a inscrição para a situação Aguardando Ajuste.

---

<div class="dev-only">

## Superfície

**Ação em tela** — origem: Detalhe da Inscrição, diálogo de solicitação de ajuste (`/validacao-inscricao/inscricoes/:inscricaoId/detalhe`)

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. A solicitação de ajuste só está disponível para inscrições na situação Em Validação.
2. Cada solicitação contém de 1 a 10 itens de ajuste.
3. Cada item de ajuste tem de 10 a 200 caracteres.
4. Ao confirmar a solicitação, a situação da inscrição passa para Aguardando Ajuste e o participante é notificado por e-mail. ⚠️ *(a notificação usa o modelo de e-mail "Ajuste Solicitado" configurado na premiação — ver CFG-EMA.)*
5. Quando o participante reenvia a inscrição, a situação passa para Ajustes Concluídos.
6. Cada solicitação de ajuste abre uma rodada auditável, preservando o que foi solicitado e o que foi reenviado.
7. A solicitação de ajuste só pode ser feita pelo validador vinculado à unidade federativa da inscrição.

---

## Cenários

```gherkin
# ← MESSAGE-DICTIONARY: BASELINE

# ── Caminho feliz ──────────────────────────────────────────────

Scenario: Solicitar ajustes ao participante
  Given que a inscrição está na situação Em Validação
  When adiciono itens de ajuste válidos e confirmo a solicitação
  Then a inscrição passa para a situação Aguardando Ajuste e o participante é notificado por e-mail

# ── Erros de validação ─────────────────────────────────────────

Scenario: Solicitação sem itens
  Given que não informei nenhum item de ajuste
  When tento confirmar a solicitação
  Then o sistema não envia e exibe "Campo obrigatório."

Scenario: Item de ajuste abaixo do mínimo
  Given que informo um item de ajuste com menos de 10 caracteres
  When tento confirmar a solicitação
  Then o sistema não envia e exibe "Mínimo de 10 caracteres."

Scenario: Item de ajuste acima do máximo
  Given que informo um item de ajuste com mais de 200 caracteres
  When tento confirmar a solicitação
  Then o sistema não envia e exibe "Máximo de 200 caracteres."

# ── Estados especiais ──────────────────────────────────────────

Scenario: Limite de itens por solicitação
  Given que já adicionei dez itens de ajuste
  When tento adicionar mais um item
  Then o sistema não permite ultrapassar dez itens na mesma solicitação

Scenario: Itens pendentes de rodadas anteriores
  Given que há itens de ajuste ainda pendentes de rodadas anteriores
  When abro a solicitação de ajuste
  Then o sistema apresenta os itens ainda pendentes
```

---

## Campos

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Item de ajuste | entrada do usuário | editável | texto longo (lista dinâmica) | sim | de 1 a 10 itens; cada item de 10 a 200 caracteres |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Situação | Aguardando Ajuste | Ao confirmar a solicitação |
| Rodada de ajuste | próxima sequência da inscrição | Ao abrir a solicitação |
| Responsável pela solicitação | validador autenticado | Ao confirmar a solicitação |
| Notificação ao participante | e-mail com o modelo "Ajuste Solicitado" | Ao confirmar a solicitação |

---

## Comportamento de tela

### Onde fica
Ação disparada pelo botão "Solicitar Ajuste" no Detalhe da Inscrição (`/validacao-inscricao/inscricoes/:inscricaoId/detalhe`), visível apenas na situação Em Validação, que abre o diálogo com a lista dinâmica de itens (de 1 a 10, cada um com contador de caracteres) e a lista dos itens pendentes de ciclos anteriores. O botão de adicionar item fica desabilitado ao atingir dez itens.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Botão "Solicitar Ajuste" desabilitado com indicador enquanto a solicitação é enviada |
| Erro de validação | Destaca o item inválido com "Mínimo de 10 caracteres." ou "Máximo de 200 caracteres." |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Atualiza a situação para "Aguardando Ajuste" e fecha o diálogo |
| Empty state | Sem itens adicionados: o envio fica bloqueado até haver ao menos um item |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | Uma solicitação com de 1 a 10 itens válidos move a inscrição para Aguardando Ajuste e notifica o participante | cenário "Solicitar ajustes ao participante" |
| SC-02 | Itens fora do intervalo de 10 a 200 caracteres são impedidos | cenários "Item de ajuste abaixo do mínimo" e "Item de ajuste acima do máximo" |
| SC-03 | Os itens pendentes de rodadas anteriores são apresentados na nova solicitação | cenário "Itens pendentes de rodadas anteriores" |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Solicitar Ajuste | EE | 3 | 5 | Complexo | 6 | 2026-02-28 |

### Memória de cálculo

- **Solicitar Ajuste** — ALR (3): Inscrição · Auditoria de E-mail · Notificação Participante. DER (5): Inscrição · Item de Ajuste · Descrição do Ajuste · Ação · Mensagem.

```json
{"pe": "Solicitar Ajuste",
 "alr": ["Inscrição", "Auditoria de E-mail", "Notificação Participante"],
 "der": ["Inscrição", "Item de Ajuste", "Descrição do Ajuste", "Ação", "Mensagem"]}
```

**Total: 6 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (1 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-019 |

---

*Feature Set: Ajustes da Inscrição · Domínio: Validação · Última revisão: 2026-08-27*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
