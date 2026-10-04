<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: CFG-EMA-03
feature_set: CFG-EMA
dominio: CFG
entidade: Configuração de E-mail da Premiação
data_model_ref: data-models/configuracao.md#configuracao-de-e-mail-da-premiacao
endpoints: []
error_codes: []
depende_de: []
origem:
  tipo: issue
  chave: HU-021_Configurar_Templates_Email
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

# Visualizar E-mail
> **Nível 3** - Feature Set: Modelos de E-mail — Major Feature Set: Configuração da Premiação - `CFG-EMA-03`

## Descrição
Permite ao administrador pré-visualizar o corpo do e-mail renderizado antes de salvar, conferindo o assunto e a aparência do modelo sem substituir os marcadores dinâmicos.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-021_Configurar_Templates_Email`](../../../hus/HU-021_Configurar_Templates_Email.docx) | Criação | — |

---

<div class="dev-only">

## Superfície

**Tela própria** — modo de pré-visualização do Diálogo de Edição de Modelo (`/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(aba **Termos & E-mails** → diálogo do template)*)

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. A pré-visualização mostra o corpo do e-mail renderizado sem substituir os marcadores dinâmicos pelos valores reais.
2. A pré-visualização é somente conferência: não altera o modelo em edição.

---

## Cenários

```gherkin
Feature: Visualizar E-mail

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Pré-visualizar o e-mail renderizado
    Given que estou editando um modelo de e-mail
    When aciono a pré-visualização
    Then o sistema apresenta o corpo do e-mail renderizado

  Scenario: Voltar da pré-visualização para a edição
    Given que estou na pré-visualização do e-mail
    When saio da pré-visualização
    Then o sistema volta ao modo de edição com o conteúdo preservado

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Marcadores não são substituídos na pré-visualização
    Given que o corpo tem o marcador {{nome_participante}}
    When abro a pré-visualização
    Then o marcador {{nome_participante}} aparece como está, sem substituição
```

---

## Campos

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Assunto | Configuração de E-mail da Premiação | somente leitura | texto | — | — |
| Corpo do e-mail | Configuração de E-mail da Premiação | somente leitura | texto longo | — | apresentado renderizado, com os marcadores visíveis |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| — | — | — |

---

## Comportamento de tela

### Onde fica
Modo de pré-visualização dentro do Diálogo de Edição de Modelo (`/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(aba **Termos & E-mails** → diálogo do template)*): alterna entre editar e ver o corpo renderizado, preservando o conteúdo em edição.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Exibe "Carregando…" enquanto o conteúdo é renderizado |
| Erro de validação | Não se aplica |
| Erro de servidor | Exibe "Não foi possível carregar os dados." |
| Sucesso | Apresenta o corpo do e-mail renderizado com os marcadores visíveis |
| Empty state | Corpo em branco: nada a pré-visualizar |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | A pré-visualização apresenta o corpo renderizado do e-mail | HU-021 (Preview) |
| SC-02 | Os marcadores dinâmicos não são substituídos na pré-visualização | HU-021 (regra de preview) |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Visualizar E-mail | CE | 1 | 10 | Simples | 3 | 2026-02-28 |

### Memória de cálculo

- **Visualizar E-mail** — ALR (1): Premiação. DER (10): Prêmio · Nome do Participante · Titulo da Premiação · Nome da Categoria · Nome da Modalidade · Número do Protocolo · Texto do Ajuste · Texto do Parecer · Nome do Administrador · Ação.

```json
{"pe": "Visualizar E-mail",
 "alr": ["Premiação"],
 "der": ["Prêmio", "Nome do Participante", "Titulo da Premiação", "Nome da Categoria", "Nome da Modalidade", "Número do Protocolo", "Texto do Ajuste", "Texto do Parecer", "Nome do Administrador", "Ação"]}
```

**Total: 3 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Estrutura atualizada | Artefato regenerado com o engine 4.1.0: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, `## Origem` com a HU e os tickets das AIMs, Gherkin com `Feature:` |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (1 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-021 |

---

*Feature Set: Modelos de E-mail · Major Feature Set: Configuração da Premiação · Última revisão: 2026-08-27*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
