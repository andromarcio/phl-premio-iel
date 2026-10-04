---
id: AVL-AVA-02
feature_set: AVL-AVA
dominio: AVL
entidade: Aceite do Termo de Confidencialidade
prioridade: P1
mvp: true
data_model_ref: data-models/avaliacao.md#aceite-do-termo-de-confidencialidade
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

# Aceitar Termo de Confidencialidade
> **Nível 3** - Feature Set: Avaliação de Projetos — Domínio: Avaliação - `AVL-AVA-02`
> **Prioridade**: P1 · **MVP**: sim

## Descrição
Permite ao avaliador ler e aceitar o termo de confidencialidade de uma premiação, liberando o acesso aos dados dos participantes; o aceite é registrado uma única vez por avaliador e premiação.

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/avaliacao/premiacao/:premiacaoId/termo` (Aceite do Termo): leitura do termo (texto ou anexo) e confirmação do aceite.

**Fidelidade ao protótipo**: referência — `prototypes/avaliacao/avaliacao-projetos/flow.html`

---

</div>

## Regras de negócio

1. Há no máximo um termo de confidencialidade ativo por premiação, do tipo Texto ou Anexo.
2. O aceite é único por avaliador e premiação, registrado uma única vez, e guarda a data do aceite e o IP de origem.
3. Enquanto o termo ativo da premiação não for aceito, o avaliador não tem acesso aos dados dos participantes daquela premiação.
4. Editar o termo não invalida os aceites já registrados: quem já aceitou não precisa aceitar de novo.
5. Premiação sem termo ativo, ou com termo desativado, não exige aceite e libera o acesso às avaliações.
6. O aceite só é registrado depois que o avaliador confirma a leitura do termo.

---

## Cenários

```gherkin
# ← MESSAGE-DICTIONARY: BASELINE

# ── Caminho feliz ──────────────────────────────────────────────

Scenario: Aceitar o termo da premiação
  Given que a premiação tem termo ativo e confirmo a leitura
  When aceito o termo
  Then o sistema registra o aceite com a data e o IP de origem e libera as avaliações da premiação

# ── Erros de validação ─────────────────────────────────────────

Scenario: Aceitar sem confirmar a leitura
  Given que abro o termo mas não marco a confirmação de leitura
  When tento aceitar
  Then o sistema não registra o aceite e exibe "Confirme a leitura do termo para continuar."
  # ← MESSAGE-DICTIONARY: AVL_ACEITE_CONFIRMACAO_OBRIGATORIA

# ── Estados especiais ──────────────────────────────────────────

Scenario: Premiação sem termo configurado
  Given que a premiação não tem termo ativo
  When acesso as avaliações da premiação
  Then o sistema libera o acesso sem exigir aceite

Scenario: Termo já aceito anteriormente
  Given que já aceitei o termo desta premiação
  When acesso novamente a premiação
  Then o sistema mantém o acesso às avaliações liberado sem solicitar novo aceite
```

---

## Campos

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Li e aceito o termo | entrada do usuário | editável | confirmação | sim | habilita o registro do aceite |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Data do aceite | Data e hora da confirmação | No momento em que o avaliador aceita o termo |
| IP de origem | Endereço de origem do avaliador | No momento do aceite |
| Nome do avaliador | Nome vigente no cadastro corporativo | No momento do aceite |
| Login do avaliador | Login vigente no cadastro corporativo | No momento do aceite |

---

## Comportamento de tela

### Onde fica
Página própria em `/avaliacao/premiacao/:premiacaoId/termo` (Aceite do Termo): o título e o conteúdo do termo (texto exibido para leitura ou anexo para download), a confirmação de leitura e o comando de aceite.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Comando de aceite desabilitado com indicador enquanto grava |
| Erro de validação | Aceite indisponível até a confirmação de leitura ser marcada |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Registra o aceite e conduz às avaliações da premiação |
| Empty state | Não se aplica |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | O aceite é registrado uma única vez por avaliador e premiação, com data e IP de origem | Regra de negócio (HU-029) |
| SC-02 | Enquanto o termo ativo não é aceito, o acesso aos dados dos participantes fica bloqueado | cenário "Aceitar sem confirmar a leitura" e Regra 3 |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Consultar Termos de Aceite por Prêmios | CE | 1 | 3 | Simples | 3 | 2026-02-28 |
| Visualizar Termo de Aceite | CE | 1 | 2 | Simples | 3 | 2026-02-28 |
| Aceitar Termo de Aceite | EE | 1 | 3 | Simples | 3 | 2026-02-28 |

### Memória de cálculo

- **Consultar Termos de Aceite por Prêmios** — ALR (1): Premiação. DER (3): Prêmio · Status Termo · Ação.

```json
{"pe": "Consultar Termos de Aceite por Prêmios",
 "alr": ["Premiação"],
 "der": ["Prêmio", "Status Termo", "Ação"]}
```
- **Visualizar Termo de Aceite** — ALR (1): Premiação. DER (2): Termo de Confidencialidade · Ação.

```json
{"pe": "Visualizar Termo de Aceite",
 "alr": ["Premiação"],
 "der": ["Termo de Confidencialidade", "Ação"]}
```
- **Aceitar Termo de Aceite** — ALR (1): Premiação. DER (3): ID Termo · Ação · Mensagem.

```json
{"pe": "Aceitar Termo de Aceite",
 "alr": ["Premiação"],
 "der": ["ID Termo", "Ação", "Mensagem"]}
```

**Total: 9 PF** (3 processos elementares).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (3 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-02 | Protótipo (docqui) | Vínculo corrigido | A linha dizia **n/a** embora a feature já estivesse desenhada em `prototypes/avaliacao/avaliacao-projetos/flow.html` desde a geração daquele fluxo — o manifesto registrava o vínculo e este N3 não. Fidelidade passa a **referência** |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-029 |

---

*Feature Set: Avaliação de Projetos · Domínio: Avaliação · Última revisão: 2026-08-27*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
