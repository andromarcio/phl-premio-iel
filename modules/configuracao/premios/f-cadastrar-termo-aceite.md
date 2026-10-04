---
id: CFG-PRE-09
feature_set: CFG-PRE
dominio: CFG
entidade: Termo de Aceite
prioridade: P1
mvp: true
data_model_ref: data-models/configuracao.md#termo-de-aceite
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

# Cadastrar Termo de Aceite
> **Nível 3** - Feature Set: Prêmios — Domínio: Configuração da Premiação - `CFG-PRE-09`
> **Prioridade**: P1 · **MVP**: sim

## Descrição
Permite ao administrador registrar um termo de aceite da edição com título e texto, podendo marcá-lo como obrigatório para concluir a inscrição.

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(nó Premiação → aba **Termos & E-mails**)* (Termos de Aceite do Prêmio)

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. Um termo de aceite pertence a uma única edição da premiação.
2. Um termo marcado como obrigatório precisa ser aceito pelo participante para que a inscrição seja concluída.

---

## Cenários

```gherkin
# ← MESSAGE-DICTIONARY: BASELINE

# ── Caminho feliz ──────────────────────────────────────────────

Scenario: Adicionar um termo de aceite
  Given que estou nos Termos de Aceite de uma edição em modo de edição
  When informo o título, o texto e a marcação de obrigatório e salvo
  Then o sistema registra o termo e exibe "Registro salvo com sucesso."
  And o termo passa a constar na relação de termos da edição

# ── Erros de validação ─────────────────────────────────────────

Scenario: Título em branco
  Given que estou registrando um termo de aceite
  When deixo o campo Título em branco e clico em "Salvar"
  Then o sistema não registra e exibe "Campo obrigatório."

Scenario: Título acima do limite
  Given que informo um título com mais de 500 caracteres
  When clico em "Salvar"
  Then o sistema não registra e exibe "Máximo de 500 caracteres."
```

---

## Campos

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Título | entrada do usuário | editável | texto | sim | máximo de 500 caracteres |
| Texto do termo | entrada do usuário | editável | texto longo | não | conteúdo apresentado ao participante para aceite |
| Obrigatório | entrada do usuário | editável | booleano (Sim/Não) | não | quando Sim, o aceite é exigido para concluir a inscrição |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Versão | 1 | Na criação do termo |
| Obrigatório | Sim | Quando não informado ⚠️ *(data-model: default Sim; a HU-002 indica default Não — a confirmar)* |

---

## Comportamento de tela

### Onde fica
Diálogo "Adicionar Termo" na tela Termos de Aceite do Prêmio (`/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(nó Premiação → aba **Termos & E-mails**)*): campos Título, Texto (com editor de texto rico) e a marcação de obrigatório; ao salvar, o termo entra na relação de termos da edição.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Botão "Salvar" desabilitado com indicador enquanto grava |
| Erro de validação | Destaca o campo Título com "Campo obrigatório." |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Exibe "Registro salvo com sucesso." e atualiza a relação de termos |
| Empty state | Não se aplica |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | Um termo com título válido é registrado e passa a constar na relação da edição | cenário "Adicionar um termo de aceite" |
| SC-02 | Um termo marcado como obrigatório é exigido do participante para concluir a inscrição | Regra de negócio 5 (HU-002) |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Listar Termos de Aceite | CE | 1 | 5 | Simples | 3 | 2026-02-28 |
| Incluir Termo de Aceite | EE | 1 | 5 | Simples | 3 | 2026-02-28 |

### Memória de cálculo

- **Listar Termos de Aceite** — ALR (1): Premiação. DER (5): Titulo · Obrigatório · Versão · Ação · Mensagem.

```json
{"pe": "Listar Termos de Aceite",
 "alr": ["Premiação"],
 "der": ["Titulo", "Obrigatório", "Versão", "Ação", "Mensagem"]}
```
- **Incluir Termo de Aceite** — ALR (1): Premiação. DER (5): Titulo · Obrigatório · Texto · Ação · Mensagem.

```json
{"pe": "Incluir Termo de Aceite",
 "alr": ["Premiação"],
 "der": ["Titulo", "Obrigatório", "Texto", "Ação", "Mensagem"]}
```

**Total: 6 PF** (2 processos elementares).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (2 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-002 |

---

*Feature Set: Prêmios · Domínio: Configuração da Premiação · Última revisão: 2026-08-27*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
