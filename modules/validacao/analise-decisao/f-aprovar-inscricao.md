<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: VAL-ANA-03
feature_set: VAL-ANA
dominio: VAL
entidade: Validação de Inscrição
data_model_ref: data-models/validacao.md#validacao-de-inscricao
endpoints: []
error_codes: []
depende_de: [VAL-ANA-01, VAL-ANA-02]
origem:
  tipo: issue
  chave: HU-018_Analisar_Validar_Inscricao
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

# Aprovar Inscrição
> **Nível 3** - Feature Set: Análise e Decisão — Major Feature Set: Validação - `VAL-ANA-03`

## Descrição
Permite ao validador concluir a validação aprovando a inscrição, com parecer opcional, de modo que ela passe à situação Validada e siga para a etapa de avaliação.

No Detalhe da Inscrição, o validador aciona "Aprovar", escreve o parecer no Diálogo de Validação — que mostra também o resumo dos itens de ajuste conferidos — e confirma; se restarem itens não conferidos, o sistema pede confirmação antes de concluir.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-018_Analisar_Validar_Inscricao`](../../../hus/HU-018_Analisar_Validar_Inscricao.docx) | Criação | — botão "Aprovar" e Diálogo de Validação com o parecer, o resumo dos itens de ajuste conferidos e a pergunta de confirmação quando há itens não conferidos; a inscrição passa a Validada |

---

<div class="dev-only">

## Superfície

**Ação em tela** — origem: Diálogo de Validação, a partir do Detalhe da Inscrição (`/validacao-inscricao/inscricoes/:inscricaoId/detalhe`)

**Fidelidade ao protótipo**: referência — `prototypes/validacao/analise-decisao/flow.html`

---

</div>

## Regras de negócio

1. A aprovação está disponível para inscrições nas situações Em Validação, Aguardando Ajuste e Ajustes Concluídos.
2. Ao aprovar, a situação da inscrição passa para Validada e a inscrição segue para a etapa de avaliação.
3. O parecer é obrigatório na aprovação e deve ter no mínimo 10 caracteres. ✅ *(conflito resolvido na conferência com o código, 2026-08-28: prevalece a regra do Diálogo de Validação da HU-026. ⚠️ A exigência está apenas na tela — o servidor aceita a aprovação sem parecer; ver `global/CONFORMIDADE-CODIGO.md` § 3.1.)*
4. A aprovação é registrada com o responsável, a data e o parecer.
5. A inscrição só pode ser aprovada pelo validador vinculado à unidade federativa da inscrição.

---

## Cenários

```gherkin
Feature: Aprovar Inscrição

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Aprovar a inscrição com parecer
    Given que a inscrição está na situação Em Validação
    When aprovo a inscrição informando um parecer
    Then a inscrição passa para a situação Validada e segue para a etapa de avaliação
    And o participante é avisado da aprovação no painel de acompanhamento e por e-mail

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Aprovar inscrição que voltou de ajuste
    Given que a inscrição está na situação Ajustes Concluídos
    When aprovo a inscrição informando um parecer
    Then a inscrição passa para a situação Validada e segue para a etapa de avaliação

  Scenario: Aprovar com itens de ajuste não conferidos
    Given que existem itens de ajuste ainda não conferidos
    When aprovo a inscrição
    Then o sistema solicita confirmação antes de concluir a aprovação

  # ── Restrições de situação ─────────────────────────────────────

  Scenario: Aprovar inscrição ainda não assumida
    Given que a inscrição está na situação Finalizada
    When tento aprovar a inscrição
    Then o sistema não permite aprovar antes de iniciar a validação

  # ── Erros de validação ─────────────────────────────────────────

  Scenario: Aprovar com parecer curto demais
    Given que a inscrição está na situação Em Validação
    When aprovo a inscrição com um parecer de menos de 10 caracteres
    Then o sistema aponta o parecer como inválido e não conclui a aprovação
