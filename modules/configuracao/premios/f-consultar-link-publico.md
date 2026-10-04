<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: CFG-PRE-08
feature_set: CFG-PRE
dominio: CFG
entidade: Link Público
data_model_ref: data-models/configuracao.md#link-publico
endpoints: []
error_codes: []
depende_de: []
origem:
  tipo: issue
  chave: HU-002_Cadastrar_Premios
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

# Consultar Links Públicos
> **Nível 3** - Feature Set: Prêmios — Major Feature Set: Configuração da Premiação - `CFG-PRE-08`

## Descrição
Permite ao administrador visualizar os links públicos de inscrição já emitidos de uma edição, com o respectivo tipo de participante e endereço.

No Formulário do Prêmio em modo de edição, o administrador aciona "Links Públicos" e vê a relação dos links já emitidos, cada um com o tipo de participante, o endereço e o botão de cópia.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-002_Cadastrar_Premios`](../../../hus/HU-002_Cadastrar_Premios.docx) | Criação | `CA-5` — relação dos links emitidos com o endereço completo e botão de cópia funcional |

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(aba **Dados** → botão “Links Públicos”)* (Links Públicos de Inscrição)

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. A consulta abrange os links públicos já emitidos da edição.
2. Cada link listado corresponde a um único tipo de participante da edição.

---

## Cenários

```gherkin
Feature: Consultar Links Públicos

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Listar os links emitidos da edição
    Given que a edição já tem links públicos emitidos
    When acesso os Links Públicos da edição
    Then o sistema exibe os links com o tipo de participante e o endereço de cada um

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Edição ainda sem links emitidos
    Given que a edição ainda não tem nenhum link público emitido
    When acesso os Links Públicos da edição
    Then o sistema exibe "Nenhum registro encontrado."
```

---

## Campos

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Prêmio | Premiação | exibido do cadastro | somente leitura | seleção → Premiação | sim | edição em contexto na tela, cujos links públicos são consultados |

---

## Colunas do resultado

| Coluna (Label PO) | Origem | Ordenação |
|---|---|---|
| Tipo de participante | Link Público (via Tipo de Participante) | padrão ↑ |
| Endereço do link público | Link Público | — |
| Data de criação do link | Link Público | ordenável |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| — | — | — |

---

## Dados lidos e gravados

| Entidade | Papel | Por que a feature a toca |
|---|---|---|
| Link Público | lê | Os links já emitidos da edição, com o endereço e a data de criação (regra 1) |
| Tipo de Participante | lê | O nome do tipo de participante de cada link, na coluna *Tipo de participante* (regra 2) |

---

## Comportamento de tela

### Onde fica
Tela Links Públicos de Inscrição (`/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(aba **Dados** → botão “Links Públicos”)*): apresenta a relação dos links já emitidos da edição, cada um com o tipo de participante, o endereço e um botão de cópia para a área de transferência.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Exibe "Carregando…" enquanto os links são recuperados |
| Erro de validação | Não se aplica |
| Erro de servidor | Exibe "Não foi possível carregar os dados." |
| Sucesso | Exibe a relação dos links emitidos da edição |
| Empty state | Sem links emitidos: "Nenhum registro encontrado." |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | A tela relaciona os links públicos emitidos da edição com tipo de participante e endereço | cenário "Listar os links emitidos da edição" |
| SC-02 | Uma edição sem links emitidos apresenta o estado vazio, sem erro | cenário "Edição ainda sem links emitidos" |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Papel | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| Consultar Links Públicos | principal | CE | 1 | 3 | Simples | 3 | 2026-02-28 |

> No baseline, o processo elementar se chama *Consultar Links Públicos de Inscrição*; aqui leva o nome da feature, como pede o `global/SIZING.md` para o `principal`. O número é o do baseline.

### Memória de cálculo

**Consultar Links Públicos** — CE · ALR 1 · DER 3 · Simples · 3 PF

```json
{"pe": "Consultar Links Públicos",
 "alr": ["Premiação"],
 "der": ["Tipo de Participante", "URL", "Ação"],
 "nao_contados": "Tipo de Participante (nome do tipo em cada link) e a coluna Data de criação do link — a planilha não os conta"}
```

Por que cada ALR:
1. `Premiação` — os links ficam na edição (subgrupo Link Público), de onde a relação é lida

⚠️ A coluna *Tipo de participante* traz o nome do tipo, que pertence ao arquivo lógico `Tipo de Participante`, e a coluna *Data de criação do link* aparece no resultado sem DER correspondente; a planilha conta ALR 1 e DER 3. Ficou o número da planilha; a divergência vai à equipe de métricas junto com o questionamento do baseline.

**Total: 3 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0. Estrutura: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, Gherkin com `Feature:`. Redação: segundo parágrafo da Descrição (como se usa), critério `CA-n` da HU na `## Origem`, coluna Entidade em `## Campos`, `## Dados lidos e gravados`, coluna Papel e memória de cálculo em bloco JSON, com o processo elementar principal levando o nome da feature e um ⚠️ com as divergências da planilha. Sem mudança de regra, cenário ou número de PF |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (1 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-002 |

---

*Feature Set: Prêmios · Major Feature Set: Configuração da Premiação · Última revisão: 2026-10-04*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
