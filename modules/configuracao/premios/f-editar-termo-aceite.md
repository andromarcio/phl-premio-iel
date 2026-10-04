---
id: CFG-PRE-10
feature_set: CFG-PRE
dominio: CFG
entidade: Termo de Aceite
prioridade: P2
mvp: false
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

# Editar Termo de Aceite
> **Nível 3** - Feature Set: Prêmios — Domínio: Configuração da Premiação - `CFG-PRE-10`
> **Prioridade**: P2 · **MVP**: não

## Descrição
Permite ao administrador alterar o título, o texto ou a obrigatoriedade de um termo de aceite já registrado na edição.

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(nó Premiação → aba **Termos & E-mails**)* (Termos de Aceite do Prêmio)

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. A edição de um termo preserva o vínculo com a mesma edição da premiação.
2. Um termo marcado como obrigatório precisa ser aceito pelo participante para que a inscrição seja concluída.

---

## Cenários

```gherkin
# ← MESSAGE-DICTIONARY: BASELINE

# ── Caminho feliz ──────────────────────────────────────────────

Scenario: Alterar o texto de um termo
  Given que selecionei um termo de aceite existente
  When altero o texto e clico em "Salvar"
  Then o sistema grava as alterações e exibe "Registro salvo com sucesso."

Scenario: Alterar a obrigatoriedade de um termo
  Given que selecionei um termo de aceite existente
  When altero a marcação de obrigatório e salvo
  Then o sistema grava a nova marcação de obrigatoriedade do termo

# ── Erros de validação ─────────────────────────────────────────

Scenario: Título apagado na edição
  Given que estou editando um termo de aceite
  When apago o campo Título e clico em "Salvar"
  Then o sistema não grava e exibe "Campo obrigatório."
```

---

## Campos

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Título | entrada do usuário | editável | texto | sim | máximo de 500 caracteres |
| Texto do termo | entrada do usuário | editável | texto longo | não | conteúdo apresentado ao participante para aceite |
| Obrigatório | entrada do usuário | editável | booleano (Sim/Não) | não | quando Sim, o aceite é exigido para concluir a inscrição |
| Prêmio | — | imutável | seleção → Premiação | — | não pode ser alterado após a criação |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Versão | Incrementada a cada alteração | Ao gravar a edição do termo ⚠️ *(a confirmar se a edição gera nova versão)* |

---

## Comportamento de tela

### Onde fica
Diálogo de edição do termo na tela Termos de Aceite do Prêmio (`/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(nó Premiação → aba **Termos & E-mails**)*), com os mesmos campos do cadastro (Título, Texto com editor rico e a marcação de obrigatório); o prêmio de origem aparece como somente leitura.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Botão "Salvar" desabilitado com indicador enquanto grava |
| Erro de validação | Destaca o campo Título com "Campo obrigatório." |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Exibe "Registro salvo com sucesso." |
| Empty state | Não se aplica |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | As alterações de título, texto e obrigatoriedade de um termo são persistidas | cenário "Alterar o texto de um termo" |
| SC-02 | A obrigatoriedade do termo pode ser alternada e é gravada | cenário "Alterar a obrigatoriedade de um termo" |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Consultar Termo de Aceite (implícita) | CE | 1 | 4 | Simples | 3 | 2026-02-28 |
| Editar Termo de Aceite | EE | 1 | 5 | Simples | 3 | 2026-02-28 |

### Memória de cálculo

- **Consultar Termo de Aceite (implícita)** — ALR (1): Premiação. DER (4): Titulo · Obrigatório · Texto · Ação.

```json
{"pe": "Consultar Termo de Aceite (implícita)",
 "alr": ["Premiação"],
 "der": ["Titulo", "Obrigatório", "Texto", "Ação"]}
```
- **Editar Termo de Aceite** — ALR (1): Premiação. DER (5): Titulo · Obrigatório · Texto · Ação · Mensagem.

```json
{"pe": "Editar Termo de Aceite",
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