```

---

## Campos

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Parecer | Validação de Inscrição | entrada do usuário | editável | texto longo | sim | mínimo de 10 caracteres |
| Situação | Inscrição | exibido do cadastro | somente leitura, atualizada pela ação | lista (Em Validação · Aguardando Ajuste · Ajustes Concluídos → Validada) | — | ação disponível nas três situações de origem |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Situação | Validada | Ao aprovar a inscrição |
| Usuário validador | validador autenticado | Ao aprovar a inscrição |
| Data da validação | data e hora da decisão | Ao aprovar a inscrição |

---

## Dados lidos e gravados

| Entidade | Papel | Por que a feature a toca |
|---|---|---|
| Item de Ajuste | lê | O diálogo resume os itens de ajuste conferidos e pede confirmação quando há itens não conferidos (cenário "Aprovar com itens de ajuste não conferidos"; DER do baseline) |
| Auditoria de E-mail | grava | O participante é avisado da aprovação por e-mail, que entra na fila de envio auditada (cenário "Aprovar a inscrição com parecer"; ALR do baseline) |
| Notificação Participante | grava | O participante é avisado da aprovação no painel de acompanhamento (cenário "Aprovar a inscrição com parecer"; ALR do baseline) |

---

## Comportamento de tela

### Onde fica
Ação disparada pelo botão "Aprovar" no Detalhe da Inscrição (`/validacao-inscricao/inscricoes/:inscricaoId/detalhe`), que abre o Diálogo de Validação com o campo de parecer e o resumo dos itens de ajuste conferidos. O botão fica disponível apenas quando a inscrição está na situação Em Validação.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Botão "Aprovar" desabilitado com indicador enquanto a decisão é registrada |
| Erro de validação | Parecer com menos de 10 caracteres bloqueia a confirmação e exibe a mensagem de campo inválido |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Atualiza a situação para "Validada" e retorna ao detalhe com o veredito |
| Empty state | Não se aplica |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | Uma inscrição Em Validação passa para Validada ao ser aprovada | cenário "Aprovar a inscrição com parecer" |
| SC-02 | Uma inscrição em Ajustes Concluídos também pode ser aprovada | cenário "Aprovar inscrição que voltou de ajuste" |
| SC-03 | Itens de ajuste não conferidos exigem confirmação antes de aprovar | cenário "Aprovar com itens de ajuste não conferidos" |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Papel | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| Aprovar Inscrição | principal | EE | 3 | 7 | Complexo | 6 | 2026-02-28 |

> No baseline, o processo elementar se chama *Aceitar / Rejeitar Inscrição* e cobre também a rejeição — `VAL-ANA-04` Rejeitar Inscrição não tem linha própria (correspondência **compartilhado** em `global/SIZING.md`); aqui leva o nome da feature, como pede o `global/SIZING.md` para o `principal`. O número é o do baseline.

### Memória de cálculo

**Aprovar Inscrição** — EE · ALR 3 · DER 7 · Complexo · 6 PF

```json
{"pe": "Aprovar Inscrição",
 "alr": ["Inscrição", "Auditoria de E-mail", "Notificação Participante"],
 "der": ["Total de itens para ajustes", "Total de itens conferidos", "Numero item", "Descrição item", "Parecer da aprovação", "Ação", "Mensagem"]}
```

Por que cada ALR:
1. `Inscrição` — a transação confere a situação de origem, grava a situação Validada e lê os itens de ajuste que o diálogo resume (subgrupo do mesmo arquivo lógico)
2. `Auditoria de E-mail` — registra o e-mail de aprovação enviado ao participante
3. `Notificação Participante` — grava o aviso da aprovação no painel do participante

⚠️ O parecer, o validador e a data da decisão são gravados na Validação de Inscrição (coluna Entidade de `## Campos`), arquivo que a planilha não enumera. Ficou o número da planilha; a divergência vai à equipe de métricas.

**Total: 6 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0. Estrutura: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, Gherkin com `Feature:`. Redação: segundo parágrafo da Descrição (como se usa), critérios da HU na `## Origem` (a HU não numera critérios: `—` e a prosa do que a feature realiza), coluna Entidade em `## Campos` (o Preenchimento, que trazia o nome da entidade, passa a `exibido do cadastro`), `## Dados lidos e gravados`, coluna Papel e memória de cálculo em bloco JSON, com o processo elementar principal levando o nome da feature (no baseline, *Aceitar / Rejeitar Inscrição*) e o porquê de cada ALR. Sem mudança de regra, cenário ou número de PF |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (1 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-02 | Protótipo (docqui) | Vínculo corrigido | A linha dizia **n/a** embora a feature já estivesse desenhada em `prototypes/validacao/analise-decisao/flow.html` desde a geração daquele fluxo — o manifesto registrava o vínculo e este N3 não. Fidelidade passa a **referência** |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-28 | Conferência doc × código (docqui) | Regras corrigidas | Situações de origem passam a incluir Aguardando Ajuste e Ajustes Concluídos; parecer passa a obrigatório (10 caracteres), resolvendo o conflito com a HU-026; rota da tela corrigida |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-018 |

---

*Feature Set: Análise e Decisão · Major Feature Set: Validação · Última revisão: 2026-10-04*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
